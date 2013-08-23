
module ('map', package.seeall)

local draw = require 'draw'
local tiles
local bomb_sprite
local bomb_hotspot

local function make_box (i, j)
  return {
    i = i,
    j = j,
    explode = function (self)
      map.put(i, j, 'box', nil)
      if math.random() > 0.7 then
        map.put(i, j, 'item', {
          i = i,
          j = j,
          action = function () bombs.increaseLimit() end,
          sprite = bomb_sprite,
          size = 1/16,
          rotation = 0,
          hotspot = bomb_hotspot,
          explode = function (self)
            map.put(i, j, 'item', nil)
          end
        })
      end
    end,
  }
end

function load (w, h)
  bomb_sprite =
    bomb_sprite or love.graphics.newImage 'data/images/bomb-item.png'
  bomb_hotspot = {bomb_sprite:getWidth()/2, bomb_sprite:getHeight()/2}
  width, height = w, h
  tiles = {}
  for i=1,height do
    tiles[i] = {}
    for j=1,width do
      if i%2 == 0 and j%2 == 0 then
        tiles[i][j] = { wall = true }
      else
        tiles[i][j] = { box = math.random() > 0.5 and make_box(i, j) or nil }
      end
    end
  end
  -- Configura cor de fundo
  love.graphics.setBackgroundColor(100,100,100)
end

function get (i, j, tag)
  if i < 1 or i > height or j < 1 or j > width then return nil end
  if tag then
    return tiles[i][j][tag]
  end
  return tiles[i][j]
end

function put (i, j, tag, value)
  if i < 1 or i > height or j < 1 or j > width then return nil end
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
      if tile.item then
        draw.item(tile.item)
      end
    end
  end 
end

