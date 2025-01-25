--include player.lua
require("player");

function love.load()

end

function love.update()
	player.update();
end

function love.draw()
	player.draw();
end

-- test