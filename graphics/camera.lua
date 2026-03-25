---@class Nyoom.Camera
---@field position Nyoom.Vector2
---@field renderScale number
---@field target love.Canvas
---@field size Nyoom.Vector2
---@field rotation number
---
---@field setActive fun(self: Nyoom.Camera)
---@field draw fun(self: Nyoom.Camera)

local methods, metamethods = {}, { __name = 'Nyoom.Camera' }

---Creates a new Camera
---@return Nyoom.Camera
---@param size? Nyoom.Vector2
local function newCamera(size)
  size = size or nyoom.common.newVector2(love.graphics.getWidth(), love.graphics.getHeight())
  local camera = {
    position = nyoom.common.newVector2(),
    renderScale = 1,
    target = love.graphics.newCanvas(size.width, size.height),
    size = size
  }

  setmetatable(camera, metamethods)

  return camera
end

-- Methods

function methods:setActive()
  love.graphics.setCanvas(self.target)
end

---@param self Nyoom.Camera
function methods:draw()
  local renderScaleOffset = self.size * 0.5 * (self.renderScale - 1)

  love.graphics.setCanvas()
  love.graphics.draw(
  self.target,
  -self.position.x * self.renderScale - renderScaleOffset.x,
  -self.position.y * self.renderScale - renderScaleOffset.y,
  0,
  self.renderScale
)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newCamera