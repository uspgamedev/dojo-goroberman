
module ('explos', package.seeall)

local map = require 'map'

local deployed = {}

function load ()
  -- Inicializa informações das exploções
  sprite = love.graphics.newImage 'data/images/explosion_1.png'
  quads = {}
  period = 0.1
  sound = love.audio.newSource 'data/sounds/PK_Hit_CK1.wav'
  -- Inicializa quadros da animação de explosão
  for i=1,5 do
    quads[i] = love.graphics.newQuad(
      (i-1)*94, 0,
      94, 95,
      sprite:getWidth(), sprite:getHeight()
    )
  end 
end

--- Cria uma explosão na posição (i, j).
function new (i, j)
  local tile = map.get(i, j)
  if tile.wall then return end
  local explo = {
    sprite = sprite,
    i = i,
    j = j,
    size = 0.5,
    hotspot = {94/2, 95-32},
    quads = quads,
    frame = 1,
    time = period
  }
  for k,obj in pairs(tile) do
    if explo_handlers[k] then
      explo_handlers[k] (i, j, obj)
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
