local function recordMessage(message)
  --TODO
end

local function getLength(list)
  local count = 0
  for _, _ in pairs(list) do count = count + 1 end
  return count
end

---@param list table
---@param customType string|nil
---@return string
local function printTable(list, customType)
  local message = string.builder()
  if customType then message:add(('<%s> {\n'):format(customType))
  else message:add('{\n') end

  for key, value in pairs(list) do
    local valueType, customType = type(value)
    if valueType == 'table' then
      if customType then message:add(('  %s: <%s> %s\n'):format(tostring(key), customType, tostring(value)))
      else message:add(('  %s: {%d} \n'):format(tostring(key), getLength(value))) end
    else message:add(('  %s: %s\n'):format(tostring(key), tostring(value))) end
  end

  return message:add('}'):build()
end

---@param ... any
function print(...)
  local message = string.builder()
  local values = {...}

  for i, value in ipairs(values) do
    local valueType, customType = type(value)
    if valueType == 'table' then
      if #values > 1 then
        if customType then message:add(('<%s> %s'):format(customType, tostring(value)))
        else message:add(('%s'):format(tostring(value))) end
      else message:add(printTable(value, customType)) end
    else message:add(('%s'):format(tostring(value))) end
  end

  local builtMessage = os.date('[%H:%M:%S] ') .. message:build(',  ') .. '\n'
  recordMessage(builtMessage)
  io.write(builtMessage)
end