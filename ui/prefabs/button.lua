---A basic button with rudimentary visual feedback.
---@class nyoom.UIButton : nyoom.UIElement
---@field text nyoom.AlignedText
---@field color nyoom.Color

---@param element nyoom.UIElement
---@param color nyoom.Color
local function setColor(element, color)
  if element.isPressed then color:mul(0.9):use()
  elseif element.isHovered then color:mul(1.25):use()
  else color:use() end
end

---A basic button with rudimentary visual feedback.
---@param text string The text to display on the button.
---@param x integer The x axis position of this element relative to its parent.
---@param y integer The y axis position of this element relative to its parent.
---@param width integer The width of this element.
---@param height integer The height of this element.
---@param parent nyoom.UIElement The parent element for this element.
---@param bodyColor? nyoom.Color The body color that this element should use. Defaults to `nyoom.defaults.backgroundColor`.
---@param textColor? nyoom.Color The text color that this element should use. Defaults to `nyoom.defaults.foregroundColor`.
---@return nyoom.UIButton
function nyoom.ui.prefabs.newButton(text, x, y, width, height, parent, bodyColor, textColor)
  local button = nyoom.ui.newElement('button' .. text, x, y, width, height, parent) --[[@as nyoom.UIButton]]
  button.text = nyoom.objects.newAlignedText(text, 0, 0, width, height):setAlignments('center', 'center'):setColor(textColor or nyoom.defaults.foregroundColor)
  button.color = bodyColor or nyoom.defaults.backgroundColor

  function button:onDraw()
    setColor(button, button.color)
    love.graphics.rectangle('fill', 0, 0, self.size.width, self.size.height)
    button.text:draw()
  end

  function button:setSize(newWidth, newHeight)
  if type(newWidth) == 'number' then self.rect.size = nyoom.objects.newVector2(newWidth, newHeight)
  else self.rect.size = newWidth end
  button.text:setSize(self.rect.size)
  ---@diagnostic disable-next-line: invisible
  self:resize(self.rect.size)
end

  return button
end