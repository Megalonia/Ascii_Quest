use specs::prelude::*;
use super::{Vision, Position, Map, Player};
use rltk::{field_of_view, Point};

pub struct VisionSystem {}

impl<'a> System<'a> for VisionSystem {
    type SystemData = ( WriteExpect<'a, Map>,
                        Entities<'a>,
                        WriteStorage<'a, Vision>,
                        WriteStorage<'a, Position>,
                        ReadStorage<'a, Player>);

    fn run(&mut self, data : Self::SystemData) {
        let (mut map, entities, mut vis, pos,player) = data;

        for(ent,vis,pos) in (&entities, &mut vis, &pos).join() {

            if vis.dirty {
                vis.dirty = false;
                vis.visible_tiles.clear();
                vis.visible_tiles = field_of_view(Point::new(pos.x,pos.y), vis.range,&*map);
                vis.visible_tiles.retain(|p| p.x >= 0 && p.x < map.width && p.y >= 0 && p.y < map.height);

                let _p : Option<&Player> = player.get(ent);
                if let Some(_p) = _p {
                    for t in map.visible_tiles.iter_mut() {
                        *t = false 
                    };
                    for v in vis.visible_tiles.iter() {
                        let idx = map.find_xy_index(v.x, v.y);
                        map.revealed_tiles[idx] = true;
                        map.visible_tiles[idx] = true;
                    }
                }

            }
        }
    }
}
