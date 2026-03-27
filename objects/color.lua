---@class Nyoom.Color
---@field r number
---@field g number
---@field b number
---@field a number
---
---@field setActive fun(self: Nyoom.Color)
---@field add fun(self: Nyoom.Color, value: Nyoom.Color|number): Nyoom.Color
---@field multiply fun(self: Nyoom.Color, value: number): Nyoom.Color
---
---@operator add(Nyoom.Color|number): Nyoom.Color
---@operator mul(number): Nyoom.Color

local methods, metamethods = {}, { __name = 'Nyoom.Color' }

---@param red number
---@param green number
---@param blue number
---@param alpha? number
---@return Nyoom.Color
local function newColor(red, green, blue, alpha)
  return setmetatable({ red, green, blue, alpha or 1 }, metamethods)
end

-- Methods

function methods:setActive()
  love.graphics.setColor(self)
end

---@param value Nyoom.Color|number
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
  if key == 'red' then return self[1] end
  if key == 'green' then return self[2] end
  if key == 'blue' then return self[3] end
  if key == 'alpha' then return self[4] end
  return methods[key]
end

function metamethods:__newindex() end

---@param value Nyoom.Color|number
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