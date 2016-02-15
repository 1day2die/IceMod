AddCSLuaFile( "autorun/client/cl_playertitle.lua" )
include("sqldata.lua")

function fetchtitle(ply)

	result = executequery("SELECT title FROM titles WHERE steamid = '" .. ply:SteamID() .. "'")
	
	if (result == nil) then
		// Do nothing!
	else
		local num_rows = 0
		
		for k, v in pairs(result) do
			num_rows = num_rows + 1
		end
		
		if (num_rows == 1) then // Check if user exists
			
			// If they do,  set the NWString to their title
			// SQLite stores tables with names, mySQL stores them with numbers. As such we need to check which one to use.
			if (result[1][1] == nil) then
				ply:SetNWString("title", result[1]['title']) // Use SQLite method
			else
				ply:SetNWString("title", result[1][1]) // Use MySQL method
			end
		else
			// Do nothing
		end
	end

end
hook.Add("PlayerInitialSpawn", "fetchtitle", fetchtitle)