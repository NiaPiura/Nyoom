---A table of color channel components ranging in value between 0 and 1, that also implements color manipulation methods.
---Can be used directly as an argument in `love.graphics.setColor()`.
---@class nyoom.Color
---@field r number
---@field g number
---@field b number
---@field a number
---
---@field use fun(self: nyoom.Color)
---@field add fun(self: nyoom.Color, value: nyoom.Color|number): nyoom.Color
---@field mul fun(self: nyoom.Color, value: number): nyoom.Color
---@field red fun(self: nyoom.Color, value: number): nyoom.Color
---@field green fun(self: nyoom.Color, value: number): nyoom.Color
---@field blue fun(self: nyoom.Color, value: number): nyoom.Color
---@field alpha fun(self: nyoom.Color, value: number): nyoom.Color
---
---@operator add(nyoom.Color | number): nyoom.Color
---@operator mul(number): nyoom.Color

local methods, metamethods = {}, { __name = 'nyoom.Color' }

---Create a new Color.
---@param red number The red component of this color.
---@param green? number The green component of this color. If `nil`, uses `red`.
---@param blue? number The blue component of this color. If `nil`, uses `red`.
---@param alpha? number The alpha component of this color. Defaults to `1`.
---@return nyoom.Color
function nyoom.objects.newColor(red, green, blue, alpha)
  return setmetatable({ red, green or red, blue or red, alpha or 1 }, metamethods)
end

-- Methods

---@param self nyoom.Color
function methods:use()
  love.graphics.setColor(self)
end

---@param self nyoom.Color
---@param value nyoom.Color | number
function methods:add(value)
  if type(value) == 'number' then
    return nyoom.objects.newColor(
      math.clamp(self[1] + value, 0, 1),
      math.clamp(self[2] + value, 0, 1),
      math.clamp(self[3] + value, 0, 1),
      math.clamp(self[4] + value, 0, 1)
    )
  else
    return nyoom.objects.newColor(
      math.clamp(self[1] + value[1], 0, 1),
      math.clamp(self[2] + value[2], 0, 1),
      math.clamp(self[3] + value[3], 0, 1),
      math.clamp(self[4] + value[4], 0, 1)
    )
  end
end

---@param self nyoom.Color
---@param value number
function methods:mul(value)
  return nyoom.objects.newColor(
    math.clamp(self[1] * value, 0, 1),
    math.clamp(self[2] * value, 0, 1),
    math.clamp(self[3] * value, 0, 1),
    math.clamp(self[4] * value, 0, 1)
  )
end

---@param self nyoom.Color
---@param value number
function methods:red(value)
  return nyoom.objects.newColor(
    math.clamp(value, 0, 1),
    self[2],
    self[3],
    self[4]
  )
end
---@param self nyoom.Color
---@param value number
function methods:green(value)
  return nyoom.objects.newColor(
    self[1],
    math.clamp(value, 0, 1),
    self[3],
    self[4]
  )
end
---@param self nyoom.Color
---@param value number
function methods:blue(value)
  return nyoom.objects.newColor(
    self[1],
    self[2],
    math.clamp(value, 0, 1),
    self[4]
  )
end
---@param self nyoom.Color
---@param value number
function methods:alpha(value)
  return nyoom.objects.newColor(
    self[1],
    self[2],
    self[3],
    math.clamp(value, 0, 1)
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

---@param value nyoom.Color | number
function metamethods:__add(value)
  return self:add(value)
end

---@param value number
function metamethods:__mul(value)
  return self:mul(value)
end

function metamethods:__tostring()
  return ('(%.2f, %.2f, %.2f, %.2f)'):format(self[1], self[2], self[3], self[4])
end