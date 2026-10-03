---@diagnostic disable: invisible

---@class Nyoom.Event<T>
---@field private idIndex integer The internal rolling id to assign to added listeners, such that they can be referred to again.
---@field private listeners Nyoom.EventListener[] List of listeners with their assigned rolling id.
---
---@field addListener fun(self: Nyoom.Event, func: fun(eventData: T)): integer Add a listener; A function that gets callen when this event is triggered.
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
  local _, index = table.ifind(self.listeners, function(value) return value.id == id end)
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

events.eventQuit = newEvent()               ---@type Nyoom.Event
events.eventDirectoryDropped = newEvent()   ---@type Nyoom.Event<{ path: string }>
events.eventFileDropped = newEvent()        ---@type Nyoom.Event<{ file: love.DroppedFile }>
events.eventFocus = newEvent()              ---@type Nyoom.Event<{ focus: boolean }>
events.eventMouseFocus = newEvent()         ---@type Nyoom.Event<{ focus: boolean }>
events.eventResize = newEvent()             ---@type Nyoom.Event<{ dimensions: Nyoom.Vector2 }>
events.eventVisible = newEvent()            ---@type Nyoom.Event<{ visible: boolean }>

function love.quit()                        events.eventQuit:trigger() end
function love.directorydropped(a)           events.eventDirectoryDropped:trigger({ path = a }) end
function love.filedropped(a)                events.eventFileDropped:trigger({ file = a }) end
function love.focus(a)                      events.eventFocus:trigger({ focus = a }) end
function love.mousefocus(a)                 events.eventMouseFocus:trigger({ focus = a }) end
function love.resize(a, b)                  events.eventResize:trigger({ dimensions = nyoom.common.newVector2(a, b) }) end
function love.visible(a)                    events.eventVisible:trigger({ visible = a }) end

-- Keyboard

events.eventKeyPressed = newEvent()         ---@type Nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode, isRepeat: boolean }>
events.eventKeyReleased = newEvent()        ---@type Nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode }>
events.eventTextEdited = newEvent()         ---@type Nyoom.Event<{ text: string, start: number, length: number }>
events.eventTextInput = newEvent()          ---@type Nyoom.Event<{ text: string }>

function love.keypressed(a, b, c)           events.eventKeyPressed:trigger({ key = a, scancode = b, isRepeat = c }) end
function love.keyreleased(a, b)             events.eventKeyReleased:trigger({ key = a, scancode = b }) end
function love.textedited(a, b, c)           events.eventTextEdited:trigger({ text = a, start = b, length = c }) end
function love.textinput(a)                  events.eventTextInput:trigger({ text = a }) end

-- Mouse

events.eventMouseMoved = newEvent()         ---@type Nyoom.Event<{ position: Nyoom.Vector2, delta: Nyoom.Vector2 }>
events.eventMousePressed = newEvent()       ---@type Nyoom.Event<{ position: Nyoom.Vector2, button: number, presses: number }>
events.eventMouseReleased = newEvent()      ---@type Nyoom.Event<{ position: Nyoom.Vector2, button: number, presses: number }>
events.eventWheelMoved = newEvent()         ---@type Nyoom.Event<{ direction: Nyoom.Vector2 }>

function love.mousemoved(a, b, c, d)        events.eventMouseMoved:trigger({ position = nyoom.common.newVector2(a, b), delta = nyoom.common.newVector2(c, d)}) end
function love.mousepressed(a, b, c, _, d)   events.eventMousePressed:trigger({ position = nyoom.common.newVector2(a, b), button = c, presses = d }) end
function love.mousereleased(a, b, c, _, d)  events.eventMouseReleased:trigger({ position = nyoom.common.newVector2(a, b), button = c, presses = d }) end
function love.wheelmoved(a, b)              events.eventWheelMoved:trigger({ direction = nyoom.common.newVector2(a, b) }) end

-- Joystick

events.eventGamepadAxis = newEvent()        ---@type Nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
events.eventGamepadPressed = newEvent()     ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.eventGamepadReleased = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.eventJoystickPressed = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.eventJoystickReleased = newEvent()   ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.eventJoystickAxis = newEvent()       ---@type Nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
events.eventJoystickHat = newEvent()        ---@type Nyoom.Event<{ joystick: love.Joystick, hat: number, direction: love.JoystickHat }>
events.eventJoystickAdded = newEvent()      ---@type Nyoom.Event<{ joystick: love.Joystick }>
events.eventJoystickRemoved = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick }>

function love.gamepadaxis(a, b, c)          events.eventGamepadAxis:trigger({ joystick = a, axis = b, value = c }) end
function love.gamepadpressed(a, b)          events.eventGamepadPressed:trigger({ joystick = a, value = b }) end
function love.gamepadreleased(a, b)         events.eventGamepadReleased:trigger({ joystick = a, value = b }) end
function love.joystickpressed(a, b)         events.eventJoystickPressed:trigger({ joystick = a, value = b }) end
function love.joystickReleased(a, b)        events.eventJoystickReleased:trigger({ joystick = a, value = b }) end
function love.joystickaxis(a, b, c)         events.eventJoystickAxis:trigger({ joystick = a, axis = b, value = c }) end
function love.joystickhat(a, b, c)          events.eventJoystickHat:trigger({ joystick = a, hat = b, direction = c }) end
function love.joystickadded(a)              events.eventJoystickAdded:trigger({ joystick = a }) end
function love.joystickremoved(a)            events.eventJoystickRemoved:trigger({ joystick = a }) end

return events