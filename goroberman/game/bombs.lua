
module ('bombs', package.seeall)

local map     = require 'map'
local draw    = require 'draw'
local explos  = require 'explos'

local deployed
local total
local limit
local sprite_cash

function load ()
  deployed = {}
  total = 0
  limit = 1
  sprite_cash = sprite_cash or love.graphics.newImage 'data/images/bomb_0.png'
end

function new (i, j)
  if map.get(i, j, 'wall') then return end
  if total >= limit then return end
  local bomb = {
    sprite = sprite_cash,
    i = i,
    j = j,
    size = 0.5,
    time = 2,
    hotspot = { sprite_cash:getWidth()/2, sprite_cash:getHeight()/2 },
    explode = explode
  }
  deployed[bomb] = true
  map.put(i, j, 'bomb', bomb)
  total = total + 1
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
function explode (bomb, radius)
  radius = radius or 2
  local i, j = bomb.i, bomb.j
  deployed[bomb] = nil
  map.put(i, j, 'bomb', nil)
  total = total - 1
  explos.new(i, j)
  explos.new(i+1, j, 1, 0, radius)
  explos.new(i-1, j, -1, 0, radius)
  explos.new(i, j+1, 0, 1, radius)
  explos.new(i, j-1, 0, -1, radius)
  explos.sound:rewind()
  explos.sound:play()
end

function show ()
  for bomb,_ in pairs(deployed) do
    draw.sprite(bomb)
  end 
end
