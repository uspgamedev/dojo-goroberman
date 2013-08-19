
--- Código para ser executado no início do jogo.
function love.load ()
  love.graphics.setBackgroundColor(100,100,100)
end

--- Código executado a todo quadro do jogo.
function love.update (dt)
  -- STUB
end

--- Código executado para desenhar na tela.
function love.draw ()
  love.graphics.print("GOROBERMAN", 512-50, 768/2-100)
end
