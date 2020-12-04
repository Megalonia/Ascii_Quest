use specs::prelude::*;
use super::{Stats, WantsToMelee, Name, SufferDamage, logs};

pub struct MeleeCombatSystem {}

impl<'a> System<'a> for MeleeCombatSystem {
    type SystemData = ( Entities<'a>,
                        WriteExpect<'a,logs::GameLog>,
                        WriteStorage<'a, WantsToMelee>,
                        ReadStorage<'a, Name>,
                        ReadStorage<'a, Stats>,
                        WriteStorage<'a, SufferDamage>
                      );
    fn run(&mut self, data : Self::SystemData) {
        let (entities, mut log, mut wants_melee, names, stats, mut damage) = data;   

        for(_entity, wants_melee, name, stat) in (&entities, &wants_melee, &names, &stats).join() {
            if stat.hp > 0 {
                let target_stats = stats.get(wants_melee.target).unwrap();
                if target_stats.hp > 0 {
                    let target_name = names.get(wants_melee.target).unwrap(); 
                    let dmg = i32::max(0, stat.power - target_stats.defense);

                    if dmg == 0 {
                        log.entries.push(format!("{} is unable to hurt {}",&name.name, &target_name.name));
                    } else {
                        log.entries.push(format!("{} hits {} for {} hp.", &name.name, &target_name.name, dmg));
                        SufferDamage::new_damage(&mut damage, wants_melee.target, dmg);
                    }
                }
            } 
        }

        wants_melee.clear()
    }
}
