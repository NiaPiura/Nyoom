---A list/array of values with an event attached.
---@class nyoom.List<T>
---
---@field getIndex fun(self: nyoom.List<T>, value: T): integer? Returns the index of `value`, or `nil` if not found.
---@field getValue fun(self: nyoom.List<T>, index: integer): T? Returns the value at `index`, or `nil` if not found.
---@field set fun(self: nyoom.List<T>, ...: T) Replaces the contents of the list with the given values.
---@field set fun(self: nyoom.List<T>, values: T[]) Replaces the contents of the list with the given values.
---@field add fun(self: nyoom.List<T>, ...: T) Adds the given values to the end of the list.
---@field add fun(self: nyoom.List<T>, values: T[]) Adds the given values to the end of the list.
---@field remove fun(self: nyoom.List<T>, ...: T) Removes the given values to the end of the list and shifts values to fill gaps. Values not existing in the list are ignored.
---@field remove fun(self: nyoom.List<T>, values: T[]) Removes the given values to the end of the list and shifts values to fill gaps. Values not existing in the list are ignored.
---@field insert fun(self: nyoom.List<T>, value: T, index?: integer) Insert given value in the given index (if within bounds), shifting values up to make room if necessary. If `index` is `nil`, adds to the end of the list.
---@field extract fun(self: nyoom.List<T>, index?: integer): T? Removes and returns a value from the list at the given index (if within bounds). If `index` is `nil`, removes from the end of the list.
---
---@field eventListChanged nyoom.Event<{ added: T[], removed: T[] }>

local methods, metamethods = {}, { __name = 'nyoom.List' }

---@generic T
---@param ... T
---@return nyoom.List<T>
function nyoom.objects.newList(...)
  local list = {
    values = {...},
    eventListChanged = nyoom.events.newEvent()
  }

  setmetatable(list, metamethods)

  return list
end

-- Methods

function methods:getIndex(value)
  return table.indexOf(self.values, value)
end

function methods:getValue(index)
  return self.values[index]
end

function methods:set(...)
  local input = {...}
  if type(input[1]) == 'table' then input = input[1] end

  local removed = self.values
  self.values = input
  self.eventListChanged:trigger({ added = input, removed = removed })
end

function methods:add(...)
  local input = {...}
  if type(input[1]) == 'table' then input = input[1] end

  for _, value in ipairs(input) do
    table.insert(self.values, value)
  end
  self.eventListChanged:trigger({ added = input, removed = {} })
end


function methods:remove(...)
  local input = {...}
  if type(input[1]) == 'table' then input = input[1] end

  local removed = {}
  for _, value in ipairs(input) do
    local index = table.indexOf(self.values, value)
    if index then table.insert(removed, table.remove(self.values, index)) end
  end
  self.eventListChanged:trigger({ added = {}, removed = removed })
end

function methods:insert(value, index)
  if type(index) ~= 'number' then index = #self.values
  elseif index < 0 or index > #self.values then return end

  table.insert(self.values, index, value)
  self.eventListChanged:trigger({ added = { value }, removed = {} })
end

function methods:extract(index)
  if type(index) ~= 'number' then index = #self.values
  elseif index < 0 or index > #self.values then return end

  local removed = table.remove(self.values, index)
  self.eventListChanged:trigger({ added = {}, removed = { removed } })
  return removed
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end