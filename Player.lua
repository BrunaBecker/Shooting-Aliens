require "media"

Player = {}

function Player:init()
    -- Defines spaceship start position
    self.x = WINDOW_W/2
    self.y = WINDOW_H - 60

    -- Spaceship x velocity.
    self.dx = 0

    -- Spaceship health points.
    self.hp = 3
    
    -- Spaceship speed
    local VELOCITY = 300

    -- Standart selection of spaceship. Gets altered after spaceship selection screen.
    local current_ship = 1
    
    self.state = 'flying'
    self.states = {
    
        -- Player movement when in flying state.
        ['flying'] = function(dt)
            -- If pressing both keys to move right and left at the same time, stop moving.
            if love.keyboard.isDown('right', 'd') and love.keyboard.isDown('left', 'a') then
                self.dx = 0
            elseif love.keyboard.isDown('left', 'a') then
                self.dx = -VELOCITY
            elseif love.keyboard.isDown('right', 'd') then
                self.dx = VELOCITY
            else 
                self.dx = 0
            end
        end
    }
end

function Player:render()
    -- Defines which spaceship will be rendered from the selection screen, then draws it.
    local ships = {ship.ship1, ship.ship2, ship.ship3}
    love.graphics.draw(ships[Game:get_ship()], self.x, self.y, 0, 0.5, 0.5)    
    
    -- Draws damage sprites over the spaceship according to the current health points.
    local damages_light = {damage_light.ship1, damage_light.ship2, damage_light.ship3}
    local damages_heavy = {damaged_heavy.ship1, damaged_heavy.ship2, damaged_heavy.ship3}
    if self.hp == 2 then
        love.graphics.draw(damages_light[Game:get_ship()], self.x, self.y, 0, 0.5, 0.5)    
    elseif self.hp == 1 then
        love.graphics.draw(damages_heavy[Game:get_ship()], self.x, self.y, 0, 0.5, 0.5)  
    elseif self.hp == 0 then
        love.graphics.draw(kill.explosion_one, self.x, self.y)  
    end
end

function Player:update(dt)
    -- Updates the player attributes.
    self.states[self.state](dt)
    -- Apply X velocity.
    self.x = self.x + self.dx * dt

    -- Locks the spaceship inside the window screen.
    if self.x < 0 then
        self.x = 0
    elseif self.x > WINDOW_W - ship_width then
        self.x = WINDOW_W - ship_width
    end

    -- Changes the game state to the highscore input screen if player health poits reach 0
    if self.hp == 0 then
        sounds['sfx_lose']:play() 
        game_state = 'get_username'
    end

    -- Checks if the player has been hit by an enemy projectile.
    Collision:is_player_hit()
end


