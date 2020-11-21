		player = {}
		require "controls"
		require "projectiles.player_bullets"

		-- statics ingame

			player.hp = 90
			player.weapons = {}
			player.weaponID = 0
			player.wtimer = 0
			player.wtimerMAX = 0

		player.load = function()

			player.type = "player"

			player.image_idle = player_image.idle
			player.image_moving = player_image.moving
			player.quad = love.graphics.newQuad(0,0,16,16,player.image_idle:getDimensions())
			
			player.x  =	_gen[1].x + _gen[1].w /2
			player.y  = _gen[1].y + _gen[1].h /2
			player.w  = 16
			player.h  = 16
			player.speed = 120
			
			bullets = {}

			player.move = false
			player.dir = "right"

			player.fps = 9.5
			player.animtimer = 1 / player.fps
			player.frame = 0
			player.framecount = 4
			player.xoffset = 0

			player.filter = function(item, other)
								if other.type == "enemy" then
									return 'cross'
								elseif other.type == "projectile" then
									return 'cross'
								elseif other.type == "weapon" then
									return "cross"
								elseif other.type == "ammo" then
									return "cross"
								else
									return "slide"
								end
							end
			
			repeat
			 if world:add(player,player.x,player.y,player.w,player.h) then
				return true
			 end
			until true
		end

		player.update = function(dt)

			local fx, fy  = player.x, player.y

			player.bullet_update(dt)

			if _G.android == false then
				fx,fy = controls.keyboard(dt,player.speed,fx,fy)
			else
				fx,fy = controls.sticks(dt,player.speed,fx,fy)
			end

		 	player.animtimer = player.animtimer - dt
			if player.animtimer <= 0 then
				player.animtimer = 1 / player.fps
				player.frame = player.frame + 1
					if player.frame == player.framecount then
					 player.frame = 1 
					end
				player.xoffset = 16 * player.frame
				player.quad:setViewport(player.xoffset,0,16,16)
			end
			
			if fx + player.w > cw then
				fx = cw - player.w
			elseif fx < 0 then 
				fx = 0
			end
			if fy + player.h > ch then 
				fy = ch - player.h
			elseif fy < 0  then
				fy = 0
			end

			pcall(function() 
				local ax,ay,cols,len = world:move(player,fx,fy,player.filter)
				player.x, player.y = ax, ay
				end )

			local mmx,mmy = cam:toWorld(push:toGame(love.mouse.getPosition()))

			if mmx >= player.x + player.w/2 then
				player.dir = "right"
			else
				player.dir = "left"
			end

			if player.hp <= 0 then
				_G.state_all = "dead"
			end

		end

		player.draw = function()

			if player.move == false then
				if player.dir == "right" then
					love.graphics.draw(player.image_idle,player.quad,player.x,player.y)
				else
					love.graphics.draw(player.image_idle,player.quad,player.x,player.y,0,-1,1,player.w)
				end
			else
				if player.dir == "right" then
					love.graphics.draw(player.image_moving,player.quad,player.x,player.y)
				else
					love.graphics.draw(player.image_moving,player.quad,player.x,player.y,0,-1,1,player.w)
				end
			end
			player.bullet_draw()
		end
