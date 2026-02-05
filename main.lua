--==================================================
-- RYUHUB | FREE NO KEY KHUSUS DELTA
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

--==================================================
-- CONFIG & PROFILE
--==================================================
local PLACE_KEY = "RyuHub_Profile_" .. game.PlaceId

local function LoadProfile()
    if isfile and isfile(PLACE_KEY..".json") then
        return HttpService:JSONDecode(readfile(PLACE_KEY..".json"))
    end
    return {}
end

local function SaveProfile(tbl)
    if writefile then
        writefile(PLACE_KEY..".json", HttpService:JSONEncode(tbl))
    end
end

local Profile = LoadProfile()

local Config = {
    AutoFish = false,
    CastDelay = 0.45,
    StrikeDelay = 0.12,
    Mode = "Safe",      -- Safe / Fast
    Chance = 85,        -- % peluang strike sukses
    MultiMin = 1,
    MultiMax = 3
}

--==================================================
-- FLOATING LOGO
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyuFloating"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local FloatBtn = Instance.new("TextButton")
FloatBtn.Parent = ScreenGui
FloatBtn.Size = UDim2.new(0,50,0,50)
FloatBtn.Position = UDim2.new(1,-70,0.5,-25)
FloatBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
FloatBtn.Text = "RYU"
FloatBtn.TextColor3 = Color3.fromRGB(230,230,230)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
FloatBtn.BorderSizePixel = 0
FloatBtn.Visible = false

local Corner = Instance.new("UICorner",FloatBtn)
Corner.CornerRadius = UDim.new(1,0)
local Stroke = Instance.new("UIStroke",FloatBtn)
Stroke.Color = Color3.fromRGB(120,0,180)
Stroke.Thickness = 1.5

-- Drag
local dragging, dragStart, startPos
FloatBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=i.Position
        startPos=FloatBtn.Position
    end
end)
FloatBtn.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dragStart
        FloatBtn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

--==================================================
-- CREATE UI (FULL LNX)
--==================================================
local Rayfield
local function CreateUI()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
    local Window = Rayfield:CreateWindow({
        Name="RYU HUB",
        LoadingTitle="RYU HUB",
        LoadingSubtitle="LNX Style Dashboard",
        ConfigurationSaving={Enabled=true, FolderName="RyuHub", FileName="Config"},
        KeySystem=false
    })

    local TabDash = Window:CreateTab("Dashboard")
    local TabAuto = Window:CreateTab("Automation")
    local TabTp = Window:CreateTab("Teleport")
    local TabMisc = Window:CreateTab("Misc")
    local TabSet = Window:CreateTab("Settings")

    -- Dashboard
    TabDash:CreateParagraph({
        Title="RYU HUB",
        Content="FINAL LNX STYLE\nClean • Stable • Professional\nInstant Fishing + Auto-Detect + Logo Floating"
    })

    -- AUTOMATION
    TabAuto:CreateSection("🎣 Fishing Automation")
    TabAuto:CreateToggle({
        Name="Instant Fishing",
        CurrentValue=Config.AutoFish,
        Callback=function(v)
            Config.AutoFish=v
            Rayfield:Notify({
                Title="RYU HUB",
                Content=v and "Instant Fishing ON" or "Instant Fishing OFF",
                Duration=2
            })
        end
    })

    TabAuto:CreateSection("⚙️ Fishing Settings")
    TabAuto:CreateSlider({
        Name="Cast Delay", Range={0,1}, Increment=0.05,
        CurrentValue=Config.CastDelay,
        Callback=function(v) Config.CastDelay=v end
    })
    TabAuto:CreateSlider({
        Name="Strike Delay", Range={0,1}, Increment=0.05,
        CurrentValue=Config.StrikeDelay,
        Callback=function(v) Config.StrikeDelay=v end
    })
    TabAuto:CreateDropdown({
        Name="Mode", Options={"Safe","Fast"}, CurrentOption=Config.Mode,
        Callback=function(v) Config.Mode=v end
    })
    TabAuto:CreateSection("🎯 Advanced (LNX)")
    TabAuto:CreateSlider({Name="Chance (%)", Range={1,100}, Increment=1, CurrentValue=Config.Chance, Callback=function(v) Config.Chance=v end})
    TabAuto:CreateSlider({Name="Multi Catch (Min)", Range={1,10}, Increment=1, CurrentValue=Config.MultiMin, Callback=function(v) Config.MultiMin=v end})
    TabAuto:CreateSlider({Name="Multi Catch (Max)", Range={1,10}, Increment=1, CurrentValue=Config.MultiMax, Callback=function(v) Config.MultiMax=v end})

    -- AUTO-DETECT / SAVE REMOTE
    TabAuto:CreateSection("🔎 Remote Fishing")
    TabAuto:CreateButton({Name="Start Scan (Template)", Callback=function()
        Rayfield:Notify({Title="RYU HUB", Content="Scan started. Do fishing once.", Duration=3})
        -- FLAG scan aktif (template)
    end})
    TabAuto:CreateButton({Name="Save Selected Remote", Callback=function()
        -- Profile.FishingRemote="PATH_REMOTE_YANG_KAMU_PILIH"
        SaveProfile(Profile)
        Rayfield:Notify({Title="RYU HUB", Content="Remote saved for this game.", Duration=3})
    end})
    TabAuto:CreateButton({Name="Reset Remote", Callback=function()
        Profile.FishingRemote=nil
        SaveProfile(Profile)
        Rayfield:Notify({Title="RYU HUB", Content="Remote reset. You can rescan.", Duration=3})
    end})

    -- TELEPORT
    TabTp:CreateSection("📍 Quick Teleport")
    TabTp:CreateButton({Name="Teleport to Spawn", Callback=function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame=CFrame.new(0,5,0)
        end
    end})

    -- MISC
    TabMisc:CreateSection("🧩 Misc")
    TabMisc:CreateButton({Name="Rejoin Server", Callback=function()
        TeleportService:Teleport(game.PlaceId, lp)
    end})

    -- SETTINGS
    TabSet:CreateSection("UI")
    TabSet:CreateButton({Name="Hide UI", Callback=function()
        FloatBtn.Visible=true
        Rayfield:Notify({Title="RYU HUB", Content="UI Hidden — Tap Logo to Open", Duration=2})
        Rayfield:Destroy()
    end})
end

-- Tap logo → open UI
FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible=false
    CreateUI()
end)

-- INIT UI
CreateUI()

--==================================================
-- CORE LOOP – MODE 6 FULL LNX
--==================================================
math.randomseed(os.clock())
local function rollChance(p) return math.random(1,100)<=p end

task.spawn(function()
    while task.wait() do
        if Config.AutoFish then
            local castDelay, strikeDelay = Config.CastDelay, Config.StrikeDelay
            if Config.Mode=="Fast" then
                castDelay=math.max(0, castDelay-0.15)
                strikeDelay=math.max(0, strikeDelay-0.05)
            end

            -- CAST
            task.wait(castDelay)

            -- STRIKE (Chance)
            if rollChance(Config.Chance) then
                task.wait(strikeDelay)
                local count=math.random(math.min(Config.MultiMin,Config.MultiMax), math.max(Config.MultiMin,Config.MultiMax))
                for i=1,count do
                    -- 🔌 TARUH REMOTE FISHING DI SINI
                    -- local FishingRemote=Profile.FishingRemote and loadstring("return "..Profile.FishingRemote)()
                    -- FishingRemote:FireServer(...)
                    task.wait(0.03)
                end
            else
                task.wait(0.08) -- natural miss
            end
        end
    end
end)
