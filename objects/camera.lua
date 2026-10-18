---(WIP)
---@class nyoom.Camera
---@field position nyoom.Vector2
---@field size nyoom.Vector2
---@field renderScale number
---
---@field activate fun(self: nyoom.Camera)
---@field deactivate fun(self: nyoom.Camera)
---@field screenToWorld fun(self: nyoom.Camera, point: nyoom.Vector2)
---@field worldToScreen fun(self: nyoom.Camera, point: nyoom.Vector2)

local methods, metamethods = {}, { __name = 'nyoom.Camera' }

---Create a new Camera.
---@return nyoom.Camera
---@param size? nyoom.Vector2 The size of thecamera's viewport. Defaults to the window's dimensions.
function nyoom.objects.newCamera(size)
  local camera = {
    position = nyoom.objects.newVector2(),
    size = size or nyoom.objects.newVector2(love.graphics.getWidth(), love.graphics.getHeight()),
    renderScale = 1,
  }

  setmetatable(camera, metamethods)

  return camera
end

-- Methods

---@param self nyoom.Camera
function methods:activate()
  local renderScaleOffset = self.size * 0.5 * (self.renderScale - 1)

  love.graphics.push()
  love.graphics.translate(
    -self.position.x * self.renderScale - renderScaleOffset.x,
    -self.position.y * self.renderScale - renderScaleOffset.y
  )
  love.graphics.scale(self.renderScale)
end

---@param self nyoom.Camera
function methods:deactivate()

  love.graphics.pop()
end


---@param self nyoom.Camera
function methods:screenToWorld(point)
  local scaledPoint = (point - self.size * 0.5) / self.renderScale
  local position = self.position + self.size * 0.5
  return position + scaledPoint
end

---@param self nyoom.Camera
function methods:worldToScreen(point)

  return nyoom.objects.newVector2()
end

-- Metamethods

function metamethods:__index(key)
  return methods[key]
end