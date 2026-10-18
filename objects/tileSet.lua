---A texture atlas configured with equally-sized square 'tile' textures
---@class nyoom.TileSet
---@field image love.Image
---@field tilesPerDimension nyoom.Vector2
---@field tileSize nyoom.Vector2
---@field tileWidth number
---@field tileHeight number
---@field quads love.Quad[]
---
---@field getTilesPerDimension fun(self: nyoom.TileSet)

local methods, metamethods = {}, { __name = 'nyoom.TileSet' }

---Create a new TileSet.
---@param image love.Image The source image to derive tiles from.
---@param tileWidth? integer The width of a tile. Defaults to `nyoom.defaults.tileSize`.
---@param tileHeight? integer The height of a tile. Defaults to `nyoom.defaults.tileSize`.
---@return nyoom.TileSet
function nyoom.objects.newTileSet(image, tileWidth, tileHeight)
  local tileSet = {
    image = image,
    tileSize = nyoom.objects.newVector2(tileWidth, tileHeight),
    tilesPerDimension = nyoom.objects.newVector2(math.floor(image:getWidth() / tileWidth), math.floor(image:getHeight() / tileHeight)),
    quads = {}
  }

  setmetatable(tileSet, metamethods)

  tileSet:generateQuads()

  return tileSet
end

---@param self nyoom.TileSet
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