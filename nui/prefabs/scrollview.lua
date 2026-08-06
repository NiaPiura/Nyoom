---@class Nyoom.UIScrollview : Nyoom.UIElement
---@field container Nyoom.UIElement

local function newScrollview(x, y, width, height, parent)
  local scrollview = nyoom.ui.prefabs.newViewport(x, y, width, height, parent) --[[@as Nyoom.UIScrollview]]
  local container = nyoom.ui.newElement('container', 0, 0, width, height, scrollview)
  local scrollVertical = nyoom.ui.prefabs.newSlider(0, 0, 'vertical', 0, 0, scrollview)
  local scrollHorizontal = nyoom.ui.prefabs.newSlider(0, 0, 'horizontal', 0, 0, scrollview)

  scrollview.id = 'scrollview'
  scrollview.container = container
  scrollVertical.isVisible = false
  scrollHorizontal.isVisible = false

  local function resize()
    local railThickness = nyoom.ui.defaults.slider.railThickness
    local isOverflowX = container.width > scrollview.width
    local isOverflowY = container.height > scrollview.height
    local overflowX = isOverflowX and math.abs((scrollview.width - (isOverflowY and railThickness or 0)) - container.width) or 0
    local overflowY = isOverflowY and math.abs((scrollview.height - (isOverflowX and railThickness or 0)) - container.height) or 0

    if overflowX > 0 then
      local railLength = scrollview.width - (isOverflowY and railThickness or 0)
      local barLength = math.floor(scrollview.width / container.width)

      scrollHorizontal:setPosition(0, scrollview.height - railThickness)
      scrollHorizontal:setRailLength(railLength)
      scrollHorizontal:setBarLength(barLength)
      scrollHorizontal.isVisible = true
    else
      scrollHorizontal.isVisible = false
    end

    if overflowY > 0 then
      local railLength = scrollview.height - (isOverflowX and railThickness or 0)
      local barLength = math.floor((scrollview.height / container.height) * railLength)

      scrollVertical:setPosition(scrollview.width - railThickness, 0)
      scrollVertical:setRailLength(railLength)
      scrollVertical:setBarLength(barLength)
      scrollVertical.isVisible = true
    else 
      scrollVertical.isVisible = false
    end
  end

  function scrollHorizontal:onValueChange(value)
    local elementDelta = container.width - scrollview.width
    container.x = elementDelta * -value
  end

  function scrollVertical:onValueChange(value)
    local elementDelta = container.height - scrollview.height
    container.y = elementDelta * -value
  end

  function scrollview:onWheel(wheelDelta)
    local mousePosition = scrollview:getRelativeMousePosition()
    if mousePosition.x < 0 or mousePosition.x > scrollview.width or mousePosition.y < 0 or mousePosition.y > scrollview.height then return end

    if wheelDelta.x ~= 0 then
      local stepSize = nyoom.ui.defaults.scrollview.scrollIncrement / container.width
      scrollHorizontal:setValue(scrollHorizontal:getValue() + (stepSize * -wheelDelta.x))
    end

    if wheelDelta.y ~= 0 then
      local stepSize = nyoom.ui.defaults.scrollview.scrollIncrement / container.height
      scrollVertical:setValue(scrollVertical:getValue() + (stepSize * -wheelDelta.y))
    end
  end

  function scrollview:onResize() resize() end
  function container:onResize() resize() end

  container:setSize(width, height)

  return scrollview
end

return newScrollview