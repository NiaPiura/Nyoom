---An Axis Aligned Bounding Box (AABB), internally represented by two vectors
---@class Nyoom.Rect
---@field x number The rect's x position.
---@field y number The rect's y position.
---@field width number The rect's Width.
---@field height number The rect's height.
---@field position Nyoom.Vector2 The rect's position (top-left corner).
---@field size Nyoom.Vector2 The rect's size (bottom-left corner's delta from the position).
---
---@field getCenter fun(self: Nyoom.Rect): Nyoom.Vector2 Returns a vector representing the center of the rect.
---@field isWithinBounds fun(self: Nyoom.Rect, point: Nyoom.Vector2): boolean Returns whether a given position is within the rect's bounds.

local methods, metamethods = {}, { __name = 'Nyoom.Rect' }

local function newRect(x, y, width, height)
  local rect = {
    position = nyoom.common.newVector2(x or 0, y or 0),
    size = nyoom.common.newVector2(width or 0, height or 0),
  }

  return setmetatable(rect, metamethods)
end

-- Methods

function methods:setPosition(x, y)
  self.position = nyoom.common.newVector2(x, y)
end

function methods:setSize(width, height)
  self.size = nyoom.common.newVector2(width, height)
end

function methods:getCenter()
  return self.position + self.size / 2
end

---@param point Nyoom.Vector2
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
  return ('%s, %s'):format(tostring(self.position), tostring(self.size))
end

return newRect