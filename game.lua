require('enemy')

function gameload()
	player = {}
	player.x = 76
	player.y = 70
	player.img = love.graphics.newImage('/Sprites/Character/Opa-Opa.png')
	player.dir = 0
	death = false
	enemy = {}
	enemydb = {}
	spawner = {}
	shots = {}
	bulletdb = {}
	bulletdb = {
	--Structure
	--x     = id of the bullet
	--Speed = bulletdb[x][1]
	--Delay = bulletdb[x][2]
	--Image = bulletdb[x][3]
		{3,10,'/Sprites/Bullets/0.png',},
	}
	if stage == 0 then
		enemydb = {
		{love.graphics.newImage('/Sprites/Enemies/0/0.png'),love.graphics.newImage('/Sprites/Enemies/0/1.png'),love.graphics.newImage('/Sprites/Enemies/0/2.png'),10,10,},
		{},
		{},
		{},
		}
	end
	bg = love.graphics.newImage('/Sprites/Levels/'..stage..'.png')
	createenemy(50,50,0)
	createenemy(0,100,0)
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

function shoot()

end

function gameupdate()
	for x=1,2 do
		if love.keyboard.isDown(controls[x][7]) then
			player.x = player.x - 1.75
			player.dir = 1
		elseif love.keyboard.isDown(controls[x][8]) then
			player.x = player.x + 1.75
			player.dir = 0
		end
		if love.keyboard.isDown(controls[x][5]) then
			player.y = player.y - 1.5
		elseif love.keyboard.isDown(controls[x][6]) then
			player.y = player.y + 1.5
		end
	end
	for i,e in ipairs(enemy) do
		ai(e,e[4])
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
	love.graphics.translate(camx * -1,0)
	love.graphics.draw(bg,0,0,0,1,1,0,0)
	if player.dir == 0 then
		love.graphics.draw(player.img,player.x,player.y,0,1,1,0,0)
	else
		love.graphics.draw(player.img,player.x,player.y,0,-1,1,10,0)
	end
	for i,e in ipairs(enemy) do
		if e[3] == 0 then
			love.graphics.draw(e[6],e[1],e[2],0,1,1,0,0)
		else
			love.graphics.draw(e[6],e[1],e[2],0,-1,1,(enemydb[e[4] + 1] [4]),0)
		end
	end
end