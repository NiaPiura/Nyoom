---A simple set of timing-related objects. These are automatically updated by nyoom.
nyoom.timing = {}

local tweenUpdate = require('nyoom.timing.tween')
local delayUpdate = require('nyoom.timing.delay')

---Timing iterator. Do not call directly.
---@param deltaTime number
---@private
function nyoom.timing.update(deltaTime)
  tweenUpdate(deltaTime)
  delayUpdate(deltaTime)
end