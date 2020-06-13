require "Player"
require "Projectile"
require "Enemies"
local utf8 = require("utf8")
local highscore = require "sick"

Game = {}

-- Defines initial state for when the game is started. 
game_state = "menu_screen"

function Game:init()
    -- Finds or creates the scoreboard file to be used.
    highscore.set("scoreboard", 5, "empty", 0)
    Player:init()
    Enemies:init()
    Projectile:init()

    -- Defines the nickname to be associed with the score in highscore board, at the end game screen.
    player = "Player"

    -- Variable for selecting and sending which spaceship to use during gameplay.
    current_ship = 1

    -- Tells the game if they should tell the player which key he must press to fire.
    tutorial = true

    -- Tells the game if the score has been saved once - otherwise the library would save the score indefinitely while the end game screen persisted.
    score_saved = false

    -- In the end game screen, if the player hasn't started typing the text input will blink and show the nickname value initialized above. Typing empties the nickname and interrupts the blinking for the user - succeding will set this variable to true. 
    started_typing = false

    -- Keeps track of the player's points.
    score = 0
    
    -- Reads the values from the scoreboard file into the game, so it can be altered and printed accordingly.
    highscore.load()
end

function Game:draw()
    if game_state == 'menu_screen' then
        -- Draws the game menu background for the specified resolution.
        for y=0, WINDOW_H, background_h do
            for x=0, WINDOW_W, background_w do
                love.graphics.draw(images.background_menu, x, y)
                x = x + background_w
            end
            y = y + background_h 
        end

        -- Game Menu text
        love.graphics.setFont(fonts.ken_large)
        love.graphics.printf("* Shooting Aliens *", 0, 100, WINDOW_W, 'center')
        love.graphics.setFont(fonts.ken_small)
        love.graphics.printf("A final project for CS50x", 200, 200, WINDOW_W, 'center')
        -- math.cos snippet blinking animation is borrowed from the source of CÖIN, a game made by George Prosser https://bitbucket.org/gprosser/coin/src/master/
        if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
            love.graphics.printf("Press Start", 0, WINDOW_H - 40, WINDOW_W, 'center')
        end
        
    elseif game_state == 'select_ship' then
        -- Table that defines the X value to draw the cursor when selecting a spaceship.
        selection_x = {
            (WINDOW_W/2 - 100 - ship_width/2) + ship_width, 
            (WINDOW_W/2 - ship_width/2) + ship_width,
            (WINDOW_W/2 + ship_width * 1.5) + ship_width
        }

        -- Draws the selection menu background for the specified resolution.
        for y=0, WINDOW_H, background_h do
            for x=0, WINDOW_W, background_w do
                love.graphics.draw(images.background_menu, x, y)
                x = x + background_w
            end
            y = y + background_h 
        end
        
        -- Selection Menu text
        love.graphics.setFont(fonts.ken_large)
        love.graphics.printf("* Shooting Aliens *", 0, 100, WINDOW_W, 'center')
        love.graphics.setFont(fonts.ken_small)
        love.graphics.printf("A final project for CS50x", 200, 200, WINDOW_W, 'center')
        love.graphics.printf("Select your ship", 0, WINDOW_H/2 - 40, WINDOW_W, 'center')

        -- Draws the spaceships options
        love.graphics.draw(ship.ship1, (WINDOW_W/2 - 100 - ship_width/2), (WINDOW_H/2), 0, 0.5)
        love.graphics.draw(ship.ship2, (WINDOW_W/2 - ship_width/2), (WINDOW_H/2), 0, 0.5)
        love.graphics.draw(ship.ship3, (WINDOW_W/2 + 100 - ship_width/2), (WINDOW_H/2), 0, 0.5)

        -- Draws a blinking cursor
        if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
            love.graphics.draw(cursor, selection_x[current_ship], (WINDOW_H/2 + ship_height), 0, 0.5)
        end

    elseif game_state == 'game_screen' then
        -- Draws the game screen background for the specified resolution.
        for y=0, WINDOW_H, background_h do
            for x=0, WINDOW_W, background_w do
                love.graphics.draw(images.background_game, x, y)
                x = x + background_w
            end
            y = y + background_h 
        end
    
        Player:render()
        Enemies:render()
        Projectile:fire_render()

        -- Draws damaged areas in the ship according to the current lifes left.
        local life = {life_ui.hp1, life_ui.hp2, life_ui.hp3}
        love.graphics.draw(life[current_ship], 20, WINDOW_H - 20 - life_height)
        love.graphics.print(Player.hp, 30 + life_width, WINDOW_H - 15 - life_height)

        -- Writes the current score and level.
        love.graphics.printf("Score: " .. score, -10, 10, WINDOW_W, 'right')
        love.graphics.printf("Level: " .. level, 10, 10, WINDOW_W, 'left')

        -- Hints what keys to press to fire.
        if tutorial then
            love.graphics.printf("Press Z or SPACE to shot", 30, WINDOW_H - 20, WINDOW_W, 'center')
        end

    elseif game_state == 'get_username' then
        -- Writes the Get Username screen text.
        love.graphics.printf("FINAL SCORE: " .. score, -10, 10, WINDOW_W, 'right')
        love.graphics.setFont(fonts.ken_large)
        love.graphics.printf("You lost!", 0, 100, WINDOW_W, 'center')
        love.graphics.setFont(fonts.ken_small)
        love.graphics.printf("Press Start to submit username", 0, WINDOW_H - 40, WINDOW_W, 'center')
        love.graphics.printf("USER:", -30, WINDOW_H/2 - 20, WINDOW_W, 'center')
        if math.cos(2 * math.pi * love.timer.getTime()) > 0 and started_typing == false then
            love.graphics.printf(player, 30, WINDOW_H/2 - 20, WINDOW_W, 'center')
        end
        -- Writes the username as the player is typing.
        if started_typing == true then 
            love.graphics.printf(player, WINDOW_W/2 + 20, WINDOW_H/2 - 20, WINDOW_W, 'left')
        end

        -- Prints the highscore board. 
        for i, score, name in highscore() do
            love.graphics.printf(name, -20, WINDOW_H/2 + i * 20, WINDOW_W/2, 'right')
            love.graphics.printf(score, WINDOW_W/2 + 20, WINDOW_H/2 + i * 20, WINDOW_W/2, 'left')
        end

    elseif game_state == 'end_game' then
        -- Writes the End Game text.
        love.graphics.printf("FINAL SCORE: " .. score, -10, 10, WINDOW_W, 'right')
        love.graphics.setFont(fonts.ken_large)
        love.graphics.printf("You lost!", 0, 100, WINDOW_W, 'center')
        love.graphics.setFont(fonts.ken_small)
        if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
            love.graphics.printf("Press Start to try again", 0, WINDOW_H - 40, WINDOW_W, 'center')
        end

        -- Prints the highscore board. 
        love.graphics.printf("Highscore:", 0, WINDOW_H/2 - 20, WINDOW_W, 'center')
        for i, score, name in highscore() do
            love.graphics.printf(name, -20, WINDOW_H/2 + i * 20, WINDOW_W/2, 'right')
            love.graphics.printf(score, WINDOW_W/2 + 20, WINDOW_H/2 + i * 20, WINDOW_W/2, 'left')
        end

    end
end

function Game:update(dt)
    if game_state == 'menu_screen' then

    elseif game_state == 'select_ship' then
        
    elseif game_state == 'game_screen' then
        Player:update(dt)
        Enemies:update(dt)
        Projectile:fire_update(dt)
    elseif game_state == 'get_username' then
        -- Gives a gloomy feel to the music if you have lost.
        music['soundtrack']:setPitch(0.85)
    elseif game_state == 'end_game' then
        -- Gives a gloomy feel to the music if you have lost.
        music['soundtrack']:setPitch(0.85)
        -- Guarantees that the score will only be written once in the file.
        if score_saved == false then

            -- Input the nickname "Player" if the player inputs an invalid value for the highscore board. 
            if player == "" then
                player = "Player"
            end

            highscore.add(player, score)
            highscore.save()
            score_saved = true
        end
    end
end

function Game:keypress(key)
    if game_state == 'menu_screen' then
        -- Pressing enter in the menu screen will take the player to the selection screen.
        if key == 'return' or key == 'space' then
            sounds['sfx_twoTone']:play() 
            game_state = 'select_ship'
        end

    elseif game_state == 'select_ship' then
        -- Keypress will move the cursor and selection between spaceships options.
        -- List interation inspired in https://love2d.org/forums/viewtopic.php?t=83237.
        if key == 'left' or key == 'a' then
            local item = selection_x[current_ship - 1]
            
            if item then
                sounds['sfx_zap']:stop() 
                sounds['sfx_zap']:play() 
                current_ship = current_ship - 1
            end
            
        elseif key == 'right' or key == 'd' then
            local item = selection_x[current_ship + 1]
            
            if item then            
                sounds['sfx_zap']:stop() 
                sounds['sfx_zap']:play() 
                current_ship = current_ship + 1
            end
        end

        -- Pressing enter in the selection screen will take the player to the game screen.
        if key == 'return' or key == 'space' then
            sounds['sfx_twoTone']:stop() 
            sounds['sfx_twoTone']:play() 
            game_state = 'game_screen'
        end

    elseif game_state == 'game_screen' then
        Projectile:fire()
        
    elseif game_state == 'get_username' then
        -- User text input with backspace feature from https://love2d.org/wiki/love.textinput
        if key == "backspace" then
            -- get the byte offset to the last UTF-8 character in the string.
            local byteoffset = utf8.offset(player, -1)
     
            if byteoffset then
                -- remove the last UTF-8 character.
                -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                player = string.sub(player, 1, byteoffset - 1)
            end
        end

        -- Pressing enter in the get_username screen will take the player to the game over screen.
        if key == 'return' then
            game_state = 'end_game'
            sounds['sfx_twoTone']:stop() 
            sounds['sfx_twoTone']:play() 
        end
        
    elseif game_state == 'end_game' then
        -- Pressing enter in the game over screen will restart the game.
        if key == 'return' or key == 'space' then
            sounds['sfx_twoTone']:stop() 
            sounds['sfx_twoTone']:play() 
            Enemies:restart_difficulty()
            Game:init()
            -- Return the pitch to normal after losing a game.
            music['soundtrack']:setPitch(1)
            game_state = 'menu_screen'
        end
    end
end

-- Sends which spaceship was selected to Player.lua, so the right ship can be rendered during gameplay.
function Game:get_ship()
    return current_ship
end

-- Adds points to the total when killing an alien. Multiplied by current level.
function Game:update_score()
    score = score + (100 * level)
end

-- Adds points to the total when killing an UFO. Multiplied by current level.
function Game:update_bonus_score()
    score = score + (1000 * level)
end

-- User text input with backspace feature from https://love2d.org/wiki/love.textinput
function love.textinput(t)
    if game_state == "get_username" then
        if started_typing == false then
            player = ""
            started_typing = true
        end

        if #player < 20 then
            player = player .. t
        end
    end
end