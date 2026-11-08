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
local uiCanvas = love.graphics.newCanvas() ---@type love.Canvas

nyoom.ui.root.eventResize:addListener(function(eventData)
  uiCanvas = love.graphics.newCanvas((eventData.dimensions):getAxes())
end)

do
  local uiscale = nyoom.settings.get('uiscale') --[[@as number]]
  if uiscale ~= 1 then
    nyoom.ui.root:setSize(love.graphics.getWidth() / uiscale, love.graphics.getHeight() / uiscale)
  end
end

nyoom.ui.topmost = nyoom.ui.root

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
  local mousePosition = nyoom.ui.projectMousePosition(eventData.position)
  for _, element in ipairs(hoverStack) do
    if not element.boundingBox:isWithinBounds(mousePosition) then element:unhover() end
  end

  regenerateHoverStack(mousePosition)

  if nyoom.ui.topmost ~= hoverStack[#hoverStack] then
    nyoom.ui.topmost.isTopmost = false
    nyoom.ui.topmost = hoverStack[#hoverStack]
    nyoom.ui.topmost.isTopmost = true
  end

  for _, element in ipairs(hoverStack) do
    if lastMousePosition ~= mousePosition then element:mousemove(mousePosition - element.position) end
    if not element.isHovered then element:hover() end
  end

  lastMousePosition = mousePosition
end

---@param eventData { position: nyoom.Vector2, button: number }
local function mousePressed(eventData)
  local mousePosition = nyoom.ui.projectMousePosition(eventData.position)
  clickCache[eventData.button] = {}
  for _, element in ipairs(hoverStack) do
    if not element.isIgnored then
      element:press(mousePosition - element.position, eventData.button)
      table.insert(clickCache[eventData.button], element)
    end
  end
end

---@param eventData { position: nyoom.Vector2, button: number, presses: number}
local function mouseReleased(eventData)
  local mousePosition = nyoom.ui.projectMousePosition(eventData.position)
  if nyoom.ui.focused and nyoom.ui.focused ~= clickCache[eventData.button][#clickCache[eventData.button]] then
    nyoom.ui.focused:unfocus()
    nyoom.ui.focused = nil
  end

  for i, element in ipairs(clickCache[eventData.button]) do
    local delta = mousePosition - element.position
    element:release(delta, eventData.button)
    if element.boundingBox:isWithinBounds(mousePosition) then element:click(delta, eventData.button, eventData.presses) end

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
  nyoom.ui.root:setSize(eventData.dimensions)
end

function nyoom.ui.projectMousePosition(screenPosition)
  local uiscale = nyoom.settings.get('uiscale') --[[@as number]]
  if not screenPosition then screenPosition = nyoom.objects.newVector2(love.mouse.getPosition()) end
  return nyoom.objects.newVector2(math.floor(screenPosition.x / uiscale), math.floor(screenPosition.y / uiscale))
end

function nyoom.ui.updateMouse()
  local mouseX, mouseY = love.mouse.getPosition()
  mouseMoved({ position = nyoom.objects.newVector2(mouseX, mouseY) })
end

function nyoom.ui.update(deltaTime)
  nyoom.ui.root:update(deltaTime)
end

function nyoom.ui.draw()
  love.graphics.setColor(1, 1, 1)
  local returnCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(uiCanvas)
  love.graphics.clear()

  nyoom.ui.root:draw()

  if nyoom.ui.topmost.onTooltip then
    love.graphics.push()
    love.graphics.translate(nyoom.ui.topmost.rect.x, nyoom.ui.topmost.rect.y)
    nyoom.ui.topmost:onTooltip()
    love.graphics.pop()
  end

  love.graphics.setCanvas(returnCanvas)

  love.graphics.setColor(1, 1, 1)
  local uiscale = nyoom.settings.get('uiscale') --[[@as number]]
  love.graphics.draw(uiCanvas, 0, 0, 0, uiscale, uiscale)
end

function nyoom.ui.isUIHovered()
  return nyoom.ui.topmost ~= nyoom.ui.root
end

--nyoom.ui.setRenderScale(nyoom.settings.get('uiscale'))

-- Love event hooks
nyoom.events.eventMousePressed:addListener(mousePressed)
nyoom.events.eventMouseReleased:addListener(mouseReleased)
nyoom.events.eventWheelMoved:addListener(wheelMoved)
nyoom.events.eventResize:addListener(resize)