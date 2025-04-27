---@class Nyoom.TileSet
---@field image love.Image
---@field tilesPerDimension Nyoom.Vector2
---@field tileSize Nyoom.Vector2
---@field tileWidth number
---@field tileHeight number
---@field quads love.Quad[]
---
---@field getTilesPerDimension fun(self: Nyoom.TileSet)

local methods, metamethods = {}, { __name = 'Nyoom.TileSet' }

---@param image love.Image
---@param tileWidth number
---@param tileHeight number
---@return Nyoom.TileSet
local function newTileSet(image, tileWidth, tileHeight)
  local tileSet = {
    image = image,
    tileSize = nyoom.common.newVector2(tileWidth, tileHeight),
    tilesPerDimension = nyoom.common.newVector2(math.floor(image:getWidth() / tileWidth), math.floor(image:getHeight() / tileHeight)),
    quads = {}
  }

  setmetatable(tileSet, metamethods)

  tileSet:generateQuads()

  return tileSet
end

---@param self Nyoom.TileSet
function methods:generateQuads()
  for i=1, self.tilesPerDimension.x * self.tilesPerDimension.y do
    local quadX = ((i-1) % self.tilesPerDimension.x) * self.tileWidth
    local quadY = math.floor((i-1) / self.tilesPerDimension.x) * self.tileHeight
    table.insert(self.quads, love.graphics.newQuad(quadX, quadY, self.tileWidth, self.tileHeight, self.image))
  end
end

function methods:getQuad(x, y)
  return self.quads[(self.tilesPerDimension.x * y) + x]
end

function metamethods:__index(key)
  if key == 'tileWidth' then return self.tileSize.width end
  if key == 'tileHeight' then return self.tileSize.height end
  return methods[key]
end

function metamethods:__newindex(key, value)
  if key == 'tileWidth' then self.tileSize.width = value
  elseif key == 'tileHeight' then self.tileSize.height = value
  else rawset(self, key, value) end
end

return newTileSet