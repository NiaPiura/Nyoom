--- (WIP)
nyoom.levels = {
  loadedLevels = {}, ---@type nyoom.Level[]
  activeLevel = nil ---@type nyoom.Level?
}

local newLevel = require('nyoom.levels.level')

function nyoom.levels.update(deltaTime)
  if nyoom.levels.activeLevel then nyoom.levels.activeLevel:update(deltaTime) end
end

function nyoom.levels.draw()
  if nyoom.levels.activeLevel then nyoom.levels.activeLevel:draw() end
end

function nyoom.levels.setActive(level)
  if type(level) == 'string' then level = table.find(nyoom.levels.loadedLevels, function(v) return v.name == level end) end
  if level then nyoom.levels.activeLevel = level end
end

function nyoom.levels.newLevel(name)
  local level = newLevel(name)
  table.insert(nyoom.levels.loadedLevels, level)
  return level
end