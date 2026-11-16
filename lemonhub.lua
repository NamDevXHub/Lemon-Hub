--// Lemon Hub - Paper To Plane (Ultimate Edition)
--// Developed by NamDevXHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("LemonHub_PaperToPlane") then
    CoreGui:FindFirstChild("LemonHub_PaperToPlane"):Destroy()
end

local Library = {}

-- Bảng màu Neon Vàng & Xanh Cyan (Phong cách Cyberpunk / Glassmorphism hiện đại nhất)
Library.Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    Sidebar = Color3.fromRGB(18, 18, 24),
    Element = Color3.fromRGB(24, 24, 34),
    ElementHover = Color3.fromRGB(32, 32, 46),
    AccentYellow = Color3.fromRGB(255, 220, 0),
    AccentCyan = Color3.fromRGB(0, 245, 255),
    TextLight = Color3.fromRGB(250, 250, 250),
    TextDim = Color3.fromRGB(150, 150, 170)
}

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LemonHub_PaperToPlane"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Khung chính với bo góc mượt mà và bóng mờ
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 560, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.AccentYellow
    MainStroke.Transparency = 0.3
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame

    -- Topbar (Thanh tiêu đề & Kéo thả cực mượt)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 46)
    Topbar.BackgroundColor3 = Library.Theme.Sidebar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 12)

    -- Sửa lại viền dưới của Topbar cho phẳng đẹp
    local TopbarCover = Instance.new("Frame")
    TopbarCover.Size = UDim2.new(1, 0, 0, 10)
    TopbarCover.Position = UDim2.new(0, 0, 1, -10)
    TopbarCover.BackgroundColor3 = Library.Theme.Sidebar
    TopbarCover.BorderSizePixel = 0
    TopbarCover.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 340, 1, 0)
    Title.Position = UDim2.new(0, 16, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.RichText = true
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Library.Theme.AccentYellow
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    local Credit = Instance.new("TextLabel")
    Credit.Size = UDim2.new(0, 150, 1, 0)
    Credit.Position = UDim2.new(1, -195, 0, 0)
    Credit.BackgroundTransparency = 1
    Credit.Text = "by NamDevXHub"
    Credit.Font = Enum.Font.GothamMedium
    Credit.TextSize = 12
    Credit.TextColor3 = Library.Theme.TextDim
    Credit.TextXAlignment = Enum.TextXAlignment.Right
    Credit.Parent = Topbar

    -- Nút Đóng UI
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -36, 0, 9)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 60, 70)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Parent = Topbar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Phím tắt RightControl ẩn hiện UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Hệ thống kéo thả menu mượt mà chuẩn xác
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

    -- Sidebar chứa danh sách Tab
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 145, 1, -58)
    Sidebar.Position = UDim2.new(0, 8, 0, 50)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.Parent = Sidebar

    -- Container chứa nội dung các trang
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -162, 1, -58)
    PagesContainer.Position = UDim2.new(0, 158, 0, 50)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = MainFrame

    local Window = {}
    local FirstTab = true

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = FirstTab and Library.Theme.ElementHover or Library.Theme.Sidebar
        TabBtn.Text = "   " .. tabName
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = FirstTab and Library.Theme.AccentYellow or Library.Theme.TextLight
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Size = UDim2.new(0, 3, 0, 20)
        TabIndicator.Position = UDim2.new(0, 0, 0.5, -10)
        TabIndicator.BackgroundColor3 = Library.Theme.AccentYellow
        TabIndicator.Visible = FirstTab
        TabIndicator.Parent = TabBtn
        Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(0, 2)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Library.Theme.AccentCyan
        Page.Visible = FirstTab
        Page.Parent = PagesContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
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
                    if btn:FindFirstChild("Frame") then btn.Frame.Visible = false end
                end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Library.Theme.ElementHover
            TabBtn.TextColor3 = Library.Theme.AccentYellow
            TabIndicator.Visible = true
        end)

        local Tab = {}

        -- Nút bấm (Button)
        function Tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Library.Theme.Element
            Btn.Text = "   " .. text
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextColor3 = Library.Theme.TextLight
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

            local Stroke = Instance.new("UIStroke", Btn)
            Stroke.Color = Library.Theme.AccentCyan
            Stroke.Transparency = 0.7
            Stroke.Thickness = 1

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.AccentCyan, TextColor3 = Library.Theme.Background}):Play()
                task.wait(0.12)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Element, TextColor3 = Library.Theme.TextLight}):Play()
                pcall(callback)
            end)
        end

        -- Nút Bật/Tắt (Toggle) dạng hình vuông bo góc cao cấp
        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -10, 0, 42)
            Toggle.BackgroundColor3 = Library.Theme.Element
            Toggle.Text = ""
            Toggle.Parent = Page
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextColor3 = Library.Theme.TextLight
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Toggle

            -- Ô vuông bo góc công tắc
            local SquareBox = Instance.new("Frame")
            SquareBox.Size = UDim2.new(0, 24, 0, 24)
            SquareBox.Position = UDim2.new(1, -36, 0.5, -12)
            SquareBox.BackgroundColor3 = state and Library.Theme.AccentYellow or Color3.fromRGB(35, 35, 48)
            SquareBox.Parent = Toggle
            Instance.new("UICorner", SquareBox).CornerRadius = UDim.new(0, 6)

            local BoxStroke = Instance.new("UIStroke", SquareBox)
            BoxStroke.Color = state and Library.Theme.AccentYellow or Library.Theme.AccentCyan
            BoxStroke.Transparency = state and 0 or 0.4
            BoxStroke.Thickness = 1.5

            -- Dấu check nhỏ bên trong khi bật
            local CheckMark = Instance.new("TextLabel")
            CheckMark.Size = UDim2.new(1, 0, 1, 0)
            CheckMark.BackgroundTransparency = 1
            CheckMark.Text = "✓"
            CheckMark.Font = Enum.Font.GothamBold
            CheckMark.TextSize = 14
            CheckMark.TextColor3 = Library.Theme.Background
            CheckMark.Visible = state
            CheckMark.Parent = SquareBox

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                local targetColor = state and Library.Theme.AccentYellow or Color3.fromRGB(35, 35, 48)
                TweenService:Create(SquareBox, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                BoxStroke.Color = state and Library.Theme.AccentYellow or Library.Theme.AccentCyan
                BoxStroke.Transparency = state and 0 or 0.4
                CheckMark.Visible = state
                pcall(callback, state)
            end)
        end

        return Tab
    end

    return Window
end

-- ==========================================
-- KHỞI TẠO TÍNH NĂNG CHUẨN XÁC CHO PAPER TO PLANE
-- ==========================================
local Window = Library:CreateWindow("🍋 LEMON HUB <font color='#00F0FF'>| Paper To Plane</font>")

local FarmTab = Window:CreateTab("Auto Farm")
local MiscTab = Window:CreateTab("Misc & Shop")

-- Hàm tìm RemoteEvent thông minh dựa trên từ khóa trong game
local function GetRemote(keyword)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find(keyword:lower()) then
            return v
        end
    end
    return nil
end

-- 1. Auto Train (Tự động luyện tập tăng sức mạnh)
FarmTab:AddToggle("Auto Train / Throw Power", false, function(state)
    _G.AutoTrain = state
    task.spawn(function()
        while _G.AutoTrain do
            task.wait(0.15)
            pcall(function()
                local remote = GetRemote("train") or GetRemote("power") or GetRemote("strength")
                if remote then
                    remote:FireServer()
                end
            end)
        end
    end)
end)

-- 2. Auto Launch Plane (Tự động ném máy bay liên tục)
FarmTab:AddToggle("Auto Launch Plane", false, function(state)
    _G.AutoLaunch = state
    task.spawn(function()
        while _G.AutoLaunch do
            task.wait(1.2)
            pcall(function()
                local remote = GetRemote("launch") or GetRemote("fly") or GetRemote("throw")
                if remote then
                    remote:FireServer(100) -- Truyền lực tối đa
                end
            end)
        end
    end)
end)

-- 3. Auto Collect Rings / Coins (Tự động bay đến nhặt nhẫn và tiền)
FarmTab:AddToggle("Auto Collect Rings / Coins", false, function(state)
    _G.AutoCollect = state
    task.spawn(function()
        while _G.AutoCollect do
            task.wait(0.4)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, folder in pairs(workspace:GetChildren()) do
                        local fName = folder.Name:lower()
                        if fName:find("ring") or fName:find("coin") or fName:find("collect") or fName:find("drop") then
                            for _, obj in pairs(folder:GetChildren()) do
                                local targetPart = nil
                                if obj:IsA("BasePart") then
                                    targetPart = obj
                                elseif obj:IsA("Model") and obj.PrimaryPart then
                                    targetPart = obj.PrimaryPart
                                elseif obj:FindFirstChildOfClass("BasePart") then
                                    targetPart = obj:FindFirstChildOfClass("BasePart")
                                end
                                
                                if targetPart then
                                    char.HumanoidRootPart.CFrame = targetPart.CFrame
                                    task.wait(0.08)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. Auto Dodge Obstacles (Tự động né vật thể / Xuyên vật cản khi bay)
local dodgeConnection
FarmTab:AddToggle("Auto Dodge Obstacles (Né vật thể)", false, function(state)
    _G.AutoDodge = state
    if _G.AutoDodge then
        dodgeConnection = RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                -- Vô hiệu hóa va chạm với mọi vật cản trong map
                for _, obj in pairs(workspace:GetChildren()) do
                    local name = obj.Name:lower()
                    if name:find("obstacle") or name:find("wall") or name:find("building") or name:find("tree") or name:find("prop") then
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
        if dodgeConnection then
            dodgeConnection:Disconnect()
            dodgeConnection = nil
        end
    end
end)

-- Tab Phụ trợ (Misc)
MiscTab:AddToggle("Anti AFK (Chống văng)", true, function(state)
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

MiscTab:AddButton("Destroy UI (Xóa Menu)", function()
    CoreGui:FindFirstChild("LemonHub_PaperToPlane"):Destroy()
end)
