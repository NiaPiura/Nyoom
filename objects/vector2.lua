---A two-dimensional vector, consisting of x and y components.
---@class Vector2
---@field x number
---@field y number
---@field width number
---@field height number
---
----@operator call: number, number
---@operator unm: Vector2
---@operator add(Vector2): Vector2
---@operator sub(Vector2): Vector2
---@operator mul(number | Vector2): Vector2
---@operator div(number): Vector2
---
---@field magnitude fun(self: Vector2): number Returns the magnitude of the vector.
---@field sqrMagnitude fun(self: Vector2): number Returns the squared magnitude of the vector.
---@field normalized fun(self: Vector2): Vector2 Returns a normalized version of this vector.
---@field distance fun(self: Vector2, target: Vector2): number Returns the distance to `target`.
---@field angleRad fun(self: Vector2, target: Vector2): number Returns the angle between `self` and `target` in radians.
---@field angleDeg fun(self: Vector2, target: Vector2): number Returns the angle between `self` and `target` in degrees.

local methods, metamethods = {}, { __name = 'Vector2' }

---Create a new Vector. Arguments default to 0.
---@param x number | nil
---@param y number | nil
---@return Vector2
local function newVector2(x, y)
  return setmetatable({ x, y }, metamethods)
end

-- Methods

function methods:get()
  return self[1], self[2]
end

function methods:magnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function methods:sqrMagnitude()
  return self.x * self.x + self.y * self.y
end

function methods:normalized()
  local length = self:magnitude()
  if length == 0 then return newVector2()
  else return newVector2(self.x / length, self.y / length) end
end

---@param target Vector2
function methods:distance(target)
  return (self - target):magnitude()
end

---@param target Vector2
function methods:angleRad(target)
  return math.atan2(target.y - self.y, target.x - self.x)
end

---@param target Vector2
function methods:angleDeg(target)
  return (self:angleRad(target) * (180 / math.pi) + 90.0) % 360.0
end

-- Metamethods

function metamethods:__index(key)
  if key == 'x' then return self[1] end
  if key == 'y' then return self[2] end
  if key == 'width' then return self[1] end
  if key == 'height' then return self[2] end
  return methods[key]
end

function metamethods:__newindex() end -- Makes vectors immutable

function metamethods:__unm()
  return newVector2(-self.x, -self.y)
end

function metamethods:__tostring()
  return ('(x:%.1f, y:%.1f)'):format(self.x, self.y)
end

function metamethods.__add(a, b)
  return newVector2(a.x + b.x, a.y + b.y)
end

function metamethods.__sub(a, b)
  if type(a) == 'number' then newVector2(a - b.x, a - b.y)
  elseif type(b) == 'number' then newVector2(a.x - b, a.y - b)
  else return newVector2(a.x - b.x, a.y - b.y) end
end

function metamethods.__mul(a, b)
  if type(a) == 'number' then return newVector2(a * b.x, a * b.y)
  elseif type(b) == 'number' then return newVector2(a.x * b, a.y * b)
  else return newVector2(a.x * b.x, a.y * b.y) end
end

function metamethods.__div(a, b)
  return newVector2(a.x / b, a.y / b)
end

function metamethods.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

return newVector2