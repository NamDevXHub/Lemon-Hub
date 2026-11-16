--================================================
-- 🍋 LEMON HUB V3 | ZYRONX MOBILE EDITION
-- CLEAN UI — KHÔNG CHỨC NĂNG / NO FEATURES
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
    BgA     = Color3.fromRGB(26, 29, 40),
    BgB     = Color3.fromRGB(11, 12, 18),
    Card    = Color3.fromRGB(30, 33, 48),
    CardHi  = Color3.fromRGB(40, 44, 63),
    Line    = Color3.fromRGB(58, 63, 85),
    Accent  = Color3.fromRGB(255, 209, 35),
    Accent2 = Color3.fromRGB(255, 149, 0),
    Text    = Color3.fromRGB(245, 246, 250),
    Muted   = Color3.fromRGB(138, 144, 165),
    Muted2  = Color3.fromRGB(90, 95, 117),
    Green   = Color3.fromRGB(80, 220, 130),
    Danger  = Color3.fromRGB(220, 75, 75),
}

local FB  = Enum.Font.GothamBlack
local FBD = Enum.Font.GothamBold
local FR  = Enum.Font.Gotham

--============ HELPERS ============
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out),
        props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end

local function stroke(p, color, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = th
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
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
Window.Size = UDim2.fromOffset(300, 380)
Window.BackgroundColor3 = C.BgA
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Active = true
Window.Parent = Screen
corner(Window, 20)

local WinGrad = Instance.new("UIGradient")
WinGrad.Color = ColorSequence.new(C.BgA, C.BgB)
WinGrad.Rotation = 135
WinGrad.Parent = Window

stroke(Window, C.Line, 1.5, 0.4)

--============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
Header.BorderSizePixel = 0
Header.Parent = Window
corner(Header, 20)

-- che 2 goc duoi cua header
local HeaderMask = Instance.new("Frame")
HeaderMask.Position = UDim2.new(0, 0, 0, 32)
HeaderMask.Size = UDim2.new(1, 0, 0, 24)
HeaderMask.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
HeaderMask.BorderSizePixel = 0
HeaderMask.ZIndex = 2
HeaderMask.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0, 14, 1, -1)
HeaderLine.Size = UDim2.new(1, -28, 0, 1)
HeaderLine.BackgroundColor3 = C.Line
HeaderLine.BackgroundTransparency = 0.3
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 3
HeaderLine.Parent = Header

-- Logo
local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(32, 32)
Logo.Position = UDim2.new(0, 16, 0.5, -16)
Logo.BackgroundColor3 = C.Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 4
Logo.Parent = Header
corner(Logo, 10)

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Color = ColorSequence.new(C.Accent, C.Accent2)
LogoGrad.Rotation = 45
LogoGrad.Parent = Logo

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "🍋"
LogoText.TextSize = 16
LogoText.ZIndex = 5
LogoText.Parent = Logo

-- Title
local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 58, 0, 12)
Title.Size = UDim2.new(1, -160, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "LEMON HUB"
Title.TextColor3 = C.Text
Title.Font = FB
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

-- Subtitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Position = UDim2.new(0, 58, 0, 32)
SubTitle.Size = UDim2.new(1, -160, 0, 12)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "V3  •  ZYRONX EDITION"
SubTitle.TextColor3 = C.Muted
SubTitle.Font = FBD
SubTitle.TextSize = 8
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 4
SubTitle.Parent = Header

-- Window Buttons
local function makeWinBtn(pos, label, hoverColor, textHover)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28, 28)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
    b.Text = label
    b.TextColor3 = C.Muted
    b.Font = FBD
    b.TextSize = 14
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = Header
    corner(b, 8)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundColor3 = hoverColor, TextColor3 = textHover or C.Text}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        tw(b, {BackgroundColor3 = Color3.fromRGB(30, 33, 48), TextColor3 = C.Muted}, 0.15)
    end)
    return b
end

local MinBtn   = makeWinBtn(UDim2.new(1, -72, 0, 14), "–", C.CardHi)
local CloseBtn = makeWinBtn(UDim2.new(1, -40, 0, 14), "✕", C.Danger, C.Text)

--============ CONTENT ============
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(0, 56)
Content.Size = UDim2.new(1, 0, 1, -56)
Content.BackgroundTransparency = 1
Content.Parent = Window

-- Hero Glow
local HeroGlow = Instance.new("Frame")
HeroGlow.AnchorPoint = Vector2.new(0.5, 0.5)
HeroGlow.Position = UDim2.new(0.5, 0, 0, 80)
HeroGlow.Size = UDim2.fromOffset(180, 180)
HeroGlow.BackgroundColor3 = C.Accent
HeroGlow.BackgroundTransparency = 0.94
HeroGlow.BorderSizePixel = 0
HeroGlow.Parent = Content
corner(HeroGlow, 90)

-- Hero Badge
local Hero = Instance.new("Frame")
Hero.AnchorPoint = Vector2.new(0.5, 0)
Hero.Position = UDim2.new(0.5, 0, 0, 26)
Hero.Size = UDim2.fromOffset(96, 96)
Hero.BackgroundColor3 = C.Accent
Hero.BorderSizePixel = 0
Hero.Parent = Content
corner(Hero, 48)

local HeroGrad = Instance.new("UIGradient")
HeroGrad.Color = ColorSequence.new(C.Accent, C.Accent2)
HeroGrad.Rotation = 45
HeroGrad.Parent = Hero

local HeroShadow = stroke(Hero, C.Accent, 0.5, 0.7)
HeroShadow.Thickness = 1

local HeroEmoji = Instance.new("TextLabel")
HeroEmoji.Size = UDim2.fromScale(1, 1)
HeroEmoji.BackgroundTransparency = 1
HeroEmoji.Text = "🍋"
HeroEmoji.TextSize = 44
HeroEmoji.Parent = Hero

-- Pulse animation
task.spawn(function()
    while Screen.Parent do
        tw(HeroGlow, {BackgroundTransparency = 0.97, Size = UDim2.fromOffset(200, 200)},
            1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
        tw(HeroGlow, {BackgroundTransparency = 0.92, Size = UDim2.fromOffset(180, 180)},
            1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
    end
end)

-- Big Title
local BigTitle = Instance.new("TextLabel")
BigTitle.AnchorPoint = Vector2.new(0.5, 0)
BigTitle.Position = UDim2.new(0.5, 0, 0, 138)
BigTitle.Size = UDim2.new(1, -40, 0, 26)
BigTitle.BackgroundTransparency = 1
BigTitle.Text = "LEMON HUB"
BigTitle.TextColor3 = C.Text
BigTitle.Font = FB
BigTitle.TextSize = 22
BigTitle.Parent = Content

local BigTitleGrad = Instance.new("UIGradient")
BigTitleGrad.Color = ColorSequence.new(C.Accent, C.Accent2)
BigTitleGrad.Rotation = 0
BigTitleGrad.Parent = BigTitle

-- Subtitle
local BigSub = Instance.new("TextLabel")
BigSub.AnchorPoint = Vector2.new(0.5, 0)
BigSub.Position = UDim2.new(0.5, 0, 0, 168)
BigSub.Size = UDim2.new(1, -40, 0, 14)
BigSub.BackgroundTransparency = 1
BigSub.Text = "ZYRONX  •  MOBILE EDITION"
BigSub.TextColor3 = C.Muted
BigSub.Font = FBD
BigSub.TextSize = 9
BigSub.Parent = Content

-- Divider
local Divider = Instance.new("Frame")
Divider.AnchorPoint = Vector2.new(0.5, 0)
Divider.Position = UDim2.new(0.5, 0, 0, 196)
Divider.Size = UDim2.fromOffset(56, 2)
Divider.BackgroundColor3 = C.Line
Divider.BackgroundTransparency = 0.3
Divider.BorderSizePixel = 0
Divider.Parent = Content
corner(Divider, 1)

-- Stats Row
local StatsRow = Instance.new("Frame")
StatsRow.Position = UDim2.fromOffset(16, 214)
StatsRow.Size = UDim2.new(1, -32, 0, 76)
StatsRow.BackgroundTransparency = 1
StatsRow.Parent = Content

local function statCard(icon, label, value, order)
    local cardW = (StatsRow.AbsoluteSize.X - 16) / 3
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(cardW, 76)
    card.Position = UDim2.fromOffset((order - 1) * (cardW + 8), 0)
    card.BackgroundColor3 = C.Card
    card.BorderSizePixel = 0
    card.Parent = StatsRow
    corner(card, 12)
    stroke(card, C.Line, 1, 0.5)

    card.MouseEnter:Connect(function()
        tw(card, {BackgroundColor3 = C.CardHi}, 0.15)
    end)
    card.MouseLeave:Connect(function()
        tw(card, {BackgroundColor3 = C.Card}, 0.15)
    end)

    local ico = Instance.new("TextLabel")
    ico.Position = UDim2.new(0, 0, 0, 8)
    ico.Size = UDim2.new(1, 0, 0, 22)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextSize = 16
    ico.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 0, 0, 34)
    lbl.Size = UDim2.new(1, 0, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.Muted
    lbl.Font = FBD
    lbl.TextSize = 8
    lbl.Parent = card

    local val = Instance.new("TextLabel")
    val.Position = UDim2.new(0, 0, 0, 50)
    val.Size = UDim2.new(1, 0, 0, 18)
    val.BackgroundTransparency = 1
    val.Text = value
    val.TextColor3 = C.Text
    val.Font = FBD
    val.TextSize = 12
    val.Parent = card

    return card
end

statCard("👤", "PLAYER", Player.DisplayName or Player.Name, 1)
statCard("🏷", "VERSION", "V3", 2)
statCard("📱", "PLATFORM", "Mobile", 3)

-- Status Pill
local StatusPill = Instance.new("Frame")
StatusPill.AnchorPoint = Vector2.new(0.5, 0)
StatusPill.Position = UDim2.new(0.5, 0, 0, 308)
StatusPill.Size = UDim2.fromOffset(96, 26)
StatusPill.BackgroundColor3 = Color3.fromRGB(30, 36, 46)
StatusPill.BorderSizePixel = 0
StatusPill.Parent = Content
corner(StatusPill, 13)
stroke(StatusPill, C.Line, 1, 0.4)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.fromOffset(7, 7)
StatusDot.Position = UDim2.new(0, 12, 0.5, -3.5)
StatusDot.BackgroundColor3 = C.Green
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusPill
corner(StatusDot, 4)

task.spawn(function()
    while Screen.Parent do
        tw(StatusDot, {BackgroundTransparency = 0.4}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.8)
        tw(StatusDot, {BackgroundTransparency = 0}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.8)
    end
end)

local StatusText = Instance.new("TextLabel")
StatusText.Position = UDim2.new(0, 26, 0, 0)
StatusText.Size = UDim2.new(1, -34, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "READY"
StatusText.TextColor3 = Color3.fromRGB(160, 220, 180)
StatusText.Font = FBD
StatusText.TextSize = 9
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusPill

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Position = UDim2.new(0, 0, 1, -24)
Footer.Size = UDim2.new(1, 0, 0, 16)
Footer.BackgroundTransparency = 1
Footer.Text = "LEMON HUB © 2025  •  ZYRONX"
Footer.TextColor3 = C.Muted2
Footer.Font = FBD
Footer.TextSize = 8
Footer.Parent = Content

--============ MINIMIZE ============
local FULL_H, MINI_H = 420, 56
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(Window, {Size = UDim2.fromOffset(340, minimized and MINI_H or FULL_H)},
        0.28, Enum.EasingStyle.Quint)
    Content.Visible = not minimized
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

--============ DRAG ============
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
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

--============ ENTRANCE ============
Window.Size = UDim2.fromOffset(300, 380)
task.wait(0.02)
tw(Window, {Size = UDim2.fromOffset(340, 420)}, 0.35,
    Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("LEMON HUB V3 — CLEAN UI LOADED")
