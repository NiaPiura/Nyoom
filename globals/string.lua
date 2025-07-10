---@class StringBuilder
---@field add fun(self: StringBuilder, string: string): StringBuilder
---@field build fun(self: StringBuilder, separator: string|nil): string

do
  local methods, metamethods = {}, { __name = 'StringBuilder' }

  ---Provides an object-oriented implementation of inserting strings into a table and calling `table.concat` on it.
  ---@return StringBuilder
  function string.builder()
    return setmetatable({ sections = {}}, metamethods)
  end

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
end

---Splits `str` into an indexed table of substrings using the seperator sequence `sep`.
---@param str string
---@param sep string
---@return string[] substrings
function string.split(str, sep)
  local list = {}
  if sep == nil then sep = "%s" end
  for substring in string.gmatch(str, "([^"..sep.."]+)") do table.insert(list, substring) end
  return list
end