local newVector2 = require('nyoom.common.vector2')
local newRect = require('nyoom.common.rect')

---@class Nyoom.Common
---@field newVector fun(x?: number, y?: number): Nyoom.Vector2 Create a new Vector.
---@field newRect fun(x?: number, y?: number, width?: number, height?: number): Nyoom.Rect Create a new Rect.
local common = {}

function common.newVector2(x, y)
  return newVector2(x, y)
end

function common.newRect(x, y, width, height)
  return newRect(x, y, width, height)
end


return common