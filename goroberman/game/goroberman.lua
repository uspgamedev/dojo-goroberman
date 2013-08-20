
module ('goroberman', package.seeall)

local map = require 'map'

local state

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

function die ()
  state = 'dying'
end

function show ()
  if not alive() then return end
  draw.sprite(goroberman)
end
