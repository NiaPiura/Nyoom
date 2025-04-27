---@class Nyoom.TileLayer
---@field name string
---@field offset Nyoom.Vector2
---@field tileMap number[]
---@field tileSet Nyoom.TileSet?
---@field spriteBatch love.SpriteBatch?
---@field spriteMap number[]?
---
---@field update fun(self: Nyoom.TileLayer, deltaTime: number)
---@field draw fun(self: Nyoom.TileLayer)
---@field setSize fun(self: Nyoom.TileLayer, width: number, height: number): Nyoom.TileLayer
---@field setTile fun(self: Nyoom.TileLayer, id: number, width: number, height: number): Nyoom.TileLayer
---@field setTileSet fun(self: Nyoom.TileLayer, tileSet: Nyoom.TileSet): Nyoom.TileLayer
---@field getTilePosition fun(self: Nyoom.TileLayer, index: number)

local methods, metamethods = {}, { __name = 'Nyoom.TileLayer' }


local function newTileLayer(name, width, height)
  local tileLayer = {
    name = name,
    offset = nyoom.common.newVector2()
  }

  setmetatable(tileLayer, metamethods)

  tileLayer:setSize(width, height)

  return tileLayer
end

-- Methods

function methods:update(deltaTime) end

---@param self Nyoom.TileLayer
function methods:draw()
  if not self.spriteBatch then return end
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.spriteBatch, self.offset.x, self.offset.y, 0, 4, 4)
end

function methods:setSize(width, height)
  self.size = nyoom.common.newVector2(width, height)
  self.tileMap = {}
  for i=1, width * height do
    self.tileMap[i] = 1
  end
  return self
end

function methods:setTile(id, x, y)
  local index = (self.size.width * y) + x + 1
  self.tileMap[index] = id
  if self.spriteMap then self.spriteBatch:set(self.spriteMap[index], self.tileSet.quads[id], x * self.tileSet.tileWidth, y * self.tileSet.tileHeight) end
  return self
end

function methods:setTileSet(tileSet)
  self.tileSet = tileSet
  self.spriteBatch = love.graphics.newSpriteBatch(tileSet.image)
  self.spriteMap = {}

  for i, id in ipairs(self.tileMap) do
    local posX, posY = self:getTilePosition(i)
    local index = self.spriteBatch:add(self.tileSet.quads[id], posX, posY)
    table.insert(self.spriteMap, index)
  end
  return self
end

function methods:getTilePosition(index)
  local tileWidth = self.tileSet and self.tileSet.tileWidth or 1
  local tileHeight = self.tileSet and self.tileSet.tileHeight or 1
  return ((index-1) % (self.size.width)) * tileWidth, math.floor((index-1) / (self.size.width)) * tileHeight
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newTileLayer
