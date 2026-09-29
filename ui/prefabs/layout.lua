---@class Nyoom.UILayout : Nyoom.UIElement
---@field updateLayout fun(self: Nyoom.UILayout)

---@param x integer
---@param y integer
---@param orientation Nyoom.Orientation
---@param childMargin integer
---@param minWidth integer
---@param minHeight integer
---@param parent Nyoom.UIElement
---@return Nyoom.UILayout
local function newLayout(x, y, orientation, childMargin, minWidth, minHeight, parent)
  minWidth, minHeight = minWidth or 0, minHeight or 0
  local layout = nyoom.ui.newElement('layout:' .. orientation, x, y, minWidth, minHeight, parent) --[[@as Nyoom.UILayout]]

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

  ---@param self Nyoom.UILayout
  function layout:addChild(element)
    if element.parent then table.removeValue(element.parent.children, element) end
    table.insert(self.children, element)
    element.parent = self
    element:updateScreenPosition()
    self:updateLayout()
    return self
  end

  ---@param self Nyoom.UILayout
  function layout:removeChild(element)
    table.removeValue(self.children, element)
    element.parent = nil
    self:updateLayout()
    return self
  end

  return layout
end

return newLayout