---@class Text
---@field string string
---@field font love.Font
---@field rect Rect

local methods, metamethods = {}, { __name = 'Text' }

local function newText(string, x, y, width, height, font)
  local text = {
    string = string,
    rect = nyoom.objects.newRect(x, y, width, height),
    font = font or love.graphics.newFont(12),
  }

  setmetatable(text, metamethods)

  return text
end

function methods:draw()

end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

function metamethods:__tostring()
  return self.string
end

return newText