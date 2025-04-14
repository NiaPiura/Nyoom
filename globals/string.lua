---@class StringBuilder
---@field add fun(self: StringBuilder, string: string): StringBuilder
---@field build fun(self: StringBuilder, separator: string|nil): string

do
  local methods, metamethods = {}, { __name = 'StringBuilder' }

  function methods:add(string)
    table.insert(self.sections, string)
    return self
  end

  function methods:build(separator)
    return table.concat(self.sections, separator or '')
  end

  function metamethods:__index(key)
    return methods[key]
  end

  function metamethods:__tostring()
    return ('Sections: %d'):format(#self.sections)
  end

  ---Provides an OOP-like implementation of inserting strings into a table and calling `table.concat` on it.
  ---@return StringBuilder
  function string.builder()
    return setmetatable({ sections = {}}, metamethods)
  end
end

---Splits a string into an indexed table based on a separator.
---@param s string
---@param sep string
---@return string[]
function string.split(s, sep)
  local t = {}
  if sep == nil then sep = "%s" end
  for str in string.gmatch(s, "([^"..sep.."]+)") do table.insert(t, str) end
  return t
end