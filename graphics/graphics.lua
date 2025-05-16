local newColor = require('nyoom.graphics.color')
local newText = require('nyoom.graphics.text')
local newTileSet = require('nyoom.graphics.tileSet')
local newTileGrid = require('nyoom.graphics.tileGrid')

---@class Nyoom.Graphics
---@field newColor fun(r: number, g: number, b: number, a?: number): Nyoom.Color Creates an object representing a color.
---@field newText fun(string: string, x: number, y: number, width: number, height: number): Nyoom.Text Creates an object representing a color.
---@field newTileSet fun(image: love.Image, tileWidth: number, tileHeight: number): Nyoom.TileSet
---@field newTileGrid fun(tileSet: Nyoom.TileSet, width?: integer, height?: integer): Nyoom.TileGrid
local graphics = {}

function graphics.newColor(r, g, b, a)
  return newColor(r, g, b, a)
end

function graphics.newText(string, x, y, width, height)
  return newText(string, x, y, width, height)
end

function graphics.newTileSet(image, tileWidth, tileHeight)
  return newTileSet(image, tileWidth, tileHeight)
end

function graphics.newTileGrid(tileSet, width, height)
  return newTileGrid(tileSet, width, height)
end

return graphics