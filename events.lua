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

events.quit = newEvent()              function love.quit(...)             events.quit:trigger(...)              end
events.directoryDropped = newEvent()  function love.directorydropped(...) events.directoryDropped:trigger(...)  end
events.fileDropped = newEvent()       function love.filedropped(...)      events.fileDropped:trigger(...)       end
events.focus = newEvent()             function love.focus(...)            events.focus:trigger(...)             end
events.mouseFocus = newEvent()        function love.mousefocus(...)       events.mouseFocus:trigger(...)        end
events.resize = newEvent()            function love.resize(...)           events.resize:trigger(...)            end
events.visible = newEvent()           function love.visible(...)          events.visible:trigger(...)           end

-- Keyboard

events.keyPressed = newEvent()        function love.keypressed(...)       events.keyPressed:trigger(...)        end
events.keyReleased = newEvent()       function love.keyreleased(...)      events.keyReleased:trigger(...)       end
events.textEdited = newEvent()        function love.textedited(...)       events.textEdited:trigger(...)        end
events.textInput = newEvent()         function love.textinput(...)        events.textInput:trigger(...)         end

-- Mouse

events.mouseMoved = newEvent()        function love.mousemoved(...)       events.mouseMoved:trigger(...)        end
events.mousePressed = newEvent()      function love.mousepressed(...)     events.mousePressed:trigger(...)      end
events.mouseReleased = newEvent()     function love.mousereleased(...)    events.mouseReleased:trigger(...)     end
events.wheelMoved = newEvent()        function love.wheelmoved(...)       events.wheelMoved:trigger(...)        end

-- Joystick

events.gamepadAxis = newEvent()       function love.gamepadaxis(...)      events.gamepadAxis:trigger(...)       end
events.gamepadPressed = newEvent()    function love.gamepadpressed(...)   events.gamepadPressed:trigger(...)    end
events.gamepadReleased = newEvent()   function love.gamepadreleased(...)  events.gamepadReleased:trigger(...)   end
events.joystickAdded = newEvent()     function love.joystickadded(...)    events.joystickAdded:trigger(...)     end
events.joystickRemoved = newEvent()   function love.joystickremoved(...)  events.joystickRemoved:trigger(...)   end
events.joystickAxis = newEvent()      function love.joystickaxis(...)     events.joystickAxis:trigger(...)      end
events.joystickHat = newEvent()       function love.joystickhat(...)      events.joystickHat:trigger(...)       end

return events