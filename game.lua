function gameload()
	player = {}
	player.x = 76
	player.y = 70
	player.img = love.graphics.newImage('/Sprites/Character/Opa-Opa.png')
	player.dir = 0
	enemy = {}
	enemydb = {}
	enemydb = {
	{love.graphics.newImage('/Sprites/Enemies/0/0.png'),love.graphics.newImage('/Sprites/Enemies/0/1.png'),love.graphics.newImage('/Sprites/Enemies/0/2.png')},
	{},
	{},
	{},
	}
	bg = love.graphics.newImage('/Sprites/Levels/'..stage..'.png')
	createenemy(50,50,0)
	--if stage == 0 then
	--	for n=0,0 do
	--		for f=0,2 do
	--			frame = love.graphics.newImage('/Sprites/Enemies/'..n..'/'..f..'.png')
	--			table.insert(enemydb,frame,n)
	--		end
	--	end
	--end
end

function createenemy(x,y,id)
	local e = {}
	e = {x,y,0,0,0,nil,}
	e[6] = enemydb[e[4] + 1] [e[5] + 1]
	--e[1]   = x
	--e[2]   = y
	--e[3]   = direction
	--e[4]   = id
	--e[5]   = frame
	--e[6]   = image
	table.insert(enemy,e)
end

function gameupdate()
	if love.keyboard.isDown(controls.Left) then
		player.x = player.x - 1.75
		player.dir = 1
	elseif love.keyboard.isDown(controls.Right) then
		player.x = player.x + 1.75
		player.dir = 0
	end
	if love.keyboard.isDown(controls.Up) then
		player.y = player.y - 1.5
	elseif love.keyboard.isDown(controls.Down) then
		player.y = player.y + 1.5
	end
	for i,e in ipairs(enemy) do
		if e[5] == 14 then
			e[5] = 0
		else
			e[5] = e[5] + 1
		end
		local trueframe = math.floor(e[5] / 5)
		e[6] = enemydb[e[4] + 1] [trueframe + 1]
	end
end

function gamedraw()
	camx = player.x - 76
	love.graphics.draw(bg,0,0,0,1,1,camx,0)
	if player.dir == 0 then
		love.graphics.draw(player.img,player.x - camx,player.y,0,1,1,0,0)
	else
		love.graphics.draw(player.img,player.x - camx,player.y,0,-1,1,10,0)
	end
	for i,e in ipairs(enemy) do
		love.graphics.draw(e[6],e[1],e[2],0,1,1,camx,0)
	end
end