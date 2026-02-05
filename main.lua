--==================================================
-- RYU HUB | FINAL AUTO FISH + INSTANT v2
-- Game : Fist It (Fishing)
-- Executor : DELTA
-- NO KEY | NO TAP | 1 LOOP
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- STATE
local State = {
    AutoFish = false,
    AutoEquip = false,
    Instant = true
}

-- ===== INSTANT FISHING v2 SETTINGS =====
local Settings = {
    Mode = "FAST",     -- SAFE / FAST / MAX
    Delay = 0.45,      -- akan di-set oleh preset
    MinDelay = 0.22,
    MaxDelay = 0.9,
    AdaptStep = 0.03,
    BurstCount = 2,
    BurstCooldown = 0.9
}

-- STORAGE (AUTO DETECT)
local FishRemote, FishArgs
local lastFire, lastBurst = 0, 0

--================ AUTO DETECT REMOTE + ARGS =================--
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" and self:IsA("RemoteEvent") then
        if not FishRemote then
            FishRemote = self
            FishArgs = args
            warn("[RYU HUB] Fishing Remote Detected:", self:GetFullName())
        end
    end
    return oldNamecall(self, ...)
end)

--================ UI (LNX STYLE) =================--
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "RYUHUB_FINAL"

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,130,0,42)
logo.Position = UDim2.new(0,15,0.5,-21)
logo.Text = "🎣 RYU HUB"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 14
logo.TextColor3 = Color3.fromRGB(255,255,255)
logo.BackgroundColor3 = Color3.fromRGB(95,0,165)
logo.BorderSizePixel = 0
Instance.new("UICorner", logo).CornerRadius = UDim.new(0,20)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,360,0,320)
main.Position = UDim2.new(0.5,-180,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(28,28,28)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,44)
title.Text = "RYU HUB — AUTO FISH"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

local function Button(text, y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,-40,0,42)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local btnFish   = Button("Auto Fishing : OFF", 60)
local btnEquip  = Button("Auto Equip : OFF", 115)
local btnMode   = Button("Mode : FAST", 170)

btnFish.MouseButton1Click:Connect(function()
    State.AutoFish = not State.AutoFish
    btnFish.Text = "Auto Fishing : "..(State.AutoFish and "ON" or "OFF")
end)

btnEquip.MouseButton1Click:Connect(function()
    State.AutoEquip = not State.AutoEquip
    btnEquip.Text = "Auto Equip : "..(State.AutoEquip and "ON" or "OFF")
end)

btnMode.MouseButton1Click:Connect(function()
    if Settings.Mode == "SAFE" then
        Settings.Mode = "FAST"
    elseif Settings.Mode == "FAST" then
        Settings.Mode = "MAX"
    else
        Settings.Mode = "SAFE"
    end
    btnMode.Text = "Mode : "..Settings.Mode
end)

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

--================ INSTANT v2 CORE (GACOR BUT SAFE) =================--
local function applyPreset()
    if Settings.Mode == "SAFE" then
        Settings.Delay = 0.8
        Settings.BurstCount = 1
    elseif Settings.Mode == "FAST" then
        Settings.Delay = 0.45
        Settings.BurstCount = 2
    elseif Settings.Mode == "MAX" then
        Settings.Delay = 0.25
        Settings.BurstCount = 3
    end
end

applyPreset()

RunService.Heartbeat:Connect(function()
    -- Auto Equip (aman)
    if State.AutoEquip then
        pcall(function()
            local tool = lp.Backpack:FindFirstChildOfClass("Tool")
            if tool and lp.Character then tool.Parent = lp.Character end
        end)
    end

    -- Auto Fish v2
    if not (State.AutoFish and FishRemote and FishArgs) then return end

    applyPreset()

    local now = tick()
    if now - lastFire < Settings.Delay then return end
    lastFire = now

    -- SMART BURST
    if now - lastBurst >= Settings.BurstCooldown then
        lastBurst = now
        for i = 1, Settings.BurstCount do
            pcall(function()
                FishRemote:FireServer(unpack(FishArgs))
            end)
            task.wait(0.03)
        end
    else
        pcall(function()
            FishRemote:FireServer(unpack(FishArgs))
        end)
    end

    -- ADAPTIVE DELAY (auto makin efisien)
    Settings.Delay = math.clamp(
        Settings.Delay - Settings.AdaptStep,
        Settings.MinDelay,
        Settings.MaxDelay
    )
end)
