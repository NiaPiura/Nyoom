---@diagnostic disable: invisible

---A cute, minimalistic event-driven UI system
---@class Nui
---@field update fun(deltaTime: number)
---@field draw fun()
local nui = {
  newElement = require('nyoom.nui.element'),
  root = nil, ---@type Element
  focused = nil, ---@type Element?
  topmost = nil, ---@type Element
}

nui.root = nui.newElement('root', 0, 0, love.graphics.getDimensions())
nui.topmost = nui.root
function nui.root:onResize(dimensions) self.size = dimensions end

local hoverStack = {} ---@type Element[]
local clickCache = {} ---@type table<number, Element[]>

function nui.update(deltaTime)
  nui.root:update(deltaTime)
end

function nui.draw()
  love.graphics.setColor(1, 1, 1, 1)
  nui.root:draw()
end

---@param mouseX number
---@param mouseY number
local function mouseMoved(mouseX, mouseY)
  local mousePosition = nyoom.objects.newVector2(mouseX, mouseY)
  for _, element in ipairs(hoverStack) do
    if not element.rect:isWithinBounds(mousePosition) then element:unhover() end
  end

  hoverStack = {}
  local searchQueue = { nui.root }

  while #searchQueue > 0 do
    local element = searchQueue[1]
    if not element.isIgnored and element.rect:isWithinBounds(mousePosition) then table.insert(hoverStack, element) end
    for _, child in ipairs(element.children) do table.insert(searchQueue, child) end
    table.remove(searchQueue, 1)
  end

  if nui.topmost ~= hoverStack[#hoverStack] then
    nui.topmost.isTopmost = false
    nui.topmost = hoverStack[#hoverStack]
    nui.topmost.isTopmost = true
  end

  for _, element in ipairs(hoverStack) do
    element:mousemove(mousePosition - element.position)
    if not element.isHovered then element:hover() end
  end
end

---@param mouseX number
---@param mouseY number
---@param button number
local function mousePressed(mouseX, mouseY, button)
  local mousePosition = nyoom.objects.newVector2(mouseX, mouseY)
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
  local mousePosition = nyoom.objects.newVector2(mouseX, mouseY)
  if nui.focused and nui.focused ~= clickCache[button][#clickCache[button]] then
    nui.focused:unfocus()
    nui.focused = nil
  end

  for i, element in ipairs(clickCache[button]) do
    local delta = mousePosition - element.position
    element:release(delta, button)
    if element.rect:isWithinBounds(mousePosition) then element:click(delta, button, presses) end

    if not element.isFocused and i == #clickCache[button] then
      nui.focused = element
      element:focus()
    end
  end
end

---@param deltaX number
---@param deltaY number
local function wheelMoved(deltaX, deltaY)
  nui.root:wheel(nyoom.objects.newVector2(deltaX, deltaY))
end

---@param width number
---@param height number
local function resize(width, height)
  nui.root:resize(nyoom.objects.newVector2(width, height))
end

-- Love event hooks
nyoom.events.listen('love.mousemoved', mouseMoved)
nyoom.events.listen('love.mousepressed', mousePressed)
nyoom.events.listen('love.mousereleased', mouseReleased)
nyoom.events.listen('love.wheelmoved', wheelMoved)
nyoom.events.listen('love.resize', resize)

return nui