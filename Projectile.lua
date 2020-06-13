require "media"
require "Player"
require "Enemies"
require "Collision"


Projectile = {}

-- Velocity for every projectile in the game.
local VELOCITY = 800

-- Variables to control the player fire cooldown.
local TIMER = 0
local COOLDOWN_PLAYER = 0

math.randomseed(os.time())

-- Initialize tables to hold all the projectiles. Resets upon level clear.
function Projectile:init()
    player_projectiles = {}
    enemies_projectiles = {}
end

function Projectile:fire_render()
    -- Draws every player projetile on the screen
    for i=1, #player_projectiles do
        local player_laser_coordinate = player_projectiles[i]
        love.graphics.draw(ammo.player_laser, player_laser_coordinate.x, player_laser_coordinate.y, 0, 0.5, 0.5)    
    end
    
    -- Draws every enemy projetile on the screen
    for i=1, #enemies_projectiles do
        local enemy_laser_coordinate = enemies_projectiles[i]
        love.graphics.draw(ammo.alien_laser, enemy_laser_coordinate.x, enemy_laser_coordinate.y, 0, 0.5, 0.5)    
    end

end

function Projectile:fire_update(dt)
    -- Keeps track of time 
    TIMER = love.timer.getTime()

    -- Updates player's projectiles y position 
    for i=1, #player_projectiles do
        local player_laser_coordinate = player_projectiles[i]
        player_laser_coordinate.y = player_laser_coordinate.y -VELOCITY * dt 
    end

    -- Checks if any player projectile has reached the end of the window. If true, removes it.
    for i=#player_projectiles, 1, -1 do
        local player_laser_coordinate = player_projectiles[i]
        if player_laser_coordinate.y < 0 then
            table.remove(player_projectiles, i)
        end
    end 


    -- Each individual alien has a 0.01% chance of firing a projectile at any moment. Chance gets higher as the level increases.
    for i=1, #aliens, 1 do
        local enemy = aliens[i]
        if math.random(1000/level) == 1 then
            enemy_fire_atributes = {
                x = (enemy.x + (alien_width/2 - 4)),
                y = enemy.y
            }

            table.insert(enemies_projectiles, enemy_fire_atributes)

            sounds['sfx_laser_alien']:stop()
            sounds['sfx_laser_alien']:play()
        end
    end

    -- Updates alien's projectiles y position 
    for i=1, #enemies_projectiles do
        local enemy_laser_coordinate = enemies_projectiles[i]
        enemy_laser_coordinate.y = enemy_laser_coordinate.y +VELOCITY * dt
    end

    -- Checks if any alien projectile has reached the end of the window. If true, removes it.
    for i=#enemies_projectiles, 1, -1 do
        local enemy_laser_coordinate = enemies_projectiles[i]
        if enemy_laser_coordinate.y > WINDOW_H then
            table.remove(enemies_projectiles, i)
        end
    end 
end

function Projectile:fire()
    -- Fires upon keypress if the cooldown is off
    if COOLDOWN_PLAYER <= TIMER and love.keyboard.isDown('z', 'space') then
        -- Draws the projectile in the current player position
        player_fire_atributes = {
            x = (Player.x + (ship_width/2 - 4)),
            y = Player.y
        }

        table.insert(player_projectiles, player_fire_atributes)
        
        sounds['sfx_laser']:stop()
        sounds['sfx_laser']:play()
        
        -- Sets the weapon cooldown to 0.7 seconds.
        COOLDOWN_PLAYER = (love.timer.getTime() + 0.7)
    end

    -- Upon first fire, turns off the message that hints which button to press to fire. 
    tutorial = false
end