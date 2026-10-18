-- Nyoom Framework (c) 2026 Nia Piura

require('nyoom.require')
require('nyoom.globals')

love.graphics.setDefaultFilter('nearest', 'nearest')
love.keyboard.setKeyRepeat(true)

---@alias nyoom.Orientation 'vertical' | 'horizontal'
---@alias nyoom.HorizontalAlignment 'left' | 'right' | 'center' | 'justify'
---@alias nyoom.VerticalAlignment 'top' | 'bottom' | 'center'

---@class nyoom
nyoom = {}
require('nyoom.objects')
require('nyoom.defaults')
require('nyoom.events')
require('nyoom.timing')
require('nyoom.input')
require('nyoom.levels')
require('nyoom.ui')

-- TEMP
require('nyoom.profiler')

nyoom.mainCamera = nyoom.objects.newCamera()

-- If Nytor is in the root directory, load it and switch to editor mode.
if love.filesystem.getInfo('nytor') then require('nytor') end

---Load and initialize game data.
---You can provide `update(deltaTime)` and `draw()` functions within your game data to be iterated along with nyoom's update and draw cycle, which are called before the UI.
---@param game table
function nyoom:loadGame(game)
  local gameUpdate = game.update or function(deltaTime) end
  local gameDraw = game.draw or function() end

  function love.update(deltaTime)
    nyoom.profiler.start()
    nyoom.ui.updateMouse()
    nyoom.input.update(deltaTime)
    nyoom.timing.update(deltaTime)
    nyoom.levels.update(deltaTime)
    gameUpdate(deltaTime)
    nyoom.ui.updateElements(deltaTime)
    nyoom.profiler.mark('nyoom.update')
  end

  function love.draw()
    nyoom.mainCamera:activate()
    nyoom.levels.draw()
    gameDraw()
    nyoom.mainCamera:deactivate()
    nyoom.ui.draw()
    nyoom.profiler.mark('nyoom.draw')
    nyoom.profiler.draw()
  end
end

return nyoom