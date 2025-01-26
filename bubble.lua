require("misc");

Bubble = Object:extend();

bubbleSprites={"Bubble","Evil Bubble"};

--Makes new bubble object. Just leave first parameter true to spawn
--the bubble randomly, leave it false to make a custom bubble
function Bubble:new(random,x,y,dx,dy,evil)
	self.popped=false
	if random then
		--my ass is not smart enough to optimize this even though
		--I'm 100% sure there's a way to
		local get;
		if math.random()>.5 then
			if math.random()>.5 then
				--top
				get={math.random(0,500),-20,0,1}
			else
				--bottom
				get={math.random(0,500),520,0,-1}
			end
		else
			if math.random()>.5 then
				--left
				get={-20,math.random(0,500),1,0}
			else
				--right
				get={520,math.random(0,500),-1,0}
			end
		end
		self.x=get[1];
		self.y=get[2];
		self.dx=get[3];
		self.dy=get[4];
		self.evil=math.random()>.5
	else
		self.x=x;
		self.y=y;
		self.dx=dx;
		self.dy=dy;
		self.evil=evil
	end


end

function Bubble:update()
	self.x=self.x+self.dx;
	self.y=self.y+self.dy;

	if self.evil then
		require "player"
		local d=angle_move(self.x,self.y,player.x,player.y,1);
		self.x=self.x+d.x
		self.y=self.y+d.y
	end

	local currentSprite=1;
	if self.evil then currentSprite=2 end

	self.sprite=love.graphics.newImage("Sprites/Bubble/"..bubbleSprites[currentSprite]..".png");

	require "main"
	if self.popped and self.evil then
		score:update(2)
	end
	if self.popped and self.evil == false then 
		score:update(1)
	end

	--chose whether to remove bubble or not
	return not (self.x==mid(-30,self.x,530) and self.y==mid(-30,self.y,530)) or self.popped
end

function Bubble:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,.3,.3);
end