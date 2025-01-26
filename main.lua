--include other files
require("player");
require("items");
require("misc");

function love.load()
	mode="start";
	--set window size
	love.window.setMode(500,500);
	--load objects
	Object = require "classic";
	require "bubble";
	require "duck";
	require "splash";
	require "rectangle";
	require "particle";
	require("score");
	--array of all objects
	allBubbles={};
	allDucks={};
	allSplashes={};
	allParticles={};
	--timer that incriments every frame
	timer=0;
	nextBubble=0;
	--Load game music
	song = love.audio.newSource("Music/RubberDucky.wav", "stream")
	song:setLooping(true)
	song:play()
	song:pause()
	--Load music
	shopSong = love.audio.newSource("Music/shopTheme.wav", "stream")
	shopSong:setLooping(true)
	shopSong:play()
	shopSong:pause()
	introSong = love.audio.newSource("Music/intro.wav", "stream")
	introSong:setLooping(true)
	introSong:play()
	introSong:pause()
	loseSong = love.audio.newSource("Music/lose.wav", "static")
	loseSong:play()
	loseSong:pause()
	-- Load Background Image
	backgroundImage = love.graphics.newImage("Background/waves.png")
	rect1 = Rectangle(0, 0, 15, 500)
	rect2 = Rectangle(0, 0, 500, 15)
	rect3 = Rectangle(485, 0, 15, 500)
	rect4 = Rectangle(0, 485, 500, 15)
	score = score(0)

	level = 0;
	swapCooldown = 3
	--Player's health
	playerHealth = 10
end


function love.update()
	timer=timer+1
	if mode=="move" then
		swapCooldown = 3
		introSong:stop()
		shopSong:pause()
		song:play()
		player.update();

		--make bubbles
		if timer>nextBubble then
			table.insert(allBubbles,Bubble(math.random()<timer/50000,math.min(4,1+math.floor(timer/5000))));
			nextBubble=timer+60-math.min(math.floor(timer/1000),30)
		end

		--update bubbles
		for i,bubble in ipairs(allBubbles) do
			if bubble.update(bubble) then
				table.remove(allBubbles,i);
			end
		end

		--make ducks
		if love.mouse.isDown(1) and player.cooldown==0 then
			offsets={x=0,y=0}
			ammount=0
			if player.upgrades.triple then 
				offsets=getDuckOffsets(-2)
				ammount=2
			end
			for i=0,ammount do
				table.insert(allDucks,Duck(player.x+15+offsets.x,player.y+15+offsets.y,love.mouse.getX(),love.mouse.getY(),player.upgrades.size,player.upgrades.speed))
				if player.upgrades.backwards then
					local targetCoords=getOppositeCoords(player.x+15,player.y+15,love.mouse.getX(),love.mouse.getY())
					table.insert(allDucks,Duck(player.x+15+offsets.x,player.y+15+offsets.y,targetCoords.x,targetCoords.y,player.upgrades.size,player.upgrades.speed))
				end
				offsets=getDuckOffsets(i*2)
			end
			player.cooldown=player.upgrades.maxCooldown
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

		--update particles
		for i,particle in ipairs(allParticles) do
			if particle.update(particle) then
				table.remove(allParticles,i)
			end
		end

		--level up
		if score.score>=getNextLevelScore() then
			level=level+1
			--mode to item and stock them
			mode="item"
			getTwoItems()
		end
		if playerHealth <= 0 then
			mode = "lose"
		end
	elseif mode=="item" then
		shopSong:play()
		song:pause()
	elseif mode =="modeSwap" then
		if swapCooldown==0 then
			mode = "move"
		end
		if timer%60==30 then
			swapCooldown = swapCooldown - 1
		end
	elseif mode =="start" then
		player.update();
		introSong:play()
		loseSong:stop()
		song:stop()
		shopSong:stop()
	elseif mode == "lose" then
		song:stop()
		shopSong:stop()
		introSong:stop()
		loseSong:play()
	end
end

function love.draw()
	love.graphics.draw(backgroundImage)
	--draw splashes
	for i,splash in ipairs(allSplashes) do
		splash.draw(splash)
	end
	--draw particles
	for i,particle in ipairs(allParticles) do
		particle.draw(particle)
	end
	--draw player
	player.draw();
	--draw ducks
	for i,duck in ipairs(allDucks) do
		duck.draw(duck);
	end
	--draw bubbles
	for i,bubble in ipairs(allBubbles) do
		bubble.draw(bubble);
	end
	rect1:draw()
	rect2:draw()
	rect3:draw()
	rect4:draw()
	healthDraw(playerHealth)
	score:draw();

	if mode=="item" then
		drawShop()
	end
	if mode=="modeSwap" then
		love.graphics.print(swapCooldown, 250, 250, 0, 2, 2)
	end
	if mode=="start" then
		rect5 = Rectangle(200, 225, 100, 50)
		rect5:draw()
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
		love.graphics.print("START", 231, 240)
	end
	love.graphics.print(timer)
end

--make splash with t growing the bigger the splash
function makeSplash(x,y,t)
	table.insert(allSplashes,Splash(x,y,t));
end

function love.mousepressed(x,y,button)
	if mode=="move" then

	elseif mode=="item" then
		if getSelected()>0 then
			items[stock[getSelected()]].redeem()
			mode="modeSwap"
		end
	elseif mode =="start" then
		if x >= 200 and x <= 300 and y >= 225 and y <= 275 then
			mode = "modeSwap"
		end
	end
end

function getDuckOffsets(a)
	local size = player.upgrades.size
	return {x=35*math.cos(a)*size,y=35*math.sin(a)*size}
end

function getNextLevelScore()
	return 10+math.floor(math.pow(level*5,1.5))
end

function makeParticles(x,y,a,cid)
	for i=1,a do
		table.insert(allParticles,Particle(x,y,cid))
	end
end