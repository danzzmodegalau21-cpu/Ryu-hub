--// RYU HUB MOBILE V14 |

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ===================== STATE =====================
local STATE = {
    SmoothAssist = false,

    AssistPower = 0.42,     -- aman (0.15–0.6)
    AssistSmooth = 0.22,    -- makin kecil makin halus
    Stability = 0.65,

    PerfMode = true,
    FPSGuard = true,
    TargetFPS = 60,

    -- dynamic
    _blend = 0,
    _fpsAvg = 60,
    _fpsMin = 60,
    _frameSamples = {},
    _lastSample = 0,

    -- guards
    ThermalGuard = true,
    AdaptiveLook = true,
    Throttle = 1.0,

    -- profiles
    Profile = "Balanced", -- Ultra | Balanced | Lite

    LastTick = 0,
    Idle = false,
}

-- ===================== VISUAL BASE =====================
local function applyVisual(level)
    -- level: 1 Lite | 2 Balanced | 3 Ultra
    pcall(function()
        Lighting.GlobalShadows = (level == 3)
        Lighting.FogEnd = 1e9
        Lighting.Brightness = (level >= 2) and 2 or 1.8
        Lighting.EnvironmentDiffuseScale = (level == 3) and 0.25 or 0
        Lighting.EnvironmentSpecularScale = (level == 3) and 0.25 or 0
    end)
end
applyVisual(2)

-- ===================== GUI ROOT =====================
local Gui = Instance.new("ScreenGui")
Gui.Name = "RyuHubV14"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = PG

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(390, 500)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(16,18,26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 22)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 1
Stroke.Transparency = 0.45
Stroke.Color = Color3.fromRGB(120,140,255)

local Grad = Instance.new("UIGradient", Main)
Grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28,30,48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14,16,24))
}
Grad.Rotation = 90

-- HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1,-24,1,0)
Title.Position = UDim2.fromOffset(12,0)
Title.BackgroundTransparency = 1
Title.Text = "RYU HUB • V14 NO-MORE-UPGRADES"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(240,245,255)
Title.TextXAlignment = Left

-- BODY
local Body = Instance.new("Frame", Main)
Body.Position = UDim2.fromOffset(0,70)
Body.Size = UDim2.new(1,0,1,-110)
Body.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Body)
UIList.Padding = UDim.new(0,12)
UIList.HorizontalAlignment = Center

-- COMPONENTS
local function Card(h)
    local c = Instance.new("Frame", Body)
    c.Size = UDim2.new(1,-28,0,h)
    c.BackgroundColor3 = Color3.fromRGB(22,24,36)
    c.BorderSizePixel = 0
    Instance.new("UICorner", c).CornerRadius = UDim.new(0,18)
    local s = Instance.new("UIStroke", c)
    s.Thickness = 1
    s.Transparency = 0.6
    s.Color = Color3.fromRGB(90,110,180)
    return c
end

local function Label(p, t)
    local l = Instance.new("TextLabel", p)
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(16,12)
    l.Size = UDim2.new(1,-32,0,22)
    l.Text = t
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextColor3 = Color3.fromRGB(235,235,245)
    l.TextXAlignment = Left
    return l
end

local function Toggle(p, text, y, cb)
    local wrap = Instance.new("Frame", p)
    wrap.Position = UDim2.fromOffset(16,y)
    wrap.Size = UDim2.new(1,-32,0,36)
    wrap.BackgroundTransparency = 1

    local t = Instance.new("TextLabel", wrap)
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(1,-64,1,0)
    t.Text = text
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(205,210,225)
    t.TextXAlignment = Left

    local btn = Instance.new("TextButton", wrap)
    btn.Size = UDim2.fromOffset(52,26)
    btn.Position = UDim2.new(1,-52,0.5,-13)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(235,235,245)
    btn.BackgroundColor3 = Color3.fromRGB(55,60,80)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,13)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = on and Color3.fromRGB(90,120,255) or Color3.fromRGB(55,60,80)
        }):Play()
        btn.Text = on and "ON" or "OFF"
        cb(on)
    end)
end

-- CARDS
local C1 = Card(120)
Label(C1, "🔥 Smooth Assist")
Toggle(C1, "Smooth Assist (NO TAP)", 50, function(v) STATE.SmoothAssist = v end)

local C2 = Card(160)
Label(C2, "⚡ Performance Suite")
Toggle(C2, "Adaptive FPS Guard", 50, function(v) STATE.FPSGuard = v end)
Toggle(C2, "Thermal Guard", 90, function(v) STATE.ThermalGuard = v end)
Toggle(C2, "Adaptive Look", 130, function(v) STATE.AdaptiveLook = v end)

local C3 = Card(120)
Label(C3, "🎛️ Profiles")
local prof = Instance.new("TextButton", C3)
prof.Position = UDim2.fromOffset(16,50)
prof.Size = UDim2.new(1,-32,0,36)
prof.Text = "Balanced"
prof.Font = Enum.Font.GothamBold
prof.TextSize = 13
prof.TextColor3 = Color3.fromRGB(235,235,245)
prof.BackgroundColor3 = Color3.fromRGB(55,60,80)
Instance.new("UICorner", prof).CornerRadius = UDim.new(0,14)

local order = {"Ultra","Balanced","Lite"}
local idx = 2
local function applyProfile(name)
    STATE.Profile = name
    if name=="Ultra" then
        STATE.AssistPower=0.5; STATE.AssistSmooth=0.2; STATE.TargetFPS=60; applyVisual(3)
    elseif name=="Balanced" then
        STATE.AssistPower=0.42; STATE.AssistSmooth=0.22; STATE.TargetFPS=60; applyVisual(2)
    else
        STATE.AssistPower=0.3; STATE.AssistSmooth=0.28; STATE.TargetFPS=45; applyVisual(1)
    end
    prof.Text = name
end
applyProfile("Balanced")
prof.MouseButton1Click:Connect(function()
    idx = idx%#order + 1
    applyProfile(order[idx])
end)

local C4 = Card(110)
Label(C4, "📊 Live Monitor")
local mon = Instance.new("TextLabel", C4)
mon.BackgroundTransparency = 1
mon.Position = UDim2.fromOffset(16,50)
mon.Size = UDim2.new(1,-32,0,44)
mon.Font = Enum.Font.Gotham
mon.TextSize = 12
mon.TextColor3 = Color3.fromRGB(185,190,210)
mon.TextXAlignment = Left
mon.TextYAlignment = Top
mon.Text = "FPS Avg: 60\nFPS Min: 60"

-- IDLE DETECT
UserInputService.InputBegan:Connect(function() STATE.Idle=false end)
UserInputService.InputEnded:Connect(function() STATE.Idle=false end)

-- CORE LOOP (FAIL-SAFE)
local function step()
    local now = os.clock()

    -- perf sampling
    local dt = now - (STATE._lastSample~=0 and STATE._lastSample or now)
    STATE._lastSample = now
    local fps = math.clamp(1/math.max(dt,1/240), 1, 240)
    table.insert(STATE._frameSamples, fps)
    if #STATE._frameSamples>30 then table.remove(STATE._frameSamples,1) end
    local sum, minv = 0, fps
    for _,v in ipairs(STATE._frameSamples) do sum+=v; if v<minv then minv=v end end
    STATE._fpsAvg = math.floor(sum/#STATE._frameSamples)
    STATE._fpsMin = math.floor(minv)
    mon.Text = ("FPS Avg: %d\nFPS Min: %d"):format(STATE._fpsAvg, STATE._fpsMin)

    -- adaptive throttle
    STATE.Throttle = 1.0
    if STATE.FPSGuard and STATE._fpsAvg < STATE.TargetFPS then STATE.Throttle = 1.3 end
    if STATE.ThermalGuard and STATE._fpsMin < 30 then STATE.Throttle = 1.6 end

    -- adaptive look
    if STATE.AdaptiveLook then
        if STATE._fpsAvg < 40 then applyVisual(1)
        elseif STATE._fpsAvg < 55 then applyVisual(2)
        else applyVisual(3) end
    end

    local base = (STATE.PerfMode and 0.03 or 0.05) * STATE.Throttle
    if now - STATE.LastTick < base then return end
    STATE.LastTick = now

    -- SMOOTH ASSIST (NO INPUT)
    if STATE.SmoothAssist then
        local target = STATE.Stability * STATE.AssistPower
        STATE._blend = STATE._blend + (target - STATE._blend) * STATE.AssistSmooth
    else
        STATE._blend *= 0.9
    end
end

RunService.RenderStepped:Connect(step)

-- FOOTER
local Foot = Instance.new("TextLabel", Main)
Foot.BackgroundTransparency = 1
Foot.Size = UDim2.new(1,0,0,26)
Foot.Position = UDim2.new(0,0,1,-28)
Foot.Text = "V14 • NO MORE UPGRADES • SAFE MODE"
Foot.Font = Enum.Font.Gotham
Foot.TextSize = 11
Foot.TextColor3 = Color3.fromRGB(150,155,175)
