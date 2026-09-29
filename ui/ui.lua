---@diagnostic disable: invisible

---@class Nyoom.UI
---@field update fun(deltaTime: number)
---@field draw fun()
---@field isUIHovered fun(): boolean
---@field defaults Nyoom.UIDefaults
---@field prefabs Nyoom.UIPrefabs
local ui = {
  newElement = require('nyoom.ui.element'),
  root = nil, ---@type Nyoom.UIElement
  focused = nil, ---@type Nyoom.UIElement?
  topmost = nil, ---@type Nyoom.UIElement
}

ui.root = ui.newElement('root', 0, 0, love.graphics.getDimensions())
ui.defaults = require('nyoom.ui.defaults')
ui.prefabs = require('nyoom.ui.prefabs')
ui.topmost = ui.root
function ui.root:onResize(dimensions) self.size = dimensions end

local hoverStack = {} ---@type Nyoom.UIElement[]
local clickCache = {} ---@type table<number, Nyoom.UIElement[]>
local lastMousePosition = nyoom.common.newVector2()

---@param mousePosition Nyoom.Vector2
local function regenerateHoverStack(mousePosition)
  hoverStack = {}
  local searchQueue = { ui.root }

  while #searchQueue > 0 do
    local element = searchQueue[1]
    if element.isIgnored and element.isHovered then element:unhover() end
    if not element.isIgnored and element.isVisible and element.rect:isWithinBounds(mousePosition) then
      table.insert(hoverStack, element)
    end
    for _, child in ipairs(element.children) do table.insert(searchQueue, child) end
    table.remove(searchQueue, 1)
  end
end

---@param mouseX number
---@param mouseY number
local function mouseMoved(mouseX, mouseY)
  local mousePosition = nyoom.common.newVector2(mouseX, mouseY)
  for _, element in ipairs(hoverStack) do
    if not element.rect:isWithinBounds(mousePosition) then element:unhover() end
  end

  regenerateHoverStack(mousePosition)

  if ui.topmost ~= hoverStack[#hoverStack] then
    ui.topmost.isTopmost = false
    ui.topmost = hoverStack[#hoverStack]
    ui.topmost.isTopmost = true
  end

  for _, element in ipairs(hoverStack) do
    if lastMousePosition ~= mousePosition then element:mousemove(mousePosition - element.position) end
    if not element.isHovered then element:hover() end
  end

  lastMousePosition = mousePosition
end

---@param mouseX number
---@param mouseY number
---@param button number
local function mousePressed(mouseX, mouseY, button)
  local mousePosition = nyoom.common.newVector2(mouseX, mouseY)
  clickCache[button] = {}
  for _, element in ipairs(hoverStack) do
    if not element.isIgnored then
      element:press(mousePosition - element.position, button)
      table.insert(clickCache[button], element)
    end
  end
end

---@param mouseX number
---@param mouseY number
---@param button number
---@param presses number
local function mouseReleased(mouseX, mouseY, button, _, presses)
  local mousePosition = nyoom.common.newVector2(mouseX, mouseY)
  if ui.focused and ui.focused ~= clickCache[button][#clickCache[button]] then
    ui.focused:unfocus()
    ui.focused = nil
  end

  for i, element in ipairs(clickCache[button]) do
    local delta = mousePosition - element.position
    element:release(delta, button)
    if element.rect:isWithinBounds(mousePosition) then element:click(delta, button, presses) end

    if not element.isFocused and i == #clickCache[button] then
      ui.focused = element
      element:focus()
    end
  end
end

---@param deltaX number
---@param deltaY number
local function wheelMoved(deltaX, deltaY)
  ui.root:wheel(nyoom.common.newVector2(deltaX, deltaY))
end

---@param width number
---@param height number
local function resize(width, height)
  ui.root:resize(nyoom.common.newVector2(width, height))
end

function ui.updateMouse()
  local mouseX, mouseY = love.mouse.getPosition()
  mouseMoved(mouseX, mouseY)
end

function ui.updateElements(deltaTime)
  ui.root:update(deltaTime)
end

function ui.draw()
  love.graphics.setColor(1, 1, 1)
  ui.root:draw()
end

function ui.isUIHovered()
  return nyoom.ui.topmost ~= nyoom.ui.root
end

-- Love event hooks
nyoom.events.mouseMovedEvent:addListener(mouseMoved)
nyoom.events.mousePressedEvent:addListener(mousePressed)
nyoom.events.mouseReleasedEvent:addListener(mouseReleased)
nyoom.events.wheelMovedEvent:addListener(wheelMoved)
nyoom.events.resizeEvent:addListener(resize)

return ui