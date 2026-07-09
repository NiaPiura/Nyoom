---@class Nyoom.UILayoutGroup : Nyoom.UIElement
---@field updateLayout fun(self: Nyoom.UILayoutGroup)

---@param x integer
---@param y integer
---@param orientation Nyoom.Orientation
---@param margin integer
---@param parent Nyoom.UIElement
---@return Nyoom.UILayoutGroup
local function newLayoutGroup(x, y, orientation, margin, parent)

  local layoutGroup = nyoom.ui.newElement(orientation .. 'LayoutGroup', x, y, 0, 0, parent) --[[@as Nyoom.UILayoutGroup]]

  function layoutGroup:updateLayout()
    local width, height = 0, 0

    for index, child in ipairs(self.children) do
      if orientation == 'vertical' then
        child:setPosition(0, height)
        height = height + child.height + (index ~= #self.children and margin or 0)
        width = math.max(width, child.width)
      else
        child:setPosition(width, 0)
        width = width + child.width + (index ~= #self.children and margin or 0)
        height = math.max(height, child.height)
      end
    end

    self:setSize(width, height)
  end

  ---@param self Nyoom.UILayoutGroup
  function layoutGroup:addChild(element)
    if element.parent then table.removeValue(element.parent.children, element) end
    table.insert(self.children, element)
    element.parent = self
    element:updateScreenPosition()
    self:updateLayout()
    return self
  end

  ---@param self Nyoom.UILayoutGroup
  function layoutGroup:removeChild(element)
    table.removeValue(self.children, element)
    element.parent = nil
    self:updateLayout()
    return self
  end

  return layoutGroup
end

return newLayoutGroup