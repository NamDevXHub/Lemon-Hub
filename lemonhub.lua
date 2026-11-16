
--=====================================
--       🍋 LEMON HUB
--       ZYRONX UI EDITION
--=====================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local GuiParent = game:GetService("CoreGui")

local Old = GuiParent:FindFirstChild("LemonHub")
if Old then Old:Destroy() end

-- COLORS
local Yellow = Color3.fromRGB(255, 210, 35)
local Dark = Color3.fromRGB(12, 13, 18)
local Card = Color3.fromRGB(25, 27, 36)
local White = Color3.fromRGB(245, 245, 245)
local Gray = Color3.fromRGB(155, 160, 175)

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "LemonHub"
Gui.ResetOnSpawn = false
Gui.Parent = GuiParent

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(330, 270)
Main.Position = UDim2.new(.5, -165, .5, -135)
Main.BackgroundColor3 = Dark
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius =
    UDim.new(0, 14)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Yellow
Stroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Card
Header.BorderSizePixel = 0

Instance.new("UICorner", Header).CornerRadius =
    UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(13, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍋 LEMON HUB"
Title.TextColor3 = Yellow
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE
local Min = Instance.new("TextButton", Header)
Min.Size = UDim2.fromOffset(28, 28)
Min.Position = UDim2.new(1, -68, 0, 11)
Min.Text = "-"
Min.TextColor3 = Yellow
Min.BackgroundColor3 = Dark
Min.Font = Enum.Font.GothamBold
Min.TextSize = 20

Instance.new("UICorner", Min).CornerRadius =
    UDim.new(0, 7)

-- CLOSE
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.fromOffset(28, 28)
Close.Position = UDim2.new(1, -35, 0, 11)
Close.Text = "X"
Close.TextColor3 = White
Close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14

Instance.new("UICorner", Close).CornerRadius =
    UDim.new(0, 7)

-- BODY
local Body = Instance.new("Frame", Main)
Body.Position = UDim2.fromOffset(10, 60)
Body.Size = UDim2.new(1, -20, 1, -95)
Body.BackgroundTransparency = 1

local Heading = Instance.new("TextLabel", Body)
Heading.Size = UDim2.new(1, 0, 0, 25)
Heading.BackgroundTransparency = 1
Heading.Text = "  AUTOMATIC FEATURES"
Heading.TextColor3 = Yellow
Heading.Font = Enum.Font.GothamBold
Heading.TextSize = 12
Heading.TextXAlignment = Enum.TextXAlignment.Left

local States = {}

-- TOGGLE
local function AddToggle(Name, Desc, Y)

    local Row = Instance.new("Frame", Body)
    Row.Position = UDim2.fromOffset(0, Y)
    Row.Size = UDim2.new(1, 0, 0, 48)
    Row.BackgroundColor3 = Card
    Row.BorderSizePixel = 0

    Instance.new("UICorner", Row).CornerRadius =
        UDim.new(0, 9)

    local Label = Instance.new("TextLabel", Row)
    Label.Position = UDim2.fromOffset(10, 3)
    Label.Size = UDim2.new(1, -75, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Yellow
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Sub = Instance.new("TextLabel", Row)
    Sub.Position = UDim2.fromOffset(10, 25)
    Sub.Size = UDim2.new(1, -75, 0, 15)
    Sub.BackgroundTransparency = 1
    Sub.Text = Desc
    Sub.TextColor3 = Gray
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 9
    Sub.TextXAlignment = Enum.TextXAlignment.Left

    local On = false
    States[Name] = false

    local Button = Instance.new("TextButton", Row)
    Button.Size = UDim2.fromOffset(43, 23)
    Button.Position = UDim2.new(1, -53, .5, -11)
    Button.Text = ""
    Button.BackgroundColor3 =
        Color3.fromRGB(55, 58, 68)
    Button.AutoButtonColor = false

    Instance.new("UICorner", Button).CornerRadius =
        UDim.new(1, 0)

    local Dot = Instance.new("Frame", Button)
    Dot.Size = UDim2.fromOffset(17, 17)
    Dot.Position = UDim2.fromOffset(3, 3)
    Dot.BackgroundColor3 = White

    Instance.new("UICorner", Dot).CornerRadius =
        UDim.new(1, 0)

    Button.MouseButton1Click:Connect(function()

        On = not On
        States[Name] = On

        TweenService:Create(Button,
            TweenInfo.new(.2), {
                BackgroundColor3 = On
                and Yellow
                or Color3.fromRGB(55, 58, 68)
            }):Play()

        TweenService:Create(Dot,
            TweenInfo.new(.2), {
                Position = On
                and UDim2.new(1, -20, 0, 3)
                or UDim2.fromOffset(3, 3)
            }):Play()

        print("[LEMON HUB]", Name,
            On and "ON" or "OFF")
    end)
end

-- ORIGINAL FEATURES
AddToggle(
    "AUTO THROW & PILOT",
    "Automatic plane control",
    32
)

AddToggle(
    "AUTO REBIRTH",
    "Automatic rebirth",
    86
)

AddToggle(
    "AUTO TRAINING",
    "Automatic training",
    140
)

-- FOOTER
local Footer = Instance.new("TextLabel", Main)
Footer.Position = UDim2.new(0, 10, 1, -27)
Footer.Size = UDim2.new(1, -20, 0, 18)
Footer.BackgroundTransparency = 1
Footer.Text = "LEMON HUB | ZYRONX UI"
Footer.TextColor3 = Gray
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 9

-- MINIMIZE
local Minimized = false

Min.MouseButton1Click:Connect(function()

    Minimized = not Minimized
    Body.Visible = not Minimized
    Footer.Visible = not Minimized

    Main.Size = Minimized
        and UDim2.fromOffset(330, 50)
        or UDim2.fromOffset(330, 270)

    Min.Text = Minimized and "+" or "-"
end)

-- CLOSE
Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- DRAG MOBILE + PC
local Dragging = false
local DragStart
local StartPos

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState ==
                Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)

    if Dragging and (
        Input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or Input.UserInputType ==
        Enum.UserInputType.Touch
    ) then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)
