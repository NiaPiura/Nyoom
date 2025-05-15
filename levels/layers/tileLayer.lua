---@class Nyoom.TileLayer
---@field name string
---@field parent Nyoom.Level
---@field offset Nyoom.Vector2
---@field tileGrid Nyoom.TileGrid
---
---@field update fun(self: Nyoom.TileLayer, deltaTime: number)
---@field draw fun(self: Nyoom.TileLayer)

local methods, metamethods = {}, { __name = 'Nyoom.TileLayer' }

---@param name string
---@param tileGrid Nyoom.TileGrid
---@param offsetX? integer
---@param offsetY? integer
---@return Nyoom.TileLayer
local function newTileLayer(name, tileGrid, offsetX, offsetY)
  local tileLayer = {
    name = name,
    offset = nyoom.common.newVector2(offsetX or 0, offsetY or 0),
    tileGrid = tileGrid
  }

  setmetatable(tileLayer, metamethods)

  return tileLayer
end

-- Methods

function methods:update(deltaTime) end

---@param self Nyoom.TileLayer
function methods:draw()
  love.graphics.setColor(1, 1, 1)
  --TEMP: scale 4 to make tilemaps better visible during development, must be replaced with camera rendering/scaling later
  love.graphics.draw(self.tileGrid.spriteBatch, self.offset.x, self.offset.y, 0, 4, 4)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newTileLayer
