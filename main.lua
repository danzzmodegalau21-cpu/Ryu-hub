--==================================================
-- RYU HUB | free not buy
-- FULL REWRITE | DASHBOARD SESUAI PERMINTAAN
--==================================================

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--==================================================
-- AUTO REMOTE DETECT
--==================================================
local Remote = {}
local function find(keys)
    for _,v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            for _,k in ipairs(keys) do
                if n:find(k) then return v end
            end
        end
    end
end

Remote.Fish   = find({"fish","fishing","catch"})
Remote.Sell   = find({"sell"})
Remote.Fav    = find({"fav","lock"})
Remote.Weather= find({"weather"})
Remote.Coin   = find({"coin","money"})

--==================================================
-- SETTINGS
--==================================================
local Set = {
    Mode = "None", -- Instant / V1 / V2
    Power = {Instant=1, V1=3, V2=999},
    Delay = {Instant=0.3, V1=0.15, V2=0},

    AutoSell=false,
    AutoFav=false,
    AutoWeather=false,
    SavePos=false,
    Freeze=false,
}

--==================================================
-- GUI BASE
--==================================================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name="RYU_HUB"
gui.ResetOnSpawn=false

-- LOGO TO OPEN
local logoBtn = Instance.new("TextButton", gui)
logoBtn.Size=UDim2.new(0,120,0,40)
logoBtn.Position=UDim2.new(0,20,0.5,-20)
logoBtn.Text="🔥 Ryu Hub"
logoBtn.Font=Enum.Font.GothamBold
logoBtn.TextSize=14
logoBtn.BackgroundColor3=Color3.fromRGB(120,0,160)
logoBtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",logoBtn).CornerRadius=UDim.new(0,10)

-- MAIN DASHBOARD
local main = Instance.new("Frame", gui)
main.Size=UDim2.new(0,520,0,360)
main.Position=UDim2.new(0.5,-260,0.5,-180)
main.BackgroundColor3=Color3.fromRGB(140,0,180)
main.Visible=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)

local inner = Instance.new("Frame", main)
inner.Size=UDim2.new(1,-20,1,-60)
inner.Position=UDim2.new(0,10,0,50)
inner.BackgroundColor3=Color3.fromRGB(60,60,60)
Instance.new("UICorner",inner).CornerRadius=UDim.new(0,12)

-- EXIT
local exit = Instance.new("TextButton", main)
exit.Size=UDim2.new(0,30,0,30)
exit.Position=UDim2.new(1,-40,0,10)
exit.Text="X"
exit.Font=Enum.Font.GothamBold
exit.TextColor3=Color3.new(1,1,1)
exit.BackgroundColor3=Color3.fromRGB(160,0,0)
Instance.new("UICorner",exit).CornerRadius=UDim.new(1,0)

exit.MouseButton1Click:Connect(function()
    main.Visible=false
end)

logoBtn.MouseButton1Click:Connect(function()
    main.Visible=true
end)

--==================================================
-- MENU BUTTON
--==================================================
local pages={}
local function newPage(name,x)
    local b=Instance.new("TextButton",main)
    b.Size=UDim2.new(0,150,0,30)
    b.Position=UDim2.new(0,x,0,10)
    b.Text=name
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    b.BackgroundColor3=Color3.fromRGB(90,90,90)
    b.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

    local p=Instance.new("Frame",inner)
    p.Size=UDim2.new(1,0,1,0)
    p.Visible=false
    p.BackgroundTransparency=1

    b.MouseButton1Click:Connect(function()
        for _,v in pairs(pages) do v.Visible=false end
        p.Visible=true
    end)

    pages[name]=p
    return p
end

local fishing = newPage("Fishing",10)
local auto    = newPage("Auto",170)
local tp      = newPage("Teleport",330)
fishing.Visible=true

--==================================================
-- BUTTON HELPER
--==================================================
local function btn(parent,text,y,cb)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,260,0,32)
    b.Position=UDim2.new(0,20,0,y)
    b.Text=text
    b.Font=Enum.Font.Gotham
    b.TextSize=13
    b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=Color3.fromRGB(80,80,80)
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.MouseButton1Click:Connect(cb)
end

--==================================================
-- FISHING PAGE
--==================================================
btn(fishing,"Freeze Badan",20,function()
    Set.Freeze=not Set.Freeze
end)

btn(fishing,"Instant Fishing (Halus + OP)",60,function()
    Set.Mode="Instant"
end)

btn(fishing,"Blantat V1 (Sedikit OP)",100,function()
    Set.Mode="V1"
end)

btn(fishing,"Blantat V2 (Sangat OP)",140,function()
    Set.Mode="V2"
end)

--==================================================
-- AUTO PAGE
--==================================================
btn(auto,"Auto Sell",20,function() Set.AutoSell=not Set.AutoSell end)
btn(auto,"Auto Favorite Rarity",60,function() Set.AutoFav=not Set.AutoFav end)
btn(auto,"Auto Buy Weather",100,function() Set.AutoWeather=not Set.AutoWeather end)
btn(auto,"Save Position",140,function() Set.SavePos=not Set.SavePos end)

--==================================================
-- TELEPORT PAGE
--==================================================
local Islands={
    Spawn=CFrame.new(0,10,0),
    Kohana=CFrame.new(1200,80,-600),
    Tropical=CFrame.new(-850,40,1300),
    Treasure=CFrame.new(2500,60,900)
}

local y=20
for n,cf in pairs(Islands) do
    btn(tp,"Teleport "..n,y,function()
        hrp.CFrame=cf
    end)
    y+=40
end

--==================================================
-- LOOPS
--==================================================
task.spawn(function()
    while task.wait() do
        if Remote.Fish and Set.Mode~="None" then
            Remote.Fish:FireServer({
                Mode="Instant",
                Power=Set.Power[Set.Mode]
            })
            task.wait(Set.Delay[Set.Mode])
        else
            task.wait(0.2)
        end
    end
end)

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
        hrp.Velocity=Vector3.zero
    end
end)

lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

print("RYU HUB | free not buy — LOADED")
