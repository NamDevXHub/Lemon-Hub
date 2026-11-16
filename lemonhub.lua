--// Lemon Hub - Paper To Plane Script (Fixed & Enhanced UI)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có để tránh trùng lặp
if CoreGui:FindFirstChild("LemonHub_PaperToPlane") then
    CoreGui:FindFirstChild("LemonHub_PaperToPlane"):Destroy()
end

local Library = {}

-- Bảng màu Neon Vàng & Xanh Cyan (Glassmorphism)
Library.Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 28),
    Element = Color3.fromRGB(28, 28, 38),
    AccentYellow = Color3.fromRGB(255, 225, 0),
    AccentCyan = Color3.fromRGB(0, 240, 255),
    TextLight = Color3.fromRGB(245, 245, 245),
    TextDim = Color3.fromRGB(160, 160, 175)
}

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LemonHub_PaperToPlane"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 540, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.AccentYellow
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- Topbar (Thanh tiêu đề & Kéo thả)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 42)
    Topbar.BackgroundColor3 = Library.Theme.Sidebar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 320, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.RichText = true
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextColor3 = Library.Theme.AccentYellow
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    local Credit = Instance.new("TextLabel")
    Credit.Size = UDim2.new(0, 150, 1, 0)
    Credit.Position = UDim2.new(1, -190, 0, 0)
    Credit.BackgroundTransparency = 1
    Credit.Text = "by NamDevXHub"
    Credit.Font = Enum.Font.GothamMedium
    Credit.TextSize = 12
    Credit.TextColor3 = Library.Theme.TextDim
    Credit.TextXAlignment = Enum.TextXAlignment.Right
    Credit.Parent = Topbar

    -- Nút Đóng UI & Phím tắt RightControl ẩn hiện
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Parent = Topbar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Kéo thả cửa sổ mượt mà
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Sidebar chứa Tab
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 135, 1, -52)
    Sidebar.Position = UDim2.new(0, 6, 0, 46)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.Parent = Sidebar

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -150, 1, -52)
    PagesContainer.Position = UDim2.new(0, 145, 0, 46)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame

    local Window = {}
    local FirstTab = true

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = FirstTab and Library.Theme.AccentYellow or Library.Theme.Sidebar
        TabBtn.Text = "  " .. tabName
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = FirstTab and Color3.fromRGB(15, 15, 20) or Library.Theme.TextLight
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Library.Theme.AccentCyan
        Page.Visible = FirstTab
        Page.Parent = PagesContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        if FirstTab then FirstTab = false end

        TabBtn.MouseButton1Click:Connect(function()
            for _, page in pairs(PagesContainer:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Library.Theme.Sidebar
                    btn.TextColor3 = Library.Theme.TextLight
                end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Library.Theme.AccentYellow
            TabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
        end)

        local Tab = {}

        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -8, 0, 36)
            Btn.BackgroundColor3 = Library.Theme.Element
            Btn.Text = "  " .. text
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextColor3 = Library.Theme.TextLight
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke", Btn)
            Stroke.Color = Library.Theme.AccentCyan
            Stroke.Transparency = 0.8

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.AccentCyan}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Element}):Play()
                pcall(callback)
            end)
        end

        -- Thiết kế lại nút Toggle: Hình vuông bo góc, có viền nét căng hiện đại
        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -8, 0, 38)
            Toggle.BackgroundColor3 = Library.Theme.Element
            Toggle.Text = ""
            Toggle.Parent = Page
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Library.Theme.TextLight
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle

            -- Khung vuông bo góc làm công tắc
            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 22, 0, 22)
            Box.Position = UDim2.new(1, -32, 0.5, -11)
            Box.BackgroundColor3 = state and Library.Theme.AccentYellow or Color3.fromRGB(38, 38, 50)
            Box.Parent = Toggle
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)

            local BoxStroke = Instance.new("UIStroke", Box)
            BoxStroke.Color = state and Library.Theme.AccentYellow or Library.Theme.AccentCyan
            BoxStroke.Transparency = state and 0 or 0.5
            BoxStroke.Thickness = 1.5

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                local targetColor = state and Library.Theme.AccentYellow or Color3.fromRGB(38, 38, 50)
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                BoxStroke.Color = state and Library.Theme.AccentYellow or Library.Theme.AccentCyan
                BoxStroke.Transparency = state and 0 or 0.5
                pcall(callback, state)
            end)
        end

        return Tab
    end

    return Window
end

-- ==========================================
-- KHỞI TẠO GIAO DIỆN & TÍNH NĂNG PAPER TO PLANE
-- ==========================================
local Window = Library:CreateWindow("🍋 LEMON HUB <font color='#00F0FF'>| Paper To Plane</font>")

local FarmTab = Window:CreateTab("Auto Farm")
local MiscTab = Window:CreateTab("Misc & Shop")

-- 1. Auto Train / Throw Power
FarmTab:AddToggle("Auto Train / Throw Power", false, function(state)
    _G.AutoTrain = state
    task.spawn(function()
        while _G.AutoTrain do
            task.wait(0.2)
            pcall(function()
                -- Tìm và kích hoạt Remote của game Paper To Plane
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("train") or v.Name:lower():find("power") or v.Name:lower():find("strength")) then
                        v:FireServer()
                    end
                end
            end)
        end
    end)
end)

-- 2. Auto Launch Plane (Đã sửa lại quét đúng Remote ném máy bay)
FarmTab:AddToggle("Auto Launch Plane", false, function(state)
    _G.AutoLaunch = state
    task.spawn(function()
        while _G.AutoLaunch do
            task.wait(1.5)
            pcall(function()
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("launch") or v.Name:lower():find("fly") or v.Name:lower():find("throw")) then
                        v:FireServer(100) -- Gửi giá trị lực ném
                    end
                end
            end)
        end
    end)
end)

-- 3. Auto Collect Rings / Coins
FarmTab:AddToggle("Auto Collect Rings / Coins", false, function(state)
    _G.AutoCollect = state
    task.spawn(function()
        while _G.AutoCollect do
            task.wait(0.5)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, folder in pairs(workspace:GetChildren()) do
                        if folder.Name:lower():find("ring") or folder.Name:lower():find("coin") or folder.Name:lower():find("collect") then
                            for _, obj in pairs(folder:GetChildren()) do
                                if obj:IsA("BasePart") or obj:FindFirstChildOfClass("BasePart") then
                                    local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                                    char.HumanoidRootPart.CFrame = targetPart.CFrame
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. Né vật thể (Auto Dodge / No Clip khi bay)
local dodgeConn
FarmTab:AddToggle("Auto Dodge Obstacles (Né vật thể)", false, function(state)
    _G.AutoDodge = state
    if _G.AutoDodge then
        dodgeConn = RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    -- Tắt va chạm toàn bộ phần của nhân vật và máy bay để xuyên qua mọi chướng ngại vật
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                -- Tắt va chạm của tất cả vật cản trong Map
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("obstacle") or obj.Name:lower():find("wall") or obj.Name:lower():find("building") or obj.Name:lower():find("tree") then
                        for _, p in pairs(obj:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end)
    else
        if dodgeConn then
            dodgeConn:Disconnect()
            dodgeConn = nil
        end
    end
end)

-- Tab Phụ trợ
MiscTab:AddToggle("Anti AFK", true, function(state)
    _G.AntiAFK = state
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if _G.AntiAFK then
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
end)

MiscTab:AddButton("Copy Website Hub", function()
    if setclipboard then
        setclipboard("https://lemonhub.wispbyte.app/")
    end
end)

MiscTab:AddButton("Destroy UI", function()
    CoreGui:FindFirstChild("LemonHub_PaperToPlane"):Destroy()
end)
