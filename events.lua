---@diagnostic disable: invisible

---@class Nyoom.Event<T>
---@field private idIndex integer The internal rolling id to assign to added listeners, such that they can be referred to again.
---@field private listeners Nyoom.EventListener[] List of listeners with their assigned rolling id.
---
---@field addListener fun(self: Nyoom.Event, func: fun(eventValues: T)): integer Add a listener; A function that gets callen when this event is triggered.
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

events.quitEvent = newEvent()               ---@type Nyoom.Event
events.directoryDroppedEvent = newEvent()   ---@type Nyoom.Event<{ path: string }>
events.fileDroppedEvent = newEvent()        ---@type Nyoom.Event<{ file: love.DroppedFile }>
events.focusEvent = newEvent()              ---@type Nyoom.Event<{ focus: boolean }>
events.mouseFocusEvent = newEvent()         ---@type Nyoom.Event<{ focus: boolean }>
events.resizeEvent = newEvent()             ---@type Nyoom.Event<{ dimensions: Nyoom.Vector2 }>
events.visibleEvent = newEvent()            ---@type Nyoom.Event<{ visible: boolean }>

function love.quit()                        events.quitEvent:trigger() end
function love.directorydropped(a)           events.directoryDroppedEvent:trigger({ path = a }) end
function love.filedropped(a)                events.fileDroppedEvent:trigger({ file = a }) end
function love.focus(a)                      events.focusEvent:trigger({ focus = a }) end
function love.mousefocus(a)                 events.mouseFocusEvent:trigger({ focus = a }) end
function love.resize(a, b)                  events.resizeEvent:trigger({ dimensions = nyoom.common.newVector2(a, b) }) end
function love.visible(a)                    events.visibleEvent:trigger({ visible = a }) end

-- Keyboard

events.keyPressedEvent = newEvent()         ---@type Nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode, isRepeat: boolean }>
events.keyReleasedEvent = newEvent()        ---@type Nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode }>
events.textEditedEvent = newEvent()         ---@type Nyoom.Event<{ text: string, start: number, length: number }>
events.textInputEvent = newEvent()          ---@type Nyoom.Event<{ text: string }>

function love.keypressed(a, b, c)           events.keyPressedEvent:trigger({ key = a, scancode = b, isRepeat = c }) end
function love.keyreleased(a, b)             events.keyReleasedEvent:trigger({ key = a, scancode = b }) end
function love.textedited(a, b, c)           events.textEditedEvent:trigger({ text = a, start = b, length = c }) end
function love.textinput(a)                  events.textInputEvent:trigger({ text = a }) end

-- Mouse

events.mouseMovedEvent = newEvent()         ---@type Nyoom.Event<{ position: Nyoom.Vector2, delta: Nyoom.Vector2 }>
events.mousePressedEvent = newEvent()       ---@type Nyoom.Event<{ position: Nyoom.Vector2, button: number, presses: number }>
events.mouseReleasedEvent = newEvent()      ---@type Nyoom.Event<{ position: Nyoom.Vector2, button: number, presses: number }>
events.wheelMovedEvent = newEvent()         ---@type Nyoom.Event<{ direction: Nyoom.Vector2 }>

function love.mousemoved(a, b, c, d)        events.mouseMovedEvent:trigger({ position = nyoom.common.newVector2(a, b), delta = nyoom.common.newVector2(c, d)}) end
function love.mousepressed(a, b, c, _, d)   events.mousePressedEvent:trigger({ position = nyoom.common.newVector2(a, b), button = c, presses = d }) end
function love.mousereleased(a, b, c, _, d)  events.mouseReleasedEvent:trigger({ position = nyoom.common.newVector2(a, b), button = c, presses = d }) end
function love.wheelmoved(a, b)              events.wheelMovedEvent:trigger({ direction = nyoom.common.newVector2(a, b) }) end

-- Joystick

events.gamepadAxisEvent = newEvent()        ---@type Nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
events.gamepadPressedEvent = newEvent()     ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.gamepadReleasedEvent = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.joystickPressedEvent = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.joystickReleasedEvent = newEvent()   ---@type Nyoom.Event<{ joystick: love.Joystick, value: number }>
events.joystickAxisEvent = newEvent()       ---@type Nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
events.joystickHatEvent = newEvent()        ---@type Nyoom.Event<{ joystick: love.Joystick, hat: number, direction: love.JoystickHat }>
events.joystickAddedEvent = newEvent()      ---@type Nyoom.Event<{ joystick: love.Joystick }>
events.joystickRemovedEvent = newEvent()    ---@type Nyoom.Event<{ joystick: love.Joystick }>

function love.gamepadaxis(a, b, c)          events.gamepadAxisEvent:trigger({ joystick = a, axis = b, value = c }) end
function love.gamepadpressed(a, b)          events.gamepadPressedEvent:trigger({ joystick = a, value = b }) end
function love.gamepadreleased(a, b)         events.gamepadReleasedEvent:trigger({ joystick = a, value = b }) end
function love.joystickpressed(a, b)         events.joystickPressedEvent:trigger({ joystick = a, value = b }) end
function love.joystickReleased(a, b)        events.joystickReleasedEvent:trigger({ joystick = a, value = b }) end
function love.joystickaxis(a, b, c)         events.joystickAxisEvent:trigger({ joystick = a, axis = b, value = c }) end
function love.joystickhat(a, b, c)          events.joystickHatEvent:trigger({ joystick = a, hat = b, direction = c }) end
function love.joystickadded(a)              events.joystickAddedEvent:trigger({ joystick = a }) end
function love.joystickremoved(a)            events.joystickRemovedEvent:trigger({ joystick = a }) end

return events