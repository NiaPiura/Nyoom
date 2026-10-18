---Various default values for nyoom to function in a predictable manner.
nyoom.defaults = {
  tileSize = 16,
  inputRepeatDelay = 0.4,
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