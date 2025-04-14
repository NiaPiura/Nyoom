local function load(modname)
  modname = string.gsub(modname, "%.", "/")

  local errmsg = ""
  local modpath = {}
  for str in string.gmatch(modname, "([^/]+)") do table.insert(modpath, str) end

  local directory = modpath[#modpath]
  local path = ('%s/%s/%s.lua'):format(love.filesystem.getWorkingDirectory(), modname, directory)
  local file = io.open(path, "rb")
  if file then return assert(loadstring(assert(file:read("*a")), path)) end

  return errmsg .. "\n\tno file '" .. path .. "' (using directory name search)"
end

table.insert(package.loaders, 2, load)
