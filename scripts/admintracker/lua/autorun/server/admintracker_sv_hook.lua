//AdminTracker by Pyro. Serverside hook file.
//If you did not purchase this addon from www.coderhire.com, please contact me. My steam profile: http://steamcommunity.com/profiles/76561198015899774/
//Do not change anything in this file unless you know what you're doing.

AT_Version = "1.2.4"

-- Add Files

AddCSLuaFile( "lua/autorun/client/admintracker_cl.lua" )
AddCSLuaFile( "lua/autorun/client/admintracker_cl_helper.lua" )

--Network Strings

util.AddNetworkString( "AT_UI" )
util.AddNetworkString( "AT_UpdateTrackedGroups" )
util.AddNetworkString( "ReturnGroupList" )
util.AddNetworkString( "ChangeTrackedPlayerList" )
util.AddNetworkString( "ReturnTrackedPlayerList" )
util.AddNetworkString( "RequestTableGroup" )
util.AddNetworkString( "RequestTablePly" )
util.AddNetworkString( "RequestTableTotal" )
util.AddNetworkString( "RequestTableSession" )
util.AddNetworkString( "ReturnTable" )

local DEFAULTGROUPS = { "admin", "superadmin" } -- too be tracked. Don't bother changing this. You can simply edit the tracked groups from ingame.

hook.Add( "Initialize", "Create_AT_DB", function() --Create our files and database tables
	if !sql.TableExists( "session_time" ) then
		sql.Query( "CREATE TABLE session_time ( name varchar(255), usergroup varchar(255), unique_id int, starttime int, sessionlength int )" )
	end
	if !sql.TableExists( "total_time" ) then
		sql.Query( "CREATE TABLE total_time ( name varchar(255), usergroup varchar(255), unique_id int, totaltime int, lastonline int )" )
	end
	if !file.Exists( "AT_groups.txt", "DATA" ) then
		file.Write( "AT_groups.txt", string.Implode( " ", DEFAULTGROUPS ) )
	end
	if !file.Exists( "AT_players.txt", "DATA" ) then
		file.Write( "AT_players.txt", "" )
	end
end )

hook.Add( "PlayerInitialSpawn", "AT_AddTo_DB", function( ply )
	local TRACKEDGROUPS = string.Explode( "::", ( file.Read( "AT_groups.txt" ) ) )
	local TRACKEDPLAYERS = string.Explode( "::", (file.Read( "AT_players.txt" ) ) )
	local pID = ply:UniqueID()
	if table.HasValue( TRACKEDGROUPS, ply:GetUserGroup() ) or table.HasValue( TRACKEDPLAYERS, pID ) then
	
		local curtime = os.time()
		plyE = sql.Query( "SELECT * FROM total_time WHERE unique_id = '"..pID.."'" )
		if !plyE then
			sql.Query( "INSERT INTO total_time ( `name`, `usergroup`, `unique_id`, `totaltime`, `lastonline` ) VALUES ( '"..ply:Name().."', '"..ply:GetUserGroup().."', '"..pID.."', '3', '"..curtime.."' ) " )
		end
		
		local HasActiveSession = sql.Query( "SELECT * FROM session_time WHERE unique_id = '"..pID.."' AND sessionlength = '0'" )
		if HasActiveSession then
			ply.starttime = HasActiveSession[1]["starttime"]
		else	
			local lastonline = sql.Query( "SELECT * FROM total_time WHERE unique_id = '"..pID.."'" )
			local MRS = tonumber(lastonline[1]["lastonline"])
			if MRS > curtime - 300 then
				ply.starttime = MRS
			else
				sql.Query( "INSERT INTO session_time( `name`, `usergroup`, `unique_id`, `starttime`, `sessionlength` ) VALUES ( '"..ply:Name().."', '"..ply:GetUserGroup().."', '"..pID.."', '"..curtime.."', '0' )" )
				ply.starttime = curtime
			end	
		end
	end
end )

hook.Add( "PlayerDisconnected", "AT_UPDATE_DB", function( ply )
	if ply.starttime ~= nil then
		local len = os.time() - ply.starttime
		sql.Query( "UPDATE session_time SET sessionlength = '"..len.."' WHERE starttime = '"..ply.starttime.."' AND unique_id = '"..ply:UniqueID().."'" )
		prevtotal = sql.Query( "SELECT totaltime FROM total_time WHERE unique_id = '"..ply:UniqueID().."'" )
		local newtotal = prevtotal[1]["totaltime"] + len
		sql.Query( "UPDATE total_time SET totaltime = '"..newtotal.."', usergroup = '"..ply:GetUserGroup().."', lastonline = '"..os.time().."' WHERE unique_id = '"..ply:UniqueID().."'" )
	end
end )

local function Display_AT( ply )
	if table.HasValue(steamID_can_use_tracker, ply:SteamID() ) or table.HasValue( group_can_use_tracker, ply:GetUserGroup() ) then
		local TRACKEDGROUPS = string.Explode( "::", ( file.Read( "AT_groups.txt" ) ) )
		local TRACKEDPLAYERS = string.Explode( "::", (file.Read( "AT_players.txt" ) ) )
		local default = sql.Query( "SELECT * FROM session_time ORDER BY CAST (starttime AS INT) DESC LIMIT 30" )
		if !default then default = { } end
		net.Start( "AT_UI" )
		net.WriteTable( TRACKEDGROUPS )
		net.WriteTable( TRACKEDPLAYERS )
		net.WriteTable( default )
		net.Send( ply )
	else
		ply:ChatPrint( "You do not have access to this panel!" )
	end
end

concommand.Add( "Admintracker", Display_AT )

hook.Add( "PlayerSay", "Display_AT", function( speaker, text )
	if string.lower(text) == "!admintracker" then
		Display_AT( speaker )
	end
	if string.lower(text) == "!atver" then
		speaker:ChatPrint( "The current version of Pyro's Admin Tracker is: " .. AT_Version )
	end
end )