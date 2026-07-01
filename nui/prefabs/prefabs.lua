local newButton = require('nyoom.nui.prefabs.button')
local newLayer = require('nyoom.nui.prefabs.layer')

---@class Nyoom.NuiPrefabs
local prefabs = {}

---A basic button with rudimentary visual feedback.
---@param text string The text to display on the button.
---@param x number The position along the X axis.
---@param y number The position along the Y axis.
---@param width number The width of the button.
---@param height number The height of the button.
---@param parent Nyoom.Element The parent element for the button.
---@param buttonColor Nyoom.Color The background color that the button should render with.
---@param textColor Nyoom.Color The text color that the button should render with.
---@return Nyoom.Element
function prefabs.newButton(text, x, y, width, height, parent, buttonColor, textColor)
  return newButton(text, x, y, width, height, parent, buttonColor, textColor)
end

---A UI element that renders to a canvas to allow rendering with accurate opacity for child elements.
---@param id string The ID of the element.
---@param opacity number The opacity to render the layer with, from 0 (fully transparent) to 1 (fully opague).
---@param width number The width of the layer. If 0, the window's width is used.
---@param height number The height of the layer. If 0, the window's height is used.
---@return Nyoom.Layer
function prefabs.newLayer(id, opacity, width, height)
  return newLayer(id, opacity, width, height)
end

return prefabs