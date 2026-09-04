---@class Nyoom.UIButton : Nyoom.UIElement
---@field text Nyoom.Text
---@field color Nyoom.Color

---@param element Nyoom.UIElement
---@param color Nyoom.Color
local function setColor(element, color)
  if element.isPressed then color:multiply(0.9):setActive()
  elseif element.isHovered then color:multiply(1.25):setActive()
  else color:setActive() end
end

---@param text string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param parent Nyoom.UIElement
---@param buttonColor Nyoom.Color
---@param textColor Nyoom.Color
---@return Nyoom.UIButton
local function newButton(text, x, y, width, height, parent, buttonColor, textColor)
  local button = nyoom.ui.newElement('button' .. text, x, y, width, height, parent) --[[@as Nyoom.UIButton]]
  button.text = nyoom.objects.newText(text, 0, 0, width, height):setAlignments('center', 'center'):setColor(textColor or nyoom.objects.newColor(1, 1, 1))
  button.color = buttonColor or nyoom.objects.newColor(0.3, 0.3, 0.3)

  function button:onDraw()
    setColor(button, button.color)
    love.graphics.rectangle('fill', 0, 0, self.size.width, self.size.height)
    button.text:draw()
  end

  return button
end

return newButton
