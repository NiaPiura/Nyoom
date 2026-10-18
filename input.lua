---@class nyoom.InputState
---@field timestamp number
---@field firstFrame boolean

---An input system for capturing keystrokes and attaching events to key combinations.
nyoom.input = {
  states = {}, ---@type { [string]: nyoom.InputState } List of all currently relevant input states that nyoom can track.
  actions = {} ---@type nyoom.InputAction[] List of all currently registered Input Actions.
}

---@param sequence string[]
---@return boolean
local function checkSequence(sequence)
    local match = true
    for _, sequenceKey in ipairs(sequence) do
      if not nyoom.input.states[sequenceKey] then match = false end
    end

    return match
end

local function onKeyDown(eventData)
  if not eventData.isRepeat then
    nyoom.input.states[eventData.key] = {
      timestamp = love.timer.getTime(),
      firstFrame = true
    }
  end
end

local function onKeyUp(eventData)
  nyoom.input.states[eventData.key] = nil
end

local function shouldActionTrigger(state, action, timestamp)
  if state.firstFrame then return true
  elseif action.options.noRepeat then return false
  elseif not action.options.useRepeatDelay then return true end

  local delay = state.timestamp + nyoom.defaults.inputRepeatDelay

  if action.options.customDelay > 0 then
    delay = state.timestamp + action.options.customDelay
  end

  if timestamp >= delay then return true
  else return false end
end

nyoom.events.eventKeyPressed:addListener(onKeyDown)
nyoom.events.eventKeyReleased:addListener(onKeyUp)

function nyoom.input.update(deltaTime)
  local timestamp = love.timer.getTime()
  for _, action in ipairs(nyoom.input.actions) do
    if checkSequence(action.sequence) then
      local state = nyoom.input.states[action.sequence[#action.sequence]]

      if shouldActionTrigger(state, action, timestamp) then
        action.callback()
      end
    end
  end

  for _, state in pairs(nyoom.input.states) do
    if state.firstFrame then
      state.firstFrame = false
    end
  end
end

---Retrieve an Input Action under the given name, or nil if it doesn't exist.
---@param name string
---@return nyoom.InputAction?
function nyoom.input.getAction(name)
  return table.find(nyoom.input.actions, function(v) return v.name == name end)
end

---Register a new Input Action, given an action under the provided `name` doesn't already exist.
---@param name string
---@param sequence string
---@param callback function
---@param options? nyoom.InputActionOptions
function nyoom.input.registerAction(name, sequence, callback, options)
  if nyoom.input.getAction(name) then return end

  options = options or {}
  options.useRepeatDelay = options.useRepeatDelay or false
  options.customDelay = options.customDelay or 0

  local action = nyoom.input.newInputAction(name, sequence, callback, options)
  table.insert(nyoom.input.actions, action)
end



---@class nyoom.InputActionOptions
---@field noRepeat boolean?
---@field useRepeatDelay boolean?
---@field customDelay number?

---(WIP)
---@class nyoom.InputAction
---@field name string The name of the Input Action.
---@field sequence string[] The sequence of inputs required to trigger the Input Action.
---@field options nyoom.InputActionOptions Additional Options for the Input Action.
---@field callback function The callback function executed when the Input Action is triggered.

local methods, metamethods = {}, { __name = 'nyoom.InputAction' }

---Create a new InputAction.
---@param name string
---@param sequence string | string[]
---@param callback function
---@param options nyoom.InputActionOptions
---@return nyoom.InputAction
function nyoom.input.newInputAction(name, sequence, callback, options)
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