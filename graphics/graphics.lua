local newColor = require('nyoom.graphics.color')
local newText = require('nyoom.graphics.text')

---@class Nyoom.Graphics
local graphics = {}

---Creates an object representing a color.
---@param r number
---@param g number
---@param b number
---@param a? number
---@return Nyoom.Color
function graphics.newColor(r, g, b, a)
  return newColor(r, g, b, a)
end

---Creates an object representing a color.
---@param string string
---@param x number
---@param y number
---@param width number
---@param height number
---@return Nyoom.Text
function graphics.newText(string, x, y, width, height)
  return newText(string, x, y, width, height)
end

return graphics