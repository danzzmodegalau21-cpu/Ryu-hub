repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

local Profile = {FishingRemote = nil}
local Config = {
    AutoFish = false,
    CastDelay = 0.01,
    StrikeDelay = 0.005,
    Mode = "Ultra",
    Chance = 100,
    MultiMin = 1,
    MultiMax = 10,
    AntiBan = true,
    StealthMode = true
}

local function FindFishingRemote()
    local searchLocations = {ReplicatedStorage, workspace}
    local remoteNames = {
        "FishingRemote", "FishEvent", "CastFishingRod", "ReelFish",
        "Fishing", "Fish", "RodCast", "RodReel", "FishingEvent"
    }
    
    for _, location in ipairs(searchLocations) do
        for _, name in ipairs(remoteNames) do
            local obj = location:FindFirstChild(name)
            if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                Profile.FishingRemote = obj:GetFullName()
                return obj
            end
        end
    end
    return nil
end

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

local dragging, dragStart, startPos
FloatBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = FloatBtn.Position
    end
end)

FloatBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        FloatBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local Rayfield = nil
local function CreateUI()
    local success, rayfieldLib = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
    end)
    
    if not success then
        FloatBtn.Text = "ERR"
        FloatBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    Rayfield = rayfieldLib
    
    local Window = Rayfield:CreateWindow({
        Name = "RYU HUB DELTA",
        LoadingTitle = "RYU HUB DELTA",
        LoadingSubtitle = "ULTRA-POWERED",
        ConfigurationSaving = {Enabled = false},
        KeySystem = false
    })

    local TabDash = Window:CreateTab("Dashboard")
    TabDash:CreateParagraph({
        Title = "🎮 RYU HUB DELTA",
        Content = "ULTRA-POWERED FISHING BOT"
    })
    
    TabDash:CreateLabel("Status: " .. (Profile.FishingRemote and "✅ Remote Found" or "⚠️ Scanning..."))
    TabDash:CreateButton({
        Name = "🔍 Scan Fishing Remote",
        Callback = function()
            local remote = FindFishingRemote()
            if remote then
                Rayfield:Notify({
                    Title = "SUCCESS",
                    Content = "Found: " .. remote.Name,
                    Duration = 5
                })
            else
                Rayfield:Notify({
                    Title = "WARNING",
                    Content = "No fishing remote found!",
                    Duration = 5
                })
            end
        end
    })

    local TabAuto = Window:CreateTab("Automation")
    TabAuto:CreateSection("🎣 Fishing Control")
    
    TabAuto:CreateToggle({
        Name = "⚡ Instant Fishing",
        CurrentValue = Config.AutoFish,
        Callback = function(v)
            Config.AutoFish = v
        end
    })
    
    TabAuto:CreateSection("⚙️ Settings")
    TabAuto:CreateDropdown({
        Name = "Mode",
        Options = {"Safe", "Fast", "Ultra"},
        CurrentOption = Config.Mode,
        Callback = function(v)
            Config.Mode = v
        end
    })
    
    TabAuto:CreateSlider({
        Name = "Success Chance %",
        Range = {1, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = Config.Chance,
        Callback = function(v)
            Config.Chance = v
        end
    })
    
    TabAuto:CreateSlider({
        Name = "Multi Catch",
        Range = {1, 20},
        Increment = 1,
        CurrentValue = Config.MultiMax,
        Callback = function(v)
            Config.MultiMax = v
            Config.MultiMin = math.min(Config.MultiMin, v)
        end
    })

    local TabTp = Window:CreateTab("Teleport")
    TabTp:CreateSection("📍 Locations")
    TabTp:CreateButton({
        Name = "Teleport to Spawn",
        Callback = function()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
            end
        end
    })
    
    TabTp:CreateButton({
        Name = "Teleport to Water",
        Callback = function()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                for _, part in pairs(workspace:GetDescendants()) do
                    if part.Name:lower():find("water") or part.Name:lower():find("sea") then
                        lp.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                        break
                    end
                end
            end
        end
    })

    local TabMisc = Window:CreateTab("Misc")
    TabMisc:CreateSection("🛠️ Utilities")
    TabMisc:CreateButton({
        Name = "🔄 Rejoin Server",
        Callback = function()
            TeleportService:Teleport(game.PlaceId, lp)
        end
    })
    
    TabMisc:CreateButton({
        Name = "📋 Copy Game ID",
        Callback = function()
            pcall(function()
                setclipboard(tostring(game.PlaceId))
                Rayfield:Notify({
                    Title = "COPIED",
                    Content = "Game ID copied to clipboard",
                    Duration = 3
                })
            end)
        end
    })
    
    TabMisc:CreateToggle({
        Name = "🛡️ Anti-AFK",
        CurrentValue = true,
        Callback = function(v)
            if v then
                getgenv().AntiAFK = true
            else
                getgenv().AntiAFK = false
            end
        end
    })

    local TabSet = Window:CreateTab("Settings")
    TabSet:CreateSection("🎨 UI Settings")
    TabSet:CreateButton({
        Name = "🎭 Toggle UI",
        Callback = function()
            if FloatBtn.Visible then
                FloatBtn.Visible = false
            else
                FloatBtn.Visible = true
                if Rayfield then
                    Rayfield:Destroy()
                    Rayfield = nil
                end
            end
        end
    })
    
    TabSet:CreateButton({
        Name = "🗑️ Reset Settings",
        Callback = function()
            Config = {
                AutoFish = false,
                CastDelay = 0.01,
                StrikeDelay = 0.005,
                Mode = "Ultra",
                Chance = 100,
                MultiMin = 1,
                MultiMax = 10,
                AntiBan = true,
                StealthMode = true
            }
        end
    })
end

FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    if not Rayfield then
        CreateUI()
    end
end)

local fishingActive = false
local math_random = math.random

local function GetFishingRemote()
    if Profile.FishingRemote then
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild(Profile.FishingRemote)
            or workspace:FindFirstChild(Profile.FishingRemote)
        return remote
    end
    return FindFishingRemote()
end

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFish and not fishingActive then
            fishingActive = true
            
            local fishingRemote = GetFishingRemote()
            
            if fishingRemote then
                local castDelay = Config.CastDelay
                local strikeDelay = Config.StrikeDelay
                
                if Config.Mode == "Fast" then
                    castDelay = 0.1
                    strikeDelay = 0.05
                elseif Config.Mode == "Ultra" then
                    castDelay = 0
                    strikeDelay = 0
                end
                
                task.wait(castDelay)
                
                if math_random(1, 100) <= Config.Chance then
                    task.wait(strikeDelay)
                    
                    local catchCount = math_random(
                        math.min(Config.MultiMin, Config.MultiMax),
                        math.max(Config.MultiMin, Config.MultiMax)
                    )
                    
                    for i = 1, catchCount do
                        pcall(function()
                            if fishingRemote:IsA("RemoteEvent") then
                                fishingRemote:FireServer("Cast", "Fish")
                                fishingRemote:FireServer("Reel", "Success")
                            elseif fishingRemote:IsA("RemoteFunction") then
                                fishingRemote:InvokeServer("Fish", "Catch")
                            end
                        end)
                        
                        if i < catchCount then
                            task.wait(0.01)
                        end
                    end
                    
                    if Rayfield and Config.AutoFish then
                        Rayfield:Notify({
                            Title = "🐟 FISH CAUGHT",
                            Content = string.format("Caught %d fish!", catchCount),
                            Duration = 2
                        })
                    end
                else
                    task.wait(0.5)
                end
            else
                if Rayfield then
                    Rayfield:Notify({
                        Title = "⚠️ WARNING",
                        Content = "No fishing remote found!",
                        Duration = 3
                    })
                end
                Config.AutoFish = false
                task.wait(5)
            end
            
            fishingActive = false
        end
    end
end)

if Config.AntiBan then
    task.spawn(function()
        while task.wait(math_random(5, 15)) do
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                if math_random(1, 10) == 1 then
                    lp.Character.Humanoid:Move(Vector3.new(
                        math_random(-10, 10),
                        0,
                        math_random(-10, 10)
                    ))
                end
            end
        end
    end)
end

if Config.StealthMode then
    task.spawn(function()
        while task.wait(1) do
            for _, conn in pairs(getconnections(lp.Idled)) do
                if conn.Disable then
                    conn:Disable()
                end
            end
        end
    end)
end

task.spawn(function()
    getgenv().AntiAFK = true
    while task.wait(1) do
        if getgenv().AntiAFK then
            pcall(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

CreateUI()
