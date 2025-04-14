---Nyoom event system. Allows for registering and listening to both Löve2D and user-made events.
---@class Events
---@field register fun(name: string) Register a new event handle.
---@field listen fun(name: string, func: fun(...)) Add a listener to an event handle.
---@field fire fun(name: string, ...) Fires an event and passes additional argument to all listeners.
local events = {}

local registeredEvents = {}

function events.register(name)
  if registeredEvents[name] then return print(('Event %s already registered'):format(name)) end
  registeredEvents[name] = {}
end

function events.listen(name, func)
  if not registeredEvents[name] then return print(('Event %s not registered'):format(name)) end
  table.insert(registeredEvents[name], func)
end

function events.fire(name, ...)
  if not registeredEvents[name] then return print(('Event %s not registered'):format(name)) end
  for _, func in ipairs(registeredEvents[name]) do func(...) end
end

---Automatically register Löve2D handles as events.
---@diagnostic disable-next-line: undefined-field
for name, _ in pairs(love.handlers) do
  events.register('love.' .. name)
  love[name] = function(...) events.fire('love.' .. name, ...) end
end

return events
