
module ('goroberman', package.seeall)

local map = require 'map'

local state
local timer
local fly_dir

function load ()
  state = 'alive'
  sprite = sprite or love.graphics.newImage 'data/images/hero_goroba_small.png'
  size = 1
  hotspot = {sprite:getWidth()/2, sprite:getHeight()-TILESIZE/2}
  repeat
    i, j = math.random(1, map.height), math.random(1, map.width)
  until not map.get(i, j, 'wall') and not map.get(i, j, 'box')
  map.put(i, j, 'goroberman', goroberman)
end

function alive ()
  return state == 'alive'
end

function dying ()
  return state == 'dying'
end

function dead ()
  return state == 'dead'
end

local collides_with = {
  wall = true,
  box = true,
  bomb = true
}

function move (di, dj)
  if not alive() then return end
  local new_i, new_j = map.inside(i+di, j+dj)
  for tag,_ in pairs(collides_with) do
    if map.get(new_i, new_j, tag) then
      return
    end
  end
  map.put(i, j, 'goroberman', nil)
  i, j = new_i, new_j
  map.put(i, j, 'goroberman', goroberman)
end

--- Trata o caso que uma explosão atinge o GoroberMan.
function explode (self)
  local old_keypressed = love.keypressed
  love.keypressed = function (button)
    if button == ' ' then
      love.keypressed = old_keypressed
      love.load()
    end
  end
  die()
end

function die ()
  state = 'dying'
  timer = 0
  local origin = { draw.toPixel(i,j) }
  local target = {
    WIDTH/4+math.random()*WIDTH/2,
    HEIGHT/4+math.random()*HEIGHT/2
  }
  fly_dir = math.atan2(target[2]-origin[2], target[1]-origin[1])
end

function update (dt)
  if dying() then
    timer = timer + dt
    if timer > 0.5 then
      state = 'dead'
    end
  end 
end

function show ()
  if dead() then return end
  if dying() then
    rotation = math.pi*2*10*timer
    size = 1+timer*2
    love.graphics.translate(
      1000*timer*math.cos(fly_dir),
      1000*timer*math.sin(fly_dir)
    )
    love.graphics.setColor(255, 255, 255, 255-timer*2*255)
  else
    rotation = 0
    size = 1
  end
  draw.sprite(goroberman)
end
