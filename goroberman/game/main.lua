
require 'goroberman'
require 'bombs'
require 'explos'
require 'map'
require 'draw'

--- Guarda a música de fundo do jogo
local bgm

--- Código para ser executado no início do jogo.
function love.load ()
  WIDTH = love.graphics.getWidth()
  HEIGHT = love.graphics.getHeight()
  TILESIZE = 64
  -- Inicializa informações do mapa
  map.load(16, 11)
  goroberman.load()
  bombs.load()
  explos.load()
  -- Inicializa música de fundo
  bgm = love.audio.newSource 'data/musics/8-Bit Bomber.ogg'
  bgm:setLooping(true)
  bgm:setVolume(0.3)
  bgm:play()
end

--- Código executado a todo quadro do jogo.
function love.update (dt)
  bombs.update(dt)
  explos.update(dt)
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
  explos.show()
  goroberman.show()
end
