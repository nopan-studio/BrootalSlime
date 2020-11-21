        event = {}
        
        event_stairs_floor_score = 1
        event_doors = {}

        event.load = function()
            event.stairs_exist = false
            
            events = {}
        end
      
        event.check = function(dt)

            for i, e in ipairs(events) do
                if e.name == "stairs" then
                    if player.x < e.x + e.w and
                        e.x < player.x + player.w and 
                            player.y < e.y + e.h and
                                e.y < player.y + player.h then

                                    event_stairs_floor_score = event_stairs_floor_score + 1
                                    loading.start("playing")
                                    gamestate.load()

                    end
                    
                elseif e.name == "door" then
                    if e.cols_add == false then
                        world:add(e,e.x,e.y,e.w,e.h)
                        e.cols_add = true
                    end

                    if _gen[e.id].enemies == 0 then
                       e.locked = false
                    end

                    if e.locked == false then     
                            e.animtimer = e.animtimer - dt
                            if e.animtimer <= 0 then
                                e.animtimer = 1 / e.fps
                                e.frame = e.frame + 1
                                if e.frame == e.framecount then
                                    pcall(function() world:remove(e) end)
                                    e.open = true
                                    e.frame = 5
                                    e.locked = true
                                end
                                e.xoffset = e.w * e.frame
                                e.quad:setViewport(e.xoffset,0,e.w,e.h)
                            end 
                    end         
                end
            end
        end

        event.stairs = function(x,y,w,h)
            if event.stairs_exist == false then
                local stairs = {
                    name = "stairs",
                    x = x,
                    y = y,
                    w = w,
                    h = h,
                }
                table.insert(events,stairs)
                event.stairs_exist = true 
             end
        end

        event.door = function(id,orient,x,y,w,h)
          

            local door = {
                name = "door",
                cols_add = false,
                locked = true,
                id = id,
                orient = orient,
                x = x,
                y = y,
                w = w,
                h = h,
                fps = 10,
                animtimer = 1 / 10,
                frame = 0,
                framecount = 6,
                xoffset = 0,
            }
            if orient == "horizontal" then
                door.image = door_image.h
                door.quad = love.graphics.newQuad(0,0,64,32,door_image.h:getDimensions())
            else
                door.image = door_image.v
                door.quad = love.graphics.newQuad(0,0,32,80,door_image.v:getDimensions())
            end
            table.insert(events,door)
        end

        event.draw = function()
            for i,e in ipairs(events) do
                if e.name == "stairs" then
                    -- blank
                elseif e.name == "door" then
                    love.graphics.draw(e.image,e.quad,e.x,e.y)
                end
            end
        end