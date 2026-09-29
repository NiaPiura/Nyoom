---@class Nyoom.UIDefaults
local defaults = {
  backgroundColor = nyoom.objects.newColor(0.3),
  foregroundColor = nyoom.objects.newColor(0.9),
  font = love.graphics.newFont(16),
  slider = {
    railColor = nyoom.objects.newColor(0.2),
    barColor = nyoom.objects.newColor(0.5),
    railThickness = 20,
    barThickness = 20,
    barMinLength = 20,
  },
  scrollview = {
    scrollIncrement = 50
  }
}

return defaults