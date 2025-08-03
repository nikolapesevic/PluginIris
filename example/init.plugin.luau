local UserInputService = game:GetService("UserInputService")
local PluginIris = require(script.Parent.Packages.PluginIris)

local pluginIris = PluginIris(plugin, "Example Plugin") -- You can provide an existing toolbar or the id for a new one
print("Got toolbar:", pluginIris:GetToolbar()) -- You can also get the toolbar from the plugin

-- Construct a new window with the pluginIris instance and a configuration
local exampleWindow = pluginIris:NewWindow({
	Id = "Example",

	Icon = "rbxassetid://85343243625312",
	Tooltip = "This is an example window using PluginIris.",
})

local Iris = exampleWindow.Iris -- You access .Iris on windows to get the Iris module
exampleWindow:SetCallback(function() -- You can only set the callback once for each window!
	Iris.Button({ "Hello world!" })
	Iris.Text({ "This is an example window using PluginIris." })
end)

-- :Toggle(), :Toggle(state: boolean) and :IsOpen() are provided by the window, so you can control the window state.
-- The window state is tracked with other actions so the buttons and window are always in sync.
local userInputEvent = UserInputService.InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.T then
		print(exampleWindow:Toggle()) -- Toggles the window
	end
	if input.KeyCode == Enum.KeyCode.Escape then
		exampleWindow:Toggle(false) -- Force a certain state
		print(exampleWindow:IsOpen())
	end
end)

pluginIris:NewWindow({
	Id = "Demo",

	IrisDemo = true,
})

-- IMPORTANT! Make sure you clean up the PluginIris instance when the plugin is unloaded.
-- This also cleans up all of the existing windows
plugin.Unloading:Connect(function()
	pluginIris:Destroy()
	userInputEvent:Disconnect()
end)
