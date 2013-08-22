
module ('explos', package.seeall)

local map = require 'map'

local deployed
local sprite_cash

function load ()
  deployed = {}
  -- Inicializa informações das exploções
  sprite_cash =
    sprite_cash or love.graphics.newImage 'data/images/explosion_1.png'
  quads = {}
  period = 0.1
  sound = love.audio.newSource 'data/sounds/PK_Hit_CK1.wav'
  -- Inicializa quadros da animação de explosão
  for i=1,5 do
    quads[i] = love.graphics.newQuad(
      (i-1)*94, 0,
      94, 95,
      sprite_cash:getWidth(), sprite_cash:getHeight()
    )
  end 
end

--- Cria uma explosão na posição (i, j).
function new (i, j)
  local tile = map.get(i, j)
  if tile.wall then return end
  local explo = {
    sprite = sprite_cash,
    i = i,
    j = j,
    size = 0.5,
    hotspot = {94/2, 95-32},
    quads = quads,
    frame = 1,
    time = period
  }
  for _,obj in pairs(tile) do
    if obj.explode then
      obj:explode()
    end
  end
  deployed[explo] = true
end

function update (dt)
  for explo,check in pairs(deployed) do
    if check == true then
      explo.time = explo.time - dt
      if explo.time <= 0 then
        explo.frame = explo.frame + 1
        explo.time = period
        if explo.frame > 5 then
          deployed[explo] = nil
        end
      end
    end
  end
end

function show ()
  for explo,_ in pairs(deployed) do
    draw.sprite_quad(explo)
  end
end
