require("misc");

Bubble = Object:extend();

bubbleSpritesString={"Bubble","Evil Bubble"};

bubbleSprites={}
for i,str in ipairs(bubbleSpritesString) do
	table.insert(bubbleSprites,love.graphics.newImage("Sprites/Bubble/"..str..".png"))
end

--Makes new bubble object. Just leave first parameter true to spawn
--the bubble randomly, leave it false to make a custom bubble
function Bubble:new(evil,health)
	self.popped=false
	self.noScore=false
	self.sprite=bubbleSprites[1];
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
	self.evil=evil;
	self.health=health

end

function Bubble:update()
	self.x=self.x+self.dx;
	self.y=self.y+self.dy;

	require "player"
	require "main"
	if self.x >= player.x and self.x <= (player.x + 89 * .5) and self.y >= player.y and self.y <= (player.y + 89 * .5) then
		health = health - 1
		self.popped = true
		self.noScore = true
	end

	if self.evil then
		local d=angle_move(self.x,self.y,player.x,player.y,1);
		self.x=self.x+d.x
		self.y=self.y+d.y
	end

	local currentSprite=1;
	if self.evil then currentSprite=2 end

	self.sprite=bubbleSprites[currentSprite]


	if self.popped and self.evil and self.noScore == false then
		score:update(2)
	end
	if self.popped and self.evil == false and self.noScore == false then 
		score:update(1)
	end

	--chose whether to remove bubble or not
	return not (self.x==mid(-30,self.x,530) and self.y==mid(-30,self.y,530)) or self.popped
end

function Bubble:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,.3,.3);
end