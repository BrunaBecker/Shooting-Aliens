require "media"

math.randomseed(os.time())

Enemies = {}

-- Variable used to keep track of how many aliens were drawn in a single line.
local aliens_in_a_line = 0
-- Variable to keep track of where to draw next alien.
local next_alien = alien_width + 20
-- Variable to keep track of where to draw next line of aliens.
local next_line = alien_height + 10
-- Current game difficulty and score multiplier.
level = 1

function Enemies:init()
    -- Position of first alien
    self.x = 60
    self.y = 60

    -- Doesn't allow game to draw an alien outside of window.
    self.x_end = WINDOW_W - 60 - alien_width

    -- Used to draw the different species of aliens. Each line must have a different class. Doesn't draw more when reaching done class.
    self.class = {'blue', 'green', 'pink', 'done'}
    self.current_class = 1

    -- Aliens health points. Only one hit will defeat it.
    self.hp = 4

    -- Initialize which direction the alien fleet will be traveling in the start of the game.
    self.direction = 'left'

    -- Variable to define how fast aliens fly according to the current level.
    VELOCITY = (level/2)

    aliens = {}
    bonus_ufo = {}

    -- Variable used to animate UFO spin when they cross the screen.
    rad = 0
    
    while self.class[self.current_class] ~= 'done' do

        -- Attribute table for each added alien.
        attributes = {
            x = self.x,
            y = self.y,
            class = self.class[self.current_class],
            hp = self.hp,
        }

        -- Creates each individual alien in a line until it reachs the end of the window or reachs the alien per line limit.
        if self.x <= self.x_end and aliens_in_a_line < 8 then
            aliens_in_a_line = aliens_in_a_line + 1
            table.insert(aliens, attributes)
            self.x = self.x + next_alien

        -- Moves to the next line and reset quantity of aliens in that line.
        else
            self.x = 60
            self.y = self.y + next_line
            self.current_class = self.current_class + 1
            aliens_in_a_line = 0
        end
    end
    
    -- Moves each alien to the current direction if none of them will hit the defined border. If one more position update will reach the end of the window, swaps movement to the other direction.
    self.movement = {
        
        ['left'] = function()
            for i=1, #aliens, 1 do
                local enemy = aliens[i]
                if (enemy.x + (alien_width * 1.5)) > WINDOW_W then
                    enemy.x = enemy.x + VELOCITY
                    for i=1, #aliens, 1 do
                        local enemy = aliens[i]
                            enemy.y = enemy.y + 20
                    end
                    self.direction = 'right'
                else
                    enemy.x = enemy.x + VELOCITY
                end
            end
        end,
    
        ['right'] = function()
            for i=1, #aliens, 1 do
                local enemy = aliens[i]
                if enemy.x < (alien_width * 0.5) then
                    enemy.x = enemy.x + -VELOCITY
                    for i=1, #aliens, 1 do
                        local enemy = aliens[i]
                            enemy.y = enemy.y + 20
                    end
                    self.direction = 'left'
                else
                    enemy.x = enemy.x + -VELOCITY
                end
            end
        end
    }
end


function Enemies:render()
    -- Draw each alien in your current attributes.
    for i=1, #aliens, 1 do
        local enemy = aliens[i]
        if enemy.class == 'blue' then
            love.graphics.draw(alien.alien_three, enemy.x, enemy.y, 0, 0.5, 0.5)
        elseif enemy.class == 'green' then
            love.graphics.draw(alien.alien_two, enemy.x, enemy.y, 0, 0.5, 0.5)
        elseif enemy.class == 'pink' then
            love.graphics.draw(alien.alien_one, enemy.x, enemy.y, 0, 0.5, 0.5)
        end
        -- end
    end

    -- Draw the UFO in your current attribute if one exists.
    for i=1, #bonus_ufo do
        local ufo = bonus_ufo[i]
        love.graphics.draw(alien.ufo, ufo.x, ufo.y, rad, 1, 1, ufo_height/2, ufo_height/2)
        sounds['sfx_ufo']:setPitch(0.70)
        sounds['sfx_ufo']:play() 
        rad = rad + 0.01
    end
end

function Enemies:update(dt)
    
    self.movement[self.direction]()
    
    -- Checks if an enemy has been defeated.
    Collision:is_enemy_hit()
    Collision:is_ufo_hit()

    if #bonus_ufo == 0 then
        sounds['sfx_ufo']:stop()
    end 
    
    -- If level has been completed, creates a new fleet of aliens again for a new level.
    if Enemies:is_level_complete() then
            Enemies:init()
    end

    -- Constantly checks if a UFO should spawn. If there's one alive, updates its attributes accordingly. 
    Enemies:ufo_spawn()
end

function Enemies:is_level_complete()
    -- Checks if every alien in the fleet has been defeated. If true, raises the current level difficulty by one. Also cleans all projectiles in the screen.
    if #aliens == 0 and #bonus_ufo == 0 then
        level = level + 1
        Projectile:init()
        return true
    end

    -- If there's only 3 aliens left, they get a boost in the flying velocity.
    if #aliens <= 3 then
        VELOCITY = (3 * level)
        music['soundtrack']:setPitch(1.25)
    else
        VELOCITY = (level/2)
        music['soundtrack']:setPitch(1)
    end
end

-- If the game is restarted, this resets the game difficulty again to level 1.
function Enemies:restart_difficulty()
    level = 1
end

-- Function that spawns and updates UFOs.
function Enemies:ufo_spawn()
    -- 0.05% chance of spawning a UFO at every update.
    if math.random(2000) == 1 then 
        attributes = {
            x = WINDOW_W,
            y = 0,
            hp = 1,
        }
        table.insert(bonus_ufo, attributes)
    end

    -- Updates each individual UFO position.
    for i=1, #bonus_ufo do
        local ufo = bonus_ufo[i]
        ufo.x = ufo.x - 3
    end
    -- Removes a UFO from table if it reachs the end of the window without giving points.
    for i=#bonus_ufo, 1, -1 do
        local ufo = bonus_ufo[i]
        if ufo.x <= 0 - ufo_height then
            table.remove(bonus_ufo, i)
        end
    end

end