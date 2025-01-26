--Background Handler

Rectangle = Object:extend();

function Rectangle:new(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

function Rectangle:draw()
	love.graphics.setColor(love.math.colorFromBytes(194, 197, 204))
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end