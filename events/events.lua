local newEvent = require('nyoom.events.event')

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