require("misc");

Bubble = Object:extend();

bubbleSprites={"Bubble"};

--Makes new bubble object. Just leave first parameter true to spawn
--the bubble randomly, leave it false to make a custom bubble
function Bubble:new(random,x,y,dx,dy)
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
	else
		self.x=x;
		self.y=y;
		self.dx=dx;
		self.dy=dy;
	end
end

function Bubble:update()
	self.x=self.x+self.dx;
	self.y=self.y+self.dy;

	local currentSprite=1;

	self.sprite=love.graphics.newImage("Sprites/Bubble/"..bubbleSprites[currentSprite]..".png");

	--chose whether to remove bubble or not
	if not (self.x==mid(-30,self.x,530) and self.y==mid(-30,self.y,530))then
		return true;
	else
		return false;
	end
end

function Bubble:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,.3,.3);
end