weapons = {}
		weapons.load = function()
			weapons_inGround = {}
		end
		weapons.add = function(id,x,y,isPlayer)
			-------------------------- kekw
			weapons[1]={
						id = 1,
			 			type = "weapon",		 	
			 			name = "handgun",
			 			image = weapon_image.handgun,
			 			quad =  love.graphics.newQuad(0,0,16,16,16,16),

			 			life = 5,

			 			timer = .5,
			 			timerMAX = .5,
			 			ammo =  32,
			 			
			 			fps = 60,
						animtimer = 1 / 10,-- fps
						frame = 0,
						framecount = 4, -- change if neccesary
						xoffset = 0, 

			 			x = x,
			 			y = y,
			 			w = 8,
			 			h = 8,

			 			filter = function(item,other) return 'cross' end
			 			}	

			weapons[2]={
						id = 2,
						type = "weapon",		 	
			 			name = "shotgun",
			 			image = weapon_image.shotgun,
			 			quad = love.graphics.newQuad(0,0,32,16,32,16),

			 			life = 5,

			 			timer = .8,
			 			timerMAX = .8,
			 			ammo =  20,

			 			fps = 60,
						animtimer = 1 / 10,-- fps
						frame = 0,
						framecount = 4, -- change if neccesary
						xoffset = 0, 

			 			x = x,
			 			y = y,
			 			w = 8,
			 			h = 8,

			 			filter = function(item,other) return 'cross' end
						}

			weapons[3]={
						id = 3,
						type = "weapon",		 	
			 			name = "smg",
						image = weapon_image.smg,
			 			quad = love.graphics.newQuad(0,0,16,16,16,16),

			 			life = 5,

			 			timer = .1,
			 			timerMAX = .1,
			 			ammo = 120,

			 			fps = 60,
						animtimer = 1 / 10,-- fps
						frame = 0,
						framecount = 4, -- change if neccesary
						xoffset = 0, 

			 			x = x,
			 			y = y,
			 			w = 8,
			 			h = 8,

			 			filter = function(item,other) return 'cross' end
						}

			weapons[4]={
						id = 4,
						type = "weapon",		 	
			 			name = "portal_gun",
						image = weapon_image.portal_gun,
			 			quad = love.graphics.newQuad(0,0,16,16,16,16),

			 			life = 5,

			 			timer = .05,
			 			timerMAX = .05,
			 			ammo = 500,

			 			fps = 60,
						animtimer = 1 / 10,-- fps
						frame = 0,
						framecount = 4, -- change if neccesary
						xoffset = 0, 

			 			x = x,
			 			y = y,
			 			w = 8,
			 			h = 8,

			 			filter = function(item,other) return 'cross' end
						}

			---------------------------- kekw
			if isPlayer ~= true then
				world:add(weapons[id],weapons[id].x,weapons[id].y,weapons[id].w,weapons[id].h)
				table.insert(weapons_inGround,weapons[id])
			else
				table.insert(player.weapons,weapons[id])
			end
		end

		weapons.update = function(dt)
			for i,w in ipairs(weapons_inGround) do
				local ax,ay,cols,len = world:move(w,w.x,w.y,w.filter)
				world:move(w,ax,ay)
				w.life = w.life - dt 
				if w.life <= 0 then
					world:remove(w)
					table.remove(weapons_inGround,i)
				end

				for v=1,len do
					local other = cols[v].other
				
					if other.type == nil then
						if pcall(function() world:remove(w) end) then
						table.remove(weapons_inGround,i)
						w.life = nil
						end

					elseif other.type == "player" and w.life ~= nil then
							if w.id == "ammo" and player.weaponID ~= 0  or w.id == player.weaponID then
								other.weapons[1].ammo = other.weapons[1].ammo + w.ammo
								pcall(function() world:remove(w) end)
								table.remove(weapons_inGround,i)
							elseif w.id == "ammo"  and player.weaponID == 0 then
								return 'slide'
							else
								table.remove(player.weapons,1)
								other.weaponID = w.id
								weapons.add(player.weaponID,player.x + 4,player.y + 4,true)
								other.wtimer = w.timer
								other.wtimerMAX = w.timerMAX
								pcall(function() world:remove(w) end)
								table.remove(weapons_inGround,i)
						end
					end	

				end			
			end

			for i,w in ipairs(player.weapons) do
				w.x = player.x + player.w / 2
				w.y = player.y + player.h / 2
			end  
		end

		weapons.draw = function()

			for i,w in ipairs(weapons_inGround) do
				love.graphics.setColor(1,1,1,w.life*100/255)
				if w.type == "ammo" then
					love.graphics.draw(w.image,w.quad,w.x,w.y)
				else
					love.graphics.draw(w.image,w.quad,w.x,w.y,0,1,1,w.w/2,w.h)
				end
				love.graphics.setColor(1,1,1,1)
			end

			for i,w in ipairs(player.weapons) do

				local mmx,mmy = cam:toWorld(push:toGame(love.mouse.getPosition()))
				local angle = math.atan2(w.y - mmy,w.x - mmx)
				local ox,oy = 8,8
				
				if player.dir == "right" then
					love.graphics.draw(w.image,w.quad,w.x,w.y,angle,-1,-1,ox,oy)
				else
					love.graphics.draw(w.image,w.quad,w.x,w.y,angle,-1,1,w.w,oy)
				end
			
			end  
		end

		weapons.add_ammo = function(x,y)
		local image = weapon_image.ammo
		local quad = love.graphics.newQuad(0,0,16,16,16,16)

		local ammo = {
			life = 5,
			type = "ammo",
			id = "ammo",
			image = image,
			quad = quad,
			x = x,
			y = y,
			w = 16,
			h = 16,
			ammo = math.random(5,20),
		}	
			ammo.filter = function(item,other)
							if other.type == "enemy" then
								return "cross"
							else
								return "slide"
							end
						end
			world:add(ammo,ammo.x,ammo.y,ammo.w,ammo.h)
			table.insert(weapons_inGround,ammo)
		end