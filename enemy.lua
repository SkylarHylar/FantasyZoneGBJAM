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
end
function floater(s)
	if s[4] == 29 then
		s[4] = 0
	else
		s[4] = s[4] + 1
	end
	if s[4] == 15 then
		s[5] = spawnerdb[stage + 1][2]
	elseif s[4] == 0 then
		s[5] = spawnerdb[stage + 1][1]
	end
end