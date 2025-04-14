local original = type

function type(obj)
  local metatable = getmetatable(obj)
  if metatable and metatable.__name then return 'table', metatable.__name
  else return original(obj) end
end
