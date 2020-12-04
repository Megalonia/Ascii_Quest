use rltk::{RGB, RandomNumberGenerator};
use specs::prelude::*;
use super::{Stats, Player, Renderable, Name, Position, Vision, Monster, BlocksTile,Rectangle, map::MAPWIDTH, Item, Consumable, ProvidesHealing};

const MAX_MOBS: i32 = 4;
const MAX_ITEMS: i32 = 2;


fn health_pots(ecs: &mut World, x: i32, y: i32) {
    ecs
    .create_entity()
    .with(Position{ x:x, y:y})
    .with(Renderable {
         symbol: rltk::to_cp437('¡'),
         fg: RGB::named(rltk::YELLOW),
         bg: RGB::from_f32(51.0, 0.0,25.0),
         render_order: 2
    })
    .with(Name{ name: "Health Pot".to_string()})
    .with(Item{})
    .with(Consumable{})
    .with(ProvidesHealing{ heals: 8})
    .build();

}

fn magic_missile_scroll(ecs: &mut World, x: i32, y: i32) {
    ecs.create_entity()
        .with(Position{ x, y })
        .with(Renderable{
            glyph: rltk::to_cp437(')'),
            fg: RGB::named(rltk::CYAN),
            bg: RGB::from_f32(51.0,0.0,25.0),
            render_order: 2
        })
        .with(Name{ name : "Magic Missile Scroll".to_string() })
        .with(Item{})
        .with(Consumable{})
        .with(Ranged{ range: 6 })
        .with(InflictsDamage{ damage: 20 })
        .build();
}

fn fireball_scroll(ecs: &mut World, x: i32, y: i32) {
    ecs.create_entity()
        .with(Position{ x, y })
        .with(Renderable{
            glyph: rltk::to_cp437(')'),
            fg: RGB::named(rltk::ORANGE),
            bg: RGB::from_f32(51.0,0.0,25.0),
            render_order: 2
        })
        .with(Name{ name : "Fireball Scroll".to_string() })
        .with(Item{})
        .with(Consumable{})
        .with(Ranged{ range: 6 })
        .with(InflictsDamage{ damage: 20 })
        .with(AreaOfEffect{ radius: 3 })
        .build();
}

fn confusion_scroll(ecs: &mut World, x: i32, y: i32) {
    ecs.create_entity()
        .with(Position{ x, y })
        .with(Renderable{
            glyph: rltk::to_cp437(')'),
            fg: RGB::named(rltk::PINK),
            bg: RGB::from_f32(51.0,0.0,25.0),
            render_order: 2
        })
        .with(Name{ name : "Confusion Scroll".to_string() })
        .with(Item{})
        .with(Consumable{})
        .with(Ranged{ range: 6 })
        .with(Confusion{ turns: 4 })
        .build();
}

pub fn player(ecs: &mut World, player_x: i32, player_y: i32) -> Entity {
    ecs
    .create_entity()
    .with(Position { x: player_x, y: player_y})
    .with(Renderable {
         symbol: rltk::to_cp437('@'),
         fg: RGB::named(rltk::YELLOW),
         bg: RGB::from_f32(51.0, 0.0,25.0),
         render_order: 0
    })
   .with(Player{})
   .with(Vision{ visible_tiles: Vec::new(), range: 8, dirty: true})
   .with(Name{name: "Player".to_string()})
   .with(Stats{max_hp: 30, hp: 30, defense: 2, power: 5})
   .build()
}

pub fn random_monster(ecs: &mut World, x: i32, y: i32) {
    let roll: i32;
    {
        let mut rng = ecs.write_resource::<RandomNumberGenerator>(); 
        roll = rng.roll_dice(1,2)
    }
    match roll {
        _ => {snake(ecs,x,y)}
    }
}

fn slime(ecs: &mut World, x: i32, y: i32) { monster(ecs,x,y, rltk::to_cp437('o'), "slime");}
fn snake(ecs: &mut World, x: i32, y: i32) { monster(ecs,x,y, rltk::to_cp437('s'), "snake");}

fn monster<S : ToString>(ecs: &mut World, x: i32, y: i32, glyph : rltk::FontCharType, name: S) {
    ecs.create_entity()
    .with(Position{ x, y })
    .with(Renderable{
        symbol: glyph,
        fg: RGB::named(rltk::BLUE),
        bg: RGB::from_f32(51.0, 0.0,25.0),
        render_order: 1
     })
     .with(Vision{ visible_tiles : Vec::new(), range: 8, dirty: true })
     .with(Monster{})
     .with(Name{ name: name.to_string()})
     .with(Stats{max_hp: 8, hp: 8, defense: 1, power: 3})
     .with(BlocksTile{})
     .build();
}

pub fn spawn_room(ecs: &mut World, room: &Rectangle) {
    let mut monster_spawn_points : Vec<usize> = Vec::new();
    let mut item_spawn_points: Vec<usize> = Vec::new();

    {
        let mut rng = ecs.write_resource::<RandomNumberGenerator>(); 
        let num_monster = rng.roll_dice(1,MAX_MOBS+2)-3;
        let num_items = rng.roll_dice(1, MAX_ITEMS+2)-3;

        for _i in 0 .. num_monster {
            let mut added = false; 
            while !added {
                let x = (room.x1 + rng.roll_dice(1, i32::abs(room.x2 - room.x1))) as usize; 
                let y = (room.y1 + rng.roll_dice(1, i32::abs(room.y2 - room.y1))) as usize; 
                let idx = (y * MAPWIDTH) + x;
                if !monster_spawn_points.contains(&idx) {
                   monster_spawn_points.push(idx);  
                   added = true;
                }
            }
        }

        for _i in 0 .. num_items {
            let mut added = false; 
            while !added {
                let x = (room.x1 + rng.roll_dice(1, i32::abs(room.x2 - room.x1))) as usize; 
                let y = (room.y1 + rng.roll_dice(1, i32::abs(room.y2 - room.y1))) as usize; 
                let idx = (y * MAPWIDTH) + x;
                if !item_spawn_points.contains(&idx) {
                   item_spawn_points.push(idx);  
                   added = true;
                }
            }
 
        }
    }

    for idx in monster_spawn_points.iter() {
        let x = *idx % MAPWIDTH; 
        let y = *idx / MAPWIDTH;
        random_monster(ecs, x as i32, y as i32);
    }

    for idx in item_spawn_points.iter() {
        let x = *idx % MAPWIDTH; 
        let y = *idx / MAPWIDTH; 
        random_item(ecs, x as i32, y as i32);

    }
}

fn random_item(ecs: &mut World, x: i32, y: i32) {
    let roll :i32;
    {
        let mut rng = ecs.write_resource::<RandomNumberGenerator>();
        roll = rng.roll_dice(1, 4);
    }
    match roll {
        1 => { health_potion(ecs, x, y) }
        2 => { fireball_scroll(ecs, x, y) }
        3 => { confusion_scroll(ecs, x, y) }
        _ => { magic_missile_scroll(ecs, x, y) }
    }
}
