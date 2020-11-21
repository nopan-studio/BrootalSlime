		ui = {}
		
		ui.pointer_ = function()
			love.mouse.setVisible( false )
			_G.mx,_G.my = push:toGame(love.mouse.getPosition())

			ptx,pty = 0,0
			enemies.check_closest() 
			
			love.graphics.draw(ui.image,ui.pointer,_G.mx,_G.my,0,1,1,4,4)
			if ptx ~= 0 and pty ~=0	then
				love.graphics.draw(ui.image,ui.pointer,ptx,pty,0,1,1,4,4)
			end
			
		end

		ui.font = function()
			local font = love.graphics.newImageFont( 'assets/ui/fonts/ihna_font.png', "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#.!?:   ")
			love.graphics.setFont(font,8)
			font:setFilter('nearest','nearest')
		end

		ui.load = function()
	

			btn_clicked = false

			ui.font()
			ui.bs_logo = love.graphics.newQuad(32*5,32,32*2,32*2,ui.image:getDimensions())
			ui.pointer = love.graphics.newQuad(32*4-16,16,16,16,ui.image:getDimensions())
			-- playing loads
			ui.hphud = love.graphics.newQuad(32*4,0,32*3,16,ui.image:getDimensions())
			ui.hpbar = love.graphics.newQuad(32*7,0,1,16,ui.image:getDimensions())
			ui.hpsign = love.graphics.newQuad(32*4,16,32,16,ui.image:getDimensions())
			ui.weapondock = love.graphics.newQuad(32*5,16,16,16,ui.image:getDimensions())
			ui.bt_pausebtn = love.graphics.newQuad(32*3,0,16,16,ui.image:getDimensions())
			--btns loads
			ui.bt_start =love.graphics.newQuad(0,0,32*3,32,ui.image:getDimensions())
			ui.bt_exit = love.graphics.newQuad(0,32*2,32*3,32,ui.image:getDimensions())
			ui.bt_respawn = love.graphics.newQuad(0,32*3,32*3,32,ui.image:getDimensions())
			ui.bt_quit = love.graphics.newQuad(0,32,32*3,32,ui.image:getDimensions())
			ui.bt_config = love.graphics.newQuad(0,32*4,32*3,32,ui.image:getDimensions())
			ui.bt_pause = love.graphics.newQuad(0,32*5,32*3,32,ui.image:getDimensions())
		
			local gap = 40

			ui.bt_func = function(bb)
							if bb.state == "exit" then
								love.event.quit()
							end	

							if bb.load == true then
								loading.start(bb.state)
							else
								_G.state_load = bb.state
								_G.state_all = bb.state
							end

							if bb.name ~= "resume" then
								gamestate.load()
							end
						end
			-- playing buttons insert
			ui.bt_playing = {
				{	
					name = "pause",
					state = "pause",
					image = ui.bt_pausebtn,
					load = false,
					x = 10,
					y = 10,
					w = 16,
					h = 16,
				},
			}

			-- menu buttons insert
			ui.bt_menu = {
					{	
						name = "play",
						state = "playing",
						image = ui.bt_start,
						load = true,
						x = sw/2.5,
						y = sh/2,
						w = 32 * 3,
						h = 32,
					},
					{	
						name = "config",
						state = "menu",
						image = ui.bt_config,
						load = false,
						x = sw/2.5,
						y = sh/2 + gap,
						w = 32 * 3,
						h = 32
					},
					{	
						name = "exit",
						state = "exit",
						image = ui.bt_exit,
						load = false,
						x = sw/2.5,
						y = sh/2 + gap + gap,
						w = 32 * 3,
						h = 32
					},
				}
			-- pause buttons insert 
			ui.bt_pause = {
				{	
					name = "resume",
					state = "playing",
					image = ui.bt_pause,
					load = false,
					x = sw/2.5,
					y = sh/2 ,
					w = 32 * 3,
					h = 32
				},
				{	
					name = "quit",
					state = "menu",
					image = ui.bt_quit,
					load = true,
					x = sw/2.5,
					y = sh/2 + gap,
					w = 32 * 3,
					h = 32
				},
			}
			-- dead buttons insert
			ui.bt_dead = {
					{	
						name = "retry",
						state = "playing",
						image = ui.bt_respawn,
						load = true,
						x = sw/2.5,
						y = sh/2.5,
						w = 32 * 3,
						h = 32
					},
					{	
						name = "quit",
						state = "menu",
						image = ui.bt_quit,
						load = true,
						x = sw/2.5,
						y = sh/2.5 + gap,
						w = 32 * 3,
						h = 32
					},
				}
		end

		ui.update = function(dt) -- ui update
			
		end

		ui.draw_menu = function() -- btn draw and shits MENU
			local lmd = love.mouse.isDown
				love.graphics.draw(ui.bg,0,0)
				love.graphics.draw(ui.image,ui.bs_logo,sw/2.74,sh/18,0,2,1.8)-- button

				for v, bb in ipairs(ui.bt_menu) do
					love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
					if _G.mx < bb.x + bb.w and
						bb.x < _G.mx + 1 and 
						_G.my < bb.y + bb.h and
							bb.y < _G.my + 1 then

								love.graphics.setBlendMode("add","premultiplied")
								love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
								love.graphics.setBlendMode("alpha")	
								if lmd(1) then
									pcall(function() ui.bt_func(bb) end)
								end
					end
				end
		end
		
		ui.draw_pause = function() -- btn draw and shits dead
			local lmd = love.mouse.isDown
				for v, bb in ipairs(ui.bt_pause) do
					love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
					if _G.mx < bb.x + bb.w and
						bb.x < _G.mx + 1 and 
						_G.my < bb.y + bb.h and
							bb.y < _G.my + 1 then

							love.graphics.setBlendMode("add","premultiplied")
							love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
							love.graphics.setBlendMode("alpha")	
							if lmd(1) then
								pcall(function() ui.bt_func(bb) end)
							end
								
					end
				end
		end

		ui.draw_dead = function() -- btn draw and shits dead
			local lmd = love.mouse.isDown
				for v, bb in ipairs(ui.bt_dead) do
					love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
					if _G.mx < bb.x + bb.w and
						bb.x < _G.mx + 1 and 
						_G.my < bb.y + bb.h and
							bb.y < _G.my + 1 then

							love.graphics.setBlendMode("add","premultiplied")
							love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
							love.graphics.setBlendMode("alpha")	
							if lmd(1) then
								pcall(function() ui.bt_func(bb) end)
							end
					end
				end
		end


		ui.draw_playing = function()

			if _G.android == true then
				controls.sticks_draw()
			end

			local lmd = love.mouse.isDown
				for i, bb in ipairs(ui.bt_playing) do
					love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
					if _G.mx < bb.x + bb.w and
							bb.x < _G.mx + 1 and 
							_G.my < bb.y + bb.h and
								bb.y < _G.my + 1 then

								love.graphics.setBlendMode("add","premultiplied")
								love.graphics.draw(ui.image,bb.image,bb.x,bb.y)-- button
								love.graphics.setBlendMode("alpha")	
								if lmd(1) then
									pcall(function() ui.bt_func(bb) end)
								end
					end
				end
			
			--draw hp bar
			love.graphics.draw(ui.image,ui.hphud,sw/2.5,sh/1.100) -- HPHUD 
			love.graphics.draw(ui.image,ui.hpbar,sw/2 - 45,sh/1.100,0,player.hp,1) -- HP BAR
			love.graphics.draw(ui.image,ui.hpsign,sw/2.6,sh/1.120) -- HP BAR

			love.graphics.draw(ui.image,ui.weapondock,sw/2.2,sh/1.200) -- weapon dock
			if player.weapons ~= nil then 
				for i,w in ipairs(player.weapons) do
					love.graphics.draw(w.image,w.quad,sw/2.2,sh/1.200)
					love.graphics.print(w.ammo,sw/2.1,sh/1.200)
				end	
			end

			love.graphics.print("Floor :"..event_stairs_floor_score,sw/4,sh/1.150)
		--	love.graphics.print("Level :"..mapLevel,sw/4,sh/1.110)

	end