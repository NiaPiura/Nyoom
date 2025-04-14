---@class Color
---@field r number
---@field g number
---@field b number
---@field a number
---
---@field setActive fun(self: Color)
---@field add fun(self: Color, value: Color|number): Color
---@field multiply fun(self: Color, value: number): Color
---
---@operator add(Color|number): Color
---@operator mul(number): Color

local methods, metamethods = {}, { __name = 'Color' }

---@param r number
---@param g number
---@param b number
---@param a? number
---@return Color
local function newColor(r, g, b, a)
  return setmetatable({ r, g, b, a or 1 }, metamethods)
end

-- Methods

function methods:setActive()
  love.graphics.setColor(self)
end

---@param value Color|number
function methods:add(value)
  if type(value) == 'number' then
    return newColor(
      math.clamp(self[1] + value, 0, 1),
      math.clamp(self[2] + value, 0, 1),
      math.clamp(self[3] + value, 0, 1),
      math.clamp(self[4] + value, 0, 1)
    )
  else
    return newColor(
      math.clamp(self[1] + value[1], 0, 1),
      math.clamp(self[2] + value[2], 0, 1),
      math.clamp(self[3] + value[3], 0, 1),
      math.clamp(self[4] + value[4], 0, 1)
    )
  end
end

---@param value number
function methods:multiply(value)
  return newColor(
    math.clamp(self[1] * value, 0, 1),
    math.clamp(self[2] * value, 0, 1),
    math.clamp(self[3] * value, 0, 1),
    math.clamp(self[4] * value, 0, 1)
  )
end

-- Metamethods

---@param key string
function metamethods:__index(key)
  if key == 'r' then return self[1] end
  if key == 'g' then return self[2] end
  if key == 'b' then return self[3] end
  if key == 'a' then return self[4] end
  return methods[key]
end

function metamethods:__newindex() end

---@param value Color|number
function metamethods:__add(value)
  return self:add(value)
end

---@param value number
function metamethods:__mul(value)
  return self:multiply(value)
end

function metamethods:__tostring()
  return ('(%.2f, %.2f, %.2f, %.2f)'):format(self[1], self[2], self[3], self[4])
end

return newColor