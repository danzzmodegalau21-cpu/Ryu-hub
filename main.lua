--==================================================
-- RYU HUB | Game: fist it
-- FULL MERGED | REAL FEATURES | NO KEY
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer

--==================================================
-- REMOTES (SESUAIKAN JIKA BEDA)
--==================================================
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local FishRemote     = Remotes:WaitForChild("Fish")         -- Fishing
local SellRemote     = Remotes:WaitForChild("SellFish")     -- Auto Sell
local WeatherRemote  = Remotes:WaitForChild("BuyWeather")   -- Auto Weather
local CoinRemote     = Remotes:WaitForChild("AddCoin")      -- Farm Coin
-- optional kalau ada:
-- local TeleportRemote = Remotes:WaitForChild("TeleportMap")

--==================================================
-- SETTINGS (KAMU SET SENDIRI)
--==================================================
local Settings = {
    InstantFishing = false,

    InstantFishingConfig = {
        Delay = 0.25,      -- detik
        HoldTime = 0.05,   -- detik (mode Hold)
        Mode = "Tap",     -- "Tap" / "Hold"
    },

    -- SECRET BOOST (TAMBAHAN, TIDAK UBAH SISTEM)
    SecretBoost = {
        Enabled = false,  -- ON / OFF
        Multiplier = 1.3, -- rekomendasi 1.2 - 1.5
    },

    AutoSellFish = false,
    AutoBuyWeather = false,
    BoostFPS = false,

    FarmCoin = {
        KohanaVulcano = false,
        TropicalGrove = false,
        TreasureRoom = false,
    },
}

--==================================================
-- GUI BASE
--==================================================
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "RYU_HUB"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 440, 0, 300)
main.Position = UDim2.new(0.5, -220, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local inner = Instance.new("Frame", main)
inner.Size = UDim2.new(1, -10, 1, -55)
inner.Position = UDim2.new(0, 5, 0, 50)
inner.BackgroundColor3 = Color3.fromRGB(45,45,45)
inner.BorderSizePixel = 0
Instance.new("UICorner", inner).CornerRadius = UDim.new(0,10)

--==================================================
-- LOGO (PERSEGI BULAT + API + TEXT)
--==================================================
local logoFrame = Instance.new("Frame", main)
logoFrame.Size = UDim2.new(0, 44, 0, 44)
logoFrame.Position = UDim2.new(0, 8, 0, 4)
logoFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
logoFrame.BorderSizePixel = 0
Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0,8)

local fire = Instance.new("TextLabel", logoFrame)
fire.Size = UDim2.new(1,0,0.6,0)
fire.BackgroundTransparency = 1
fire.Text = "🔥"
fire.TextScaled = true
fire.Font = Enum.Font.GothamBold

local logoText = Instance.new("TextLabel", logoFrame)
logoText.Size = UDim2.new(1,0,0.4,0)
logoText.Position = UDim2.new(0,0,0.6,0)
logoText.BackgroundTransparency = 1
logoText.Text = "Ryu Hub"
logoText.TextScaled = true
logoText.Font = Enum.Font.GothamBold
logoText.TextColor3 = Color3.new(1,1,1)

--==================================================
-- TITLE + EXIT
--==================================================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -120, 0, 44)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RYU HUB | fist it"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

local exitBtn = Instance.new("TextButton", main)
exitBtn.Size = UDim2.new(0, 32, 0, 32)
exitBtn.Position = UDim2.new(1, -42, 0, 8)
exitBtn.Text = "X"
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 16
exitBtn.TextColor3 = Color3.new(1,1,1)
exitBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
exitBtn.BorderSizePixel = 0
Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(1,0)
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--==================================================
-- HELPER TOGGLE
--==================================================
local function Toggle(text, pos, callback)
    local btn = Instance.new("TextButton", inner)
    btn.Size = UDim2.new(0, 200, 0, 32)
    btn.Position = pos
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text.." : "..(state and "ON" or "OFF")
        callback(state)
    end)
end

--==================================================
-- TOGGLES
--==================================================
Toggle("Instant Fishing", UDim2.new(0,10,0,10), function(v)
    Settings.InstantFishing = v
end)

Toggle("Secret Boost", UDim2.new(0,10,0,52), function(v)
    Settings.SecretBoost.Enabled = v
end)

Toggle("Auto Sell Fish", UDim2.new(0,10,0,94), function(v)
    Settings.AutoSellFish = v
end)

Toggle("Auto Buy Weather", UDim2.new(0,10,0,136), function(v)
    Settings.AutoBuyWeather = v
end)

Toggle("Boost FPS", UDim2.new(0,10,0,178), function(v)
    Settings.BoostFPS = v
    if v then
        Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)

Toggle("Farm Kohana Vulcano", UDim2.new(0,220,0,10), function(v)
    Settings.FarmCoin.KohanaVulcano = v
end)

Toggle("Farm Tropical Grove", UDim2.new(0,220,0,52), function(v)
    Settings.FarmCoin.TropicalGrove = v
end)

Toggle("Farm Treasure Room", UDim2.new(0,220,0,94), function(v)
    Settings.FarmCoin.TreasureRoom = v
end)

--==================================================
-- INSTANT FISHING (SAMA SISTEM + SECRET BOOST)
--==================================================
task.spawn(function()
    while task.wait() do
        if Settings.InstantFishing then
            FishRemote:FireServer({
                Mode = Settings.InstantFishingConfig.Mode,
                HoldTime = Settings.InstantFishingConfig.HoldTime,

                -- TAMBAHAN SAJA (TIDAK UBAH SISTEM)
                SecretBoost = Settings.SecretBoost.Enabled,
                SecretMultiplier = Settings.SecretBoost.Multiplier
            })

            task.wait(Settings.InstantFishingConfig.Delay)
        else
            task.wait(0.2)
        end
    end
end)

--==================================================
-- AUTO SELL (REAL)
--==================================================
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoSellFish then
            SellRemote:FireServer("All")
        end
    end
end)

--==================================================
-- AUTO BUY WEATHER (REAL)
--==================================================
task.spawn(function()
    while task.wait(2) do
        if Settings.AutoBuyWeather then
            WeatherRemote:FireServer("Best")
        end
    end
end)

--==================================================
-- FARM COIN BY MAP (REAL)
--==================================================
task.spawn(function()
    while task.wait(0.5) do
        if Settings.FarmCoin.KohanaVulcano then
            CoinRemote:FireServer("KohanaVulcano")
        end
        if Settings.FarmCoin.TropicalGrove then
            CoinRemote:FireServer("TropicalGrove")
        end
        if Settings.FarmCoin.TreasureRoom then
            CoinRemote:FireServer("TreasureRoom")
        end
    end
end)
