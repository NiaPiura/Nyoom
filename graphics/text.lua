local newColor = require('nyoom.graphics.color')

---@class Nyoom.Text
---@field string string
---@field font love.Font
---@field rect Nyoom.Rect
---@field color Nyoom.Color
---@field horizontalAlignment TextHorizontalAlignment
---@field verticalAlignment TextVerticalAlignment
---@field offset number
---
---@field draw fun(self: Nyoom.Text)
---@field setFont fun(self: Nyoom.Text, font: love.Font): Nyoom.Text
---@field setColor fun(self: Nyoom.Text, color: Nyoom.Color): Nyoom.Text
---@field setAlignments fun(self: Nyoom.Text, horizonral: TextHorizontalAlignment, vertical: TextVerticalAlignment): Nyoom.Text
---@field setPosition fun(self: Nyoom.Text, x: number, y: number): Nyoom.Text
---@field setPosition fun(self: Nyoom.Text, position: Nyoom.Vector2): Nyoom.Text
---@field setSize fun(self: Nyoom.Text, width: number, height: number): Nyoom.Text
---@field setSize fun(self: Nyoom.Text, size: Nyoom.Vector2): Nyoom.Text
---@field update fun(self: Nyoom.Text)

---@alias TextHorizontalAlignment 'left'|'right'|'center'|'justify'
---@alias TextVerticalAlignment 'top'|'bottom'|'center'

local defaults = {
  color = newColor(1, 1, 1),
  font = love.graphics.newFont(12)
}

local methods, metamethods = {}, { __name = 'Nyoom.Text' }

---@param string string
---@param x number
---@param y number
---@param width number
---@param height number
---@return Nyoom.Text
local function newText(string, x, y, width, height)
  local text = {
    string = string,
    rect = nyoom.common.newRect(x, y, width, height),
    font = defaults.font,
    color = defaults.color,
    horizontalAlignment = 'left',
    verticalAlignment = 'top',
    offset = 0
  }

  setmetatable(text, metamethods)

  text:update()

  return text
end

---@param self Nyoom.Text
function methods:draw()
  love.graphics.setColor(self.color)
  love.graphics.printf(self.string, self.font, self.rect.x, self.rect.y + self.offset, self.rect.width, self.horizontalAlignment)
end

function methods:setText(string)
  self.string = string
  self:update()
  return self
end

function methods:setFont(font)
  self.font = font
  self:update()
  return self
end

function methods:setColor(color)
  self.color = color
  return self
end

function methods:setAlignments(horizontal, vertical)
  self.horizontalAlignment = horizontal
  self.verticalAlignment = vertical
  self:update()
  return self
end

---@param x number|Nyoom.Vector2
---@param y number|nil
function methods:setPosition(x, y)
  if type(x) == 'number' then self.rect.position = nyoom.common.newVector2(x, y)
  else self.rect.position = x end
end

---@param self Nyoom.Text
---@param width number|Nyoom.Vector2
---@param height number|nil
function methods:setSize(width, height)
  if type(width) == 'number' then self.rect.size = nyoom.common.newVector2(width, height)
  else self.rect.size = width end
  self:update()
end

---@param self Nyoom.Text
function methods:update()
  self.offset = (self.rect.height - self.font:getHeight()) / 2
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

function metamethods:__tostring()
  return self.string
end

return newText