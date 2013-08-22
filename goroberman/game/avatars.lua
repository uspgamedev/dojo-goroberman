
module ('avatars', package.seeall)

local map = require 'map'

local proto = {
  state = 'alive',
  timer = 0,
  fly_dir = 0,
  size = 1,
  rotation = 0,
  hotspot = nil,
  i = 1, j = 1
}

local sprite_cash
local hotspot_cash
local deployed

function load ()
  deployed = {}
  sprite_cash =
    sprite_cash or love.graphics.newImage 'data/images/hero_goroba_small.png'
  hotspot_cash = {sprite_cash:getWidth()/2, sprite_cash:getHeight()-TILESIZE/2}
end

function new ()
  local avatar = setmetatable({}, { __index = proto })
  local i, j
  repeat
    i, j = math.random(1, map.height), math.random(1, map.width)
  until not map.get(i, j, 'wall') and not map.get(i, j, 'box')
  avatar.i, avatar.j = i, j
  avatar.sprite = sprite_cash
  avatar.hotspot = hotspot_cash
  deployed[avatar] = true
  map.put(i, j, 'avatar', avatar)
  return avatar
end

function proto:alive ()
  return self.state == 'alive'
end

function proto:dying ()
  return self.state == 'dying'
end

function proto:dead ()
  return self.state == 'dead'
end

local collides_with = {
  wall = true,
  box = true,
  bomb = true,
  avatar = true
}

function proto:move (di, dj)
  if not self:alive() then return end
  local new_i, new_j = map.inside(self.i+di, self.j+dj)
  for tag,_ in pairs(collides_with) do
    if map.get(new_i, new_j, tag) then
      return
    end
  end
  map.put(self.i, self.j, 'avatar', nil)
  self.i, self.j = new_i, new_j
  map.put(self.i, self.j, 'avatar', self)
end

--- Trata o caso que uma explosão atinge o GoroberMan.
function proto:explode ()
  local old_keypressed = love.keypressed
  love.keypressed = function (button)
    if button == ' ' then
      love.keypressed = old_keypressed
      love.load()
    end
  end
  self:die()
end

function proto:die ()
  if self:dying() then return end
  self.state = 'dying'
  self.timer = 0
  local origin = { draw.toPixel(self.i, self.j) }
  local target = {
    WIDTH/4+math.random()*WIDTH/2,
    HEIGHT/4+math.random()*HEIGHT/2
  }
  self.fly_dir = math.atan2(target[2]-origin[2], target[1]-origin[1])
end

function update (dt)
  local dead = {}
  for avatar,_ in pairs(deployed) do
    if avatar:dying() then
      avatar.timer = avatar.timer + dt
      if avatar.timer > 0.5 then
        table.insert(dead, avatar)
      end
    end 
  end
  for _,avatar in ipairs(dead) do
    deployed[avatar] = nil
  end
end

function show ()
  for avatar,_ in pairs(deployed) do
    if avatar:dying() then
      avatar.rotation = math.pi*2*10*avatar.timer
      avatar.size = 1+avatar.timer*2
      love.graphics.translate(
        1000*avatar.timer*math.cos(avatar.fly_dir),
        1000*avatar.timer*math.sin(avatar.fly_dir)
      )
      love.graphics.setColor(255, 255, 255, 255-avatar.timer*2*255)
    else
      avatar.rotation = 0
      avatar.size = 1
    end
    draw.sprite(avatar)
  end
end
