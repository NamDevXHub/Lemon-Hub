--==============================================================
--  LEMON HUB — UI DESIGN
--  by NamDevXHub
--  Chỉ là giao diện, dán vào LocalScript trong StarterPlayerScripts
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================= THEME =========================
local T = {
	Accent     = Color3.fromRGB(255, 214, 10),
	AccentDark = Color3.fromRGB(190, 155, 0),
	Bg         = Color3.fromRGB(20, 20, 24),
	Card       = Color3.fromRGB(30, 30, 36),
	Element    = Color3.fromRGB(42, 42, 50),
	Text       = Color3.fromRGB(238, 238, 242),
	TextDim    = Color3.fromRGB(140, 140, 150),
	Line       = Color3.fromRGB(58, 58, 68),
	Font       = Enum.Font.Gotham,
	FontMed    = Enum.Font.GothamMedium,
	FontBold   = Enum.Font.GothamBold,
}

--========================= HELPERS =========================
local function new(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props) do i[k] = v end
	if parent then i.Parent = parent end
	return i
end

local function corner(radius, parent)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(color, thickness, transparency, parent)
	return new("UIStroke", { Color = color, Thickness = thickness, Transparency = transparency or 0 }, parent)
end

local function tween(inst, time, goal, style)
	local t = TweenService:Create(inst, TweenInfo.new(time, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
	t:Play()
	return t
end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--========================= SCREEN GUI =========================
local gui = new("ScreenGui", {
	Name = "LemonHubUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

--========================= NÚT BẬT / TẮT =========================
local holder = new("Frame", {
	Name = "ToggleHolder",
	Size = UDim2.fromOffset(80, 54),
	Position = UDim2.new(0, 24, 0.5, -27),
	BackgroundTransparency = 1,
	Parent = gui,
})
makeDraggable(holder, holder)

-- nút vuông
local btn = new("Frame", {
	Name = "SquareButton",
	Size = UDim2.fromOffset(54, 54),
	BackgroundColor3 = T.Accent,
	Parent = holder,
})
corner(16, btn)
local btnStroke = stroke(T.AccentDark, 2, 0.15, btn)

-- vòng tròn bên trong nút
local circle = new("Frame", {
	Name = "Circle",
	Size = UDim2.fromOffset(34, 34),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundColor3 = T.Bg,
	Parent = btn,
})
corner(999, circle)

local icon = new("TextLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "≡",
	Font = T.FontBold,
	TextSize = 22,
	TextColor3 = T.Accent,
	Parent = circle,
})

-- ô tròn nằm cạnh nút vuông (đèn trạng thái)
local dot = new("Frame", {
	Name = "SideDot",
	Size = UDim2.fromOffset(14, 14),
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 62, 0.5, 0),
	BackgroundColor3 = T.Element,
	Parent = holder,
})
corner(999, dot)
local dotStroke = stroke(T.Line, 1, 0, dot)

local clickArea = new("TextButton", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "",
	Parent = btn,
})

--========================= PANEL =========================
local panel = new("Frame", {
	Name = "Panel",
	Size = UDim2.fromOffset(420, 520),
	Position = UDim2.new(1, -460, 0.5, -260),
	BackgroundColor3 = T.Bg,
	Visible = false,
	ClipsDescendants = true,
	Parent = gui,
})
corner(18, panel)
stroke(T.Line, 1, 0.2, panel)

local panelScale = new("UIScale", { Scale = 0.92 }, panel)

-- Header
local header = new("Frame", {
	Size = UDim2.new(1, 0, 0, 62),
	BackgroundTransparency = 1,
	Parent = panel,
})

local title = new("TextLabel", {
	Size = UDim2.new(1, -100, 0, 22),
	Position = UDim2.new(0, 18, 0, 12),
	BackgroundTransparency = 1,
	Text = "LEMON HUB",
	Font = T.FontBold,
	TextSize = 19,
	TextColor3 = T.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = header,
})

local subtitle = new("TextLabel", {
	Size = UDim2.new(1, -100, 0, 16),
	Position = UDim2.new(0, 18, 0, 34),
	BackgroundTransparency = 1,
	Text = "by NamDevXHub",
	Font = T.FontMed,
	TextSize = 12,
	TextColor3 = T.Accent,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = header,
})

local closeBtn = new("TextButton", {
	Size = UDim2.fromOffset(28, 28),
	Position = UDim2.new(1, -42, 0, 17),
	BackgroundColor3 = T.Element,
	Text = "✕",
	Font = T.FontBold,
	TextSize = 13,
	TextColor3 = T.TextDim,
	AutoButtonColor = false,
	Parent = header,
})
corner(9, closeBtn)
closeBtn.MouseEnter:Connect(function() tween(closeBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(220, 70, 70), TextColor3 = Color3.fromRGB(255,255,255) }) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, 0.15, { BackgroundColor3 = T.Element, TextColor3 = T.TextDim }) end)

-- Tab bar
local tabBar = new("Frame", {
	Size = UDim2.new(1, -36, 0, 34),
	Position = UDim2.new(0, 18, 0, 62),
	BackgroundColor3 = T.Card,
	Parent = panel,
})
corner(10, tabBar)

local tabIndicator = new("Frame", {
	Size = UDim2.new(0, 0, 0, 3),
	Position = UDim2.new(0, 0, 1, -3),
	BackgroundColor3 = T.Accent,
	Parent = tabBar,
})
corner(2, tabIndicator)

-- Content
local content = new("ScrollingFrame", {
	Size = UDim2.new(1, -36, 1, -160),
	Position = UDim2.new(0, 18, 0, 110),
	BackgroundTransparency = 1,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = T.Accent,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Parent = panel,
})
new("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, content)

--========================= COMPONENTS =========================
local function sectionLabel(text)
	local lbl = new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = string.upper(text),
		Font = T.FontBold,
		TextSize = 11,
		TextColor3 = T.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = content,
	})
	return lbl
end

local function toggleRow(text, default, callback)
	local row = new("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = T.Card,
		Parent = content,
	})
	corner(10, row)

	new("TextLabel", {
		Size = UDim2.new(1, -80, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		Font = T.FontMed,
		TextSize = 14,
		TextColor3 = T.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local sw = new("Frame", {
		Size = UDim2.fromOffset(42, 22),
		Position = UDim2.new(1, -56, 0.5, -11),
		BackgroundColor3 = T.Element,
		Parent = row,
	})
	corner(11, sw)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(0, 3, 0.5, -8),
		BackgroundColor3 = T.TextDim,
		Parent = sw,
	})
	corner(999, knob)

	local state = default and true or false
	local function apply(anim)
		local goalPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local goalBg = state and T.Accent or T.Element
		local goalKnob = state and Color3.fromRGB(30, 30, 34) or T.TextDim
		if anim then
			tween(knob, 0.18, { Position = goalPos }, Enum.EasingStyle.Back)
			tween(sw, 0.18, { BackgroundColor3 = goalBg })
			tween(knob, 0.18, { BackgroundColor3 = goalKnob })
		else
			knob.Position = goalPos
			sw.BackgroundColor3 = goalBg
			knob.BackgroundColor3 = goalKnob
		end
	end
	apply(false)

	new("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		Parent = sw,
	}).MouseButton1Click:Connect(function()
		state = not state
		apply(true)
		if callback then callback(state) end
	end)

	return row
end

local function sliderRow(text, min, max, default, step, callback)
	local row = new("Frame", {
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = T.Card,
		Parent = content,
	})
	corner(10, row)

	new("TextLabel", {
		Size = UDim2.new(1, -70, 0, 18),
		Position = UDim2.new(0, 14, 0, 8),
		BackgroundTransparency = 1,
		Text = text,
		Font = T.FontMed,
		TextSize = 14,
		TextColor3 = T.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local valueLbl = new("TextLabel", {
		Size = UDim2.new(0, 60, 0, 18),
		Position = UDim2.new(1, -74, 0, 8),
		BackgroundTransparency = 1,
		Text = tostring(default),
		Font = T.FontBold,
		TextSize = 13,
		TextColor3 = T.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})

	local track = new("Frame", {
		Size = UDim2.new(1, -28, 0, 6),
		Position = UDim2.new(0, 14, 1, -18),
		BackgroundColor3 = T.Element,
		Parent = row,
	})
	corner(3, track)

	local ratio = (default - min) / (max - min)
	local fill = new("Frame", {
		Size = UDim2.new(ratio, 0, 1, 0),
		BackgroundColor3 = T.Accent,
		Parent = track,
	})
	corner(3, fill)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(14, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(ratio, 0, 0.5, 0),
		BackgroundColor3 = T.Text,
		Parent = track,
	})
	corner(999, knob)
	stroke(T.Accent, 2, 0, knob)

	local dragging = false
	local function setFromInput(posX)
		local rel = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local raw = min + (max - min) * rel
		local val = math.floor(raw / step + 0.5) * step
		local r = (val - min) / (max - min)
		fill.Size = UDim2.new(r, 0, 1, 0)
		knob.Position = UDim2.new(r, 0, 0.5, 0)
		valueLbl.Text = (step >= 1) and tostring(math.floor(val)) or string.format("%.1f", val)
		if callback then callback(val) end
	end

	local hit = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.new(0, 0, 0.5, -11),
		BackgroundTransparency = 1,
		Text = "",
		Parent = track,
	})
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromInput(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			setFromInput(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return row
end

local function actionButton(text, callback)
	local b = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = T.Accent,
		Text = text,
		Font = T.FontBold,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(25, 25, 28),
		AutoButtonColor = false,
		Parent = content,
	})
	corner(10, b)
	b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 228, 90) }) end)
	b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = T.Accent }) end)
	b.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
	return b
end

--========================= NỘI DUNG MẪU =========================
sectionLabel("Combat")
toggleRow("Aim Assist", false, function(v) print("Aim Assist:", v) end)
toggleRow("Auto Parry", false, function(v) print("Auto Parry:", v) end)

sectionLabel("Visual")
toggleRow("ESP Box", false, function(v) print("ESP:", v) end)
sliderRow("FOV Radius", 20, 300, 90, 5, function(v) print("FOV:", v) end)

sectionLabel("Misc")
sliderRow("Walk Speed", 16, 100, 16, 1, function(v) print("Speed:", v) end)
actionButton("Reset Settings", function() print("Reset!") end)

--========================= OPEN / CLOSE =========================
local isOpen = false
local openTween

local function setOpen(state)
	if isOpen == state then return end
	isOpen = state

	if openTween then openTween:Cancel() end

	if state then
		panel.Visible = true
		panelScale.Scale = 0.92
		openTween = tween(panelScale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
		tween(icon, 0.22, { Rotation = 90, Text = "✕" })
		tween(btn, 0.22, { BackgroundColor3 = T.AccentDark })
		tween(dot, 0.22, { BackgroundColor3 = T.Accent })
		tween(dotStroke, 0.22, { Transparency = 1 })
	else
		openTween = tween(panelScale, 0.16, { Scale = 0.88 })
		task.delay(0.16, function()
			if not isOpen then panel.Visible = false end
		end)
		tween(icon, 0.22, { Rotation = 0, Text = "≡" })
		tween(btn, 0.22, { BackgroundColor3 = T.Accent })
		tween(dot, 0.22, { BackgroundColor3 = T.Element })
		tween(dotStroke, 0.22, { Transparency = 0 })
	end
end

clickArea.MouseButton1Click:Connect(function()
	setOpen(not isOpen)
end)
closeBtn.MouseButton1Click:Connect(function()
	setOpen(false)
end)

-- kéo panel bằng header
makeDraggable(header, panel)
