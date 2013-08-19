
module ('goroberman', package.seeall)

function load ()
  sprite = love.graphics.newImage 'data/images/hero_goroba_small.png'
  i = 1
  j = 1
  size = 1
  hotspot = {sprite:getWidth()/2, sprite:getHeight()-TILESIZE/2}
end

function putInMap (map)
  repeat
    i, j = math.random(1, map.height), math.random(1, map.width)
  until not map[i][j].wall and not map[i][j].box
  map[i][j].goroberman = goroberman
end

local collides_with = {
  wall = true,
  box = true,
  bomb = true
}

function move (map, di, dj)
  local new_i, new_j = inside(i+di, j+dj)
  for case,_ in pairs(collides_with) do
    if map[new_i][new_j][case] then
      return
    end
  end
  map[i][j].goroberman = nil
  i, j = new_i, new_j
  map[i][j].goroberman = goroberman
end
