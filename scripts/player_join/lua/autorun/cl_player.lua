// client side apple

// Spawn
function player_spawn( data )
local name1 = data:ReadString()
local nickteamcolour1 = team.GetColor(data:ReadShort())
	chat.AddText( Color( 255, 0, 255 ), "[Icemod] ", nickteamcolour1, name1, Color( 255, 255, 255 ), " has joined in the server." )
	surface.PlaySound( "garrysmod/save_load1.wav" )
end
usermessage.Hook("player_spawn", player_spawn)