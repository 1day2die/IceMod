hook.Add('Initialize','CH_S_aa21fc625ba519dddf53aac227430785', function()
	http.Post('http://coderhire.com/api/script-statistics/usage/2259/660/aa21fc625ba519dddf53aac227430785/', {
		port = GetConVarString('hostport'),
		hostname = GetHostName()
	})
end)