--include other files
require("player");
require("items");
require("misc");

function love.load()
	love.window.setTitle("Dirty Duck")
	love.window.setIcon(love.image.newImageData("Sprites/Player/Duck1.png"))
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
	gameTimer=0;
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
	loseSong:setLooping(false)
	loseSong:play()
	loseSong:pause()
	--Load Sound Effects
	upgradeSound = love.audio.newSource("Music/upgrade_cc.wav", "static")
	itemSound =love.audio.newSource("Music/item_cc.wav", "static")
	-- Load Background Image
	backgroundImages = {
		love.graphics.newImage("Background/Waves1.png"),
		love.graphics.newImage("Background/Waves2.png")
	}
	-- Load Title image
	titleImages = {
		love.graphics.newImage("Sprites/Title/Title1.png"),
		love.graphics.newImage("Sprites/Title/Title2.png")
	}
	rect1 = Rectangle(0, 0, 15, 500)
	rect2 = Rectangle(0, 0, 500, 15)
	rect3 = Rectangle(485, 0, 15, 500)
	rect4 = Rectangle(0, 485, 500, 15)
	score = score(0)

	level = 0;
	swapCooldown = 3
	loseCooldown = 9
	soundPlayed = false
	--Player's health
	playerHealth = 10
end


function love.update()
	gameTimer=gameTimer+1
	if mode=="move" then
		timer=timer+1
		swapCooldown = 3
		loseCooldown = 9
		soundPlayed = false
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
		if soundPlayed == false then
			upgradeSound:play()
			soundPlayed = true
		end
		shopSong:play()
		song:pause()
	elseif mode =="modeSwap" then
		if swapCooldown==0 then
			mode = "move"
		end
		if gameTimer%60==30 then
			swapCooldown = swapCooldown - 1
		end
	elseif mode =="start" then
		--player.update();
		introSong:play()
		loseSong:stop()
		song:stop()
		shopSong:stop()
	elseif mode == "lose" then
		song:stop()
		shopSong:stop()
		introSong:stop()
		loseSong:play()
		if loseCooldown==0 then
			mode = "start"
			gameReset()
		end
		if gameTimer%60==30 then
			loseCooldown = loseCooldown - 1
		end
	end
end

function love.draw()
	love.graphics.draw(backgroundImages[getDrawBounce()])
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
		rect7 = Rectangle(225, 15, 50, 30)
		rect7:draw()
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
		love.graphics.print(swapCooldown, 247, 21, 0, 1, 1)
	end
	if mode=="start" then
		rect5 = Rectangle(200, 225, 100, 50)
		rect5:draw()
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
		love.graphics.print("START", 231, 240)
		love.graphics.draw(titleImages[getDrawBounce()])
	end
	if mode == "lose" then
		rect6 = Rectangle(185, 200, 130, 100)
		rect6:draw()
		love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
		love.graphics.print("You lose", 225, 240)
		love.graphics.print(loseCooldown, 245, 260, 0, 1, 1)
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
			itemSound:play()
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

function gameReset()
	player.x = 201
	player.y = 100
	player.dx = 0  
	player.dy = 0 
	player.friction = 0.7 
	player.speed = 1
	player.cooldown = 0
	player.upgrades[1] = false
	player.upgrades[2] = false
	player.upgrades[3] = false
	player.upgrades[4] = 3
	player.upgrades[5] = 0.5
	player.upgrades[6] = 45
	allBubbles={}
	allDucks={}
	allSplashes={}
	allParticles={}
	playerHealth = 10
	timer = 0 
	gameTimer = 0
	nextBubble = 0
	score:new(0)
	level = 0;
end