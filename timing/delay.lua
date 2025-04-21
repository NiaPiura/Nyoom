---Allows for delayed execution of a given function.
---@class Nyoom.Delay
---@field duration number
---@field position number
---@field onFinish fun(self: Nyoom.Delay): Nyoom.Delay
---
---@field set fun(self: Nyoom.Delay, remainder: number): Nyoom.Delay Sets the current delay's remaining time.
---@field finish fun(self: Nyoom.Delay): Nyoom.Delay Finish the Delay.
---@field start fun(self: Nyoom.Delay): Nyoom.Delay Add delay into activeDelays.
---@field stop fun(self: Nyoom.Delay): Nyoom.Delay Remove tween from activeDelays.
---@field restart fun(self: Nyoom.Delay): Nyoom.Delay Equivalent to `self:set(0):start()`

---@type Nyoom.Delay[]
local activeDelays = {}
local methods, metamethods = {}, { __name = 'Nyoom.Delay' }

---A simple delayed execution library.
---@class Delays
---@field update fun(deltaTime: number)
---@field new fun(duration: number, onFinish: function): Nyoom.Delay
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