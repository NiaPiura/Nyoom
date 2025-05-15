---@param element Nyoom.Element
---@param color Nyoom.Color
local function setColor(element, color)
  if element.isPressed then color:multiply(0.9):setActive()
  elseif element.isHovered then color:multiply(1.25):setActive()
  else color:setActive() end
end

local function newButton(text, x, y, width, height, parent, buttonColor, textColor)
  local element = nyoom.ui.newElement('button' .. text, x, y, width, height, parent)
  local textObject = nyoom.graphics.newText(text, 0, 0, width, height):setAlignments('center', 'center'):setColor(textColor or nyoom.graphics.newColor(1, 1, 1))
  buttonColor = buttonColor or nyoom.graphics.newColor(0.3, 0.3, 0.3)

  function element:onDraw()
    setColor(element, buttonColor)
    love.graphics.rectangle('fill', 0, 0, self.size.width, self.size.height)
    textObject:draw()
  end

  return element
end

return newButton