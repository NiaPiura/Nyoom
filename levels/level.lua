local newTileLayer = require('nyoom.levels.layers.tileLayer')

---@class nyoom.Level
---@field name string
---@field layers nyoom.LayerTypes[]
---
---@field update fun(self: nyoom.Level, deltaTime: number)
---@field draw fun(self: nyoom.Level)
---@field addTileLayer fun(self: nyoom.Level, name: string, tileGrid: nyoom.TileGrid, offsetX?: integer, offsetY?: integer): nyoom.TileLayer
---@field findLayer fun(self: nyoom.Level, name: string): nyoom.LayerTypes|nil

---@alias nyoom.LayerTypes nyoom.TileLayer

local methods, metamethods = {}, { __name = 'nyoom.Level' }

---@param name string
local function newLevel(name)
  local level = {
    name = name,
    layers = {}
  }

  setmetatable(level, metamethods)

  return level
end

-- Methods

function methods:update(deltaTime)

end

function methods:draw()
  for _, layer in ipairs(self.layers) do
    layer:draw()
  end
end

function methods:addTileLayer(name, tileGrid, offsetX, offsetY)
  local tileLayer = newTileLayer(name, tileGrid, offsetX, offsetY)
  tileLayer.parent = self
  table.insert(self.layers, tileLayer)
  return tileLayer
end

---@param self nyoom.Level
---@return nyoom.LayerTypes|nil, number
function methods:findLayer(name)
  for i, layer in ipairs(self.layers) do
    if layer.name == name then return layer, i end
  end
  return nil, -1
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newLevel
