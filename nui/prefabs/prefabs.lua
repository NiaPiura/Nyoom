local newButton = require('nyoom.nui.prefabs.button')
local newLayer = require('nyoom.nui.prefabs.layer')

---@class Nyoom.NuiPrefabs
---@field newButton fun(text: string, x: number, y: number, width: number, height: number, parent?: Nyoom.Element, buttonColor?: Nyoom.Color, textColor?: Nyoom.Color): Nyoom.Element
---@field newLayer fun(id: string, opacity: number): Nyoom.Layer
local prefabs = {}

function prefabs.newButton(text, x, y, width, height, parent, buttonColor, textColor)
  return newButton(text, x, y, width, height, parent, buttonColor, textColor)
end

function prefabs.newLayer(id, opacity)
  return newLayer(id, opacity)
end

return prefabs