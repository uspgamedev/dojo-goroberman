
module ('bombs', package.seeall)

local map   = require 'map'
local draw  = require 'draw'

local deployed = {}

function load ()
  sprite = sprite or love.graphics.newImage 'data/images/bomb_0.png'
end

function new (i, j)
  if map.get(i, j, 'wall') then return end
  local bomb = {
    sprite = sprite,
    i = i,
    j = j,
    size = 0.5,
    time = 3,
    hotspot = { sprite:getWidth()/2, sprite:getHeight()/2 },
    explode = explode
  }
  deployed[bomb] = true
  map.put(i, j, 'bomb', bomb)
end

function update (dt)
  for bomb,_ in pairs(deployed) do
    bomb.time = bomb.time - dt
    if bomb.time <= 0 then
      explode(bomb)
    end
  end 
end

--- Explode a bomba passada como argumento.
function explode (bomb)
  local i, j = bomb.i, bomb.j
  deployed[bomb] = nil
  map.put(i, j, 'bomb', nil)
  new_explo(map.inside(i, j))
  new_explo(map.inside(i+1, j))
  new_explo(map.inside(i-1, j))
  new_explo(map.inside(i, j+1))
  new_explo(map.inside(i, j-1))
  explos.sound:rewind()
  explos.sound:play()
end

function show ()
  for bomb,_ in pairs(deployed) do
    draw.sprite(bomb)
  end 
end
