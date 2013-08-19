
module ('goroberman', package.seeall)

local map = require 'map'

function load ()
  sprite = love.graphics.newImage 'data/images/hero_goroba_small.png'
  i = 1
  j = 1
  size = 1
  hotspot = {sprite:getWidth()/2, sprite:getHeight()-TILESIZE/2}
end

function putInMap ()
  repeat
    i, j = math.random(1, map.height), math.random(1, map.width)
  until not map.get(i, j, 'wall') and not map.get(i, j, 'box')
  map.put(i, j, 'goroberman', goroberman)
end

local collides_with = {
  wall = true,
  box = true,
  bomb = true
}

function move (di, dj)
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
