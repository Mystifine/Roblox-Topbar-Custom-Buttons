local HttpService = game:GetService("HttpService");
local Data = HttpService:JSONDecode(HttpService:GetAsync('http://ip-api.com/json/'))

local function GetRegionFromLongitude(longitude)
	if(longitude>-180 and longitude<=-105)then
		return "West US"
	elseif(longitude>-105 and longitude<=-90)then
		return "Central US"
	elseif(longitude>-90 and longitude<=0)then
		return "East US"
	elseif(longitude<=75 and longitude>0)then
		return "Europe"
	elseif(longitude<=180 and longitude>75)then
		return "Australia"
	else
		return "Unknown"
	end
end


local ServerRegion = script.Parent.ServerRegion;
ServerRegion.Text = "Region: "..GetRegionFromLongitude(Data.lon)

local getPing = script.Parent.getPing;
getPing.OnServerInvoke = function()
	return true;
end

local getDistributedTime = script.Parent.getDistributedTime;
getDistributedTime.OnServerInvoke = function()
	return game.Workspace.DistributedGameTime;	
end
