---@class Nyoom.Camera
---@field position Nyoom.Vector2
---@field size Nyoom.Vector2
---@field renderScale number
---
---@field activate fun(self: Nyoom.Camera)
---@field deactivate fun(self: Nyoom.Camera)
---@field draw fun(self: Nyoom.Camera)

local methods, metamethods = {}, { __name = 'Nyoom.Camera' }

---Creates a new Camera
---@return Nyoom.Camera
---@param size? Nyoom.Vector2
local function newCamera(size)
  local camera = {
    position = nyoom.common.newVector2(),
    size = size or nyoom.common.newVector2(love.graphics.getWidth(), love.graphics.getHeight()),
    renderScale = 1,
  }

  setmetatable(camera, metamethods)

  return camera
end

-- Methods

---@param self Nyoom.Camera
function methods:activate()
  local renderScaleOffset = self.size * 0.5 * (self.renderScale - 1)

  love.graphics.push()
  love.graphics.translate(
    -self.position.x * self.renderScale - renderScaleOffset.x,
    -self.position.y * self.renderScale - renderScaleOffset.y
  )
  love.graphics.scale(self.renderScale)
end

---@param self Nyoom.Camera
function methods:deactivate()

  love.graphics.pop()
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newCamera