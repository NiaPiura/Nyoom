-- Minimized Nyoom framework (only core features and Nui present)

require('nyoom.require') -- Custom loader to search for lua files matching the folder name
require('nyoom.globals')

---@class Nyoom
nyoom = {}
nyoom.objects = require('nyoom.objects') ---@type Objects
nyoom.graphics = require('nyoom.graphics') ---@type Graphics
nyoom.timing = require('nyoom.timing') ---@type Timing
nyoom.events = require('nyoom.events') ---@type Events
nyoom.perf = require('nyoom.perfmon') -- TODO: rewrite and properly type perfmon
nyoom.nui = require('nyoom.nui') ---@type Nui

function nyoom.update(deltaTime)
  nyoom.perf.start()
  nyoom.perf.mark('update')
  nyoom.timing.update(deltaTime)
end

function nyoom.postUpdate(deltaTime)
  nyoom.perf.mark('nui')
  nyoom.nui.update(deltaTime)
end

function nyoom.draw()
  nyoom.perf.mark('draw')
  nyoom.nui.draw()
  nyoom.perf.draw()
end

nyoom.events.listen('love.keypressed', function(key) if key == '/' then nyoom.perf.toggle() end end)