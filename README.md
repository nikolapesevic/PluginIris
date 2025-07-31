# Plugin Iris

Super simple layer built on top of Iris to provide a more convenient interface for using Iris within Studio plugins.

Benefits:
1. Simplified API to create plugin windows and corresponding buttons.
2. Automatically pauses rendering if the window is not visible.
3. Modifies Iris theme to match the Studio theme.
4. Handles all the boilerplate that must be done to make Iris work well in a plugin context.
5. Uses a hack to make Iris work in multiple plugins and windows at the same time.

## Usage
```luau
	local IrisPlugin = require(script.IrisPlugin)
	
	local window = IrisPlugin({
		Plugin = plugin,
		Title = "My Plugin",
		
	})
```