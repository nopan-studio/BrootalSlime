 cc = {}

	 cc.clean_residues = function(dt)
		-- reset player etc.
		player.hp = 90
		player.weapons = {}
		player.weaponID = 0
		-- reset floor score
		event_stairs_floor_score = 1
		 -- CLEAN PLAYER BULLETS
		pcall( function()
 		for i, k in ipairs(bullets) do
 			if pcall(function() world:remove(k) end) then
 				table.remove(bullets,i)
 			end
 		end
 		-- CLEAN ENEMY BULLETS
 		for i, k in ipairs(e_bullet) do
 			if pcall(function() world:remove(k) end) then
 				table.remove(e_bullet,i)
 			end
 		end
 		-- CLEAN ENEMIES
 		for i, k in ipairs(enemy_count) do
 			if pcall(function() world:remove(k) end) then
 				table.remove(enemy_count,i)
 			end
 		end
 		-- CLEAN WEAPONS IN GROUND
 		for i, k in ipairs(weapons_inGround) do
 			if pcall(function() world:remove(k) end) then
 				table.remove(weapons_inGround,i)
 			end
		 end
		end)
 	end