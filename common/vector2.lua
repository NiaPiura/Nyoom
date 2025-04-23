---A two-dimensional vector, consisting of x and y components.
---@class Nyoom.Vector2
---@field x number
---@field y number
---@field width number
---@field height number
---
----@operator call: number, number
---@operator unm: Nyoom.Vector2
---@operator add(Nyoom.Vector2): Nyoom.Vector2
---@operator sub(Nyoom.Vector2): Nyoom.Vector2
---@operator mul(number | Nyoom.Vector2): Nyoom.Vector2
---@operator div(number): Nyoom.Vector2
---
---@field magnitude fun(self: Nyoom.Vector2): number Returns the magnitude of the vector.
---@field sqrMagnitude fun(self: Nyoom.Vector2): number Returns the squared magnitude of the vector.
---@field normalized fun(self: Nyoom.Vector2): Nyoom.Vector2 Returns a normalized version of this vector.
---@field distance fun(self: Nyoom.Vector2, target: Nyoom.Vector2): number Returns the distance to `target`.
---@field angleRad fun(self: Nyoom.Vector2, target: Nyoom.Vector2): number Returns the angle between `self` and `target` in radians.
---@field angleDeg fun(self: Nyoom.Vector2, target: Nyoom.Vector2): number Returns the angle between `self` and `target` in degrees.

local methods, metamethods = {}, { __name = 'Nyoom.Vector2' }

---Create a new Vector. Arguments default to 0.
---@param x number|nil
---@param y number|nil
---@return Nyoom.Vector2
local function newVector2(x, y)
  return setmetatable({ x or 0, y or 0 }, metamethods)
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

---@param target Nyoom.Vector2
function methods:distance(target)
  return (self - target):magnitude()
end

---@param target Nyoom.Vector2
function methods:angleRad(target)
  return math.atan2(target.y - self.y, target.x - self.x)
end

---@param target Nyoom.Vector2
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