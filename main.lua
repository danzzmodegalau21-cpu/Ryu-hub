--[[ 
    RYU HUB - NO KEY
    Optimized & Clean Version
--]]

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

--// PLAYER
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local PlayerGui = Player:WaitForChild("PlayerGui")

--// SETTINGS (BISA DIUBAH)
local Settings = {
	DelayFire = 0.15,     -- speed fire remote
	PerfectDelay = 0.05, -- cek perfect
	TeleportOffset = 3
}

--// FIND REMOTE
local Remote
for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
	if v:IsA("RemoteEvent") and v.Name:lower():find("fish") then
		Remote = v
		break
	end
end

if not Remote then
	for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") then
			Remote = v
			break
		end
	end
end

--// GRAPHIC BOOST
pcall(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("BlurEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("BloomEffect")
	or v:IsA("ColorCorrectionEffect")
	or v:IsA("DepthOfFieldEffect") then
		v:Destroy()
	end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _,obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		obj.Material = Enum.Material.Plastic
		obj.Reflectance = 0
	end
end

--// TELEPORT NEAREST FISH
local function TeleportToFish()
	local Nearest, Distance
	for _,p in ipairs(workspace:GetDescendants()) do
		if p:IsA("BasePart") and p.Name:lower():find("fish") then
			local d = (p.Position - HumanoidRootPart.Position).Magnitude
			if not Distance or d < Distance then
				Distance = d
				Nearest = p
			end
		end
	end

	if Nearest then
		HumanoidRootPart.CFrame = Nearest.CFrame + Vector3.new(0, Settings.TeleportOffset, 0)
	end
end

TeleportToFish()

--// AUTO FIRE REMOTE
task.spawn(function()
	while task.wait(Settings.DelayFire) do
		if Remote then
			pcall(function()
				Remote:FireServer()
			end)
		end
	end
end)

--// AUTO PERFECT
task.spawn(function()
	while task.wait(Settings.PerfectDelay) do
		for _,gui in ipairs(PlayerGui:GetDescendants()) do
			if gui:IsA("TextLabel") and gui.Text:lower():find("perfect") then
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
			end
		end
	end
end)

--// ANTI AFK
Player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)-- NO KEY / NO PASSWORD / NO CHECK

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local VirtualUser=game:GetService("VirtualUser")
local VirtualInputManager=game:GetService("VirtualInputManager")
local Lighting=game:GetService("Lighting")

local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")
local PlayerGui=player:WaitForChild("PlayerGui")

local delayTime=0.15

local remote
for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
	if v:IsA("RemoteEvent") and string.find(string.lower(v.Name),"fish") then
		remote=v
		break
	end
end
if not remote then
	for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") then
			remote=v
			break
		end
	end
end

pcall(function()
	settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
end)

for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect")
	or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
		v:Destroy()
	end
end

Lighting.GlobalShadows=false
Lighting.FogEnd=9e9
Lighting.Brightness=1
Lighting.EnvironmentDiffuseScale=0
Lighting.EnvironmentSpecularScale=0

for _,obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") then
		obj.Material=Enum.Material.Plastic
		obj.Reflectance=0
	end
end

local function teleportToNearestSpot()
	local nearest,dist
	for _,p in ipairs(workspace:GetDescendants()) do
		if p:IsA("BasePart") and string.find(string.lower(p.Name),"fish") then
			local d=(p.Position-hrp.Position).Magnitude
			if not dist or d<dist then
				dist=d
				nearest=p
			end
		end
	end
	if nearest then
		hrp.CFrame=nearest.CFrame+Vector3.new(0,3,0)
	end
end
teleportToNearestSpot()

task.spawn(function()
	while true do
		if remote then
			pcall(function()
				remote:FireServer()
			end)
		end
		task.wait(delayTime)
	end
end)

task.spawn(function()
	while true do
		for _,gui in ipairs(PlayerGui:GetDescendants()) do
			if gui:IsA("TextLabel") or gui:IsA("ImageLabel") then
				if string.find(string.lower(gui.Name),"perfect")
				or (gui:IsA("TextLabel") and gui.Text and string.find(string.lower(gui.Text),"perfect")) then
					VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
					VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
				end
			end
		end
		task.wait(0.05)
	end
end)

player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)
