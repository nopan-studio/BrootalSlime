    camera = {}
    local gamera = require 'libs.gamera'
     camera.load = function()
        cam = gamera.new(0,0,cw,9999)
		cam:setWindow(0,0,sw,sh)
		cam:setScale(2)
     end

     camera.update = function(dt)
        if _G.android == false then
            local x,y = cam:toWorld(push:toGame(love.mouse.getPosition()))
            local cx,cy = (x + player.x) /2, (y + player.y) /2

            if cx > player.x + 30 then
                cx = player.x + 30
            elseif cx < player.x - 30 then
                cx = player.x - 30
            end

            if cy > player.y + 30 then
                cy = player.y + 30

            elseif cy < player.y - 30 then
                cy = player.y - 30
            end
            camera.x = math.floor(cx)
            camera.y = math.floor(cy)
            cam:setPosition(camera.x , camera.y)
        else
            if e_targetX ~= 0 and e_targetY ~= 0 then
                local x = e_targetX
                local y = e_targetY

                local cx,cy = (x + player.x) /2, (y + player.y) /2

                camera.x = math.floor(cx)
                camera.y = math.floor(cy)
                
                cam:setPosition(camera.x , camera.y)
            else
                cam:setPosition(player.x , player.y)
            end
        end
    end