require("main")

Particle = Object:extend()

function setParticleColor(cid)
	if cid==1 then
		--duck
		love.graphics.setColor(1,1,.5)
	elseif cid==0 then
		--bubble
		love.graphics.setColor(1,1,1)
	end
end

function Particle:new(x,y,cid)
	self.x=x
	self.y=y
	self.cid=cid
	self.time=20+math.random()*9+cid*8
	local angle=math.random()*2*math.pi
	local speed=math.random()*2+1
	self.dx=speed*math.cos(angle)
	self.dy=speed*math.sin(angle)
end

function Particle:update()
	self.x=self.x+self.dx
	self.y=self.y+self.dy
	self.dx=self.dx/1.1
	self.dy=self.dy/1.1
	self.time=self.time-1
	if math.random()<math.abs(self.dx) and math.random()<math.abs(self.dy) then makeSplash(self.x,self.y,5) end
	return self.time<=0
end

function Particle:draw()
	setParticleColor(self.cid)
	love.graphics.circle("fill",self.x,self.y,self.cid+1)
	love.graphics.setColor(1,1,1)
end