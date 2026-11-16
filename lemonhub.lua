local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    AutoThrow = false,
    ThrowCooldown = 0.6,
    TargetRange = 150,
    ThrowPath = nil,

    AutoDodge = false,
    DodgeRadius = 18,
    DodgeDistance = 8,
    DodgeSensitivity = 0.6,
    DodgeCooldown = 0.35,
    MinThreatSpeed = 15,
}

local Alive = true
local SpyEnabled = false
local Connections = {}
local RemoteStore = {}
local LastCapturedPath = nil
local lastThrow = 0
local lastDodge = 0

local dodgeParams = OverlapParams.new()
dodgeParams.FilterType = Enum.RaycastFilterType.Exclude

local function describe(v)
    local t = typeof(v)
    if t == "Vector3" then
        return string.format("Vector3(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
    elseif t == "CFrame" then
        local p = v.Position
        return string.format("CFrame(%.2f, %.2f, %.2f)", p.X, p.Y, p.Z)
    elseif t == "Instance" then
        return v:GetFullName()
    elseif t == "table" then
        return "table"
    else
        return t .. ": " .. tostring(v)
    end
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if SpyEnabled and (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
        pcall(function()
            local path = self:GetFullName()
            local args = table.pack(...)
            local prev = RemoteStore[path]
            RemoteStore[path] = {
                Remote = self,
                Args = args,
                Method = method,
                Count = (prev and prev.Count or 0) + 1,
            }
            LastCapturedPath = path
        end)
    end
    return oldNamecall(self, ...)
end))

local function fireStored(path)
    local entry = path and RemoteStore[path]
    if not entry or not entry.Remote or not entry.Remote.Parent then
        return false, "remote không tồn tại"
    end
    return pcall(function()
        if entry.Method == "InvokeServer" then
            entry.Remote:InvokeServer(table.unpack(entry.Args, 1, entry.Args.n))
        else
            entry.Remote:FireServer(table.unpack(entry.Args, 1, entry.Args.n))
        end
    end)
end

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

    if Config.ThrowPath then
        local ok = fireStored(Config.ThrowPath)
        if ok then
            lastThrow = os.clock()
        end
        return
    end

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

local function getRemoteOptions()
    local list = {}
    for path in pairs(RemoteStore) do
        table.insert(list, path)
    end
    table.sort(list)
    if #list == 0 then
        list = { "Chưa có remote" }
    end
    return list
end

local function buildLogText()
    local paths = {}
    for path in pairs(RemoteStore) do
        table.insert(paths, path)
    end
    if #paths == 0 then
        return "Chưa bắt được remote nào. Bật Remote Spy rồi ném máy bay một lần."
    end
    table.sort(paths, function(a, b)
        return RemoteStore[a].Count > RemoteStore[b].Count
    end)

    local lines = {}
    for i = 1, math.min(#paths, 8) do
        local path = paths[i]
        local entry = RemoteStore[path]
        local argText = {}
        for j = 1, entry.Args.n do
            table.insert(argText, describe(entry.Args[j]))
        end
        table.insert(lines, string.format("[%d] %s (%s)\n    args: %s",
            entry.Count, path, entry.Method, table.concat(argText, ", ")))
    end
    return table.concat(lines, "\n")
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

local SpyTab = Window:CreateTab("Remote Spy")

SpyTab:CreateToggle({
    Name = "Bật Remote Spy",
    CurrentValue = false,
    Flag = "SpyEnabled",
    Callback = function(value)
        SpyEnabled = value
    end,
})

local LogParagraph = SpyTab:CreateParagraph({
    Title = "Log remote",
    Content = "Chưa có remote nào.",
})

local RemoteDropdown = SpyTab:CreateDropdown({
    Name = "Remote dùng để ném",
    Options = { "Chưa có remote" },
    CurrentOption = { "Chưa có remote" },
    MultipleOptions = false,
    Flag = "ThrowRemote",
    Callback = function(option)
        local choice = type(option) == "table" and option[1] or option
        if choice == "Chưa có remote" then
            Config.ThrowPath = nil
        else
            Config.ThrowPath = choice
        end
    end,
})

SpyTab:CreateButton({
    Name = "Làm mới danh sách",
    Callback = function()
        LogParagraph:Set({ Title = "Log remote", Content = buildLogText() })
        pcall(function()
            RemoteDropdown:Refresh(getRemoteOptions())
        end)
    end,
})

SpyTab:CreateButton({
    Name = "Bắn thử remote đã chọn",
    Callback = function()
        if not Config.ThrowPath then
            Rayfield:Notify({ Title = "Lemon Hub", Content = "Chưa chọn remote.", Duration = 3 })
            return
        end
        local ok, err = fireStored(Config.ThrowPath)
        Rayfield:Notify({
            Title = "Lemon Hub",
            Content = ok and "Đã bắn remote." or ("Lỗi: " .. tostring(err)),
            Duration = 3,
        })
    end,
})

SpyTab:CreateButton({
    Name = "Xóa log",
    Callback = function()
        table.clear(RemoteStore)
        Config.ThrowPath = nil
        LogParagraph:Set({ Title = "Log remote", Content = "Chưa có remote nào." })
        pcall(function()
            RemoteDropdown:Refresh({ "Chưa có remote" })
        end)
    end,
})

table.insert(Connections, task.spawn(function()
    local lastCount = -1
    while Alive do
        task.wait(1.5)
        local count = 0
        for _ in pairs(RemoteStore) do
            count += 1
        end
        if count ~= lastCount then
            lastCount = count
            LogParagraph:Set({ Title = "Log remote", Content = buildLogText() })
            pcall(function()
                RemoteDropdown:Refresh(getRemoteOptions())
            end)
        end
    end
end))

local SettingsTab = Window:CreateTab("Cài đặt")

SettingsTab:CreateButton({
    Name = "Unload Lemon Hub",
    Callback = function()
        Alive = false
        SpyEnabled = false
        Config.AutoThrow = false
        Config.AutoDodge = false
        for _, conn in ipairs(Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        table.clear(Connections)
        table.clear(RemoteStore)
        Rayfield:Destroy()
    end,
})
