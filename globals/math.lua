---Clamps `value` between `min` and `max`.
---@param value number
---@param min number
---@param max number
---@return number
function math.clamp(value, min, max)
  if (value < min) then return min
  elseif (value > max) then return max
  else return value end
end

---Returns the sign of `value`.
---@param value number
---@return integer `1` for positive values, `-1` for negative values. The value `0` is treated as positive.
function math.sign(value)
  if (value >= 0) then return 1
  else return -1 end
end

---Rounds the given value to the nearest integer. `0.5` is rounded up
---@param value number
---@return integer
function math.round(value)
  if value >= 0.5 then return math.ceil(value)
  else return math.floor(value) end
end