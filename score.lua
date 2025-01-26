--Score Feature

score = Object:extend();

function score.new(score)
	self.score = score
end

function score.update()
	self.score = self.score + 1
end

function score.draw()
	love.graphics.print("Score" + self.score, 200, 0)
end