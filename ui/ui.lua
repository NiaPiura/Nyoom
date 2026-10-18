---@diagnostic disable: invisible

---A lightweight and adaptable event and callback driven UI system.
nyoom.ui = {
  root = nil, ---@type nyoom.UIElement
  focused = nil, ---@type nyoom.UIElement?
  topmost = nil ---@type nyoom.UIElement
}

require('nyoom.ui.element')
require('nyoom.ui.prefabs')

nyoom.ui.root = nyoom.ui.newElement('root', 0, 0, love.graphics.getDimensions())
nyoom.ui.topmost = nyoom.ui.root

function nyoom.ui.root:onResize(dimensions) self.size = dimensions end

local hoverStack = {} ---@type nyoom.UIElement[]
local clickCache = {} ---@type table<number, nyoom.UIElement[]>
local lastMousePosition = nyoom.objects.newVector2()

----@param mousePosition nyoom.Vector2
--[[ local function regenerateHoverStack(mousePosition)
  hoverStack = {}
  local searchQueue = { ui.root }

  while #searchQueue > 0 do
    local element = searchQueue[1]
    if element.isIgnored and element.isHovered then element:unhover() end
    if not element.isIgnored and element.isVisible and element.boundingBox:isWithinBounds(mousePosition) then
      table.insert(hoverStack, element)
    end

    if element.isVisible and element.boundingBox:isWithinBounds(mousePosition)then
      for _, child in ipairs(element.children) do
        table.insert(searchQueue, child)
      end
    end

    table.remove(searchQueue, 1)
  end
end ]]

---@param mousePosition nyoom.Vector2
local function checkHoverStackRecursive(mousePosition, element)
  if element.isIgnored and element.isHovered then element:unhover() end
  if not element.isIgnored and element.isVisible and element.boundingBox:isWithinBounds(mousePosition) then
    table.insert(hoverStack, element)
  end

  if element.isVisible and element.boundingBox:isWithinBounds(mousePosition)then
    for _, child in ipairs(element.children) do
      checkHoverStackRecursive(mousePosition, child)
    end
  end
end

local function regenerateHoverStack(mousePosition)
  hoverStack = {}
  checkHoverStackRecursive(mousePosition, nyoom.ui.root)
end

---@param eventData { position: nyoom.Vector2 }
local function mouseMoved(eventData)
  for _, element in ipairs(hoverStack) do
    if not element.boundingBox:isWithinBounds(eventData.position) then element:unhover() end
  end

  regenerateHoverStack(eventData.position)

  if nyoom.ui.topmost ~= hoverStack[#hoverStack] then
    nyoom.ui.topmost.isTopmost = false
    nyoom.ui.topmost = hoverStack[#hoverStack]
    nyoom.ui.topmost.isTopmost = true
  end

  for _, element in ipairs(hoverStack) do
    if lastMousePosition ~= eventData.position then element:mousemove(eventData.position - element.position) end
    if not element.isHovered then element:hover() end
  end

  lastMousePosition = eventData.position
end

---@param eventData { position: nyoom.Vector2, button: number }
local function mousePressed(eventData)
  clickCache[eventData.button] = {}
  for _, element in ipairs(hoverStack) do
    if not element.isIgnored then
      element:press(eventData.position - element.position, eventData.button)
      table.insert(clickCache[eventData.button], element)
    end
  end
end

---@param eventData { position: nyoom.Vector2, button: number, presses: number}
local function mouseReleased(eventData)
  if nyoom.ui.focused and nyoom.ui.focused ~= clickCache[eventData.button][#clickCache[eventData.button]] then
    nyoom.ui.focused:unfocus()
    nyoom.ui.focused = nil
  end

  for i, element in ipairs(clickCache[eventData.button]) do
    local delta = eventData.position - element.position
    element:release(delta, eventData.button)
    if element.boundingBox:isWithinBounds(eventData.position) then element:click(delta, eventData.button, eventData.presses) end

    if not element.isFocused and i == #clickCache[eventData.button] then
      nyoom.ui.focused = element
      element:focus()
    end
  end
end

---@param eventData { direction: nyoom.Vector2 }
local function wheelMoved(eventData)
  nyoom.ui.root:wheel(eventData.direction)
end

---@param eventData { dimensions: nyoom.Vector2 }
local function resize(eventData)
  nyoom.ui.root:resize(eventData.dimensions)
end

function nyoom.ui.updateMouse()
  local mouseX, mouseY = love.mouse.getPosition()
  mouseMoved({ position = nyoom.objects.newVector2(mouseX, mouseY) })
end

function nyoom.ui.updateElements(deltaTime)
  nyoom.ui.root:update(deltaTime)
end

function nyoom.ui.draw()
  love.graphics.setColor(1, 1, 1)
  nyoom.ui.root:draw()

  if nyoom.ui.topmost.onTooltip then
    love.graphics.push()
    love.graphics.translate(nyoom.ui.topmost.rect.x, nyoom.ui.topmost.rect.y)
    nyoom.ui.topmost:onTooltip()
    love.graphics.pop()
  end
end

function nyoom.ui.isUIHovered()
  return nyoom.ui.topmost ~= nyoom.ui.root
end

-- Love event hooks
nyoom.events.eventMousePressed:addListener(mousePressed)
nyoom.events.eventMouseReleased:addListener(mouseReleased)
nyoom.events.eventWheelMoved:addListener(wheelMoved)
nyoom.events.eventResize:addListener(resize)