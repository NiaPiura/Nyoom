---@class Nyoom.UISlider : Nyoom.UIElement
---@field getValue fun(self: Nyoom.UISlider): number
---@field setValue fun(self: Nyoom.UISlider, value: number)
---@field onValueChange fun(self: Nyoom.UISlider, value: number)

---@param x integer
---@param y integer
---@param orientation Nyoom.Orientation
---@param railLength integer
---@param barLength integer
---@param parent Nyoom.UIElement
---@return Nyoom.UISlider
local function newSlider(x, y, orientation, railLength, barLength, parent)
  local defaults = nyoom.ui.defaults.slider
  local railWidth, railHeight = defaults.railThickness, defaults.railThickness
  local barWidth, barHeight = defaults.barThickness, defaults.barThickness

  railLength = math.max(defaults.barMinLength, railLength)
  barLength = math.clamp(barLength, defaults.barMinLength, railLength)
  
  if orientation == 'vertical' then
    railHeight = railLength
    barHeight = barLength
  else
    railWidth = railLength
    barWidth = barLength
  end

  local value = 0
  local barPosition = 0
  local mouseOffset = 0
  local slider = nyoom.ui.newElement('slider', x, y, railWidth, railHeight, parent) --[[@as Nyoom.UISlider]]

  ---@param position number
  local function moveBar(position)
    local clampedPosition = math.clamp(position, 0, railLength - barLength)
    slider:setValue(clampedPosition / (railLength - barLength))
  end

  local function setBarPosition()
    barPosition = math.round((railLength - barLength) * (value / 1)) --TODO: Support specified max value?
  end

  function slider:onDraw()
    love.graphics.setColor(defaults.railColor)
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)

    local colorMultiplier = 1
    if self.isPressed then colorMultiplier = 0.8
    elseif self.isHovered then colorMultiplier = 1.2 end

    love.graphics.setColor(defaults.barColor * colorMultiplier)
    love.graphics.rectangle('fill', orientation == 'horizontal' and barPosition or 0, orientation == 'vertical' and barPosition or 0, barWidth, barHeight)
  end

  function slider:onUpdate()
    if self.isPressed then
      local mousePosition = self:getRelativeMousePosition()
      if self.position ~= mousePosition then
        local mouseAxisPosition = mousePosition:getRelevantAxis(orientation)
        moveBar(mouseAxisPosition - mouseOffset)
      end
    end

    setBarPosition()
  end

  function slider:onPress(mousePosition)
    local mouseAxisPosition = mousePosition:getRelevantAxis(orientation)

    if mouseAxisPosition < barPosition or mouseAxisPosition > barPosition + barLength then
      moveBar(mouseAxisPosition - (barLength / 2))
      setBarPosition()
    end
    
    mouseOffset = mouseAxisPosition - barPosition
  end

  function slider:onRelease()
    mouseOffset = 0
  end

  function slider:setValue(newValue)
    value = newValue
    if self.onValueChange then self:onValueChange(value) end
  end

  function slider:getValue()
    return value
  end

  return slider
end

return newSlider