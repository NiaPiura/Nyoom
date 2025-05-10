local newLevel = require('nyoom.levels.level')

---@class Nyoom.Levels
---@field update fun(deltaTime: number)
---@field draw fun()
---@field setActive fun(name: string)
---@field setActive fun(level: Nyoom.Level)
---@field newLevel fun(name: string): Nyoom.Level
local levels = {
  loadedLevels = {}, ---@type Nyoom.Level[]
  activeLevel = nil ---@type Nyoom.Level
}

function levels.update(deltaTime)
  if levels.activeLevel then levels.activeLevel:update(deltaTime) end
end

function levels.draw()
  if levels.activeLevel then levels.activeLevel:draw() end
end

function levels.setActive(level)
  if type(level) == 'string' then level = table.find(levels.loadedLevels, function(v) return v.name == level end) end
  if level then levels.activeLevel = level end
end

function levels.newLevel(name)
  local level = newLevel(name)
  table.insert(levels.loadedLevels, level)
  return level
end

return levels