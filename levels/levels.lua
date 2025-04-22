---@class Nyoom.Level

local methods, metamethods = {}, { __name = 'Nyoom.Level' }

---@class Nyoom.Levels
local levels = {
  loadedLevels = {} ---@type Nyoom.Level[]
}

function levels.update(deltaTime)

end

function levels.draw()

end

function levels.newLevel()

end

return levels