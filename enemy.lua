function ai(e,id)
	if id == 0 then
		if e[1] >= player.x + 50 then
			e[3] = 1
		elseif e[1] <= player.x - 50 then
			e[3] = 0
		end
		if e[3] == 0 then
			e[1] = e[1] + 1.5
		else
			e[1] = e[1] - 1.5
		end
	end
	if e[5] == 14 then
		e[5] = 0
	else
		e[5] = e[5] + 1
	end
	local trueframe = math.floor(e[5] / 5)
	e[6] = enemydb[e[4] + 1] [trueframe + 1]
end
function floater(i,s)
	if s[4] == 59 then
		s[4] = 0
		if s[6] <= 0 then
			createenemy(s[1] + 8,s[2] + 18,0,i)
			s[6] = 1
			print('SPAWN')
		end
	else
		s[4] = s[4] + 1
	end
	if s[4] == 30 then
		s[5] = spawnerdb[stage + 1][2]
	elseif s[4] == 0 then
		s[5] = spawnerdb[stage + 1][1]
	end
end