
module ('draw', package.seeall)

function toPixel (i, j)
  return 32+(j-1)*TILESIZE, 54+32+(i-1)*TILESIZE
end

function sprite (obj)
  if not obj.sprite then return end
  local i, j = obj.i, obj.j
  love.graphics.draw(
    obj.sprite,
    32+(j-1)*TILESIZE,
    64+32+(i-1)*TILESIZE,
    obj.rotation or 0,
    obj.size, obj.size,
    obj.hotspot[1], obj.hotspot[2]
  )
end

function sprite_quad (obj)
  local i, j = obj.i, obj.j
  local quad = obj.quads[obj.frame]
  love.graphics.drawq(
    obj.sprite,
    quad,
    32+(j-1)*TILESIZE,
    64+32+(i-1)*TILESIZE,
    0,
    obj.size, obj.size,
    obj.hotspot[1], obj.hotspot[2]
  )
end

function cube (i, j, color, padding)
  love.graphics.setColor(color)
  love.graphics.rectangle(
    'fill',
    (j-1)*TILESIZE+padding,
    64+(i-1)*TILESIZE+padding,
    64-padding*2, 32-padding
  )
  love.graphics.setColor(color[1]*0.75, color[2]*0.75, color[3]*0.75)
  love.graphics.rectangle(
    'fill',
    (j-1)*TILESIZE+padding,
    64+(i-1)*TILESIZE+32,
    64-padding*2, 32-padding
  )
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle(
    'line',
    (j-1)*TILESIZE+padding,
    64+(i-1)*TILESIZE+padding,
    64-padding*2, 64-padding*2
  )
  love.graphics.setColor(255,255,255)
end

-- Desenha uma caixa
function box (i, j)
  cube(i, j, {120, 100, 60}, 8)
end

--- Desenha uma parede
function wall (i, j)
  cube(i, j, {150, 150, 150}, 0)
end
