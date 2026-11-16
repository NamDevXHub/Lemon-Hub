--// Lemon Hub - Paper To Plane Script (Updated)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -8, 0, 36)
            Toggle.BackgroundColor3 = Library.Theme.Element
            Toggle.Text = ""
            Toggle.Parent = Page
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Library.Theme.TextLight
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 22, 0, 22)
            Indicator.Position = UDim2.new(1, -32, 0.5, -11)
            Indicator.BackgroundColor3 = state and Library.Theme.AccentYellow or Color3.fromRGB(50, 50, 65)
            Indicator.Parent = Toggle
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 5)

            Toggle.MouseButton1ClientConnect = Toggle.MouseButton1Click:Connect(function()
                state = not state
                local targetColor = state and Library.Theme.AccentYellow or Color3.fromRGB(50, 50, 65)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, state)
            end)
        end

        return Tab
    end

    return Window
end

-- ==========================================
-- KHỞI TẠO GIAO DIỆN & TÍNH NĂNG CHO PAPER TO PLANE
-- ==========================================
local Window = Library:CreateWindow("🍋 LEMON HUB <font color='#00F0FF'>| Paper To Plane</font>")

local FarmTab = Window:CreateTab("Auto Farm")
local MiscTab = Window:CreateTab("Misc & Shop")

-- 1. Auto Train / Throw Power
FarmTab:AddToggle("Auto Train / Throw Power", false, function(state)
    _G.AutoTrain = state
    task.spawn(function()
        while _G.AutoTrain do
            task.wait(0.1)
            pcall(function()
                game:GetService("ReplicatedStorage"):FindFirstChild("Packages", true):FindFirstChild("Knit", true).Services.TrainService.RE.Train:FireServer()
            end)
        end
    end)
end)

-- 2. Auto Launch Plane
FarmTab:AddToggle("Auto Launch Plane", false, function(state)
    _G.AutoLaunch = state
    task.spawn(function()
        while _G.AutoLaunch do
            task.wait(1)
            pcall(function()
                local args = { [1] = 100 }
                game:GetService("ReplicatedStorage"):FindFirstChild("Packages", true):FindFirstChild("Knit", true).Services.FlightService.RE.Launch:FireServer(unpack(args))
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
                for _, ring in pairs(workspace:FindFirstChild("Rings") and workspace.Rings:GetChildren() or {}) do
                    if ring:FindFirstChild("PrimaryPart") or ring:IsA("BasePart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = ring.CFrame
                    end
                end
            end)
        end
    end)
end)

-- 4. Tính năng Né vật thể (Auto Dodge / No Clip Obstacles khi bay)
local dodgeConnection
FarmTab:AddToggle("Auto Dodge Obstacles (Né vật thể)", false, function(state)
    _G.AutoDodge = state
    if _G.AutoDodge then
        dodgeConnection = RunService.Stepped:Connect(function()
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    -- Cho phép máy bay/nhân vật xuyên qua các vật cản (CanCollide = false)
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    -- Nếu có các vật cản cụ thể trong workspace (ví dụ folder Obstacles hoặc Buildings)
                    if workspace:FindFirstChild("Obstacles") then
                        for _, obj in pairs(workspace.Obstacles:GetChildren()) do
                            if obj:IsA("BasePart") then
                                obj.CanCollide = false
                            end
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
