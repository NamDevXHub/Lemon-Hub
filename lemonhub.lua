
--========================================
-- 🍋 LEMON HUB | ZYRONX UI V2
--========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("LemonHub")
if Old then Old:Destroy() end

local Yellow = Color3.fromRGB(255,210,35)
local Dark = Color3.fromRGB(12,13,18)
local Card = Color3.fromRGB(25,27,36)
local White = Color3.fromRGB(245,245,245)
local Gray = Color3.fromRGB(155,160,175)

local States = {}
local Connections = {}

local Gui = Instance.new("ScreenGui")
Gui.Name = "LemonHub"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(330,350)
Main.Position = UDim2.new(.5,-165,.5,-175)
Main.BackgroundColor3 = Dark
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,14)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Color = Yellow
Stroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,50)
Header.BackgroundColor3 = Card
Header.Parent = Main

Instance.new("UICorner",Header).CornerRadius =
    UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.fromOffset(13,0)
Title.BackgroundTransparency = 1
Title.Text = "🍋 LEMON HUB"
Title.TextColor3 = Yellow
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local function HeaderButton(text,x,color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28,28)
    b.Position = UDim2.new(1,x,0,11)
    b.Text = text
    b.TextColor3 = White
    b.BackgroundColor3 = color
    b.Font = Enum.Font.GothamBold
    b.Parent = Header
    Instance.new("UICorner",b).CornerRadius =
        UDim.new(0,7)
    return b
end

local Min = HeaderButton("-", -68, Dark)
local Close = HeaderButton("X", -35,
    Color3.fromRGB(180,45,45))

-- BODY
local Body = Instance.new("Frame")
Body.Position = UDim2.fromOffset(10,60)
Body.Size = UDim2.new(1,-20,1,-95)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Heading = Instance.new("TextLabel")
Heading.Size = UDim2.new(1,0,0,25)
Heading.BackgroundTransparency = 1
Heading.Text = "  AUTOMATIC FEATURES"
Heading.TextColor3 = Yellow
Heading.Font = Enum.Font.GothamBold
Heading.TextSize = 12
Heading.TextXAlignment = Enum.TextXAlignment.Left
Heading.Parent = Body

local Scroll = Instance.new("ScrollingFrame")
Scroll.Position = UDim2.fromOffset(0,28)
Scroll.Size = UDim2.new(1,0,1,-28)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Yellow
Scroll.CanvasSize = UDim2.fromOffset(0,280)
Scroll.Parent = Body

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.Parent = Scroll

local function AddToggle(name,desc,callback)
    States[name] = false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-5,0,48)
    Row.BackgroundColor3 = Card
    Row.BorderSizePixel = 0
    Row.Parent = Scroll

    Instance.new("UICorner",Row).CornerRadius =
        UDim.new(0,9)

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.fromOffset(10,3)
    Label.Size = UDim2.new(1,-75,0,22)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Yellow
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Sub = Instance.new("TextLabel")
    Sub.Position = UDim2.fromOffset(10,25)
    Sub.Size = UDim2.new(1,-75,0,15)
    Sub.BackgroundTransparency = 1
    Sub.Text = desc
    Sub.TextColor3 = Gray
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = Row

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(43,23)
    Button.Position = UDim2.new(1,-53,.5,-11)
    Button.Text = ""
    Button.BackgroundColor3 =
        Color3.fromRGB(55,58,68)
    Button.AutoButtonColor = false
    Button.Parent = Row

    Instance.new("UICorner",Button).CornerRadius =
        UDim.new(1,0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(17,17)
    Dot.Position = UDim2.fromOffset(3,3)
    Dot.BackgroundColor3 = White
    Dot.Parent = Button

    Instance.new("UICorner",Dot).CornerRadius =
        UDim.new(1,0)

    Button.MouseButton1Click:Connect(function()
        local newState = not States[name]

        local ok,err = pcall(function()
            callback(newState)
        end)

        if not ok then
            warn("LEMON HUB ERROR:",err)
            return
        end

        States[name] = newState

        TweenService:Create(Button,TweenInfo.new(.2),{
            BackgroundColor3 = newState and Yellow
                or Color3.fromRGB(55,58,68)
        }):Play()

        TweenService:Create(Dot,TweenInfo.new(.2),{
            Position = newState
                and UDim2.new(1,-20,0,3)
                or UDim2.fromOffset(3,3)
        }):Play()
    end)
end

-- THROW ASSISTANCE
AddToggle("AUTO THROW",
    "Throw assistance - requires game support",
    function(enabled)
        warn("AUTO THROW:",enabled)
    end)

-- PILOT ASSISTANCE
AddToggle("AUTO PILOT",
    "Flight assistance - requires game support",
    function(enabled)
        warn("AUTO PILOT:",enabled)
    end)

-- REBIRTH
AddToggle("AUTO REBIRTH",
    "Rebirth assistance - requires game support",
    function(enabled)
        warn("AUTO REBIRTH:",enabled)
    end)

-- TRAINING
AddToggle("AUTO TRAINING",
    "Training assistance - requires game support",
    function(enabled)
        warn("AUTO TRAINING:",enabled)
    end)

-- AUTO DODGE: SAFE OBSTACLE WARNING
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude

AddToggle("AUTO DODGE",
    "Detect nearby obstacles",
    function(enabled)
        if Connections.Dodge then
            Connections.Dodge:Disconnect()
            Connections.Dodge = nil
        end

        if not enabled then
            return
        end

        Connections.Dodge = RunService.Heartbeat:Connect(
            function()
                local char = Player.Character
                if not char then return end

                local root = char:FindFirstChild(
                    "HumanoidRootPart")

                if not root then return end

                RayParams.FilterDescendantsInstances = {char}

                local directions = {
                    root.CFrame.LookVector,
                    (root.CFrame * CFrame.Angles(0,math.rad(25),0)).LookVector,
                    (root.CFrame * CFrame.Angles(0,math.rad(-25),0)).LookVector
                }

                for _,dir in ipairs(directions) do
                    local result = workspace:Raycast(
                        root.Position,
                        dir * 15,
                        RayParams
                    )

                    if result then
                        warn("LEMON HUB: OBSTACLE DETECTED")
                        break
                    end
                end
            end
        )
    end)

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.Position = UDim2.new(0,10,1,-27)
Footer.Size = UDim2.new(1,-20,0,18)
Footer.BackgroundTransparency = 1
Footer.Text = "LEMON HUB | ZYRONX UI"
Footer.TextColor3 = Gray
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 9
Footer.Parent = Main

-- MINIMIZE
local Minimized = false

Min.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Body.Visible = not Minimized
    Footer.Visible = not Minimized

    Main.Size = Minimized
        and UDim2.fromOffset(330,50)
        or UDim2.fromOffset(330,350)

    Min.Text = Minimized and "+" or "-"
end)

-- CLOSE
Close.MouseButton1Click:Connect(function()
    for _,connection in pairs(Connections) do
        connection:Disconnect()
    end
    Gui:Destroy()
end)

-- DRAG: PC AND TOUCH
local Dragging = false
local DragStart
local StartPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = Main.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

print("🍋 LEMON HUB ZYRONX UI LOADED")
