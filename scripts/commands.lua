//lua/autorun



function testCommand( pl, text, teamonly ) --THIS IS FOR SERVER WITH THE ULX TEMPADDUSER COMMAND
		    if (string.lower(text) == "!trialvip") then 
						if testvalid then
								RunConsoleCommand( "ulx", "tempadduserid", pl:SteamID(), "vips", "720", "user" )
								RunConsoleCommand( "ulx", "tsaycolor", "Player " .. pl:Nick() .. " has started his !trialvip time!", "green" )
								testvalid = false
						end
						if not testvalid then
						pl:ChatPrint("You already had your 12 hour Test time, you can become a vip by donating and helping the server. type !donate for more info" )
						end
				end
			end
				hook.Add( "PlayerSay", "tcommand", testCommand )
				/*
				function testCommand( pl, text, teamonly ) --THIS WILL WORK ON ANY SERVER
		    if (string.lower(text) == "!trialvip") then 
						if not file.Exists( "testvip/vip" .. pl:SteamID() .. ".txt", "DATA" ) then
								file.Write( "testvip/vip" .. pl:SteamID() .. ".txt", "TestVIP Used" .. pl:Nick() )
								RunConsoleCommand( "ulx", "tempadduserid", pl:SteamID(), "vips", "720", "user" )
								RunConsoleCommand( "ulx", "tsaycolor", "Player " .. pl:Nick() .. " has started his !trialvip time!", "green" )
						end
						if file.Exists( "testvip/vip" .. pl:SteamID() .. ".txt", "DATA" ) then
						pl:ChatPrint("You already had your 12 hour Test time, you can become a vip by donating and helping the server. type !donate for more info" )
						end
				end
			end
				hook.Add( "PlayerSay", "tcommand", testCommand )
				*/
----------------REJOIN COMMAND-------------------
function joinCommand( pl, text, teamonly )
		    if (string.lower(text) == "!reconnect") or (string.lower(text) == "!rejoin") then 
				pl:ConCommand("retry")
				end
				end
				hook.Add( "PlayerSay", "jcommand", joinCommand )
----------------COLLECTION COMMAND-------------------

function collectionCommand( pl, text, teamonly )
		    if (string.lower(text) == "!collection") or (string.lower(text) == "!downloads") or (string.lower(text) == "!download") or (string.lower(text) == "!errors") then 
			    pl:SendLua([[gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=226668801")]]) -- Change ADDRESS to your chosen page.
		for k, v in pairs(player.GetAll()) do v:ChatPrint( "IF YOU SEE BIG RED ERRORS EVERYWHERE PLEASE TYPE !collection/!downloads/!errors AND HIT THE 'SUBSCRIBE ALL' BUTTON!" )


		end
	end
    end
    
hook.Add( "PlayerSay", "ccommand", collectionCommand )
----------------BANLIST COMMAND-------------------

function banCommand( pl, text, teamonly )
		    if (string.lower(text) == "!bans") or (string.lower(text) == "!banlist") then 
			    pl:SendLua([[gui.OpenURL("http://icemodservers.de/banlist/index.php?p=darkrp")]]) -- Change ADDRESS to your chosen page.
		for k, v in pairs(player.GetAll()) do v:ChatPrint( "Player " .. pl:Nick() .. " has viewed the Banlist! Type !bans to view it" )


		end
	end
    end
    
hook.Add( "PlayerSay", "bcommand", banCommand )

----------------DONATE COMMAND-------------------

function donateCommand( pl, text, teamonly )
		    if (string.lower(text) == "!donate") then 
			    pl:SendLua([[gui.OpenURL("http://icemodservers.de/donate/")]]) -- Change ADDRESS to your chosen page.
		for k, v in pairs(player.GetAll()) do v:ChatPrint( "Player " .. pl:Nick() .. " has viewed our Donation Site! Type !donate to view it" )


		end
	end
    end
    
hook.Add( "PlayerSay", "dcommand", donateCommand )


----------------FORUM COMMAND-------------------

function forumCommand( pl, text, teamonly )
		    if (string.lower(text) == "!forum") or (string.lower(text) == "!forums") then 
			    pl:SendLua([[gui.OpenURL("http://icemod.net")]]) -- Change ADDRESS to your chosen page.
			    for k, v in pairs(player.GetAll()) do v:ChatPrint( "Player " .. pl:Nick() .. " has viewed our Forum! Type !forum to check it out" )

		end
	end
end
hook.Add( "PlayerSay", "fcommand", forumCommand )



----------------Server COMMAND-------------------

function serverCommand( pl, text, teamonly )
		    if (string.lower(text) == "!servers") or (string.lower(text) == "!serverlist") then 
			    pl:SendLua([[gui.OpenURL("http://icemodservers.de/banlist/index.php?p=srv")]]) -- Change ADDRESS to your chosen page.
			    for k, v in pairs(player.GetAll()) do v:ChatPrint( "Player " .. pl:Nick() .. " has viewed our Servers! Type !servers to check it out" )

		end
	end
end
hook.Add( "PlayerSay", "scommand", serverCommand )


