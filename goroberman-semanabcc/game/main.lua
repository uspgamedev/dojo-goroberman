local goroberman_sprite
local goroberman_i, goroberman_j = 2, 2
local bomb_i, bomb_j = 4, 4
local bomb = nil
local bomb_timer = 0
local explosion = {image = nil, sprite = {}, i = 1, j = 1, active = nil, timer = 0, isprite = 1}
local caixa_i, caixa_j = 1,1
--- Código para ser executado no início do jogo.
function love.load ()
  love.graphics.setBackgroundColor(100,100,100)
  goroberman_sprite = love.graphics.newImage 'data/images/hero_goroba_small.png'
  bomb_sprite = love.graphics.newImage 'data/images/bomb_0.png'
  explosion.image = love.graphics.newImage 'data/images/explosion_1.png'
  for i=1, 5 do
    explosion.sprite[i] = love.graphics.newQuad(0 + 94*(i-1), 0, 94, 95, 474, 95)
  end
  mundo = {}
  for i = 0, 8 do
    mundo[i] = {}
    for j=0,11 do
      mundo[i][j] = 'empty'
    end
  end
    mundo[1][1] = 'caixa'
end

--- Código executado a todo quadro do jogo.
function love.update (dt)
  if (bomb) then
    bomb_timer = bomb_timer + dt
    if bomb_timer > 2 then
      if bomb_i + 1 == caixa_i and bomb_j == caixa_j then
        mundo[1][1] = 'empty'
      end
      if bomb_i - 1 == caixa_i and bomb_j == caixa_j then
        mundo[1][1] = 'empty'
      end
      if bomb_j + 1 == caixa_j and bomb_i == caixa_i then
        mundo[1][1] = 'empty'
      end
      if bomb_j - 1 == caixa_j and bomb_i == caixa_i then
        mundo[1][1] = 'empty'
      end
      bomb = nil
      bomb_timer = 0
      explosion.active = true
      explosion.timer = 0
      explosion.i = bomb_i
      explosion.j = bomb_j
      explosion.isprite = 1
    end
  end

  if(explosion.active) then
    explosion.timer = explosion.timer + dt
    if(explosion.timer > 0.1) then
       explosion.timer = 0
       if(explosion.isprite <=4) then
        explosion.isprite = explosion.isprite + 1
      else
        explosion.active = false
      end
    end
  end

end

function love.keypressed (button)
  if button == 'escape' then
    love.event.push 'quit'
  elseif button == 'up' then
    if goroberman_i*64 > 0 then
      if mundo[goroberman_i-1][goroberman_j] ~= 'caixa' then
        goroberman_i = goroberman_i - 1
      end
    end
  elseif button == 'down' then
    if goroberman_i*64 < 600-128  then
      if mundo[goroberman_i+1][goroberman_j] ~= 'caixa' then
        goroberman_i = goroberman_i + 1
      end
    end
  elseif button == 'left' then
    if goroberman_j*64 > 0  then
      if mundo[goroberman_i][goroberman_j-1] ~= 'caixa' then
        goroberman_j = goroberman_j - 1
      end
    end
  elseif button == 'right' then
    if goroberman_j*64 < 800-128  then
      if mundo[goroberman_i][goroberman_j+1] ~= 'caixa' then
        goroberman_j = goroberman_j + 1
      end
    end
  end

  if button == ' ' then
    if not bomb then
      bomb = true
      bomb_i = goroberman_i
      bomb_j = goroberman_j
    end
  end
end

--- Código executado para desenhar na tela.
function love.draw ()
  love.graphics.print("GOROBERMAN", 512-50, 768/2-100)
  if (bomb) then
    love.graphics.draw(bomb_sprite, 64*bomb_j, 64*bomb_i)
  end
  if (explosion.active) then
    love.graphics.drawq(explosion.image, explosion.sprite[explosion.isprite] , 64*explosion.j, 64*explosion.i)
    love.graphics.drawq(explosion.image, explosion.sprite[explosion.isprite] , 64*(explosion.j+1), 64*explosion.i)
    love.graphics.drawq(explosion.image, explosion.sprite[explosion.isprite] , 64*(explosion.j-1), 64*explosion.i)
    love.graphics.drawq(explosion.image, explosion.sprite[explosion.isprite] , 64*explosion.j, 64*(explosion.i+1))
    love.graphics.drawq(explosion.image, explosion.sprite[explosion.isprite] , 64*explosion.j, 64*(explosion.i-1))



  end
  love.graphics.draw(goroberman_sprite, 64*goroberman_j, 64*goroberman_i)
  love.graphics.setColor(180,140,50)
  if mundo[1][1] == 'caixa' then
    love.graphics.rectangle('fill', 64, 64, 64, 64)
  end
  love.graphics.setColor(255,255,255)
end
