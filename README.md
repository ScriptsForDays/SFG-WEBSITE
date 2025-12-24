<<<<<<< HEAD
# FluxUI - Premium Customizable UI Library

A highly customizable UI library for Roblox exploits that supports both PC and mobile platforms.

## Features

- ✅ **Fully Customizable** - Edit all UI components easily
- ✅ **Cross-Platform** - Works on PC and Mobile devices
- ✅ **Modern Design** - Beautiful, smooth animations
- ✅ **Component-Based** - Easy to use and extend
- ✅ **Client-Side** - Ready for exploit integration
- ✅ **Clean Layout** - Dedicated tab container, organized structure

## Installation

### Method 1: Standalone (Recommended for Exploits)
Copy the entire contents of `FluxUI_Standalone.lua` directly into your exploit script.

### Method 2: Module
Use `require()` to load `FluxUI.lua` as a module.

## Quick Start

```lua
-- Load FluxUI
local FluxUI = _G.FluxUI  -- If using standalone version

-- Create Window
local window = FluxUI:CreateWindow("My Exploit UI", {
    Size = UDim2.new(0, 500, 0, 400),
    Position = UDim2.new(0.5, 0, 0.5, 0)
})

-- Create Tab
local tab = FluxUI:CreateTab(window, "Main")

-- Create Section
local section = FluxUI:CreateSection(tab, "Features")

-- Add Components
FluxUI:CreateButton(section, "Click Me", function()
    print("Button clicked!")
end)
```

## Components

- **Window** - Main container with title bar and tab container
- **Tab** - Tab navigation (positioned in dedicated container below title)
- **Section** - Group related controls
- **Button** - Clickable buttons
- **Toggle** - On/off switches
- **Slider** - Adjustable sliders
- **TextBox** - Input fields
- **Label** - Text labels
- **Dropdown** - Selection dropdowns

## Customization

### Colors
Edit colors in `FluxUI.Colors`:

```lua
FluxUI.Colors = {
    Primary = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    -- ... more colors
}
```

### Component Editing
All components return instances that you can modify:

```lua
local button = FluxUI:CreateButton(section, "Click Me", function() end)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Customize!
```

## Files

- `FluxUI.lua` - Module version (requires `require()`)
- `FluxUI_Standalone.lua` - Standalone version (no require needed)
- `Example.lua` - Usage examples
- `FluxUI_Visualization.html` - Visual preview of the UI

## Recent Fixes

- ✅ Fixed tab positioning (tabs now in dedicated container below title bar)
- ✅ Fixed color assignment errors with proper nil checks
- ✅ Enhanced error handling throughout
- ✅ Improved layout and spacing

## License

Free to use and modify for your projects.

## Contributing

Feel free to submit issues or pull requests!

=======
<!--<h1 align="center">WindUI</h1> -->


<picture>
    <source srcset="docs/banner-dark.webp" media="(prefers-color-scheme: dark)">
    <source srcset="docs/banner-light.webp" media="(prefers-color-scheme: light)">
    <img src="docs/banner-light.png" alt="WindUI Banner">
</picture>

> [!WARNING]
> This WindUI was not inspired by, and the name has nothing to do with UI Frameworks


 
> [!WARNING] 
> WindUI is currently in Beta.
> This project is still under active development. Bugs, issues, and unstable features may occur. We’re constantly working on improvements, so please be patient and report any problems you encounter.



### Credits
- [Dawid-Scripts](https://github.com/dawid-scripts) 
- [Lucide-Icons](https://github.com/lucide-icons/lucide) 


### Links
- [Discord Server](https://discord.gg/ftgs-development-hub-1300692552005189632)
- [Documentation](https://ScriptsForDays.github.io/CUSTOMUI/)

- [Example](/main_example.lua) (wip)
  ```luau
  loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptsForDays/CUSTOMUI/refs/heads/main/main_example.lua'))()
  ```

### Custom Enhancements

This is a custom version of WindUI with the following enhancements:

- **Dynamic Dropdown Updates**: Added `SetValues()` method for real-time dropdown value updates
- **Custom Accent Customization**: Override theme properties with methods like `SetCustomAccent()`, `SetCustomBackground()`, etc.
- **Enhanced UI Control**: Customize backgrounds, text colors, buttons, and more without creating full themes

See [main_example.lua](/main_example.lua) for usage examples.
>>>>>>> 408d5ab (UI: sync Lua changes, add Notify API, example Test Notification; exclude HTML visualization)
