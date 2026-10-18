---@class nyoom.UIScrollview : nyoom.UIElement
---@field container nyoom.UIElement
---@field scrollVertical nyoom.UISlider
---@field scrollHorizontal nyoom.UISlider

---A UI element that allows content larger than itself to be contained within, and to pan across said content using scrollbars.
---@param x integer The x axis position of this element relative to its parent.
---@param y integer The y axis position of this element relative to its parent.
---@param width integer The width of this element.
---@param height integer The height of this element.
---@param parent nyoom.UIElement The parent element for this element.
---@return nyoom.UIScrollview
function nyoom.ui.prefabs.newScrollview(x, y, width, height, parent)
  local scrollview = nyoom.ui.prefabs.newViewport(x, y, width, height, parent) --[[@as nyoom.UIScrollview]]
  local container = nyoom.ui.newElement('container', 0, 0, width, height, scrollview)
  local scrollVertical = nyoom.ui.prefabs.newSlider(0, 0, 'vertical', scrollview)
  local scrollHorizontal = nyoom.ui.prefabs.newSlider(0, 0, 'horizontal', scrollview)

  scrollview.id = 'scrollview'
  scrollview.container = container
  scrollview.scrollVertical = scrollVertical
  scrollview.scrollHorizontal = scrollHorizontal
  scrollVertical.isVisible = false
  scrollHorizontal.isVisible = false

  local function resize()
    local railThickness = nyoom.defaults.slider.railThickness
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

    container.boundingBox:setSize(scrollview.size)
  end

  function scrollHorizontal:onValueChange(value)
    local elementDelta = container.width - scrollview.width
    container.x = elementDelta * -value
    container.boundingBox.x = container.rect.x - container.x
  end

  function scrollVertical:onValueChange(value)
    local elementDelta = container.height - scrollview.height
    container.y = elementDelta * -value
    container.boundingBox.y = container.rect.y - container.y
  end

  scrollview.eventMouseWheel:addListener(function(eventData)
    local hasTopMostElement = false
    local searchQueue = { scrollview }

    while #searchQueue > 0 do
      local element = searchQueue[1]

      if element.isTopmost then hasTopMostElement = true
      else
        for _, child in ipairs(element.children) do
          table.insert(searchQueue, child)
        end
      end
      
      table.remove(searchQueue, 1)
    end

    if not hasTopMostElement then return end

    local mousePosition = scrollview:getRelativeMousePosition()
    if mousePosition.x < 0 or mousePosition.x > scrollview.width or mousePosition.y < 0 or mousePosition.y > scrollview.height then return end

    if eventData.delta.x ~= 0 then
      local stepSize = nyoom.defaults.scrollview.scrollIncrement / container.width
      scrollHorizontal:setValue(scrollHorizontal:getValue() + (stepSize * -eventData.delta.x))
    end

    if eventData.delta.y ~= 0 then
      local stepSize = nyoom.defaults.scrollview.scrollIncrement / container.height
      scrollVertical:setValue(scrollVertical:getValue() + (stepSize * -eventData.delta.y))
    end
  end)

  scrollview.eventResize:addListener(resize)
  container.eventResize:addListener(resize)

  container:setSize(width, height)

  return scrollview
end