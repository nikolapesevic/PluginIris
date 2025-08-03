# Plugin Iris

[Iris](https://github.com/SirMallard/Iris) wrapper to make plugin development more convenient.

## Benefits
- Simplified Roblox and Iris API to make windows.
- Window contents are perfectly aligned with Iris windows.
- Modifies Iris theme to match the Studio theme.
- Uses a hack to make Iris work in multiple windows and plugins at the same time.
- Automatically creates a toolbar, button and action for the window.

## Installation
The library is available on [Wally](https://wally.run) as a [Package](https://wally.run/package/nikolapesevic/pluginiris).

## Documentation
Please refer to the [Example](https://github.com/nikolapesevic/pluginiris/blob/main/example/init.plugin.luau). The library is strictly typed and only contains a few functions.

## Known Issues
- Support for Iris windows inside of PluginIris windows can be buggy and messy. This could be fixed in the future by adding another method to create windows which are not tied to toolbars and buttons.
- Making multiple windows work is a total hack and annoying to maintain. Currently, the latest .rbxm release of Iris is grabbed and put into the lib folder. This is not ideal, but it works for now. I've explored many different avenues to make this work, but none of them were good enoughTM.

## Development
1. `rokit install & wally install` - Install dependencies.
2. Enable `Reload Plugins on file changed` in Studio settings.
3. `rojo build example.project.json --plugin PluginIris.rbxm --watch` - To build the example for testing.