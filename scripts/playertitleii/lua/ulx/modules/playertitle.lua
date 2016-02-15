local CATEGORY_NAME = "Fun"

function ulx.settheirtitle(calling_ply, target, targettitle)
	result = playerTitleSet(target, targettitle)
	if not result[1] then
		if result[2] == "too_long" then
			calling_ply:SendLua("chat.AddText(Color(250,125,0), 'Titles can\\'t be longer than 40 characters!')")
		-- I probably plan on adding more fail conditions later.
		end
	else
		BroadcastLua("chat.AddText(player.GetByID("..tostring(calling_ply:EntIndex()).."), Color(255,255,255), ' has set ', player.GetByID("..tostring(target:EntIndex()).."), '\\'s title to ', Color(0,255,0), '"..string.Replace(targettitle, "'", "\\'").."')")
	end
end

local settitle_cmd = ulx.command(CATEGORY_NAME, "ulx settitle", ulx.settheirtitle, "!settitle")
settitle_cmd:addParam{ type=ULib.cmds.PlayerArg }
settitle_cmd:addParam{ type=ULib.cmds.StringArg, hint="title", ULib.cmds.takeRestOfLine }
settitle_cmd:defaultAccess(ULib.ACCESS_ADMIN)
settitle_cmd:help("Change target's title to <title>")

function ulx.settitle(ply, targettitle)
	result = playerTitleSet(ply, targettitle)
	if not result[1] then
		if result[2] == "too_long" then
			ply:SendLua("chat.AddText(Color(250,125,0), 'Titles can\\'t be longer than 40 characters!')")
		end
	else
		BroadcastLua("chat.AddText(player.GetByID("..tostring(ply:EntIndex()).."), Color(255,255,255), ' has set their title to ', Color(0,255,0), '"..string.Replace(targettitle, "'", "\\'").."')")
	end
end

local title_cmd = ulx.command(CATEGORY_NAME, "ulx title", ulx.settitle, "!title")
title_cmd:addParam{ type=ULib.cmds.StringArg, hint="title", ULib.cmds.takeRestOfLine }
title_cmd:defaultAccess(ULib.ACCESS_ALL)
title_cmd:help("Set your title to <title>. Note that admins can change it at any time. Remove the title by saying !title remove")

function ulx.mytitle(ply)
	title = playerTitleGet(ply)
	if not title then
		ply:SendLua("chat.AddText(Color(250,125,0), 'You don\\' have a custom title!')")
	else
		ply:SendLua("chat.AddText(Color(255,255,255), 'Your title is ', Color(0,255,0), '"..string.Replace(title, "'", "\\'").."')")
	end
end

local mytitle_cmd = ulx.command(CATEGORY_NAME, "ulx mytitle", ulx.mytitle, "!mytitle")
mytitle_cmd:defaultAccess(ULib.ACCESS_ALL)
mytitle_cmd:help("Check your title.")

-- I removed the Exclusive Check.
