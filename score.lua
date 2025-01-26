--Score Feature

score = Object:extend();

function score:new(score)
	self.score = score
end

function score:update()
	self.score = self.score + 1
end

function score:draw()
	scoreString = string.format("Score: %d", self.score)
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	love.graphics.print(scoreString, 225, 0)
end