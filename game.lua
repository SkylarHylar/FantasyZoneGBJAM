require('enemy')

function gameload()
	player = {}
	player.x     = 76
	player.xbound= 10
	player.y     = 70
	player.ybound= 8
	player.img   = love.graphics.newImage('/Sprites/Character/Opa-Opa.png')
	player.dir   = 0
	player.gun   = 0
	player.gs    = false
	player.gd    = 0
	player.bs    = false
	player.bd    = 0
	player.bomb  = 4
	player.timer = 0
	pause        = false
	score        = 0
	money        = 0
	--player.timer is the amount of time a bought weapon lasts.
	death = false
	
	shot = love.audio.newSource('/Sounds/shoot.wav', 'static')
	
	enemy = {}
	--e[1] = x
	--e[2] = y
	--e[3] = direction
	--e[4] = id
	--e[5] = frame
	--e[6] = image
	enemydb = {}
	spawner = {}
	--p[1] = x
	--p[2] = y
	--p[3] = hp
	--p[4] = frame
	--p[5] = image
	spawnerdb = {}
	shots = {}
	--s[1] = x
	--s[2] = y
	--s[3] = dir
	--s[4] = angle
	--s[5] = id
	--Gotta talk about angles!
	--0-7:  Up to Down-Down-Right.
	--8-15: Down to Up-Up-Left.
	--Angles apply to 7 shot (and maybe enemy shots).
	bulletdb = {}
	bulletdb = {
	----Structure
	--x     = id of the bullet
	--Speed = bulletdb[x][1]
	--Delay = bulletdb[x][2]
	--Image = bulletdb[x][3]
	--X Bound = bulletdb[x][4]
	--Y Bound = bulletdb[x][5]
	--Damage = bulletdb[x][6]
	----Bullet IDs:
	--0: Twin Shot
	--1: Wide Shot
	--2: Laser Shot
	--3: 7-Way Shot
	--4: Bomb
	--5: Smart Bomb
	--6: Fire Bomb
	--7: Heavy Bomb
		{8,8,'0',8,8,1},
		{3,10,'1',20,30,2},
		{3,10,'2',24,8,1},
		{3,10,'3',4,4,1},
		{3,10,'4',8,8,4},
		{3,10,'5',8,8,1},
		{3,10,'6',8,8,32},
		{3,10,'7',8,8,32},
	}
	for x=0,3 do
		bulletdb[x + 1][3] = love.graphics.newImage('/Sprites/Bullets/'..bulletdb[x + 1][3]..'.png')
	end
	--Note: All values are taken from the SMS version, since that would be a toned-down home version, instead of the hard Arcade Version.
	----Weapons:
	---NAME: Damage, Price, Increase.
	--Twin Shot: 1, Included, Nil.
	--Wide Shot: 2, $1000, + $400.
	--Laser Shot: 1 (but it is a continuous shot), $500, + $800.
	--7-Way Shot: 1 (Shoots 7, and multiple can hit.), $2500, + ?.
	--Bomb: 4, Included, Nil.
	--Twin Bomb: 4 (There can be 2 at a time),$100, + $100.
	----Special Bombs: You only get one, but they're kinda useful.
	--Smart Bomb: 1 (Does damage to every enemy), $1000, + $500.
	--Fire Bomb: Insta-Wrecks?, $1000, + $300.
	--Heavy Bomb: Insta-Wrecks?, $1000, + $500.
	----Engines: Guessing on the speeds, and their prices do not increase.
	---NAME: Speed, Price.
	--Small Wings: 1.5, Included.
	--Big Wings: ?, $100.
	--Jet Engine: ?, $500.
	--Turbo Engine: ?, $5000.
	--Rocket Engine: ? (Reported to be insanely fast, making it nearly impossible to use), $30000.
	----Lives: $2500, ? (First time, it was + $7500).
	--The Twin Shot is the base of the scale, with the Level 1 spawners having 16 HP.
	spawnerdb = {
		{love.graphics.newImage('/Sprites/Spawners/0/0.png'),love.graphics.newImage('/Sprites/Spawners/0/1.png'),28,18,16,}
		
	}
	if stage == 0 then
		enemydb = {
			{love.graphics.newImage('/Sprites/Enemies/0/0.png'),love.graphics.newImage('/Sprites/Enemies/0/1.png'),love.graphics.newImage('/Sprites/Enemies/0/2.png'),10,10,},
			{},
			{},
			{},
		}
		spawner = {
			{140,30,spawnerdb[1][5],0,spawnerdb[1][1],}
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
	table.insert(enemy,e)
end

function trigger(ent,id,angle)
	if ent == player then
		if id ~= 3 then
			s = {}
			s = {player.x + (player.dir * -10),player.y,player.dir,0,id,}
			table.insert(shots,s)
		end
	else
		
	end
end

function shoot(ent)
	if ent[5] == 0 then
		if ent[3] == 0 then
			ent[1] = ent[1] + bulletdb[ent[5] + 1][1]
		else
			ent[1] = ent[1] - bulletdb[ent[5] + 1][1]
		end
	elseif ent[5] == 4 then
		
	end
	if ent[1] <= player.x - 84 or ent[1] >= player.x + 84 then
		for i=0,5 do
			table.remove(shots,ent[i])
		end
		ent = nil
		player.gs = false
	else
	
	end
end

function gameupdate()
	for x=1,2 do
		if love.keyboard.isDown(controls[x][7]) then
			player.x = player.x - 1.5
			player.dir = 1
		elseif love.keyboard.isDown(controls[x][8]) then
			player.x = player.x + 1.5
			player.dir = 0
		end
		if player.dir == 1 then
			player.x = player.x - 0.25
		else
			player.x = player.x + 0.25
		end
		if love.keyboard.isDown(controls[x][5]) then
			player.y = player.y - 1.5
		elseif love.keyboard.isDown(controls[x][6]) then
			player.y = player.y + 1.5
		end
		if love.keyboard.isDown(controls[x][2]) then
			if player.gun ~= 3 then
				if player.gd == 0 then
					if player.gs == false then
						trigger(player,player.gun,0)
						player.gd = bulletdb[player.gun + 1][2]
						player.gs = true
						love.audio.stop(shot)
						love.audio.play(shot)
					end
				else
					player.gd = player.gd - 1
				end
			end
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
	for i,e in ipairs(shots) do
		shoot(e)
	end
	for i,e in ipairs(spawner) do
		floater(e)
	end
	collision()
end

function collision()
	--Collision possibilities:
	---Player:
	----1. Player-Enemy.
	----2. Player-Shot.
	----3. Player-Spawner.
	----4. Player-Boss.
	----5. Player-Balloon.
	----6. Player-Coin.
	---Enemy:
	----1. Enemy-Shot. (Yep)
	---Spawner:
	----1. Spawner-Shot. (Yep)
	---Boss:
	----1. Boss-Shot.
	for i,s in ipairs(shots) do
		local hit = false
		for d,e in ipairs(enemy) do
			if (s[2] + bulletdb[s[5] + 1][5] >= e[2] and s[2] + bulletdb[s[5] + 1][5] <= e[2] + enemydb[e[4] + 1][5]) or (s[2] >= e[2] and s[2] <= e[2] + enemydb[e[4] + 1][5])then
				if (s[1] + bulletdb[s[5] + 1][4] >= e[1] and s[1] + bulletdb[s[5] + 1][4] <= e[1] + enemydb[e[4] + 1][4]) or (s[1] >= e[1] and s[1] <= e[1] + enemydb[e[4] + 1][4])then
					for f=0,6 do
						table.remove(enemy,f)
					end
					e = nil
					hit = true
				end
			end
		end
		for d,e in ipairs(spawner) do
			if (s[2] + bulletdb[s[5] + 1][5] >= e[2] and s[2] + bulletdb[s[5] + 1][5] <= e[2] + spawnerdb[stage + 1][4]) or (s[2] >= e[2] and s[2] <= e[2] + spawnerdb[stage + 1][4])then
				if (s[1] + bulletdb[s[5] + 1][4] >= e[1] and s[1] + bulletdb[s[5] + 1][4] <= e[1] + spawnerdb[stage + 1][3]) or (s[1] >= e[1] and s[1] <= e[1] + spawnerdb[stage + 1][3])then
					if e[3] > 1 then
						e[3] = e[3] - bulletdb[s[5] + 1][6]
					else
						for f=0,4 do
							table.remove(spawner,f)
						end
						e = nil
					end
					hit = true
				end
			end
		end
		if hit == true then
			for t=0,5 do
				table.remove(shots,t)
			end
			s = nil
			player.gs = false
		end
	end
end

function gamedraw()
	camx = player.x - 76
	love.graphics.translate(camx * -1,0)
	if pause == false then
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
		for i,e in ipairs(shots) do
			if e[3] == 0 then
				love.graphics.draw(bulletdb[e[5] + 1][3],e[1],e[2],0,1,1,0,0)
			else
				love.graphics.draw(bulletdb[e[5] + 1][3],e[1],e[2],0,-1,1,(enemydb[e[4] + 1] [4]),0)
			end
		end
		for i,e in ipairs(spawner) do
			love.graphics.draw(e[5],e[1],e[2],0,1,1,0,0)
		end
	else
		love.graphics.draw(bg,0,0,0,1,1,0,0)
	end
end