local newVector2 = require('nyoom.objects.vector2')
local newRect = require('nyoom.objects.rect')

---@class Objects
local objects = {}

---Create a new Vector
---@param x number | nil
---@param y number | nil
---@return Vector2
function objects.newVector2(x, y)
  return newVector2(x, y)
end

---Create a new Rect
---@param x number | nil
---@param y number | nil
---@param width number | nil
---@param height number | nil
---@return Rect
function objects.newRect(x, y, width, height)
  return newRect(x, y, width, height)
end


return objects