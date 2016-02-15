-- Comments by Lt.Smith will be marked as such.

function playerTitleGet(ply)
	local mytitle = ply:GetNetworkedString("title")
	if mytitle == "" then
		return nil
	else if mytitle == "remove" then
		return nil
	else
		return mytitle
	end
end

end

function playerTitleSet(ply, targettitle)
		
	if string.len(targettitle) > 40 then
		return { false, "too_long" } -- I wish Lua had tuples. Or at least lists. I don't wanna send a full on table D-:
	end

	ply:SetNetworkedString("title", targettitle)

	-- Lt.Smith : Store title in database of user's choice
	local result = executequery("SELECT * FROM titles WHERE steamid = '" .. ply:SteamID() .. "'")
	local num_rows = 0
	
	-- Lt.Smith : Check if the result is nil, if not, check the number of rows. MySQL returns data even if it returns no rows.
	if not (result == nil) then
		for k, v in pairs(result) do
			num_rows = num_rows + 1
		end
	end
	
	if (num_rows == 0) then -- Lt.Smith : Check if user exists
		-- Lt.Smith : if they don't, make a new record
		result = executequery("INSERT INTO titles (steamid, title) VALUES('" .. ply:SteamID() .. "', '" .. targettitle .. "')")
		return { true, "new_entry" }
	else
		-- Lt.Smith : If they do,  update the DB
		result = executequery("UPDATE titles SET title = '" .. targettitle .. "' WHERE steamid = '" .. ply:SteamID() .. "'")
		return { true, "existing_entry" }
	end
end
