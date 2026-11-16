--================================================
-- ⚡ ZYRONX UI | MOBILE EDITION
-- CLEAN SHOWCASE — KHÔNG CHỨC NĂNG / NO FEATURES
--================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("ZyronxUI")
if Old then Old:Destroy() end

--============ PALETTE ============
local C = {
    BgTop   = Color3.fromRGB(18, 20, 30),
    BgBot   = Color3.fromRGB(8, 9, 14),
    Glass   = Color3.fromRGB(28, 32, 46),
    GlassHi = Color3.fromRGB(38, 43, 62),
    Line    = Color3.fromRGB(58, 65, 92),
    Cyan    = Color3.fromRGB(0, 220, 255),
    Cyan2   = Color3.fromRGB(120, 90, 255),
    Text    = Color3.fromRGB(240, 243, 250),
    Muted   = Color3.fromRGB(130, 138, 165),
    Muted2  = Color3.fromRGB(80, 87, 112),
    Green   = Color3.fromRGB(70, 235, 145),
    Danger  = Color3.fromRGB(235, 80, 90),
}

local FB  = Enum.Font.GothamBlack
local FBD = Enum.Font.GothamBold
local FR  = Enum.Font.Gotham

--============ HELPERS ============
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2,
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

local function gradient(p, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0
    g.Parent = p
    return g
end

--============ ROOT ============
local Screen = Instance.new("ScreenGui")
Screen.Name = "ZyronxUI"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.DisplayOrder = 100
Screen.Parent = PlayerGui

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.Size = UDim2.fromOffset(300, 400)
Window.BackgroundColor3 = C.BgTop
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Active = true
Window.Parent = Screen
corner(Window, 22)

gradient(Window, C.BgTop, C.BgBot, 135)

local WinStroke = stroke(Window, C.Cyan, 1.2, 0.55)

-- Outer soft glow (viền phát sáng)
local OuterGlow = Instance.new("Frame")
OuterGlow.Name = "OuterGlow"
OuterGlow.AnchorPoint = Vector2.new(0.5, 0.5)
OuterGlow.Position = UDim2.fromScale(0.5, 0.5)
OuterGlow.Size = UDim2.new(1, 14, 1, 14)
OuterGlow.BackgroundColor3 = C.Cyan
OuterGlow.BackgroundTransparency = 0.96
OuterGlow.BorderSizePixel = 0
OuterGlow.ZIndex = 0
OuterGlow.Parent = Screen
corner(OuterGlow, 26)

-- Đồng bộ vị trí glow với window
RunService.RenderStepped:Connect(function()
    if not Window.Parent then
        OuterGlow:Destroy()
        return
    end
    OuterGlow.Position = Window.Position
    OuterGlow.Size = UDim2.new(
        Window.Size.X.Scale, Window.Size.X.Offset + 14,
        Window.Size.Y.Scale, Window.Size.Y.Offset + 14
    )
end)

--============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundTransparency = 1
Header.Parent = Window

-- Logo chữ Z
local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(34, 34)
Logo.Position = UDim2.new(0, 16, 0.5, -17)
Logo.BackgroundColor3 = C.Cyan
Logo.BorderSizePixel = 0
Logo.Parent = Header
corner(Logo, 9)

gradient(Logo, C.Cyan, C.Cyan2, 45)
stroke(Logo, C.Cyan, 1, 0.4)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Z"
LogoText.TextColor3 = Color3.fromRGB(10, 14, 22)
LogoText.Font = FB
LogoText.TextSize = 20
LogoText.Parent = Logo

-- Brand
local Brand = Instance.new("TextLabel")
Brand.Position = UDim2.new(0, 60, 0, 13)
Brand.Size = UDim2.new(1, -160, 0, 20)
Brand.BackgroundTransparency = 1
Brand.Text = "ZYRONX"
Brand.TextColor3 = C.Text
Brand.Font = FB
Brand.TextSize = 17
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.Parent = Header

local brandGrad = gradient(Brand, C.Text, C.Cyan, 0)

-- Tag
local Tag = Instance.new("TextLabel")
Tag.Position = UDim2.new(0, 60, 0, 33)
Tag.Size = UDim2.new(1, -160, 0, 12)
Tag.BackgroundTransparency = 1
Tag.Text = "MOBILE  •  EDITION"
Tag.TextColor3 = C.Muted
Tag.Font = FBD
Tag.TextSize = 8
Tag.TextXAlignment = Enum.TextXAlignment.Left
Tag.Parent = Header

-- Window controls
local function makeWinBtn(pos, label, hc, htc)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28, 28)
    b.Position = pos
    b.BackgroundColor3 = C.Glass
    b.Text = label
    b.TextColor3 = C.Muted
    b.Font = FBD
    b.TextSize = 14
    b.AutoButtonColor = false
    b.Parent = Header
    corner(b, 8)
    stroke(b, C.Line, 1, 0.6)

    b.MouseEnter:Connect(function()
        tw(b, {BackgroundColor3 = hc, TextColor3 = htc or C.Text}, 0.15)
    end)
    b.MouseLeave:Connect(function()
        tw(b, {BackgroundColor3 = C.Glass, TextColor3 = C.Muted}, 0.15)
    end)
    return b
end

local MinBtn   = makeWinBtn(UDim2.new(1, -72, 0, 15), "–", C.GlassHi)
local CloseBtn = makeWinBtn(UDim2.new(1, -40, 0, 15), "✕", C.Danger, C.Text)

-- Header divider
local HLine = Instance.new("Frame")
HLine.Position = UDim2.new(0, 16, 1, -1)
HLine.Size = UDim2.new(1, -32, 0, 1)
HLine.BackgroundColor3 = C.Line
HLine.BackgroundTransparency = 0.5
HLine.BorderSizePixel = 0
HLine.Parent = Header

--============ CONTENT ============
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(0, 58)
Content.Size = UDim2.new(1, 0, 1, -58)
Content.BackgroundTransparency = 1
Content.Parent = Window

-- Hero glow
local HeroGlow = Instance.new("Frame")
HeroGlow.AnchorPoint = Vector2.new(0.5, 0.5)
HeroGlow.Position = UDim2.new(0.5, 0, 0, 78)
HeroGlow.Size = UDim2.fromOffset(160, 160)
HeroGlow.BackgroundColor3 = C.Cyan
HeroGlow.BackgroundTransparency = 0.94
HeroGlow.BorderSizePixel = 0
HeroGlow.Parent = Content
corner(HeroGlow, 80)

-- Hero logo box
local Hero = Instance.new("Frame")
Hero.AnchorPoint = Vector2.new(0.5, 0)
Hero.Position = UDim2.new(0.5, 0, 0, 26)
Hero.Size = UDim2.fromOffset(88, 88)
Hero.BackgroundColor3 = C.Glass
Hero.BorderSizePixel = 0
Hero.Parent = Content
corner(Hero, 22)

gradient(Hero, C.Glass, C.GlassHi, 135)
local heroStroke = stroke(Hero, C.Cyan, 1.2, 0.35)

local HeroZ = Instance.new("TextLabel")
HeroZ.Size = UDim2.fromScale(1, 1)
HeroZ.BackgroundTransparency = 1
HeroZ.Text = "Z"
HeroZ.TextColor3 = C.Cyan
HeroZ.Font = FB
HeroZ.TextSize = 46
HeroZ.Parent = Hero

-- Hero pulse
task.spawn(function()
    while Screen.Parent and Window.Parent do
        tw(HeroGlow, {BackgroundTransparency = 0.97, Size = UDim2.fromOffset(180, 180)},
            2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
        tw(HeroGlow, {BackgroundTransparency = 0.92, Size = UDim2.fromOffset(160, 160)},
            2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(2)
    end
end)

-- Name
local BigBrand = Instance.new("TextLabel")
BigBrand.AnchorPoint = Vector2.new(0.5, 0)
BigBrand.Position = UDim2.new(0.5, 0, 0, 126)
BigBrand.Size = UDim2.new(1, -40, 0, 28)
BigBrand.BackgroundTransparency = 1
BigBrand.Text = "ZYRONX"
BigBrand.TextColor3 = C.Text
BigBrand.Font = FB
BigBrand.TextSize = 26
BigBrand.Parent = Content
gradient(BigBrand, C.Text, C.Cyan, 90)

-- Sub
local BigSub = Instance.new("TextLabel")
BigSub.AnchorPoint = Vector2.new(0.5, 0)
BigSub.Position = UDim2.new(0.5, 0, 0, 156)
BigSub.Size = UDim2.new(1, -40, 0, 14)
BigSub.BackgroundTransparency = 1
BigSub.Text = "PREMIUM MOBILE INTERFACE"
BigSub.TextColor3 = C.Muted
BigSub.Font = FBD
BigSub.TextSize = 9
BigSub.Parent = Content

-- Divider
local Div = Instance.new("Frame")
Div.AnchorPoint = Vector2.new(0.5, 0)
Div.Position = UDim2.new(0.5, 0, 0, 184)
Div.Size = UDim2.fromOffset(48, 1)
Div.BackgroundColor3 = C.Line
Div.BackgroundTransparency = 0.4
Div.BorderSizePixel = 0
Div.Parent = Content

-- Info cards
local Cards = Instance.new("Frame")
Cards.Position = UDim2.fromOffset(16, 200)
Cards.Size = UDim2.new(1, -32, 0, 70)
Cards.BackgroundTransparency = 1
Cards.Parent = Content

local function infoCard(icon, label, value, order)
    local cardW = (Cards.AbsoluteSize.X - 16) / 3
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(cardW, 70)
    card.Position = UDim2.fromOffset((order - 1) * (cardW + 8), 0)
    card.BackgroundColor3 = C.Glass
    card.BorderSizePixel = 0
    card.Parent = Cards
    corner(card, 12)
    stroke(card, C.Line, 1, 0.5)

    card.MouseEnter:Connect(function()
        tw(card, {BackgroundColor3 = C.GlassHi}, 0.15)
    end)
    card.MouseLeave:Connect(function()
        tw(card, {BackgroundColor3 = C.Glass}, 0.15)
    end)

    local ico = Instance.new("TextLabel")
    ico.Position = UDim2.new(0, 0, 0, 8)
    ico.Size = UDim2.new(1, 0, 0, 20)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextSize = 15
    ico.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 0, 0, 30)
    lbl.Size = UDim2.new(1, 0, 0, 11)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.Muted
    lbl.Font = FBD
    lbl.TextSize = 7
    lbl.Parent = card

    local val = Instance.new("TextLabel")
    val.Position = UDim2.new(0, 0, 0, 44)
    val.Size = UDim2.new(1, 0, 0, 18)
    val.BackgroundTransparency = 1
    val.Text = value
    val.TextColor3 = C.Text
    val.Font = FBD
    val.TextSize = 11
    val.Parent = card

    return card
end

local nameStr = Player.DisplayName or Player.Name
if #nameStr > 8 then nameStr = nameStr:sub(1, 8) .. "…" end

infoCard("👤", "USER", nameStr, 1)
infoCard("⚡", "VER", "V3.0", 2)
infoCard("📱", "MODE", "Mobile", 3)

-- Status pill
local Pill = Instance.new("Frame")
Pill.AnchorPoint = Vector2.new(0.5, 0)
Pill.Position = UDim2.new(0.5, 0, 0, 288)
Pill.Size = UDim2.fromOffset(110, 28)
Pill.BackgroundColor3 = C.Glass
Pill.BorderSizePixel = 0
Pill.Parent = Content
corner(Pill, 14)
stroke(Pill, C.Line, 1, 0.4)

local Dot = Instance.new("Frame")
Dot.Size = UDim2.fromOffset(7, 7)
Dot.Position = UDim2.new(0, 14, 0.5, -3.5)
Dot.BackgroundColor3 = C.Green
Dot.BorderSizePixel = 0
Dot.Parent = Pill
corner(Dot, 4)

task.spawn(function()
    while Screen.Parent and Window.Parent do
        tw(Dot, {BackgroundTransparency = 0.5}, 0.9,
            Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
        tw(Dot, {BackgroundTransparency = 0}, 0.9,
            Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.9)
    end
end)

local PillText = Instance.new("TextLabel")
PillText.Position = UDim2.new(0, 28, 0, 0)
PillText.Size = UDim2.new(1, -36, 1, 0)
PillText.BackgroundTransparency = 1
PillText.Text = "SYSTEM ONLINE"
PillText.TextColor3 = Color3.fromRGB(160, 235, 190)
PillText.Font = FBD
PillText.TextSize = 9
PillText.TextXAlignment = Enum.TextXAlignment.Left
PillText.Parent = Pill

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Position = UDim2.new(0, 0, 1, -28)
Footer.Size = UDim2.new(1, 0, 0, 16)
Footer.BackgroundTransparency = 1
Footer.Text = "ZYRONX © 2025  •  UI SHOWCASE"
Footer.TextColor3 = C.Muted2
Footer.Font = FBD
Footer.TextSize = 8
Footer.Parent = Content

--============ MINIMIZE ============
local FULL_H, MINI_H = 400, 58
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(Window, {Size = UDim2.fromOffset(300, minimized and MINI_H or FULL_H)},
        0.28, Enum.EasingStyle.Quint)
    Content.Visible = not minimized
    MinBtn.Text = minimized and "+" or "–"
end)

--============ CLOSE ============
CloseBtn.MouseButton1Click:Connect(function()
    tw(Window, {Size = UDim2.fromOffset(240, 300)},
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
Window.Size = UDim2.fromOffset(280, 380)
task.wait(0.02)
tw(Window, {Size = UDim2.fromOffset(300, 400)}, 0.35,
    Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("ZYRONX UI LOADED")
