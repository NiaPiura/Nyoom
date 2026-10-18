---@diagnostic disable: invisible

---A system for defining events that can be listened to. Implements events for all `love` callbacks.
nyoom.events = {}

---An object that can have listener functions attached, which will all be called with a payload when the event is triggered.
---@class nyoom.Event<T>
---@field private idIndex integer The internal rolling id to assign to added listeners, such that they can be referred to again.
---@field private listeners nyoom.EventListener[] List of listeners with their assigned rolling id.
---
---@field addListener fun(self: nyoom.Event, func: fun(eventData: T)): integer Add a listener; A function that gets callen when this event is triggered.
---@field removeListener fun(self: nyoom.Event, id: integer): boolean Remove a listener using the id given when adding said listener.
---@field trigger fun(self: nyoom.Event, ...: any) Trigger the event, passing any arguments to all listeners.

---@class nyoom.EventListener
---@field id integer
---@field func fun(...: any)

local methods, metamethods = {}, { __name = 'nyoom.Event' }

---Creates a new Event.
---@return nyoom.Event
function nyoom.events.newEvent()
  local event = {
    idIndex = 0,
    listeners = {}
  }

  setmetatable(event, metamethods)

  return event
end

-- Methods

---@param self nyoom.Event
function methods:addListener(func)
  self.idIndex = self.idIndex + 1
  table.insert(self.listeners, { id = self.idIndex, func = func})
  return self.idIndex
end

---@param self nyoom.Event
function methods:removeListener(id)
  local _, index = table.ifind(self.listeners, function(value) return value.id == id end)
  if index then
    table.remove(self.listeners, index)
    return true
  else return false end
end

---@param self nyoom.Event
function methods:trigger(...)
  for _, listener in ipairs(self.listeners) do listener.func(...) end
end

-- metamethods

function metamethods:__index(key)
  return methods[key]
end


-- Register Löve2D callbacks as events.
-- General

nyoom.events.eventQuit = nyoom.events.newEvent()              ---@type nyoom.Event
nyoom.events.eventDirectoryDropped = nyoom.events.newEvent()  ---@type nyoom.Event<{ path: string }>
nyoom.events.eventFileDropped = nyoom.events.newEvent()       ---@type nyoom.Event<{ file: love.DroppedFile }>
nyoom.events.eventFocus = nyoom.events.newEvent()             ---@type nyoom.Event<{ focus: boolean }>
nyoom.events.eventMouseFocus = nyoom.events.newEvent()        ---@type nyoom.Event<{ focus: boolean }>
nyoom.events.eventResize = nyoom.events.newEvent()            ---@type nyoom.Event<{ dimensions: nyoom.Vector2 }>
nyoom.events.eventVisible = nyoom.events.newEvent()           ---@type nyoom.Event<{ visible: boolean }>

function love.quit()                                          nyoom.events.eventQuit:trigger() end
function love.directorydropped(a)                             nyoom.events.eventDirectoryDropped:trigger({ path = a }) end
function love.filedropped(a)                                  nyoom.events.eventFileDropped:trigger({ file = a }) end
function love.focus(a)                                        nyoom.events.eventFocus:trigger({ focus = a }) end
function love.mousefocus(a)                                   nyoom.events.eventMouseFocus:trigger({ focus = a }) end
function love.resize(a, b)                                    nyoom.events.eventResize:trigger({ dimensions = nyoom.objects.newVector2(a, b) }) end
function love.visible(a)                                      nyoom.events.eventVisible:trigger({ visible = a }) end

-- Keyboard

nyoom.events.eventKeyPressed = nyoom.events.newEvent()        ---@type nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode, isRepeat: boolean }>
nyoom.events.eventKeyReleased = nyoom.events.newEvent()       ---@type nyoom.Event<{ key: love.KeyConstant, scancode: love.Scancode }>
nyoom.events.eventTextEdited = nyoom.events.newEvent()        ---@type nyoom.Event<{ text: string, start: number, length: number }>
nyoom.events.eventTextInput = nyoom.events.newEvent()         ---@type nyoom.Event<{ text: string }>

function love.keypressed(a, b, c)                             nyoom.events.eventKeyPressed:trigger({ key = a, scancode = b, isRepeat = c }) end
function love.keyreleased(a, b)                               nyoom.events.eventKeyReleased:trigger({ key = a, scancode = b }) end
function love.textedited(a, b, c)                             nyoom.events.eventTextEdited:trigger({ text = a, start = b, length = c }) end
function love.textinput(a)                                    nyoom.events.eventTextInput:trigger({ text = a }) end

-- Mouse

nyoom.events.eventMouseMoved = nyoom.events.newEvent()        ---@type nyoom.Event<{ position: nyoom.Vector2, delta: nyoom.Vector2 }>
nyoom.events.eventMousePressed = nyoom.events.newEvent()      ---@type nyoom.Event<{ position: nyoom.Vector2, button: number, presses: number }>
nyoom.events.eventMouseReleased = nyoom.events.newEvent()     ---@type nyoom.Event<{ position: nyoom.Vector2, button: number, presses: number }>
nyoom.events.eventWheelMoved = nyoom.events.newEvent()        ---@type nyoom.Event<{ direction: nyoom.Vector2 }>

function love.mousemoved(a, b, c, d)                          nyoom.events.eventMouseMoved:trigger({ position = nyoom.objects.newVector2(a, b), delta = nyoom.objects.newVector2(c, d)}) end
function love.mousepressed(a, b, c, _, d)                     nyoom.events.eventMousePressed:trigger({ position = nyoom.objects.newVector2(a, b), button = c, presses = d }) end
function love.mousereleased(a, b, c, _, d)                    nyoom.events.eventMouseReleased:trigger({ position = nyoom.objects.newVector2(a, b), button = c, presses = d }) end
function love.wheelmoved(a, b)                                nyoom.events.eventWheelMoved:trigger({ direction = nyoom.objects.newVector2(a, b) }) end

-- Joystick

nyoom.events.eventGamepadAxis = nyoom.events.newEvent()       ---@type nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
nyoom.events.eventGamepadPressed = nyoom.events.newEvent()    ---@type nyoom.Event<{ joystick: love.Joystick, value: number }>
nyoom.events.eventGamepadReleased = nyoom.events.newEvent()   ---@type nyoom.Event<{ joystick: love.Joystick, value: number }>
nyoom.events.eventJoystickPressed = nyoom.events.newEvent()   ---@type nyoom.Event<{ joystick: love.Joystick, value: number }>
nyoom.events.eventJoystickReleased = nyoom.events.newEvent()  ---@type nyoom.Event<{ joystick: love.Joystick, value: number }>
nyoom.events.eventJoystickAxis = nyoom.events.newEvent()      ---@type nyoom.Event<{ joystick: love.Joystick, axis: love.GamepadAxis, value: number }>
nyoom.events.eventJoystickHat = nyoom.events.newEvent()       ---@type nyoom.Event<{ joystick: love.Joystick, hat: number, direction: love.JoystickHat }>
nyoom.events.eventJoystickAdded = nyoom.events.newEvent()     ---@type nyoom.Event<{ joystick: love.Joystick }>
nyoom.events.eventJoystickRemoved = nyoom.events.newEvent()   ---@type nyoom.Event<{ joystick: love.Joystick }>

function love.gamepadaxis(a, b, c)                            nyoom.events.eventGamepadAxis:trigger({ joystick = a, axis = b, value = c }) end
function love.gamepadpressed(a, b)                            nyoom.events.eventGamepadPressed:trigger({ joystick = a, value = b }) end
function love.gamepadreleased(a, b)                           nyoom.events.eventGamepadReleased:trigger({ joystick = a, value = b }) end
function love.joystickpressed(a, b)                           nyoom.events.eventJoystickPressed:trigger({ joystick = a, value = b }) end
function love.joystickReleased(a, b)                          nyoom.events.eventJoystickReleased:trigger({ joystick = a, value = b }) end
function love.joystickaxis(a, b, c)                           nyoom.events.eventJoystickAxis:trigger({ joystick = a, axis = b, value = c }) end
function love.joystickhat(a, b, c)                            nyoom.events.eventJoystickHat:trigger({ joystick = a, hat = b, direction = c }) end
function love.joystickadded(a)                                nyoom.events.eventJoystickAdded:trigger({ joystick = a }) end
function love.joystickremoved(a)                              nyoom.events.eventJoystickRemoved:trigger({ joystick = a }) end