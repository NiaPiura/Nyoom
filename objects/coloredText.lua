---@class Nyoom.ColoredText
---@field separator string
---@field sections { text: string, color: Nyoom.Color }[]
---
---@field addSection fun(self: Nyoom.ColoredText, text: string, color: Nyoom.Color): Nyoom.ColoredText
---@field newLine fun(self: Nyoom.ColoredText): Nyoom.ColoredText
---@field build fun(self: Nyoom.ColoredText): table
---@field buildString fun(self: Nyoom.ColoredText): string
---@field getDimensions fun(self: Nyoom.ColoredText, font: love.Font): Nyoom.Vector2

local methods, metamethods = {}, { __name = "Nyoom.ColoredText" }

local function newColoredText(separator)
  local coloredText = {
    sections = {},
    separator = separator or ' '
  }

  setmetatable(coloredText, metamethods)

  return coloredText
end

---@param self Nyoom.ColoredText
function methods:addSection(text, color)
  table.insert(self.sections, { text = text, color = color or nyoom.ui.defaults.foregroundColor })
  return self
end

---@param self Nyoom.ColoredText
function methods:newLine()
  table.insert(self.sections, { text = ' \n', color = nyoom.ui.defaults.foregroundColor })
  return self
end

---@param self Nyoom.ColoredText
function methods:build()
  local coloredText = {}

  for _, section in ipairs(self.sections) do
    table.insert(coloredText, section.color)
    table.insert(coloredText, section.text .. (section.text ~= ' \n' and self.separator or ''))
  end

  return coloredText
end

---@param self Nyoom.ColoredText
function methods:buildString()
  local text = ''

  for _, section in ipairs(self.sections) do
    text = text .. section.text .. (section.text ~= ' \n' and self.separator or '')
  end

  return text
end

---@param self Nyoom.ColoredText
---@param font love.Font
function methods:getDimensions(font)
  local text = self:buildString()
  local lines = #text:split('\n')

  return nyoom.common.newVector2(font:getWidth(text), font:getHeight() * lines)
end

function metamethods:__index(key)
  return methods[key]
end

return newColoredText