		slime = {}

		slime.add = function(id,x,y)
			local e = {
				type = "enemy",
				name = "slime",
				room = id,

				image_idle = slime_image.idle,
				image_moving = slime_image.moving,
				image_dying = slime_image.dying,
				
				quad = love.graphics.newQuad(0,0,16,16,96,16),

				status = "idle",
				fps = 7,
				animtimer = 1 / 7,-- fps
				frame = 0,
				framecount = 6, -- change if neccesary
				xoffset = 0, 

				dist = 900,

				hp = 100,
				x = x,
				y = y-100,
				w = 16,
				h = 16,
				tx = 0,
				ty = 0,

				timer = 2,
				wander_timer = 0,

				damage = 5,
				atktimer = 2,
				speed = 40,
				fposx = x,
				fposy = y,
				grounded = false,
				hit = false,

				filter = function(item, other)
								if other.type == "enemy" then
									return 'slide'
								elseif other.type == "player" then
									return 'cross'
								elseif other.type == "projectile" then
									return 'cross'
								elseif other.type == "weapon" then
									return "cross"
								else
									return "slide"
								end
							end,
				
			}

			e.image = e.image_moving

			world:add(e,e.x,e.y,e.w,e.h)
			table.insert(enemy_count,e)
		end

		slime.update = function(i,e,dt)
			if e.name == "slime" then
					if e.grounded ~= true then
						e.quad:setViewport(16*3,0,16,16)
						e.y = e.y + 100 * dt
						if e.y > e.fposy then
							world:update(e,e.x,e.y,e.w,e.h)
							e.grounded = true
						end
					else
						local fx,fy = e.x,e.y
						local angle = math.atan2(fy - player.y, fx - player.x)
						e.dist = math.sqrt((fy - player.y)^2 + (fx - player.x)^2)
						local dx = math.cos(angle) * e.speed
						local dy = math.sin(angle) * e.speed

						fx,fy =  math.min(fx - dx * dt), math.min(fy - dy * dt)

							e.animtimer = e.animtimer - dt
							if e.animtimer <= 0 then
								e.animtimer = 1 / e.fps
								e.frame = e.frame + 1
									if e.frame == e.framecount then 
										e.frame = 1
											if e.status == "dying" then
												world:remove(e)	
												table.remove(enemy_count,i)
											end
									end
									e.xoffset = 16 *  e.frame
									e.quad:setViewport(e.xoffset,0,16,16)
							end

						if e.status == "dying" then
							e.image = e.image_dying

						elseif e.dist <= 130 then
							e.status = "moving"
							e.image = e.image_moving
						elseif e.timer <= 0 then
							e.status = "wander"
						else
							e.timer = e.timer - dt -- timer for wandering
							e.status = "idle"
							e.image = e.image_idle
						end

						if e.status == "idle" then
							pcall(function()
								local ax, ay, cols, len = world:move(e,e.x,e.y,e.filter)
								e.x,e.y = ax,ay
							end)
					
						elseif e.status == "moving" then
							pcall(function()	
								e.wander_timer = 0 
								local ax, ay, cols, len = world:move(e,fx,fy,e.filter)
								for i=1,len do
									local other = cols[i].other
									if other.type == "player" then
										e.atktimer = e.atktimer - dt
										if e.atktimer <= 0 then
											
											player.hp = player.hp - e.damage
											e.atktimer = 2
										end
									end	
								end
								e.x,e.y = ax,ay
							end)

						elseif e.status == "wander" then
							
							if e.wander_timer <= 0 then
								e.tx,e.ty = math.random(e.x - 100,e.x + 100), math.random(e.y - 100,e.y + 100)
								e.image = e.image_moving
								e.wander_timer = 4 
							else
								local fx,fy = e.x,e.y 
								local angle = math.atan2(fy - e.ty,fx - e.tx)
								local dx = math.cos(angle) * e.speed
								local dy = math.sin(angle) * e.speed

								fx = fx - dx * dt
								fy = fy - dy * dt
								if e.x <= e.tx + 2 and e.x >= e.tx or e.y <= e.ty and e.y >= e.ty then
									e.wander_timer = 0
									e.status = "idle"
									e.timer = 2
								else
									e.wander_timer = e.wander_timer - dt 
								end
								pcall(function()
									local ax, ay, cols, len = world:move(e,fx,fy,e.filter)
										for i=1,len do
											local other = cols[i].other
											if other.type == nil then
												e.wander_timer = 0
											end	
										end
									e.x,e.y = ax,ay
								end)
							end
						end


					end
			end	
		end

		slime.draw = function(i,e)
			if e.name == "slime" then
				
				if e.x < player.x then
					love.graphics.draw(e.image,e.quad,e.x,e.y)
				else
					love.graphics.draw(e.image,e.quad,e.x,e.y,0,-1,1,e.w)
				end

				if e.hit ~= false then
					love.graphics.setBlendMode("add","premultiplied")
						if e.x < player.x then
							love.graphics.draw(e.image,e.quad,e.x,e.y)
						else
							love.graphics.draw(e.image,e.quad,e.x,e.y,0,-1,1,e.w)
						end
					e.hit = false
				end

				love.graphics.setBlendMode("alpha")
			end
		end