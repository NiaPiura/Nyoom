---@class Nyoom.UIViewport : Nyoom.UIElement

local function newViewport(x, y, width, height, parent)
  local viewport = nyoom.ui.newElement('viewport', x, y, width, height, parent) --[[@as Nyoom.UIViewport]]

  local returnScissor

  function viewport:onDraw()
    local scissorX, scissorY, scissorWidth, scissorHeight = love.graphics.getScissor()
    if scissorX then
      returnScissor = nyoom.common.newRect(scissorX, scissorY, scissorWidth, scissorHeight)
    end
    love.graphics.setScissor(self.x, self.y, self.width, self.height)
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

return newViewport