--[[
    Shooting Aliens is a small game made in LÖVE for the Final Project of CS50x 2020.
    Project Author: Bruna Becker
]]

require "Game"

-- The window configuration and resolution (1280x720) is defined at conf.lua.
WINDOW_W = love.graphics.getWidth()
WINDOW_H = love.graphics.getHeight()

function love.load()
    -- Enables repeated keypress events when a key key is held down. 
    love.keyboard.setKeyRepeat(true)

    images = {
        background_menu = love.graphics.newImage('assets/background_blue.png'),
        background_game = love.graphics.newImage('assets/background_blue.png'),
    }

    fonts = {
        ken_small = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 16),
        ken_large = love.graphics.newFont('fonts/kenvector_future_thin.ttf', 88)
    }

    -- Sets the font that will be used for the whole game.
    love.graphics.setFont(fonts.ken_small)
    
    -- Gets the size of the background tile so it can be drawed relatively to the window size.
    background_w = images.background_menu:getWidth()
    background_h = images.background_menu:getHeight()

    Game:init()

    -- Plays the background music in a loop while the game is open.
    music['soundtrack']:setLooping(true)
    music['soundtrack']:setVolume(0.2)
    music['soundtrack']:play()
end

function love.draw()
    Game:draw()
end

function love.update(dt)
    Game:update(dt)
end

function love.keypressed(key)
    -- Closes the game in any moment if the esc key is pressed.
    if key == 'escape' then
        love.event.quit()
    end
    
    Game:keypress(key)    
end


