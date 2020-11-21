		controls = {}

		love.mousepressed = function(x,y,button)
			if _G.state_all == "playing" then
				local x,y = cam:toWorld(push:toGame(love.mouse.getPosition()))
				if button == 2 then
				--	world:update(player,
				--	_gen[#_gen].x +  _gen[#_gen].w /2 ,
				--	_gen[#_gen].y +  _gen[#_gen].h / 2
				--	)
					slime.add(1,x,y)
					weapons.add(4,x,y)
				elseif button == 3 then
					weapons.add_ammo(x,y)
				end
			end
		end

		controls.load = function()
			controls.stick_load()
		end
		--keyboard controls
		controls.keyboard = function (dt,speed,fx,fy)

			local lmd = love.mouse.isDown
			if lmd(1) then
				local x,y =cam:toWorld(push:toGame(love.mouse.getPosition()))
				player.wtimer = player.wtimer - dt
				
				if player.weaponID ~= 0 and player.wtimer <= 0 and player.weapons[1].ammo ~= 0 then
					player.weapons[1].ammo = player.weapons[1].ammo - 1
					player.bullet_add(x,y,player.weaponID)
					player.wtimer = player.wtimerMAX
				end

			elseif lmd(2) then
				
			end

			lkd = love.keyboard.isDown
			if lkd("w","a","s","d") then
				player.move = true
				if lkd("w") then
					fy = fy - math.floor( speed * dt)
				end
				if lkd("s") then
					fy = fy + math.floor( speed * dt)
				end
				if lkd("a") then
					fx = fx - math.floor( speed * dt)
				end
				if lkd("d") then
					fx = fx + math.floor( speed * dt)
				end
			else
				player.move = false
			end

			return fx,fy
		end

		controls.stick_load = function()

		-- MOBILE
			stick = {
				defx = 70,
				defy = sh / 1.7 + 30,
				x = 70,
				y = sh / 1.7 + 30,
				w = 30,
				h = 30,
			}

			stick_l = {
				x = 70 - 30,
				y = sh/1.7 + 30,
			}

			stick_r = {
				x = 70 + 30,
				y = sh/1.7 + 30,
			}

			stick_tr = {
				x = 70 + 30,
				y = sh/1.7,
			}

			stick_tl = {
				x = 70 - 30,
				y = sh/1.7,
			}

			stick_t = {
				x = 70,
				y = sh/1.7,
			}

			stick_bl = {
				x = 70 - 30,
				y = sh/1.7 + 60,
			}

			stick_br = {
				x = 70 + 30,
				y = sh/1.7 + 60,
			}

			stick_b = {
				x = 70,
				y = sh/1.7+60,
			}

			stick_fire = {
				x = sw /1.3,
				y = sh/1.7 ,
			}

			touch_no = nil
			-- lights
			stick_fire.light = false
			stick_l.light = false
			stick_r.light = false
			stick_t.light = false
			stick_b.light = false
		end

		controls.sticks = function(dt,speed,fx,fy)

			local touches = love.touch.getTouches()
			
			if #touches == 0 or #touches == nil then
				touch_no = nil
				player.move = false
				stick_fire.light = false
				stick_l.light = false
				stick_r.light = false
				stick_t.light = false
				stick_b.light = false
			end

			for i,id in ipairs(touches) do

				local x,y = push:toGame(love.touch.getPosition(id))				
					
					if AABB(x,y,1,1,stick_fire.x,stick_fire.y,60,60) and e_targetX ~= 0 and e_targetY ~= 0 then -- fire button
						
						stick_fire.light = true
						local x,y = e_targetX,e_targetY
						player.wtimer = player.wtimer - dt
						
						if player.weaponID ~= 0 and player.wtimer <= 0 and player.weapons[1].ammo ~= 0 then
							player.weapons[1].ammo = player.weapons[1].ammo - 1
							player.bullet_add(x,y,player.weaponID)
							player.wtimer = player.wtimerMAX
						end
					else
						stick_fire.light = false
					end

					if id == touch_no or touch_no == nil then
						if AABB(x,y,1,1,stick.defx-30,stick.defy-30,90,90)then
							player.move = true
							if touch_no == nil then
								touch_no = id
							end
						else
							touch_no = nil
							player.move = false
							stick_l.light = false
							stick_r.light = false
							stick_t.light = false
							stick_b.light = false
						end

						if 	AABB(x,y,1,1,stick_l.x,stick_l.y,stick.w,stick.h) then  -- LEFT
							fx = fx - math.floor( speed * dt)
							player.dir = "left"
							stick_l.light = true
							stick_r.light = false
							stick_t.light = false
							stick_b.light = false
				
						elseif  AABB(x,y,1,1,stick_r.x,stick_r.y,stick.w,stick.h) then  -- RIGHT
							fx = fx + math.floor( speed * dt)
							player.dir = "right"
							stick_r.light = true
							stick_l.light = false
							stick_t.light = false
							stick_b.light = false

						elseif  AABB(x,y,1,1,stick_t.x,stick_t.y,stick.w,stick.h) then  -- TOP
							fy = fy - math.floor( speed * dt)
							stick_t.light = true
							stick_r.light = false
							stick_l.light = false
							stick_b.light = false

						elseif  AABB(x,y,1,1,stick_b.x,stick_b.y,stick.w,stick.h) then  -- BOTTOM
							fy = fy + math.floor( speed * dt)
							stick_b.light = true
							stick_r.light = false
							stick_t.light = false
							stick_l.light = false

						elseif  AABB(x,y,1,1,stick_tr.x,stick_tr.y,stick.w,stick.h) then  -- TOP RIGHT
							fy = fy - math.floor( speed * dt)
							fx = fx + math.floor( speed * dt)
							player.dir = "right"
							stick_t.light = true
							stick_r.light = true
							stick_l.light = false
							stick_b.light = false

						elseif  AABB(x,y,1,1,stick_tl.x,stick_tl.y,stick.w,stick.h) then  -- TOP LEFT
							fy = fy - math.floor( speed * dt)
							fx = fx - math.floor( speed * dt)
							player.dir = "left"
							stick_t.light = true
							stick_l.light = true
							stick_b.light = false
							stick_r.light = false

						elseif  AABB(x,y,1,1,stick_bl.x,stick_bl.y,stick.w,stick.h) then  -- BOTTOM LEFT
							fy = fy + math.floor( speed * dt)
							fx = fx - math.floor( speed * dt)
							player.dir = "left"
							stick_b.light = true
							stick_l.light = true
							stick_t.light = false
							stick_r.light = false

						elseif  AABB(x,y,1,1,stick_br.x,stick_br.y,stick.w,stick.h) then  -- BOTTOM RIGHT
							fy = fy + math.floor( speed * dt)
							fx = fx + math.floor( speed * dt)
							player.dir = "rights"
							stick_b.light = true
							stick_r.light = true
							stick_t.light = false
							stick_l.light = false
						end
					end
				
			end
			
			return fx,fy
		end

		controls.sticks_draw = function()

			if stick_l.light == true then
				love.graphics.setBlendMode("add","premultiplied")
				love.graphics.draw(tstick.tstick,tstick.l,stick_l.x,stick_l.y)
			end
				love.graphics.draw(tstick.tstick,tstick.l,stick_l.x,stick_l.y)
				love.graphics.setBlendMode("alpha")
			
			if stick_r.light == true then
				love.graphics.setBlendMode("add","premultiplied")
				love.graphics.draw(tstick.tstick,tstick.r,stick_r.x,stick_r.y)
			end
				love.graphics.draw(tstick.tstick,tstick.r,stick_r.x,stick_r.y)
				love.graphics.setBlendMode("alpha")

			if stick_t.light == true then
				love.graphics.setBlendMode("add","premultiplied")
				love.graphics.draw(tstick.tstick,tstick.t,stick_t.x,stick_t.y)
			end
				love.graphics.draw(tstick.tstick,tstick.t,stick_t.x,stick_t.y)
				love.graphics.setBlendMode("alpha")

			if stick_b.light == true then
				love.graphics.setBlendMode("add","premultiplied")
				love.graphics.draw(tstick.tstick,tstick.b,stick_b.x,stick_b.y)
			end
				love.graphics.draw(tstick.tstick,tstick.b,stick_b.x,stick_b.y)
				love.graphics.setBlendMode("alpha")

			if stick_fire.light == true then
				love.graphics.setBlendMode("add","premultiplied")
				love.graphics.draw(tstick.tstick,tstick.fire,stick_fire.x,stick_fire.y,0,2,2)
			end
				love.graphics.draw(tstick.tstick,tstick.fire,stick_fire.x,stick_fire.y,0,2,2)
				love.graphics.setBlendMode("alpha")
		end


