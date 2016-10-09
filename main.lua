love.graphics.setDefaultFilter("nearest","nearest")

require('menu')
require('game')
require('enemy')
require('shop')

function love.load()
	min_dt = 1/60
	next_time = love.timer.getTime()
	
	thefont = love.graphics.newFont('/Sprites/Basics/hachicro.ttf', 8)
	love.graphics.setFont(thefont)
	
	controltype = "keyboard"
	controls = {}
--  x = control row	
--	A =      controls[x][1],
--	B =      controls[x][2],
--	Start =  controls[x][3],
--	Select = controls[x][4],
--	Up =     controls[x][5],
--	Down =   controls[x][6],
--	Left =   controls[x][7],
--	Right =  controls[x][8],
	controls = {
		{'l','k','h','g','w','s','a','d',},
		{'x','z','return','space','up','down','left','right',},
	}

	
	mode = 0
	menuload()
	
	dtotal = 0   -- this keeps track of how much time has passed
	scwidth,scale = love.window.getDesktopDimensions()
	scale = 3
	love.graphics.setScissor(0,0,480,432)
end

function modeswitch(m)
	if m == 1 then
		mode = 1
		gameload()
	elseif m == 2 then
		mode = 2
		shopload()
	elseif m == 3 then
		mode = 3
		selectload()
	elseif m == 4 then
		mode = 4
		transload()
	else
		mode = 0
		menuload()
	end
end

function love.update(dt)
	next_time = next_time + min_dt
	dtotal = dtotal + dt
	if mode == 1 then
		gameupdate()
	elseif mode == 2 then
		shopupdate()
	elseif mode == 3 then
		selectupdate()
	elseif mode == 4 then
		gameupdate()
	else
		menuupdate()
	end
end

function love.keypressed(key,scancode,isrepeat)
	for x=1,2 do
		if mode == 0 then
			if key == controls[x][5] then
				if sy == 0 then
					if stage == nil then
						if sx == 1 then
							sx = 3
						else
							sx = sx - 1
						end
					else
						if sx == 0 then
							sx = 3
						else
							sx = sx - 1
						end
					end
				elseif sy == 1 then
					if sz == 0 then
						if sx == 0 then
							sx = 3
						else
							sx = sx - 1
						end
					elseif sz == 1 then
						if sx == 0 then
							sx = 4
						else
							sx = sx - 1
						end
					elseif sz == 2 then
						if sx == 0 then
							sx = 1
						else
							sx = 0
						end
					elseif sz == 3 then
						if sx == 0 then
							sx = 1
						else
							sx = 0
						end
					elseif sz == 4 then
						if sx == 0 then
							sx = 1
						else
							sx = 0
						end
					end
				end
			elseif key == controls[x][6] then
				if sy == 0 then
					if stage == nil then
						if sx == 3 then
							sx = 1
						else
							sx = sx + 1
						end
					else
						if sx == 3 then
							sx = 0
						else
							sx = sx + 1
						end
					end
				elseif sy == 1 then
					if sz == 0 then
						if sx == 3 then
							sx = 0
						else
							sx = sx + 1
						end
					elseif sz == 1 then
						if sx == 4 then
							sx = 0
						else
							sx = sx + 1
						end
					elseif sz == 2 then
						if sx == 1 then
							sx = 0
						else
							sx = 1
						end
					elseif sz == 3 then
						if sx == 1 then
							sx = 0
						else
							sx = 1
						end
					elseif sz == 4 then
						if sx == 1 then
							sx = 0
						else
							sx = 1
						end
					end
				end
			elseif key == controls[x][1] then
				if sy == 0 then
					if sx == 2 then
						sy = 1
						sx = 0
					elseif sx == 3 then
						love.event.quit()
					elseif sx == 0 then
						modeswitch(1)
					else
						stage = 0 
						modeswitch(1)
					end
				elseif sy == 1 then
					if sz == 0 then
						sz = sx + 1
						sx = 0
					elseif sz == 1 then
						if sx == 0 then
							scale = 2
							love.window.setMode(320,288)
							love.graphics.setScissor(0,0,320,288)
						elseif sx == 1 then
							scale = 3
							love.window.setMode(480,432)
							love.graphics.setScissor(0,0,480,432)
						elseif sx == 2 then
							scale = 5
							love.window.setMode(800,720)
							love.graphics.setScissor(0,0,800,720)
						elseif sx == 3 then
							scale = 7
							love.window.setMode(1120,1008)
							love.graphics.setScissor(0,0,1120,1008)
						elseif sx == 4 then
							scwidth,scale = love.window.getDesktopDimensions()
							scale = scale / 144
							love.window.setMode(scale * 160,scale * 144)
							love.window.setFullscreen(true)
							love.graphics.setScissor(((scwidth - (scale*160)) / 2),0,scale*160,scale * 144)
						end
						if love.window.getFullscreen() == true then
							if sx ~= 4 then
								love.window.setFullscreen(false)
							end
						end
					elseif sz == 2 then
						if sx == 0 then
							if smusic == true then
								smusic = false
							else
								smusic = true
							end
						elseif sx == 1 then
							if ssound == true then
								ssound = false
							else
								ssound = true
							end
						end
					elseif sz == 3 then
						if sx == 0 then
							if slives == 2 then
								slives = 4
							elseif slives == 4 then
								slives = 6
							else
								slives = 2
							end
						elseif sx == 1 then
							if sprice == 1 then
								sprice = 2
							elseif sprice == 2 then
								sprice = 0.5
							else
								sprice = 1
							end
						end
					elseif sz == 4 then
						if sx == 0 then
							if keytype == 0 then
								keytype = 1
							elseif keytype == 1 then
								keytype = 2
							else
								keytype = 0
							end
						elseif sx == 1 then
							sz = 5
							sx = 4
							if keytype == 0 then
								controls[1][5] = 'w'
								controls[1][6] = 's'
								controls[1][7] = 'a'
								controls[1][8] = 'd'
								controls[1][1] = 'l'
								controls[1][2] = 'k'
								controls[1][4] = 'g'
								controls[2][1] = 'x'
								controls[2][2] = 'z'
							elseif keytype == 1 then
								controls[1][5] = 'z'
								controls[1][7] = 'q'
								controls[2][2] = 'w'
							elseif keytype == 2 then
								controls[1][5] = ','
								controls[1][6] = 'o'
								controls[1][7] = 'a'
								controls[1][8] = 'e'
								controls[1][1] = 's'
								controls[1][2] = 'n'
								controls[1][4] = 'd'
								controls[2][1] = 'q'
								controls[2][2] = ';'
							end
						end
					elseif sz == 5 then
						sz = 6
						sx = 4
					elseif sz == 6 then
						sz = 0
						sx = 0
					end
				end
			elseif key == controls[x][2] then
				if sy == 1 then
					if sz == 0 then
						sy = 0
						if stage == nil then
							sx = 1
						else
							sx = 0
						end
					elseif sz ~= 6 and sz ~= 5 then
						sz = 0
						sx = 0
					end
				end
			end
		elseif mode == 1 then
			if key == controls[x][3] then
				if pause == false then
					pause = true
					love.audio.pause(music)
				else
					pause = false
					love.audio.resume(musicstart)
					love.audio.resume(music)
				end
			end
			if pause == true then
				if key == controls[x][5] then
					if tx == 0 then
						tx = 2
					else
						tx = tx - 1
					end
				elseif key == controls[x][6] then
					if tx == 2 then
						tx = 0
					else
						tx = tx + 1
					end
				end
				if key == controls[x][1] then
					if tx == 1 then
						modeswitch(3)
					elseif tx == 2 then
						stage = nil
						modeswitch(0)
					else
						modeswitch(2)
					end
				end
			end
		end
	end
end
function love.draw()
	love.graphics.clear()
	if love.window.getFullscreen() == true then
		love.graphics.translate((scwidth - (scale*160)) / 2, 0)
	end
	love.graphics.push()
		love.graphics.scale(scale)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill',0,0,160,144)
		if mode == 1 then
			gamedraw()
		elseif mode == 2 then
			shopdraw()
		elseif mode == 3 then
			selectdraw()
		elseif mode == 4 then
			transdraw()
		else
			menudraw()
		end
	love.graphics.pop()
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end