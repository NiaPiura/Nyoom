local newButton = require('nyoom.nui.prefabs.button')

---@class Nyoom.NuiPrefabs
---@field newButton fun(text: string, x: number, y: number, width: number, height: number, parent?: Nyoom.Element, buttonColor?: Nyoom.Color, textColor?: Nyoom.Color): Nyoom.Element
local prefabs = {}

function prefabs.newButton(text, x, y, width, height, parent, buttonColor, textColor)
  return newButton(text, x, y, width, height, parent, buttonColor, textColor)
end

return prefabs