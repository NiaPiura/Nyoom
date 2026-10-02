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

    if element.isVisible then
      for _, child in ipairs(element.children) do table.insert(searchQueue, child) end
    end

    table.remove(searchQueue, 1)
  end
end

---@param eventValues { position: Nyoom.Vector2 }
local function mouseMoved(eventValues)
  for _, element in ipairs(hoverStack) do
    if not element.rect:isWithinBounds(eventValues.position) then element:unhover() end
  end

  regenerateHoverStack(eventValues.position)

  if ui.topmost ~= hoverStack[#hoverStack] then
    ui.topmost.isTopmost = false
    ui.topmost = hoverStack[#hoverStack]
    ui.topmost.isTopmost = true
  end

  for _, element in ipairs(hoverStack) do
    if lastMousePosition ~= eventValues.position then element:mousemove(eventValues.position - element.position) end
    if not element.isHovered then element:hover() end
  end

  lastMousePosition = eventValues.position
end

---@param eventValues { position: Nyoom.Vector2, button: number }
local function mousePressed(eventValues)
  clickCache[eventValues.button] = {}
  for _, element in ipairs(hoverStack) do
    if not element.isIgnored then
      element:press(eventValues.position - element.position, eventValues.button)
      table.insert(clickCache[eventValues.button], element)
    end
  end
end

---@param eventValues { position: Nyoom.Vector2, button: number, presses: number}
local function mouseReleased(eventValues)
  if ui.focused and ui.focused ~= clickCache[eventValues.button][#clickCache[eventValues.button]] then
    ui.focused:unfocus()
    ui.focused = nil
  end

  for i, element in ipairs(clickCache[eventValues.button]) do
    local delta = eventValues.position - element.position
    element:release(delta, eventValues.button)
    if element.rect:isWithinBounds(eventValues.position) then element:click(delta, eventValues.button, eventValues.presses) end

    if not element.isFocused and i == #clickCache[eventValues.button] then
      ui.focused = element
      element:focus()
    end
  end
end

---@param eventValues { direction: Nyoom.Vector2 }
local function wheelMoved(eventValues)
  ui.root:wheel(eventValues.direction)
end

---@param eventValues { dimensions: Nyoom.Vector2 }
local function resize(eventValues)
  ui.root:resize(eventValues.dimensions)
end

function ui.updateMouse()
  local mouseX, mouseY = love.mouse.getPosition()
  mouseMoved({ position = nyoom.common.newVector2(mouseX, mouseY) })
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
--nyoom.events.eventMouseMoved:addListener(mouseMoved)
nyoom.events.eventMousePressed:addListener(mousePressed)
nyoom.events.eventMouseReleased:addListener(mouseReleased)
nyoom.events.eventWheelMoved:addListener(wheelMoved)
nyoom.events.eventResize:addListener(resize)

return ui