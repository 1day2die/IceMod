surface.CreateFont( "SortingOptions", {
font = "Arial",
size = 18,
weight = 900
} )

surface.CreateFont( "SortBySteamID", {
font = "Arial",
size = 15,
weight = 500
} )

function StringText( num )
	local txt, col, bool
	if num == 10 then
		txt = "Player Name(Session Time)"
		col = 2
		bool = true
	elseif num == 11 then
		txt = "Player Name(Total Time)"
		col = 2
		bool = false
	elseif num == 20 then
		txt = "Unique ID(Session Time)"
		col = 2
		bool = true
	elseif num == 21 then
		txt = "Unique ID(Total Time)"
		col = 2
		bool = true
	elseif num == 2 then
		txt = "Most Recent Session"
		col = 2
		bool = true
	elseif num == 3 then
		txt = "Longest Session"
		col = 3
		bool = true
	elseif num == 40 then
		txt = "Group (Session Time)"
		col = 2
		bool = true
	elseif num == 41 then
		txt = "Group (Total Time)"
		col = 2
		bool = false
	elseif num == 5 then
		txt = "Highest Total Time"
		col = 2
		bool = false
	elseif num == 6 then
		txt = "Lowest Total Time"
		col = 2
		bool = false
	elseif num == 7 then
		txt = "Last Logged On"
		col = 3
		bool = true
	end
	return txt, num, bool
end