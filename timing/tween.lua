---A representation of an easing operation on two sets of values over time.
---@class Nyoom.Tween
---@field method EasingMethods
---@field duration number
---@field position number
---@field value number
---@field power number
---
---@field isReversed boolean
---
---@field ease fun(self: Nyoom.Tween, method: EasingMethods, power: number): Nyoom.Tween Set the easing method.
---@field set fun(self: Nyoom.Tween, position: number): Nyoom.Tween Sets the current tween value to the given position.
---@field forward fun(self: Nyoom.Tween): Nyoom.Tween Set tween to play back in forwards direction.
---@field backward fun(self: Nyoom.Tween): Nyoom.Tween Set tween to play back in backwards direction.
---@field finish fun(self: Nyoom.Tween): Nyoom.Tween Finish the tween.
---@field start fun(self: Nyoom.Tween): Nyoom.Tween Add tween into activeTweens.
---@field stop fun(self: Nyoom.Tween): Nyoom.Tween Remove tween from activeTweens.
---@field restart fun(self: Nyoom.Tween): Nyoom.Tween Equivalent to `self:set(0):start()`
---
---@field onUpdate fun(self: Nyoom.Tween)? Add a callback that runs on every step to apply the tween's state to something.
---@field onFinish fun(self: Nyoom.Tween)? Add a callback that runs when the tween is finished.

---@alias EasingMethods 'linear'|'easeIn'|'easeOut'|'easeInOut'

-- x = position in easing function, p = tween power.
local easingMethods = {
  linear = function (x) return x end,
  easeIn = function (x, p) return math.pow(x, p) end,
  easeOut = function (x, p) return 1 - math.pow(1 - x, p) end,
  easeInOut = function (x, p) if x < 0.5 then return math.pow(x * 2, p) / 2 else return 1 - math.pow(2 - x * 2, p) / 2 end end
}

local methods, metamethods = {}, { __name = 'Nyoom.Tween' }

---A simple tweening Library.
---@class Nyoom.Tweens
---@field update fun(deltaTime: number)
---@field newTween fun(duration: number, object: table, target: table): Nyoom.Tween
local tweens = {
  activeTweens = {} ---@type Nyoom.Tween[]
}

function tweens.update(deltaTime)
  for _, tween in pairs(tweens.activeTweens) do
    tween:set(tween.position + (deltaTime * (tween.isReversed and -1 or 1)))
  end
end

local function matchFields(object, target)
  local origin = {}
  for k, _ in pairs(target) do origin[k] = object[k] end
  return origin
end

function tweens.newTween(duration, object, target)
  local tween = {
    method = 'linear',
    duration = duration or 0,
    position = 0,
    value = 0,
    power = 1,

    object = object,
    target = target,
    origin = matchFields(object,target),

    isReversed = false
  }

  return setmetatable(tween, metamethods)
end

-- Methods

function methods:ease(method, power)
  self.method = method
  self.power = power
  return self
end

function methods:set(position)
  self.position = math.clamp(position, 0, self.duration)

  self.value = easingMethods[self.method](self.position / self.duration, self.power)
  for k, v in pairs(self.target) do self.object[k] = self.origin[k] + (v - self.origin[k]) * self.value end

  if self.onUpdate then self.onUpdate(self) end
  if not self.isReversed then if self.position >= self.duration then self:finish() end
  else if self.position <= 0 then self:finish() end end
  return self
end

function methods:forward()
  self.position = 0
  self.isReversed = false
  return self
end

function methods:backward()
  self.position = self.duration
  self.isReversed = true
  return self
end

function methods:finish()
  self.position = self.duration
  self.value = 1

  self:stop()
  if self.onFinish then self:onFinish(self) end
  return self
end

function methods:start()
  local index = table.indexOf(tweens.activeTweens, self)
  if not index then table.insert(tweens.activeTweens, self) end
  return self
end

function methods:stop()
  local index = table.indexOf(tweens.activeTweens, self)
  if index then table.remove(tweens.activeTweens, index) end
  return self
end

function methods:restart()
  self:set(0):start()
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

function metamethods:__tostring()
  return ('Method: %s, Value: %.3f'):format(self.method, self.value)
end

return tweens