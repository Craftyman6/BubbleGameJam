--include other files
require("player");
--require("score");

function love.load()
	--set window size
	love.window.setMode(500,500);
	--load objects
	Object = require "classic";
	require "bubble";
	require "duck";
	--array of all objects
	allBubbles={};
	allDucks={};
	--timer that incriments every frame
	timer=0;
	--Load game music
	song = love.audio.newSource("Music/RubberDucky.wav", "stream")
	song:setLooping(true)
	song:play()
	-- Load Background Image
	background = love.graphics.newImage("Background/waves.png")
	--
	--score = score(0)
end

function love.update()
	timer=timer+1
	player.update();
	if timer%60==30 then

		table.insert(allBubbles,Bubble(true));
	end

	--update bubbles
	for i,bubble in ipairs(allBubbles) do
		if bubble.update(bubble) then
			table.remove(allBubbles,i);
		end
	end

	--update ducks
	for i,duck in ipairs(allDucks) do
		if duck.update(duck) then
			table.remove(allDucks,i)
		end
	end
end

function love.mousepressed(x,y,button)
	if button==1 then
		print("ran");
		table.insert(allDucks,Duck(player.x,player.y,x,y))
	end
end

function love.draw()
	love.graphics.draw(background)
	player.draw();
	--score.draw();
	for i,bubble in ipairs(allBubbles) do
		bubble.draw(bubble);
	end
	for i,duck in ipairs(allDucks) do
		duck.draw(duck);
	end
	love.graphics.print(#allDucks);
end