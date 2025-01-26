require("misc");
require("main")

Duck = Object:extend();

duckSpritesString={"Duck"};

duckSound = love.audio.newSource("Music/shoot_cc.wav", "static")

duckSprites={}
for i,str in ipairs(duckSpritesString) do
	table.insert(duckSprites,love.graphics.newImage("Sprites/SmallDuck/"..str..".png"))
end

--Makes a new duck object
function Duck:new(px,py,mx,my,size,speed)
	self.speed=speed
	self.d=angle_move(px,py,mx,my,1);
	self.x=px+self.d.x*30
	self.y=py+self.d.y*30
	self.sprite=duckSprites[1]
	self.size=size
	love.audio.setEffect("shootEffect", {
		type = "distortion",
		gain = math.random()*.5,
		edge = math.random()*.25,
	})
	duckSound:setEffect("shootEffect")
	duckSound:play()
end

function Duck:update()

	self.x=self.x+self.d.x*self.speed
	self.y=self.y+self.d.y*self.speed

	local currentSprite=1

	self.sprite=duckSprites[currentSprite]

	if math.random()<.3 then makeSplash(self.x+15,self.y+15,10) end

	--check to pop bubbles
	require "main"
	for i,bubble in ipairs(allBubbles) do
		if math.sqrt(math.pow(self.x-bubble.x,2)+math.pow(self.y-bubble.y,2))<30+10*self.size then
			bubble.health=bubble.health-1
			makeParticles(self.x+15+5*self.size,self.y+15+5*self.size,math.floor(6+self.size*5),1)
			return true
		end
	end

	--chose whether to remove duck or not
	return not (self.x==mid(-30,self.x,530) and self.y==mid(-30,self.y,530))

end

function Duck:draw()
	love.graphics.draw(self.sprite,self.x,self.y,0,self.size,self.size,25,25)
end