
module ('bombs', package.seeall)

local map     = require 'map'
local draw    = require 'draw'
local explos  = require 'explos'

local deployed
local sprite_cash

function load ()
  deployed = {}
  sprite_cash = sprite_cash or love.graphics.newImage 'data/images/bomb_0.png'
end

function new (i, j)
  if map.get(i, j, 'wall') then return end
  local bomb = {
    sprite = sprite_cash,
    i = i,
    j = j,
    size = 0.5,
    time = 3,
    hotspot = { sprite_cash:getWidth()/2, sprite_cash:getHeight()/2 },
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
  explos.new(map.inside(i, j))
  explos.new(map.inside(i+1, j))
  explos.new(map.inside(i-1, j))
  explos.new(map.inside(i, j+1))
  explos.new(map.inside(i, j-1))
  explos.sound:rewind()
  explos.sound:play()
end

function show ()
  for bomb,_ in pairs(deployed) do
    draw.sprite(bomb)
  end 
end
