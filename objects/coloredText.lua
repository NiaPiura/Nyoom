---@class nyoom.ColoredText
---@field separator string
---@field sections { text: string, color: nyoom.Color }[]
---
---@field addSection fun(self: nyoom.ColoredText, text: string, color: nyoom.Color): nyoom.ColoredText
---@field newLine fun(self: nyoom.ColoredText): nyoom.ColoredText
---@field merge fun(self: nyoom.ColoredText, coloredText: nyoom.ColoredText): nyoom.ColoredText
---@field build fun(self: nyoom.ColoredText): table
---@field buildString fun(self: nyoom.ColoredText): string
---@field getDimensions fun(self: nyoom.ColoredText, font: love.Font): nyoom.Vector2

local methods, metamethods = {}, { __name = "nyoom.ColoredText" }

---Create a new ColoredText.
---@param separator? string The character to place between sections when concatenating. Defaults to empty space (` `).
---@return nyoom.ColoredText
function nyoom.objects.newColoredText(separator)
  local coloredText = {
    sections = {},
    separator = separator or ' '
  }

  setmetatable(coloredText, metamethods)

  return coloredText
end

---@param self nyoom.ColoredText
function methods:addSection(text, color)
  table.insert(self.sections, { text = text, color = color or nyoom.defaults.foregroundColor })
  return self
end

---@param self nyoom.ColoredText
function methods:newLine()
  table.insert(self.sections, { text = ' \n', color = nyoom.defaults.foregroundColor })
  return self
end

---@param self nyoom.ColoredText
function methods:merge(coloredText)
  for _, section in ipairs(coloredText.sections) do
    table.insert(self.sections, section)
  end
  return self
end

---@param self nyoom.ColoredText
function methods:build()
  local coloredText = {}

  for _, section in ipairs(self.sections) do
    table.insert(coloredText, section.color)
    table.insert(coloredText, section.text .. (section.text ~= ' \n' and self.separator or ''))
  end

  return coloredText
end

---@param self nyoom.ColoredText
function methods:buildString()
  local text = ''

  for _, section in ipairs(self.sections) do
    text = text .. section.text .. (section.text ~= ' \n' and self.separator or '')
  end

  return text
end

---@param self nyoom.ColoredText
---@param font love.Font
function methods:getDimensions(font)
  local text = self:buildString()
  local lines = #text:split('\n')

  return nyoom.objects.newVector2(font:getWidth(text), font:getHeight() * lines)
end

function metamethods:__index(key)
  return methods[key]
end