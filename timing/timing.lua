local tween = require('nyoom.timing.tween')
local delay = require('nyoom.timing.delay')

---@class Nyoom.Timing
---@field update fun(deltaTime: number)
---@field newTween fun(duration: number, object: table, target: table): Nyoom.Tween Create a new Tween
---@field newDelay fun(duration: number, onFinish: fun(self: Nyoom.Delay) ): Nyoom.Delay Create a new Delay and automatically starts it.
local timing = {}

function timing.update(deltaTime)
  tween.update(deltaTime)
  delay.update(deltaTime)
end

function timing.newTween(duration, object, target)
  return tween.newTween(duration, object, target)
end

function timing.newDelay(duration, onFinish)
  return delay.newDelay(duration, onFinish)
end

return timing