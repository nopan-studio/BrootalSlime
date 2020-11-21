		gamestate = {}

		_G.state_load = "playing" 	-- dead , menu, paused, loading
        _G.state_all = "menu"

		gamestate.load = function()
			-- GLOBAL LOADS
			assets.load()
			ui.load()
			sfx.load()
			camera.load()
			loading.load()
			
			if _G.state_all == "playing" or _G.state_load == "playing"  then	
				event.load()
				weapons.load()
				enemies.load()
				level.load()
				player.load()
				controls.stick_load()
				
			end
			
		end

		gamestate.update = function(dt)
			ui.update(dt)
			sfx.update(dt)
				if _G.state_all == "playing" then
					player.update(dt)
					level.update(dt)
					event.check(dt)
					particle.update(dt)
					weapons.update(dt)
					enemies.update(dt)
					ui.update(dt)
					camera.update(dt)
				elseif _G.state_all == "dead" then
					cc.clean_residues(dt)
				elseif _G.state_all == "menu" then
					cc.clean_residues(dt)
				elseif _G.state_all == "loading" then
					
					loading.update(dt)
					
				end
		end

		gamestate.draw = function()
			ui.pointer_()
				if _G.state_all == "playing" or _G.state_all == "pause"then
					
					cam:draw(function(l,t,w,h)
						
						level:draw()
						shadows.draw()
						event.draw()
						enemies.draw()
						player.draw()
						particle:draw()
						weapons.draw()
						gamestate.debug_mode_entities()
					end)

					if  _G.state_all == "pause" then
						ui.draw_pause()
					else
						ui.draw_playing()
					end
					gamestate.debug_mode_text()

				elseif _G.state_all == "dead" then
					ui.draw_dead()
				elseif _G.state_all == "menu" then
					ui.draw_menu()
				elseif _G.state_all == "loading" then
					loading.draw()
				end
			ui.pointer_()
		end

		gamestate.debug_mode_text = function()
			if _G.debug_mode == true then
				-- print important kinks
				local x,y = cam:toWorld(player.x,player.y)
				love.graphics.print("x pos:"..x,10,10)
				love.graphics.print("y pos:"..y,10,20)

				love.graphics.print("ptx pos:"..ptx,10,30)
				love.graphics.print("pty pos:"..pty,10,35)

				love.graphics.print("Enemy Count:"..#enemy_count,10,40)
				love.graphics.print("Weapon inGround:"..#weapons_inGround,10,60)
				love.graphics.print("Weapons player:"..#player.weapons,10,80)
				love.graphics.print("Weapon ID:"..player.weaponID,10,90)
				love.graphics.print("Events Count"..#events,10,100)
			end
		end

		gamestate.debug_mode_entities = function()
			if _G.debug_mode == true then
				--bump cols draw
				--draw events
				
				--playerdraw
				love.graphics.rectangle("line",player.x,player.y,player.w,player.h)
				--enemy draw
				for i,e in ipairs(enemy_count) do
				love.graphics.rectangle("line",e.x,e.y,e.w,e.h)
				end
				--draw weapons in ground
				for i,e in ipairs(weapons_inGround) do
				love.graphics.rectangle("line",e.x,e.y,e.w,e.h)
				end
				for i,e in ipairs(player.weapons) do
				love.graphics.rectangle("line",e.x,e.y,e.w,e.h)
				end
				--draw bullets
				for i,e in ipairs(bullets) do
				love.graphics.rectangle("line",e.x,e.y,e.w,e.h)
				end
				--draw eventss
				for i,e in ipairs(events) do
					if e.name == "stairs" then
						love.graphics.setColor(0,1,0)
						love.graphics.rectangle("fill",e.x,e.y,e.w,e.h)
						love.graphics.setColor(1,1,1)
						love.graphics.print("EVENT NAME:"..e.name,e.x,e.y)
					elseif e.name == "door" then
						love.graphics.print("EVENT NAME:"..e.name,e.x,e.y)
						love.graphics.print("id:"..e.id,e.x,e.y + 10)
					end
				end

			end

		end