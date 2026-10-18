---A string of text aligned to a bounding box.
---@class nyoom.AlignedText
---@field string string
---@field font love.Font
---@field rect nyoom.Rect
---@field color nyoom.Color
---@field horizontalAlignment nyoom.HorizontalAlignment
---@field verticalAlignment nyoom.VerticalAlignment
---@field offset number
---
---@field draw fun(self: nyoom.AlignedText)
---@field setFont fun(self: nyoom.AlignedText, font: love.Font): nyoom.AlignedText
---@field setColor fun(self: nyoom.AlignedText, color: nyoom.Color): nyoom.AlignedText
---@field setAlignments fun(self: nyoom.AlignedText, horizonral: nyoom.HorizontalAlignment, vertical: nyoom.VerticalAlignment): nyoom.AlignedText
---@field setPosition fun(self: nyoom.AlignedText, x: number, y: number): nyoom.AlignedText
---@field setPosition fun(self: nyoom.AlignedText, position: nyoom.Vector2): nyoom.AlignedText
---@field setSize fun(self: nyoom.AlignedText, width: number, height: number): nyoom.AlignedText
---@field setSize fun(self: nyoom.AlignedText, size: nyoom.Vector2): nyoom.AlignedText
---@field update fun(self: nyoom.AlignedText)

local methods, metamethods = {}, { __name = 'nyoom.Text' }

---Create a new AlignedText.
---@param string string The string to align.
---@param x? number The x axis position of this object. Defaults to `0`.
---@param y? number The y axis position of this object. Defaults to `0`.
---@param width? number The width of this object. Defaults to `0`.
---@param height? number The height of this object. Defaults to `0`.
---@return nyoom.AlignedText
function nyoom.objects.newAlignedText(string, x, y, width, height)
  local text = {
    string = string,
    rect = nyoom.objects.newRect(x, y, width, height),
    font = nyoom.defaults.font,
    color = nyoom.defaults.foregroundColor,
    horizontalAlignment = 'center',
    verticalAlignment = 'center'
  }

  setmetatable(text, metamethods)

  return text
end

---@param self nyoom.AlignedText
function methods:draw()
  self.color:use()

  local offsetY = 0
  if self.verticalAlignment == 'center' then offsetY = (self.rect.height - self.font:getHeight()) / 2
  elseif self.verticalAlignment == 'bottom' then offsetY = self.rect.height - self.font:getHeight() end

  love.graphics.printf(self.string, self.font, self.rect.x, self.rect.y + offsetY, self.rect.width, self.horizontalAlignment)
end

function methods:setText(string)
  self.string = string
  return self
end

function methods:setFont(font)
  self.font = font
  return self
end

function methods:setColor(color)
  self.color = color
  return self
end

function methods:setAlignments(horizontal, vertical)
  self.horizontalAlignment = horizontal
  self.verticalAlignment = vertical
  return self
end

---@param x number | nyoom.Vector2
---@param y? number
function methods:setPosition(x, y)
  if type(x) == 'number' then self.rect.position = nyoom.objects.newVector2(x, y)
  else self.rect.position = x end
end

---@param self nyoom.AlignedText
---@param width number | nyoom.Vector2
---@param height? number
function methods:setSize(width, height)
  if type(width) == 'number' then self.rect.size = nyoom.objects.newVector2(width, height)
  else self.rect.size = width end
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

function metamethods:__tostring()
  return ('%s - %s'):format(self.string, self.rect)
end