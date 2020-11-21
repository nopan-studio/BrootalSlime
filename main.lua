		bump = require "libs.bump"
		push = require "libs.push"
		require  "libs.aabb"

		-------------------------
		require "assets"
		require "conf"
		require "gamestate"
		require "loading"
		require "map"	
		require "weapons"
		require "particles"
		require "ui"
		require "sfx"
		require "cc"
		require "camera"
		require "shadows"
		-------------------------
		require "entities.player"
		require "entities.enemies"

		math.randomseed(os.time())
		
		love.load = function()
			--1440,960
			cw,ch = 1440,960
			canvas = love.graphics.newCanvas(cw, ch)
			
			love.graphics.setDefaultFilter('nearest','nearest')
			sw, sh = 480, 270

			local windowWidth, windowHeight = love.window.getDesktopDimensions()
			windowWidth ,windowHeight = windowWidth *.7 , windowHeight *.7
			push:setupScreen(sw, sh, windowWidth, windowHeight, {fullscreen = false, stretched = true,canvas = canvas, pixelperfect = true})
			gamestate.load()
		end

		function love.resize(w, h)
  			return push:resize(w, h)
		end

		love.update = function(dt)	
			gamestate.update(dt)
		end

		love.draw = function()
			push:start()
				gamestate.draw()
			push:finish()
		end