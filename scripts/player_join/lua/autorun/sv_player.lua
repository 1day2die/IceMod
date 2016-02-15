// server side apple
AddCSLuaFile( "cl_player.lua"  )

//Spawn
function FirstSpawn( ply )
	timer.Create( "server_spawn_timer_wait", 3, 1, function()
colour1 = ply:Team()
spawn1 = ply:Nick()
	umsg.Start( "player_spawn")
	umsg.String(spawn1)
	umsg.Short(colour1)
	umsg.End()
Msg("Player " .. spawn1 .. " has joined the server.\n")
end)
end
  
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", FirstSpawn )