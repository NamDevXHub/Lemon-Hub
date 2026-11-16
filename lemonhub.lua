
--================================================
-- 🍋 LEMON HUB V3 | ZYRONX MOBILE EDITION
--================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("LemonHub")
if Old then Old:Destroy() end

local Yellow = Color3.fromRGB(255,210,35)
local Dark = Color3.fromRGB(12,13,18)
local Card = Color3.fromRGB(25,27,36)
local White = Color3.fromRGB(245,245,245)
local Gray = Color3.fromRGB(155,160,175)
local Red = Color3.fromRGB(210,65,65)

local Features = {
    ["AUTO THROW"] = "Chưa có API game",
    ["AUTO PILOT"] = "Chưa có API game",
    ["AUTO DODGE"] = "Chưa có API game",
    ["AUTO REBIRTH"] = "Chưa có API game",
    ["AUTO TRAINING"] = "Chưa có API game"
}

local Gui = Instance.new("ScreenGui")
Gui.Name = "LemonHub"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 100
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(310,350)
Main.Position = UDim2.new(.5,-155,.5,-175)
Main.BackgroundColor3 = Dark
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,15)

local Border = Instance.new("UIStroke",Main)
Border.Color = Yellow
Border.Thickness = 2

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,48)
Header.BackgroundColor3 = Card
Header.Parent = Main

Instance.new("UICorner",Header).CornerRadius =
    UDim.new(0,13)

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(12,0)
Title.Size = UDim2.new(1,-100,1,0)
Title.BackgroundTransparency = 1
Title.Text = "🍋 LEMON HUB V3"
Title.TextColor3 = Yellow
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local function MakeButton(parent,text,pos,color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28,27)
    b.Position = pos
    b.Text = text
    b.TextColor3 = White
    b.BackgroundColor3 = color
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = parent

    Instance.new("UICorner",b).CornerRadius =
        UDim.new(0,7)

    return b
end

local Min = MakeButton(Header,"-",
    UDim2.new(1,-67,0,10),Dark)

local Close = MakeButton(Header,"X",
    UDim2.new(1,-34,0,10),Red)

-- BODY
local Body = Instance.new("Frame")
Body.Position = UDim2.fromOffset(10,57)
Body.Size = UDim2.new(1,-20,1,-87)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Heading = Instance.new("TextLabel")
Heading.Size = UDim2.new(1,0,0,25)
Heading.BackgroundTransparency = 1
Heading.Text = "  AUTOMATIC FEATURES"
Heading.TextColor3 = Yellow
Heading.Font = Enum.Font.GothamBold
Heading.TextSize = 11
Heading.TextXAlignment = Enum.TextXAlignment.Left
Heading.Parent = Body

local Scroll = Instance.new("ScrollingFrame")
Scroll.Position = UDim2.fromOffset(0,28)
Scroll.Size = UDim2.new(1,0,1,-28)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Yellow
Scroll.CanvasSize = UDim2.fromOffset(0,300)
Scroll.Parent = Body

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.Parent = Scroll

local function AddFeature(name,description)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-5,0,49)
    Row.BackgroundColor3 = Card
    Row.BorderSizePixel = 0
    Row.Parent = Scroll

    Instance.new("UICorner",Row).CornerRadius =
        UDim.new(0,9)

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.fromOffset(10,4)
    Label.Size = UDim2.new(1,-100,0,20)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Yellow
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Sub = Instance.new("TextLabel")
    Sub.Position = UDim2.fromOffset(10,25)
    Sub.Size = UDim2.new(1,-100,0,16)
    Sub.BackgroundTransparency = 1
    Sub.Text = description
    Sub.TextColor3 = Gray
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = Row

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.fromOffset(83,25)
    Status.Position = UDim2.new(1,-90,.5,-12)
    Status.BackgroundColor3 = Color3.fromRGB(55,58,68)
    Status.Text = "NOT LINKED"
    Status.TextColor3 = White
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 8
    Status.Parent = Row

    Instance.new("UICorner",Status).CornerRadius =
        UDim.new(0,7)
end

AddFeature("AUTO THROW","Throw assistance")
AddFeature("AUTO PILOT","Flight assistance")
AddFeature("AUTO DODGE","Obstacle warning")
AddFeature("AUTO REBIRTH","Rebirth assistance")
AddFeature("AUTO TRAINING","Training assistance")

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.Position = UDim2.new(0,10,1,-24)
Footer.Size = UDim2.new(1,-20,0,16)
Footer.BackgroundTransparency = 1
Footer.Text = "ZYRONX UI | MOBILE EDITION"
Footer.TextColor3 = Gray
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 9
Footer.Parent = Main

-- MINIMIZE
local minimized = false

Min.MouseButton1Click:Connect(function()
    minimized = not minimized

    Body.Visible = not minimized
    Footer.Visible = not minimized

    Main.Size = minimized
        and UDim2.fromOffset(310,48)
        or UDim2.fromOffset(310,350)

    Min.Text = minimized and "+" or "-"
end)

-- CLOSE
Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- MOBILE + PC DRAG
local dragging = false
local dragStart
local startPosition
local dragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("LEMON HUB V3 MOBILE LOADED")
