
			enemies.bullet_add = function(x,y,id)
			local fx,fy = x + 8,y + 8
			local speed = 80
			local angle = math.atan2(fy - player.y, fx - player.x)
			local dx = math.cos(angle) * speed
			local dy = math.sin(angle) * speed
			local image = love.graphics.newImage("assets/projectile/bullets.png")
			local filter =	function(item, other)
								if other.type == "enemy" then
									return 'cross'
								elseif other.type == "player" then
									return 'touch'
								elseif other.type == "projectile" then
									return 'cross'
								elseif other.type == "weapon" then
									return "cross"
								else
									return "touch"
								end
							end
			if id == 1 then
				local b = {
					type = "projectile",
					image = image,
					damage = 10,
					x = fx,
					y = fy,
					w = 8,
					h = 8,
					dx = dx,
					dy = dy,
					speed = speed,
					filter = filter,
				}
				world:add(b,b.x,b.y,b.w,b.h)
				table.insert(e_bullet,b)
			end
		end

		enemies.bullet_update = function(dt)
			for i, b in ipairs(e_bullet) do
			local fx,fy = b.x,b.y
				fx = fx - b.dx * dt
				fy = fy - b.dy * dt

			
			local ax, ay, cols, len = world:move(b,fx,fy,b.filter)
				for v=1,len do
					local other = cols[v].other
					if other.type == "player" then
						player.hp = player.hp - b.damage
						world:remove(b)
						table.remove(e_bullet,i)
					elseif other.type == nil then
						particle.add(fx,fy)
						world:remove(b)
						table.remove(e_bullet,i)
					end
				end
				b.x,b.y = ax,ay
			end
		end

		enemies.bullet_draw = function()
			for i, b in ipairs(e_bullet) do
				love.graphics.draw(b.image,b.x,b.y,b.x,1,1,b.w/2,b.h/2)
			end
		end 