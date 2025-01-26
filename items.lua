require("player");
require("misc");

stock={}

function getItemSprite(str)
	return love.graphics.newImage("Sprites/Items/"..str..getDrawBounce()..".png")
end

items={
	{
		name="Bowl",
		desc="Shoot three ducks at once",
		available=function() return not player.upgrades.triple end,
		redeem=function() player.upgrades.triple=true end
	},
	{
		name="Spork",
		desc="Shoot ducks behind you",
		available=function() return not player.upgrades.backwards end,
		redeem=function() player.upgrades.backwards=true end
	},
	{
		name="Plate",
		desc="Swim faster",
		available=function() return not player.upgrades.boost end,
		redeem=function() player.upgrades.boost=true; player.friction=.8 end
	},
	{
		name="Spoon",
		desc="Ducks swim faster",
		available=function() return true end,
		redeem=function() player.upgrades.speed=player.upgrades.speed+2 end
	},
	{
		name="Sponge",
		desc="Larger ducks",
		available=function() return true end,
		redeem=function() player.upgrades.size=player.upgrades.size+.2 end
	},
	{
		name="Chopsticks",
		desc="Shoot ducks more rapidly",
		available=function() return player.upgrades.maxCooldown>5 end,
		redeem=function() player.upgrades.maxCooldown=player.upgrades.maxCooldown-5 end
	}
}

function getTwoItems()
	local available={}
	for i,item in ipairs(items) do
		if item.available() then table.insert(available,i) end
	end
	local ret={}
	for i=0,1 do
		local choice=math.random(1,#available)
		table.insert(ret,available[choice])
		table.remove(available,choice)
	end
	stock = ret
end



function drawShop()
	require "main"
	love.graphics.draw(getItemSprite("Dishwasher"),-50,20)
	for i,id in ipairs(stock) do
		local item=items[id]
		if getSelected()==i then
			love.graphics.setColor(0,0,0)
			love.graphics.print(item.name,-100+200*i,370)
			love.graphics.print(item.desc,-100+200*i,400)
			love.graphics.setColor(1,1,1)
		else
			love.graphics.setColor(.5,.5,.5)
		end
		love.graphics.draw(getItemSprite(item.name),-100+200*i,190+math.sin(i+love.timer.getTime()*5)*10)
		love.graphics.setColor(1,1,1)
	end
end

function getSelected()
	local x,y = love.mouse.getPosition()
	if y<150 or y>350 then
		return 0
	else
		return math.floor(x/250)+1
	end
end