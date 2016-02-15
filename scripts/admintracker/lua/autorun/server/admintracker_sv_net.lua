//AdminTracker by Pyro. Serverside net file.
//If you did not purchase this addon from www.coderhire.com, please contact me. My steam profile: http://steamcommunity.com/profiles/76561198015899774/
//Do not change anything in this file unless you know what you're doing.

net.Receive( "AT_UpdateTrackedGroups", function()
	local TRACKEDGROUPS = string.Explode( "::", ( file.Read( "AT_groups.txt" ) ) )
	local TRACKEDPLAYERS = string.Explode( "::", (file.Read( "AT_players.txt" ) ) )
	GtC = net.ReadString()
	if table.HasValue( TRACKEDGROUPS, GtC ) then
		table.RemoveByValue( TRACKEDGROUPS, GtC)
		file.Write( "AT_groups.txt", string.Implode( "::", TRACKEDGROUPS ) )
	else
		table.insert( TRACKEDGROUPS, GtC )
		file.Write( "AT_groups.txt", string.Implode( "::", TRACKEDGROUPS ) )
	end
	net.Start( "ReturnGroupList" )
			net.WriteTable( TRACKEDGROUPS )
			net.WriteTable( TRACKEDPLAYERS )
	net.Broadcast()
	
end )

net.Receive( "ChangeTrackedPlayerList", function()
	local TRACKEDPLAYERS = string.Explode( "::", (file.Read( "AT_players.txt" ) ) )
	local TRACKEDGROUPS = string.Explode( "::", ( file.Read( "AT_groups.txt" ) ) )
	ply = net.ReadEntity()
	uID = ply:UniqueID()
	if table.HasValue( TRACKEDPLAYERS, uID ) then
		table.RemoveByValue( TRACKEDPLAYERS, uID )
		file.Write( "AT_players.txt", string.Implode( "::", TRACKEDPLAYERS ) )
	else
		table.insert( TRACKEDPLAYERS, uID )
		file.Write( "AT_players.txt", string.Implode( "::", TRACKEDPLAYERS ) )
	end
	net.Start( "ReturnTrackedPlayerList" )
		net.WriteTable( TRACKEDGROUPS )
		net.WriteTable( TRACKEDPLAYERS )
	net.Broadcast()
end )

net.Receive( "RequestTableGroup", function( len, ply )
	local DoTotal = net.ReadInt( 32 )
	local group = net.ReadString()
	local entries = net.ReadInt( 32 )
	local tbl
		if DoTotal == 1 then
			tbl = sql.Query( "SELECT * FROM total_time WHERE usergroup = '"..group.."' ORDER BY CAST (totaltime AS INT) DESC LIMIT '"..entries.."'" )
		else
			tbl = sql.Query( "SELECT * FROM session_time WHERE usergroup = '"..group.."' ORDER BY CAST (starttime AS INT) DESC LIMIT '"..entries.."'" )
		end
		if !tbl then tbl = { } end
	net.Start( "ReturnTable" )
		net.WriteTable( tbl )
		net.WriteInt( 40 + DoTotal, 32 )
	net.Send( ply )
end )

net.Receive( "RequestTableTotal", function( len, ply )
	local val = net.ReadInt( 32 )
	local entries = net.ReadInt( 32 )
	local tbl
	if val == 1 then 
		tbl = sql.Query( "SELECT * FROM total_time ORDER BY CAST ( totaltime AS INT ) DESC LIMIT '"..entries.."'" )
	elseif val == 2 then
		tbl = sql.Query( "SELECT * FROM total_time ORDER BY CAST ( totaltime AS INT ) ASC LIMIT '"..entries.."'" )
	else
		tbl = sql.Query( "SELECT * FROM total_time ORDER BY CAST ( lastonline AS INT ) ASC LIMIT '"..entries.."'" )
	end
	if !tbl then tbl = { } end
	net.Start( "ReturnTable" )
		net.WriteTable( tbl )
		net.WriteInt( 4 + val , 32 )
	net.Send( ply )
end )

net.Receive( "RequestTableSession", function( len, ply )
	local val = net.ReadInt( 32 )
	local entries = net.ReadInt( 32 )
	local tbl
	if val == nil then val = 1 end
	if val == 1 then 
		tbl = sql.Query( "SELECT * FROM session_time ORDER BY CAST ( starttime AS INT ) DESC LIMIT '"..entries.."'" )
	else
		tbl = sql.Query( "SELECT * FROM session_time ORDER BY CAST ( sessionlength AS INT ) DESC LIMIT '"..entries.."'" )
	end
	if !tbl then tbl = { } end
	net.Start( "ReturnTable" )
		net.WriteTable( tbl )
		net.WriteInt( 1+val, 32 )
	net.Send( ply )
end )

net.Receive( "RequestTablePly", function( len, ply )
	local sendint, tbl
	local val = net.ReadDouble( ) -- some uniqueID's can be over 32bits. So we use ReadDouble which can support up to 64 bits of data.
	local entries = net.ReadInt( 32 )
	local DoTotal = net.ReadInt( 32 )
	if val == 1 then -- if we want their name. If val ~= 1 then it's a uniqueID and we'll read that.
		name = net.ReadString()
		if DoTotal == 1 then
			sendint = 11
			tbl = sql.Query( "SELECT * FROM total_time WHERE name LIKE '%"..name.."%' ORDER BY CAST (totaltime AS INT) DESC LIMIT '"..entries.."'" )
		else
			sendint = 10
			tbl = sql.Query( "SELECT * FROM session_time WHERE name LIKE '%"..name.."%' ORDER BY CAST (starttime AS INT) DESC LIMIT '"..entries.."'" )
		end
	else
		if DoTotal == 1 then
			sendint = 21
			tbl = sql.Query( "SELECT * FROM total_time WHERE unique_id = '"..val.."'" )
		else
			sendint = 20
			tbl = sql.Query( "SELECT * FROM session_time WHERE unique_id = '"..val.."' ORDER BY CAST (starttime AS INT) DESC LIMIT '"..entries.."'" )
		end
	end
	if !tbl then tbl = { } end
net.Start( "ReturnTable" )
	net.WriteTable( tbl )
	net.WriteInt( sendint , 32 )
net.Send( ply )
end )