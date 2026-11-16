--// Lemon Hub - Paper To Plane (Pro Edition)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Bảo vệ UI chạy trên mọi Executor
local ParentUI = (gethui and gethui()) or game:GetService("CoreGui")
if ParentUI:FindFirstChild("LemonHub_P2P_Pro") then
    ParentUI:FindFirstChild("LemonHub_P2P_Pro"):Destroy()
end

-- Bảng màu Neon Vàng & Xanh Cyan Đẳng cấp
local Theme = {
    Bg = Color3.fromRGB(14, 14, 20),
    Topbar = Color3.fromRGB(20, 20, 28),
    Sidebar = Color3.fromRGB(18, 18, 26),
    Card = Color3.fromRGB(24, 24, 34),
    Yellow = Color3.fromRGB(255, 215, 0),
    Cyan = Color3.fromRGB(0, 245, 255),
    Off = Color3.fromRGB(50, 50, 68),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(145, 145, 170)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LemonHub_P2P_Pro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentUI

-- Khung chính
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 540, 0, 350)
Main.Position = UDim2.new(0.5, -270, 0.5, -175)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Yellow
MainStroke.Transparency = 0.2
MainStroke.Thickness = 1.8

-- Topbar (Kéo thả siêu mượt)
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
Title.Size = UDim2.new(0, 320, 1, 0)
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

-- Nút Đóng (X)
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

-- Kéo thả Menu
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

-- Phím tắt ẩn hiện menu: RightControl
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

-- Sidebar (Chọn Tab)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -52)
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

-- Container chứa các Trang tính năng
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -152, 1, -52)
PagesContainer.Position = UDim2.new(0, 144, 0, 48)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = Main

local Window = {}
local FirstTab = true

function Window:CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -12, 0, 36)
    TabBtn.BackgroundColor3 = FirstTab and Theme.Card or Color3.fromRGB(22, 22, 32)
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
                b.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                b.TextColor3 = Theme.Text
            end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Theme.Card
        TabBtn.TextColor3 = Theme.Yellow
    end)

    local Tab = {}

    -- Hàm tạo Toggle Bật/Tắt (Hình vuông bo góc cao cấp, rõ ràng)
    function Tab:AddToggle(title, callback)
        local state = false
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -6, 0, 44)
        Card.BackgroundColor3 = Theme.Card
        Card.Parent = Page
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
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
        Toggle.Text = ""
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
-- KHỞI TẠO TÍNH NĂNG CHUẨN XÁC CHO PAPER TO PLANE
-- ==========================================
local Window = Library:CreateWindow("🍋 LEMON HUB")

local MainTab = Window:CreateTab("Auto Farm")
local MiscTab = Window:CreateTab("Misc")

-- Hàm tìm RemoteEvent chuẩn xác trong Paper To Plane
local function GetRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find(name:lower()) then
            return v
        end
    end
    return nil
end

-- 1. Auto Train (Luyện tập tăng sức mạnh)
MainTab:AddToggle("Auto Train (Tăng lực ném)", function(on)
    _G.AutoTrain = on
    while _G.AutoTrain do
        pcall(function()
            local remote = GetRemote("Train") or GetRemote("Strength") or GetRemote("Power")
            if remote then remote:FireServer() end
        end)
        task.wait(0.2)
    end
end)

-- 2. Auto Launch (Tự động ném máy bay)
MainTab:AddToggle("Auto Launch (Phóng máy bay)", function(on)
    _G.AutoLaunch = on
    while _G.AutoLaunch do
        pcall(function()
            local remote = GetRemote("Launch") or GetRemote("Fly") or GetRemote("Throw")
            if remote then remote:FireServer(100) end
        end)
        task.wait(1.5)
    end
end)

-- 3. Auto Collect Rings (Tự động nhặt vòng)
MainTab:AddToggle("Auto Collect Rings (Nhặt vòng)", function(on)
    _G.AutoCollect = on
    while _G.AutoCollect do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("ring") or obj.Name:lower():find("coin") then
                        if obj:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = obj.CFrame
                            task.wait(0.05)
                        elseif obj:IsA("Model") and obj.PrimaryPart then
                            char.HumanoidRootPart.CFrame = obj.PrimaryPart.CFrame
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- 4. Auto Dodge / Xuyên vật cản (Né chướng ngại vật)
local dodgeConnection
MainTab:AddToggle("Auto Dodge (Xuyên vật cản)", function(on)
    _G.AutoDodge = on
    if _G.AutoDodge then
        dodgeConnection = RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
                for _, obj in pairs(workspace:GetChildren()) do
                    local n = obj.Name:lower()
                    if n:find("obstacle") or n:find("wall") or n:find("building") or n:find("tree") then
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end
            end)
        end)
    else
        if dodgeConnection then
            dodgeConnection:Disconnect()
            dodgeConnection = nil
        end
    end
end)

-- Tab Misc
MiscTab:AddButton("Copy Website Hub", function()
    if setclipboard then setclipboard("https://lemonhub.wispbyte.app/") end
end)

MiscTab:AddButton("Destroy UI (Xóa Menu)", function()
    ScreenGui:Destroy()
end)
