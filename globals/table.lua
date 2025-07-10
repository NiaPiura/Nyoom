---Returns the key of `searchValue` in `list`, or nil if missing.
---@param list table
---@param searchValue any
---@return any key
function table.keyOf(list, searchValue)
  for key, value in pairs(list) do
    if value == searchValue then return key end
  end
end

---Returns the index of `searchValue` in `list`, or nil if missing.
---@param list table
---@param searchValue any
---@return integer? index
function table.indexOf(list, searchValue)
  for index, value in ipairs(list) do
    if value == searchValue then return index end
  end
end

---Removes `searchValue` from the table, returning `true` if successful.
---@param list table
---@param searchValue any
---@return boolean success
function table.removeValue(list, searchValue)
  local index = table.indexOf(list, searchValue)
  if index then
    table.remove(list, index)
    return true
  else return false end
end

---Finds the first match in `list` (in arbitrary order) where `func` returns `true`, returning both its value and key or `nil, nil` if no matches were found. 
---@param list table
---@param func fun(value: any): boolean
---@return any value, any key
function table.find(list, func)
  for key, value in pairs(list) do
    if func(value) then return value, key end
  end
end

---Finds the first element in `list` (in order of index) where `func` returns `true`, returning both its value and index or `nil, 0` if no matches were found.
---@param list table
---@param func fun(value: any): boolean
---@return any value, integer index
function table.ifind(list, func)
  for index, value in ipairs(list) do
    if func(value) then return value, index end
  end
  return nil, 0
end

---Returns an indexed table containing the keys of `list`.
---@param list table
---@return string[] keys
function table.keys(list)
  local keys = {}
  for key, _ in pairs(list) do
    table.insert(keys, key)
  end
  return keys
end

---Returns an indexed table containing the values of `list`.
---@param list table
---@return any[] values
function table.values(list)
  local values = {}
  for _, value in pairs(list) do
    table.insert(values, value)
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
    local metatable = getmetatable(original)
    -- Only make a copy of the metatable if the metatable does not represent a custom type, as designated by the __name property. Otherwise reuse it.
    if metatable.__name then setmetatable(copy, metatable)
    else setmetatable(copy, table.clone(metatable)) end
  else
    copy = original
  end
  return copy
end

---Shallow-copies over all of a table's fields to another target table
---@param target table
---@param list table
function table.apply(target, list)
  for k, v in pairs(list) do
    target[k] = v
  end
end