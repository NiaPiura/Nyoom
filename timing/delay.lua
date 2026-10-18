---Allows for delayed execution of a given function.
---@class nyoom.Delay
---@field duration number
---@field position number
---@field onFinish fun(self: nyoom.Delay): nyoom.Delay
---
---@field set fun(self: nyoom.Delay, remainder: number): nyoom.Delay Sets the current delay's remaining time.
---@field finish fun(self: nyoom.Delay): nyoom.Delay Finish the Delay.
---@field start fun(self: nyoom.Delay): nyoom.Delay Add delay into activeDelays.
---@field stop fun(self: nyoom.Delay): nyoom.Delay Remove tween from activeDelays.
---@field restart fun(self: nyoom.Delay): nyoom.Delay Equivalent to `self:set(0):start()`

local methods, metamethods = {}, { __name = 'nyoom.Delay' }

local activeDelays = {} ---@type nyoom.Delay[]

function nyoom.timing.newDelay(duration, onFinish)
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
  self:onFinish(self)
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



---Delay Update Function
---@param deltaTime number
return function(deltaTime)
  for _, delay in pairs(activeDelays) do
    delay:set(delay.position + deltaTime)
  end
end