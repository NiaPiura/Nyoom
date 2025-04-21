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

local methods, metamethods = {}, { __name = 'Nyoom.Delay' }

---A simple delayed execution library.
---@class Nyoom.Delays
---@field update fun(deltaTime: number)
---@field newDelay fun(duration: number, onFinish: function): Nyoom.Delay
local delays = {
  activeDelays = {} ---@type Nyoom.Delay[]
}

function delays.update(deltaTime)
  for _, delay in pairs(delays.activeDelays) do
    delay:set(delay.position + deltaTime)
  end
end

function delays.newDelay(duration, onFinish)
  local delay = {
    duration = duration or 0,
    position = 0,
    onFinish = onFinish
  }

  setmetatable(delay, metamethods)

  delay:start()

  return delay
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
  local index = table.indexOf(delays.activeDelays, self)
  if not index then table.insert(delays.activeDelays, self) end
  return self
end

function methods:stop()
  local index = table.indexOf(delays.activeDelays, self)
  if index then table.remove(delays.activeDelays, index) end
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