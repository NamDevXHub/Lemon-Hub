--[[
    =====================================================================
      LEMON HUB  -  by NamDevXHub
      Game : Paper to Plane (Roblox)
      UI   : Rayfield (Sirius)          Phím K : ẩn / hiện menu
    =====================================================================
    Ghi chú:
      * Đây là bản "chung": không phụ thuộc tên Remote của game, nên dùng
        được cho các game clicker / simulator ném máy bay giấy.
      * Muốn thêm tính năng riêng cho game (Auto Sell, Auto Hatch...), thêm
        vào mục "TÍNH NĂNG RIÊNG CỦA GAME" ở cuối file.
]]

---------------------------------------------------------------------
-- 0. CHỐNG CHẠY TRÙNG
---------------------------------------------------------------------
local env = (getgenv and getgenv()) or _G
if env.LemonHubDestroy then
    pcall(env.LemonHubDestroy)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

---------------------------------------------------------------------
-- 1. SERVICES & BIẾN CHUNG
---------------------------------------------------------------------
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local VirtualUser        = game:GetService("VirtualUser")
local TeleportService    = game:GetService("TeleportService")
local HttpService        = game:GetService("HttpService")
local Lighting           = game:GetService("Lighting")
local StarterGui         = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")

local VIM
pcall(function()
    VIM = game:GetService("VirtualInputManager")
end)

local LocalPlayer = Players.LocalPlayer

local HUB_NAME   = "Lemon Hub"
local HUB_AUTHOR = "NamDevXHub"
local GAME_TITLE = "Paper to Plane"
local ICON       = 4483362458

local State = {
    -- Farm
    AutoClick     = false,
    ClickMode     = "Auto",
    CPS           = 8,
    ClickX        = 50,
    ClickY        = 88,
    AutoButton    = false,
    ButtonKeyword = "",
    ButtonDelay   = 1,
    -- Nhân vật
    SpeedOn = false,
    Speed   = 50,
    JumpOn  = false,
    Jump    = 100,
    InfJump = false,
    Noclip  = false,
    -- Khác
    AntiAFK = true,
}

local alive       = true
local connections = {}
local savedCFrame = nil
local lightBackup = nil
local Rayfield    = nil

local function track(conn)
    table.insert(connections, conn)
    return conn
end

---------------------------------------------------------------------
-- 2. TẢI GIAO DIỆN RAYFIELD
---------------------------------------------------------------------
local okLib, lib = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not okLib or not lib then
    warn("[Lemon Hub] Không tải được Rayfield: " .. tostring(lib))
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = HUB_NAME,
            Text     = "Không tải được giao diện. Kiểm tra mạng hoặc executor!",
            Duration = 6,
        })
    end)
    return
end
Rayfield = lib

---------------------------------------------------------------------
-- 3. HÀM TIỆN ÍCH
---------------------------------------------------------------------
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title    = title or HUB_NAME,
            Content  = content or "",
            Duration = duration or 4,
            Image    = ICON,
        })
    end)
end

local function getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local gameName = GAME_TITLE
pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- Click / ném ------------------------------------------------------
local function doClick()
    local mode = State.ClickMode
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")

    if tool and (mode == "Auto" or mode == "Tool Activate") then
        pcall(function() tool:Activate() end)
        return
    end
    if mode == "Tool Activate" then return end

    local cam = workspace.CurrentCamera
    if not (VIM and cam) then return end
    local size = cam.ViewportSize
    local x = size.X * State.ClickX / 100
    local y = size.Y * State.ClickY / 100
    pcall(function()
        VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
end

-- Nút GUI ----------------------------------------------------------
local function isShown(gui)
    local cur = gui
    while cur and cur ~= game do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("LayerCollector") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return true
end

local function buttonText(btn)
    if btn:IsA("TextButton") then
        return btn.Text
    end
    local lbl = btn:FindFirstChildWhichIsA("TextLabel", true)
    return lbl and lbl.Text or ""
end

local function collectButtons(keyword)
    local result = {}
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return result end
    keyword = string.lower(keyword or "")

    for _, g in ipairs(pg:GetDescendants()) do
        if g:IsA("GuiButton") and isShown(g) then
            local sg = g:FindFirstAncestorOfClass("ScreenGui")
            if not (sg and string.find(sg.Name, "Rayfield", 1, true)) then
                if keyword == "" then
                    table.insert(result, g)
                else
                    local name = string.lower(g.Name)
                    local text = string.lower(buttonText(g))
                    if string.find(name, keyword, 1, true) or string.find(text, keyword, 1, true) then
                        table.insert(result, g)
                    end
                end
            end
        end
    end
    return result
end

local function pressButton(btn)
    for _, sig in ipairs({ btn.MouseButton1Click, btn.Activated }) do
        if firesignal then
            pcall(firesignal, sig)
        elseif getconnections then
            local ok, list = pcall(getconnections, sig)
            if ok and list then
                for _, c in ipairs(list) do
                    pcall(function() c:Fire() end)
                end
            end
        end
    end
end

local function dumpButtons()
    local list = collectButtons("")
    local shown = math.min(#list, 150)
    print(("[Lemon Hub] Có %d nút đang hiển thị:"):format(#list))
    for i = 1, shown do
        local b = list[i]
        print(("%d) Name=%s | Text=%s | %s"):format(i, b.Name, buttonText(b), b:GetFullName()))
    end
    notify("Danh sách nút", "Đã in " .. shown .. " nút ra console (nhấn F9 để xem).", 5)
end

-- Nhân vật ---------------------------------------------------------
local function restoreSpeed()
    local hum = getHum()
    if hum then hum.WalkSpeed = State.OrigSpeed or 16 end
end

local function restoreJump()
    local hum = getHum()
    if hum then
        hum.JumpPower = State.OrigJump or 50
        if State.OrigUseJump ~= nil then
            hum.UseJumpPower = State.OrigUseJump
        end
    end
end

-- Ánh sáng / đồ họa ------------------------------------------------
local function setFullbright(on)
    if on then
        lightBackup = {
            Brightness     = Lighting.Brightness,
            ClockTime      = Lighting.ClockTime,
            FogEnd         = Lighting.FogEnd,
            GlobalShadows  = Lighting.GlobalShadows,
            Ambient        = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
        }
        Lighting.Brightness     = 2
        Lighting.ClockTime      = 14
        Lighting.FogEnd         = 100000
        Lighting.GlobalShadows  = false
        Lighting.Ambient        = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    elseif lightBackup then
        for k, v in pairs(lightBackup) do
            pcall(function() Lighting[k] = v end)
        end
        lightBackup = nil
    end
end

local function fpsBoost()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() Lighting.GlobalShadows = false end)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
            or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("BasePart") and not v:IsA("Terrain") then
            v.CastShadow = false
            v.Material = Enum.Material.SmoothPlastic
        end
        count = count + 1
        if count % 2000 == 0 then task.wait() end
    end
    notify("FPS Boost", "Đã giảm đồ họa để game mượt hơn.")
end

-- Server -----------------------------------------------------------
local function rejoin()
    notify("Rejoin", "Đang vào lại server...")
    if #Players:GetPlayers() <= 1 then
        LocalPlayer:Kick("\nLemon Hub: đang vào lại game...")
        task.wait()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

local function serverHop()
    notify("Server Hop", "Đang tìm server khác...")
    local ok, data = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId)
            .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if ok and type(data) == "table" and data.data then
        for _, s in ipairs(data.data) do
            if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
    end
    notify("Server Hop", "Không tìm được server phù hợp, thử lại sau nhé.")
end

-- Hủy hub ----------------------------------------------------------
local function destroyHub()
    alive = false
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}

    if State.SpeedOn then restoreSpeed() end
    if State.JumpOn then restoreJump() end
    setFullbright(false)

    pcall(function() Rayfield:Destroy() end)
    env.LemonHubDestroy = nil
end
env.LemonHubDestroy = destroyHub

---------------------------------------------------------------------
-- 4. LOGIC (vòng lặp & kết nối)
---------------------------------------------------------------------
-- Auto click
task.spawn(function()
    while alive do
        if State.AutoClick then
            doClick()
            task.wait(1 / math.max(State.CPS, 1))
        else
            task.wait(0.2)
        end
    end
end)

-- Auto bấm nút GUI
task.spawn(function()
    while alive do
        if State.AutoButton and State.ButtonKeyword ~= "" then
            local list = collectButtons(State.ButtonKeyword)
            for i = 1, math.min(#list, 10) do
                pressButton(list[i])
            end
            task.wait(State.ButtonDelay)
        else
            task.wait(0.3)
        end
    end
end)

-- WalkSpeed / JumpPower (giữ giá trị khi game cố reset)
track(RunService.Heartbeat:Connect(function()
    if not (State.SpeedOn or State.JumpOn) then return end
    local hum = getHum()
    if not hum then return end
    if State.SpeedOn and hum.WalkSpeed ~= State.Speed then
        hum.WalkSpeed = State.Speed
    end
    if State.JumpOn then
        if not hum.UseJumpPower then hum.UseJumpPower = true end
        if hum.JumpPower ~= State.Jump then hum.JumpPower = State.Jump end
    end
end))

-- Infinite Jump
track(UserInputService.JumpRequest:Connect(function()
    if not State.InfJump then return end
    local hum = getHum()
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

-- Noclip
track(RunService.Stepped:Connect(function()
    if not State.Noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end))

-- Anti AFK
track(LocalPlayer.Idled:Connect(function()
    if not State.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end))

---------------------------------------------------------------------
-- 5. GIAO DIỆN
---------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = HUB_NAME .. " | " .. HUB_AUTHOR,
    Icon = 0,
    LoadingTitle = HUB_NAME,
    LoadingSubtitle = "by " .. HUB_AUTHOR,
    ShowText = HUB_NAME,
    Theme = "AmberGlow",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ===== TAB: THÔNG TIN =====
local InfoTab = Window:CreateTab("Thông tin", ICON)
InfoTab:CreateSection(HUB_NAME)
InfoTab:CreateParagraph({
    Title = HUB_NAME .. " - " .. HUB_AUTHOR,
    Content = "Hub dành cho " .. GAME_TITLE .. ". Nhấn phím K để ẩn/hiện menu.",
})
InfoTab:CreateLabel("Game: " .. tostring(gameName))
InfoTab:CreateLabel("PlaceId: " .. tostring(game.PlaceId))
InfoTab:CreateLabel("Người chơi: " .. LocalPlayer.DisplayName)
InfoTab:CreateSection("Lưu ý")
InfoTab:CreateParagraph({
    Title = "Khuyến cáo",
    Content = "Dùng script có thể vi phạm Điều khoản của Roblox và bị khóa tài khoản. Nên dùng acc phụ.",
})

-- ===== TAB: FARM =====
local FarmTab = Window:CreateTab("Farm", ICON)

FarmTab:CreateSection("Auto Click / Ném máy bay")
FarmTab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Callback = function(v)
        State.AutoClick = v
    end,
})
FarmTab:CreateSlider({
    Name = "Tốc độ click",
    Range = {1, 25},
    Increment = 1,
    Suffix = " lần/giây",
    CurrentValue = State.CPS,
    Callback = function(v)
        State.CPS = v
    end,
})
FarmTab:CreateDropdown({
    Name = "Kiểu click",
    Options = {"Auto", "Screen Click", "Tool Activate"},
    CurrentOption = {"Auto"},
    MultipleOptions = false,
    Callback = function(opt)
        State.ClickMode = (type(opt) == "table" and opt[1]) or opt or "Auto"
    end,
})
FarmTab:CreateSlider({
    Name = "Vị trí click - ngang (X)",
    Range = {5, 95},
    Increment = 1,
    Suffix = " %",
    CurrentValue = State.ClickX,
    Callback = function(v)
        State.ClickX = v
    end,
})
FarmTab:CreateSlider({
    Name = "Vị trí click - dọc (Y)",
    Range = {5, 95},
    Increment = 1,
    Suffix = " %",
    CurrentValue = State.ClickY,
    Callback = function(v)
        State.ClickY = v
    end,
})
FarmTab:CreateParagraph({
    Title = "Gợi ý",
    Content = "Auto: đang cầm Tool thì dùng Tool, không thì click vào màn hình. Hãy chọn vị trí click nằm ngoài menu hub và ngoài các nút của game.",
})

FarmTab:CreateSection("Auto bấm nút GUI (Rebirth, Upgrade, Hatch...)")
FarmTab:CreateInput({
    Name = "Tên / chữ trên nút",
    CurrentValue = "",
    PlaceholderText = "VD: Rebirth (gõ xong nhấn Enter)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        State.ButtonKeyword = tostring(text or "")
    end,
})
FarmTab:CreateSlider({
    Name = "Chờ giữa các lần bấm",
    Range = {0.3, 10},
    Increment = 0.1,
    Suffix = " giây",
    CurrentValue = State.ButtonDelay,
    Callback = function(v)
        State.ButtonDelay = v
    end,
})
FarmTab:CreateToggle({
    Name = "Auto bấm nút",
    CurrentValue = false,
    Callback = function(v)
        if v and State.ButtonKeyword == "" then
            notify("Auto bấm nút", "Hãy nhập tên/chữ trên nút trước nhé.")
        end
        if v and not (firesignal or getconnections) then
            notify("Auto bấm nút", "Executor của bạn không hỗ trợ firesignal/getconnections.", 6)
        end
        State.AutoButton = v
    end,
})
FarmTab:CreateButton({
    Name = "In danh sách nút đang hiện (xem ở F9)",
    Callback = dumpButtons,
})

-- ===== TAB: NHÂN VẬT =====
local PlayerTab = Window:CreateTab("Nhân vật", ICON)
local speedToggle, jumpToggle, infJumpToggle, noclipToggle

PlayerTab:CreateSection("Tốc độ & nhảy")
speedToggle = PlayerTab:CreateToggle({
    Name = "Bật WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        if v then
            local hum = getHum()
            if hum then State.OrigSpeed = hum.WalkSpeed end
            State.SpeedOn = true
        else
            State.SpeedOn = false
            restoreSpeed()
        end
    end,
})
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = State.Speed,
    Callback = function(v)
        State.Speed = v
    end,
})
jumpToggle = PlayerTab:CreateToggle({
    Name = "Bật JumpPower",
    CurrentValue = false,
    Callback = function(v)
        if v then
            local hum = getHum()
            if hum then
                State.OrigJump = hum.JumpPower
                State.OrigUseJump = hum.UseJumpPower
            end
            State.JumpOn = true
        else
            State.JumpOn = false
            restoreJump()
        end
    end,
})
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = State.Jump,
    Callback = function(v)
        State.Jump = v
    end,
})

PlayerTab:CreateSection("Di chuyển")
infJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump (nhảy vô hạn)",
    CurrentValue = false,
    Callback = function(v)
        State.InfJump = v
    end,
})
noclipToggle = PlayerTab:CreateToggle({
    Name = "Noclip (xuyên tường)",
    CurrentValue = false,
    Callback = function(v)
        State.Noclip = v
    end,
})
PlayerTab:CreateButton({
    Name = "Tắt hết tính năng nhân vật",
    Callback = function()
        for _, t in ipairs({ speedToggle, jumpToggle, infJumpToggle, noclipToggle }) do
            pcall(function() t:Set(false) end)
        end
        notify("Nhân vật", "Đã tắt các tính năng nhân vật.")
    end,
})

-- ===== TAB: DỊCH CHUYỂN =====
local TpTab = Window:CreateTab("Dịch chuyển", ICON)
TpTab:CreateSection("Vị trí đã lưu")
TpTab:CreateButton({
    Name = "Lưu vị trí hiện tại",
    Callback = function()
        local hrp = getHRP()
        if hrp then
            savedCFrame = hrp.CFrame
            notify("Dịch chuyển", "Đã lưu vị trí hiện tại.")
        else
            notify("Dịch chuyển", "Không tìm thấy nhân vật.")
        end
    end,
})
TpTab:CreateButton({
    Name = "Dịch chuyển tới vị trí đã lưu",
    Callback = function()
        local hrp = getHRP()
        if hrp and savedCFrame then
            hrp.CFrame = savedCFrame
        else
            notify("Dịch chuyển", "Chưa có vị trí nào được lưu.")
        end
    end,
})

-- ===== TAB: KHÁC =====
local MiscTab = Window:CreateTab("Khác", ICON)
MiscTab:CreateSection("Tiện ích")
MiscTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,
    Callback = function(v)
        State.AntiAFK = v
    end,
})
MiscTab:CreateToggle({
    Name = "Fullbright (sáng toàn map)",
    CurrentValue = false,
    Callback = function(v)
        setFullbright(v)
    end,
})
MiscTab:CreateButton({
    Name = "FPS Boost (giảm đồ họa)",
    Callback = function()
        task.spawn(fpsBoost)
    end,
})

MiscTab:CreateSection("Server")
MiscTab:CreateButton({
    Name = "Rejoin (vào lại server)",
    Callback = function()
        task.spawn(rejoin)
    end,
})
MiscTab:CreateButton({
    Name = "Server Hop (đổi server)",
    Callback = function()
        task.spawn(serverHop)
    end,
})

MiscTab:CreateSection("Hub")
MiscTab:CreateButton({
    Name = "Hủy " .. HUB_NAME,
    Callback = destroyHub,
})

---------------------------------------------------------------------
-- 6. TÍNH NĂNG RIÊNG CỦA GAME
---------------------------------------------------------------------
-- Thêm tính năng dành riêng cho Paper to Plane ở đây, ví dụ:
--
-- FarmTab:CreateToggle({
--     Name = "Tên tính năng",
--     CurrentValue = false,
--     Callback = function(v)
--         -- viết logic của bạn ở đây
--     end,
-- })

notify(HUB_NAME, "Đã tải xong! Nhấn K để ẩn/hiện menu.", 5)
