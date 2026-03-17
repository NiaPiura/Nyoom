---@class Nyoom.InputAction
---@field name string The name of the Input Action.
---@field sequence string[] The sequence of inputs required to trigger the Input Action.
---@field callback function The callback function executed when the Input Action is triggered.

local methods, metamethods = {}, { __name = 'Nyoom.InputAction' }

---Create a new InputAction
---@param name string
---@param sequence string | string[]
---@param callback function
---@return Nyoom.InputAction
local function newInputAction(name, sequence, callback)
  if type(sequence) == 'string' then sequence = string.split(string.lower(sequence), '+') end

  local inputAction = {
    name = name,
    sequence = sequence,
    callback = callback
  }

  setmetatable(inputAction, metamethods)

  return inputAction
end


---@class Nyoom.Input
---@field states { [string]: number } List of all currently relevant input states that Nyoom can track.
---@field actions Nyoom.InputAction[] List of all currently registered Input Actions.
local input = {
  states = {},
  actions = {}
}

local function onKeyDown(key, _, isRepeat)
  if not isRepeat then input.states[key] = love.timer.getTime() end

  for _, action in ipairs(input.actions) do
    local match = true
    for _, sequenceKey in ipairs(action.sequence) do
      if not input.states[sequenceKey] then match = false end
    end

    if match then action.callback() end
  end
end

local function onKeyUp(key)
  input.states[key] = nil
end

nyoom.events.keyPressed:addListener(onKeyDown)
nyoom.events.keyReleased:addListener(onKeyUp)

function input.getAction(name)
  return table.find(input.actions, function(v) return v.name == name end)
end

function input.registerAction(name, sequence, callback)
  if input.getAction(name) then return end

  local action = newInputAction(name, sequence, callback)
  table.insert(input.actions, action)
end

return input