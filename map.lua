		level = {}

		require "event"
		
		loadTilemap = function(path,tx,ty) -- function for spreading tile sheets
			local map =  require(path)
  			map.quads ={}
			map.tileset = tileset
			map.layers.x = tx
			map.layers.y = ty
  			local tileset = map.tilesets[1]
  				map.image = love.graphics.newImage("assets/map/tileset_brootal.png")
	  			for y = 0,  (tileset.imageheight / tileset.tileheight) - 1 do
	  				for x = 0,  (tileset.imagewidth/ tileset.tilewidth) - 1 do
	  					local quad = love.graphics.newQuad(
	  						x * tileset.tilewidth,
	  						y * tileset.tileheight,
	  						tileset.tilewidth,
	  						tileset.tileheight,
	  						tileset.imagewidth,
	  						tileset.imageheight
	  						)
	  					table.insert(map.quads,quad)
	  				end	
	  			end

	  			for i, layer in ipairs(map.layers) do
					for y = 0, layer.height - 1 do
						for x = 0, layer.width - 1 do
							local index	= (x + y * layer.width) + 1
							local tid = layer.data[index]

							if tid ~= 1 and tid ~= 2 and tid ~= 3 and tid ~= 26 and tid ~= 27  then

								local  quad = map.quads[tid]
								local xx = tx + x * 16
								local yy = ty + y * 16

								world:add  	( "k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											.."k"..math.random(-999,999).."k"..math.random(-999,999).."k"..math.random(-999,999)
											,xx,yy,16,16)
							
							end
						end
					end
				end
			
			map.draw = function(tx,ty) 
				for i, layer in ipairs(map.layers) do
					for y = 0, layer.height - 1 do
						for x = 0, layer.width - 1 do
							local index	= (x + y * layer.width) + 1
							local tid = layer.data[index]

							if tid ~= 0 then
								local  quad = map.quads[tid]
								local xx = tx + x * 16
								local yy = ty + y * 16
								
								if _G.debug_mode == true and tid ~= 2 and tid ~= 6 then
									love.graphics.rectangle(
									"line",
									xx,
									yy,
									16,
									16
									)
								else
									love.graphics.draw(
									map.image,
									quad,
									xx,
									yy
									)
								end
								
							end
						end
					end
				end
			end
		 	return map
		end

		-- map functions

		level.load = function()
			
			world = bump.newWorld(50)
			level.generate_load()
			enemies.add_to_map()
		end

		level.update = function(dt)
		
		end

		level.draw = function()
			love.graphics.setColor(50/255,41/255,71/255) -- BACKGROUND COLOR
			love.graphics.rectangle("fill",0,0,cw,ch)
			love.graphics.setColor(1,1,1)

			level.generate_draw()
		end

	
		level.generate_load = function()
			
			_gen = {}

			local id = {
			[1]={
				id = false,
				door = false,
				x = 0,
				y = 0,
				},

			[2]={
				id = false,
				door = false,
				x = 480,
				y = 0,
				},	

			[3]={
				id = false,
				door = false,
				x = 480*2,
				y = 0,
				},

			[4]={
				id = false,
				door = false,
				x = 0,
				y = 320,
				},

			[5]={
				id = false,
				door = false,
				x = 480,
				y = 320,
				},
			
			[6]={
				id = false,
				door = false,
				x = 480 * 2,
				y = 320,
				},

			[7]={
				id = false,
				door = false,
				x = 0,
				y = 320*2,
				},

			[8]={
				id = false,
				door = false,
				x = 480,
				y = 320*2,
				},
			
			[9]={
				id = false,
				door = false,
				x = 480 * 2,
				y = 320*2,
				},
			}

			local rooms = {
				[1] = "maps/proc_maps/1_left_top",
				[2] = "maps/proc_maps/2_top_bottom",
				[3] = "maps/proc_maps/3_top_right",
				[4] = "maps/proc_maps/4_left_right",
				[5] = "maps/proc_maps/5_left_bottom",
				[6] = "maps/proc_maps/6_bottom_right",
			}
			local s_rooms = {
				[1] = "maps/proc_maps/starting_left",
				[2] = "maps/proc_maps/starting_right",
				[3] = "maps/proc_maps/starting_bottom",
				[4] = "maps/proc_maps/starting_up",
			}
			local l_rooms = {
				[1] = "maps/proc_maps/last_left",
				[2] = "maps/proc_maps/last_right",
				[3] = "maps/proc_maps/last_bottom",
				[4] = "maps/proc_maps/last_up",
			}

			local randoms = {
				[1] = {2,4},
				[2] = {1,3,5},
				[3] = {2,6},
				[4] = {1,5,7},
				[5] = {2,4,6,8},
				[6]	= {3,5,9},
				[7] = {4,8},
				[8]	= {5,7,9},
				[9] = {6,8},
			}

			

			math.randomseed(os.time()+os.time())
			
		--	repeat 
			gen_id = math.random(1,9)
		--	until gen_id ~= 2 and gen_id ~= 4 and gen_id ~= 6 and gen_id ~= 8  
			
			local no = 1
			local last_pos = ""
				
			for i=1, 5 do
				
				local k = {
					gen_id = gen_id,
					enemies = 0,
					map = "",
					no = no,
					x = id[gen_id].x,
					y = id[gen_id].y,
					w = 480,
					h = 320,
				}

				id[gen_id].id = true
				
				for i, v in ipairs(randoms) do
					for k, j in ipairs(v) do
						if j == gen_id then
						table.remove(v,k)
						end
					end
				end
				
				repeat
					if k.no == "last" then
						nextGen = math.random(1,#randoms[gen_id])
					
					else
						repeat
							nextGen = math.random(1,#randoms[gen_id])
						until #randoms[randoms[gen_id][nextGen]] > 0-- i hope this fix the 5 limit issue kekw
					end
					
					if k.no == 1 then
							if randoms[gen_id][nextGen] == gen_id - 3 then -- assume top
								k.map = loadTilemap(s_rooms[4],k.x,k.y)
								last_pos = "top"
							elseif randoms[gen_id][nextGen] == gen_id - 1 then -- assume left
								k.map = loadTilemap(s_rooms[1],k.x,k.y)
								last_pos = "left"
							elseif randoms[gen_id][nextGen] == gen_id + 1 then  -- assume right
								k.map = loadTilemap(s_rooms[2],k.x,k.y)
								last_pos = "right"
							elseif randoms[gen_id][nextGen] == gen_id + 3 then -- assume bottom
								k.map = loadTilemap(s_rooms[3],k.x,k.y)
								last_pos = "bottom"
							end
					
					else

						if k.no == "last" then
							if last_pos == "bottom" then -- assume top
								k.map = loadTilemap(l_rooms[4],k.x,k.y)
									event.stairs(k.x + 16 * 13,k.y + k.h - 16*2,16 * 4 ,16)
								last_pos = "top"
							elseif last_pos == "right" then -- assume left
								k.map = loadTilemap(l_rooms[1],k.x,k.y)
									event.stairs(k.x + k.w - 16 * 2,k.y + 16 * 8,16 ,16 * 4)									
								last_pos = "left"
							elseif last_pos == "left" then  -- assume right
								k.map = loadTilemap(l_rooms[2],k.x,k.y)
									event.stairs(k.x + 16 ,k.y + 16 * 8,16 ,16 * 4)
								last_pos = "right"
							elseif last_pos == "top" then -- assume bottom
								k.map = loadTilemap(l_rooms[3],k.x,k.y)
									event.stairs(k.x + 16 * 13,k.y+16,16 * 4 ,16)
								last_pos = "bottom"
							end

						elseif randoms[gen_id][nextGen] == gen_id - 3 and last_pos == "right" then -- assume right top
							k.map = loadTilemap(rooms[1],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y,16*4,16*2)
									last_pos = "top"
						elseif randoms[gen_id][nextGen] == gen_id + 1 and last_pos == "right" then -- assume right straight
							k.map = loadTilemap(rooms[4],k.x,k.y)
								event.door(k.no,"vertical",k.x + k.w - 16 ,k.y + 16*7,16*2,16*5)
									last_pos = "right"
						elseif randoms[gen_id][nextGen] == gen_id - 1 and last_pos == "right" then -- assume right straight
							k.map = loadTilemap(rooms[4],k.x,k.y)
								event.door(k.no,"vertical",k.x,k.y + 16*7,16*2,16*5)
									last_pos = "left"
						elseif randoms[gen_id][nextGen] == gen_id + 3 and last_pos == "right" then -- assume right bottom
							k.map = loadTilemap(rooms[5],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y + k.h - 16,16*4,16*2)
									last_pos = "bottom"

						elseif randoms[gen_id][nextGen] == gen_id - 3 and last_pos == "left" then -- assume left top
							k.map = loadTilemap(rooms[3],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y,16*4,16*2)
									last_pos = "top"
						elseif randoms[gen_id][nextGen] == gen_id + 1 and last_pos == "left" then -- assume left straight
							k.map = loadTilemap(rooms[4],k.x,k.y)
								event.door(k.no,"vertical",k.x + k.w - 16 ,k.y + 16*7,16*2,16*5)
									last_pos = "right"
						elseif randoms[gen_id][nextGen] == gen_id - 1 and last_pos == "left" then -- assume left straight
							k.map = loadTilemap(rooms[4],k.x,k.y)
								event.door(k.no,"vertical",k.x,k.y + 16*7,16*2,16*5)
									last_pos = "left"
						elseif randoms[gen_id][nextGen] == gen_id + 3 and last_pos == "left" then -- assume left bottom
							k.map = loadTilemap(rooms[6],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y + k.h - 16,16*4,16*2)
									last_pos = "bottom"
						
						elseif randoms[gen_id][nextGen] == gen_id - 3 and last_pos == "bottom" then -- assume bottom top -- almost useless
							k.map = loadTilemap(rooms[2],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y,16*4,16*2)
									last_pos = "top"
						elseif randoms[gen_id][nextGen] == gen_id + 1 and last_pos == "bottom" then -- assume bottom right
							k.map = loadTilemap(rooms[3],k.x,k.y)
								event.door(k.no,"vertical",k.x + k.w - 16 ,k.y + 16*7,16*2,16*5)
									last_pos = "right"
						elseif randoms[gen_id][nextGen] == gen_id - 1 and last_pos == "bottom" then -- assume bottom left
							k.map = loadTilemap(rooms[1],k.x,k.y)
								event.door(k.no,"vertical",k.x,k.y + 16*7,16*2,16*5)
									last_pos = "left"
						elseif randoms[gen_id][nextGen] == gen_id + 3 and last_pos == "bottom" then -- assume bottom bottom
							k.map = loadTilemap(rooms[2],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y + k.h - 16,16*4,16*2)
									last_pos = "bottom"

						elseif randoms[gen_id][nextGen] == gen_id - 3 and last_pos == "top" then -- assume top top -- almost useless
							k.map = loadTilemap(rooms[2],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y,16*4,16*2)
									last_pos = "top"
						elseif randoms[gen_id][nextGen] == gen_id + 1 and last_pos == "top" then -- assume top right
							k.map = loadTilemap(rooms[6],k.x,k.y)
								event.door(k.no,"vertical",k.x + k.w - 16 ,k.y + 16*7,16*2,16*5)
									last_pos = "right"
						elseif randoms[gen_id][nextGen] == gen_id - 1 and last_pos == "top" then -- assume top left
							k.map = loadTilemap(rooms[5],k.x,k.y)
								event.door(k.no,"vertical",k.x,k.y + 16*7,16*2,16*5)
									last_pos = "left"
						elseif randoms[gen_id][nextGen] == gen_id + 3 and last_pos == "top" then -- assume top bottom
							k.map = loadTilemap(rooms[2],k.x,k.y)
								event.door(k.no,"horizontal",k.x + 16*13,k.y + k.h - 16,16*4,16*2)
									last_pos = "bottom"
						else
							-- HEY HEY 
						end
					end

				until k.map ~= ""

				
				
				table.insert(_gen,k)

				if pcall(function() if no * 2 == no * 2 then return true end end ) then -- wtf is this spaghetti
					no = no +  1
				end

				if no == 5 then
					no = "last"
				end
				
				
				last_gen_id = gen_id
				gen_id = randoms[gen_id][nextGen]

			end
		
		end
		
		level.generate_draw = function()
		
			if #_gen == 5 then
				for i,k in ipairs(_gen) do
					--love.graphics.rectangle("line",k.x,k.y,k.w,k.h)
					k.map.draw(k.x,k.y)
					love.graphics.print(k.no,k.x,k.y)
				end
			end
		
		end