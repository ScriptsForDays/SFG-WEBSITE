# FluxUI - Premium Customizable UI Library

A highly customizable UI library for Roblox exploits that supports both PC and mobile platforms.

## Features

- ✅ **Fully Customizable** - Edit all UI components easily
- ✅ **Cross-Platform** - Works on PC and Mobile devices
- ✅ **Modern Design** - Beautiful, smooth animations
- ✅ **Component-Based** - Easy to use and extend
- ✅ **Client-Side** - Ready for exploit integration

## Components

### Window
Create a main window for your UI.

```lua
local window = FluxUI:CreateWindow("Title", {
    Size = UDim2.new(0, 500, 0, 400),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Theme = "Dark"
})
```

### Tab
Create tabs to organize your UI. Supports Lucide icons!

```lua
-- Tab without icon
local tab = FluxUI:CreateTab(window, "Tab Name")

-- Tab with icon (using icon name)
local tab = FluxUI:CreateTab(window, "Main", "Home")

-- Tab with custom icon asset ID
local tab = FluxUI:CreateTab(window, "Settings", 6031077403)
```

### Section
Group related controls together.

```lua
local section = FluxUI:CreateSection(tab, "Section Name")
```

### Button
Create clickable buttons. Supports Lucide icons!

```lua
-- Button without icon
FluxUI:CreateButton(section, "Button Text", function()
    -- Your code here
end)

-- Button with icon
FluxUI:CreateButton(section, "Execute Script", function()
    -- Your code here
end, "Play")
```

### Toggle
Create on/off switches.

```lua
local toggle = FluxUI:CreateToggle(section, "Toggle Name", false, function(value)
    print("Toggle:", value)
end)
```

### Slider
Create adjustable sliders.

```lua
local slider = FluxUI:CreateSlider(section, "Slider Name", 0, 100, 50, function(value)
    print("Value:", value)
end)
```

### TextBox
Create input fields.

```lua
FluxUI:CreateTextBox(section, "Placeholder text", function(text, enterPressed)
    print("Text:", text)
end)
```

### Label
Create text labels.

```lua
FluxUI:CreateLabel(section, "Label Text")
```

### Dropdown
Create selection dropdowns.

```lua
local dropdown = FluxUI:CreateDropdown(section, "Dropdown Name", {"Option 1", "Option 2"}, function(value)
    print("Selected:", value)
end)
```

## Lucide Icons

FluxUI supports Lucide icons similar to WindUI! You can add icons to tabs and buttons.

### Available Icons

Common icon names you can use:
- **Navigation**: `Home`, `Settings`, `User`, `Users`, `Menu`
- **Actions**: `Play`, `Pause`, `Stop`, `Refresh`, `Download`, `Upload`, `Save`, `Trash`, `Edit`
- **Combat/Gaming**: `Sword`, `Shield`, `Target`, `Zap`, `Flame`
- **UI Elements**: `Check`, `X`, `Plus`, `Minus`, `ArrowRight`, `ArrowLeft`, `ChevronRight`, `ChevronLeft`
- **Status**: `Info`, `Alert`, `Warning`, `Star`, `Heart`

### Using Icons

```lua
-- Use icon name (string)
FluxUI:CreateTab(window, "Main", "Home")
FluxUI:CreateButton(section, "Save", function() end, "Save")

-- Use asset ID (number)
FluxUI:CreateTab(window, "Settings", 6031077403)

-- Use full asset ID string
FluxUI:CreateTab(window, "Profile", "rbxassetid://6031075927")

-- Get icon asset ID programmatically
local iconId = FluxUI:GetIcon("Home")
```

### Adding Custom Icons

Add your own icons to `FluxUI.Icons`:

```lua
FluxUI.Icons.MyCustomIcon = "rbxassetid://1234567890"
FluxUI:CreateTab(window, "Custom", "MyCustomIcon")
```

## Customization

### Colors
Edit colors in `FluxUI.Colors`:

```lua
FluxUI.Colors = {
    Primary = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255),
    -- ... more colors
}
```

### Component Editing
All components return instances that you can modify:

```lua
local button = FluxUI:CreateButton(section, "Click Me", function() end)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Customize!
```

## Usage Example

See `Example.lua` for a complete usage example.

## Mobile Support

FluxUI automatically detects mobile devices and adjusts:
- Window sizes
- Touch input handling
- Layout spacing

## Notes

- All scripts are client-side ready
- Components are fully editable
- Supports both mouse and touch input
- Smooth animations included

