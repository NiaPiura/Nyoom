local newVector2 = require('nyoom.common.vector2')
local newRect = require('nyoom.common.rect')

---@class Common
local common = {}

---Create a new Vector
---@param x number | nil
---@param y number | nil
---@return Vector2
function common.newVector2(x, y)
  return newVector2(x, y)
end

---Create a new Rect
---@param x number | nil
---@param y number | nil
---@param width number | nil
---@param height number | nil
---@return Rect
function common.newRect(x, y, width, height)
  return newRect(x, y, width, height)
end


return common