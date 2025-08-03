local UserInputService = game:GetService("UserInputService")
local PluginIris = require(script.Parent.Packages.PluginIris)

local pluginIris = PluginIris(
	plugin,

	-- IMPORTANT! We use a hack to allow multiple instances of Iris to be used in the same plugin.
	-- Esentially the Iris module is cloned for each window, so you can use multiple windows parented to different plugin widgets.
	-- However, due internal differences in package managers, I cannot reliably clone the module, so you must provide the internal Iris module as an argument.
	-- The best way to do this is to implement some regex like below in order to get the internal module from the plugin, and not just the shortcut module point to the main Iris module.
	script.Parent.Packages._Index[script.Parent.Packages.Iris.Source:match('%["([^"]+)"%]')]["iris"],

	"Example" -- You can provide an existing toolbar or the id for a new one
)

-- You can also get the toolbar from the plugin, this is also useful for adding non-IrisPlugin buttons
print("Got toolbar:", pluginIris:GetToolbar())

local exampleWindow = pluginIris:NewWindow({
	Id = "Example",
	Button = {
		Icon = "rbxassetid://85343243625312",
		Tooltip = "This is an example window using PluginIris.",
	},
	Window = {
		Title = "Example Window",
		MinSize = Vector2.new(356, 128),
	},
})

-- IMPORTANT! Do not use the Iris module directly, instead use the instance of Iris provided by the window.
-- This is the hack that allows us to use multiple instances of Iris. You also get the Iris instance as an argument in the callback.
local testState = exampleWindow.Iris.State("Hello world")
exampleWindow:SetCallback(function(iris) -- You can only set the callback once for each window!
	iris.Button({ "Hello world!" })
	iris.Text({ "This is an example window using PluginIris." })
end)

-- :Toggle(), :Toggle(state: boolean) and :IsOpen() are provided by the window, so you can control the window state.
-- The window state is tracked with other actions so the buttons and window are always in sync.
UserInputService.InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.T then
		exampleWindow:Toggle() -- Toggles the window
		print(exampleWindow:IsOpen())
	end
	if input.KeyCode == Enum.KeyCode.Escape then
		exampleWindow:Toggle(false) -- Force a certain state
	end
end)

-- Because of the hack, you can create as many windows as you want
local demoWindow = pluginIris:NewWindow({
	Id = "Example 2",
	Window = {
		Title = "Iris Demo", -- Use Demo to show the Iris demo window
		Demo = true,
		MinSize = Vector2.new(720, 720),
	},
})

-- Don't forget to clean up the windows when the plugin is unloaded!
plugin.Unloading:Connect(function()
	exampleWindow:Destroy()
	demoWindow:Destroy()
end)
