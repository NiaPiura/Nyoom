---An Axis Aligned Bounding Box (AABB), internally represented by two vectors
---@class Nyoom.Rect
---@field x number
---@field y number
---@field width number
---@field height number
---@field position Nyoom.Vector2
---@field size Nyoom.Vector2
---
---@field getCenter fun(self: Nyoom.Rect): Nyoom.Vector2
---@field isWithinBounds fun(self: Nyoom.Rect, point: Nyoom.Vector2): boolean

local methods, metamethods = {}, { __name = 'Nyoom.Rect' }

local function newRect(x, y, width, height)
  local rect = {
    position = nyoom.common.newVector2(x or 0, y or 0),
    size = nyoom.common.newVector2(width or 0, height or 0),
  }

  return setmetatable(rect, metamethods)
end

-- Methods

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

function metamethods:__newindex() end

function metamethods:__tostring()
  return ('p%s s%s'):format(tostring(self.position), tostring(self.size))
end

return newRect