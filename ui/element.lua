---@diagnostic disable: invisible

---@class nyoom.UIElement
---@field id string
---@field relativePosition nyoom.Vector2
---@field x number
---@field y number
---@field width number
---@field height number
---@field position nyoom.Vector2
---@field size nyoom.Vector2
---@field rect nyoom.Rect
---@field boundingBox nyoom.Rect
---@field parent nyoom.UIElement?
---@field children nyoom.UIElement[]
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
---@field private update fun(self: nyoom.UIElement, deltaTime: number)
---@field private draw fun(self: nyoom.UIElement)
---@field private click fun(self: nyoom.UIElement, position: nyoom.Vector2, button: number, presses: number)
---@field private press fun(self: nyoom.UIElement, position: nyoom.Vector2, button: number)
---@field private release fun(self: nyoom.UIElement, position: nyoom.Vector2, button: number)
---@field private mousemove fun(self: nyoom.UIElement, position: nyoom.Vector2)
---@field private hover fun(self: nyoom.UIElement)
---@field private unhover fun(self: nyoom.UIElement)
---@field private focus fun(self: nyoom.UIElement)
---@field private unfocus fun(self: nyoom.UIElement)
---@field private wheel fun(self: nyoom.UIElement, delta: nyoom.Vector2)
---@field private resize fun(self: nyoom.UIElement, dimensions: nyoom.Vector2)
---
---@field addChild fun(self: nyoom.UIElement, element: nyoom.UIElement): nyoom.UIElement
---@field removeChild fun(self: nyoom.UIElement, element: nyoom.UIElement): nyoom.UIElement
---@field getChild fun(self: nyoom.UIElement, id: string): nyoom.UIElement?
---@field setPosition fun(self: nyoom.UIElement, x: number, y: number)
---@field setPosition fun(self: nyoom.UIElement, position: nyoom.Vector2)
---@field setSize fun(self: nyoom.UIElement, width: number, height: number)
---@field setSize fun(self: nyoom.UIElement, size: nyoom.Vector2)
---@field updateScreenPosition fun(self: nyoom.UIElement)
---@field getRelativeMousePosition fun(self: nyoom.UIElement): nyoom.Vector2
---
---@field onUpdate fun(self: nyoom.UIElement, deltaTime: number)?
---@field onPostUpdate fun(self: nyoom.UIElement)?
---@field onDraw fun(self: nyoom.UIElement)?
---@field onPostDraw fun(self: nyoom.UIElement)?
---@field onTooltip fun(self: nyoom.UIElement)?
---
---@field eventMouseClick nyoom.Event<{ position: nyoom.Vector2, button: number, presses: number }>
---@field eventMousePress nyoom.Event<{ position: nyoom.Vector2, button: number}>
---@field eventMouseRelease nyoom.Event<{ position: nyoom.Vector2, button: number}>
---@field eventMouseMove nyoom.Event<{ position: nyoom.Vector2 }>
---@field eventHover nyoom.Event
---@field eventUnhover nyoom.Event
---@field eventFocus nyoom.Event
---@field eventUnfocus nyoom.Event
---@field eventMouseWheel nyoom.Event<{ delta: nyoom.Vector2 }>
---@field eventResize nyoom.Event<{ dimensions: nyoom.Vector2 }>

---@class ElementStates
---@field isVisible boolean?
---@field isEnabled boolean?
---@field isIgnored boolean?
---@field isTopmost boolean?
---@field isPressed boolean?
---@field isHovered boolean?
---@field isFocused boolean?

local methods, metamethods = {}, { __name = 'nyoom.UIElement' }

---Creates a new element.
---@param id string
---@param x number
---@param y number
---@param width number
---@param height number
---@param parent? nyoom.UIElement
---@param state? ElementStates
---@return nyoom.UIElement
function nyoom.ui.newElement(id, x, y, width, height, parent, state)
  local element = {
    id = id or '',
    relativePosition = nyoom.objects.newVector2(x, y),
    rect = nyoom.objects.newRect(x, y, width, height),
    boundingBox = nyoom.objects.newRect(x, y, width, height),

    isVisible = true,
    isEnabled = true,
    isIgnored = (state and state.isIgnored) or false,
    isTopmost = (state and state.isTopmost) or false,
    isPressed = (state and state.isPressed) or false,
    isHovered = (state and state.isHovered) or false,
    isFocused = (state and state.isFocused) or false,

    eventMouseClick = nyoom.events.newEvent(),
    eventMousePress = nyoom.events.newEvent(),
    eventMouseRelease = nyoom.events.newEvent(),
    eventMouseMove = nyoom.events.newEvent(),
    eventHover = nyoom.events.newEvent(),
    eventUnhover = nyoom.events.newEvent(),
    eventFocus = nyoom.events.newEvent(),
    eventUnfocus = nyoom.events.newEvent(),
    eventMouseWheel = nyoom.events.newEvent(),
    eventResize = nyoom.events.newEvent(),

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

---@param self nyoom.UIElement
function methods:update(deltaTime)
  if not self.isEnabled then return end
  if self.onUpdate then self:onUpdate(deltaTime) end
  for _, e in ipairs(self.children) do e:update(deltaTime) end
  if self.onPostUpdate then self:onPostUpdate() end
end

---@param self nyoom.UIElement
function methods:draw()
  if not self.isVisible then return end
  love.graphics.push()
  love.graphics.translate(self.relativePosition.x, self.relativePosition.y)
  if self.onDraw then self:onDraw() end
  for _, e in ipairs(self.children) do e:draw() end
  if self.onPostDraw then self:onPostDraw() end
  love.graphics.pop()
end

-- Event Handling

---@param self nyoom.UIElement
function methods:click(position, button, presses)
  self.eventMouseClick:trigger({ position = position, button = button, presses = presses })
end

---@param self nyoom.UIElement
function methods:press(position, button)
  self.isPressed = true
  self.eventMousePress:trigger({ position = position, button = button })
end

---@param self nyoom.UIElement
function methods:release(position, button)
  self.isPressed = false
  self.eventMouseRelease:trigger({ position = position, button = button })
end

---@param self nyoom.UIElement
function methods:mousemove(position)
  self.eventMouseMove:trigger({ position = position })
end

---@param self nyoom.UIElement
function methods:hover()
  self.isHovered = true
  self.eventHover:trigger()
end

---@param self nyoom.UIElement
function methods:unhover()
  self.isHovered = false
  self.eventUnhover:trigger()
end

---@param self nyoom.UIElement
function methods:focus()
  self.isFocused = true
  self.eventFocus:trigger()
end

---@param self nyoom.UIElement
function methods:unfocus()
  self.isFocused = false
  self.eventUnfocus:trigger()
end

---@param self nyoom.UIElement
function methods:wheel(delta)
  self.eventMouseWheel:trigger({ delta = delta })
  for _, e in ipairs(self.children) do e:wheel(delta) end
end

---@param self nyoom.UIElement
function methods:resize(dimensions)
  if not self._isResizing then
    self._isResizing = true
    self.eventResize:trigger(dimensions)
  end
  for _, e in ipairs(self.children) do e:resize(dimensions) end
  self._isResizing = false
end

-- Hierarchy manipulation / tooling

---@param self nyoom.UIElement
function methods:addChild(element)
  if element.parent then table.removeValue(element.parent.children, element) end
  table.insert(self.children, element)
  element.parent = self
  element:updateScreenPosition()
  return self
end

---@param self nyoom.UIElement
function methods:removeChild(element)
  table.removeValue(self.children, element)
  element.parent = nil
  return self
end

---@param self nyoom.UIElement
function methods:getChild(id)
  for _, element in ipairs(self.children) do
    if element.id == id then return element end
  end
end

---@param self nyoom.UIElement
function methods:setPosition(x, y)
  if type(x) == 'number' then self.relativePosition = nyoom.objects.newVector2(x, y)
  else self.relativePosition = x end
  self:updateScreenPosition()
end

---@param self nyoom.UIElement
function methods:setSize(width, height)
  if type(width) == 'number' then self.rect:setSize(width, height)
  else self.rect:setSize(width) end

  self.boundingBox:setSize(self.rect.size)

  self:resize(self.rect.size)
end

---@param self nyoom.UIElement
function methods:updateScreenPosition()
  if self.parent then
    self.rect:setPosition(self.parent.rect.position + self.relativePosition)
    for _, child in ipairs(self.children) do child:updateScreenPosition() end
  else
    self.rect:setPosition(self.relativePosition)
  end

  self.boundingBox:setPosition(self.rect.position)
end

---@param self nyoom.UIElement
function methods:getRelativeMousePosition()
  local mousePosition = nyoom.objects.newVector2(love.mouse.getPosition())
  return mousePosition - self.rect.position
end

-- Metamethods

function metamethods:__index(key)
  if key == 'x' then return self.relativePosition.x end
  if key == 'y' then return self.relativePosition.y end
  if key == 'width' then return self.rect.width end
  if key == 'height' then return self.rect.height end
  if key == 'position' then return self.rect.position end
  if key == 'size' then return self.rect.size end
  return methods[key]
end

---@param self nyoom.UIElement
function metamethods:__newindex(key, value)
  if key == 'x' then self:setPosition(value, self.relativePosition.y)
  elseif key == 'y' then self:setPosition(self.relativePosition.x, value)
  elseif key == 'width' then self:setSize(value, self.height)
  elseif key == 'height' then self:setSize(self.width, value)
  elseif key == 'position' then self:setPosition(value)
  elseif key == 'size' then self:setSize(value)
  else rawset(self, key, value) end
end

function metamethods:__tostring()
  return self.id
end