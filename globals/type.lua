local original = type

---Returns the type of `value`.<br>In case `value` is a table, return `metatable.__name` as well if it exists (for the purpose of custom typing).
---@param value any
---@return string type
---@return string? customType
function type(value)
  local metatable = getmetatable(value)
  if metatable and metatable.__name then return 'table', metatable.__name
  else return original(value) end
end
