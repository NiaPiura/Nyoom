---Clamps value between `min` and `max`.
---@param value number
---@param min number
---@param max number
---@return number
function math.clamp(value, min, max)
  if (value < min) then return min
  elseif (value > max) then return max
  else return value end
end

---Returns the value's sign.
---@param value number
---@return integer 1 for positive values, -1 for negative values. 0 is treated as positive.
function math.sign(value)
  if (value >= 0) then return 1
  else return -1 end
end

---Rounds the given value to the nearest integer.
---@param value number
---@return integer
function math.round(value)
  if value >= 0 then return math.floor(value)
  else return math.ceil(value) end
end