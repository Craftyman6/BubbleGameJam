--include main.lua and misc.lua
require("misc");


--Player object
player=
{
	--x position
	x=230,
	--y position
	y=230,
	--x momentum
	dx=0,
	--y momentum
	dy=0,
	--player friction
	friction=0.7,
	--player speed
	speed=1,
	--string of all sprite filenames
	sprites={
		love.graphics.newImage("Sprites/Player/Duck1.png"),
		love.graphics.newImage("Sprites/Player/Duck2.png")
	},
	--negative one if flipped sprite
	flp=1,
	flpoffset=0,
	--current sprite image object
	sprite=love.graphics.newImage("Sprites/Player/Duck1.png"),
	--Window size minus sprite size
	windowWidth = 500 - (89 * .5),
	windowHeight = 500 - (89 * .5),
	--shoot cooldown
	cooldown=0,
	--array of upgrades
	upgrades={
		--three ducks at a time
		triple=false,
		--shoot backwards as well
		backwards=false,
		--boost to player speed
		boost=false,
		--increase duck speed
		speed=3,
		--increase duck size
		size=.5,
		--decrease cooldown
		maxCooldown=45
	},
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
		local splash = false;
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.dy=player.dy-player.speed;
			splash=true;
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.dx=player.dx-player.speed;
			splash=true;
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.dy=player.dy+player.speed;
			splash=true;
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			player.dx=player.dx+player.speed;
			splash=true;
		end

		if splash and math.random()>.6 then require "main"; makeSplash(player.x+25,player.y+25,15) end

		player.dx=player.dx*player.friction;
		player.dy=player.dy*player.friction;

		player.cooldown=mid(0,player.cooldown-1,player.upgrades.maxCooldown);

		if player.dx>0 then player.flp=1; player.flpoffset=0 else player.flp=-1; player.flpoffset=35 end

		local currentSprite=getDrawBounce();

		player.sprite=player.sprites[currentSprite];
	end,
	--draw function
	draw = function()
		love.graphics.draw(player.sprite,player.x+player.flpoffset,player.y,0,.5*player.flp,.5);
	end
}

function healthDraw(pHealthNum)
	pHealth = string.format("Health: %d", pHealthNum)
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.print(pHealth, 400, 0)
end