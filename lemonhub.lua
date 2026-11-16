local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    AutoThrow = false,
    ThrowCooldown = 0.6,
    TargetRange = 150,

    AutoDodge = false,
    DodgeRadius = 18,
    DodgeDistance = 8,
    DodgeSensitivity = 0.6,
    DodgeCooldown = 0.35,
    MinThreatSpeed = 15,
}

local Alive = true
local Connections = {}
local lastThrow = 0
local lastDodge = 0

local dodgeParams = OverlapParams.new()
dodgeParams.FilterType = Enum.RaycastFilterType.Exclude

local function getCharacter()
    return LocalPlayer.Character
end

local function getRoot()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getPlane()
    local char = getCharacter()
    if not char then return nil end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        return equipped
    end

    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local hum = getHumanoid()
    if backpack and hum then
        local tool = backpack:FindFirstChildOfClass("Tool")
        if tool then
            hum:EquipTool(tool)
        end
    end
    return nil
end

local function isEnemy(plr)
    if plr == LocalPlayer then return false end
    if LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end
    return true
end

local function getNearestEnemyRoot()
    local root = getRoot()
    if not root then return nil end

    local best, bestDist = nil, Config.TargetRange
    for _, plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestDist then
                    best = hrp
                    bestDist = d
                end
            end
        end
    end
    return best
end

local function tryThrow()
    if os.clock() - lastThrow < Config.ThrowCooldown then return end

    local root = getRoot()
    if not root then return end

    local plane = getPlane()
    if not plane or plane.Parent ~= getCharacter() then return end

    local target = getNearestEnemyRoot()
    if not target then return end

    local flat = Vector3.new(
        target.Position.X - root.Position.X,
        0,
        target.Position.Z - root.Position.Z
    )
    if flat.Magnitude > 0.1 then
        root.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
    end

    plane:Activate()
    lastThrow = os.clock()
end

local function isCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    while model do
        if model:FindFirstChildOfClass("Humanoid") then
            return true
        end
        model = model.Parent and model.Parent:FindFirstAncestorOfClass("Model")
    end
    return false
end

local function getDodgeDirection(root)
    local char = getCharacter()
    if not char then return nil end

    dodgeParams.FilterDescendantsInstances = { char }
    local parts = workspace:GetPartBoundsInRadius(root.Position, Config.DodgeRadius, dodgeParams)

    for _, part in ipairs(parts) do
        if not part.Anchored and not isCharacterPart(part) then
            local v = part.AssemblyLinearVelocity
            local speed = v.Magnitude

            if speed >= Config.MinThreatSpeed then
                local toRoot = root.Position - part.Position
                if toRoot.Magnitude > 0.1 then
                    local towardness = v.Unit:Dot(toRoot.Unit)
                    if towardness >= Config.DodgeSensitivity then
                        local perp = Vector3.new(-v.Z, 0, v.X)
                        if perp.Magnitude > 0.01 then
                            perp = perp.Unit
                            local side = toRoot:Dot(perp) >= 0 and 1 or -1
                            return perp * side
                        end
                    end
                end
            end
        end
    end

    return nil
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Alive then return end

    if Config.AutoThrow then
        pcall(tryThrow)
    end

    if Config.AutoDodge and os.clock() - lastDodge >= Config.DodgeCooldown then
        local root = getRoot()
        if root then
            local ok, dir = pcall(getDodgeDirection, root)
            if ok and dir then
                root.CFrame = root.CFrame + dir * Config.DodgeDistance
                lastDodge = os.clock()
            end
        end
    end
end))

local Window = Rayfield:CreateWindow({
    Name = "Lemon Hub",
    LoadingTitle = "Lemon Hub",
    LoadingSubtitle = "by Darkwen",
    Theme = "Amber Glow",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Máy bay")

MainTab:CreateSection("Auto ném")

MainTab:CreateToggle({
    Name = "Auto ném máy bay",
    CurrentValue = false,
    Flag = "AutoThrow",
    Callback = function(value)
        Config.AutoThrow = value
    end,
})

MainTab:CreateSlider({
    Name = "Cooldown ném (giây)",
    Range = { 0.1, 3 },
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.6,
    Flag = "ThrowCooldown",
    Callback = function(value)
        Config.ThrowCooldown = value
    end,
})

MainTab:CreateSlider({
    Name = "Tầm ném (studs)",
    Range = { 20, 500 },
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 150,
    Flag = "TargetRange",
    Callback = function(value)
        Config.TargetRange = value
    end,
})

MainTab:CreateSection("Né vật thể")

MainTab:CreateToggle({
    Name = "Auto né vật thể",
    CurrentValue = false,
    Flag = "AutoDodge",
    Callback = function(value)
        Config.AutoDodge = value
    end,
})

MainTab:CreateSlider({
    Name = "Bán kính quét (studs)",
    Range = { 5, 60 },
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 18,
    Flag = "DodgeRadius",
    Callback = function(value)
        Config.DodgeRadius = value
    end,
})

MainTab:CreateSlider({
    Name = "Khoảng né (studs)",
    Range = { 2, 30 },
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 8,
    Flag = "DodgeDistance",
    Callback = function(value)
        Config.DodgeDistance = value
    end,
})

MainTab:CreateSlider({
    Name = "Độ nhạy né (0.1 - 1)",
    Range = { 0.1, 1 },
    Increment = 0.05,
    CurrentValue = 0.6,
    Flag = "DodgeSensitivity",
    Callback = function(value)
        Config.DodgeSensitivity = value
    end,
})

MainTab:CreateSlider({
    Name = "Cooldown né (giây)",
    Range = { 0.1, 1 },
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.35,
    Flag = "DodgeCooldown",
    Callback = function(value)
        Config.DodgeCooldown = value
    end,
})

local SettingsTab = Window:CreateTab("Cài đặt")

SettingsTab:CreateButton({
    Name = "Unload Lemon Hub",
    Callback = function()
        Alive = false
        Config.AutoThrow = false
        Config.AutoDodge = false
        for _, conn in ipairs(Connections) do
            conn:Disconnect()
        end
        table.clear(Connections)
        Rayfield:Destroy()
    end,
})
