---@diagnostic disable: invisible

---@class Nyoom.UIElement
---@field id string
---@field offset Nyoom.Vector2
---@field x number
---@field y number
---@field width number
---@field height number
---@field position Nyoom.Vector2
---@field size Nyoom.Vector2
---@field rect Nyoom.Rect
---@field parent Nyoom.UIElement?
---@field children Nyoom.UIElement[]
---
---@field isVisible boolean
---@field isEnabled boolean
---@field isIgnored boolean
---@field isTopmost boolean
---@field isPressed boolean
---@field isHovered boolean
---@field isFocused boolean
---
---@field private _isResizing boolean Prevents infinite loops by halting resize triggers during a resize trigger.
---
---@field private update fun(self: Nyoom.UIElement, deltaTime: number)
---@field private draw fun(self: Nyoom.UIElement)
---@field private click fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number, presses: number)
---@field private press fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number)
---@field private release fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number)
---@field private mousemove fun(self: Nyoom.UIElement, position: Nyoom.Vector2)
---@field private hover fun(self: Nyoom.UIElement)
---@field private unhover fun(self: Nyoom.UIElement)
---@field private focus fun(self: Nyoom.UIElement)
---@field private unfocus fun(self: Nyoom.UIElement)
---@field private wheel fun(self: Nyoom.UIElement, delta: Nyoom.Vector2)
---@field private resize fun(self: Nyoom.UIElement, dimensions: Nyoom.Vector2)
---
---@field addChild fun(self: Nyoom.UIElement, element: Nyoom.UIElement): Nyoom.UIElement
---@field removeChild fun(self: Nyoom.UIElement, element: Nyoom.UIElement): Nyoom.UIElement
---@field getChild fun(self: Nyoom.UIElement, id: string): Nyoom.UIElement?
---@field setPosition fun(self: Nyoom.UIElement, x: number, y: number)
---@field setPosition fun(self: Nyoom.UIElement, position: Nyoom.Vector2)
---@field setSize fun(self: Nyoom.UIElement, width: number, height: number)
---@field setSize fun(self: Nyoom.UIElement, size: Nyoom.Vector2)
---@field updateScreenPosition fun(self: Nyoom.UIElement)
---@field getRelativeMousePosition fun(self: Nyoom.UIElement): Nyoom.Vector2
---
---@field onUpdate fun(self: Nyoom.UIElement, deltaTime: number)?
---@field onPostUpdate fun(self: Nyoom.UIElement)?
---@field onDraw fun(self: Nyoom.UIElement)?
---@field onPostDraw fun(self: Nyoom.UIElement)?
---@field onClick fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number, presses: number)?
---@field onPress fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number)?
---@field onRelease fun(self: Nyoom.UIElement, position: Nyoom.Vector2, button: number)?
---@field onMouseMove fun(self: Nyoom.UIElement, position: Nyoom.Vector2)?
---@field onHover fun(self: Nyoom.UIElement)?
---@field onUnhover fun(self: Nyoom.UIElement)?
---@field onFocus fun(self: Nyoom.UIElement)?
---@field onUnfocus fun(self: Nyoom.UIElement)?
---@field onWheel fun(self: Nyoom.UIElement, delta: Nyoom.Vector2)?
---@field onResize fun(self: Nyoom.UIElement, dimensions: Nyoom.Vector2)?

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
---@param parent? Nyoom.UIElement
---@param state? ElementStates
---@return Nyoom.UIElement
local function newElement(id, x, y, width, height, parent, state)
  local element = {
    id = id or '',
    offset = nyoom.common.newVector2(x, y),
    rect = nyoom.common.newRect(x, y, width, height),

    isVisible = true,
    isEnabled = true,
    isIgnored = (state and state.isIgnored) or false,
    isTopmost = (state and state.isTopmost) or false,
    isPressed = (state and state.isPressed) or false,
    isHovered = (state and state.isHovered) or false,
    isFocused = (state and state.isFocused) or false,

    parent = nil,
    children = {}
  }

  if state and state.isVisible == false then element.isVisible = false end
  if state and state.isEnabled == false then element.isEnabled = false end

  setmetatable(element, metamethods)

  if parent and parent.addChild then parent:addChild(element) end

  return element
end

-- Methods
-- Runtime Callbacks

---@param self Nyoom.UIElement
function methods:update(deltaTime)
  if not self.isEnabled then return end
  if self.onUpdate then self:onUpdate(deltaTime) end
  for _, e in ipairs(self.children) do e:update(deltaTime) end
  if self.onPostUpdate then self:onPostUpdate() end
end

---@param self Nyoom.UIElement
function methods:draw()
  if not self.isVisible then return end
  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)
  if self.onDraw then self:onDraw() end
  for _, e in ipairs(self.children) do e:draw() end
  if self.onPostDraw then self:onPostDraw() end
  love.graphics.pop()
end

-- Event Handling

---@param self Nyoom.UIElement
function methods:click(position, button, presses)
  if self.onClick then self:onClick(position, button, presses) end
end

---@param self Nyoom.UIElement
function methods:press(position, button)
  self.isPressed = true
  if self.onPress then self:onPress(position, button) end
end

---@param self Nyoom.UIElement
function methods:release(position, button)
  self.isPressed = false
  if self.onRelease then self:onRelease(position, button) end
end

---@param self Nyoom.UIElement
function methods:mousemove(position)
  if self.onMouseMove then self:onMouseMove(position) end
end

---@param self Nyoom.UIElement
function methods:hover()
  self.isHovered = true
  if self.onHover then self:onHover() end
end

---@param self Nyoom.UIElement
function methods:unhover()
  self.isHovered = false
  if self.onUnhover then self:onUnhover() end
end

---@param self Nyoom.UIElement
function methods:focus()
  self.isFocused = true
  if self.onFocus then self:onFocus() end
end

---@param self Nyoom.UIElement
function methods:unfocus()
  self.isFocused = false
  if self.onUnfocus then self:onUnfocus() end
end

---@param self Nyoom.UIElement
function methods:wheel(delta)
  if self.onWheel then self:onWheel(delta) end
  for _, e in ipairs(self.children) do e:wheel(delta) end
end

---@param self Nyoom.UIElement
function methods:resize(dimensions)
  if not self._isResizing and self.onResize then
    self._isResizing = true
    self:onResize(dimensions)
  end
  for _, e in ipairs(self.children) do e:resize(dimensions) end
  self._isResizing = false
end

-- Hierarchy manipulation / tooling

---@param self Nyoom.UIElement
function methods:addChild(element)
  if element.parent then table.removeValue(element.parent.children, element) end
  table.insert(self.children, element)
  element.parent = self
  element:updateScreenPosition()
  return self
end

---@param self Nyoom.UIElement
function methods:removeChild(element)
  table.removeValue(self.children, element)
  element.parent = nil
  return self
end

---@param self Nyoom.UIElement
function methods:getChild(id)
  for _, element in ipairs(self.children) do
    if element.id == id then return element end
  end
end

---@param self Nyoom.UIElement
function methods:setPosition(x, y)
  if type(x) == 'number' then self.offset = nyoom.common.newVector2(x, y)
  else self.offset = x end
  self:updateScreenPosition()
end

---@param self Nyoom.UIElement
function methods:setSize(width, height)
  if type(width) == 'number' then self.rect.size = nyoom.common.newVector2(width, height)
  else self.rect.size = width end
  self:resize(self.rect.size)
end

---@param self Nyoom.UIElement
function methods:updateScreenPosition()
  if self.parent then
    self.rect.position = self.parent.rect.position + self.offset
    for _, child in ipairs(self.children) do child:updateScreenPosition() end
  else
    self.rect.position = self.offset
  end
end

---@param self Nyoom.UIElement
function methods:getRelativeMousePosition()
  local mousePosition = nyoom.common.newVector2(love.mouse.getPosition())
  return mousePosition - self.rect.position
end

-- Metamethods

function metamethods:__index(key)
  if key == 'x' then return self.offset.x end
  if key == 'y' then return self.offset.y end
  if key == 'width' then return self.rect.width end
  if key == 'height' then return self.rect.height end
  if key == 'position' then return self.rect.position end
  if key == 'size' then return self.rect.size end
  return methods[key]
end

---@param self Nyoom.UIElement
function metamethods:__newindex(key, value)
  if key == 'x' then self:setPosition(value, self.offset.y)
  elseif key == 'y' then self:setPosition(self.offset.x, value)
  elseif key == 'width' then self:setSize(value, self.height)
  elseif key == 'height' then self:setSize(self.width, value)
  elseif key == 'position' then self:setPosition(value)
  elseif key == 'size' then self:setSize(value)
  else rawset(self, key, value) end
end

function metamethods:__tostring()
  return self.id
end

return newElement