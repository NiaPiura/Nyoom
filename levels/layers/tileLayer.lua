---@class nyoom.TileLayer
---@field name string
---@field parent nyoom.Level
---@field offset nyoom.Vector2
---@field tileGrid nyoom.TileGrid
---
---@field update fun(self: nyoom.TileLayer, deltaTime: number)
---@field draw fun(self: nyoom.TileLayer)

local methods, metamethods = {}, { __name = 'nyoom.TileLayer' }

---@param name string
---@param tileGrid nyoom.TileGrid
---@param offsetX? integer
---@param offsetY? integer
---@return nyoom.TileLayer
local function newTileLayer(name, tileGrid, offsetX, offsetY)
  local tileLayer = {
    name = name,
    offset = nyoom.objects.newVector2(offsetX or 0, offsetY or 0),
    tileGrid = tileGrid
  }

  setmetatable(tileLayer, metamethods)

  return tileLayer
end

-- Methods

function methods:update(deltaTime) end

---@param self nyoom.TileLayer
function methods:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.tileGrid.spriteBatch, self.offset.x, self.offset.y)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newTileLayer
