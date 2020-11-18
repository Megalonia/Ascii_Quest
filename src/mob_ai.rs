use specs::prelude::*;
use super::{Vision, Monster};
use rltk::{console,Point};

pub struct MobAI {}

impl<'a> System<'a> for MobAI {
    type SystemData = ( ReadStorage<'a, Vision>, 
                        ReadExpect<'a, Point>,
                        ReadStorage<'a, Monster>);

    fn run(&mut self, data : Self::SystemData) {
        let (vis, player_pos, monster) = data;

        for (_vis,_monster) in (&vis,&monster).join() {
            if _vis.visible_tiles.contains(&*player_pos) {
                console::log("Monster considers their own existence");
            }
        }
    }
}
