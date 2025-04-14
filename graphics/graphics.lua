local newColor = require ('src.nyoom.graphics.color')

---@class Graphics
local graphics = {}

---Creates an object representing a color.
---@param r number
---@param g number
---@param b number
---@param a? number
---@return Color
function graphics.newColor(r, g, b, a)
  return newColor(r, g, b, a)
end

return graphics