--[[
	FluxUI - Standalone Version for Exploits
	Copy this entire file into your exploit script
	No require() needed - everything is self-contained
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- FluxUI Table
local FluxUI = {}

-- Utility Functions
local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function create(class, props)
	local instance = Instance.new(class)
	for prop, value in pairs(props or {}) do
		if prop == "Parent" then
			instance.Parent = value
		else
			pcall(function()
				instance[prop] = value
			end)
		end
	end
	return instance
end

local function tween(instance, info, props)
	local tween = TweenService:Create(instance, TweenInfo.new(unpack(info)), props)
	tween:Play()
	return tween
end

-- Color Presets
FluxUI.Colors = {
	Primary = Color3.fromRGB(25, 25, 25),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(0, 162, 255),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	Success = Color3.fromRGB(0, 255, 127),
	Warning = Color3.fromRGB(255, 165, 0),
	Error = Color3.fromRGB(255, 0, 0),
}

-- Lucide Icons Asset IDs
-- Common Lucide icons for Roblox (using popular icon pack asset IDs)
FluxUI.Icons = {
	-- Navigation
	Home = "rbxassetid://6031075938",
	House = "rbxassetid://6031075938", -- Same as Home
	Settings = "rbxassetid://6031077403",
	Cog = "rbxassetid://6031077403", -- Same as Settings (gear/cog icon)
	User = "rbxassetid://6031075927",
	Users = "rbxassetid://6031075939",
	Menu = "rbxassetid://6031075937",
	
	-- Actions
	Play = "rbxassetid://6031077404",
	Pause = "rbxassetid://6031077405",
	Stop = "rbxassetid://6031077406",
	Refresh = "rbxassetid://6031077407",
	Download = "rbxassetid://6031077408",
	Upload = "rbxassetid://6031077409",
	Save = "rbxassetid://6031077410",
	Trash = "rbxassetid://6031077411",
	Edit = "rbxassetid://6031077412",
	
	-- Combat/Gaming
	Sword = "rbxassetid://6031077413",
	Swords = "rbxassetid://6031077413", -- Dual swords icon
	Shield = "rbxassetid://6031077414",
	Target = "rbxassetid://6031077415",
	Zap = "rbxassetid://6031077416",
	Flame = "rbxassetid://6031077417",
	
	-- UI Elements
	Check = "rbxassetid://6031077418",
	X = "rbxassetid://6031077419",
	Plus = "rbxassetid://6031077420",
	Minus = "rbxassetid://6031077421",
	ArrowRight = "rbxassetid://6031077422",
	ArrowLeft = "rbxassetid://6031077423",
	ChevronRight = "rbxassetid://6031077424",
	ChevronLeft = "rbxassetid://6031077425",
	
	-- Status
	Info = "rbxassetid://6031077426",
	Alert = "rbxassetid://6031077427",
	Warning = "rbxassetid://6031077428",
	Star = "rbxassetid://6031077429",
	Heart = "rbxassetid://6031077430",
	
	-- Default fallback
	Default = "rbxassetid://6031075938", -- Home icon as default
}

-- Notification API for scripts (standalone version)
function FluxUI:Notify(title, message, duration)
	duration = duration or 4000
	local notifGui = create("ScreenGui", {
		Name = "SFG_Notification",
		ResetOnSpawn = false,
		Parent = CoreGui
	})

	local container = create("Frame", {
		Name = "Container",
		Size = UDim2.new(0, 300, 0, 64),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -20, 0, 20),
		BackgroundColor3 = Color3.fromRGB(34,34,34),
		BorderSizePixel = 0,
		ZIndex = 10000,
		Parent = notifGui
	})

	local corner = create("UICorner", { CornerRadius = UDim.new(0,8), Parent = container })

	local titleLabel = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 6),
		BackgroundTransparency = 1,
		Text = tostring(title or "Notification"),
		TextColor3 = Color3.new(1,1,1),
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container
	})

	local msgLabel = create("TextLabel", {
		Name = "Message",
		Size = UDim2.new(1, -20, 0, 34),
		Position = UDim2.new(0, 10, 0, 26),
		BackgroundTransparency = 1,
		Text = tostring(message or ""),
		TextColor3 = Color3.fromRGB(200,200,200),
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = container
	})

	pcall(function()
		local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local startPos = container.Position
		container.Position = UDim2.new(1, 20, 0, 20)
		local tweenIn = TweenService:Create(container, info, { Position = startPos })
		tweenIn:Play()
	end)

	delay(duration/1000, function()
		pcall(function()
			local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local tweenOut = TweenService:Create(container, info, { Position = UDim2.new(1, 20, 0, 20), BackgroundTransparency = 1 })
			tweenOut:Play()
			tweenOut.Completed:Wait()
			notifGui:Destroy()
		end)
	end)
end

-- Get Icon Asset ID
function FluxUI:GetIcon(iconName)
	if type(iconName) == "string" then
		return FluxUI.Icons[iconName] or FluxUI.Icons.Default
	elseif type(iconName) == "number" then
		return "rbxassetid://" .. tostring(iconName)
	else
		return iconName -- Assume it's already an asset ID string
	end
end

-- Create Main ScreenGui
function FluxUI:CreateWindow(title, options)
	options = options or {}
	
	local window = {}
	window.Title = title or "SFG UI Window"
	window.CompactTitle = options.CompactTitle or "SFG Compact"
	window.Size = options.Size or (isMobile() and UDim2.new(0.95, 0, 0.95, 0) or UDim2.new(0, 500, 0, 400))
	window.Position = options.Position or (isMobile() and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0))
	window.Theme = options.Theme or "Dark"
	window.IsMinimized = false
	
	-- Main ScreenGui
	local screenGui = create("ScreenGui", {
		Name = "SFG UI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = CoreGui
	})
	
	-- Main Frame (centered on screen)
	local mainFrame = create("Frame", {
		Name = "MainFrame",
		Size = window.Size,
		Position = UDim2.new(0.5, 0, 0.5, 0), -- Centered: 50% from left, 50% from top
		AnchorPoint = Vector2.new(0.5, 0.5), -- Anchor from center
		BackgroundColor3 = FluxUI.Colors.Primary,
		BorderSizePixel = 0,
		Parent = screenGui
	})
	
	-- Corner
	local mainCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = mainFrame
	})
	
	-- Shadow
	local shadow = create("ImageLabel", {
		Name = "Shadow",
		Size = UDim2.new(1, 10, 1, 10),
		Position = UDim2.new(0, -5, 0, -5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		-- stronger shadow to better match HTML visualization
		ImageTransparency = 0.25,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 0,
		Parent = mainFrame
	})
	
	-- Top Bar
	local topBar = create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Parent = mainFrame
	})
	
	local topBarCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = topBar
	})
	
	-- Title Label
	local titleLabel = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -140, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = window.Title,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		Parent = topBar
	})
	
	-- Minimize Button (darkish gray background, left of close button)
	local minimizeButton = create("TextButton", {
		Name = "Minimize",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -70, 0, 4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Text = "−",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = topBar
	})
	
	local minimizeCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = minimizeButton
	})
	
	-- Close Button (5px from right, 4px from top for better alignment)
	local closeButton = create("TextButton", {
		Name = "Close",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -35, 0, 4),
		BackgroundColor3 = Color3.fromRGB(255, 50, 50),
		BorderSizePixel = 0,
		Text = "×",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = topBar
	})
	
	local closeCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = closeButton
	})
	
	-- Compact UI Frame (shown when minimized) - Top center of screen
	local compactFrame = create("Frame", {
		Name = "CompactFrame",
		Size = UDim2.new(0, 200, 0, 40),
		Position = UDim2.new(0.5, -100, 0, 10), -- Top center: X=50% offset -100 (half width), Y=0 offset 10px
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Visible = false,
		Parent = screenGui
	})
	
	local compactCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = compactFrame
	})
	
	local compactShadow = create("ImageLabel", {
		Name = "Shadow",
		Size = UDim2.new(1, 10, 1, 10),
		Position = UDim2.new(0, -5, 0, -5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 0,
		Parent = compactFrame
	})
	
	local compactTopBar = create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Parent = compactFrame
	})
	
	local compactTopBarCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = compactTopBar
	})
	
	local compactTitleLabel = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = window.CompactTitle,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		Parent = compactTopBar
	})
	
	local compactMaximizeButton = create("TextButton", {
		Name = "Maximize",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -35, 0, 4),
		BackgroundColor3 = Color3.fromRGB(60, 60, 60),
		BorderSizePixel = 0,
		Text = "+",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		Parent = compactTopBar
	})
	
	local compactMaximizeCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = compactMaximizeButton
	})
	
	-- Tab Container (vertical sidebar for tabs - extends from top to bottom)
	local tabContainer = create("Frame", {
		Name = "TabContainer",
		Size = UDim2.new(0, 160, 1, -40), -- Full height minus title bar
		Position = UDim2.new(0, 0, 0, 40), -- Starts below title bar
		BackgroundColor3 = FluxUI.Colors.Primary,
		BorderSizePixel = 0,
		Parent = mainFrame
	})
	
	-- Separation line between tab section and content
	local tabSeparator = create("Frame", {
		Name = "TabSeparator",
		Size = UDim2.new(0, 1, 1, -40),
		Position = UDim2.new(0, 160, 0, 40),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Parent = mainFrame
	})
	
	local tabContainerLayout = create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = tabContainer
	})
	
	local tabContainerPadding = create("UIPadding", {
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 5),
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		Parent = tabContainer
	})
	
	-- Content Frame (adjusted for title bar + vertical tab sidebar)
	local contentFrame = create("ScrollingFrame", {
		Name = "Content",
		Size = UDim2.new(1, -180, 1, -60), -- Adjusted for 160px tab container + 20px spacing
		Position = UDim2.new(0, 170, 0, 50), -- Adjusted position (160px tab + 10px spacing)
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = FluxUI.Colors.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = mainFrame
	})
	
	local contentLayout = create("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = contentFrame
	})
	
	local contentPadding = create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = contentFrame
	})
	
	-- Drag Functionality (for both main and compact frames)
	local dragging, dragInput, dragStart, startPos
	local currentDraggingFrame = nil
	
	local function update(input, frame)
		if not frame then return end
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
	
	local function setupDrag(frame, isTopBar)
		frame.InputBegan:Connect(function(input)
			-- Only allow dragging from topbar, not from buttons
			local target = input.Target
			if target and (target:IsA("TextButton") or target.Parent:IsA("TextButton")) then
				return -- Don't drag if clicking on buttons
			end
			
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				currentDraggingFrame = frame
				dragStart = input.Position
				startPos = frame.Position
				
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						currentDraggingFrame = nil
					end
				end)
			end
		end)
		
		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
	end
	
	-- Setup dragging only for topbars (not the entire window)
	setupDrag(topBar, true)
	setupDrag(compactTopBar, true)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and currentDraggingFrame then
			update(input, currentDraggingFrame)
		end
	end)
	
	-- Minimize Button
	minimizeButton.MouseButton1Click:Connect(function()
		window.IsMinimized = true
		-- Compact frame is always positioned at top center
		compactFrame.Position = UDim2.new(0.5, -100, 0, 10)
		
		-- Hide main frame, show compact frame
		mainFrame.Visible = false
		compactFrame.Visible = true
	end)
	
	-- Maximize Button (in compact frame)
	compactMaximizeButton.MouseButton1Click:Connect(function()
		window.IsMinimized = false
		-- Restore main frame to its original position (don't change it)
		
		-- Hide compact frame, show main frame
		compactFrame.Visible = false
		mainFrame.Visible = true
	end)
	
	-- Close Button - Clean up everything instantly
	closeButton.MouseButton1Click:Connect(function()
		-- Hide everything immediately to prevent any visual delay
		mainFrame.Visible = false
		compactFrame.Visible = false
		tabContainer.Visible = false
		contentFrame.Visible = false
		topBar.Visible = false
		
		-- Animate the close (optional visual effect)
		tween(mainFrame, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
			Size = UDim2.new(0, 0, 0, 0)
		})
		
		-- Clean up after animation
		wait(0.2)
		screenGui:Destroy()
	end)
	
	-- Update Canvas Size
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
	end)
	
	-- Window Methods
	window.Instance = screenGui
	window.MainFrame = mainFrame
	window.ContentFrame = contentFrame
	window.TopBar = topBar
	window.TabContainer = tabContainer
	window.CompactFrame = compactFrame
	
	function window:Destroy()
		screenGui:Destroy()
	end
	
	function window:Hide()
		mainFrame.Visible = false
		compactFrame.Visible = false
	end
	
	function window:Show()
		if window.IsMinimized then
			compactFrame.Visible = true
		else
			mainFrame.Visible = true
		end
	end
	
	function window:Minimize()
		window.IsMinimized = true
		-- Compact frame is always positioned at top center
		compactFrame.Position = UDim2.new(0.5, -100, 0, 10)
		mainFrame.Visible = false
		compactFrame.Visible = true
	end
	
	function window:Maximize()
		window.IsMinimized = false
		-- Restore main frame (don't change its position)
		compactFrame.Visible = false
		mainFrame.Visible = true
	end
	
	function window:SetCompactTitle(title)
		window.CompactTitle = title or "SFG Compact"
		compactTitleLabel.Text = window.CompactTitle
	end
	
	return window
end

-- Create Tab
function FluxUI:CreateTab(window, name, icon)
	local tab = {}
	tab.Name = name or "Tab"
	tab.Window = window
	
	-- Tab Button (vertical layout in sidebar)
	-- Ensure colors are available
	local secondaryColor = (FluxUI.Colors and FluxUI.Colors.Secondary) or Color3.fromRGB(35, 35, 35)
	local textSecondaryColor = (FluxUI.Colors and FluxUI.Colors.TextSecondary) or Color3.fromRGB(200, 200, 200)
	
	local tabButton = create("TextButton", {
		Name = name,
		Size = UDim2.new(1, -10, 0, 35),
		BackgroundColor3 = secondaryColor,
		BorderSizePixel = 0,
		Text = "",
		TextColor3 = textSecondaryColor,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = window.TabContainer
	})
	
	-- Icon support (if provided)
	local iconSize = 18
	local textOffset = 0
	if icon then
		local iconAssetId = FluxUI:GetIcon(icon)
		local iconImage = create("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Position = UDim2.new(0, 10, 0, (35 - iconSize) / 2),
			BackgroundTransparency = 1,
			Image = iconAssetId,
			ImageColor3 = textSecondaryColor,
			Parent = tabButton
		})
		textOffset = iconSize + 5
	end
	
	-- Tab Label
	local tabLabel = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -10 - textOffset, 1, 0),
		Position = UDim2.new(0, 10 + textOffset, 0, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = textSecondaryColor,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = tabButton
	})
	
	local tabButtonPadding = create("UIPadding", {
		PaddingLeft = UDim.new(0, 0),
		Parent = tabButton
	})
	
	local tabCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = tabButton
	})
	
	-- Tab Content
	local tabContent = create("Frame", {
		Name = name .. "Content",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = window.ContentFrame
	})
	
	local tabLayout = create("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = tabContent
	})
	
	local tabPadding = create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		Parent = tabContent
	})
	
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
	end)
	
	-- Tab Selection
	local function selectTab()
		-- Store colors locally to avoid nil errors - use fallback values
		local secondaryColor = (FluxUI.Colors and FluxUI.Colors.Secondary) or Color3.fromRGB(35, 35, 35)
		local accentColor = (FluxUI.Colors and FluxUI.Colors.Accent) or Color3.fromRGB(0, 162, 255)
		local textSecondaryColor = (FluxUI.Colors and FluxUI.Colors.TextSecondary) or Color3.fromRGB(200, 200, 200)
		
		-- Reset all tabs in tab container (only TextButtons)
		if window.TabContainer then
			for _, child in pairs(window.TabContainer:GetChildren()) do
				if child:IsA("TextButton") and child ~= tabButton then
					pcall(function()
						if child and child.Parent then
							child.BackgroundColor3 = secondaryColor
							local label = child:FindFirstChild("Label")
							if label then
								label.TextColor3 = textSecondaryColor
							end
							local icon = child:FindFirstChild("Icon")
							if icon then
								icon.ImageColor3 = textSecondaryColor
							end
						end
					end)
				end
			end
		end
		
		-- Hide all tab contents
		if window.ContentFrame then
			for _, child in pairs(window.ContentFrame:GetChildren()) do
				if child:IsA("Frame") and child.Name:match("Content") then
					child.Visible = false
				end
			end
		end
		
		-- Activate selected tab
		if tabButton and tabButton.Parent then
			pcall(function()
				tabButton.BackgroundColor3 = accentColor
				local label = tabButton:FindFirstChild("Label")
				if label then
					label.TextColor3 = Color3.new(1, 1, 1)
				end
				local icon = tabButton:FindFirstChild("Icon")
				if icon then
					icon.ImageColor3 = Color3.new(1, 1, 1)
				end
			end)
		end
		
		if tabContent then
			tabContent.Visible = true
		end
	end
	
	tabButton.MouseButton1Click:Connect(selectTab)
	
	-- Set as default if first tab
	if #window.TabContainer:GetChildren() == 1 then
		selectTab()
	end
	
	tab.Instance = tabButton
	tab.Content = tabContent
	
	return tab
end

-- Create Section
function FluxUI:CreateSection(tab, title)
	local section = {}
	section.Title = title or "Section"
	
	local sectionFrame = create("Frame", {
		Name = title,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Parent = tab.Content
	})
	
	local sectionCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = sectionFrame
	})
	
	local sectionPadding = create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 15),
		PaddingRight = UDim.new(0, 15),
		Parent = sectionFrame
	})
	
	local titleLabel = create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold,
		Parent = sectionFrame
	})
	
	local contentFrame = create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 25),
		BackgroundTransparency = 1,
		Parent = sectionFrame
	})
	
	local contentLayout = create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = contentFrame
	})
	
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		contentFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
		sectionFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 35)
	end)
	
	section.Instance = sectionFrame
	section.Content = contentFrame
	
	return section
end

-- Create Button
function FluxUI:CreateButton(section, text, callback, icon)
	local button = create("TextButton", {
		Name = text,
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = FluxUI.Colors.Accent,
		BorderSizePixel = 0,
		Text = "",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 14,
		Font = Enum.Font.Gotham,
		Parent = section.Content
	})
	
	-- Icon support (if provided)
	local iconSize = 18
	local textOffset = 0
	if icon then
		local iconAssetId = FluxUI:GetIcon(icon)
		local iconImage = create("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Position = UDim2.new(0, 10, 0, (35 - iconSize) / 2),
			BackgroundTransparency = 1,
			Image = iconAssetId,
			ImageColor3 = Color3.new(1, 1, 1),
			Parent = button
		})
		textOffset = iconSize + 5
	end
	
	-- Button Label
	local buttonLabel = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -20 - textOffset, 1, 0),
		Position = UDim2.new(0, 10 + textOffset, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = button
	})
	
	local buttonCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = button
	})
	
	button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
		tween(button, {0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
			Size = UDim2.new(0.98, 0, 0, 33)
		})
		wait(0.1)
		tween(button, {0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
			Size = UDim2.new(1, 0, 0, 35)
		})
	end)
	
	return button
end

-- Create Toggle
function FluxUI:CreateToggle(section, text, default, callback)
	local toggle = {}
	toggle.Value = default or false
	
	local toggleFrame = create("Frame", {
		Name = text,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = section.Content
	})
	
	local label = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = toggleFrame
	})
	
	local toggleButton = create("TextButton", {
		Name = "Toggle",
		Size = UDim2.new(0, 45, 0, 25),
		Position = UDim2.new(1, -45, 0, 2.5),
		BackgroundColor3 = toggle.Value and FluxUI.Colors.Accent or Color3.fromRGB(21, 21, 21),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(50, 50, 50),
		Text = "",
		Parent = toggleFrame
	})
	
	local toggleCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 12),
		Parent = toggleButton
	})
	
	local toggleDot = create("Frame", {
		Name = "Dot",
		Size = UDim2.new(0, 19, 0, 19),
		Position = UDim2.new(0, 3, 0, 3),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = toggleButton
	})
	
	local dotCorner = create("UICorner", {
		CornerRadius = UDim.new(0.5, 0),
		Parent = toggleDot
	})
	
	local function updateToggle()
		if toggle.Value then
			tween(toggleDot, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
				Position = UDim2.new(0, 23, 0, 3)
			})
			tween(toggleButton, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
				BackgroundColor3 = FluxUI.Colors.Accent
			})
		else
			tween(toggleDot, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
				Position = UDim2.new(0, 3, 0, 3)
			})
			tween(toggleButton, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
				BackgroundColor3 = Color3.fromRGB(21, 21, 21)
			})
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		toggle.Value = not toggle.Value
		updateToggle()
		if callback then
			callback(toggle.Value)
		end
	end)
	
	updateToggle()
	
	toggle.Instance = toggleFrame
	toggle.Button = toggleButton
	
	function toggle:Set(value)
		toggle.Value = value
		updateToggle()
		if callback then
			callback(toggle.Value)
		end
	end
	
	return toggle
end

-- Create Slider
function FluxUI:CreateSlider(section, text, min, max, default, callback)
	local slider = {}
	slider.Value = default or min
	slider.Min = min or 0
	slider.Max = max or 100
	
	local sliderFrame = create("Frame", {
		Name = text,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = section.Content
	})
	
	local labelFrame = create("Frame", {
		Name = "LabelFrame",
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Parent = sliderFrame
	})
	
	local label = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = labelFrame
	})
	
	-- Value display/input (clickable to edit)
	local valueContainer = create("Frame", {
		Name = "ValueContainer",
		Size = UDim2.new(0, 60, 1, 0),
		Position = UDim2.new(1, -60, 0, 0),
		BackgroundTransparency = 1,
		Parent = labelFrame
	})
	
	local valueLabel = create("TextLabel", {
		Name = "Value",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(slider.Value),
		TextColor3 = FluxUI.Colors.TextSecondary,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.Gotham,
		Parent = valueContainer
	})
	
	-- Editable TextBox (hidden by default)
	local valueTextBox = create("TextBox", {
		Name = "ValueInput",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Text = tostring(slider.Value),
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.Gotham,
		Visible = false,
		Parent = valueContainer
	})
	
	local valueTextBoxCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = valueTextBox
	})
	
	local valueTextBoxPadding = create("UIPadding", {
		PaddingRight = UDim.new(0, 5),
		Parent = valueTextBox
	})
	
	local track = create("Frame", {
		Name = "Track",
		Size = UDim2.new(1, 0, 0, 5),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Parent = sliderFrame
	})
	
	local trackCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 2),
		Parent = track
	})
	
	local fill = create("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Accent,
		BorderSizePixel = 0,
		Parent = track
	})
	
	local fillCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 2),
		Parent = fill
	})
	
	local dot = create("Frame", {
		Name = "Dot",
		Size = UDim2.new(0, 15, 0, 15),
		Position = UDim2.new(0, -7.5, 0, -5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = track
	})
	
	local dotCorner = create("UICorner", {
		CornerRadius = UDim.new(0.5, 0),
		Parent = dot
	})
	
	local function updateSlider(value)
		slider.Value = math.clamp(value, slider.Min, slider.Max)
		local percent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		dot.Position = UDim2.new(percent, -7.5, 0, -5)
		local displayValue = math.floor(slider.Value)
		valueLabel.Text = tostring(displayValue)
		if not valueTextBox:IsFocused() then
			valueTextBox.Text = tostring(displayValue)
		end
		if callback then
			callback(slider.Value)
		end
	end
	
	-- Click on value label to edit
	valueLabel.MouseButton1Click:Connect(function()
		valueLabel.Visible = false
		valueTextBox.Visible = true
		valueTextBox.Text = tostring(math.floor(slider.Value))
		valueTextBox:CaptureFocus()
	end)
	
	-- Handle value input
	valueTextBox.FocusLost:Connect(function(enterPressed)
		local inputValue = tonumber(valueTextBox.Text)
		if inputValue then
			updateSlider(inputValue)
		else
			valueTextBox.Text = tostring(math.floor(slider.Value))
		end
		valueTextBox.Visible = false
		valueLabel.Visible = true
	end)
	
	-- Also allow touch input for mobile
	valueLabel.TouchTap:Connect(function()
		valueLabel.Visible = false
		valueTextBox.Visible = true
		valueTextBox.Text = tostring(math.floor(slider.Value))
		valueTextBox:CaptureFocus()
	end)
	
	local dragging = false
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			updateSlider(slider.Min + (slider.Max - slider.Min) * percent)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			updateSlider(slider.Min + (slider.Max - slider.Min) * percent)
		end
	end)
	
	updateSlider(slider.Value)
	
	slider.Instance = sliderFrame
	
	function slider:Set(value)
		updateSlider(value)
	end
	
	return slider
end

-- Create TextBox
function FluxUI:CreateTextBox(section, placeholder, callback)
	local textBox = create("TextBox", {
		Name = placeholder,
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = placeholder,
		TextColor3 = FluxUI.Colors.Text,
		PlaceholderColor3 = FluxUI.Colors.TextSecondary,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		Parent = section.Content
	})
	
	local textBoxCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = textBox
	})
	
	local textBoxPadding = create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = textBox
	})
	
	textBox.FocusLost:Connect(function(enterPressed)
		if callback then
			callback(textBox.Text, enterPressed)
		end
	end)
	
	return textBox
end

-- Create Label
function FluxUI:CreateLabel(section, text)
	local label = create("TextLabel", {
		Name = text,
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = FluxUI.Colors.TextSecondary,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = section.Content
	})
	
	return label
end

-- Create Dropdown
function FluxUI:CreateDropdown(section, text, options, callback)
	local dropdown = {}
	dropdown.Options = options or {}
	dropdown.Value = nil
	dropdown.Open = false
	
	local dropdownFrame = create("Frame", {
		Name = text,
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundTransparency = 1,
		Parent = section.Content
	})
	
	local label = create("TextLabel", {
		Name = "Label",
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		Parent = dropdownFrame
	})
	
	local button = create("TextButton", {
		Name = "Button",
		Size = UDim2.new(0, 35, 0, 35),
		Position = UDim2.new(1, -35, 0, 0),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Text = "▼",
		TextColor3 = FluxUI.Colors.Text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		Parent = dropdownFrame
	})
	
	local buttonCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = button
	})
	
	local optionsFrame = create("ScrollingFrame", {
		Name = "Options",
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundColor3 = FluxUI.Colors.Secondary,
		BorderSizePixel = 0,
		Visible = false,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = FluxUI.Colors.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = dropdownFrame
	})
	
	local optionsCorner = create("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = optionsFrame
	})
	
	local optionsLayout = create("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = optionsFrame
	})
	
	local optionsPadding = create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		Parent = optionsFrame
	})
	
	optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		optionsFrame.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y + 10)
		optionsFrame.Size = UDim2.new(1, 0, 0, math.min(optionsLayout.AbsoluteContentSize.Y + 10, 150))
		dropdownFrame.Size = UDim2.new(1, 0, 0, dropdown.Open and (35 + math.min(optionsLayout.AbsoluteContentSize.Y + 10, 150)) or 35)
	end)
	
	for i, option in pairs(dropdown.Options) do
		local optionButton = create("TextButton", {
			Name = option,
			Size = UDim2.new(1, -10, 0, 30),
			Position = UDim2.new(0, 5, 0, 0),
			BackgroundColor3 = FluxUI.Colors.Primary,
			BorderSizePixel = 0,
			Text = option,
			TextColor3 = FluxUI.Colors.Text,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			LayoutOrder = i,
			Parent = optionsFrame
		})
		
		local optionCorner = create("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = optionButton
		})
		
		optionButton.MouseButton1Click:Connect(function()
			dropdown.Value = option
			label.Text = text .. ": " .. option
			dropdown.Open = false
			optionsFrame.Visible = false
			button.Text = "▼"
			dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
			if callback then
				callback(option)
			end
		end)
	end
	
	button.MouseButton1Click:Connect(function()
		dropdown.Open = not dropdown.Open
		optionsFrame.Visible = dropdown.Open
		button.Text = dropdown.Open and "▲" or "▼"
		if dropdown.Open then
			dropdownFrame.Size = UDim2.new(1, 0, 0, 35 + math.min(#dropdown.Options * 32 + 10, 150))
		else
			dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
		end
	end)
	
	dropdown.Instance = dropdownFrame
	dropdown.Button = button
	
	function dropdown:Set(value)
		if table.find(dropdown.Options, value) then
			dropdown.Value = value
			label.Text = text .. ": " .. value
			if callback then
				callback(value)
			end
		end
	end
	
	return dropdown
end

-- Make FluxUI globally available (for exploit environments)
_G.FluxUI = FluxUI

--[[
	EXAMPLE USAGE (paste below this line in your exploit):
	
	local window = FluxUI:CreateWindow("My Exploit UI")
	local tab = FluxUI:CreateTab(window, "Main")
	local section = FluxUI:CreateSection(tab, "Combat")
	FluxUI:CreateButton(section, "Kill All", function()
		print("Kill All clicked!")
	end)
]]

