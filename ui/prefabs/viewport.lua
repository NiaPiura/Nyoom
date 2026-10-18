---@class nyoom.UIViewport : nyoom.UIElement

---A UI element that only renders contents within it's dimensions.
---@param x integer The x axis position of this element relative to its parent.
---@param y integer The y axis position of this element relative to its parent.
---@param width integer The width of this element.
---@param height integer The height of this element.
---@param parent nyoom.UIElement The parent element for this element.
---@return nyoom.UIViewport
function nyoom.ui.prefabs.newViewport(x, y, width, height, parent)
  local viewport = nyoom.ui.newElement('viewport', x, y, width, height, parent) --[[@as nyoom.UIViewport]]

  local returnScissor

  function viewport:onDraw()
    local scissorX, scissorY, scissorWidth, scissorHeight = love.graphics.getScissor()
    if scissorX then
      returnScissor = nyoom.objects.newRect(scissorX, scissorY, scissorWidth, scissorHeight)
    end

    local position = self.position
    love.graphics.setScissor(position.x, position.y, self.width, self.height)
  end

  function viewport:onPostDraw()
    if returnScissor then
      love.graphics.setScissor(returnScissor.x, returnScissor.y, returnScissor.width, returnScissor.height)
      returnScissor = nil
    else
      love.graphics.setScissor()
    end
  end

  return viewport
end