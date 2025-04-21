-- Nyoom Framework (c) 2025 Nia Piura

require('nyoom.require')
require('nyoom.globals')

---@class Nyoom
nyoom = {}
nyoom.common = require('nyoom.common') ---@type Nyoom.Common
nyoom.graphics = require('nyoom.graphics') ---@type Nyoom.Graphics
nyoom.timing = require('nyoom.timing') ---@type Nyoom.Timing
nyoom.events = require('nyoom.events') ---@type Nyoom.Events
nyoom.profiler = require('nyoom.profiler') ---@type Nyoom.Profiler
nyoom.nui = require('nyoom.nui') ---@type Nyoom.Nui

function nyoom.update(deltaTime)
  nyoom.profiler.start()
  nyoom.timing.update(deltaTime)
  nyoom.profiler.mark('update:base')
end

function nyoom.postUpdate(deltaTime)
  nyoom.nui.update(deltaTime)
  nyoom.profiler.mark('update:nui')
end

function nyoom.draw()
  nyoom.nui.draw()
  nyoom.profiler.mark('draw:nui')
  nyoom.profiler.draw()
end

nyoom.events.listen('love.keypressed', function(key) if key == '/' then nyoom.profiler.toggle() end end)