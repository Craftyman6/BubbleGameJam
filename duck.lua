require("misc");

Duck = Object:extend();

duckSprites={"Duck"};

--Makes a new duck object
function Duck:new(px,py,mx,my)
	self.speed=5
	self.d=angle_move(px,py,mx,my,1);
	self.x=px+self.d.x*30
	self.y=py+self.d.y*30
	self.sprite=love.graphics.newImage("Sprites/SmallDuck/"..duckSprites[1]..".png");

end

function Duck:update()

	self.x=self.x+self.d.x*self.speed
	self.y=self.y+self.d.y*self.speed

	local currentSprite=1

	self.sprite=love.graphics.newImage("Sprites/SmallDuck/"..duckSprites[currentSprite]..".png");

	--chose whether to remove duck or not
	return not (self.x==mid(-30,self.x,530) and self.y==mid(-30,self.y,530))

end

function Duck:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,.5,.5)
end