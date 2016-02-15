//AdminTracker by Pyro. Clientside file.
//If you did not purchase this addon from www.coderhire.com, please contact me. My steam profile: http://steamcommunity.com/profiles/76561198015899774/

local numtable = { 41, 5, 6, 7, 21, 11 }

net.Receive( "AT_UI", function()
	local trackedgroups = net.ReadTable()
	local trackedplayers = net.ReadTable()
	local displist = net.ReadTable()
	local grplen = math.Clamp(#xgui.data.groups * 20, 102, 200 )
	
	local Dmain = vgui.Create( "DFrame" )
	Dmain:SetPos( ScrW()/2 - 400, ScrH()/2 - 325 )
	Dmain:SetSize( 800, 650 )
	Dmain:SetTitle( "Admin Tracker                                                                                                                                                         Current Time: " .. os.date( "%x at %H:%M", os.time()) )
	Dmain:SetDraggable( true )
	Dmain:MakePopup()
	
	local left = vgui.Create( "DPanel", Dmain )
	left:SetPos( 1, 25 )
	left:SetSize( 449, 625 )
	
	local right = vgui.Create( "DPanel", Dmain )
	right:SetPos( 450, 25 )
	right:SetSize( 349, 625 )
	
	local sL = vgui.Create( "DNumSlider", right ) -- slider for #entries to return
	local gTime = vgui.Create( "DCheckBoxLabel", right ) -- toggles betwen group search for total or session time
	
	sL:SetPos( -130, grplen + 120 ) 
	sL:SetWide( 300 )
	sL:SetMin( 1 )
	sL:SetMax( 1000 )
	sL:SetDecimals( 0 )
	sL:SetValue( 30 )	
	
	gTime:SetPos( 10, grplen + 70 )
	gTime:SetText( "Total instead of Session time" )
	gTime:SetTextColor( Color( 70, 70, 70 ) )
	gTime:SizeToContents()
	gTime:SetValue( 0 )
	
	local sT = vgui.Create( "DLabel", left )
	sT:SetColor( Color(70, 70, 70 ) )
	sT:SetFont( "SortingOptions" )
	sT:SetPos( left:GetWide()/2 - sT:GetWide()* 2, 590 )
	
	local function DrawList( tbl, tblval, sorttxt, C1, C2, C3, C4, sortC, Cbool )
	
		sT:SetText( "Sorting by: " .. sorttxt )
		sT:SizeToContents()
		
		local output = vgui.Create( "DListView", left )
		output:SetSize( 449, 580 )  --We have to create the Listview inside the refresh function, or it won't erase the previous columns when re-drawing.
		output:AddColumn( C1 )
		output:AddColumn( C2 )
		output:AddColumn( C3 )
		output:AddColumn( C4 )
		output.OnRowRightClick = function()
			for k, v in pairs(tbl) do
				if (tostring(output:GetLine(output:GetSelectedLine()):GetValue(1))) == tbl[k]["name"] then
					net.Start( "RequestTablePly" )
						net.WriteDouble ( tbl[k]["unique_id"] )
						net.WriteInt( sL:GetValue(), 32 )
						net.WriteInt( gTime:GetChecked() and 1 or 0, 32 )
					net.SendToServer()
					break
				end
			end
		end
		for k, v in ipairs( tbl ) do
				local row = tbl[k]
				local name = row[ "name" ]
				local usergroup = row["usergroup"]
				if tblval == 1 then
					local timeval
					local TinSec = row["starttime"]
					local len = row["sessionlength"]
					local usergroup = row["usergroup"]
					if len == "0" then
						timeval = "    Not yet indexed" --spaces are intentional for centering.
					else
						timeval = " "..math.floor( len/3600 ) .. " hours, " .. math.floor( math.floor( len/60 )%60 ) .. " minutes "
					end
					output:AddLine( name, os.date( "%x at %H:%M", TinSec ), timeval, usergroup )
					output:SortByColumn( sortC, Cbool )
					for num, line in pairs(output:GetLines()) do
						if num == k then
							if tonumber(len) < 3600 then
								line.Paint = function()
									surface.SetDrawColor(50,255,50)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							elseif tonumber(len) > 3600 && tonumber(len) < 10800 then
								line.Paint = function()
									surface.SetDrawColor(255,255,0)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							elseif tonumber(len) > 10800 then
								line.Paint = function()
									surface.SetDrawColor(250,55,50)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							end
						end
					end
				else
					local ttime = row[ "totaltime" ]
					local lastonline = row [ "lastonline" ]
					for num, line in pairs(output:GetLines()) do
						if num + 1 == k then
							if tonumber(ttime) > 18000 && tonumber(ttime) < 43200 then
								line.Paint = function()
									surface.SetDrawColor(255,255,0)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							elseif tonumber(ttime) > 43200 then
								line.Paint = function()
									surface.SetDrawColor(250,55,50)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							else
								line.Paint = function()
									surface.SetDrawColor(50,255,50)
									surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
								end
							end
						end
					end
					ttime = math.floor( ttime/3600 ) .. " hours, " .. math.floor( math.floor( ttime/60 )%60 ) .. " minutes "
					output:AddLine( name, ttime, os.date( "%x at %H:%M", lastonline), usergroup )
					--output:SortByColumn( sortC, Cbool )		
			end
		end
	end
	DrawList( displist, 1, "Most Recent Session", "PlayerName", "Join Time", "Session Length", "Usergroup", 2, true )
	
	local SO = vgui.Create( "DLabel", right ) -- Text "Sorting Options"
	local gS = vgui.Create( "DComboBox", right ) -- Dropdown menu for group sorting
	local tT = vgui.Create( "DComboBox", right ) -- Dropdown menu for total time sorting
	local sT = vgui.Create( "DComboBox", right ) -- Dropdown menu for session time sorting
	local PNB = vgui.Create( "DTextEntry", right ) -- Text entry for playername
	local SiD = vgui.Create( "DLabel", right ) -- SteamID info text
	local sLT = vgui.Create( "DLabel", right ) -- text for slider
	local allgrp = vgui.Create( "DListView", right ) -- box for selecting tracked groups
	local idvply = vgui.Create( "DListView", right ) -- box for selecting to track invididual players
	
	SO:SetPos( 120, grplen + 5 )
	SO:SetFont( "SortingOptions" )
	SO:SetText( "Sorting Options:" )
	SO:SetColor( Color( 100, 100, 100 ) )
	SO:SizeToContents()
	
	tT:SetPos( right:GetWide() - 165, grplen + 30 )
	tT:SetSize( 140, 30 )
	tT:SetValue( "Sort by Total Time" )
	tT:AddChoice( "Highest Total Time" )
	tT:AddChoice( "Lowest Total Time" )
	tT:AddChoice( "Longest Time Since Online" )
	tT.OnSelect = function( pnl, idx, val, dat )
		net.Start( "RequestTableTotal" )
			net.WriteInt( idx, 32 )
			net.WriteInt( sL:GetValue(), 32 )
		net.SendToServer()
	end
	
	sT:SetPos( right:GetWide() - 165, grplen + 103 )
	sT:SetSize( 155, 30 )
	sT:SetValue( "Sort by Session Time" )
	sT:AddChoice( "Most Recent session" )
	sT:AddChoice( "Longest Session" )
	sT.OnSelect = function( pnl, idx, val, dat )
		net.Start( "RequestTableSession" )
		net.WriteInt( idx, 32 )
		net.WriteInt( sL:GetValue(), 32 )
		net.SendToServer()
	end
	
	PNB:SetPos( right:GetWide() - 165, grplen + 176 )
	PNB:SetSize( 155, 20 )
	PNB:SetText( "Sort by Player Name:" )
	PNB:SelectAllOnFocus( true )
	PNB.OnEnter = function()
		net.Start( "RequestTablePly" )
			net.WriteDouble( 1 )
			net.WriteInt( sL:GetValue(), 32 )
			net.WriteInt( gTime:GetChecked() and 1 or 0, 32 )
			net.WriteString( PNB:GetValue() )
		net.SendToServer()
	end
	
	sLT:SetPos( 5, grplen + 110 )
	sLT:SetFont( "SortBySteamID" )
	sLT:SetColor( Color( 100, 100, 100 ) )
	sLT:SetText( "Number of entries to return:" )
	sLT:SizeToContents()
	
	SiD:SetPos( 10, grplen + 190 )
	SiD:SetFont( "SortBySteamID" )
	SiD:SetColor( Color( 70, 70, 70 ) )
	SiD:SetText( "To sort by steamID,\nRight click on a players name in the list on the left.\nThis will automatically display all entries for that player." )
	SiD:SizeToContents()
	
	allgrp:AddColumn( "Group" )
	allgrp:AddColumn( "Members being tracked?" )
	allgrp:SetSize( 349, grplen )
	
	local function GroupRefresh( grouplist )
	if !Dmain:IsValid() then return else end -- don't really know why I need the else, but it doesn't work if the else isn't there.
	local istrk
		allgrp:Clear()
		for k, v in pairs( xgui.data.groups ) do
			if table.HasValue( grouplist, v ) then
				istrk = "Yes"
			else
				istrk = "No"
			end
			allgrp:AddLine( v, istrk )
		end
		for _, v in pairs(allgrp:GetLines()) do
			if v:GetColumnText(2) == "Yes"  then
				v.Paint = function()
					surface.SetDrawColor(50,255,50)
					surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
				end
			else
				v.Paint = function()
					surface.SetDrawColor(255,89,89)
					surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
				end
			end
		end
		
		gS:SetPos( 10, grplen + 30 )
		gS:SetSize( 140, 30 )
		gS:Clear()
		gS:SetValue( "Sort by Group" )
		for k, v in pairs( grouplist ) do
			if v ~= "" then
				gS:AddChoice( v )
			end
		end
	gS.OnSelect = function( pnl, idx, val, dat )
		net.Start( "RequestTableGroup" )
			net.WriteInt( gTime:GetChecked() and 1 or 0, 32 )
			net.WriteString( val )
			net.WriteInt( sL:GetValue(), 32 )
		net.SendToServer()
	end
	
	end
	
	GroupRefresh( trackedgroups )

	allgrp.OnRowRightClick = function()
		for k, v in pairs(xgui.data.groups) do
			if allgrp:GetSelectedLine() == k then
				net.Start( "AT_UpdateTrackedGroups" )
					net.WriteString( v )
					net.WriteInt( sL:GetValue(), 32 )
				net.SendToServer()
			end
		end
	end
	
	idvply:AddColumn( "Player Name" )
	idvply:AddColumn( "Tracked by group?" )
	idvply:AddColumn( "Tracked individually?" )
	idvply:SetPos( 0, grplen + 240 )
	idvply:SetSize( right:GetWide(), (388 - 51 * (grplen) / 50) )
	
	local function UpdatePlyList( trackedplayers, trackedgroups )
		if !Dmain:IsValid() then return else end
		idvply:Clear()
		for k, v in ipairs(player.GetAll()) do
			local istrkbg, istrkidv
			if table.HasValue( trackedgroups, v:GetUserGroup() ) then
				istrkbg = "Yes"
			else
				istrkbg = "No"
			end
			if table.HasValue( trackedplayers, v:UniqueID() ) then
				istrkidv = "Yes"
			else
				istrkidv = "No"
			end
			idvply:AddLine( v:Nick(), istrkbg, istrkidv )
		end
		for _, v in pairs(idvply:GetLines()) do
			if v:GetColumnText(3) == "Yes"  then
				v.Paint = function()
					surface.SetDrawColor(50,255,50)
					surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
				end
			elseif v:GetColumnText(3) == "No" and  v:GetColumnText(2) == "No" then
				v.Paint = function()
					surface.SetDrawColor(255,89,89)
					surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
				end
			elseif v:GetColumnText(2) == "Yes" and v:GetColumnText(3) == "No" then
				v.Paint = function()
					surface.SetDrawColor(255,255,50)
					surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
				end
			end
		end
	end
	UpdatePlyList( trackedplayers, trackedgroups )
	
	idvply.OnRowRightClick = function()
		for k, v in ipairs(player.GetAll()) do
			if idvply:GetSelectedLine() == k and IsValid(v) then
				net.Start( "ChangeTrackedPlayerList" )
					net.WriteEntity( v )
				net.SendToServer()
			end
		end
	end
	
	net.Receive( "ReturnTrackedPlayerList", function()
		local trackedgroups = net.ReadTable()
		local trackedplayers = net.ReadTable()
		UpdatePlyList( trackedplayers, trackedgroups )
	end )
	
	net.Receive( "ReturnGroupList", function()
		local trackedgroups = net.ReadTable()	
		local trackedplayers = net.ReadTable()
		GroupRefresh( trackedgroups )
		UpdatePlyList( trackedplayers, trackedgroups )
	end )
	
	net.Receive( "ReturnTable", function()
	local tbl = net.ReadTable()
	local num = net.ReadInt( 32 )
	local sortC = net.ReadInt( 32 )
	local val, col, bool = StringText(num)
		if table.HasValue( numtable, num ) then
			DrawList( tbl, 2, val, "PlayerName", "Total Time", "Last Online", "Usergroup", col, bool )
		else
			DrawList( tbl, 1, val, "PlayerName", "JoinTime", "Session Length", "Usergroup", col, bool )
		end 
	end )
	
end)