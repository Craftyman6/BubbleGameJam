function mid(a,b,c)
	return math.max(math.min(a,b), math.min(math.max(a,b),c));
end

function angle_move(x,y, targetx, targety, speed)
	local a=atan2(x-targetx,y-targety)
	return {x=-speed*cos(a), y=-speed*sin(a)}
end