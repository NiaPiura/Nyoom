---@diagnostic disable: invisible

---@class Nyoom.Event
---@field private idIndex integer The internal rolling id to assign to added listeners, such that they can be referred to again.
---@field private listeners Nyoom.EventListener[] List of listeners with their assigned rolling id.
---
---@field addListener fun(self: Nyoom.Event, func: fun(...: any)): integer Add a listener; A function that gets callen when this event is triggered.
---@field removeListener fun(self: Nyoom.Event, id: integer): boolean Remove a listener using the id given when adding said listener.
---@field trigger fun(self: Nyoom.Event, ...: any) Trigger the event, passing any arguments to all listeners.

---@class Nyoom.EventListener
---@field id integer
---@field func fun(...: any)

local methods, metamethods = {}, { __name = 'Nyoom.Event' }

---Creates a new `Event`.
---@return Nyoom.Event
local function newEvent()
  local event = {
    idIndex = 0,
    listeners = {}
  }

  setmetatable(event, metamethods)

  return event
end

-- Methods

---@param self Nyoom.Event
function methods:addListener(func)
  self.idIndex = self.idIndex + 1
  table.insert(self.listeners, { id = self.idIndex, func = func})
  return self.idIndex
end

---@param self Nyoom.Event
function methods:removeListener(id)
  local _, index = table.ifind(self.listeners, function(value) return value == id end)
  if index then
    table.remove(self.listeners, index)
    return true
  else return false end
end

---@param self Nyoom.Event
function methods:trigger(...)
  for _, listener in ipairs(self.listeners) do listener.func(...) end
end

-- metamethods

function metamethods:__index(key)
  return methods[key]
end

return newEvent