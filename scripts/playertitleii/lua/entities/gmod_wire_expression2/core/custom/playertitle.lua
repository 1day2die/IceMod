e2function number entity:hasTitle()
	if this:IsPlayer() then
		gettitle = playerTitleGet(this)
		if gettitle then return 1
		else return 0 end
	else return 0
	end
end

e2function string entity:title()
	if this:IsPlayer() then
		gettitle = playerTitleGet(this)
		if gettitle then return gettitle
		else
			self.player:SendLua("chat.AddText(Color(250,125,0), 'You used E:title() on a player with no title. Shame shame.")
			return "#NOTITLE"
		end
	end
end

e2function void entity:setTitle(string target)
	if this:IsPlayer() then
		if self.player:IsAdmin() then
			result = playerTitleSet(this, target)
			if not result[1] then
				if result[2] == "too_long" then
					self.player:SendLua("chat.AddText(Color(250,125,0), 'Titles can\\'t be longer than 40 characters!')")
				end
			end
		else
			if this == self.player then
				result = playerTitleSet(this, target)
				if not result[1] then
					if result[2] == "too_long" then
						self.player:SendLua("chat.AddText(Color(250,125,0), 'Titles can\\'t be longer than 40 characters!')")
					end
				end
			else
				self.player:SendLua("chat.AddText(Color(250,125,0), 'You must be an admin to use E:setTitle() on other players.')")
			end
		end
	end
end
