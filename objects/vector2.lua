---A two-dimensional vector, consisting of x (width) and y (height) components.
---@class nyoom.Vector2
---@field x number The vector's x component.
---@field y number The vector's y component.
---@field width number An alias to `x`, can be used when vector represents dimensions insteaf of a point.
---@field height number An alias to `y`, can be used when vector represents dimensions insteaf of a point.
---
----@operator call: number, number
---@operator unm: nyoom.Vector2
---@operator add(nyoom.Vector2): nyoom.Vector2
---@operator sub(nyoom.Vector2): nyoom.Vector2
---@operator mul(number | nyoom.Vector2): nyoom.Vector2
---@operator div(number): nyoom.Vector2
---
---@field getAxes fun(self: nyoom.Vector2): number, number Returns the vector's components seperately.
---@field getRelevantAxis fun(self: nyoom.Vector2, orientation: nyoom.Orientation): number
---@field magnitude fun(self: nyoom.Vector2): number Returns the magnitude of the vector.
---@field sqrMagnitude fun(self: nyoom.Vector2): number Returns the squared magnitude of the vector.
---@field normalized fun(self: nyoom.Vector2): nyoom.Vector2 Returns a normalized version of this vector.
---@field distance fun(self: nyoom.Vector2, target: nyoom.Vector2): number Returns the distance to `target`.
---@field angleRad fun(self: nyoom.Vector2, target: nyoom.Vector2): number Returns the angle between `self` and `target` in radians.
---@field angleDeg fun(self: nyoom.Vector2, target: nyoom.Vector2): number Returns the angle between `self` and `target` in degrees.

local methods, metamethods = {}, { __name = 'nyoom.Vector2' }

---Create a new vector.
---@param x? number The x axis component. Defaults to `0`.
---@param y? number The y axis component. Defaults to `0`.
---@return nyoom.Vector2
function nyoom.objects.newVector2(x, y)
  return setmetatable({ x or 0, y or 0 }, metamethods)
end

-- Methods

function methods:getAxes()
  return self[1], self[2]
end

function methods:getRelevantAxis(orientation)
  return orientation == 'horizontal' and self[1] or self[2]
end

function methods:magnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function methods:sqrMagnitude()
  return self.x * self.x + self.y * self.y
end

function methods:normalized()
  local length = self:magnitude()
  if length == 0 then return nyoom.objects.newVector2()
  else return nyoom.objects.newVector2(self.x / length, self.y / length) end
end

---@param target nyoom.Vector2
function methods:distance(target)
  return (self - target):magnitude()
end

---@param target nyoom.Vector2
function methods:angleRad(target)
  return math.atan2(target.y - self.y, target.x - self.x)
end

---@param target nyoom.Vector2
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
  return nyoom.objects.newVector2(-self.x, -self.y)
end

function metamethods.__add(a, b)
  return nyoom.objects.newVector2(a.x + b.x, a.y + b.y)
end

function metamethods.__sub(a, b)
  return nyoom.objects.newVector2(a.x - b.x, a.y - b.y)
end

function metamethods.__mul(a, b)
  if type(a) == 'number' then return nyoom.objects.newVector2(a * b.x, a * b.y)
  elseif type(b) == 'number' then return nyoom.objects.newVector2(a.x * b, a.y * b)
  else return nyoom.objects.newVector2(a.x * b.x, a.y * b.y) end
end

function metamethods.__div(a, b)
  if type(a) == 'number' then error('Cannot devide number by vector')
  elseif type(b) == 'number' then return nyoom.objects.newVector2(a.x / b, a.y / b)
  else return nyoom.objects.newVector2(a.x / b.x, a.y / b.y) end
end

function metamethods.__eq(a, b)
  return math.abs(a.x - b.x) < 1e-5 and math.abs(a.y - b.y) < 1e-5
end

function metamethods:__tostring()
  return ('(%.1f, %.1f)'):format(self.x, self.y)
end