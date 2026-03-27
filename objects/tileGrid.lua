---A renderable `Nyoom.Grid` using `love.SpriteBatch` and `Nyoom.TileSet` to determine how and what to render. 
---@class Nyoom.TileGrid
---@field width integer The tileGrid's width in tiles.
---@field height integer The tileGrid's height in tiles.
---@field size Nyoom.Vector2 the tileGrid's size in tiles.
---@field tileSet Nyoom.TileSet the tileSet used.
---@field tileMap Nyoom.Grid The underlying grid containing tile IDs.
---@field spriteMap Nyoom.Grid A grid of sprite indexes used to update the spriteBatch.
---@field spriteBatch love.SpriteBatch The drawable Love2D object that allows the tileGrid to be rendered.
---
---@field getTileId fun(self: Nyoom.TileGrid, x: integer, y: integer): integer? Returns the tile ID at the given position, or nil if out of bounds.
---@field getTileId fun(self: Nyoom.TileGrid, index: integer): integer? Returns the tile ID at the given index, or nil if out of bounds.
---@field setTileId fun(self: Nyoom.TileGrid, x: integer, y: integer, id: integer): Nyoom.TileGrid Sets the tileID at the given position.
---@field setTileId fun(self: Nyoom.TileGrid, index: integer, id: integer): Nyoom.TileGrid Sets the tileID at the given index.
---@field getTilePixelPosition fun(self: Nyoom.TileGrid, x: integer, y: integer): Nyoom.Vector2? Returns the pixel coordinates of the tile at the given index.
---@field getTilePixelPosition fun(self: Nyoom.TileGrid, index: integer): Nyoom.Vector2? Returns the pixel coordinates of the tile at the given index.
---@field setTileSet fun(self: Nyoom.TileGrid, tileSet: Nyoom.TileSet): Nyoom.TileGrid Changes the used tileSet.
---@field setGridSize fun(self: Nyoom.TileGrid, width: integer, height: integer): Nyoom.TileGrid Resizes the tilegrid.

local methods, metamethods = {}, { __name = 'Nyoom.TileGrid' }

---@param self Nyoom.TileGrid
local function repopulateSpriteBatch(self)
  self.spriteMap:clear()
  self.spriteBatch:clear()
  for index, id in ipairs(self.tileMap.map) do
    local tilePos = self:getTilePixelPosition(index)
    if tilePos then
      local spriteIndex = self.spriteBatch:add(self.tileSet.quads[id], tilePos.x, tilePos.y)
      self.spriteMap:setValue(spriteIndex, index)
    end
  end
end

---If y is defined, use x/y coordinates, otherwise treat x as index.
local function indexOrCoords(self, x, y)
  return y and self.tileMap:getIndex(x, y) or x
end

---@param tileSet Nyoom.TileSet
---@param width? integer
---@param height? integer
---@return Nyoom.TileGrid
local function newTileGrid(tileSet, width, height)
  local tileGrid = {
    tileSet = tileSet,
    tileMap = nyoom.common.newGrid(width or 0, height or 0),
    spriteMap = nyoom.common.newGrid(width or 0, height or 0),
    spriteBatch = love.graphics.newSpriteBatch(tileSet.image)
  }

  setmetatable(tileGrid, metamethods)

  repopulateSpriteBatch(tileGrid)

  return tileGrid
end

-- Methods

function methods:getTileId(x, y)
  local index = indexOrCoords(self, x, y)
  return self.tileMap:getValue(index)
end

---@param self Nyoom.TileGrid
function methods:setTileId(id, x, y)
  local index = indexOrCoords(self, x, y)
  local spriteIndex = self.spriteMap:getValue(index)

  self.tileMap:setValue(id, index)
  self.spriteBatch:set(spriteIndex, self.tileSet.quads[id], self:getTilePixelPosition(index):getComponents())
  return self
end

---@param self Nyoom.TileGrid
function methods:getTilePixelPosition(x, y)
  local index = indexOrCoords(self, x, y)
  local pos = self.tileMap:getPosition(index)
  if not pos then return
  else return nyoom.common.newVector2(pos.x, pos.y) * self.tileSet.tileSize end
end

function methods:setTileSet(tileSet)
  self.tileSet = tileSet
  self.spriteBatch:setTexture(tileSet.image)
  repopulateSpriteBatch(self)
  return self
end

function methods:setGridSize(width, height)
  self.tileMap:setSize(width, height)
  self.spriteMap:setSize(width, height)
  repopulateSpriteBatch(self)

  return self
end

-- Metamethods

function metamethods:__index(key)
  if key == 'width' then return self.tileMap.width end
  if key == 'height' then return self.tileMap.height end
  if key == 'size' then return self.tileMap.size end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'width' then self:setSize(value, self.tileMap.height)
  elseif key == 'height' then self:setSize(self.tileMap.width, value)
  elseif key == 'size' then self:setSize(value.x, value.y)
  else rawset(self, key, value) end
end

return newTileGrid