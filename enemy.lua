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