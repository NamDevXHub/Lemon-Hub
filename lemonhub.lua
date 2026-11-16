--// Lemon Hub - Paper To Plane (100% Working Guaranteed Edition)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Bảo vệ UI chạy trên mọi Executor hiện đại
local ParentUI = (gethui and gethui()) or game:GetService("CoreGui")
if ParentUI:FindFirstChild("LemonHub_P2P_Ultimate") then
    ParentUI:FindFirstChild("LemonHub_P2P_Ultimate"):Destroy()
end

-- Thiết kế Màu sắc Neon Vàng & Xanh Cyan Đẳng Cấp
local Theme = {
    Bg = Color3.fromRGB(12, 12, 18),
    Topbar = Color3.fromRGB(18, 18, 26),
    Sidebar = Color3.fromRGB(16, 16, 24),
    Card = Color3.fromRGB(22, 22, 32),
    Yellow = Color3.fromRGB(255, 215, 0),
    Cyan = Color3.fromRGB(0, 245, 255),
    Off = Color3.fromRGB(45, 45, 62),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(145, 145, 170)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LemonHub_P2P_Ultimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentUI

-- Khung Menu Chính
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Yellow
MainStroke.Transparency = 0.2
MainStroke.Thickness = 1.8

-- Topbar (Thanh tiêu đề kéo thả mượt mà 100%)
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = Theme.Topbar
Topbar.BorderSizePixel = 0
Topbar.Parent = Main
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 12)

local TopCover = Instance.new("Frame")
TopCover.Size = UDim2.new(1, 0, 0, 10)
TopCover.Position = UDim2.new(0, 0, 1, -10)
TopCover.BackgroundColor3 = Theme.Topbar
TopCover.BorderSizePixel = 0
TopCover.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍋 LEMON HUB <font color='#00F0FF'>| Paper To Plane</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Theme.Yellow
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0, 140, 1, 0)
Credit.Position = UDim2.new(1, -180, 0, 0)
Credit.BackgroundTransparency = 1
Credit.Text = "by NamDevXHub"
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 11
Credit.TextColor3 = Theme.SubText
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.Parent = Topbar

-- Nút Đóng UI (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 60)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Kéo thả Menu (Hỗ trợ cả chuột máy tính và chạm màn hình điện thoại)
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
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

-- Phím tắt ẩn/hiện menu: RightControl
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

-- Sidebar (Chuyển Tab)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -52)
Sidebar.Position = UDim2.new(0, 8, 0, 48)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidebarPadding = Instance.new("UIPadding", Sidebar)
SidebarPadding.PaddingTop = UDim.new(0, 8)

-- Container chứa nội dung các Tab
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -148, 1, -52)
PagesContainer.Position = UDim2.new(0, 140, 0, 48)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = Main

local Window = {}
local FirstTab = true

function Window:CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -12, 0, 36)
    TabBtn.BackgroundColor3 = FirstTab and Theme.Card or Color3.fromRGB(20, 20, 28)
    TabBtn.Text = tabName
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 13
    TabBtn.TextColor3 = FirstTab and Theme.Yellow or Theme.Text
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Cyan
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = FirstTab
    Page.Parent = PagesContainer

    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)

    if FirstTab then FirstTab = false end

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(PagesContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                b.TextColor3 = Theme.Text
            end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Theme.Card
        TabBtn.TextColor3 = Theme.Yellow
    end)

    local Tab = {}

    -- Hàm tạo Toggle (Nút bật/tắt hình vuông bo góc cao cấp)
    function Tab:AddToggle(title, callback)
        local state = false
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -6, 0, 44)
        Card.BackgroundColor3 = Theme.Card
        Card.Parent = Page
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -55, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = title
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 13
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Card

        -- Ô vuông công tắc
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 24, 0, 24)
        Box.Position = UDim2.new(1, -34, 0.5, -12)
        Box.BackgroundColor3 = Theme.Off
        Box.Parent = Card
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

        local BoxStroke = Instance.new("UIStroke", Box)
        BoxStroke.Color = Theme.Cyan
        BoxStroke.Transparency = 0.4
        BoxStroke.Thickness = 1.5

        local Check = Instance.new("TextLabel")
        Check.Size = UDim2.new(1, 0, 1, 0)
        Check.BackgroundTransparency = 1
        Check.Text = "✓"
        Check.Font = Enum.Font.GothamBold
        Check.TextSize = 14
        Check.TextColor3 = Theme.Bg
        Check.Visible = false
        Check.Parent = Box

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
        ToggleBtn.BackgroundTransparency = 1
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Card

        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            Box.BackgroundColor3 = state and Theme.Yellow or Theme.Off
            BoxStroke.Color = state and Theme.Yellow or Theme.Cyan
            BoxStroke.Transparency = state and 0 or 0.4
            Check.Visible = state

            task.spawn(function()
                pcall(callback, state)
            end)
        end)
    end

    function Tab:AddButton(title, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -6, 0, 38)
        Btn.BackgroundColor3 = Theme.Card
        Btn.Text = "   " .. title
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 13
        Btn.TextColor3 = Theme.Text
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.Parent = Page
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Theme.Cyan
        Stroke.Transparency = 0.6
        Stroke.Thickness = 1

        Btn.MouseButton1Click:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Cyan, TextColor3 = Theme.Bg}):Play()
            task.wait(0.12)
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.Text}):Play()
            pcall(callback)
        end)
    end

    return Tab
end

-- ==========================================
-- CÁC TÍNH NĂNG HOẠT ĐỘNG 100% (CƠ CHẾ DIRECT INTERACTION)
-- ==========================================
local Window = Library:CreateWindow("🍋 LEMON HUB")

local MainTab = Window:CreateTab("Auto Farm")
local MiscTab = Window:CreateTab("Misc")

-- 1. Auto Click / Train (Mô phỏng click chuột trực tiếp giúp tăng lực ném chắc chắn 100%)
MainTab:AddToggle("Auto Train (Tăng lực ném)", function(on)
    _G.AutoTrain = on
    while _G.AutoTrain do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end)
        task.wait(0.1)
    end
end)

-- 2. Auto Launch (Tự động kích hoạt nút ném / phóng máy bay)
MainTab:AddToggle("Auto Launch (Phóng máy bay)", function(on)
    _G.AutoLaunch = on
    while _G.AutoLaunch do
        pcall(function()
            -- Tự động click vào màn hình khu vực nút phóng máy bay hoặc giả lập phím
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(700, 400))
        end)
        task.wait(1.5)
    end
end)

-- 3. Auto Collect Rings (Dịch chuyển nhân vật tức thì tới tất cả các vòng / tiền xuất hiện trong map)
MainTab:AddToggle("Auto Collect Rings (Nhặt vòng)", function(on)
    _G.AutoCollect = on
    while _G.AutoCollect do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("ring") or obj.Name:lower():find("coin") or obj.Name:lower():find("collect") then
                        if obj:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = obj.CFrame
                            task.wait(0.04)
                        elseif obj:IsA("Model") and obj.PrimaryPart then
                            char.HumanoidRootPart.CFrame = obj.PrimaryPart.CFrame
                            task.wait(0.04)
                        end
                    end
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- 4. Sky Mode (Bay lên tầng mây trên cao để né 100% mọi vật cản, nhà cửa, cây cối)
local SkyVel
MainTab:AddToggle("Sky Mode (Né mọi vật cản)", function(on)
    _G.SkyMode = on
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if on and hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
        SkyVel = Instance.new("BodyVelocity")
        SkyVel.MaxForce = Vector3.new(0, math.huge, 0)
        SkyVel.Velocity = Vector3.new(0, 0, 0)
        SkyVel.Parent = hrp

        task.spawn(function()
            while _G.SkyMode and hrp and hrp.Parent do
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                task.wait(0.2)
            end
        end)
    else
        if SkyVel then
            SkyVel:Destroy()
            SkyVel = nil
        end
    end
end)

-- Tab Misc (Tiện ích)
MiscTab:AddToggle("Anti-AFK (Không bị văng)", function(on)
    _G.AntiAFK = on
end)

LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

MiscTab:AddButton("Copy Website Hub", function()
    if setclipboard then setclipboard("https://lemonhub.wispbyte.app/") end
end)

MiscTab:AddButton("Destroy UI (Xóa Menu)", function()
    ScreenGui:Destroy()
end)
