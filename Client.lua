--|| SERVICES ||--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketPlaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild"Humanoid"
local getPing = script.Parent.getPing
local getDistributedTime = script.Parent.getDistributedTime;

local ClientData = script.Parent
local pingInterval = 1
local lastPing = os.clock() - pingInterval

local Coordinates = ClientData.Coordinates
local FPS = ClientData.FramesPerSecond
local MS = ClientData.Ping
local Ver = ClientData.ServerVersion

Ver.Text = "Version: "..MarketPlaceService:GetProductInfo(game.PlaceId).Updated

local function ToHMS(second)
	return ("%02i:%02i:%02i"):format(second/60^2, second/60%60, second%60)
end

Player.CharacterAdded:Connect(function(Char)
	Character = Char
	Humanoid = Character:WaitForChild"Humanoid"
end)

RunService.Stepped:Connect(function()
	if Character and Character:FindFirstChild("HumanoidRootPart") then
		local RootPartCFrame = Character.HumanoidRootPart.CFrame
		Coordinates.Text = "Coordinates: {"..math.floor(RootPartCFrame.X)..","..math.floor(RootPartCFrame.Y)..","..math.floor(RootPartCFrame.Z).."}"
	end

	FPS.Text = "FPS: "..math.floor(game.Workspace:GetRealPhysicsFPS() * 100) / 100

	if os.clock() - lastPing >= pingInterval then
		lastPing = os.clock()
		getPing:InvokeServer()
		MS.Text = "Ping: "..(math.floor(((os.clock() - lastPing) * 1000) * 100) / 100).." MS" 
	end
end)

while true do
	wait(1)
	local Time = getDistributedTime:InvokeServer();
	script.Parent.ServerUptime.Text = "Server Lifetime: "..ToHMS(math.floor(Time));
end
