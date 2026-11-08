local settings = {
  title = { type = 'string', value = 'Nyoom Game' },
  resolution = { type = 'vector2', value = nyoom.objects.newVector2(800, 600) },
  display = { type = 'number', value = 1 },
  window = { type = 'string', value = 'windowed' },
  locale = { type = 'string', value = 'en-US' },
  uiscale = { type = 'number', value = 1 }
}

local setters = {}

---@param value string
function setters.title(value)
  love.window.setTitle(value)
end

---@param value nyoom.Vector2
function setters.resolution(value)
  love.window.updateMode(value.x, value.y, {})
end

---@param value number
function setters.display(value)
  love.window.updateMode(settings.resolution.value.x, settings.resolution.value.y, { display = value })
end

---@param value string
function setters.window(value)
  local mode = {}
  if value == 'windowed' then       mode = { fullscreen = false }
  elseif value == 'fullscreen' then mode = { fullscreen = true, fullscreentype = 'exclusive' }
  elseif value == 'borderless' then mode = { fullscreen = true, fullscreentype = 'desktop' }
  end

  love.window.updateMode(settings.resolution.value.x, settings.resolution.value.y, mode)
end

function setters.locale(value)
  --TODO: Implement locale system directly into Nyoom
end

function setters.uiscale(value)
  nyoom.ui.root:setSize(love.graphics.getWidth() / value, love.graphics.getHeight() / value)
end



nyoom.settings = {}

---@param key string
---@param value any
---@return string | number | nyoom.Vector2
local function setValueType(key, value)
  if settings[key].type == 'vector2' then
    local dimensions = string.split(value, ',')
    return nyoom.objects.newVector2(tonumber(dimensions[1]), tonumber(dimensions[2]))
  elseif settings[key].type == 'number' then
    return tonumber(value) or 0
  else
    return value
  end
end

---@param key string
---@return any value
function nyoom.settings.get(key)
  return settings[key].value
end

---@param key string
---@param value any
---@return boolean success
function nyoom.settings.set(key, value)
  if settings[key] then
    value = setValueType(key, value)
    settings[key].value = value
    setters[key](value)
    return true
  else
    return false
  end
end

-- Load settings
do
  if love.filesystem.getInfo('settings', 'file') then
    for line in love.filesystem.lines('settings') do
      local split = string.split(line, '=')
      local key, value = split[1], split[2] ---@type string, any

      if settings[key] then
        settings[key].value = setValueType(key, value)
      end
    end
  end

  -- Init game window based on settings
  love.window.setMode(settings.resolution.value.width, settings.resolution.value.height, {
    fullscreen = settings.window.value ~= 'windowed',
    fullscreentype = settings.window.value == 'fullscreen' and 'exclusive' or 'desktop',
    display = settings.display.value
  })
end