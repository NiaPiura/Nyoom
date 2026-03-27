---@class Nyoom.Entity
---@field position Nyoom.Vector2
---@field components Nyoom.Component[]
---
---@field update fun(self: Nyoom.Entity, deltaTime: number)
---@field draw fun(self: Nyoom.Entity)
---@field addComponent fun(self: Nyoom.Entity, component: Nyoom.Component)

---@class Nyoom.Component
---@field name string
---@field entity? Nyoom.Entity
---@field update? fun(self: Nyoom.Component, deltaTime: number)
---@field draw? fun(self: Nyoom.Component)

local methods, metamethods = {}, { __name = 'Nyoom.Entity' }

---@return Nyoom.Entity
local function newEntity()
  local entity = {
    position = nyoom.common.newVector2(),
    components = {}
  }

  setmetatable(entity, metamethods)

  return entity
end

-- Methods

---@param self Nyoom.Entity
function methods:update(deltaTime)
  for _, component in ipairs(self.components) do
    print('test')
    if component.update then component:update(deltaTime) end
  end
end

---@param self Nyoom.Entity
function methods:draw()
  for _, component in ipairs(self.components) do
    if component.draw then component:draw() end
  end
end

---@param self Nyoom.Entity
function methods:addComponent(component)
  component.entity = self
  if component.init then component:init() end
  table.insert(self.components, component)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newEntity