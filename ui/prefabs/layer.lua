---@class nyoom.UILayer : nyoom.UIElement
---@field setOpacity fun(self: nyoom.UILayer, opacity: number)

---A UI element that renders to a canvas to allow rendering with accurate opacity for child elements.
---@param id string The ID of the element.
---@param opacity? number The opacity of this element, ranging from `0` (fully transparent) to `1` (fully opague). Defaults to `1`.
---@param x? integer The x axis position of this element relative to its parent. Defaults to `0`.
---@param y? integer The y axis position of this element relative to its parent. Defaults to `0`.
---@param width? integer The width of this element. If `0` or `nil`, the window's width is used.
---@param height? integer The height of this element. If `0` or `nil`, the window's height is used.
---@param parent? nyoom.UIElement The parent element for this elementr. If `nil`, defaults to `nyoom.ui.root`.
---@return nyoom.UILayer
function nyoom.ui.prefabs.newLayer(id, opacity, x, y, width, height, parent)
  local definedWidth = width and width ~= 0
  local definedHeight = height and height ~= 0

  opacity = opacity or 1
  x, y = x or 0, y or 0
  parent = parent or nyoom.ui.root

  if not definedWidth then width = love.graphics.getWidth() end
  if not definedHeight then height = love.graphics.getHeight() end

  width = width --[[@as integer]]
  height = height --[[@as integer]]

  local canvas = love.graphics.newCanvas(width, height)
  local layer = nyoom.ui.newElement(id, x, y, width, height, parent, { isIgnored = true }) --[[@as nyoom.UILayer]]

  local returnCanvas

  function layer:onDraw()
    returnCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
  end

  function layer:onPostDraw()
    love.graphics.setCanvas(returnCanvas)
    returnCanvas = nil
    love.graphics.setColor(1, 1, 1, opacity)
    love.graphics.draw(canvas, 0, 0)
  end

  layer.eventResize:addListener(function()
    if not definedWidth then width = love.graphics.getWidth() end
    if not definedHeight then height = love.graphics.getHeight() end

    canvas = love.graphics.newCanvas(width, height)
    layer:setSize(width, height)
  end)

  function layer:setOpacity(newOpacity)
    opacity = newOpacity
  end

  return layer
end