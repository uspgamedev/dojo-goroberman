
module ('goroberman', package.seeall)

function load ()
  sprite = love.graphics.newImage 'data/images/hero_goroba_small.png'
  i = 1
  j = 1
  size = 1
  hotspot = {sprite:getWidth()/2, sprite:getHeight()-TILESIZE/2}
end
