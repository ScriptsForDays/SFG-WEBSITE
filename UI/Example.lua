--[[
	FluxUI Example Usage
	This demonstrates how to use FluxUI in your exploits
	
	LOADING METHODS:
	1. If using FluxUI_Standalone.lua, FluxUI is already available as _G.FluxUI
	2. If using FluxUI.lua as a module, use: local FluxUI = require(script.Parent.FluxUI)
	3. For exploits, copy FluxUI_Standalone.lua content directly into your script
	
	FIXES APPLIED:
	- Tabs now have their own dedicated container below the title bar
	- Fixed color assignment errors with proper error handling and nil checks
	- All color assignments use fallback values to prevent nil errors
	- Enhanced safety checks for object existence before property access
	- Clean, organized layout with proper spacing
]]

-- Load FluxUI with error handling
local FluxUI

-- Method 1: Try global (if standalone version was loaded)
if _G.FluxUI then
	FluxUI = _G.FluxUI
-- Method 2: Try require (if using module version)
elseif script and script.Parent then
	-- Extra fallback: if a ModuleScript named 'FluxUI_Standalone' is a sibling, try require it
	local standaloneModule = script.Parent:FindFirstChild("FluxUI_Standalone")
	if standaloneModule and standaloneModule:IsA("ModuleScript") then
		local ok, mod = pcall(function() return require(standaloneModule) end)
		if ok and mod then
			FluxUI = mod
		end
	end

	-- Final fallback: attempt to load the standalone via raw GitHub (single-call like other UIs)
	if not FluxUI then
		local okHttp = pcall(function() return game.HttpGet end)
		if okHttp and game.HttpGet then
			local url = "https://raw.githubusercontent.com/ScriptsForDays/FluxUI-Lib/main/UI/FluxUI_Standalone.lua"
			local ok, res = pcall(function() return game:HttpGet(url) end)
			if ok and res and res ~= "" then
				local fok, fres = pcall(function() return loadstring(res)() end)
				-- standalone may return a module or set _G.FluxUI
				if fok and fres then
					FluxUI = fres
				elseif _G and _G.FluxUI then
					FluxUI = _G.FluxUI
				end
			end
		end
	end
	-- Still fallback to a local module if present
	local success, result = pcall(function()
		return require(script.Parent.FluxUI)
	end)
	if success and result then
		FluxUI = result
	end
end

-- Error if FluxUI still not loaded
if not FluxUI then
	warn("FluxUI not found! Make sure to load FluxUI_Standalone.lua first, or use require() for FluxUI.lua")
	return
end

-- Verify FluxUI has required methods
if not FluxUI.CreateWindow or not FluxUI.CreateTab then
	warn("FluxUI is missing required methods! Make sure you're using the correct version.")
	return
end

-- Create Window with error handling
-- Note: Tabs are now displayed in a dedicated container below the title bar
local window
local success, err = pcall(function()
	window = FluxUI:CreateWindow("SFG UI Preview", {
		Size = UDim2.new(0, 500, 0, 400),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Theme = "Dark"
	})
end)

if not success or not window then
	warn("Failed to create window:", err)
	return
end

-- Create 3 Example Tabs with error handling
-- Tabs are automatically positioned in the tab container (below title bar)
local mainTab, combatTab, settingsTab

success, err = pcall(function()
	mainTab = FluxUI:CreateTab(window, "Main", "House")
	combatTab = FluxUI:CreateTab(window, "Combat", "Swords")
	settingsTab = FluxUI:CreateTab(window, "Settings", "Cog")
end)

if not success then
	warn("Failed to create tabs:", err)
	return
end

-- Verify tab container exists (fix verification)
if window.TabContainer then
	print("✓ Tab container created successfully")
else
	warn("⚠ Tab container not found - tabs may not display correctly")
end

-- Main Tab Content (with error handling)
if mainTab then
	local welcomeSection = FluxUI:CreateSection(mainTab, "Welcome")
	FluxUI:CreateLabel(welcomeSection, "Welcome to SFG UI!")
	FluxUI:CreateLabel(welcomeSection, "A clean, modern UI library — for your scripts' needs.")

	local quickActionsSection = FluxUI:CreateSection(mainTab, "Quick Actions")
	FluxUI:CreateButton(quickActionsSection, "Execute Script", function()
		print("Script executed!")
		-- Your exploit code here
	end, "Play")

	FluxUI:CreateButton(quickActionsSection, "Clear Console", function()
		print("Console cleared!")
		-- Your exploit code here
	end, "Refresh")

	local featuresSection = FluxUI:CreateSection(mainTab, "Features")
	local espToggle = FluxUI:CreateToggle(featuresSection, "ESP", false, function(value)
		print("ESP:", value and "Enabled" or "Disabled")
		-- Your exploit code here
	end)

	local walkSpeedSlider = FluxUI:CreateSlider(featuresSection, "Walk Speed", 16, 200, 16, function(value)
		print("Walk Speed:", value)
		-- Your exploit code here
	end)
end

-- Combat Tab Content (with error handling)
if combatTab then
	local combatSection = FluxUI:CreateSection(combatTab, "Combat Features")
	FluxUI:CreateButton(combatSection, "Kill All", function()
		print("Kill All executed!")
		-- Your exploit code here
	end)

	FluxUI:CreateButton(combatSection, "Teleport to Spawn", function()
		print("Teleporting to spawn...")
		-- Your exploit code here
	end)

	local combatSettingsSection = FluxUI:CreateSection(combatTab, "Combat Settings")
	local autoAttackToggle = FluxUI:CreateToggle(combatSettingsSection, "Auto Attack", false, function(value)
		print("Auto Attack:", value)
		-- Your exploit code here
	end)

	local damageMultiplierSlider = FluxUI:CreateSlider(combatSettingsSection, "Damage Multiplier", 1, 10, 1, function(value)
		print("Damage Multiplier:", value)
		-- Your exploit code here
	end)
end

-- Settings Tab Content (with error handling)
if settingsTab then
	local visualSection = FluxUI:CreateSection(settingsTab, "Visual Settings")
	FluxUI:CreateLabel(visualSection, "Choose your preferred theme")
	local themeDropdown = FluxUI:CreateDropdown(visualSection, "Theme", {"Dark", "Light", "Blue"}, function(value)
		print("Theme selected:", value)
		-- Your exploit code here
	end)

	local configSection = FluxUI:CreateSection(settingsTab, "Configuration")
	FluxUI:CreateTextBox(configSection, "Enter config name...", function(text, enterPressed)
		if text ~= "" then
			print("Config name:", text)
			-- Your exploit code here
		end
	end)
	-- Notifications test button (uses FluxUI:Notify if available)
	local notifSection = FluxUI:CreateSection(settingsTab, "Notifications")
	FluxUI:CreateButton(notifSection, "Test Notification", function()
		pcall(function()
			if FluxUI.Notify then
				FluxUI:Notify("Test Notification", "This is a test notification.", 2000)
			else
				warn("Notify API not available.")
			end
		end)
	end)
end

print("✓ FluxUI Example loaded successfully!")
print("✓ All tabs created with proper error handling")
print("✓ Color assignment fixes applied")

-- Window Control Examples
--[[
	-- Toggle window visibility
	window:Hide() -- Hide window
	window:Show() -- Show window
	
	-- Destroy window
	window:Destroy() -- Destroy window
	
	-- Access window components
	print(window.MainFrame)      -- Main window frame
	print(window.ContentFrame)   -- Scrollable content area
	print(window.TopBar)         -- Title bar with close button
	print(window.TabContainer)   -- Tab container (NEW - separate from title bar)
]]

-- Component Control Examples
--[[
	-- Update toggle programmatically
	espToggle:Set(true)
	
	-- Update slider programmatically
	walkSpeedSlider:Set(100)
	
	-- Update dropdown programmatically
	themeDropdown:Set("Blue")
]]

