
require 'goroberman'
require 'bombs'
require 'map'
require 'draw'

--- Guarda a música de fundo do jogo
local bgm

--- Tabela com funções que tratam as explosões
local explo_handlers = {}

--- Código para ser executado no início do jogo.
function love.load ()
  WIDTH = love.graphics.getWidth()
  HEIGHT = love.graphics.getHeight()
  TILESIZE = 64
  -- Inicializa informações do mapa
  map.load(16, 11)
  goroberman.load()
  bombs.load()
  -- Inicializa informações das exploções
  explos = {
    sprite = love.graphics.newImage 'data/images/explosion_1.png',
    quads = {},
    period = 0.1,
    sound = love.audio.newSource 'data/sounds/PK_Hit_CK1.wav'
  }
  -- Inicializa quadros da animação de explosão
  for i=1,5 do
    explos.quads[i] = love.graphics.newQuad(
      (i-1)*94, 0,
      94, 95,
      explos.sprite:getWidth(), explos.sprite:getHeight()
    )
  end
  -- Inicializa música de fundo
  bgm = love.audio.newSource 'data/musics/8-Bit Bomber.ogg'
  bgm:setLooping(true)
  bgm:setVolume(0.3)
  bgm:play()
end

--- Trata o caso em que uma explosão atinge uma caixa.
function explo_handlers.box (i, j)
  map.put(i, j, 'box', nil)
end

--- Cria uma explosão na posição (i, j).
function new_explo (i, j)
  local tile = map.get(i, j)
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

--- Trata o caso em que uma explosão atinge outra bomba.
function explo_handlers.bomb (i, j, bomb)
  bomb:explode()
end

--- Trata o caso que uma explosão atinge o GoroberMan.
function explo_handlers.goroberman (i, j)
  local old_keypressed = love.keypressed
  love.keypressed = function (button)
    if button == ' ' then
      love.keypressed = old_keypressed
      map.load(16, 11)
      goroberman.load()
    end
  end
  goroberman.die()
end

--- Código executado a todo quadro do jogo.
function love.update (dt)
  bombs.update(dt)
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
  goroberman.update(dt)
end

local move_directions = {
  up    = {-1, 0},
  down  = {1, 0},
  left  = {0, -1},
  right = {0, 1}
}

--- Função chamada quando o jogador aperta uma tecla do teclado.
function love.keypressed (button)
  local i, j = goroberman.i, goroberman.j
  if button == ' ' then
    bombs.new(i,j)
  elseif move_directions[button] then
    goroberman.move(unpack(move_directions[button]))
  end
end

--- Código executado para desenhar na tela.
function love.draw ()
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill', 0, 0, WIDTH, 64)
  love.graphics.setColor(255,255,255)
  love.graphics.printf("GOROBERMAN", WIDTH/2, 32, 0, 'center')
  map.show()
  bombs.show()
  for explo, check in pairs(explos) do
    if check == true then
      draw.sprite_quad(explo)
    end
  end
  goroberman.show()
end
