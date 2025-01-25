Bubble={
	allBubbles={},
	makeBubble=function (x,y)
		table.insert(Bubble.allBubbles,{
			x=x,
			y=y,
			dx=love.math.random()*10-5,
			dy=love.math.random()*10-5,
			timer=0
		});
	end,
}