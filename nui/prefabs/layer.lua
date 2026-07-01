---@class Nyoom.Layer : Nyoom.Element
---@field setOpacity fun(self: Nyoom.Layer, opacity: number)


---@param id string
---@param opacity number
---@param width number
---@param height number
---@return Nyoom.Layer
local function newLayer(id, opacity, width, height)
  local definedWidth = width == 0
  local definedHeight = height == 0

  if not definedWidth then width = love.graphics.getWidth() end
  if not definedHeight then height = love.graphics.getHeight() end

  local canvas = love.graphics.newCanvas(width, height)
  local layer = nyoom.ui.newElement(id, 0, 0, width, height, nyoom.ui.root, { isIgnored = true }) --[[@as Nyoom.Layer]]

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
