-- Tables to store image (and its respectives widths and heights, if necessary) and sound files.

ship = {
    ship1 = love.graphics.newImage('assets/player/playerShip1_red.png'),
    ship2 = love.graphics.newImage('assets/player/playerShip2_red.png'),
    ship3 = love.graphics.newImage('assets/player/playerShip3_red.png')
}
ship_width = (ship.ship1:getWidth() * 0.5)
ship_height = (ship.ship1:getHeight() * 0.5)

damage_light = {
    ship1 = love.graphics.newImage('assets/player/playerShip1_damage.png'),
    ship2 = love.graphics.newImage('assets/player/playerShip2_damage.png'),
    ship3 = love.graphics.newImage('assets/player/playerShip3_damage.png'),
}
damaged_heavy = {
    ship1 = love.graphics.newImage('assets/player/playerShip1_damage2.png'),
    ship2 = love.graphics.newImage('assets/player/playerShip2_damage2.png'),
    ship3 = love.graphics.newImage('assets/player/playerShip3_damage2.png')
}

life_ui = {
    hp1 = love.graphics.newImage('assets/player/playerLife1_red.png'),
    hp2 = love.graphics.newImage('assets/player/playerLife2_red.png'),
    hp3 = love.graphics.newImage('assets/player/playerLife3_red.png')
}
life_width = life_ui.hp1:getWidth()
life_height = life_ui.hp1:getHeight()

alien = {
    alien_one = love.graphics.newImage('assets/aliens/shipPink.png'),
    alien_two = love.graphics.newImage('assets/aliens/shipGreen.png'),
    alien_three = love.graphics.newImage('assets/aliens/shipBlue.png'),
    ufo = love.graphics.newImage('assets/aliens/ufoBlue.png')
}
alien_width = (alien.alien_one:getWidth() * 0.5)
alien_height = (alien.alien_one:getHeight() * 0.5)
ufo_width = (alien.ufo:getWidth())
ufo_height = (alien.ufo:getHeight())

kill = {
    explosion_one = love.graphics.newImage('assets/aliens/laserPink_burst.png'),
    explosion_two = love.graphics.newImage('assets/aliens/laserGreen_burst.png'),
    explosion_three = love.graphics.newImage('assets/aliens/laserBlue_burst.png')
}

ammo = {
    player_laser = love.graphics.newImage('assets/lasers/laserRed06.png'),
    alien_laser = love.graphics.newImage('assets/lasers/laserBlue06.png')
}


sounds = {
    sfx_twoTone = love.audio.newSource('sounds/sfx_twoTone.ogg', 'static'),
    sfx_laser = love.audio.newSource('sounds/sfx_laser1.ogg', 'static'),
    sfx_laser_alien = love.audio.newSource('sounds/sfx_laser2.ogg', 'static'),
    sfx_lose = love.audio.newSource('sounds/sfx_lose.ogg', 'static'),
    sfx_zap = love.audio.newSource('sounds/sfx_zap.ogg', 'static'),
    sfx_hurt = love.audio.newSource('sounds/sfx_hurt.wav', 'static'),
    sfx_ufo = love.audio.newSource('sounds/sfx_ufo.wav', 'static')
}

music = {
    soundtrack = love.audio.newSource('sounds/POL-nuts-and-bolts-short.wav', 'static')
}

cursor = love.graphics.newImage('assets/cursor.png')