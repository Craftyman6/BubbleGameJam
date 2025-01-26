--include other files
require("player");
require("score");

function love.load()
	--set window size
	love.window.setMode(500,500);
	--load objects
	Object = require "classic";
	require "bubble";
	--array of all bubbles
	allBubbles={};
	--timer that incriments every frame
	timer=0;
	--Load game music
	song = love.audio.newSource("Music/RubberDucky.wav", "stream")
	song:setLooping(true)
	song:play()
	-- Load Background Image
	background = love.graphics.newImage("Background/waves.png")
	--
	score = score(0)
end

function love.update()
	timer=timer+1
	player.update();
	if timer%60 == 30 then
		table.insert(allBubbles,Bubble(true));
	end

	--update bubbles
	for i,bubble in ipairs(allBubbles) do
		if bubble.update(bubble) then
			table.remove(allBubbles,i);
		end
	end
end

function love.draw()
	love.graphics.draw(background)
	player.draw();
	score.draw();
	for i,bubble in ipairs(allBubbles) do
		bubble.draw(bubble);
	end
	love.graphics.print(#allBubbles);
end