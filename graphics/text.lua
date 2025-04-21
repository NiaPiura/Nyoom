local newColor = require('nyoom.graphics.color')

---@class Text
---@field string string
---@field font love.Font
---@field rect Rect
---@field color Color
---@field horizontalAlignment TextHorizontalAlignment
---@field verticalAlignment TextVerticalAlignment
---@field offset number
---
---@field draw fun(self: Text)
---@field setFont fun(self: Text, font: love.Font): Text
---@field setColor fun(self: Text, color: Color): Text
---@field setAlignments fun(self: Text, horizonral: TextHorizontalAlignment, vertical: TextVerticalAlignment): Text
---@field setPosition fun(self: Text, x: number, y: number): Text
---@field setPosition fun(self: Text, position: Vector2): Text
---@field setSize fun(self: Text, width: number, height: number): Text
---@field setSize fun(self: Text, size: Vector2): Text
---@field update fun(self: Text)

---@alias TextHorizontalAlignment 'left'|'right'|'center'|'justify'
---@alias TextVerticalAlignment 'top'|'bottom'|'center'

local defaults = {
  color = newColor(1, 1, 1),
  font = love.graphics.newFont(12)
}

local methods, metamethods = {}, { __name = 'Text' }

---@param string string
---@param x number
---@param y number
---@param width number
---@param height number
---@return Text
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

---@param self Text
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

---@param x number|Vector2
---@param y number|nil
function methods:setPosition(x, y)
  if type(x) == 'number' then self.rect.position = nyoom.common.newVector2(x, y)
  else self.rect.position = x end
end

---@param self Text
---@param width number|Vector2
---@param height number|nil
function methods:setSize(width, height)
  if type(width) == 'number' then self.rect.size = nyoom.common.newVector2(width, height)
  else self.rect.size = width end
  self:update()
end

---@param self Text
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