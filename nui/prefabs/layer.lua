---@class Nyoom.UILayer : Nyoom.UIElement
---@field setOpacity fun(self: Nyoom.UILayer, opacity: number)

---@param id string
---@param opacity number
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@return Nyoom.UILayer
local function newLayer(id, opacity, x, y, width, height)
  local definedWidth = width ~= 0
  local definedHeight = height ~= 0

  if not definedWidth then width = love.graphics.getWidth() end
  if not definedHeight then height = love.graphics.getHeight() end

  local canvas = love.graphics.newCanvas(width, height)
  local layer = nyoom.ui.newElement(id, x, y, width, height, nyoom.ui.root, { isIgnored = true }) --[[@as Nyoom.UILayer]]

  local returnCanvas

  function layer:onDraw()
    returnCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(canvas)
  end

  function layer:onPostDraw()
    love.graphics.setCanvas(returnCanvas)
    returnCanvas = nil
    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.draw(canvas, 0, 0)
  end

  function layer:onResize()
    if not definedWidth then width = love.graphics.getWidth() end
    if not definedHeight then height = love.graphics.getHeight() end

    canvas = love.graphics.newCanvas(width, height)
    layer:setSize(width, height)
  end

  function layer:setOpacity(newOpacity)
    opacity = newOpacity
  end

  return layer
end

return newLayer
