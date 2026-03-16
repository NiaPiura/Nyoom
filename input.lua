---@class Nyoom.InputAction

local function newInputAction()

end


---@class Nyoom.Input
---@field inputStates { [string]: number }
local input = {
  inputStates = {}
}

local function onKeyDown(key, _, isRepeat)
  if not isRepeat then input.inputStates[key] = love.timer.getTime() end
end

local function onKeyUp(key)
  input.inputStates[key] = nil
end

nyoom.events.keyPressed:addListener(onKeyDown)
nyoom.events.keyReleased:addListener(onKeyUp)

function input.registerAction(name, sequence, callback)

end

return input