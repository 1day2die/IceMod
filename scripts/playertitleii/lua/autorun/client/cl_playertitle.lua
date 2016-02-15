//Config

// Names enabled?
local enablenames = false

						
// Titles enabled?
local enabletitles = true

// How to align the text?
// 0 = left
// 1 = center
// 2 = right
local textalign = 1

// Distance multiplier. The higher this number, the further away you'll see names and titles.
local distancemulti = 1

////////////////////////////////////////////////////////////////////
// Don't edit below this point unless you know what you're doing. //
////////////////////////////////////////////////////////////////////

function DrawNameTitle()

	local vStart = LocalPlayer():GetPos()
	local vEnd

        for k, v in pairs(player.GetAll()) do
                if v:Alive() and v != LocalPlayer() then
                        local vPos = v:GetPos() + Vector(0,0,84)
                        local vDistance = math.floor((LocalPlayer():GetPos():Distance( vPos ))/40)
                        local vScreenpos = vPos:ToScreen() 
						local levelColor = Color(189, 195, 199, 255)	
						local dist = LocalPlayer():GetPos():Distance(v:GetPos())
						

		local vStart = LocalPlayer():GetPos()
		local vEnd = v:GetPos() + Vector(0,0,40)
		local trace = {}
		
		trace.start = vStart
		trace.endpos = vEnd
		local trace = util.TraceLine( trace )
		
		if trace.HitWorld then
		return
			--Do nothing!
		else
			local mepos = LocalPlayer():GetPos()
			local tpos = v:GetPos()
			local tdist = mepos:Distance(tpos)
			
			if tdist <= 3000 then
				local zadj = 0.03334 * tdist
				local pos = v:GetPos() + Vector(0,0,v:OBBMaxs().z + 5 + zadj)
				pos = pos:ToScreen()
				
				//local alphavalue = (600 * distancemulti) - (tdist/1.5)
				//alphavalue = math.Clamp(alphavalue, 0, 255)

				local alphavalue = (400) - (tdist/1.5)
				alphavalue = math.Clamp(alphavalue, 0, 255)
				
				local outlinealpha = (325 * distancemulti) - (tdist/2)
				outlinealpha = math.Clamp(outlinealpha, 0, 255)
				
				local playercolour = team.GetColor(v:Team())
				local playertitle = v:GetNetworkedString("title")
				
				if ( (v != LocalPlayer()) and (v:GetNWBool("exclusivestatus") == false) ) then
					if (enablenames == true) then
						draw.SimpleTextOutlined(v:Name(), "vID", pos.x, pos.y - 10, Color(playercolour.r, playercolour.g, playercolour.b, alphavalue),textalign,1,2,Color(0,0,0,outlinealpha))
					end
					if (playertitle == "remove") and (enabletitles == true) then
						return
					end
					if (not (playertitle == "")) and (enabletitles == true) then
							if (dist < 300) and v:Alive() then  
//						draw.SimpleTextOutlined(playertitle, "ChatFont", pos.x, pos.y + 15, Color(255,0,204,alphavalue),textalign,1,1,Color(0,0,0,outlinealpha))
						draw.SimpleTextOutlined(playertitle, "ChatFont", tonumber(vScreenpos.x), tonumber(vScreenpos.y + 40), Color(255,0,204,alphavalue),TEXT_ALIGN_CENTER,1,1,Color(0,0,0,outlinealpha))

					end
					end


				end
			end
		end
	end
end
end

hook.Add("HUDPaint", "DrawNameTitle", DrawNameTitle)