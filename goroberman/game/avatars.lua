
module ('avatars', package.seeall)

local map     = require 'map'
local explos  = require 'explos'

local proto = {
  state = 'alive',
  timer = 0,
  fly_dir = 0,
  size = 1,
  rotation = 0,
  hotspot = nil,
  i = 1, j = 1,
  damages = true,
  delay = 0
}

local collides_with = {
  wall = true,
  box = true,
  bomb = true,
  avatar = true
}

local sprite_cash
local hotspot_cash
local deployed

function load ()
  deployed = {}
  sprite_cash = sprite_cash or {
    goroba = love.graphics.newImage 'data/images/hero_goroba_small.png',
    wil = love.graphics.newImage 'data/images/hero_wil.png'
  }
  hotspot_cash = hotspot_cash or {
    goroba = {
      sprite_cash.goroba:getWidth()/2,
      sprite_cash.goroba:getHeight()*3/4
    },
    wil = {
      sprite_cash.wil:getWidth()/2,
      sprite_cash.wil:getHeight()*3/4
    }
  }
end

local function collides (i, j)
  for tag,_ in pairs(collides_with) do
    if map.get(i, j, tag) then
      return true
    end
  end
end

local next_ID = 1

function new (which)
  local avatar = setmetatable({}, { __index = proto })
  local i, j
  repeat
    i, j = math.random(1, map.height), math.random(1, map.width)
  until not map.get(i, j, 'wall')
  for ki=i-1,i+1 do
    for kj=j-1,j+1 do
      map.put(ki, kj, 'box', nil)
    end
  end
  avatar.i, avatar.j = i, j
  avatar.sprite = sprite_cash[which]
  avatar.hotspot = hotspot_cash[which]
  avatar.ID = next_ID
  next_ID = next_ID + 1
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

function proto:move (di, dj)
  if not self:alive() then return end
  local new_i, new_j = map.inside(self.i+di, self.j+dj)
  if self.damages then
    local another = map.get(new_i, new_j, 'avatar')
    if another and another ~= self then
      another:explode()
    end
  end
  if collides(new_i, new_j) then return end
  map.put(self.i, self.j, 'avatar', nil)
  self.i, self.j = new_i, new_j
  map.put(self.i, self.j, 'avatar', self)
end

--- Trata o caso que uma explosão atinge o GoroberMan.
function proto:explode ()
  self:die()
end

function proto:die ()
  if self:dying() then return end
  explos.sound:rewind()
  explos.sound:play()
  map.put(self.i, self.j, 'avatar', nil)
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
    if avatar:alive() and avatar.damages then
      -- This is done by enemy avatars
      avatar.delay = avatar.delay - dt
      if avatar.delay <= 0 then
        if math.random() >= 0.5 then
          avatar:move(1-2*(math.random(2)-1), 0)
        else
          avatar:move(0, 1-2*(math.random(2)-1))
        end
        avatar.delay = -math.log(math.random())*0.5
      end
    elseif avatar:dying() then
      avatar.timer = avatar.timer + dt
      avatar.rotation = math.pi*2*5*avatar.timer
      avatar.size = avatar.size*((10^6)^dt)
      if avatar.timer > 1/2 then
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
    love.graphics.push()
    if avatar:dying() then
      love.graphics.translate(
        1000*avatar.timer*math.cos(avatar.fly_dir),
        1000*avatar.timer*math.sin(avatar.fly_dir)
      )
      love.graphics.setColor(255, 255, 255, 255-avatar.timer*2*255)
    end
    draw.sprite(avatar)
    love.graphics.pop()
    love.graphics.setColor(255, 255, 255)
  end
end
