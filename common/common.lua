local newVector2 = require('nyoom.common.vector2')
local newRect = require('nyoom.common.rect')

---@class Nyoom.Common
---@field newVector2 fun(x?: number, y?: number): Nyoom.Vector2 Create a new Vector.
---@field newRect fun(x?: number, y?: number, width?: number, height?: number): Nyoom.Rect Create a new Rect.
local common = {}

function common.newVector2(x, y)
  return newVector2(x or 0, y or 0)
end

function common.newRect(x, y, width, height)
  return newRect(x, y, width, height)
end


return common