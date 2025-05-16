---@diagnostic disable: invisible

---@class Nyoom.Element
---@field id string
---@field offset Nyoom.Vector2 Read-only
---@field x number
---@field y number
---@field width number
---@field height number
---@field position Nyoom.Vector2
---@field size Nyoom.Vector2
---@field rect Nyoom.Rect read-only
---@field parent Nyoom.Element? Read-only
---@field children Nyoom.Element[] Read-only
---
---@field isVisible boolean Read-only
---@field isEnabled boolean Read-only
---@field isIgnored boolean Read-only
---@field isTopmost boolean Read-only
---@field isPressed boolean Read-only
---@field isHovered boolean Read-only
---@field isFocused boolean Read-only
---
---@field private update fun(self: Nyoom.Element, deltaTime: number)
---@field private draw fun(self: Nyoom.Element)
---@field private click fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number, presses: number)
---@field private press fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number)
---@field private release fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number)
---@field private mousemove fun(self: Nyoom.Element, position: Nyoom.Vector2)
---@field private hover fun(self: Nyoom.Element)
---@field private unhover fun(self: Nyoom.Element)
---@field private focus fun(self: Nyoom.Element)
---@field private unfocus fun(self: Nyoom.Element)
---@field private wheel fun(self: Nyoom.Element, delta: Nyoom.Vector2)
---@field private resize fun(self: Nyoom.Element, dimentions: Nyoom.Vector2)
---
---@field addChild fun(self: Nyoom.Element, element: Nyoom.Element): Nyoom.Element
---@field removeChild fun(self: Nyoom.Element, element: Nyoom.Element): Nyoom.Element
---@field getChild fun(self: Nyoom.Element, id: string): Nyoom.Element
---@field setPosition fun(self: Nyoom.Element, x: number, y: number)
---@field setPosition fun(self: Nyoom.Element, position: Nyoom.Vector2)
---@field setSize fun(self: Nyoom.Element, width: number, height: number)
---@field setSize fun(self: Nyoom.Element, size: Nyoom.Vector2)
---@field updateScreenPosition fun(self: Nyoom.Element)
---@field getRelativeMousePosition fun(self: Nyoom.Element): Nyoom.Vector2
---
---@field onUpdate fun(self: Nyoom.Element, deltaTime: number)?
---@field onPostUpdate fun(self: Nyoom.Element)?
---@field onDraw fun(self: Nyoom.Element)?
---@field onPostDraw fun(self: Nyoom.Element)?
---@field onClick fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number, presses: number)?
---@field onPress fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number)?
---@field onRelease fun(self: Nyoom.Element, position: Nyoom.Vector2, button: number)?
---@field onMouseMove fun(self: Nyoom.Element, position: Nyoom.Vector2)?
---@field onHover fun(self: Nyoom.Element)?
---@field onUnhover fun(self: Nyoom.Element)?
---@field onFocus fun(self: Nyoom.Element)?
---@field onUnfocus fun(self: Nyoom.Element)?
---@field onWheel fun(self: Nyoom.Element, delta: Nyoom.Vector2)?
---@field onResize fun(self: Nyoom.Element, dimentions: Nyoom.Vector2)?

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
---@param parent? Nyoom.Element
---@param state? ElementStates
---@return Nyoom.Element
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

---@param self Nyoom.Element
function methods:update(deltaTime)
  if self.isEnabled and self.onUpdate then self:onUpdate(deltaTime) end
  for _, e in ipairs(self.children) do e:update(deltaTime) end
  if self.isEnabled and self.onPostUpdate then self:onPostUpdate() end
end

---@param self Nyoom.Element
function methods:draw()
  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)
  if self.isVisible and self.onDraw then self:onDraw() end
  for _, e in ipairs(self.children) do e:draw() end
  if self.isVisible and self.onPostDraw then self:onPostDraw() end
  love.graphics.pop()
end

-- Event Handling

---@param self Nyoom.Element
function methods:click(position, button, presses)
  if self.onClick then self:onClick(position, button, presses) end
end

---@param self Nyoom.Element
function methods:press(position, button)
  self.isPressed = true
  if self.onPress then self:onPress(position, button) end
end

---@param self Nyoom.Element
function methods:release(position, button)
  self.isPressed = false
  if self.onRelease then self:onRelease(position, button) end
end

---@param self Nyoom.Element
function methods:mousemove(position)
  if self.onMouseMove then self:onMouseMove(position) end
end

---@param self Nyoom.Element
function methods:hover()
  self.isHovered = true
  if self.onHover then self:onHover() end
end

---@param self Nyoom.Element
function methods:unhover()
  self.isHovered = false
  if self.onUnhover then self:onUnhover() end
end

---@param self Nyoom.Element
function methods:focus()
  self.isFocused = true
  if self.onFocus then self:onFocus() end
end

---@param self Nyoom.Element
function methods:unfocus()
  self.isFocused = false
  if self.onUnfocus then self:onUnfocus() end
end

---@param self Nyoom.Element
function methods:wheel(delta)
  if self.onWheel then self:onWheel(delta) end
  for _, e in ipairs(self.children) do e:wheel(delta) end
end

---@param self Nyoom.Element
function methods:resize(dimensions)
  if self.onResize then self:onResize(dimensions) end
  for _, e in ipairs(self.children) do e:resize(dimensions) end
end

-- Hierarchy manipulation / tooling

---@param self Nyoom.Element
function methods:addChild(element)
  if element.parent then table.removeValue(element.parent.children, element) end
  table.insert(self.children, element)
  element.parent = self
  element:updateScreenPosition()
end

---@param self Nyoom.Element
function methods:removeChild(element)
  table.removeValue(self.children, element)
  element.parent = nil
end

---@param self Nyoom.Element
function methods:getChild(id)
  for _, element in ipairs(self.children) do
    if element.id == id then return element end
  end
end

---@param self Nyoom.Element
function methods:setPosition(x, y)
  if type(x) == 'number' then self.offset = nyoom.common.newVector2(x, y)
  else self.offset = x end
  self:updateScreenPosition()
end

---@param self Nyoom.Element
function methods:setSize(width, height)
  if type(width) == 'number' then self.size = nyoom.common.newVector2(width, height)
  else self.size = width end
  self:resize(self.size)
end

---@param self Nyoom.Element
function methods:updateScreenPosition()
  if self.parent then
    self.position = self.parent.position + self.offset
    for _, child in ipairs(self.children) do child:updateScreenPosition() end
  else
    self.position = self.offset
  end
end

---@param self Nyoom.Element
function methods:getRelativeMousePosition()
  local mousePosition = nyoom.common.newVector2(love.mouse.getPosition())
  return mousePosition - self.position
end

-- Metamethods

function metamethods:__index(key)
  if key == 'x' then return self.rect.x end
  if key == 'y' then return self.rect.y end
  if key == 'width' then return self.rect.width end
  if key == 'height' then return self.rect.height end
  if key == 'position' then return self.rect.position end
  if key == 'size' then return self.rect.size end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'x' then self.rect.x = value
  elseif key == 'y' then self.rect.y = value
  elseif key == 'width' then self.rect.width = value
  elseif key == 'height' then self.rect.height = value
  elseif key == 'position' then self.rect.position = value
  elseif key == 'size' then self.rect.size = value
  else rawset(self, key, value) end
end

function metamethods:__tostring()
  return self.id
end

return newElement