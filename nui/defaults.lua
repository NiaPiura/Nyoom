local color = nyoom.objects.newColor

---@class Nyoom.NuiDefaults
local defaults = {
  backgroundColor = color(0.3),
  foregroundColor = color(0.9),
  slider = {
    railColor = color(0.2),
    barColor = color(0.5),
    railThickness = 20,
    barThickness = 20,
    barMinLength = 20,
  },
  scrollview = {
    scrollIncrement = 50
  }
}

return defaults