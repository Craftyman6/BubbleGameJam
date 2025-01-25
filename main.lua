--import bubble file with Bubble data
require("bubble");

--default lua function that runs every frame
function love.update()
	updateBubbles();
end

--default lua function that runs every frame
function love.draw()
    drawBubbles();
end

--function that runs code from each bubble every frame
function updateBubbles()
	--check if the mouse is down
	if love.mouse.isDown(1) then
		--store mouse position
		local x,y=love.mouse.getPosition();
		--make bubble in position
		Bubble.makeBubble(x,y);
	end
	--for every bubble
	for i,bubble in ipairs(Bubble.allBubbles) do
		--move x
		bubble.x=bubble.x+bubble.dx;
		--move y
		bubble.y=bubble.y+bubble.dy;
		--slow down x
		bubble.dx=mid(bubble.dx+.1,0,bubble.dx-.1);
		--slow down y
		bubble.dy=mid(bubble.dy+.1,0,bubble.dy-.1);
		--increase timer
		bubble.timer=bubble.timer+1;
		--if bubble has existed for too long
		if bubble.timer>60 then
			--remove bubble
			table.remove(Bubble.allBubbles,i);
		end
	end
end

--function that runs code to draw each bubble
function drawBubbles()
	--for every bubble
	for i,bubble in ipairs(Bubble.allBubbles) do
		--draw bubble outline
		love.graphics.circle("line",bubble.x,bubble.y,4);
		--draw bubble reflection
		love.graphics.circle("fill",bubble.x+1,bubble.y-1,1);
	end
end

--function that returns the middle value of three numbers
function mid(a,b,c)
	print("ran");
	return math.max(math.min(a,b), math.min(math.max(a,b),c));
end