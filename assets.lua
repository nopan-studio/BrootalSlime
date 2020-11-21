        assets = {}

        assets.load = function()
            -- load entities Images
            vfx = {
                shadow_image = love.graphics.newImage("assets/vfx/shadows.png")
            }
            player_image = {
                idle = love.graphics.newImage("assets/entities/player/player_idle.png"),
                moving = love.graphics.newImage("assets/entities/player/player_moving.png"),
            }

            slime_image = {
                idle = love.graphics.newImage("assets/entities/slime/slime_idle.png"),
				moving = love.graphics.newImage("assets/entities/slime/slime_moving.png"),
				dying = love.graphics.newImage("assets/entities/slime/slime_dying.png"),
            }
            -- load ui images
                ui.image = love.graphics.newImage("assets/ui/menu_ui.png")
                ui.bg = love.graphics.newImage("assets/ui/bg/bg.png")

            -- load map events, images
            door_image = {
                h = love.graphics.newImage("assets/map/doors/h_doors.png"), -- horizontal door
			    v = love.graphics.newImage("assets/map/doors/v_doors.png"), -- vertical_door		   
            }
           
            -- load weapons
            weapon_image = {
                handgun = love.graphics.newImage("assets/weapons/handgun.png"),
                shotgun = love.graphics.newImage("assets/weapons/shotgun.png"),
                smg = love.graphics.newImage("assets/weapons/smg.png"),
                portal_gun = love.graphics.newImage("assets/weapons/portal_gun.png"),
                ammo = love.graphics.newImage("assets/weapons/ammo.png"),

            }
            -- pad
            tstick = {
                tstick = love.graphics.newImage("assets/ui/stick.png")
            }
            -- pad quads
                tstick.fire = love.graphics.newQuad(60,0,30,30,tstick.tstick:getDimensions())
                tstick.l = love.graphics.newQuad(0,0,30,30,tstick.tstick:getDimensions())
                tstick.r = love.graphics.newQuad(30,30,30,30,tstick.tstick:getDimensions())
                tstick.t = love.graphics.newQuad(30,0,30,30,tstick.tstick:getDimensions())
                tstick.b = love.graphics.newQuad(0,30,30,30,tstick.tstick:getDimensions())
        end