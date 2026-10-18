---@class nyoom.UISlider : nyoom.UIElement
---@field getValue fun(self: nyoom.UISlider): number
---@field setValue fun(self: nyoom.UISlider, value: number)
---@field onValueChange fun(self: nyoom.UISlider, value: number)
---@field setRailLength fun(self:nyoom.UISlider, length: integer)
---@field setBarLength fun(self:nyoom.UISlider, length: integer)

---A UI element that functions like a slider, which can also be used as a scrollbar.
---@param x integer The x axis position of this element relative to its parent.
---@param y integer The y axis position of this element relative to its parent.
---@param orientation nyoom.Orientation The orientation of this element.
---@param parent nyoom.UIElement The parent element for this element.
---@param railLength? integer The length of the slider's rail; the space the slider can move along. If `0` or `nil`, `nyoom.defaults.barMinLength`  is used.
---@param barLength? integer The length of the Slider's bar; the draggable element that moves along the rail. If `0` or `nil`, `nyoom.defaults.barMinLength`  is used.
---@return nyoom.UISlider
function nyoom.ui.prefabs.newSlider(x, y, orientation, parent, railLength, barLength)
  local defaults = nyoom.defaults.slider
  local railWidth, railHeight = 0, 0
  local barWidth, barHeight = 0, 0
  railLength, barLength = 0, 0

  local value = 0
  local barPosition = 0
  local mouseOffset = nil
  local slider = nyoom.ui.newElement('slider', x, y, 0, 0, parent) --[[@as nyoom.UISlider]]

  ---@param position number
  local function moveBar(position)
    local clampedPosition = math.clamp(position, 0, railLength - barLength)
    slider:setValue(clampedPosition / (railLength - barLength))
  end

  local function setBarPosition()
    barPosition = math.round((railLength - barLength) * (value / 1)) --TODO: Support specified max value?
  end

  function slider:onDraw()
    defaults.railColor:use()
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)

    local colorMultiplier = 1
    if mouseOffset then colorMultiplier = 0.8
    elseif self.isTopmost then colorMultiplier = 1.2 end

    defaults.barColor:mul(colorMultiplier):use()
    love.graphics.rectangle('fill', orientation == 'horizontal' and barPosition or 0, orientation == 'vertical' and barPosition or 0, barWidth, barHeight)
  end

  function slider:onUpdate()
    if mouseOffset then
      local mousePosition = self:getRelativeMousePosition()
      if self.position ~= mousePosition then
        local mouseAxisPosition = mousePosition:getRelevantAxis(orientation)
        moveBar(mouseAxisPosition - mouseOffset)
      end
    end

    setBarPosition() --TODO: only update bar position when value changes
  end

  slider.eventMousePress:addListener(function(eventData)
    if not slider.isTopmost then return end
    print('Pressed')
    local mouseAxisPosition = eventData.position:getRelevantAxis(orientation)

    if mouseAxisPosition < barPosition or mouseAxisPosition > barPosition + barLength then
      moveBar(mouseAxisPosition - (barLength / 2))
      setBarPosition()
    end
    
    mouseOffset = mouseAxisPosition - barPosition
  end)

  slider.eventMouseRelease:addListener(function()
    mouseOffset = nil
  end)

  function slider:setRailLength(length)
    railLength = math.max(defaults.barMinLength, length)

    if orientation == 'vertical' then
      railWidth = defaults.railThickness
      railHeight = railLength
    else
      railWidth = railLength
      railHeight = defaults.railThickness
    end

    slider:setSize(railWidth, railHeight)
  end

  function slider:setBarLength(length)
    barLength = math.clamp(length, defaults.barMinLength, railLength)

    if orientation == 'vertical' then
      barWidth = defaults.barThickness
      barHeight = barLength
    else
      barWidth = barLength
      barHeight = defaults.barThickness
    end
  end

  function slider:setValue(newValue)
    value = math.clamp(newValue, 0, 1)
    if self.onValueChange then self:onValueChange(value) end
  end

  function slider:getValue()
    return value
  end

  slider:setRailLength(railLength)
  slider:setBarLength(barLength)

  return slider
end