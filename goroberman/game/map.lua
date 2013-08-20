
module ('map', package.seeall)

local draw = require 'draw'
local tiles

function load (w, h)
  width, height = w, h
  tiles = {}
  for i=1,height do
    tiles[i] = {}
    for j=1,width do
      if i%2 == 0 and j%2 == 0 then
        tiles[i][j] = { wall = true }
      else
        tiles[i][j] = { box = math.random() > 0.5 }
      end
    end
  end
  -- Configura cor de fundo
  love.graphics.setBackgroundColor(100,100,100)
end

function get (i, j, tag)
  if tag then
    return tiles[i][j][tag]
  end
  return tiles[i][j]
end

function put (i, j, tag, value)
  tiles[i][j][tag] = value
end

function inside (i, j)
  return  math.max(1, math.min(height, i)), math.max(1, math.min(width, j))
end

function show ()
  for i,row in ipairs(tiles) do
    for j,tile in ipairs(row) do
      if tile.wall then
        draw.wall(i,j)
      end
      if tile.box then
        draw.box(i,j)
      end
    end
  end 
end

