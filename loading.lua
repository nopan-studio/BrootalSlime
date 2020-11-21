        loading = {}

        loading.load = function() -- kekw useless for some reason
            loading.timer = 2
        end

        loading.start = function(t_state) --target state, duration of the loading
            loading.nextstate = t_state
            _G.state_load = loading.nextstate
            _G.state_all = "loading"
            loading.Isloading = true
        end

        loading.update = function(dt)
            if loading.Isloading == true then
                loading.timer = loading.timer - dt
                if loading.timer < 0 then
                    _G.state_all = _G.state_load
                    loading.Isloading = false
                end
            end
        end

        loading.draw = function()
            love.graphics.draw(ui.bg,0,0)
            love.graphics.print(_G.state_all,sw/2,sh/2.1)
          --  love.graphics.print(math.floor(loading.timer),sw/2,sh/2)
            
        end