local newTileLayer = require('nyoom.levels.layers.tileLayer')

---@class Nyoom.Level
---@field name string
---@field layers Nyoom.LayerTypes[]
---
---@field update fun(self: Nyoom.Level, deltaTime: number)
---@field draw fun(self: Nyoom.Level)
---@field addTileLayer fun(self: Nyoom.Level, name: string, width: number, height: number): Nyoom.TileLayer
---@field findLayer fun(self: Nyoom.Level, name: string): Nyoom.LayerTypes|nil

---@alias Nyoom.LayerTypes Nyoom.TileLayer

local methods, metamethods = {}, { __name = 'Nyoom.Level' }

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

function methods:addTileLayer(name, width, height)
  local tileLayer = newTileLayer(name, width, height)
  tileLayer.parent = self
  table.insert(self.layers, tileLayer)
  return tileLayer
end

---@param self Nyoom.Level
---@return Nyoom.LayerTypes|nil, number
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
