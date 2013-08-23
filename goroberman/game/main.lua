
require 'avatars'
require 'bombs'
require 'explos'
require 'map'
require 'draw'

--- Guarda a música de fundo do jogo
local bgm

--- Goroberman
local goroberman

--- Variáveis globais locais
local timer
local delay

--- Código para ser executado no início do jogo.
function love.load ()
  WIDTH = love.graphics.getWidth()
  HEIGHT = love.graphics.getHeight()
  TILESIZE = 64
  timer = 0
  delay = 5
  -- Inicializa informações do mapa
  map.load(16, 11)
  avatars.load()
  bombs.load()
  explos.load()
  -- Inicializa música de fundo
  if not bgm then
    bgm = love.audio.newSource 'data/musics/8-Bit Bomber.ogg'
    bgm:setLooping(true)
    bgm:setVolume(0.3)
    bgm:play()
  end
  -- Inicializa o goroberman
  goroberman = avatars.new 'goroba'
  goroberman.damages = false
  function goroberman:explode ()
    local old_keypressed = love.keypressed
    function love.keypressed (button)
      if button == ' ' then
        love.keypressed = old_keypressed
        love.load()
      end
    end
    self:die()
  end
  -- Cria um MechaWils
  (avatars.new 'wil').size = 1/4
end


--- Código executado a todo quadro do jogo.
function love.update (dt)
  bombs.update(dt)
  explos.update(dt)
  avatars.update(dt)
  timer = timer + dt
  if avatars.getTotal() <= 17 then
    while timer >= delay do
      timer = timer - delay
      delay = math.max(delay*0.9, 1.0);
      (avatars.new 'wil').size = 1/4
    end
  end
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
    goroberman:move(unpack(move_directions[button]))
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
  avatars.show()
end
