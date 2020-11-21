		particle = {}
		particle_count = {} 

		particle.add = function(x,y)
			local mmx,mmy = push:toGame(love.mouse.getPosition())
			local angle = math.atan2(mmy - player.y + 8,mmx - player.x + 8)
			local p = {
				pSystem = love.graphics.newParticleSystem(love.graphics.newImage("assets/particles/particle.png"), 5),
				}
				p.pSystem:setParticleLifetime(1,1)
				p.pSystem:setLinearAcceleration(-4, -4, 50, 50)
			 	p.pSystem:setSpeed(-40)
				p.pSystem:setSpin(10, 100)
				p.pSystem:setRotation(10,20)
				p.pSystem:setDirection(angle)
				p.px = x
				p.py = y
				p.limit = 1
			table.insert(particle_count,p)
		end

		particle.update = function(dt)
			for i, p in ipairs(particle_count) do
				p.pSystem:emit(10)
				p.pSystem:update(dt)
				p.limit = p.limit - dt
				if p.limit < 0 then
					table.remove(particle_count,i)
				end
			end
		
		end 

		particle.draw = function()
			for k,p in ipairs(particle_count) do
				love.graphics.draw(p.pSystem,p.px + 8,p.py + 8)
			end
		end