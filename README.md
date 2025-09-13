# Plugin Iris

[Iris](https://github.com/SirMallard/Iris) wrapper to make plugin development more convenient.

## Benefits
- Simplified Roblox and Iris API to make windows.
- Modifies Iris theme to match the Studio theme.
- Automatically creates a toolbar, button and action for the window.

## Installation
The library is available on [Wally](https://wally.run) as a [Package](https://wally.run/package/triankl3/pluginiris).

## Usage
Please refer to the [Example](https://github.com/nikolapesevic/pluginiris/blob/main/example/init.plugin.luau). The library is strictly typed and only contains a few functions.

## Development
1. `rokit install & wally install` - Install dependencies.
2. Enable `Reload Plugins on file changed` in Studio settings.
3. `rojo build example.project.json --plugin PluginIris.rbxm --watch` - To build the example for testing.