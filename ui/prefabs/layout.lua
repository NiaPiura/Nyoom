---@class nyoom.UILayout : nyoom.UIElement
---@field updateLayout fun(self: nyoom.UILayout)

---A UI element that automatically aligns elements along given orientation.
---@param x integer The x axis position of this element relative to its parent.
---@param y integer The y axis position of this element relative to its parent.
---@param orientation nyoom.Orientation The orientation of this element.
---@param parent nyoom.UIElement The parent element for this element.
---@param childMargin? integer The margin between child elements. Defaults to `0`.
---@param minWidth? integer The minimum width of this element. Defaults to `0`.
---@param minHeight? integer The minimum height of this element. Defaults to `0`.
---@return nyoom.UILayout
function nyoom.ui.prefabs.newLayout(x, y, orientation, parent, childMargin, minWidth, minHeight)
  minWidth, minHeight = minWidth or 0, minHeight or 0
  local layout = nyoom.ui.newElement('layout:' .. orientation, x, y, minWidth, minHeight, parent) --[[@as nyoom.UILayout]]

  function layout:updateLayout()
    local width, height = 0, 0

    for index, child in ipairs(self.children) do
      if orientation == 'vertical' then
        child:setPosition(0, height)
        height = height + child.height + (index ~= #self.children and childMargin or 0)
        width = math.max(width, child.width)
      else
        child:setPosition(width, 0)
        width = width + child.width + (index ~= #self.children and childMargin or 0)
        height = math.max(height, child.height)
      end
    end

    self:setSize(math.max(width, minWidth), math.max(height, minHeight))
  end

  ---@param self nyoom.UILayout
  function layout:addChild(element)
    if element.parent then table.removeValue(element.parent.children, element) end
    table.insert(self.children, element)
    element.parent = self
    element:updateScreenPosition()
    self:updateLayout()
    return self
  end

  ---@param self nyoom.UILayout
  function layout:removeChild(element)
    table.removeValue(self.children, element)
    element.parent = nil
    self:updateLayout()
    return self
  end

  return layout
end