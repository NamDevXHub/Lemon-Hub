--================================================
-- 🍋 LEMON HUB V3 | ZYRONX MOBILE EDITION
-- UI ONLY — KHÔNG CHỨA BẤT KỲ CHỨC NĂNG NÀO
--================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("LemonHub")
if Old then Old:Destroy() end

--============ PALETTE ============
local C = {
    Bg        = Color3.fromRGB(12, 13, 18),
    Header    = Color3.fromRGB(19, 21, 29),
    Card      = Color3.fromRGB(24, 26, 35),
    CardHover = Color3.fromRGB(33, 36, 48),
    Accent    = Color3.fromRGB(255, 210, 35),
    Accent2   = Color3.fromRGB(255, 160, 0),
    Text      = Color3.fromRGB(245, 246, 250),
    Muted     = Color3.fromRGB(138, 144, 162),
    Track     = Color3.fromRGB(46, 50, 64),
    Line      = Color3.fromRGB(52, 56, 72),
    Danger    = Color3.fromRGB(214, 72, 72),
}

local FONT_BLACK = Enum.Font.GothamBlack
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_REG   = Enum.Font.Gotham

--============ HELPERS ============
local function tw(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out)
    local a = TweenService:Create(obj, info, props)
    a:Play()
    return a
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

--============ ROOT ============
local Screen = Instance.new("ScreenGui")
Screen.Name = "LemonHub"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.DisplayOrder = 100
Screen.Parent = PlayerGui

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.Size = UDim2.fromOffset(320, 410)
Window.BackgroundColor3 = C.Bg
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Active = true
Window.Parent = Screen
corner(Window, 18)
stroke(Window, C.Line, 1.5, 0.25)

--============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundColor3 = C.Header
Header.BorderSizePixel = 0
Header.Parent = Window
corner(Header, 18)

-- che 2 góc dưới của header
local HeaderFill = Instance.new("Frame")
HeaderFill.Position = UDim2.new(0, 0, 0, 34)
HeaderFill.Size = UDim2.new(1, 0, 0, 20)
HeaderFill.BackgroundColor3 = C.Header
HeaderFill.BorderSizePixel = 0
HeaderFill.ZIndex = 2
HeaderFill.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.BackgroundColor3 = C.Accent
HeaderLine.BackgroundTransparency = 0.75
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 3
HeaderLine.Parent = Header

-- Logo
local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(26, 26)
Logo.Position = UDim2.new(0, 15, 0.5, -13)
Logo.BackgroundColor3 = C.Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 4
Logo.Parent = Header
corner(Logo, 8)

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Color = ColorSequence.new(C.Accent, C.Accent2)
LogoGrad.Rotation = 45
LogoGrad.Parent = Logo

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "🍋"
LogoText.TextSize = 14
LogoText.ZIndex = 5
LogoText.Parent = Logo

-- Title
local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 50, 0, 0)
Title.Size = UDim2.new(1, -150, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "LEMON HUB"
Title.TextColor3 = C.Text
Title.Font = FONT_BLACK
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Position = UDim2.new(0, 50, 0, 30)
Version.Size = UDim2.new(1, -150, 0, 14)
Version.BackgroundTransparency = 1
Version.Text = "V3  •  ZYRONX EDITION"
Version.TextColor3 = C.Muted
Version.Font = FONT_BOLD
Version.TextSize = 8
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.ZIndex = 4
Version.Parent = Header

-- Window buttons
local function makeWinBtn(pos, label, hoverColor)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28, 28)
    b.Position = pos
    b.BackgroundColor3 = C.Bg
    b.Text = label
    b.TextColor3 = C.Muted
    b.Font = FONT_BOLD
    b.TextSize = 15
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = Header
    corner(b, 8)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundColor3 = hoverColor, TextColor3 = C.Text}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        tw(b, {BackgroundColor3 = C.Bg, TextColor3 = C.Muted}, 0.15)
    end)
    return b
end

local MinBtn   = makeWinBtn(UDim2.new(1, -70, 0, 13), "–", C.CardHover)
local CloseBtn = makeWinBtn(UDim2.new(1, -38, 0, 13), "✕", C.Danger)

--============ BODY ============
local Body = Instance.new("Frame")
Body.Position = UDim2.fromOffset(0, 54)
Body.Size = UDim2.new(1, 0, 1, -54)
Body.BackgroundTransparency = 1
Body.Parent = Window

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Position = UDim2.fromOffset(16, 12)
SectionTitle.Size = UDim2.new(1, -120, 0, 18)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Text = "AUTOMATIC FEATURES"
SectionTitle.TextColor3 = C.Accent
SectionTitle.Font = FONT_BOLD
SectionTitle.TextSize = 10
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.Parent = Body

local Badge = Instance.new("TextLabel")
Badge.AnchorPoint = Vector2.new(1, 0)
Badge.Position = UDim2.new(1, -16, 0, 12)
Badge.Size = UDim2.fromOffset(58, 18)
Badge.BackgroundColor3 = Color3.fromRGB(40, 43, 56)
Badge.Text = "UI ONLY"
Badge.TextColor3 = C.Muted
Badge.Font = FONT_BOLD
Badge.TextSize = 8
Badge.Parent = Body
corner(Badge, 6)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Position = UDim2.fromOffset(14, 40)
Scroll.Size = UDim2.new(1, -28, 1, -74)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = C.Accent
Scroll.ScrollBarImageTransparency = 0.35
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.Parent = Body

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

local ListPad = Instance.new("UIPadding")
ListPad.PaddingTop = UDim.new(0, 2)
ListPad.PaddingBottom = UDim.new(0, 10)
ListPad.Parent = Scroll

--============ CARD ============
local function createCard(icon, title, subtitle)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 58)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.Parent = Scroll
    corner(card, 12)
    local cs = stroke(card, C.Line, 1, 0.55)

    -- icon
    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.fromOffset(34, 34)
    iconBox.Position = UDim2.new(0, 12, 0.5, -17)
    iconBox.BackgroundColor3 = C.Accent
    iconBox.BorderSizePixel = 0
    iconBox.Parent = card
    corner(iconBox, 10)

    local ig = Instance.new("UIGradient")
    ig.Color = ColorSequence.new(C.Accent, C.Accent2)
    ig.Rotation = 45
    ig.Parent = iconBox

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.fromScale(1, 1)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 15
    iconLabel.Font = FONT_BOLD
    iconLabel.TextColor3 = Color3.fromRGB(35, 28, 8)
    iconLabel.Parent = iconBox

    -- title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Position = UDim2.new(0, 56, 0, 10)
    titleLabel.Size = UDim2.new(1, -160, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = C.Text
    titleLabel.Font = FONT_BOLD
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    -- subtitle
    local subLabel = Instance.new("TextLabel")
    subLabel.Position = UDim2.new(0, 56, 0, 30)
    subLabel.Size = UDim2.new(1, -160, 0, 15)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle
    subLabel.TextColor3 = C.Muted
    subLabel.Font = FONT_REG
    subLabel.TextSize = 10
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = card

    -- toggle (thuần trang trí)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(42, 23)
    toggle.Position = UDim2.new(1, -56, 0.5, -11.5)
    toggle.BackgroundColor3 = C.Track
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = card
    corner(toggle, 12)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(17, 17)
    knob.Position = UDim2.new(0, 3, 0.5, -8.5)
    knob.BackgroundColor3 = C.Muted
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    corner(knob, 9)

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        tw(toggle, {BackgroundColor3 = on and C.Accent or C.Track}, 0.2)
        tw(knob, {
            Position = on
                and UDim2.new(1, -20, 0.5, -8.5)
                or  UDim2.new(0, 3, 0.5, -8.5),
            BackgroundColor3 = on
                and Color3.fromRGB(35, 28, 8)
                or  C.Muted
        }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- hover
    card.MouseEnter:Connect(function()
        tw(card, {BackgroundColor3 = C.CardHover}, 0.15)
        tw(cs, {Transparency = 0.2}, 0.15)
    end)
    card.MouseLeave:Connect(function()
        tw(card, {BackgroundColor3 = C.Card}, 0.15)
        tw(cs, {Transparency = 0.55}, 0.15)
    end)

    return card
end

--============ DANH SÁCH (TRANG TRÍ) ============
createCard("🎯", "AUTO THROW",   "Throw assistance")
createCard("✈", "AUTO PILOT",   "Flight assistance")
createCard("🛡", "AUTO DODGE",   "Obstacle warning")
createCard("♻", "AUTO REBIRTH", "Rebirth assistance")
createCard("⚡", "AUTO TRAINING","Training assistance")

--============ FOOTER ============
local Footer = Instance.new("TextLabel")
Footer.Position = UDim2.new(0, 16, 1, -26)
Footer.Size = UDim2.new(1, -32, 0, 16)
Footer.BackgroundTransparency = 1
Footer.Text = "ZYRONX  •  MOBILE EDITION  •  V3"
Footer.TextColor3 = Color3.fromRGB(90, 95, 112)
Footer.Font = FONT_BOLD
Footer.TextSize = 9
Footer.Parent = Body

--============ MINIMIZE ============
local FULL_H, MINI_H = 410, 54
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    tw(Window, {Size = UDim2.fromOffset(320, minimized and MINI_H or FULL_H)},
        0.25, Enum.EasingStyle.Quint)

    Body.Visible = not minimized
    MinBtn.Text = minimized and "+" or "–"
end)

--============ CLOSE ============
CloseBtn.MouseButton1Click:Connect(function()
    tw(Window, {Size = UDim2.fromOffset(260, 320)},
        0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.19, function()
        Screen:Destroy()
    end)
end)

--============ DRAG (PC + MOBILE) ============
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position

        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--============ ENTRANCE ============
Window.Size = UDim2.fromOffset(300, 390)
tw(Window, {Size = UDim2.fromOffset(320, 410)}, 0.28,
    Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("LEMON HUB V3 — UI ONLY LOADED")
