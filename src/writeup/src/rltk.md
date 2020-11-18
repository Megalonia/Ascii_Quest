# ASCII QUEST

## Getting Started With Rust

### Getting Rust
On most platforms going to <https://rustup.rs> will get you on the latest working toolchain. Once it is installed, verify by typing ```cargo -version``` or ```rustup -V``` in command line. 

### Creating a project
Rust had a built-in package manager called ```cargo```. Cargo can make project templates for you, To create a new project, type ```cargo init PROJECT_NAME_HERE ```. 

It will create a directory with the following: 
```
src\main.rs \\ Contains a simple "Hello, World!" program
Cargo.toml  \\ Manifest file that defines project
.gitignore 
```

### Setting up Cargo.toml
To use libraries we must include them in the dependecies section of our toml. Rust makes it very easy to add and adjust dependecies. Our section will like like this for now:
```toml
[dependencies]
rltk = { version = "0.8.0" }
```

### Hello World in RLTK
in```main.rs``` we will write the following
```rs
use rltk::{GameState, Rltk};
// Structure to hold the many game states
struct State {}

// Implements the 'GameState' for states ***REQUIRED TO MAKE A GAME*** 
impl GameState for State {

    // Function for game iteration
    fn tick(&mut self, ctx : &mut Rltk) {
        // Clear the screen
        ctx.cls();
        //print hello rust world at 1,1
        ctx.print(1, 1, "Hello Rust World");
    }
}

 
fn main() -> rltk::BError {
    use rltk::RltkBuilder;
    // make a 80x50 terminal
    let game_context = RltkBuilder::simple80x50()
        //title terminal ASCII Quest
        .with_title("ASCII QUEST")
        .build()?;
    //Copy State struct
    let game_state = State{ };
    rltk::main_loop(game_context, game_state)
}
```
Use ```cargo run``` to build and run project to get the following:


## Entities and Components
Object oriented design  is very common in game development; However, Object-orieted design does have a downside, it can become confusing when the game begins to expand and more complicated objects are added. Entity Component based design tries to eliminate the hierarchy, and instead implement a set of "components" that describe what you want. We will be using the specs lib to provide ECS(Entity Compnent Systems) design.
```toml
[dependencies]
rltk = { version = "0.8.0" }
specs = "0.16.1"
specs-derive = "0.4.
```

## Defining Position
A basic part of the game is to define ```position```, so our entites know wherethey are. It will simple just have the X-Y coordinates for position on screen.

```rs
#[derive(Component)]
struct Position {
    x: i32,
    y: i32,
}
```
```#[derive(Component)]``` provides boilerplate for our data

## Define Renderable
A second part our entites need is the ability to display them. What character represents them, and what color they should be. We create the ```Renderable``` component as follows:

```rs
#[derive(Component)]
struct Renderable {
    symbol: rltk::FontCharType,
    fg: RGB,
    bg: RGB,
}
```
We will represent the character, the foreground and background color of the entity.

## The World

So we have two basic parts, but no where to put them. Specs provides a way to register our custom components at start up with a 'World' type. The World entity will be defined in a State struct

```rs
struct State {
    ecs: World
}
```
In ```main.rs``` we will add our world
```rs
let mut game_state = State 
    ecs: World::new()
};
```
Now we register our components to the World:

```rs
game_state.ecs.register::<Position>();
game_state.ecs.register::<Renderable>()
```

## The Player
Now we've got a World that knows how to store position and renderable components. In order to use them they need to be attached to something in the game. We will define the player as : 

```rs 
game_state.ecs
          .create_entity()
          .with(Position { x: 40, y: 25 })
          .with(Renderable {
                symbol: rltk::to_cp437('@'),
                fg: RGB::named(rltk::YELLOW),
                bg: RGB::named(rltk::BLACK),
           })
    .build();
```
This tell our World that we want a new entity. The position is the middle of the terminal, with an @ symbol in yellow on black.

### Updating Tick
Now that we have an entity lets do something with that data. In our ```tick``` function, we replace our hello world code with the following:
```rs
let positions = self.ecs.read_storage::<Position>();
let renderables = self.ecs.read_storage::<Renderable>();

for (pos, render) in (&positions, &renderables).join() {
    ctx.set(pos.x, pos.y, render.fg, render.bg, render.glyph);
}
```
This accesses the position and renderable components and sets entities. Running it with ```cargo run`` give the following:

INSERT IMAGE

### Moving the Player
Let's make the player move with keyboard controls. First we need to add a new component for the player:
```rs
#[derive(Component, Debug)]
struct Player {}
```
and add it to the entity:
```
game_state.ecs
    .create_entity()
    .with(Position { x: 40, y: 25 })
    .with(Renderable {
        symbol: rltk::to_cp437('@'),
        fg: RGB::named(rltk::YELLOW),
        bg: RGB::named(rltk::BLACK),
    })
    .with(Player{})
    .build()
```
Now we implement the move\_player and player\_input function:
```rs
fn move_player(delta_x: i32, delta_y: i32, ecs: &mut World) {
    let mut positions = ecs.write_storage::<Position>();
    let mut players = ecs.write_storage::<Player>();

    for (_player, pos) in (&mut players, &mut positions).join() {
        pos.x = min(79 , max(0, pos.x + delta_x));
        pos.y = min(49, max(0, pos.y + delta_y));
    }
}

fn player_input(game_state: &mut State, ctx: &mut Rltk) {
    // Player movement
    match ctx.key {
        None => {} // Nothing happened
        Some(key) => match key {
            VirtualKeyCode::Left  => move_player(-1, 0, &mut game_state.ecs),
            VirtualKeyCode::Right => move_player(1, 0, &mut game_state.ecs),
            VirtualKeyCode::Up    => move_player(0, -1, &mut game_state.ecs),
            VirtualKeyCode::Down  => move_player(0, 1, &mut game_state.ecs),
            _ => {}
        },
    }
}
```
add player\_input to tick and run.

## Making a Map
A Roguelike without a map to explore is a bit pointless, so we'll put together a basic map, draw it, and let the player walk around it.

### Defining the map parts
We'll start by allowing two tile types: walls and floors.
```rs
#[derive(PartialEq, Copy, Clone)]
enum TileType {
    Wall, Floor
}
``` 
### Building a Map
We'll make a function that returns a vector of tiles, representing the map. Which means we need a way to figure out which index is at the given X-Y position. Thus we make the find_xy_index function:

```rs
pub fn find_xy_index(x: i32, y: i32) -> usize {
    (y as usize * 80) + x as usize
}
```
Multiplies the y position by the map width (80), and adds x. This guarantees one tile per location, and efficiently maps it in memory for left-to-right reading.

Now we will write a constructor to make the make

```rs
fn new_map() -> Vec<TileType> {
    let mut map = vec![TileType::Floor; 80*50];

    // Make the boundaries walls
    for x in 0..80 {
        map[find_xy_index(x, 0)] = TileType::Wall;
        map[find_xy_index(x, 49)] = TileType::Wall;
    }
    for y in 0..50 {
        map[find_xy_index(0, y)] = TileType::Wall;
        map[find_xy_index(79, y)] = TileType::Wall;
    }

    // Now we'll randomly splat a bunch of walls. It won't be pretty, but it's a decent illustration.
    // First, obtain the thread-local RNG:
    let mut rng = rltk::RandomNumberGenerator::new();

    for _i in 0..400 {
        let x = rng.roll_dice(1, 79);
        let y = rng.roll_dice(1, 49);
        let idx = find_xy_index(x, y);
        if idx != find_xy_index(40, 25) {
            map[idx] = TileType::Wall;
        }
    }

    map
}
```
In main, we will add our randomly generated map to the World:
```rs
game_state.ecs.insert(new_map());
```
### Draw the map

Now we have a map, we need to put it on the screen. We'll make a function called ```draw_map```:

```rs
fn draw_map(map: &[TileType], ctx : &mut Rltk) {
    let mut y = 0;
    let mut x = 0;
    for tile in map.iter() {
        // Render a tile depending upon the tile type
        match tile {
            TileType::Floor => {
                ctx.set(x, y, RGB::from_f32(0.5, 0.5, 0.5), RGB::from_f32(0., 0., 0.), rltk::to_cp437('.'));
            }
            TileType::Wall => {
                ctx.set(x, y, RGB::from_f32(0.0, 1.0, 0.0), RGB::from_f32(0., 0., 0.), rltk::to_cp437('#'));
            }
        }

        // Move the coordinates
        x += 1;
        if x > 79 {
            x = 0;
            y += 1;
        }
    }
}
```

### Collision
With the current code the player can walk through walls. So, we need to modifiy ```move_player``` function to check if the distination is open:

```rs
fn move_player(delta_x: i32, delta_y: i32, ecs: &mut World) {
    let mut positions = ecs.write_storage::<Position>();
    let mut players = ecs.write_storage::<Player>();
    let map = ecs.fetch::<Vec<TileType>>();

    for (_player, pos) in (&mut players, &mut positions).join() {
        let destination_idx = find_xy_index(pos.x + delta_x, pos.y + delta_y);
        if map[destination_idx] != TileType::Wall {
            pos.x = min(79 , max(0, pos.x + delta_x));
            pos.y = min(49, max(0, pos.y + delta_y));
        }
    }
}
```
Now when the program is ran the walls are solid.

## Making a better map.
We'll start off by making a new function to make rooms and corridors.

```rs
pub fn rooms_and_corridors() -> Vec<TileType> {
    let mut map = vec![TileType::Wall; 80*50];
    map
}
```
This functions fills the whole map with wall(which is the first step in our algorithm). The second step in the algorithm is making use of a custom ```Rectangle``` type.  
```rs
pub struct Rectangle {
    pub x1 : i32,
    pub x2 : i32,
    pub y1 : i32,
    pub y2 : i32
}

impl Rectangle {
    pub fn new(x:i32, y: i32, w:i32, h:i32) -> Rectangle {
        Rectangle{x1:x, y1:y, x2:x+w, y2:y+h}
    }

    // Returns true if this overlaps with other
    pub fn intersect(&self, other:&Rectangle) -> bool {
        self.x1 <= other.x2 && self.x2 >= other.x1 && self.y1 <= other.y2 && self.y2 >= other.y1
    }

    pub fn center(&self) -> (i32, i32) {
        ((self.x1 + self.x2)/2, (self.y1 + self.y2)/2)
    }
}
```
We also need to make a new function to apply rooms to a map:

```rs
fn add_room_to_map(room : &Rect, map: &mut [TileType]) {
    for y in room.y1 +1 ..= room.y2 {
        for x in room.x1 + 1 ..= room.x2 {
            map[find_xy_index(x, y)] = TileType::Floor;
        }
    }
}
```
With this new code, we can create a new ```Rectangle``` and add it to the map as floors with ```add_room_to_map```.


## Corridors
We need to connect our rooms together, so we will create two funtion to connect the rooms vertically and horizontally.

```rs

fn add_horizontal_tunnel(map: &mut [TileType], x1:i32, x2:i32, y:i32) {
    for x in min(x1,x2) ..= max(x1,x2) {
        let idx = find_xy_index(x, y);
        if idx > 0 && idx < 80*50 {
            map[idx as usize] = TileType::Floor;
        }
    }
}

fn add_vertical_tunnel(map: &mut [TileType], y1:i32, y2:i32, x:i32) {
    for y in min(y1,y2) ..= max(y1,y2) {
        let idx = find_xy_index(x, y);
        if idx > 0 && idx < 80*50 {
            map[idx as usize] = TileType::Floor;
        }
    }
}
```
Now we have all the parts to make a simple dungeon.

## Putting it together

Now we can make a randomly generated dungeon. with the following changes to ```rooms_and_corridors```:
```rs
pub fn rooms_and_corridors() -> (Vec<Rect>,Vec<TileType>)  {

    let mut map = vec![TileType::Wall; 80*50];

    let mut rooms : Vec<Rect> = Vec::new();
    const MAX_ROOMS : i32 = 30;
    const MIN_SIZE : i32 = 6;
    const MAX_SIZE : i32 = 10;

    let mut rng = RandomNumberGenerator::new();

    for _ in 0..MAX_ROOMS {
        let w = rng.range(MIN_SIZE, MAX_SIZE);
        let h = rng.range(MIN_SIZE, MAX_SIZE);
        let x = rng.roll_dice(1, 80 - w - 1) - 1;
        let y = rng.roll_dice(1, 50 - h - 1) - 1;
        let new_room = Rect::new(x, y, w, h);
        let mut ok = true;
        for other_room in rooms.iter() {
            if new_room.intersect(other_room) { ok = false }
        }
        if ok {
            add_room_to_map(&new_room, &mut map);

            if !rooms.is_empty() {
                 let (new_x, new_y) = new_room.center();
                 let (prev_x, prev_y) = rooms[rooms.len()-1].center();
                 if rng.range(0,2) == 1 {
                    add_horizontal_tunnel(&mut map, prev_x, new_x, prev_y);
                    add_vertical_tunnel(&mut map, prev_y, new_y, new_x);
                 } else {
                    add_vertical_tunnel(&mut map, prev_y, new_y, prev_x);
                    add_horizontal_tunnel(&mut map, prev_x, new_x, new_y);
                 }
            }

            rooms.push(new_room);
        }
    }


    (rooms, map)

}
```
What this does is builds rooms with random hight and width, placing the rooms randomly s.t x and y are greater than 0 and less than the max map size minus one, we iterate through existing rooms, rejecting new rooms if they overlap with old rooms. Then we look at our rooms and join rooms if they exist.

## Add it to main
Our main.rs file also requires adjustments, to accept the new format. We change our main function

```rs
fn main() -> rltk::BError {                                                    
    use rltk::RltkBuilder;
    let context = RltkBuilder::simple80x50()
        .with_title("ASCII QUEST")
        .build()?;
    let mut game_state = State {
        ecs: World::new()
    };
    game_state.ecs.register::<Position>();
    game_state.ecs.register::<Renderable>();
    game_state.ecs.register::<Player>();

    let (rooms, map) = rooms_and_corridors();
    game_state.ecs.insert(map);
    let (player_x, player_y) = rooms[0].center();

     game_state.ecs
        .create_entity()
        .with(Position { x: player_x, y: player_y})
        .with(Renderable {
            symbol: rltk::to_cp437('@'),
            fg: RGB::named(rltk::YELLOW),
            bg: RGB::named(rltk::BLACK),
        })
        .with(Player{})
        .build();


    rltk::main_loop(context, game_state)
}
```

## More map updates
Want to create a map struture to help keep things clear.

```rs

impl Map {
    pub fn find_xy_index(&self, x: i32, y: i32) -> usize {
        (y as usize * self.width as usize) + x as usize
    }

    fn add_room_to_map(&mut self, room : &Rectangle) {
        for y in room.y1 +1 ..= room.y2 {
            for x in room.x1 + 1 ..= room.x2 {
                let idx = self.find_xy_index(x, y);
                self.tiles[idx] = TileType::Floor;
            }
        }
    }

    fn add_horizontal_tunnel(&mut self, x1:i32, x2:i32, y:i32) {
        for x in min(x1,x2) ..= max(x1,x2) {
            let idx = self.find_xy_index(x, y);
            if idx > 0 && idx < self.width as usize * self.height as usize {
                self.tiles[idx as usize] = TileType::Floor;
            }
        }
    }

    fn add_vertical_tunnel(&mut self, y1:i32, y2:i32, x:i32) {
        for y in min(y1,y2) ..= max(y1,y2) {
            let idx = self.find_xy_index(x, y);
            if idx > 0 && idx < self.width as usize * self.height as usize {
                self.tiles[idx as usize] = TileType::Floor;
            }
        }
    }

    pub fn rooms_and_corridors() -> Map {
        let mut map = Map{
            tiles : vec![TileType::Wall; 80*50],
            rooms : Vec::new(),
            width : 80,
            height: 50
        };

        const MAX_ROOMS : i32 = 30;
        const MIN_SIZE : i32 = 6;
        const MAX_SIZE : i32 = 10;

        let mut rng = RandomNumberGenerator::new();

        for i in 0..MAX_ROOMS {
            let w = rng.range(MIN_SIZE, MAX_SIZE);
            let h = rng.range(MIN_SIZE, MAX_SIZE);
            let x = rng.roll_dice(1, map.width - w - 1) - 1;
            let y = rng.roll_dice(1, map.height - h - 1) - 1;
            let new_room = Rectangle::new(x, y, w, h);
            let mut ok = true;
            for other_room in map.rooms.iter() {
                if new_room.intersect(other_room) { ok = false }
            }
            if ok {
                map.add_room_to_map(&new_room);

                if !map.rooms.is_empty() {
                    let (new_x, new_y) = new_room.center();
                    let (prev_x, prev_y) = map.rooms[map.rooms.len()-1].center();
                    if rng.range(0,2) == 1 {
                        map.add_horizontal_tunnel(prev_x, new_x, prev_y);
                        map.add_vertical_tunnel(prev_y, new_y, new_x);
                    } else {
                        map.add_vertical_tunnel(prev_y, new_y, prev_x);
                        map.add_horizontal_tunnel(prev_x, new_x, new_y);
                    }
                }

                map.rooms.push(new_room);
            }
        }

        map
    }
}
```
Updates to main and player are needed.

## Adding Fog 
We want to limit player visibility, while also considering what future monster will see, too. We want to make a reusable componenet to use across entities.
We'll give each entity a list of tiles they can see and visbility range.

```rs
#[derive(Component)]
pub struct Vision {
    pub visible_tiles : Vec<rltk::Point>,
    pub range : i32
}
```
Register new componenet in main and give player the new component.


## Generic Vision
Create a generic system to handle vision
```rs
use specs::prelude::*;
use super::{Vision, Position};

pub struct VisionSystem {}

impl<'a> System<'a> for VisionSystem {
    type SystemData = ( WriteStorage<'a, Vision>, 
                        WriteStorage<'a, Position>);

    fn run(&mut self, (mut viewshed, pos) : Self::SystemData) {
        for (viewshed,pos) in (&mut viewshed, &pos).join() {
        }
    }
}
```
Now we have add our module and adjust run_systems in main.rs to actually call the system.

## Rendering 

We'll update our draw_map function to only draw tiles that are visible to the player

```rs
pub fn draw_map(ecs: &World, ctx : &mut Rltk) {
    let mut viewsheds = ecs.write_storage::<Vision>();
    let mut players = ecs.write_storage::<Player>();
    let map = ecs.fetch::<Map>();

    for (_player, viewshed) in (&mut players, &mut viewsheds).join() {
        let mut y = 0;
        let mut x = 0;
        for tile in map.tiles.iter() {
            // Render a tile depending upon the tile type
            let pt = Point::new(x,y);
            if viewshed.visible_tiles.contains(&pt) {
                match tile {
                    TileType::Floor => {
                        ctx.set(x, y, RGB::from_f32(0.5, 0.5, 0.5), RGB::from_f32(0., 0., 0.), rltk::to_cp437('.'));
                    }
                    TileType::Wall => {
                        ctx.set(x, y, RGB::from_f32(0.0, 1.0, 0.0), RGB::from_f32(0., 0., 0.), rltk::to_cp437('#'));
                    }
                }
            }

            // Move the coordinates
            x += 1;
            if x > 79 {
                x = 0;
                y += 1;
            }
        }
    }
}
```

## Including Revealed Tiles

To simulate memory, we'll expand our ```Map``` class to include a vector of bools, where each tile is represented by an index.

```rs
#[derive(Default)]
pub struct Map {
    pub tiles : Vec<TileType>,
    pub rooms : Vec<Rect>,
    pub width : i32,
    pub height : i32,
    pub revealed_tiles : Vec<bool>
}
```
edit rooms_and_corridors to contain our new field where each value is false.
changed draw_map to look at values, instead of iterating the components each time. Extend VisionSystem to know how to mark tiles as revealed. Add more improvemtns to increase speed.


## Improving Fog
We want to render the parts of the map we know are there, but we want to restrict vision of areas we are currently not in. Update ```Map``` to add current visible tiles. Next, for our ```VisionSystem``` we clear the list of visible tiles before iterating, marking the currently visible tiles. We adjust ```draw_map`` to handle not know but not visible tiles. After running the project we can see that the visible tiles are red and pink and grey when theyre out of vision,


## Adding Mobs
We'll start by making a ```Monster``` component and registering it on main.
we can create and entity with the monster component:

``` 
game_state.ecs.create_entity()
    .with(Position{ x, y })
    .with(Renderable{
        symbol: 'M',
        fg: RGB::named(rltk::RED),
        bg: RGB::named(rltk::BLACK),
    })
    .with(Vision{ visible_tiles : Vec::new(), range: 8, dirty: true })
    .with(Monster{})
    .build();
