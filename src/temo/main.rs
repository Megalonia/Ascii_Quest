use rltk::{GameState, Rltk, Point};
use specs::prelude::*;

mod components;
mod player;
mod map;
mod rect;
mod vision;
mod mob_ai;
mod map_indexing;
mod melee_combat;
mod damage;
mod gui;
mod logs;
mod spawner;
mod inventory;

pub use components::*;
use player::*;
pub use map::*;
pub use rect::Rectangle;
use vision::VisionSystem;
use mob_ai::MobAI;
use map_indexing::MapIndexingSystem;
use melee_combat::MeleeCombatSystem;
use damage::DamageSystem;
use inventory::{ItemCollectionSystem, ItemUseSystem, ItemDropSystem};


#[derive(PartialEq, Copy, Clone)]
pub enum RunState {
    AwaitingInput,
    PreRun,
    PlayerTurn,
    MonsterTurn,
    ShowInventory,
    ShowDropItem,
    ShowTargeting { range : i32, item : Entity} 
}

pub struct State {
    pub ecs: World
}

impl State {
    fn run_systems(&mut self) {
        let mut vis = VisionSystem{};
        vis.run_now(&self.ecs);
        let mut mob = MobAI{};
        mob.run_now(&self.ecs);
        let mut mapindex = MapIndexingSystem{};
        mapindex.run_now(&self.ecs);
        let mut melee = MeleeCombatSystem{};
        melee.run_now(&self.ecs);
        let mut damage = DamageSystem{};
        damage.run_now(&self.ecs);
        let mut pickup = ItemCollectionSystem{};
        pickup.run_now(&self.ecs);
        let mut itemuse = ItemUseSystem{};
        potion.run_now(&self.ecs);
        let mut drop_items = ItemDropSystem{};
        drop_items.run_now(&self.ecs);
        self.ecs.maintain();
    }
}

impl GameState for State {
    fn tick(&mut self, ctx : &mut Rltk) {
        ctx.cls();
        
        draw_map(&self.ecs, ctx);

        {
            let positions = self.ecs.read_storage::<Position>();
            let renderables = self.ecs.read_storage::<Renderable>();
            let map = self.ecs.fetch::<Map>();

            let mut data = (&positions, &renderables).join().collect::<Vec<_>>();
            data.sort_by(|&a, &b| b.1.render_order.cmp(&a.1.render_order) );
            for (pos, render) in data.iter() {
                let idx = map.xy_idx(pos.x, pos.y);
                if map.visible_tiles[idx] { ctx.set(pos.x, pos.y, render.fg, render.bg, render.glyph) }
            }

            gui::draw_ui(&self.ecs, ctx); 
        }

        let mut new_run_state; 
        {
            let runstate = self.ecs.fetch::<RunState>();  
            new_run_state = *runstate;
        }

        match new_run_state {
            RunState::PreRun => {
                self.run_systems(); 
                self.ecs.maintain();
                new_run_state = RunState::AwaitingInput;
            } 
            RunState::AwaitingInput => {
                new_run_state = player_input(self, ctx); 
            }
            RunState::PlayerTurn => {
                self.run_systems(); 
                self.ecs.maintain();
                new_run_state = RunState::MonsterTurn;
            }
            RunState::MonsterTurn => {
                self.run_systems(); 
                self.ecs.maintain();
                new_run_state = RunState::AwaitingInput;
            }
            RunState::ShowInventory => {
                let result = gui::show_inventory(self, ctx);
                match result.0 {
                    gui::ItemMenuResult::Cancel => new_run_state = RunState::AwaitingInput,
                    gui::ItemMenuResult::NoResponse => {}
                    gui::ItemMenuResult::Selected => {
                        let item_entity = result.1.unwrap();
                        let is_ranged = self.ecs.read_storage::<Ranged>();
                        let is_item_ranged = is_ranged.get(item_entity)
                         if let Some(is_item_ranged) = is_item_ranged {
                            newrunstate = RunState::ShowTargeting{ range: is_item_ranged.range, item: item_entity };
                        } else {
                                let mut intent = self.ecs.write_storage::<WantsToUseItem>();
                            intent.insert(*self.ecs.fetch::<Entity>(), WantsToUseItem{ item: item_entity, target: None }).expect("Unable to insert intent");
                        new_run_state = RunState::PlayerTurn;
                    }
                }
            }
            RunState::ShowDropItem => {
                let result = gui::drop_item_menu(self, ctx);
                match result.0 {
                    gui::ItemMenuResult::Cancel => new_run_state = RunState::AwaitingInput,
                    gui::ItemMenuResult::NoResponse => {}
                    gui::ItemMenuResult::Selected => {
                        let item_entity = result.1.unwrap();
                        let mut intent = self.ecs.write_storage::<WantsToDropItem>();
                        intent.insert(*self.ecs.fetch::<Entity>(), WantsToDropItem {item: item_entity}).expect("Unable to insert intent");
                        new_run_state = RunState::PlayerTurn;
                    }
                }
 
            }

            RunState::ShowTargeting{range, item} => {
                let result = gui::ranged_target(self, ctx, range);
                match result.0 {
                    gui::ItemMenuResult::Cancel => newrunstate = RunState::AwaitingInput,
                    gui::ItemMenuResult::NoResponse => {}
                    gui::ItemMenuResult::Selected => {
                        let mut intent = self.ecs.write_storage::<WantsToUseItem>();
                        intent.insert(*self.ecs.fetch::<Entity>(), WantsToUseItem{ item, target: result.1 }).expect("Unable to insert intent");
                        newrunstate = RunState::PlayerTurn;
                    }
                }
            }
        }

        {
            let mut runwriter = self.ecs.write_resource::<RunState>(); 
            *runwriter = new_run_state;
        }
        damage::delete_dead(&mut self.ecs);

    }
}



fn main() -> rltk::BError {
    use rltk::RltkBuilder;
    let mut context = RltkBuilder::simple80x50()
        .with_title("ASCII QUEST")
        .build()?;
    context.with_post_scanlines(true);
    let mut game_state = State {
        ecs: World::new(),
    };
    game_state.ecs.register::<Position>();
    game_state.ecs.register::<Renderable>();
    game_state.ecs.register::<Player>();
    game_state.ecs.register::<Vision>();
    game_state.ecs.register::<Monster>();
    game_state.ecs.register::<Name>();
    game_state.ecs.register::<BlocksTile>();
    game_state.ecs.register::<Stats>();
    game_state.ecs.register::<WantsToMelee>();
    game_state.ecs.register::<SufferDamage>();
    game_state.ecs.register::<Item>();
    game_state.ecs.register::<ProvideHealing>();
    game_state.ecs.register::<InflictsDamage>();
    game_state.ecs.register::<AreaOfEffect>();
    game_state.ecs.register::<Consumable>();
    game_state.ecs.register::<Ranged>();
    game_state.ecs.register::<InBackpack>();
    game_state.ecs.register::<WantsToPickupItem>();
    game_state.ecs.register::<WantsToUseItem>();
    game_state.ecs.register::<WantsToDropItem>();
    game_state.ecs.register::<Confusion>();

    let map = Map::rooms_and_corridors();
    let (player_x, player_y) = map.rooms[0].center();

    let player_entity = spawner::player(&mut game_state.ecs, player_x, player_y);
    game_state.ecs.insert(rltk::RandomNumberGenerator::new());

    for room in map.rooms.iter().skip(1) {
        spawner::spawn_room(&mut game_state.ecs,room);
    }
    game_state.ecs.insert(map);
    game_state.ecs.insert(Point::new(player_x, player_y));
    game_state.ecs.insert(player_entity);
    game_state.ecs.insert(RunState::PreRun);
    game_state.ecs.insert(logs::GameLog{ entries: vec!["Welcome to Ascii Quest".to_string(),
                                                      "An acrid smell fills your nostrils".to_string()]});


    rltk::main_loop(context, game_state)
}

