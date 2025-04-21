---@class Nyoom.ProfilerMark
---@field label string
---@field delta number
---@field percentage number

---@class Nyoom.Profiler
---@field marks Nyoom.ProfilerMark[]
---@field targetFPS number
---@field frameStart number
---@field timestamp number
---@field isVisible boolean
local profiler = {
  marks = {},
  targetFPS = 30,
  frameStart = 0,
  timestamp = 0,
  isVisible = false
}

local display = {
  graphPos = 0,
  graph = love.graphics.newCanvas(200, 120),
  graphBuffer = love.graphics.newCanvas(200, 120),
  font = love.graphics.newFont(11),
  markOffset = nyoom.common.newVector2(3, 28) -- 210, 28
}

display.font:setLineHeight(0.75)

---Sets up profiler for the start of the update.
function profiler.start()
  profiler.marks = {}
  profiler.timestamp = love.timer.getTime()
  profiler.frameStart = love.timer.getTime()
end

---Marks time elapsed since the last mark or start of the update with the given label.
---@param label string
function profiler.mark(label)
  local time = love.timer.getTime()

  table.insert(profiler.marks, { label = label, delta = time - profiler.timestamp })
  profiler.timestamp = time
end

function profiler.toggle()
  profiler.isVisible = not profiler.isVisible

  if profiler.isVisible then
    local canvas = love.graphics.getCanvas()
    display.graphPos = 0

    love.graphics.setCanvas(display.graph)
    love.graphics.clear(0, 0, 0)
    love.graphics.setCanvas(display.graphBuffer)
    love.graphics.clear(0, 0, 0)

    love.graphics.setCanvas(canvas)
  end
end

local function renderStats()
  local stats = love.graphics.getStats()

  local statsBuilder = string.builder()
  statsBuilder:add(('FPS: %i Dt: %.3f RAM: %.1fMb VRAM: %.1fMb'):format(
    love.timer.getFPS(),
    love.timer.getDelta() * 1000,
    collectgarbage("count") / 1024, --kb > Mb
    stats.texturememory / 1048576 -- b > Mb
  ))

  statsBuilder:add(('Drawcalls/batched: %i/%i (Images: %i Fonts: %i Canvases/switches: %i/%i)'):format(
    stats.drawcalls,
    stats.drawcallsbatched,
    stats.images,
    stats.fonts,
    stats.canvases,
    stats.canvasswitches
  ))

  local statsString = statsBuilder:build('\n')

  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.rectangle('fill', 0, 0, display.font:getWidth(statsString) + 6, 28)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(statsString, display.font, 3, 3)
end

local function renderMarks(totalTime, offset)
  local markBuilder = string.builder()
  for _, mark in ipairs(profiler.marks) do
    markBuilder:add(('%s: %.1f%% / %.3fms'):format(
      mark.label,
      mark.percentage,
      mark.delta * 1000
    ))
  end

  local markString = markBuilder:build('\n')
  local totalString = ('total: %.1f%% / %.3fms'):format((totalTime / (1 / profiler.targetFPS)) * 100, totalTime * 1000)

  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.rectangle('fill', display.markOffset.x, display.markOffset.y, math.max(display.font:getWidth(totalString), display.font:getWidth(markString)) + 6, ((#profiler.marks + 1) * 10) + 8)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(totalString, display.font, display.markOffset.x + 3, display.markOffset.y + 2)
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.print(markString, display.font, display.markOffset.x + 3, display.markOffset.y + 12)
end

local function renderGraph(totalTime)
  local baseCanvas = love.graphics.getCanvas()
  local baseLine = love.graphics.getLineWidth()

  love.graphics.setCanvas(display.graph)
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1, 0.98)
  love.graphics.draw(display.graphBuffer, 0, 0)

  local lineHeight = math.clamp((totalTime * 1000) / profiler.targetFPS, 0, 100)
  --print(totalTime, lineHeight, 1-lineHeight)

  love.graphics.setColor(lineHeight, 1 - lineHeight, 0)
  love.graphics.line(
    display.graphPos, 120,
    display.graphPos, 120 - (lineHeight * 120)
  )
  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas(display.graphBuffer)
  love.graphics.draw(display.graph, 0, 0)
  love.graphics.setCanvas(baseCanvas)

  display.graphPos = display.graphPos + 2
  if display.graphPos > 200 then display.graphPos = 0 end

  love.graphics.setLineWidth(0)
  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.rectangle('fill', 3, 33, 200, 120)
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.draw(display.graph, 3, 33)
  love.graphics.rectangle('line', 2, 32, 202, 122)
  love.graphics.line(3, 93, 203, 93)
  love.graphics.setLineWidth(baseLine)
end

---Finishes the profiler and renders results to the screen
function profiler.draw()
  if not profiler.isVisible then return end

  local stamp = love.timer.getTime()

  local totalTime = love.timer.getTime() - profiler.frameStart
  for _, mark in ipairs(profiler.marks) do mark.percentage = (mark.delta / totalTime) * 100 end

  renderStats()
  renderMarks(totalTime)
  --renderGraph(totalTime) -- Graph rendering has issues
  --love.graphics.print(('%.3fms'):format((love.timer.getTime() - stamp) * 1000), 3, 157)
end

return profiler