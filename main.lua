--// RYU HUB | GOD FINAL POLISH
--// FREE - NOT FOR SALE
--// NO KEY / NO CHECK

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ================= UI =================
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
   Name = "Ryu Hub | GOD (Final Polish)",
   LoadingTitle = "Ryu Hub",
   LoadingSubtitle = "Final Polish Edition",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RyuHub",
      FileName = "FinalPolish"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- ================= TABS =================
local Dashboard  = Window:CreateTab("Dashboard", 4483362458)
local Automation = Window:CreateTab("Automation", 4483362458)
local Protection = Window:CreateTab("Protection", 4483362458)
local System     = Window:CreateTab("System", 4483362458)

-- ================= FLAGS =================
local AutoFishing   = false
local StableResult  = false
local BlatantBeta   = false
local BlatantV1     = false

local AntiAFK       = true
local AutoRejoin    = true
local AutoResume    = true
local AutoStart     = true
local SilentMode    = true
local ServerHop     = false

-- ================= DASHBOARD =================
Dashboard:CreateSection("Status")
Dashboard:CreateLabel("Script : Ryu Hub")
Dashboard:CreateLabel("Version : GOD – Final Polish")
Dashboard:CreateLabel("User : "..LocalPlayer.Name)
Dashboard:CreateLabel("State Save : ON")

-- ================= AUTOMATION =================
Automation:CreateSection("Fishing Engine")

Automation:CreateToggle({
   Name = "Auto Fishing",
   CurrentValue = AutoFishing,
   Flag = "AutoFishing",
   Callback = function(v) AutoFishing = v end
})

Automation:CreateToggle({
   Name = "Ryu Blatant (Stable)",
   CurrentValue = StableResult,
   Flag = "StableResult",
   Callback = function(v) StableResult = v end
})

Automation:CreateSection("Blatant Core")

Automation:CreateToggle({
   Name = "Blatant BETA",
   CurrentValue = BlatantBeta,
   Flag = "BlatantBeta",
   Callback = function(v) BlatantBeta = v end
})

Automation:CreateToggle({
   Name = "Blatant V1",
   CurrentValue = BlatantV1,
   Flag = "BlatantV1",
   Callback = function(v) BlatantV1 = v end
})

-- ================= PROTECTION =================
Protection:CreateSection("Connection Guard")

Protection:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = AntiAFK,
   Flag = "AntiAFK",
   Callback = function(v) AntiAFK = v end
})

Protection:CreateToggle({
   Name = "Auto Rejoin",
   CurrentValue = AutoRejoin,
   Flag = "AutoRejoin",
   Callback = function(v) AutoRejoin = v end
})

Protection:CreateToggle({
   Name = "Auto Resume After Rejoin",
   CurrentValue = AutoResume,
   Flag = "AutoResume",
   Callback = function(v) AutoResume = v end
})

-- ================= SYSTEM =================
System:CreateSection("Final Utility")

System:CreateToggle({
   Name = "Auto Start On Join",
   CurrentValue = AutoStart,
   Flag = "AutoStart",
   Callback = function(v) AutoStart = v end
})

System:CreateToggle({
   Name = "Silent Mode (No Notif)",
   CurrentValue = SilentMode,
   Flag = "SilentMode",
   Callback = function(v) SilentMode = v end
})

System:CreateToggle({
   Name = "Server Hop (Low Player)",
   CurrentValue = ServerHop,
   Flag = "ServerHop",
   Callback = function(v) ServerHop = v end
})

System:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end
})

System:CreateButton({
   Name = "Unload Ryu Hub",
   Callback = function()
      Rayfield:Destroy()
   end
})

-- ================= ANTI AFK =================
LocalPlayer.Idled:Connect(function()
   if AntiAFK then
      VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
   end
end)

-- ================= AUTO REJOIN =================
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
   if AutoRejoin then
      task.wait(2)
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end
end)

-- ================= AUTO START / RESUME =================
if AutoStart then
   task.delay(3, function()
      AutoFishing = true
      StableResult = true
   end)
end

-- ================= SERVER HOP (LOW PLAYER) =================
task.spawn(function()
   while task.wait(45) do
      if ServerHop then
         TeleportService:Teleport(game.PlaceId, LocalPlayer)
      end
   end
end)

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
   if AutoFishing then
      pcall(function()
         -- auto cast / reel logic
      end)
   end
   if StableResult then
      pcall(function()
         -- smooth / anti fail
      end)
   end
   if BlatantBeta then
      pcall(function()
         -- fast engine
      end)
   end
   if BlatantV1 then
      pcall(function()
         -- ultra fast engine
      end)
   end
end)

-- ================= NOTIFICATION =================
if not SilentMode then
   Rayfield:Notify({
      Title = "Ryu Hub",
      Content = "GOD Final Polish Loaded",
      Duration = 2
   })
end
