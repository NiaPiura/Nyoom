---@class nyoom.InputActionOptions
---@field useRepeatDelay boolean?
---@field customDelay number?

---@class Nyoom.InputAction
---@field name string The name of the Input Action.
---@field sequence string[] The sequence of inputs required to trigger the Input Action.
---@field options nyoom.InputActionOptions Additional Options for the Input Action.
---@field callback function The callback function executed when the Input Action is triggered.

local methods, metamethods = {}, { __name = 'Nyoom.InputAction' }

---Create a new InputAction
---@param name string
---@param sequence string | string[]
---@param callback function
---@param options nyoom.InputActionOptions
---@return Nyoom.InputAction
local function newInputAction(name, sequence, callback, options)
  if type(sequence) == 'string' then sequence = string.split(string.lower(sequence), '+') end

  local inputAction = {
    name = name,
    sequence = sequence,
    options = options,
    callback = callback
  }

  setmetatable(inputAction, metamethods)

  return inputAction
end

---@class Nyoom.InputState
---@field timestamp number
---@field firstFrame boolean

---@class Nyoom.Input
---@field repeatDelay number The delay in seconds before a held input starts repeating.
---@field states { [string]: Nyoom.InputState } List of all currently relevant input states that Nyoom can track.
---@field actions Nyoom.InputAction[] List of all currently registered Input Actions.
local input = {
  repeatDelay = 0.4,
  states = {},
  actions = {}
}

---@param sequence string[]
---@return boolean
local function checkSequence(sequence)
    local match = true
    for _, sequenceKey in ipairs(sequence) do
      if not input.states[sequenceKey] then match = false end
    end

    return match
end

local function onKeyDown(key, _, isRepeat)
  if not isRepeat then
    input.states[key] = {
      timestamp = love.timer.getTime(),
      firstFrame = true
    }
  end
end

local function onKeyUp(key)
  input.states[key] = nil
end

nyoom.events.keyPressed:addListener(onKeyDown)
nyoom.events.keyReleased:addListener(onKeyUp)

function input.update(dt)
  local timestamp = love.timer.getTime()
  for _, action in ipairs(input.actions) do
    if checkSequence(action.sequence) then
      local state = input.states[action.sequence[#action.sequence]]
      local delay = state.timestamp + input.repeatDelay

      if action.options.customDelay > 0 then
        delay = state.timestamp + action.options.customDelay
      end

      if state.firstFrame or not action.options.useRepeatDelay or
      (action.options.useRepeatDelay and timestamp >= delay) then
        action.callback()
      end
    end
  end

  for _, state in pairs(input.states) do
    if state.firstFrame then
      state.firstFrame = false
    end
  end
end

---Retrieve an Input Action under the given name, or nil if it doesn't exist.
---@param name string
---@return Nyoom.InputAction?
function input.getAction(name)
  return table.find(input.actions, function(v) return v.name == name end)
end

---Register a new Input Action, given an action under the provided `name` doesn't already exist.
---@param name string
---@param sequence string
---@param callback function
---@param options? nyoom.InputActionOptions
function input.registerAction(name, sequence, callback, options)
  if input.getAction(name) then return end

  options = options or {}
  options.useRepeatDelay = options.useRepeatDelay or false
  options.customDelay = options.customDelay or 0

  local action = newInputAction(name, sequence, callback, options)
  table.insert(input.actions, action)
end

return input