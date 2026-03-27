local newColor = require('nyoom.objects.color')
local newText = require('nyoom.objects.text')
local newTileSet = require('nyoom.objects.tileSet')
local newTileGrid = require('nyoom.objects.tileGrid')
local newCamera = require('nyoom.objects.camera')

---@class Nyoom.Objects
---@field newColor fun(red: number, green: number, blue: number, alpha?: number): Nyoom.Color Creates an object representing a color.
---@field newText fun(string: string, x: number, y: number, width: number, height: number): Nyoom.Text Creates an object representing a color.
---@field newTileSet fun(image: love.Image, tileWidth: number, tileHeight: number): Nyoom.TileSet
---@field newTileGrid fun(tileSet: Nyoom.TileSet, width?: integer, height?: integer): Nyoom.TileGrid
---@field newCamera fun(size?: Nyoom.Vector2): Nyoom.Camera
local objects = {}

function objects.newColor(red, green, blue, alpha)
  return newColor(red, green, blue, alpha)
end

function objects.newText(string, x, y, width, height)
  return newText(string, x, y, width, height)
end

function objects.newTileSet(image, tileWidth, tileHeight)
  return newTileSet(image, tileWidth, tileHeight)
end

function objects.newTileGrid(tileSet, width, height)
  return newTileGrid(tileSet, width, height)
end

function objects.newCamera(size)
  return newCamera(size)
end

return objects