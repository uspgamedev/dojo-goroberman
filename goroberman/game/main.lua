
local goroberman
local bombs
local explos
local tilesize
local map
local bgm

--- Código para ser executado no início do jogo.
function love.load ()
  goroberman = {
    sprite = love.graphics.newImage 'data/images/hero_goroba_small.png',
    i = 1,
    j = 1,
    size = 1,
    hotspot = {32, 90-32}
  }
  bombs = {
    sprite = love.graphics.newImage 'data/images/bomb_0.png'
  }
  explos = {
    sprite = love.graphics.newImage 'data/images/explosion_1.png',
    quads = {},
    period = 0.1,
    sound = love.audio.newSource 'data/sounds/PK_Hit_CK1.wav'
  }
  for i=1,5 do
    explos.quads[i] = love.graphics.newQuad(
      (i-1)*94, 0,
      94, 95,
      explos.sprite:getWidth(), explos.sprite:getHeight()
    )
  end
  tilesize = 64
  map = {}
  for i=1,11 do
    map[i] = {}
    for j=1,16 do
      if i%2 == 0 and j%2 == 0 then
        map[i][j] = { wall = true }
      else
        map[i][j] = { box = math.random() > 0.5 }
      end
    end
  end
  do 
    local i, j
    repeat
      i, j = math.random(1,11), math.random(1,16)
    until not map[i][j].wall and not map[i][j].box
    map[i][j].goroberman = goroberman
    goroberman.i = i
    goroberman.j = j
  end
  bgm = love.audio.newSource 'data/musics/8-Bit Bomber.ogg'
  love.graphics.setBackgroundColor(100,100,100)
  bgm:setLooping(true)
  bgm:setVolume(0.3)
  bgm:play()
end

local function inside (i,j)
  return math.max(1, math.min(11, i)), math.max(1, math.min(16, j))
end

local function new_bomb (i, j)
  if map[i][j].wall then return end
  local bomb = {
    sprite = bombs.sprite,
    i = i,
    j = j,
    size = 0.5,
    time = 3,
    hotspot = { bombs.sprite:getWidth()/2, bombs.sprite:getHeight()/2 }
  }
  bombs[bomb] = true
  map[i][j].bomb = bomb
end

local explo_handlers = {}

function explo_handlers.box (i, j)
  map[i][j].box = false
end

local function new_explo (i, j)
  local tile = map[i][j]
  if tile.wall then return end
  local explo = {
    sprite = explos.sprite,
    i = i,
    j = j,
    size = 0.5,
    hotspot = {94/2, 95-32},
    quads = explos.quads,
    frame = 1,
    time = explos.period
  }
  for k,obj in pairs(tile) do
    if explo_handlers[k] then
      explo_handlers[k] (i, j, obj)
    end
  end
  explos[explo] = true
end

local function explode (bomb)
  local i, j = bomb.i, bomb.j
  bombs[bomb] = nil
  map[i][j].bomb = nil
  new_explo(inside(i, j))
  new_explo(inside(i+1, j))
  new_explo(inside(i-1, j))
  new_explo(inside(i, j+1))
  new_explo(inside(i, j-1))
  explos.sound:rewind()
  explos.sound:play()
end

function explo_handlers.bomb (i, j, bomb)
  explode(bomb)
end

function explo_handlers.goroberman (i, j)
  love.update = nil
  love.draw = function ()
    love.graphics.translate(512-50, love.graphics.getHeight()/2-100)
    love.graphics.scale(3,3)
    love.graphics.print("YOU LOSE", 0, 0)
  end
end

--- Código executado a todo quadro do jogo.
function love.update (dt)
  for bomb,check in pairs(bombs) do
    if check == true then
      bomb.time = bomb.time - dt
      if bomb.time <= 0 then
        explode(bomb)
      end
    end
  end
  for explo,check in pairs(explos) do
    if check == true then
      explo.time = explo.time - dt
      if explo.time <= 0 then
        explo.frame = explo.frame + 1
        explo.time = explos.period
        if explo.frame > 5 then
          explos[explo] = nil
        end
      end
    end
  end
end

function love.keypressed (button)
  local i, j = goroberman.i, goroberman.j
  if button == ' ' then
    new_bomb(i, j)
  elseif button == 'up' then
    i = i - 1
  elseif button == 'down' then
    i = i + 1
  elseif button == 'left' then
    j = j - 1
  elseif button == 'right' then
    j = j + 1
  end
  i, j = inside(i,j)
  if not map[i][j].wall and not map[i][j].box and not map[i][j].bomb then
    map[goroberman.i][goroberman.j].goroberman = nil
    goroberman.i = i
    goroberman.j = j
    map[i][j].goroberman = goroberman
  end
end

local function draw_sprite (obj)
  local i, j = obj.i, obj.j
  love.graphics.draw(
    obj.sprite,
    32+(j-1)*tilesize,
    64+32+(i-1)*tilesize,
    0,
    obj.size, obj.size,
    obj.hotspot[1], obj.hotspot[2]
  )
end

local function draw_sprite_quad (obj)
  local i, j = obj.i, obj.j
  local quad = obj.quads[obj.frame]
  love.graphics.drawq(
    obj.sprite,
    quad,
    32+(j-1)*tilesize,
    64+32+(i-1)*tilesize,
    0,
    obj.size, obj.size,
    obj.hotspot[1], obj.hotspot[2]
  )
end

local function draw_box (i, j)
  love.graphics.setColor(120, 100, 60)
  love.graphics.rectangle(
    'fill',
    (j-1)*tilesize+8,
    64+(i-1)*tilesize+8,
    64-16, 32-8
  )
  love.graphics.setColor(60, 50, 30)
  love.graphics.rectangle(
    'fill',
    (j-1)*tilesize+8,
    64+(i-1)*tilesize+32,
    64-16, 32-8
  )
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle(
    'line',
    (j-1)*tilesize+8,
    64+(i-1)*tilesize+8,
    64-16, 64-16
  )
  love.graphics.setColor(255,255,255)
end

local function draw_wall (i, j)
  love.graphics.setColor(200, 200, 200)
  love.graphics.rectangle(
    'fill',
    (j-1)*tilesize,
    64+(i-1)*tilesize,
    64, 32
  )
  love.graphics.setColor(150, 150, 150)
  love.graphics.rectangle(
    'fill',
    (j-1)*tilesize,
    64+(i-1)*tilesize,
    64, 32
  )
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle(
    'line',
    (j-1)*tilesize,
    64+(i-1)*tilesize,
    64, 64
  )
  love.graphics.setColor(255,255,255)
end

--- Código executado para desenhar na tela.
function love.draw ()
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), 64)
  love.graphics.setColor(255,255,255)
  love.graphics.print("GOROBERMAN", 512-50, 32)
  for i,row in ipairs(map) do
    for j,tile in ipairs(row) do
      if tile.wall then
        draw_wall(i,j)
      end
      if tile.box then
        draw_box(i,j)
      end
    end
  end
  for bomb, check in pairs(bombs) do
    if check == true then
      draw_sprite(bomb)
    end
  end
  for explo, check in pairs(explos) do
    if check == true then
      draw_sprite_quad(explo)
    end
  end
  draw_sprite(goroberman)
end
