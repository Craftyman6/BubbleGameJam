Splash = Object:extend()

function Splash:new(x,y)
	self.x=x
	self.y=y
	self.time=0
end

function Splash:update()
	self.time=self.time+1
	return self.time>15
end

function Splash:draw()
	love.graphics.setColor(.9,.9,.9,1-self.time/15)
	love.graphics.ellipse("line",self.x,self.y,self.time,self.time*.5)
	love.graphics.setColor(1,1,1)
end