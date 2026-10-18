---An Axis Aligned Bounding Box (AABB), represented by a `position` vector and a `size` vector.
---@class nyoom.Rect
---@field x number The rect's x position.
---@field y number The rect's y position.
---@field width number The rect's Width.
---@field height number The rect's height.
---@field position nyoom.Vector2 The rect's position (top-left corner).
---@field size nyoom.Vector2 The rect's size (bottom-left corner's delta from the position).
---
---@field setPosition fun(self: nyoom.Rect, x: number, y: number)
---@field setPosition fun(self: nyoom.Rect, position: nyoom.Vector2)
---@field setSize fun(self: nyoom.Rect, width: number, height: number)
---@field setSize fun(self: nyoom.Rect, size: nyoom.Vector2)
---@field getCenter fun(self: nyoom.Rect): nyoom.Vector2 Returns a vector representing the center of the rect.
---@field isWithinBounds fun(self: nyoom.Rect, point: nyoom.Vector2): boolean Returns whether a given position is within the rect's bounds.

local methods, metamethods = {}, { __name = 'nyoom.Rect' }

---Create a new Rect.
---@param x? integer The x axis position of this object. Defaults to `0`.
---@param y? integer The y axis position of this object. Defaults to `0`.
---@param width? integer The width of this object. Defaults to `0`.
---@param height? integer The height of this object. Defaults to `0`.
---@return nyoom.Rect
function nyoom.objects.newRect(x, y, width, height)
  local rect = {
    position = nyoom.objects.newVector2(x or 0, y or 0),
    size = nyoom.objects.newVector2(width or 0, height or 0),
  }

  return setmetatable(rect, metamethods)
end

-- Methods

function methods:setPosition(x, y)
  if type(x) == 'number' then self.position = nyoom.objects.newVector2(x, y)
  else self.position = nyoom.objects.newVector2(x.x, x.y) end
end

function methods:setSize(width, height)
  if type(width) == 'number' then self.size = nyoom.objects.newVector2(width, height)
  else self.size = nyoom.objects.newVector2(width.x, width.y) end
end

function methods:getCenter()
  return self.position + self.size / 2
end

---@param point nyoom.Vector2
function methods:isWithinBounds(point)
  return
    point.x >= self.x and point.x < self.x + self.width and
    point.y >= self.y and point.y < self.y + self.height
end


-- Metamethods

---@param key string
function metamethods:__index(key)
  if key == 'x' then return self.position[1] end
  if key == 'y' then return self.position[2] end
  if key == 'width' then return self.size[1] end
  if key == 'height' then return self.size[2] end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'x' then self:setPosition(value, self.y)
  elseif key == 'y' then self:setPosition(self.x, value)
  elseif key == 'width' then self:setSize(value, self.height)
  elseif key == 'height' then self:setSize(self.width, value) end
end

function metamethods:__tostring()
  return ('pos:%s, size:%s'):format(tostring(self.position), tostring(self.size))
end