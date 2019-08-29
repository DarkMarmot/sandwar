# Sandbox Wars

A "Battle Royale" game in which you control a spaceship by coding its AI in Lua -- which is executed in Elixir via Robert's Virding's Erlang library Luerl.

Basic Game Rules:

1) Your ship will spawn somewhere randomly in space after a 30 second delay.
2) Your screen will be centered on a radar display with a limited view of your surroundings.
3) Every few seconds, your AI routine will be executed so that it can issue commands.
4) Available commands (up to 10 energy max for each):
    1) `thrust(energy)` - moves your ship
    2) `face(direction)` - instantly face a given direction (0 to 360 degrees), expends no energy
    3) `turn(direction)` - instantly turns (0 to 360 degrees), expends no energy
    4) `scan(energy)` - increases your radar range and uncovers cloaked ships
    5) `cloak(energy)` - blocks radar tracking
    6) `fire(energy)` - fires a missile whose damage and range increase with energy
5) Your AI will run with a `status` table preset with current conditions.
    1) `status.x` - your x position in space
    2) `status.y` - your y position in space
    3) `status.hull` - your current ship health, starts at 100
    4) `status.energy` - your current energy, starts at 100, recovers 20 per AI round
    5) `status.ships` - list of ships detected by your last radar scan (with `distance`, `direction` and `name`)
    6) `status.missiles` - list of missiles detected by your last radar scan (with `distance` and `direction` -- currently missing :( )
6) There is a `nearest(list)` function that can be used to find the closest missile or ship, e.g. `ship = nearest(status.ships)`
     
Example ship AIs:

### RANDOM BURST AI
```lua
 scan(4)
 s = status.age
 -- every 4th AI round, blast a bunch of random missiles
 if math.floor(s) % 4 == 0 then
   for i = 1,12 do
     face(math.random(360))
     fire(math.random(10))
   end 
 end
  
```


### AMBUSH AI
```lua

  scan_power = 5
  cloak_power = 5
  thrust_power = 5
  
  n = nearest(status.ships)
  
  if n ~= nil and n.distance < 500 then
   face(n.direction - 15)
   if status.energy > 50 then
    for i=-1,3 do
     fire(10)
     turn(15)
    end
   end
   face(n.direction - 110)
  else
  
   if status.energy >= 80 then
     scan_power = 10
     cloak_power = 10
   end   
  end   
  
  thrust(thrust_power)
  cloak(cloak_power)
  scan(scan_power) 
    
```


### HUNTER KILLER AI
```lua
  
  
  -- stay around the center of the game world
  x = status.x
  y = status.y
  boundary = 700
  
  scan_power = 5
  
  if x < -boundary then
    face(math.random(180) - 90)
  elseif x > boundary then
   face(math.random(180) + 90)
  elseif y < -boundary then
   face(math.random(180))
  elseif y > boundary then
   face(math.random(180) + 180)
  end
  
   -- spiral in towards nearby ships while firing
  n = nearest(status.ships)
  
  if n ~= nil and n.distance < 300 then
   face(n.direction - 10)
   if status.energy > 50 then
    for i=-1,5 do
     fire(5)
     turn(5)
    end
   end
   face(n.direction + 80)
  else
   if status.energy >= 80 then
     scan_power = 10
   end   
  end   
  
  thrust(10)
  scan(scan_power) 
    
```


    
        
    


