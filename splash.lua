Splash = Object:extend()

function Splash:new(x,y,t)
	self.x=x
	self.y=y
	self.time=t
	self.startTime=t
	self.size=0
end

function Splash:update()
	self.time=self.time-1
	self.size=self.size+1
	return self.time<=0
end

function Splash:draw()
	love.graphics.setColor(.9,.9,.9,self.time/self.startTime)
	love.graphics.ellipse("line",self.x,self.y,self.size,self.size*.5)
	love.graphics.setColor(1,1,1)
end