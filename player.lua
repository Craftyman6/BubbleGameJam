--include main.lua and misc.lua
require("misc");

--Player object
player=
{
	--x position
	x=0,
	--y position
	y=0,
	--x momentum
	dx=0,
	--y momentum
	dy=0,
	--player friction
	friction=0.8,
	--player speed
	speed=1,
	--string of all sprite filenames
	sprites={"duck"},
	--current sprite image object
	sprite,
	--Window size minus sprite size
	windowWidth = 500 - (89 * .5),
	windowHeight = 500 - (89 * .5),
	--shoot cooldown
	cooldown=0,
	--max shoot cooldown
	maxCooldown=45,
	--update function
	update = function()
		player.x=player.x+player.dx;
		player.y=player.y+player.dy;
		if player.x <= 0 then
			player.x = 0 
		end
		if player.x >= player.windowWidth then
			player.x = player.windowWidth
		end
		if player.y <= 0 then
			player.y = 0 
		end
		if player.y >= player.windowHeight then
			player.y = player.windowHeight
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.dy=player.dy-player.speed;
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.dx=player.dx-player.speed;
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.dy=player.dy+player.speed;
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			player.dx=player.dx+player.speed;
		end
		player.dx=player.dx*player.friction;
		player.dy=player.dy*player.friction;

		player.cooldown=mid(0,player.cooldown-1,player.maxCooldown);

		local currentSprite=1;

		player.sprite=love.graphics.newImage("Sprites/Player/"..player.sprites[currentSprite]..".png");
	end,
	--draw function
	draw = function()
		love.graphics.draw(player.sprite,player.x,player.y,0,.5,.5);
	end
}