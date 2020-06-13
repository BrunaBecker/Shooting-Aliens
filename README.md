

 ## **Shooting Aliens** is a small game made in LÖVE for the Final Project of [CS50x 2020](https://cs50.harvard.edu/x/2020/).
 
 The development of this game explored the LUA language, LÖVE framework - plus a few of its libraries -, and public/free licensed assets scavenged across different websites - all properly credited in a following section.

Project Author: Bruna Becker
 
 # Game features: 

## Implementation of media such as sounds, images, fonts

Each piece of the game has its own sprite, and most events like shooting or colliding trigger your respective sound effect. The game also has a background soundtrack and standard font. A weapon must always pew.

## Interactive menus

Upon launching the game, the user is greeted by the game menu. Inspired by many classic games, pressing start will take the game to the next screen: ship selection. There, the user can choose which spaceship to play with from three options. Pressing start again will define the choice and proceed to the gameplay itself.

## Gameplay with increasing difficulty

Extraterrestrial creatures found you in dark, vast space and they want to take you down! As a weaponized spacecraft, the player must try not to be defeated by a - very defined - number of - ordered and coordinated - aliens. Have I mentioned that killing one scores you some points?

Defeating every alien in a fleet will trigger a harder and faster one.

## Random generated objectives

There's a small but constant possibility that a random unidentified circular flying object will show up crossing the top corner of the game screen. They are very valuable in score points. And if you don't hit them, no one will ever believe you when you say you saw one. 

## Score system and scoreboard saved locally

Upon being defeated, the player's score will be saved in a local file for the purpose of bragging rights. The five highest scores will be listed on the game over screen.

The player has the option to type their username of choice to be associated with the achieved scored. Otherwise, it will be recorded for all posterity* with the boring "Player" nickname. 

This game doesn't has any type of interaction with the network or multiplayer feature. The user's score history will be private unless he purposefully shares it.
			
*Or until the save file is altered/deleted. Whatever happens first.

# Controls:
`start` or `spacebar`: Confirm in menus.

`right` and `left` arrows or `a` and `d`: menu and in-game movement. 

`z` or `spacebar`: Fire in-game.

`esc`: Quits game completely.


# Resources and Credits:
	
**Language**

* [Lua](http://www.lua.org/)

Especial shout-out to the quick and helpful [Learn Lua in 15 Minutes](http://tylerneylon.com/a/learn-lua/) guide, by Tyler Neylon.


**Framework**
* [LÖVE](https://love2d.org/)
	* [BoundingBox LÖVE](https://love2d.org/wiki/BoundingBox.lua) script for collision detection .
	*  [SICK](https://gist.github.com/Kyrremann/b29397159e939cff2896ed53f1e7c10f) library for highscore feature.

**Borrowed Code Snippet**
*  math.cos blinking animation from the source of [CÖIN](https://bitbucket.org/gprosser/coin/src/master/), a game made by George Prosser.
* User text input with backspace feature from [love.textinput](https://love2d.org/wiki/love.textinput).


**Assets** 

Every resource from [Kenney](https://kenney.nl/) used in this project is licensed under [Public Domain (CC0 1.0 Universal)](https://creativecommons.org/publicdomain/zero/1.0/). 

* Images
	* Aliens assets from [Kenney's Alien UFO pack](https://kenney.nl/assets/alien-ufo-pack)
	* Spaceships, projectiles, icons, cursor, brackground assets from [Kenney's Space Shooter Redux](https://kenney.nl/assets/space-shooter-redux).

* Sound effects 
	* Pretty much everything from [Kenney's Space Shooter Redux](https://kenney.nl/assets/space-shooter-redux).
	* But a few extras were made in [BFXR](https://www.bfxr.net/).

* Text Fonts 
	* Kenvector Future from the bonus pack from [Kenney's Space Shooter Redux](https://kenney.nl/assets/space-shooter-redux).


* Background Soundtrack 
	* “Nuts and Bolts”, from PlayOnLoop.com.
	Licensed under Creative Commons by [Attribution 4.0](https://creativecommons.org/licenses/by/4.0/).
	No changes and alterations were made to the track.	

