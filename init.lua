-- Nyoom Framework (c) 2025 Nia Piura

require('nyoom.require')
require('nyoom.globals')

love.graphics.setDefaultFilter('nearest', 'nearest')
love.keyboard.setKeyRepeat(true)

---@class Nyoom
nyoom = {}
nyoom.common = require('nyoom.common') ---@type Nyoom.Common
nyoom.graphics = require('nyoom.graphics') ---@type Nyoom.Graphics
nyoom.timing = require('nyoom.timing') ---@type Nyoom.Timing
nyoom.events = require('nyoom.events') ---@type Nyoom.Events
nyoom.levels = require('nyoom.levels') ---@type Nyoom.Levels
nyoom.profiler = require('nyoom.profiler') ---@type Nyoom.Profiler
nyoom.ui = require('nyoom.nui') ---@type Nyoom.Nui

---Load and initialize game data.
---You can provide `update(deltaTime)` and `draw()` functions to be iterated along with Nyoom.
---@param game table
function nyoom:loadGame(game)
  gameUpdate = game.update or function(deltaTime) end
  gameDraw = game.draw or function() end

  function love.update(deltaTime)
    nyoom.profiler.start()
    nyoom.timing.update(deltaTime)
    nyoom.levels.update(deltaTime)
    gameUpdate(deltaTime)
    nyoom.ui.update(deltaTime)
    nyoom.profiler.mark('nyoom.update')
  end

  function love.draw()
    nyoom.levels.draw()
    gameDraw()
    nyoom.ui.draw()
    nyoom.profiler.mark('nyoom.draw')
    nyoom.profiler.draw()
  end
end

--TEMP
nyoom.events.listen('love.keypressed', function(key) if key == '/' then nyoom.profiler.toggle() end end)

return nyoom