--- A 2D grid of values. Positions are 0-indexed while `map` is 1-indexed
---@class Nyoom.Grid
---@field size Nyoom.Vector2
---@field width integer
---@field height integer
---@field defaultValue any
---@field map any[]
---
---@field getPosition fun(self: Nyoom.Grid, index: integer): Nyoom.Vector2? Gets the index in the map that correlates to the given position, or nil if out of bounds.
---@field getIndex fun(self: Nyoom.Grid, x: integer, y: integer): integer? Gets the index in the map that correlates to the given position, or nil if out of bounds.
---@field setValue fun(self: Nyoom.Grid, x: integer, y: integer, value: any): Nyoom.Grid Sets a value mapped to given position. Can be chained.
---@field getValue fun(self: Nyoom.Grid, x: integer, y: integer): any Gets a value mapped to given position, or nil if out of bounds.
---@field setSize fun(self: Nyoom.Grid, width: integer, height: integer) Resizes the grid.
---@field clear fun(self: Nyoom.Grid, value: any) Clear the grid, replacing values with either given value, or `defaultValue`.

local methods, metamethods = {}, { __name = 'Nyoom.Grid' }

---@param index integer
---@param width integer
---@return integer
---@return integer
local function indexToPosition(index, width)
  return (index-1) % width, math.floor((index-1) / width)
end

---@param x integer
---@param y integer
---@param width integer
---@return integer
local function positionToIndex(x, y, width)
  return (width * y) + x + 1
end

---@param width integer
---@param height integer
---@return integer
---@return integer
local function clampDimensions(width, height)
  return math.max(width, 1), math.max(height, 1)
end

---@param width integer
---@param height integer
---@param defaultValue? number
---@return Nyoom.Grid
local function newGrid(width, height, defaultValue)
  local grid = {
    size = nyoom.common.newVector2(clampDimensions(width, height));
    defaultValue = defaultValue or 1,
    map = {}
  }

  setmetatable(grid, metamethods)

  grid:clear()

  return grid
end

-- Methods

---@param self Nyoom.Grid
function methods:getPosition(index)
  if index < 1 or index > #self.map then return end
  return nyoom.common.newVector2(indexToPosition(index, self.width))
end

---@param self Nyoom.Grid
function methods:getIndex(x, y)
  if x < 0 or x > self.width - 1 or y < 0 or y > self.height - 1 then return end
  return positionToIndex(x, y, self.width)
end

---@param self Nyoom.Grid
function methods:setValue(x, y, value)
  local index = self:getIndex(x, y)
  if index then self.map[index] = value end
  return self
end

---@param self Nyoom.Grid
function methods:getValue(x, y)
  local index = self:getIndex(x, y)
  return self.map[index]
end

---@param self Nyoom.Grid
function methods:setSize(width, height)
  width, height = clampDimensions(width, height)
  local map = {}

  for x = 0, width - 1 do
    for y = 0, height - 1 do
      local value = self:getValue(x, y)
      map[(width * y) + x + 1] = value or self.defaultValue
    end
  end

  self.size = nyoom.common.newVector2(width, height)
  self.map = map
end

---@param self Nyoom.Grid
function methods:clear(value)
  value = value or self.defaultValue
  for i = 1, self.width * self.height do
    self.map[i] = value
  end
end

-- Metamethods

function metamethods:__index(key)
  if key == 'width' then return self.size.width end
  if key == 'height' then return self.size.height end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'width' then self:setSize(value, self.size.height)
  elseif key == 'height' then self:setSize(self.size.width, value)
  else rawset(self, key, value) end
end

return newGrid