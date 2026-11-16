--// Lemon Hub - Paper To Plane (Zero Lag & Smooth UI Edition)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Bảo vệ UI để hiển thị trên mọi Executor mà không bị ẩn nút
local ParentUI = (gethui and gethui()) or game:GetService("CoreGui")
if ParentUI:FindFirstChild("LemonHub_P2P") then
    ParentUI:FindFirstChild("LemonHub_P2P"):Destroy()
end

-- Cấu hình giao diện Neon tối giản, sắc nét
local Theme = {
    Bg = Color3.fromRGB(16, 16, 22),
    Header = Color3.fromRGB(22, 22, 30),
    Card = Color3.fromRGB(26, 26, 36),
    Yellow = Color3.fromRGB(255, 220, 0),
    Cyan = Color3.fromRGB(0, 240, 255),
    Off = Color3.fromRGB(55, 55, 70),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(150, 150, 170)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LemonHub_P2P"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentUI

-- Khung chính (Main Window)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 480, 0, 330)
Main.Position = UDim2.new(0.5, -240, 0.5, -165)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Border = Instance.new("UIStroke", Main)
Border.Color = Theme.Yellow
Border.Thickness = 1.5

-- Thanh tiêu đề (Kéo thả siêu mượt)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local FixBottom = Instance.new("Frame")
FixBottom.Size = UDim2.new(1, 0, 0, 10)
FixBottom.Position = UDim2.new(0, 0, 1, -10)
FixBottom.BackgroundColor3 = Theme.Header
FixBottom.BorderSizePixel = 0
FixBottom.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 280, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍋 LEMON HUB <font color='#00F0FF'>| Paper To Plane</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Theme.Yellow
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0, 120, 1, 0)
Credit.Position = UDim2.new(1, -165, 0, 0)
Credit.BackgroundTransparency = 1
Credit.Text = "by NamDevXHub"
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 11
Credit.TextColor3 = Theme.SubText
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.Parent = Header

-- Nút Thu gọn / Đóng
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hệ thống kéo thả chuẩn xác (Hoạt động cả PC và Mobile)
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Phím tắt RightCtrl ẩn/hiện menu
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

-- Khu vực chứa các nút tính năng (Cuộn mượt)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 1, -58)
Container.Position = UDim2.new(0, 12, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Theme.Cyan
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = Main

local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.Padding = UDim.new(0, 10)

-- Hàm tạo Nút Bật/Tắt (Toggle Switch) rõ nét, bấm cực nhạy
local function CreateToggle(title, desc, callback)
    local state = false
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 52)
    Card.BackgroundColor3 = Theme.Card
    Card.Parent = Container
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Theme.Off
    CardStroke.Thickness = 1

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -80, 0, 22)
    TitleLbl.Position = UDim2.new(0, 14, 0, 6)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Card

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size = UDim2.new(1, -80, 0, 18)
    DescLbl.Position = UDim2.new(0, 14, 0, 27)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Text = desc
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.TextSize = 11
    DescLbl.TextColor3 = Theme.SubText
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.Parent = Card

    -- Công tắc Gạt (Switch Button)
    local SwitchBtn = Instance.new("TextButton")
    SwitchBtn.Size = UDim2.new(0, 48, 0, 24)
    SwitchBtn.Position = UDim2.new(1, -62, 0.5, -12)
    SwitchBtn.BackgroundColor3 = Theme.Off
    SwitchBtn.Text = ""
    SwitchBtn.AutoButtonColor = false
    SwitchBtn.Parent = Card
    Instance.new("UICorner", SwitchBtn).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.Parent = SwitchBtn
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBtn.MouseButton1Click:Connect(function()
        state = not state
        local bg = state and Theme.Yellow or Theme.Off
        local knobPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local strokeColor = state and Theme.Cyan or Theme.Off

        TweenService:Create(SwitchBtn, TweenInfo.new(0.18), {BackgroundColor3 = bg}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.18), {Position = knobPos}):Play()
        CardStroke.Color = strokeColor

        task.spawn(function()
            pcall(callback, state)
        end)
    end)
end

-- ==========================================
-- TÍNH NĂNG HOẠT ĐỘNG THEO CƠ CHẾ MỚI (0% LAG)
-- ==========================================

-- 1. Auto Click / Auto Train (Mô phỏng click chuột thực tế - không quét Remote gây lag)
CreateToggle("Auto Train / Click Nhanh", "Tự động click luyện lực ném liên tục không gây lag", function(on)
    _G.AutoClick = on
    while _G.AutoClick do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(500, 500))
        task.wait(0.08)
    end
end)

-- 2. Auto Launch (Tự động bấm phím Space/Click để ném máy bay)
CreateToggle("Auto Launch (Tự động ném máy bay)", "Tự động kích hoạt phóng máy bay khi ở vạch xuất phát", function(on)
    _G.AutoLaunch = on
    while _G.AutoLaunch do
        pcall(function()
            -- Giả lập nhấn phím Space hoặc Click giữa màn hình để ném
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
        task.wait(1.5)
    end
end)

-- 3. Sky Cruise / Bay cao né mọi vật thể (Cơ chế nâng độ cao an toàn)
local SkyBodyVelocity
CreateToggle("Sky Mode (Bay cao né mọi vật thể)", "Nâng máy bay/nhân vật lên tầng cao để tránh toàn bộ chướng ngại vật", function(on)
    _G.SkyMode = on
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if on and hrp then
        -- Đưa nhân vật lên cao hơn mặt đất 80 studs để né toàn bộ nhà, cây, tường
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 80, 0)
        
        -- Giữ độ cao ổn định và tắt va chạm chỉ trên nhân vật (không quét map -> 0% lag)
        SkyBodyVelocity = Instance.new("BodyVelocity")
        SkyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        SkyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        SkyBodyVelocity.Parent = hrp

        task.spawn(function()
            while _G.SkyMode and hrp and hrp.Parent do
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        if SkyBodyVelocity then
            SkyBodyVelocity:Destroy()
            SkyBodyVelocity = nil
        end
    end
end)

-- 4. Speed Boost (Tăng tốc độ bay / di chuyển)
CreateToggle("Boost Tốc Độ Bay (x2 Speed)", "Tăng tốc độ lao tới của máy bay và nhân vật", function(on)
    _G.SpeedBoost = on
    while _G.SpeedBoost do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 65
            end
        end)
        task.wait(0.3)
    end
    pcall(function()
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end)
end)

-- 5. Anti AFK (Chống văng game)
CreateToggle("Anti-AFK (Treo máy không bị kick)", "Giữ kết nối ổn định khi treo máy farm lâu", function(on)
    _G.AntiAFK = on
end)

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
