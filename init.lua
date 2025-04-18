-- Minimized Nyoom framework (only core features and Nui present)

require('nyoom.require') -- Custom loader to search for lua files matching the folder name
require('nyoom.globals')

---@class Nyoom
nyoom = {}
nyoom.objects = require('nyoom.objects') ---@type Objects
nyoom.graphics = require('nyoom.graphics') ---@type Graphics
nyoom.timing = require('nyoom.timing') ---@type Timing
nyoom.events = require('nyoom.events') ---@type Events
nyoom.profiler = require('nyoom.profiler') ---@type Profiler
nyoom.nui = require('nyoom.nui') ---@type Nui

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