local Gamestate = require 'vendor/gamestate'
local fonts = require 'fonts'
local Keyboard = {}

Keyboard.__index = Keyboard

function Keyboard.new(width, height)
    local keyboard = {}
    setmetatable(keyboard, Keyboard)
end