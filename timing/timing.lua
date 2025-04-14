local tween = require('src.nyoom.timing.tween')
local delay = require('src.nyoom.timing.delay')

---@class Timing
---@field update fun(deltaTime: number)
---@field newTween fun(duration: number, object: table, target: table): Tween Create a new Tween
---@field newDelay fun(duration: number, onFinish: fun(self: Delay) ): Delay Create a new Delay and automatically starts it.
local timing = {}

function timing.update(deltaTime)
  tween.update(deltaTime)
  delay.update(deltaTime)
end

function timing.newTween(duration, object, target)
  return tween.new(duration, object, target)
end

function timing.newDelay(duration, onFinish)
  return delay.new(duration, onFinish)
end

return timing