		sfx = {}
		sounds = {}

		sfx.load = function()
			bgm = love.sound.newSoundData("sfx/bg.wav")
			gunshot = love.sound.newSoundData("sfx/weapons/gunshot.wav")
		end

		sfx.add = function(audio,pitch) 
			local s = love.audio.newSource(audio, "static")
			if pitch ~= nil then
			s:setPitch(pitch)
			end
			s:play()
			table.insert(sfx,s)
		end

		sfx.update = function(dt)
			for i, s in ipairs(sounds) do
				if s:isStopped() then
					table.remove(sounds,i)
				end
			end
		end