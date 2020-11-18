use rltk::{VirtualKeyCode, Rltk,Point};
use specs::prelude::*;
use super::{Position, Player, State, TileType, Map, Vision, RunState};
use std::cmp::{min, max};

pub fn move_player(delta_x: i32, delta_y: i32, ecs: &mut World) {
    let mut positions = ecs.write_storage::<Position>();
    let mut players = ecs.write_storage::<Player>();
    let mut vision = ecs.write_storage::<Vision>();
    let map = ecs.fetch::<Map>();

    for (_player, pos, vis) in (&mut players, &mut positions, &mut vision).join() {
        let destination_idx = map.find_xy_index(pos.x + delta_x, pos.y + delta_y);
        if map.tiles[destination_idx] != TileType::Wall {
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
        None => {return RunState::Paused} // Nothing happened
        Some(key) => match key {
            VirtualKeyCode::Left => move_player(-1, 0, &mut game_state.ecs),
            VirtualKeyCode::Right => move_player(1, 0, &mut game_state.ecs),
            VirtualKeyCode::Up => move_player(0, -1, &mut game_state.ecs),
            VirtualKeyCode::Down => move_player(0, 1, &mut game_state.ecs),
            _ => {return RunState::Paused}
        },
    }
    RunState::Running
}
