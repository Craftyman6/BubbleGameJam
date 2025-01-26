--include other files
require("player");

function love.load()
	--set window size
	love.window.setMode(500,500);
	--load objects
	Object = require "classic";
	require "bubble";
	require "duck";
	require "splash";
	require "rectangle";
	require("score");
	--array of all objects
	allBubbles={};
	allDucks={};
	allSplashes={};
	--timer that incriments every frame
	timer=0;
	--Load game music
	song = love.audio.newSource("Music/RubberDucky.wav", "stream")
	song:setLooping(true)
	song:play()
	-- Load Background Image
	backgroundImage = love.graphics.newImage("Background/waves.png")
	rect1 = Rectangle(0, 0, 15, 500)
	rect2 = Rectangle(0, 0, 500, 15)
	rect3 = Rectangle(485, 0, 15, 500)
	rect4 = Rectangle(0, 485, 500, 15)
	score = score(0)
end

function love.update(dt)

	timer=timer+1
	player.update();

	--make bubbles
	if timer%60==30 then
		table.insert(allBubbles,Bubble(true));
	end

	--update bubbles

	for i,bubble in ipairs(allBubbles) do
		if bubble.update(bubble) then
			table.remove(allBubbles,i);
		end
	end

	--make ducks
	if love.mouse.isDown(1) and player.cooldown==0 then
		table.insert(allDucks,Duck(player.x,player.y,love.mouse.getX(),love.mouse.getY()))
		player.cooldown=player.maxCooldown
	end

	--update ducks
	for i,duck in ipairs(allDucks) do
		if duck.update(duck) then
			table.remove(allDucks,i)
		end
	end

	--update splashes
	for i,splash in ipairs(allSplashes) do
		if splash.update(splash) then
			table.remove(allSplashes,i)
		end
	end


end

function love.draw()
	love.graphics.draw(backgroundImage)
	--draw splashes
	for i,splash in ipairs(allSplashes) do
		splash.draw(splash)
	end
	player.draw();
	for i,bubble in ipairs(allBubbles) do
		bubble.draw(bubble);
	end
	for i,duck in ipairs(allDucks) do
		duck.draw(duck);
	end
	rect1:draw()
	rect2:draw()
	rect3:draw()
	rect4:draw()
	score:draw();
	love.graphics.print(#allDucks);
end

function makeSplash(x,y)
	table.insert(allSplashes,Splash(x,y));
end