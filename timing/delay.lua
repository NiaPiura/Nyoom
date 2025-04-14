---Allows for delayed execution of a given function.
---@class Delay
---@field duration number
---@field position number
---@field onFinish fun(self: Delay): Delay
---
---@field set fun(self: Delay, remainder: number): Delay Sets the current delay's remaining time.
---@field finish fun(self: Delay): Delay Finish the Delay.
---@field start fun(self: Delay): Delay Add delay into activeDelays.
---@field stop fun(self: Delay): Delay Remove tween from activeDelays.
---@field restart fun(self: Delay): Delay Equivalent to `self:set(0):start()`

---@type Delay[]
local activeDelays = {}
local methods, metamethods = {}, { __name = 'Delay' }

---A simple delayed execution library.
---@class Delays
---@field update fun(deltaTime: number)
---@field new fun(duration: number, onFinish: function): Delay
local delays = {}

function delays.update(deltaTime)
  for _, delay in pairs(activeDelays) do
    delay:set(delay.position + deltaTime)
  end
end

function delays.new(duration, onFinish)
  local newDelay = {
    duration = duration or 0,
    position = 0,
    onFinish = onFinish
  }

  setmetatable(newDelay, metamethods)

  newDelay:start()

  return newDelay
end

-- Methods

function methods:set(position)
  self.position = math.clamp(position, 0, self.duration)

  if self.position >= self.duration then self:finish() end
  return self
end

function methods:finish()
  self.position = self.duration

  self:stop()
  self:onFinish()
  return self
end

function methods:start()
  local index = table.indexOf(activeDelays, self)
  if not index then table.insert(activeDelays, self) end
  return self
end

function methods:stop()
  local index = table.indexOf(activeDelays, self)
  if index then table.remove(activeDelays, index) end
  return self
end

function methods:restart()
  self:set(0):start()
  return self
end

-- Metamethods

---@param key string
function metamethods:__index(key)
  return methods[key]
end

function metamethods:__tostring()
  return ('Time left: %.3f'):format(self.duration - self.position)
end

return delays