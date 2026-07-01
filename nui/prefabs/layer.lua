---@class Nyoom.Layer : Nyoom.Element
---@field setOpacity fun(self: Nyoom.Layer, opacity: number)

local function newLayer(id, opacity)
  local width, height = love.graphics.getDimensions()
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
    width, height = love.graphics.getDimensions()
    canvas = love.graphics.newCanvas(width, height)
    layer:setSize(width, height)
  end

  function layer:setOpacity(newOpacity)
    opacity = newOpacity
  end

  return layer
end

return newLayer

