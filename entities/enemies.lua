		enemies = {}
		enemy_count ={}

		require "projectiles.enemies_projectile"
		require "entities.enemies.slime"

		enemies.load = function()
			e_id = 1
			e_targetX,e_targetY = 0,0
			e_bullet = {}
			enemy_count ={}
		end

		enemies.update = function(dt)

			enemies.bullet_update(dt)
		
			for i, e in ipairs(enemy_count) do
				slime.update(i,e,dt)
				if e.hp <= 0 then
					if e.status ~= "dying" then
						e.status = "dying"
						e.frame = 0
					pcall(function() _gen[e.room].enemies = _gen[e.room].enemies - 1 end)
					end
				end
			end	

		end

		enemies.draw = function()
			enemies.bullet_draw()
			for i, e in ipairs(enemy_count) do
				slime.draw(i,e)
			end	
		end

		enemies.ai_wander = function(e,dt)
			if e.wander_timer <= 0 then
				e.tx,e.ty = math.random(e.x - 50,e.x + 50), math.random(e.y - 50,e.y + 50)
				e.wander_timer = 4 
			else
				local fx,fy = e.x,e.y 
				local angle = math.atan2(fy - e.ty,fx - e.tx)
				local dx = math.cos(angle) * e.speed
				local dy = math.sin(angle) * e.speed
				fx = fx - dx * dt
				fy = fy - dy * dt
				e.wander_timer = e.wander_timer - dt 
				return fx, fy
			end
		end

		enemies.check_closest = function()
		
			for i=1,#enemy_count do
				if enemy_count[i].dist < 90  then
					pcall(function()
						if enemy_count[e_id].dist > enemy_count[i].dist then
							e_id = i
							ptx,pty =  push:toReal(cam:toScreen(enemy_count[i].x + enemy_count[i].w / 2 , enemy_count[i].y +  enemy_count[i].h / 2 ))
							e_targetX = enemy_count[i].x + enemy_count[i].w / 2 
							e_targetY = enemy_count[i].y +  enemy_count[i].h / 2 
						end
					end)
				else
					if i == e_id then
						ptx,pty =  0,0
						e_targetX = player.x + player.w / 2
						e_targetY = player.y + player.h / 2
					
					end
				end
			end
		
		end

		enemies.add_to_map = function() -- adds enemies to map
			for i,e in ipairs(_gen) do
				if e.no ~= 1 then
					for k=1, 6 do
						local x = math.random(e.x + 16*7,e.x+e.w - 16*7)
						local y = math.random(e.y + 16*7,e.y+e.h - 16*7)
						slime.add(e.no,x,y)
						e.enemies = e.enemies + 1
					end
				else
					weapons.add(4,math.random(e.x + 16*7,e.x+e.w - 16*7),math.random(e.y + 16*7,e.y+e.h - 16*7))
				end
			end
		end