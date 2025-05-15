local newVector2 = require('nyoom.common.vector2')
local newRect = require('nyoom.common.rect')
local newGrid = require('nyoom.common.grid')

---@class Nyoom.Common
---@field newVector2 fun(x?: number, y?: number): Nyoom.Vector2
---@field newRect fun(x?: number, y?: number, width?: number, height?: number): Nyoom.Rect
---@field newGrid fun(width: number, height: number, defaultValue?: number): Nyoom.Grid
local common = {}

function common.newVector2(x, y)
  return newVector2(x, y)
end

function common.newRect(x, y, width, height)
  return newRect(x, y, width, height)
end

function common.newGrid(width, height, defaultValue)
  return newGrid(width, height, defaultValue)
end


return common