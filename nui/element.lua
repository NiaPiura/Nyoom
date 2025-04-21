---@diagnostic disable: invisible

---@class Element
---@field id string
---@field offset Vector2 Read-only
---@field position Vector2
---@field size Vector2
---@field rect Rect read-only
---@field parent Element? Read-only
---@field children Element[] Read-only
---
---@field isVisible boolean Read-only
---@field isEnabled boolean Read-only
---@field isIgnored boolean Read-only
---@field isTopmost boolean Read-only
---@field isPressed boolean Read-only
---@field isHovered boolean Read-only
---@field isFocused boolean Read-only
---
---@field private update fun(self: Element, deltaTime: number)
---@field private draw fun(self: Element)
---@field private click fun(self: Element, position: Vector2, button: number, presses: number)
---@field private press fun(self: Element, position: Vector2, button: number)
---@field private release fun(self: Element, position: Vector2, button: number)
---@field private mousemove fun(self: Element, position: Vector2)
---@field private hover fun(self: Element)
---@field private unhover fun(self: Element)
---@field private focus fun(self: Element)
---@field private unfocus fun(self: Element)
---@field private wheel fun(self: Element, delta: Vector2)
---@field private resize fun(self: Element, dimentions: Vector2)
---
---@field addChild fun(self: Element, element: Element): Element
---@field removeChild fun(self: Element, element: Element): Element
---@field getChild fun(self: Element, id: string): Element
---@field setPosition fun(self: Element, x: number, y: number)
---@field setPosition fun(self: Element, position: Vector2)
---@field setSize fun(self: Element, width: number|Vector2, height: number|nil)
---@field updateScreenPosition fun(self: Element)
---@field getRelativeMousePosition fun(self: Element): Vector2
---
---@field onUpdate fun(self: Element, deltaTime: number)?
---@field onPostUpdate fun(self: Element)?
---@field onDraw fun(self: Element)?
---@field onPostDraw fun(self: Element)?
---@field onClick fun(self: Element, position: Vector2, button: number, presses: number)?
---@field onPress fun(self: Element, position: Vector2, button: number)?
---@field onRelease fun(self: Element, position: Vector2, button: number)?
---@field onMouseMove fun(self: Element, position: Vector2)?
---@field onHover fun(self: Element)?
---@field onUnhover fun(self: Element)?
---@field onFocus fun(self: Element)?
---@field onUnfocus fun(self: Element)?
---@field onWheel fun(self: Element, delta: Vector2)?
---@field onResize fun(self: Element, dimentions: Vector2)?

---@class ElementStates
---@field isVisible boolean?
---@field isEnabled boolean?
---@field isIgnored boolean?
---@field isTopmost boolean?
---@field isPressed boolean?
---@field isHovered boolean?
---@field isFocused boolean?

local methods, metamethods = {}, { __name = 'Element' }

---Creates a new element.
---@param id string
---@param x number
---@param y number
---@param width number
---@param height number
---@param parent? Element
---@param state? ElementStates
---@return Element
local function newElement(id, x, y, width, height, parent, state)
  local element = {
    id = id or '',
    offset = nyoom.common.newVector2(x, y),
    rect = nyoom.common.newRect(x, y, width, height),

    isVisible = (state and state.isVisible) or true,
    isEnabled = (state and state.isEnabled) or true,
    isIgnored = (state and state.isIgnored) or false,
    isTopmost = (state and state.isTopmost) or false,
    isPressed = (state and state.isPressed) or false,
    isHovered = (state and state.isHovered) or false,
    isFocused = (state and state.isFocused) or false,

    parent = nil,
    children = {}
  }

  setmetatable(element, metamethods)

  if parent and parent.addChild then parent:addChild(element) end

  return element
end

-- Methods
-- Runtime Callbacks

---@param self Element
function methods:update(deltaTime)
  if self.isEnabled and self.onUpdate then self:onUpdate(deltaTime) end
  for _, e in ipairs(self.children) do e:update(deltaTime) end
  if self.isEnabled and self.onPostUpdate then self:onPostUpdate() end
end

---@param self Element
function methods:draw()
  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)
  if self.isVisible and self.onDraw then self:onDraw() end
  for _, e in ipairs(self.children) do e:draw() end
  if self.isVisible and self.onPostDraw then self:onPostDraw() end
  love.graphics.pop()
end

-- Event Handling

---@param self Element
function methods:click(position, button, presses)
  if self.onClick then self:onClick(position, button, presses) end
end

---@param self Element
function methods:press(position, button)
  self.isPressed = true
  if self.onPress then self:onPress(position, button) end
end

---@param self Element
function methods:release(position, button)
  self.isPressed = false
  if self.onRelease then self:onRelease(position, button) end
end

---@param self Element
function methods:mousemove(position)
  if self.onMouseMove then self:onMouseMove(position) end
end

---@param self Element
function methods:hover()
  self.isHovered = true
  if self.onHover then self:onHover() end
end

---@param self Element
function methods:unhover()
  self.isHovered = false
  if self.onUnhover then self:onUnhover() end
end

---@param self Element
function methods:focus()
  self.isFocused = true
  if self.onFocus then self:onFocus() end
end

---@param self Element
function methods:unfocus()
  self.isFocused = false
  if self.onUnfocus then self:onUnfocus() end
end

---@param self Element
function methods:wheel(delta)
  if self.onWheel then self:onWheel(delta) end
  for _, e in ipairs(self.children) do e:wheel(delta) end
end

---@param self Element
function methods:resize(dimensions)
  if self.onResize then self:onResize(dimensions) end
  for _, e in ipairs(self.children) do e:resize(dimensions) end
end

-- Hierarchy manipulation / tooling

---@param self Element
function methods:addChild(element)
  if element.parent then table.removeValue(element.parent.children, element) end
  table.insert(self.children, element)
  element.parent = self
  element:updateScreenPosition()
end

---@param self Element
function methods:removeChild(element)
  table.removeValue(self.children, element)
  element.parent = nil
end

---@param self Element
function methods:getChild(id)
  for _, element in ipairs(self.children) do
    if element.id == id then return element end
  end
end

---@param self Element
function methods:setPosition(x, y)
  if type(x) == 'number' then self.offset = nyoom.common.newVector2(x, y)
  else self.offset = x end
  self:updateScreenPosition()
end

---@param self Element
function methods:setSize(width, height)
  if type(width) == 'number' then self.size = nyoom.common.newVector2(width, height)
  else self.size = width end
  self:resize(self.size)
end

---@param self Element
function methods:updateScreenPosition()
  if self.parent then
    self.position = self.parent.position + self.offset
    for _, child in ipairs(self.children) do child:updateScreenPosition() end
  else
    self.position = self.offset
  end
end

---@param self Element
function methods:getRelativeMousePosition()
  local mousePosition = nyoom.common.newVector2(love.mouse.getPosition())
  return mousePosition - self.position
end

-- Metamethods

function metamethods:__index(key)
  if key == 'position' then return self.rect.position end
  if key == 'size' then return self.rect.size end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'position' then self.rect.position = value
  elseif key == 'size' then self.rect.size = value
  else rawset(self, key, value) end
end

function metamethods:__tostring()
  return self.id
end

return newElement