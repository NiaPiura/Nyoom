local newColor = require('nyoom.graphics.color')
local newText = require('nyoom.graphics.text')

---@class Nyoom.Graphics
---@field newColor fun(r: number, g: number, b: number, a?: number): Nyoom.Color Creates an object representing a color.
---@field newText fun(string: string, x: number, y: number, width: number, height: number): Nyoom.Text Creates an object representing a color.
local graphics = {}

function graphics.newColor(r, g, b, a)
  return newColor(r, g, b, a)
end

function graphics.newText(string, x, y, width, height)
  return newText(string, x, y, width, height)
end

return graphics