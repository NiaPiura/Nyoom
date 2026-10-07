---@class Nyoom.NineSplice
---@field texture love.Texture
---@field cornerSize integer
---@field quads love.Quad[]
---
---@field getSpriteBatch fun(self: Nyoom.NineSplice, width: integer, height: integer)

local methods, metamethods = {}, { __name = "Nyoom.NineSplice" }

---Splices a texture into 9 sections, which can then be resized to fit any desired shape. Source `texture` needs to be square.
---@param texture love.Texture
---@param cornerSize integer
---@return Nyoom.NineSplice
local function newNineSplice(texture, cornerSize)
  local nineSplice = {
    texture = texture,
    cornerSize = cornerSize
  }

  local textureSize = texture:getDimensions()
  local sideLength = textureSize - (cornerSize * 2)

  nineSplice.quads = {
    love.graphics.newQuad(0,                       0,                       cornerSize, cornerSize, texture),
    love.graphics.newQuad(cornerSize + sideLength, 0,                       cornerSize, cornerSize, texture),
    love.graphics.newQuad(cornerSize + sideLength, cornerSize + sideLength, cornerSize, cornerSize, texture),
    love.graphics.newQuad(0,                       cornerSize + sideLength, cornerSize, cornerSize, texture),

    love.graphics.newQuad(cornerSize,              0,          sideLength, cornerSize, texture),
    love.graphics.newQuad(cornerSize + sideLength, cornerSize, cornerSize, sideLength, texture),
    love.graphics.newQuad(cornerSize, cornerSize + sideLength, sideLength, cornerSize, texture),
    love.graphics.newQuad(0,                       cornerSize, cornerSize, sideLength, texture),

    love.graphics.newQuad(cornerSize, cornerSize, sideLength, sideLength, texture)
  }

  setmetatable(nineSplice, metamethods)

  return nineSplice
end

---@param self Nyoom.NineSplice
function methods:getSpriteBatch(width, height)
  local cornerSize = self.cornerSize
  local sideLength = self.texture:getDimensions() - (cornerSize * 2)

  local contentWidth = width - (cornerSize * 2)
  local contentHeight = height - (cornerSize * 2)
  local scaleWidth = contentWidth / sideLength
  local scaleHeight = contentHeight / sideLength

  spriteBatch = love.graphics.newSpriteBatch(self.texture, 9, "static")

  spriteBatch:add(self.quads[1], 0,                         0                         )
  spriteBatch:add(self.quads[2], cornerSize + contentWidth, 0                         )
  spriteBatch:add(self.quads[3], cornerSize + contentWidth, cornerSize + contentHeight)
  spriteBatch:add(self.quads[4], 0,                         cornerSize + contentHeight)

  spriteBatch:add(self.quads[5], cornerSize,                0,                          0, scaleWidth, 1          )
  spriteBatch:add(self.quads[6], cornerSize + contentWidth, cornerSize,                 0, 1,          scaleHeight)
  spriteBatch:add(self.quads[7], cornerSize,                cornerSize + contentHeight, 0, scaleWidth, 1          )
  spriteBatch:add(self.quads[8], 0,                         cornerSize,                 0, 1,          scaleHeight)

  spriteBatch:add(self.quads[9], cornerSize,                cornerSize,                 0, scaleWidth, scaleHeight)

  return spriteBatch
end

function metamethods:__index(key)
  return methods[key]
end

return newNineSplice