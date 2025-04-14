local perfMon = {
  measurements = {},
  font = love.graphics.newFont(11),

  showPerfMetrics = false,
  targetDelta = 1/60, -- Target 60 frames per second
  timestamp = 0
}

function perfMon.setup(width, height)
  perfMon.canvases = {
    width = width,
    height = height,
    writePos = 0,
    bg = love.graphics.newCanvas(width + 2, height + 2),
    graph = love.graphics.newCanvas(width, height),
    buffer = love.graphics.newCanvas(width, height),
    overlay = love.graphics.newCanvas(width + 2, height + 2)
  }

  local canvas = love.graphics.getCanvas()

  love.graphics.setCanvas(perfMon.canvases.bg)
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle("fill", 1, 1, width, height)

  love.graphics.setCanvas(perfMon.canvases.overlay)
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.rectangle("line", 1, 1, width, height)
  love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
  love.graphics.line(1, height / 2, width, height / 2)

  love.graphics.setCanvas(canvas)
  love.graphics.setColor(1, 1, 1)
end

function perfMon.start()
  if not perfMon.canvases then
    perfMon.setup(200, 120)
  end

  perfMon.measurements = {}
  perfMon.timestamp = love.timer.getTime()
end

function perfMon.mark(label)
  local time = love.timer.getTime()

  perfMon.measurements[#perfMon.measurements + 1] = { label = label, value = time - perfMon.timestamp }
  perfMon.timestamp = time
end

function perfMon.toggle()
  perfMon.showPerfMetrics = not perfMon.showPerfMetrics

  if perfMon.showPerfMetrics then
    local canvas = love.graphics.getCanvas()
    perfMon.canvases.writePos = 0

    love.graphics.setCanvas(perfMon.canvases.graph)
    love.graphics.clear(0, 0, 0)
    love.graphics.setCanvas(perfMon.canvases.buffer)
    love.graphics.clear(0, 0, 0)

    love.graphics.setCanvas(canvas)
  end
end

function perfMon.draw()
  if not perfMon.showPerfMetrics then return end

  local stats = love.graphics.getStats()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(perfMon.font)

  local statsBasic = string.format(
    "FPS: %i Dt: %.4f RAM: %.1fMb VRAM: %.1fMb",
    love.timer.getFPS(),
    love.timer.getDelta(),
    collectgarbage("count") / 1024, --kb > Mb
    stats.texturememory / 1048576 -- b > Mb
  )

  local statsAdvanced = string.format(
    "Drawcalls/batched: %i/%i (Images: %i Fonts: %i Canvases/switches: %i/%i)",
    stats.drawcalls,
    stats.drawcallsbatched,
    stats.images,
    stats.fonts,
    stats.canvases,
    stats.canvasswitches
  )

  love.graphics.print(statsBasic, 5, 5)
  love.graphics.print(statsAdvanced, 5, 15)

  local percentages = {}
  local sumDt = 0
  local sumP = 0
  local deltaP = 0

  love.graphics.setColor(0.8, 0.8, 0.8)

  -- Labeled measurements
  for i, _ in ipairs(perfMon.measurements) do
    deltaP = (perfMon.measurements[i].value / perfMon.targetDelta)

    love.graphics.print(
      string.format(
        "%s: %.1f%% / %.3fms",
        perfMon.measurements[i].label,
        deltaP * 100,
        perfMon.measurements[i].value * 1000
      ),
      perfMon.canvases.width + 10,
      30 + (i * 10)
    )

    percentages[i] = deltaP
    sumDt = sumDt + perfMon.measurements[i].value * 1000
    sumP = sumP + deltaP
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
    string.format(
      "total: %.1f%% / %.3fms" ,
      sumP * 100,
      sumDt
    ),
    perfMon.canvases.width + 10,
    30
  )

  perfMon.timestamp = love.timer.getTime()

  local canvas = love.graphics.getCanvas()

  love.graphics.setCanvas(perfMon.canvases.graph)
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1, 0.98)
  love.graphics.draw(perfMon.canvases.buffer, 0, 0)
  local height = math.clamp(sumP, 0, 100) * 2
  love.graphics.setColor(height, 1 / height, 0)
  love.graphics.line(
    perfMon.canvases.writePos,
    perfMon.canvases.height,
    perfMon.canvases.writePos,
    perfMon.canvases.height - (perfMon.canvases.height * sumP) / 2
  )

  love.graphics.setColor(1, 1, 1)
  love.graphics.setCanvas(perfMon.canvases.buffer)
  love.graphics.draw(perfMon.canvases.graph, 0, 0)

  love.graphics.setCanvas(canvas)

  perfMon.canvases.writePos = perfMon.canvases.writePos + 2
  if perfMon.canvases.writePos > perfMon.canvases.width then
    perfMon.canvases.writePos = 0
  end

  love.graphics.draw(perfMon.canvases.bg, 5, 30)
  love.graphics.draw(perfMon.canvases.graph, 6, 31)
  love.graphics.draw(perfMon.canvases.overlay, 5, 30)

  love.graphics.print(
    string.format(
      "Graph: %.3fms",
      (love.timer.getTime() - perfMon.timestamp) * 1000
    ),
    5,
    perfMon.canvases.height + 30
  )
end

return perfMon