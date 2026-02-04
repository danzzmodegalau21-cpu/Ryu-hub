--[[ 
    RYU HUB | FREE (NOT BUY)
    100% NO KEY • NO PASSWORD • NO CHECK
    UI HOTBAR EDITION
]]

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

--// PLAYER
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local PlayerGui = Player:WaitForChild("PlayerGui")

--// SETTINGS (FREE EDIT)
local Settings = {
	AutoFire = true,
	AutoPerfect = true,
	TeleportFish = true,
	AntiAFK = true,
	DelayFire = 0.15,
	PerfectDelay = 0.05,
	TeleportOffset = 3
}

--// FIND REMOTE (NO CHECK)
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
	if v:IsA("BlurEffect") or v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")
	or v:IsA("ColorCorrectionEffect") then
		v:Destroy()
	end
end
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9

--// TELEPORT TO FISH
local function TeleportToFish()
	if not Settings.TeleportFish then return end
	local nearest,dist
	for _,p in ipairs(workspace:GetDescendants()) do
		if p:IsA("BasePart") and p.Name:lower():find("fish") then
			local d = (p.Position - HRP.Position).Magnitude
			if not dist or d < dist then
				dist = d
				nearest = p
			end
		end
	end
	if nearest then
		HRP.CFrame = nearest.CFrame + Vector3.new(0, Settings.TeleportOffset, 0)
	end
end

--// AUTO FIRE (NO LIMIT)
task.spawn(function()
	while task.wait(Settings.DelayFire) do
		if Settings.AutoFire and Remote then
			pcall(function()
				Remote:FireServer()
			end)
		end
	end
end)

--// AUTO PERFECT
task.spawn(function()
	while task.wait(Settings.PerfectDelay) do
		if not Settings.AutoPerfect then continue end
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
	if Settings.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

--// ================= UI HOTBAR =================

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "RYU_HUB_FREE_NOT_BUY"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35,0.38)
frame.Position = UDim2.fromScale(0.02,0.32)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,32)
title.BackgroundTransparency = 1
title.Text = "RYU HUB | FREE (NO KEY)"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local function Button(text,callback)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,0,0,36)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		callback(b)
	end)
	return b
end

Button("Auto Fire : ON",function(btn)
	Settings.AutoFire = not Settings.AutoFire
	btn.Text = "Auto Fire : "..(Settings.AutoFire and "ON" or "OFF")
end)

Button("Auto Perfect : ON",function(btn)
	Settings.AutoPerfect = not Settings.AutoPerfect
	btn.Text = "Auto Perfect : "..(Settings.AutoPerfect and "ON" or "OFF")
end)

Button("Teleport Fish",function()
	TeleportToFish()
end)

Button("Anti AFK : ON",function(btn)
	Settings.AntiAFK = not Settings.AntiAFK
	btn.Text = "Anti AFK : "..(Settings.AntiAFK and "ON" or "OFF")
end)

Button("+ Fire Speed",function()
	Settings.DelayFire = math.max(0.02, Settings.DelayFire - 0.02)
end)

Button("- Fire Speed",function()
	Settings.DelayFire = Settings.DelayFire + 0.02
end)

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)
