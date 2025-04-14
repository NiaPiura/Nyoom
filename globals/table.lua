---Returns the key of the given value, or nil if missing
---@param list table
---@param value any
---@return any
function table.keyOf(list, value)
  for k, v in pairs(list) do
    if v == value then return k end
  end
end

---Returns the index of the gven value, or nil if missing
---@param list table
---@param value any
---@return integer | nil
function table.indexOf(list, value)
  for i, v in ipairs(list) do
    if v == value then return i end
  end
end

---Removed a value from the table
---@param list table
---@param value any
function table.removeValue(list, value)
  local index = table.indexOf(list, value)
  if index then table.remove(list, index) end
end

---Returns the first value in arbitrary order that returns true on the matching function provided, or nil if nothing matched. 
---@param list table
---@param func function
---@return any
function table.find(list, func)
  for _, v in pairs(list) do
    if func(v) then return v end
  end
end

---Returns the first value in order of index that returns true on the matching function provided, or nil if nothing matched.
---@param list table
---@param func function
---@return any
function table.ifind(list, func)
  for _, v in ipairs(list) do
    if func(v) then return v end
  end
end

---Returns an indexed table containing the keys of the provided table
---@param list table
---@return string[]
function table.keys(list)
  local keys = {}
  for k, _ in pairs(list) do
    keys[#keys+1] = k
  end
  return keys
end

---Returns an indexed table containing the values of the provided table
---@param list table
---@return any[]
function table.values(list)
  local values = {}
  for _, v in pairs(list) do
    values[#values+1] = v
  end
  return values
end

---Creates a deep copy of a table, including metatables
---@param original table
---@return table
function table.clone(original)
  local copy
  if type(original) == 'table' then
    copy = {}
    for originalKey, originalValue in next, original, nil do
      copy[table.clone(originalKey)] = table.clone(originalValue)
    end
    setmetatable(copy, table.clone(getmetatable(original)))
  else
    copy = original
  end
  return copy
end