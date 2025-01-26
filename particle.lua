Particle = Object:extend()

function Particle:new(x,y)
	self.x=x
	self.y=y
	local angle=math.random()*2*math.pi
end

function Particle:update()
	self.time=self.time+1
	self.size=self.size+1
	return self.time<=0
end

function Particle:draw()
	love.graphics.setColor(.9,.9,.9,1-self.time/15)
	love.graphics.ellipse("line",self.x,self.y,self.time,self.time*.5)
	love.graphics.setColor(1,1,1)
end