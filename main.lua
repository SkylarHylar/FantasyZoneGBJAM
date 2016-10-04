love.graphics.setDefaultFilter("nearest","nearest")

require('menu')
require('game')

function love.load()
	min_dt = 1/60
	next_time = love.timer.getTime()
	
	thefont = love.graphics.newFont('/Sprites/Basics/hachicro.ttf', 8)
	love.graphics.setFont(thefont)
	
	controltype = "keyboard"
	controls = {}
	controls = {
	A =      'l',
	B =      'k',
	Start =  'h',
	Select = 'g',
	Up =     'w',
	Down =   's',
	Left =   'a',
	Right =  'd',
	}
	defcontrols = {}
	defcontrols = {
	A =      'l',
	B =      'k',
	Start =  'h',
	Select = 'g',
	Up =     'w',
	Down =   's',
	Left =   'a',
	Right =  'd',
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
	else
		menuupdate()
	end
end

function love.keypressed(key,scancode,isrepeat)
	if mode == 0 then
		if key == controls.Up then
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
						sx = 2
					else
						sx = sx - 1
					end
				end
			end
		elseif key == controls.Down then
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
					if sx == 2 then
						sx = 0
					else
						sx = sx + 1
					end
				end
			end
		elseif key == controls.A then
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
					if sx == 0 then
						sz = 1
					elseif sx == 1 then
						sz = 2
					elseif sx == 2 then
						sz = 3
					elseif sx == 3 then
						sz = 4
					end
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
						if slives == 3 then
							slives = 5
						elseif slives == 5 then
							slives = 7
						else
							slives = 3
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
						if layout == 0 then
							layout = 1
						else
							layout = 0
						end
					elseif sx == 2 then
						sz = 5
						sx = 4
						if layout == 0 then
							controls.Up = 'w'
							controls.Down = 's'
							controls.Left = 'a'
							controls.Right = 'd'
							controls.A = 'l'
							controls.B = 'k'
							controls.Start =  'h'
							controls.Select = 'g'
							if keytype == 1 then
								controls.Up = 'z'
								controls.Left = 'q'
							elseif keytype == 2 then
								controls.Up = ','
								controls.Down = 'o'
								controls.Left = 'a'
								controls.Right = 'e'
								controls.A = 's'
								controls.B = 'n'
								controls.Select = 'd'
							end
						elseif layout == 1 then
							controls.Up = 'up'
							controls.Down = 'down'
							controls.Left = 'left'
							controls.Right = 'right'
							controls.A = 'x'
							controls.B = 'z'
							controls.Start =  'return'
							controls.Select = 'rshift'
							if keytype == 1 then
								controls.B = 'w'
							elseif keytype == 2 then
								controls.A = 'q'
								controls.B = ';'
							end
						end
					end
				elseif sz == 5 then
					sz = 0
					sx = 0
				end
			end
		elseif key == controls.B then
			if sy == 1 then
				if sz == 0 then
					sy = 0
					if stage == nil then
						sx = 1
					else
						sx = 0
					end
				elseif sz ~= 4 or 5 then
					sz = 0
					sx = 0
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