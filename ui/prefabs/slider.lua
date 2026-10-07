---@class Nyoom.UISlider : Nyoom.UIElement
---@field getValue fun(self: Nyoom.UISlider): number
---@field setValue fun(self: Nyoom.UISlider, value: number)
---@field onValueChange fun(self: Nyoom.UISlider, value: number)
---@field setRailLength fun(self:Nyoom.UISlider, length: integer)
---@field setBarLength fun(self:Nyoom.UISlider, length: integer)

---@param x integer
---@param y integer
---@param orientation Nyoom.Orientation
---@param railLength integer
---@param barLength integer
---@param parent Nyoom.UIElement
---@return Nyoom.UISlider
local function newSlider(x, y, orientation, railLength, barLength, parent)
  local defaults = nyoom.ui.defaults.slider
  local railWidth, railHeight = 0, 0
  local barWidth, barHeight = 0, 0

  local value = 0
  local barPosition = 0
  local mouseOffset = nil
  local slider = nyoom.ui.newElement('slider', x, y, 0, 0, parent) --[[@as Nyoom.UISlider]]

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

return newSlider