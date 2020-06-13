
Collision = {}

function Collision:is_player_hit()
    -- Checks if player has been hit by an enemy projectile. If true, subtract a health point.
    for i=#enemies_projectiles, 1, -1 do
        local enemy_laser_coordinate = enemies_projectiles[i]
        if  enemy_laser_coordinate.x > Player.x and 
            enemy_laser_coordinate.x < (Player.x + ship_width) and
            enemy_laser_coordinate.y > Player.y and 
            enemy_laser_coordinate.y < (Player.y + ship_width) then
                table.remove(enemies_projectiles, i)
                sounds['sfx_hurt']:stop()
                sounds['sfx_hurt']:play()
                Player.hp = Player.hp - 1
        end
    end

    -- Checks if the player has collided with an alien. If true, defeats the player completely.
    for i=1, #aliens do
        local enemy = aliens[i]
        if CheckCollision(enemy.x, enemy.y, alien_width, alien_height, Player.x, Player.y, ship_width, ship_height) then
            Player.hp = 0
        end
    end
end

function Collision:is_enemy_hit()
    -- Check every player projectile to see if they striked an alien. If true, sets the state of this alien to defeated. Also sums the value in points for that alien to the score.
    for i=#player_projectiles, 1, -1 do
        local player_laser_coordinate = player_projectiles[i]

        for j=#aliens, 1, -1 do
            local enemy = aliens[j]
            if  player_laser_coordinate.x > enemy.x and 
                player_laser_coordinate.x < (enemy.x + alien_width) and
                player_laser_coordinate.y > enemy.y and 
                player_laser_coordinate.y < (enemy.y + alien_height) then
                    table.remove(player_projectiles, i)
                    table.remove(aliens, j)
                    sounds['sfx_lose']:stop()
                    sounds['sfx_lose']:play()
                    love.graphics.draw(kill.explosion_one, enemy.x, enemy.y)
                    Game:update_score()
            end

        end
    end
end

function Collision:is_ufo_hit()
        -- Check every player projectile to see if they striked an UFO. If true, remove said UFO from the table. Also sums the value in points for that UFO to the score.
    for i=#player_projectiles, 1, -1 do
        local player_laser_coordinate = player_projectiles[i]

        for j=#bonus_ufo, 1, -1 do
            local ufo = bonus_ufo[j]
            if  player_laser_coordinate.x > (ufo.x - ufo_width/2) and 
                player_laser_coordinate.x < (ufo.x + ufo_width/2) and
                player_laser_coordinate.y > (ufo.y - ufo_height/2) and 
                player_laser_coordinate.y < (ufo.y + ufo_height/2) then
                    table.remove(player_projectiles, i)
                    sounds['sfx_lose']:stop()
                    sounds['sfx_lose']:play()
                    Game:update_bonus_score()
                    table.remove(bonus_ufo, j)
            end
        end
    end
end

-- Snippet from: BoundingBox LÖVE script for collision detection https://love2d.org/wiki/BoundingBox.lua
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end
