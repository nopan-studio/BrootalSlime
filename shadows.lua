        shadows = {}

        shadows.draw = function()
            for i, e in ipairs(enemy_count) do 
                love.graphics.draw(vfx.shadow_image,e.x,e.y + e.w/3)
            end
        end