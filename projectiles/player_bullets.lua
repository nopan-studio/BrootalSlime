
	player.bullet_add = function(x,y,id)

		local image = love.graphics.newImage("assets/projectile/bullets.png")
		local laser = love.graphics.newImage("assets/projectile/laser.png")
		local sx,sy = player.x + 8,player.y + 8
		local gx,gy = x,y
		local speed = 150
		local angle = math.atan2(sy - gy,sx - gx)
		local dx,dy = math.cos(angle) * speed, math.sin(angle) * speed
		local filter =	function(item, other)
								if other.type == "enemy" then
									return 'touch'
								elseif other.type == "player" then
									return 'cross'
								elseif other.type == "projectile" then
									return 'cross'
								elseif other.type == "weapon" then
									return "cross"
								else
									return "touch"
								end
							end
		local w,h = 8,8
		
		if id == 0 then
			return false
		elseif id == 1 then
			local b = {
				type = "projectile",
				image = image,
				damage = 10,
				bulletLife = 2,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)
			sfx.add(gunshot)

		elseif id == 2 then
			local b = {
				type = "projectile",
				image = image,
				damage = 10,
				bulletLife = .5,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)
			sfx.add(gunshot)

			local angle = math.atan2(sy - gy,sx - gx) - .07
			local dx,dy = math.cos(angle) * speed, math.sin(angle) * speed
			local b = {
				type = "projectile",
				image = image,
				damage = 10,
				bulletLife = .5,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)
			
			local angle = math.atan2(sy - gy,sx - gx) + .07
			local dx,dy = math.cos(angle) * speed, math.sin(angle) * speed
			local b = {
				type = "projectile",
				image = image,
				damage = 10,
				bulletLife = .5,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)

		elseif id == 3 then
			local b = {
				type = "projectile",
				image = image,
				damage = 5,
				bulletLife = 1,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)
			sfx.add(gunshot)

		elseif id == 4 then
			local b = {
				type = "projectile",
				image = laser,
				damage = 5,
				bulletLife = 1.2,
				angle = angle,
				x = sx,
				y = sy,
				w = w,
				h = h,
				dx = dx,
				dy = dy,
				speed = speed,
				filter = filter,
			}
			world:add(b,b.x,b.y,b.w,b.h)
			table.insert(bullets,b)
			sfx.add(gunshot,2)
		end

	end

	player.bullet_update = function(dt)
		for i, b in ipairs(bullets) do
			b.bulletLife = b.bulletLife - dt
			if b.bulletLife >= 0 then
				local fx,fy = b.x,b.y
				fx = fx - b.dx * dt
				fy = fy - b.dy * dt

				pcall(function() 
					local ax, ay, cols, len = world:check(b,fx,fy,b.filter)
					for v=1,len do
						local other = cols[v].other
						if other.type == "enemy" then
							other.hp = other.hp - b.damage
							other.hit = true
							other.x = other.x - b.dx * dt
							other.y = other.y - b.dy * dt
							world:remove(b)
							table.remove(bullets,i)
						elseif other.type == nil or other.type == "ammo" then
							particle.add(fx,fy)
							world:remove(b)
							table.remove(bullets,i)
						end
					end
					b.x,b.y = ax,ay
				end)

			else
				pcall(function() 
				world:remove(b)
				table.remove(bullets,i)
				end)
			end
		end
	end

	player.bullet_draw = function()
		for i, b in ipairs(bullets) do
			love.graphics.draw(b.image,b.x,b.y,b.angle,1,1,b.w/2,b.h/2)
		end
	end