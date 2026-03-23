---@class Nyoom.Camera
---@field position Nyoom.Vector2
---@field renderScale number
---@field target love.Canvas
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
    target = love.graphics.newCanvas(size.width, size.height)
  }

  setmetatable(camera, metamethods)

  return camera
end

-- Methods

function methods:setActive()
  love.graphics.setCanvas(self.target)
end

function methods:draw()
  love.graphics.setCanvas()
  love.graphics.draw(self.target, 0 - self.position.x, 0 - self.position.y, 0, self.renderScale, self.renderScale)
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end

return newCamera