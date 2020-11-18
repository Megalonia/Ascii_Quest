use rltk::{GameState, Rltk, RGB, Point};
use specs::prelude::*;

mod components;
mod player;
mod map;
mod rect;
mod vision;
mod mob_ai;

pub use components::*;
use player::*;
pub use map::*;
pub use rect::Rectangle;
use vision::VisionSystem;
use mob_ai::MobAI;


#[derive(PartialEq, Copy, Clone)]
pub enum RunState { Paused, Running }

pub struct State {
    pub ecs: World,
    pub runstate: RunState
}

impl State {
    fn run_systems(&mut self) {
        let mut vis = VisionSystem{};
        vis.run_now(&self.ecs);
        let mut mob = MobAI{};
        mob.run_now(&self.ecs);
        self.ecs.maintain();
    }
}

impl GameState for State {
    fn tick(&mut self, ctx : &mut Rltk) {
        ctx.cls();
        
        if self.runstate == RunState::Running {
            self.run_systems();
            self.runstate = RunState::Paused;
        } else {
            self.runstate = player_input(self, ctx);
        }
        //DRAW MAP
        draw_map(&self.ecs, ctx);

        //WHERE ARE ENTITIES
        let positions = self.ecs.read_storage::<Position>();
        let renderables = self.ecs.read_storage::<Renderable>();
        let map = self.ecs.fetch::<Map>();

        for (pos, render) in (&positions, &renderables).join() {
            let idx = map.find_xy_index(pos.x, pos.y);
            if map.visible_tiles[idx]{
                ctx.set(pos.x, pos.y, render.fg, render.bg, render.symbol);
            }
        }
                
    }
}



fn main() -> rltk::BError {
    use rltk::RltkBuilder;
    let context = RltkBuilder::simple80x50()
        .with_title("ASCII QUEST")
        .build()?;
    let mut game_state = State {
        ecs: World::new(),
        runstate: RunState::Running
    };
    game_state.ecs.register::<Position>();
    game_state.ecs.register::<Renderable>();
    game_state.ecs.register::<Player>();
    game_state.ecs.register::<Vision>();
    game_state.ecs.register::<Monster>();

    let map = Map::rooms_and_corridors();
    let (player_x, player_y) = map.rooms[0].center();

    game_state.ecs
        .create_entity()
        .with(Position { x: player_x, y: player_y})
        .with(Renderable {
            symbol: rltk::to_cp437('@'),
            fg: RGB::named(rltk::YELLOW),
            bg: RGB::named(rltk::BLACK),
        })
        .with(Player{})
        .with(Vision{ visible_tiles: Vec::new(), range: 8, dirty: true})
        .build();

    let mut rng = rltk::RandomNumberGenerator::new();
    for room in map.rooms.iter().skip(1) {
        let (x,y) = room.center();

        let glyph : rltk::FontCharType;
        let roll = rng.roll_dice(1, 2);
        match roll {
            1 => { glyph = rltk::to_cp437('S') }
            _ => { glyph = rltk::to_cp437('s') }
         }
        game_state.ecs.create_entity()
            .with(Position{ x, y })
            .with(Renderable{
                symbol: glyph,
                fg: RGB::named(rltk::GREEN),
                bg: RGB::named(rltk::BLACK),
            })
            .with(Vision{ visible_tiles : Vec::new(), range: 8, dirty: true })
            .with(Monster{})
                                                                    
           .build();
}

    game_state.ecs.insert(map);
    game_state.ecs.insert(Point::new(player_x, player_y));

    rltk::main_loop(context, game_state)
}

