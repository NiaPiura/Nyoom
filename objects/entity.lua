---(WIP)
---@class nyoom.Entity
---@field position nyoom.Vector2
---@field components nyoom.Component[]
---
---@field update fun(self: nyoom.Entity, deltaTime: number)
---@field draw fun(self: nyoom.Entity)
---@field addComponent fun(self: nyoom.Entity, component: nyoom.Component)

---@class nyoom.Component
---@field name string
---@field entity? nyoom.Entity
---@field update? fun(self: nyoom.Component, deltaTime: number)
---@field draw? fun(self: nyoom.Component)

local methods, metamethods = {}, { __name = 'nyoom.Entity' }

---Create a new Entity.
---@return nyoom.Entity
function nyoom.objects.newEntity()
  local entity = {
    position = nyoom.objects.newVector2(),
    components = {}
  }

  setmetatable(entity, metamethods)

  return entity
end

-- Methods

---@param self nyoom.Entity
function methods:update(deltaTime)
  for _, component in ipairs(self.components) do
    if component.update then component:update(deltaTime) end
  end
end

---@param self nyoom.Entity
function methods:draw()
  for _, component in ipairs(self.components) do
    if component.draw then component:draw() end
  end
end

---@param self nyoom.Entity
function methods:addComponent(component)
  component.entity = self
  if component.init then component:init() end
  table.insert(self.components, component)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end