--include main.lua and misc.lua
require("misc");

--Player object
player={
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
	--update function
	update = function()
		player.x=player.x+player.dx;
		player.y=player.y+player.dy;
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

		local currentSprite=1;

		player.sprite=love.graphics.newImage("Sprites/Player/"..player.sprites[currentSprite]..".png");
	end,
	--draw function
	draw = function()
		love.graphics.draw(player.sprite,player.x,player.y,0,.5,.5);
	end
}