local newButton = require('nyoom.nui.prefabs.button')
local newLayer = require('nyoom.nui.prefabs.layer')
local newSlider = require('nyoom.nui.prefabs.slider')
local newLayout = require('nyoom.nui.prefabs.layout')
local newViewport = require('nyoom.nui.prefabs.viewport')
local newScrollview = require('nyoom.nui.prefabs.scrollview')

---@class Nyoom.NuiPrefabs
local prefabs = {}

---A basic button with rudimentary visual feedback.
---@param text string The text to display on the button.
---@param x integer The position along the X axis.
---@param y integer The position along the Y axis.
---@param width integer The width of the button.
---@param height integer The height of the button.
---@param parent Nyoom.UIElement The parent element for the button.
---@param buttonColor? Nyoom.Color The background color that the button should render with.
---@param textColor? Nyoom.Color The text color that the button should render with.
---@return Nyoom.UIElement
function prefabs.newButton(text, x, y, width, height, parent, buttonColor, textColor)
  buttonColor = buttonColor or nyoom.objects.newColor(0.4, 0.4, 0.4)
  textColor = textColor or nyoom.objects.newColor(0.9, 0.9, 0.9)
  return newButton(text, x, y, width, height, parent, buttonColor, textColor)
end

---A UI element that renders to a canvas to allow rendering with accurate opacity for child elements.
---@param id string The ID of the element.
---@param opacity? number The opacity to render the layer with, from 0 (fully transparent) to 1 (fully opague). Defaults to 1.
---@param x? integer The position of the layer on screen along the X axis.
---@param y? integer The position of the layer on screen along the Y axis.
---@param width? integer The width of the layer. If 0, the window's width is used.
---@param height? integer The height of the layer. If 0, the window's height is used.
---@return Nyoom.UILayer
function prefabs.newLayer(id, opacity, x, y, width, height)
  opacity = opacity or 1
  x = x or 0
  y = y or 0
  width = width or 0
  height = height or 0
  return newLayer(id, opacity, x, y, width, height)
end

---A UI element that functions like a slider, which can also be used as a scrollbar.
---@param x integer The position of the layer on screen along the X axis.
---@param y integer The position of the layer on screen along the Y axis.
---@param orientation Nyoom.Orientation The orientation of the slider.
---@param railLength integer The length of the slider's rail; the space the slider can move along.
---@param barLength integer The length of the Slider's bar; the draggable element that moves along the rail. If 0, NUI defaults are used.
---@param parent Nyoom.UIElement The parent element for the slider.
---@return Nyoom.UISlider
function prefabs.newSlider(x, y, orientation, railLength, barLength, parent)
  return newSlider(x, y, orientation, railLength, barLength, parent)
end

---A UI element that automatically aligns elements along given orientation.
---@param x integer
---@param y integer
---@param orientation Nyoom.Orientation
---@param margin integer
---@param parent Nyoom.UIElement
---@return Nyoom.UILayout
function prefabs.newLayout(x, y, orientation, margin, parent)
  return newLayout(x, y, orientation, margin, parent)
end

---A UI element that only renders contents within it's dimensions.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param parent Nyoom.UIElement
---@return Nyoom.UIViewport
function prefabs.newViewport(x, y, width, height, parent)
  return newViewport(x, y, width, height, parent)
end

---A UI element that allows content larger than itself to be contained within, and to pan across said content using scrollbars.
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param parent Nyoom.UIElement
---@return Nyoom.UIScrollview
function prefabs.newScrollview(x, y, width, height, parent)
  return newScrollview(x, y, width, height, parent)
end

return prefabs