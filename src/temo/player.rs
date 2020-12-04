use rltk::{VirtualKeyCode, Rltk,Point};
use specs::prelude::*;
use super::{Position, Player, State, Map, Vision, RunState, Stats, WantsToMelee,Item,logs::GameLog,WantsToPickupItem};
use std::cmp::{min, max};

pub fn move_player(delta_x: i32, delta_y: i32, ecs: &mut World) {
    let mut positions = ecs.write_storage::<Position>();
    let mut players   = ecs.write_storage::<Player>();
    let mut vision    = ecs.write_storage::<Vision>();
    let mut wants_to_melee = ecs.write_storage::<WantsToMelee>();
    let combat_stats  = ecs.read_storage::<Stats>();
    let map           = ecs.fetch::<Map>();
    let entities      = ecs.entities();

    for (entity,_player, pos, vis) in (&entities, &mut players, &mut positions, &mut vision).join() {
        if pos.x + delta_x < 1 || pos.x + delta_x > map.width-1 || pos.y + delta_y < 1 || pos.y + delta_y > map.height-1 { return; }

        let destination_idx = map.find_xy_index(pos.x + delta_x, pos.y + delta_y);
        for potential_target in map.tile_content[destination_idx].iter() {
            let target = combat_stats.get(*potential_target);
            if let Some(_target) = target {
                wants_to_melee.insert(entity, WantsToMelee{ target: *potential_target}).expect("Add target failed");
                return;
            }
        }
        if !map.blocked[destination_idx]{
            pos.x = min(79 , max(0, pos.x + delta_x));
            pos.y = min(49, max(0, pos.y + delta_y));
            
            vis.dirty = true;
            let mut ppos = ecs.write_resource::<Point>();
            ppos.x = pos.x;
            ppos.y = pos.y;
        }
    }
}

pub fn player_input(game_state: &mut State, ctx: &mut Rltk) -> RunState {

    // Player movement
    match ctx.key {
        None => {return RunState::AwaitingInput}
        Some(key) => match key {
            //Cardinal
            VirtualKeyCode::Left  => move_player(-1, 0, &mut game_state.ecs),
            VirtualKeyCode::Right => move_player(1, 0, &mut game_state.ecs),
            VirtualKeyCode::Up    => move_player(0, -1, &mut game_state.ecs),
            VirtualKeyCode::Down  => move_player(0, 1, &mut game_state.ecs),

            //Diagonals
            VirtualKeyCode::Q => move_player(-1, -1, &mut game_state.ecs),
            VirtualKeyCode::E => move_player(1, -1, &mut game_state.ecs),
            VirtualKeyCode::A => move_player(-1, 1, &mut game_state.ecs),
            VirtualKeyCode::D => move_player(1, 1, &mut game_state.ecs),
            //Pick Up Item
            VirtualKeyCode::G => get_item(&mut game_state.ecs),
            //Open Inventory
            VirtualKeyCode::I => return RunState::ShowInventory,
            //Drop Item
            VirtualKeyCode::T => return RunState::ShowDropItem,
            _ => {return RunState::AwaitingInput}
        },
    }
    RunState::PlayerTurn
}

fn get_item(ecs: &mut World) {
    let player_pos = ecs.fetch::<Point>();
    let player_entity = ecs.fetch::<Entity>();
    let entities = ecs.entities();
    let items = ecs.read_storage::<Item>();
    let positions = ecs.read_storage::<Position>();
    let mut gamelog = ecs.fetch_mut::<GameLog>();

    let mut target_item : Option<Entity> = None;
    for (item_entity, _item, position) in (&entities, &items, &positions).join() {
        if position.x == player_pos.x && position.y == player_pos.y {
            target_item = Some(item_entity);
        }
    }

    match target_item {
        None => gamelog.entries.push("There is nothing here to pick up.".to_string()),
        Some(item) => {
            let mut pickup = ecs.write_storage::<WantsToPickupItem>();
            pickup.insert(*player_entity, WantsToPickupItem{ collected_by: *player_entity, item }).expect("Unable to insert want to pickup");
        }
    }
}
