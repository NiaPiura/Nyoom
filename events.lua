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



---@class Nyoom.Events
---@field newEvent fun(): Nyoom.Event
local events = {}
function events.newEvent() return newEvent() end

-- Register Löve2D callbacks as events.
-- General

events.quitEvent = newEvent()              function love.quit(...)             events.quitEvent:trigger(...)              end
events.directoryDroppedEvent = newEvent()  function love.directorydropped(...) events.directoryDroppedEvent:trigger(...)  end
events.fileDroppedEvent = newEvent()       function love.filedropped(...)      events.fileDroppedEvent:trigger(...)       end
events.focusEvent = newEvent()             function love.focus(...)            events.focusEvent:trigger(...)             end
events.mouseFocusEvent = newEvent()        function love.mousefocus(...)       events.mouseFocusEvent:trigger(...)        end
events.resizeEvent = newEvent()            function love.resize(...)           events.resizeEvent:trigger(...)            end
events.visibleEvent = newEvent()           function love.visible(...)          events.visibleEvent:trigger(...)           end

-- Keyboard

events.keyPressedEvent = newEvent()        function love.keypressed(...)       events.keyPressedEvent:trigger(...)        end
events.keyReleasedEvent = newEvent()       function love.keyreleased(...)      events.keyReleasedEvent:trigger(...)       end
events.textEditedEvent = newEvent()        function love.textedited(...)       events.textEditedEvent:trigger(...)        end
events.textInputEvent = newEvent()         function love.textinput(...)        events.textInputEvent:trigger(...)         end

-- Mouse

events.mouseMovedEvent = newEvent()        function love.mousemoved(...)       events.mouseMovedEvent:trigger(...)        end
events.mousePressedEvent = newEvent()      function love.mousepressed(...)     events.mousePressedEvent:trigger(...)      end
events.mouseReleasedEvent = newEvent()     function love.mousereleased(...)    events.mouseReleasedEvent:trigger(...)     end
events.wheelMovedEvent = newEvent()        function love.wheelmoved(...)       events.wheelMovedEvent:trigger(...)        end

-- Joystick

events.gamepadAxisEvent = newEvent()       function love.gamepadaxis(...)      events.gamepadAxisEvent:trigger(...)       end
events.gamepadPressedEvent = newEvent()    function love.gamepadpressed(...)   events.gamepadPressedEvent:trigger(...)    end
events.gamepadReleasedEvent = newEvent()   function love.gamepadreleased(...)  events.gamepadReleasedEvent:trigger(...)   end
events.joystickAddedEvent = newEvent()     function love.joystickadded(...)    events.joystickAddedEvent:trigger(...)     end
events.joystickRemovedEvent = newEvent()   function love.joystickremoved(...)  events.joystickRemovedEvent:trigger(...)   end
events.joystickAxisEvent = newEvent()      function love.joystickaxis(...)     events.joystickAxisEvent:trigger(...)      end
events.joystickHatEvent = newEvent()       function love.joystickhat(...)      events.joystickHatEvent:trigger(...)       end

return events