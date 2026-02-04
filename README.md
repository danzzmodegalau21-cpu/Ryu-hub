-- ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

math.randomseed(os.clock() * 1e6)

local Config = {
	FishTimeDefault = 0.3,
	FishCooldown = 0.1,

	BaseSecretChance = 0.003,
	PityStep = 0.0015,
	PityMax = 0.03,

	BaseFishAmount = 1,
	BonusFishChance = 0.4,
	BonusFishMin = 2,
	BonusFishMax = 4,

	MinRodMultiplier = 10,
	MaxRodMultiplier = 15,
}

local FishTime = ReplicatedStorage:FindFirstChild("FishTime")
if not FishTime then
	FishTime = Instance.new("NumberValue")
	FishTime.Name = "FishTime"
	FishTime.Value = Config.FishTimeDefault
	FishTime.Parent = ReplicatedStorage
end

local FishRequest = ReplicatedStorage:FindFirstChild("FishRequest")
	or Instance.new("RemoteEvent", ReplicatedStorage)
FishRequest.Name = "FishRequest"

local TeleportRequest = ReplicatedStorage:FindFirstChild("TeleportRequest")
	or Instance.new("RemoteEvent", ReplicatedStorage)
TeleportRequest.Name = "TeleportRequest"

local pity = {}
local cooldown = {}
local TeleportSpots = {}

local function canFish(player)
	local now = os.clock()
	if (cooldown[player] or 0) > now then
		return false
	end
	cooldown[player] = now + Config.FishCooldown
	return true
end

local function secretChance(player)
	return math.clamp(
		Config.BaseSecretChance + (pity[player] or 0),
		0,
		Config.BaseSecretChance + Config.PityMax
	)
end

local function rollSecret(player)
	if math.random() < secretChance(player) then
		pity[player] = 0
		return true
	end
	pity[player] = math.min((pity[player] or 0) + Config.PityStep, Config.PityMax)
	return false
end

local function rollFishAmount()
	local amount = Config.BaseFishAmount
	if math.random() < Config.BonusFishChance then
		amount += math.random(Config.BonusFishMin, Config.BonusFishMax)
	end
	return amount * math.random(Config.MinRodMultiplier, Config.MaxRodMultiplier)
end

FishRequest.OnServerEvent:Connect(function(player)
	if not canFish(player) then return end

	task.wait(math.max(0, FishTime.Value))

	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local fishValue = stats:FindFirstChild("Fish")
	local secretValue = stats:FindFirstChild("SecretFish")

	local fishGain = rollFishAmount()
	if fishValue then
		fishValue.Value += fishGain
	end

	if secretValue and rollSecret(player) then
		secretValue.Value += 1
	end
end)

local function rebuildTeleports()
	table.clear(TeleportSpots)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation")
			or (obj:IsA("BasePart") and obj.Name:lower():find("spawn")) then
			table.insert(TeleportSpots, obj.CFrame)
		end
	end
end

rebuildTeleports()
Workspace.DescendantAdded:Connect(rebuildTeleports)
Workspace.DescendantRemoving:Connect(rebuildTeleports)

TeleportRequest.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or #TeleportSpots == 0 then return end
	hrp.CFrame = TeleportSpots[math.random(#TeleportSpots)]
end)

Players.PlayerRemoving:Connect(function(player)
	pity[player] = nil
	cooldown[player] = nil
end)
