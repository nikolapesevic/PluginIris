local UserInputService = game:GetService("UserInputService")
local PluginIris = require(script.Parent.Packages.PluginIris)

local toolbar = PluginIris(plugin, "Example Plugin") -- You can provide an existing toolbar or the id for a new one
print("Got toolbar:", toolbar:Get()) -- You can also retrieve the Roblox toolbar instance

-- Construct a new window with the toolbar instance and a configuration
local exampleWindow = toolbar:NewWindow({
	Id = "Example",

	Icon = "rbxassetid://85343243625312",
	Tooltip = "This is an example window using PluginIris.",

	IrisArgs = {
		NoTitleBar = true,
		NoBackground = true,
		NoClose = true,
		NoCollapse = true,
		NoMove = true,
		NoScrollbar = false,
		NoResize = true,
	},
	DefaultSize = Vector2.new(500, 100),
	DefaultPosition = Vector2.new(0, 0),
})

local Iris = toolbar.Iris -- You access .Iris on the toolbar instance
exampleWindow:SetCallback(function() -- You can only set the callback once for each window!
	Iris.Button({ "Hello world!" })
	Iris.Text({ "This is an example window using PluginIris." })
	Iris.Text({ "It uses more complex settings to anchor it self to the top left." })
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

toolbar:NewWindow({
	Id = "Demo",

	IrisDemo = true,
})

-- IMPORTANT! Make sure you clean up the PluginIris instance when the plugin is unloaded.
-- This also cleans up all of the existing windows
plugin.Unloading:Connect(function()
	toolbar:Destroy()
	userInputEvent:Disconnect()
end)
