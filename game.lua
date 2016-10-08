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
	player.engine= 0
	player.speed = (player.engine * 1.5) + 1.5
	player.timer = 0
	player.coast = true
	pause        = false
	score        = 0
	money        = 0
	--player.timer is the amount of time a bought weapon lasts.
	death = false
	dtimer = 0
	boss = false
	
	shot = love.audio.newSource('/Sounds/shoot.wav', 'static')
	
	enemy = {}
	--e[1] = x
	--e[2] = y
	--e[3] = direction
	--e[4] = id
	--e[5] = frame
	--e[6] = image
	--e[7] = creator
	enemydb = {}
	spawner = {}
	--p[1] = x
	--p[2] = y
	--p[3] = hp
	--p[4] = frame
	--p[5] = image
	--p[6] = enemies
	spawnerdb = {}
	shots = {}
	--s[1] = x
	--s[2] = y
	--s[3] = dir
	--s[4] = angle
	--s[5] = id
	--s[6] = speed
	--s[7] = distance traveled
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
		{3,10,'4',6,8,4},
		{3,10,'5',8,8,1},
		{3,10,'6',8,8,32},
		{3,10,'7',8,8,32},
	}
	for x=0,4 do
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
	----Lives: $2500, ? (+7500, +15000).
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
			{0,30,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{80,100,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{160,50,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{240,16,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{320,80,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{400,120,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{480,30,spawnerdb[1][5],0,spawnerdb[1][1],0,},
			{560,40,spawnerdb[1][5],0,spawnerdb[1][1],0,},
		}
	end
	booms = {}
	boom = love.graphics.newImage('/Sprites/Character/Boom.png')
		
	bg = love.graphics.newImage('/Sprites/Levels/'..stage..'.png')
end

function createenemy(x,y,id,sp)
	local e = {}
	e = {x,y,0,0,0,nil,sp,}
	e[6] = enemydb[e[4] + 1] [e[5] + 1]
	table.insert(enemy,e)
end

function kill()
	if death == false and dtimer < dtotal then
		dtimer = dtotal
		death = true
		for c=0,15 do
			local b = {}
			b = {player.x + 2,player.y + 1,c}
			table.insert(booms,b)
		end
	else	
		if dtimer >= dtotal - 3 then
			for i,b in ipairs(booms) do
				if b[3] == 0 then
					b[2] = b[2] - 4
				elseif b[3] == 1 then
					b[1] = b[1] + 1
					b[2] = b[2] - 3
				elseif b[3] == 2 then
					b[1] = b[1] + 2
					b[2] = b[2] - 2
				elseif b[3] == 3 then
					b[1] = b[1] + 3
					b[2] = b[2] - 1
				elseif b[3] == 4 then
					b[1] = b[1] + 4
				elseif b[3] == 5 then
					b[1] = b[1] + 3
					b[2] = b[2] + 1
				elseif b[3] == 6 then
					b[1] = b[1] + 2
					b[2] = b[2] + 2
				elseif b[3] == 7 then
					b[1] = b[1] + 1
					b[2] = b[2] + 3
				elseif b[3] == 8 then
					b[2] = b[2] + 4
				elseif b[3] == 9 then
					b[1] = b[1] - 1
					b[2] = b[2] + 3
				elseif b[3] == 10 then
					b[1] = b[1] - 2
					b[2] = b[2] + 2
				elseif b[3] == 11 then
					b[1] = b[1] - 3
					b[2] = b[2] + 1
				elseif b[3] == 12 then
					b[1] = b[1] - 4
				elseif b[3] == 13 then
					b[1] = b[1] - 3
					b[2] = b[2] - 1
				elseif b[3] == 14 then
					b[1] = b[1] - 2
					b[2] = b[2] - 2
				elseif b[3] == 15 then
					b[1] = b[1] - 1
					b[2] = b[2] - 3
				end
			end
		else
			death = false
			for i,b in ipairs(booms) do
				table.remove(booms,i)
			end
		end
	end	
end

function trigger(ent,id,angle)
	if ent == player then
		if id ~= 3 then
			s = {}
			s = {player.x + (player.dir * -10),player.y,player.dir,0,id,0,0,}
			table.insert(shots,s)
			if id == 4 then
				if player.coast == false then
					s[6] = 1.75
				else
					s[6] = 0.5
				end
				s[1] = s[1] + 5
			end
		end
	else
		
	end
end

function shoot(ent,k)
	if ent[5] == 0 then
		if ent[3] == 0 then
			ent[1] = ent[1] + bulletdb[ent[5] + 1][1]
			ent[7] = ent[7] + bulletdb[ent[5] + 1][1]
		else
			ent[1] = ent[1] - bulletdb[ent[5] + 1][1]
			ent[7] = ent[7] + bulletdb[ent[5] + 1][1]
		end
	elseif ent[5] == 4 then
		ent[1] = ent[1] + ((ent[6] * 1.5) - (((ent[6] * 1.5) * ent[3]) * 3))
		if ent[2] >= 140 then
			table.remove(shots,k)
			player.bs = false
		else
			ent[2] = ent[2] + 1.5
		end
	end
	if (ent[1] <= player.x - 84 or ent[1] >= player.x + 84) and ent[7] >= 200 then
		if ent[5] <= 3 then
			table.remove(shots,k)
			player.gs = false
		end
	end
end

function gameupdate()
	if pause == false and death == false then
		player.coast = true
		for x=1,2 do
			if love.keyboard.isDown(controls[x][7]) then
				player.x = player.x - player.speed
				player.dir = 1
				player.coast = false
			elseif love.keyboard.isDown(controls[x][8]) then
				player.x = player.x + player.speed
				player.dir = 0
				player.coast = false
			end
			if player.dir == 1 then
				player.x = player.x - 0.25
			else
				player.x = player.x + 0.25
			end
			if love.keyboard.isDown(controls[x][5]) then
				if player.y > 1 then
					player.y = player.y - player.speed
				else
					player.y = 0
				end
			elseif love.keyboard.isDown(controls[x][6]) then
				if player.y < 135 then
					player.y = player.y + player.speed
				else
					player.y = 136
				end
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
			if love.keyboard.isDown(controls[x][1]) then
				if player.bd == 0 then
					if player.bs == false then
						trigger(player,player.bomb,0)
						player.bd = bulletdb[player.bomb + 1][2]
						player.bs = true
					end
				else
					player.bd = player.bd - 1
				end
			end
		end
		xchecker(player,player)
		for i,e in ipairs(enemy) do
			ai(e,e[4])
			xchecker(e,enemy)
		end
		for i,e in ipairs(shots) do
			shoot(e,i)
			xchecker(e,shots)
		end
		for i,e in ipairs(spawner) do
			floater(i,e)
		end
		collision()
		bossswitch()
		
	elseif death == true then
		kill()
	end
end

function xchecker(ent,typ)
	local xc = 0
	if typ == player then
		xc = player.x
	else
		xc = ent[1]
	end
	if xc > 640 then
		xc = xc - 640
	elseif xc < 0 then
		xc = xc + 640
	end
	if ent == player then
		player.x = xc
	else
		ent[1] = xc
		if typ == enemy then
			--if ent[1] <= camx - 8 or 0 then
			
			--end
		end
	end
end


function collision()
	--Collision possibilities:
	---Player:
	----1. Player-Enemy.
	----2. Player-Spawner.
	----3. Player-Boss.
	----4. Player-Coin.
	---Enemy:
	----1. Enemy-Shot. (Yep)
	---Spawner:
	----1. Spawner-Shot. (Yep)
	---Boss:
	----1. Boss-Shot.
	--=====BULLET COLLISION=====--
	for i,s in ipairs(shots) do
		local hit = false
		for d,e in ipairs(enemy) do
			if (s[2] + bulletdb[s[5] + 1][5] >= e[2] and s[2] + bulletdb[s[5] + 1][5] <= e[2] + enemydb[e[4] + 1][5]) or (s[2] >= e[2] and s[2] <= e[2] + enemydb[e[4] + 1][5])then
				if (s[1] + bulletdb[s[5] + 1][4] >= e[1] and s[1] + bulletdb[s[5] + 1][4] <= e[1] + enemydb[e[4] + 1][4]) or (s[1] >= e[1] and s[1] <= e[1] + enemydb[e[4] + 1][4])then
					for q,p in ipairs(spawner) do
						if e[7] == q then
							p[6] = 0
						end
						print(e[7])
					end
					table.remove(enemy,d)
					hit = true
				end
			end
		end
		for d,e in ipairs(spawner) do
			if (s[2] + bulletdb[s[5] + 1][5] >= e[2] and s[2] + bulletdb[s[5] + 1][5] <= e[2] + spawnerdb[stage + 1][4]) or (s[2] >= e[2] and s[2] <= e[2] + spawnerdb[stage + 1][4])then
				if (s[1] + bulletdb[s[5] + 1][4] >= e[1] and s[1] + bulletdb[s[5] + 1][4] <= e[1] + spawnerdb[stage + 1][3]) or (s[1] >= e[1] and s[1] <= e[1] + spawnerdb[stage + 1][3])then
					e[3] = e[3] - bulletdb[s[5] + 1][6]
					print(e[3])
					if e[3] <= 0 then
						table.remove(spawner,d)
					end
					hit = true
				end
			end
		end
		if hit == true then
			if s[5] >= 4 then
				player.bs = false
			else
				player.gs = false
			end
			table.remove(shots,i)
		end
	end
	--=====PLAYER COLLISION=====--
	local hit = false
	--for d,e in ipairs(enemy) do
		--if (player.y + player.ybound >= e[2] and player.y + player.ybound <= e[2] + enemydb[e[4] + 1][4]) or (player.y >= e[2] and player.y <= e[2] + enemydb[e[4] + 1][4])then
			--if (player.x + player.xbound >= e[1] and player.x + player.xbound <= e[1] + enemydb[e[4] + 1][3]) or (player.x >= e[1]and player.x <= e[1] + enemydb[e[4] + 1][3])then
				--table.remove(enemy,d)
				--hit = true
			--end
		--end
	--end
	--for d,e in ipairs(spawner) do
		--if (player.y + player.ybound >= e[2] and player.y + player.ybound <= e[2] + spawnerdb[stage + 1][4]) or (player.y >= e[2] and player.y <= e[2] + spawnerdb[stage + 1][4])then
			--if (player.x + player.xbound >= e[1] and player.x + player.xbound <= e[1] + spawnerdb[stage + 1][3]) or (player.x >= e[1] and player.x <= e[1] + spawnerdb[stage + 1][3])then
				--table.remove(spawner,d)
				--hit = true
			--end
		--end
	--end
	if hit == true then
		death = true
	end
end

function bossswitch()
	local count = 0
	for d,e in ipairs(spawner) do
		count = count + 1
	end
	if count == 0 then
		boss = true
	end
end

function gamedraw()
	camx = player.x - 76
	if pause == false then	
		love.graphics.translate((camx * -1) - 640,0)
		bgdraw(0)
		bgdraw(-640)
		bgdraw(-1280)
		truedraw()
		love.graphics.translate(640,0)
		truedraw()
		if player.dir == 0 then
			love.graphics.draw(player.img,player.x,player.y,0,1,1,0,0)
		else
			love.graphics.draw(player.img,player.x,player.y,0,-1,1,10,0)
		end
		if boss == true then
			print('BOSS TIME!')
		end
		love.graphics.translate(640,0)
		truedraw()
	elseif pause == true or death == true then
		bgdraw(camx)
		for i,e in ipairs(booms) do
			love.graphics.draw(boom,e[1],e[2],0,1,1,0,0)
			print('banana')
		end
	end
end

function bgdraw(offx)
	love.graphics.draw(bg,0,0,0,1,1,offx,0)
end

function truedraw()
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
			love.graphics.draw(bulletdb[e[5] + 1][3],e[1],e[2],0,-1,1,(bulletdb[e[4] + 1] [4]),0)
		end
	end
	for i,e in ipairs(spawner) do
		love.graphics.draw(e[5],e[1],e[2],0,1,1,0,0)
	end
end