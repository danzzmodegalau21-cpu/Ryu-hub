--==================================================
-- RYU HUB | FREE NOT BUY
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--==================================================
-- REMOTE DETECT (STABLE)
--==================================================
local function find(keys)
    for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            for _,k in ipairs(keys) do
                if n:find(k) then
                    return v
                end
            end
        end
    end
end

local Remote = {}
local function refreshRemote()
    Remote.Fish    = find({"fish","fishing","catch"})
    Remote.Sell    = find({"sell"})
    Remote.Fav     = find({"fav","lock"})
    Remote.Weather = find({"weather"})
end
refreshRemote()

--==================================================
-- SETTINGS (LEGIT OP)
--==================================================
local Set = {
    Mode = "V1", -- Instant / V1 / V2

    Config = {
        Instant = { Power = 1.15, Delay = 0.30 },
        V1      = { Power = 4.2,  Delay = 0.14 },
        V2      = { Power = 850,  Delay = 0.04 }
    },

    AutoSell = false,
    AutoFav = false,
    AutoWeather = false,
    Freeze = false
}

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "RYU_HUB"
gui.ResetOnSpawn = false

-- LOGO
local logoBtn = Instance.new("TextButton", gui)
logoBtn.Size = UDim2.new(0,44,0,44)
logoBtn.Position = UDim2.new(0,20,0.5,-22)
logoBtn.Text = "🔥"
logoBtn.TextSize = 20
logoBtn.Font = Enum.Font.GothamBold
logoBtn.BackgroundColor3 = Color3.fromRGB(120,0,160)
logoBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",logoBtn).CornerRadius = UDim.new(0,12)

local logoStroke = Instance.new("UIStroke", logoBtn)
logoStroke.Color = Color3.fromRGB(200,130,255)
logoStroke.Thickness = 1.5

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,520,0,320)
main.Position = UDim2.new(0.5,-260,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(135,0,175)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

local inner = Instance.new("Frame", main)
inner.Size = UDim2.new(1,-14,1,-54)
inner.Position = UDim2.new(0,7,0,45)
inner.BackgroundColor3 = Color3.fromRGB(55,55,55)
Instance.new("UICorner",inner).CornerRadius = UDim.new(0,12)

-- EXIT
local exit = Instance.new("TextButton", main)
exit.Size = UDim2.new(0,26,0,26)
exit.Position = UDim2.new(1,-34,0,10)
exit.Text = "X"
exit.Font = Enum.Font.GothamBold
exit.TextSize = 13
exit.TextColor3 = Color3.new(1,1,1)
exit.BackgroundColor3 = Color3.fromRGB(170,40,40)
Instance.new("UICorner",exit).CornerRadius = UDim.new(1,0)

exit.MouseButton1Click:Connect(function()
    main.Visible = false
end)
logoBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

--==================================================
-- PAGE
--==================================================
local pages = {}
local function newPage(name,x)
    local b = Instance.new("TextButton",main)
    b.Size = UDim2.new(0,150,0,26)
    b.Position = UDim2.new(0,x,0,10)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BackgroundColor3 = Color3.fromRGB(85,85,85)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,7)

    local p = Instance.new("Frame",inner)
    p.Size = UDim2.new(1,0,1,0)
    p.Visible = false
    p.BackgroundTransparency = 1

    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(100,100,100)
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(85,85,85)
    end)

    b.MouseButton1Click:Connect(function()
        for _,v in pairs(pages) do v.Visible = false end
        p.Visible = true
    end)

    pages[name] = p
    return p
end

local auto = newPage("Auto",10)
auto.Visible = true

local function btn(parent,text,y,cb)
    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.new(0,260,0,30)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(75,75,75)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(95,95,95)
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(75,75,75)
    end)

    b.MouseButton1Click:Connect(cb)
end

-- AUTO PAGE
btn(auto,"Auto Sell",20,function()
    Set.AutoSell = not Set.AutoSell
end)

btn(auto,"Auto Favorite",60,function()
    Set.AutoFav = not Set.AutoFav
end)

btn(auto,"Auto Weather",100,function()
    Set.AutoWeather = not Set.AutoWeather
end)

--==================================================
-- AUTO FISHING (STABLE + LEGIT)
--==================================================
task.spawn(function()
    while task.wait() do
        if not Remote.Fish then
            refreshRemote()
            task.wait(1)
        elseif Set.Mode ~= "None" then
            local cfg = Set.Config[Set.Mode]
            Remote.Fish:FireServer({
                Mode = Set.Mode,
                Power = cfg.Power
            })
            task.wait(cfg.Delay + math.random() * 0.03)
        end
    end
end)

--==================================================
-- AUTO SYSTEM
--==================================================
task.spawn(function()
    while task.wait(1) do
        if Set.AutoSell and Remote.Sell then
            Remote.Sell:FireServer("All")
        end
        if Set.AutoFav and Remote.Fav then
            Remote.Fav:FireServer({"Rare","Epic","Legend","Secret"})
        end
        if Set.AutoWeather and Remote.Weather then
            Remote.Weather:FireServer("Best")
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Set.Freeze then
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end)

lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

print("RYU HUB | PERFECT 10/10 UI + STABLE — LOADED")
