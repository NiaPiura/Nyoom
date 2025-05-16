--- A renderable `Nyoom.Grid` using `love.SpriteBatch` and `Nyoom.TileSet` to determine how and what to render. 
---@class Nyoom.TileGrid
---@field width integer
---@field height integer
---@field size Nyoom.Vector2
---@field tileSet Nyoom.TileSet
---@field tileMap Nyoom.Grid
---@field spriteMap Nyoom.Grid
---@field spriteBatch love.SpriteBatch
---
---@field setSize fun(self: Nyoom.TileGrid, width: integer, height: integer): Nyoom.TileGrid Resizes the tilegrid.
---@field setTile fun(self: Nyoom.TileGrid, width: integer, height: integer, id: integer): Nyoom.TileGrid
---@field setTileSet fun(self: Nyoom.TileGrid, tileSet: Nyoom.TileSet): Nyoom.TileGrid
---@field getTilePosition fun(self: Nyoom.TileGrid, index: integer): Nyoom.Vector2?

local methods, metamethods = {}, { __name = 'Nyoom.TileGrid' }

---@param self Nyoom.TileGrid
local function repopulateSpriteBatch(self)
  self.spriteMap:clear()
  self.spriteBatch:clear()
  for i, id in ipairs(self.tileMap.map) do
    local pos = self.tileMap:getPosition(i)
    local tilePos = self:getTilePosition(i)
    if pos and tilePos then
      local spriteIndex = self.spriteBatch:add(self.tileSet.quads[id], tilePos.x, tilePos.y)
      self.spriteMap:setValue(pos.x, pos.y, spriteIndex)
    end
  end
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

function methods:setSize(width, height)
  self.tileMap:setSize(width, height)
  self.spriteMap:setSize(width, height)
  repopulateSpriteBatch(self)

  return self
end

function methods:setTile(x, y, id)
  local index = self.tileMap:getIndex(x, y)
  local spriteIndex = self.spriteMap:getValue(x, y)
  if not index then return end

  self.tileMap:setValue(x, y, id)
  self.spriteBatch:set(spriteIndex, self.tileSet.quads[id], x * self.tileSet.tileWidth, y * self.tileSet.tileHeight)
  return self
end

function methods:setTileSet(tileSet)
  self.tileSet = tileSet
  self.spriteBatch:setTexture(tileSet.image)
  repopulateSpriteBatch(self)
  return self
end

function methods:getTilePosition(index)
  local pos = self.tileMap:getPosition(index)
  if not pos then return
  else return nyoom.common.newVector2(pos.x * self.tileSet.tileWidth, pos.y * self.tileSet.tileHeight) end
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