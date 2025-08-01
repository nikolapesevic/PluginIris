local UserInputService = game:GetService("UserInputService")
local PluginIris = require(script.Parent.Packages.PluginIris)

local pluginIris = PluginIris(plugin, "Example") -- You can provide an existing toolbar or the id for a new one

-- You can also get the toolbar from the plugin, this is also useful for adding non-IrisPlugin buttons
print("Got toolbar:", pluginIris:GetToolbar())

local exampleWindow = pluginIris:NewWindow(
	{
		Id = "Example",
		Button = {
			Icon = "rbxassetid://85343243625312",
			Tooltip = "This is an example window using PluginIris.",
		},
		Window = {
			Title = "Example Window",
			MinSize = Vector2.new(356, 128),
		},
	},
	function(plugin: Plugin, iris) -- IMPORTANT! You must use this instance of the iris module that is passed to the function! Do not use Iris directly!
		iris.Button({ "Hello world!" })
		iris.Text({ "This is an example window using PluginIris." })
	end
)

UserInputService.InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.T then
		exampleWindow:Toggle() -- Toggles the window
		print(exampleWindow:IsOpen())
	end
	if input.KeyCode == Enum.KeyCode.Escape then
		exampleWindow:Toggle(false) -- Force a certain state
	end
end)

local demoWindow = pluginIris:NewWindow({
	Id = "Example 2",
	Window = {
		Title = "Iris Demo",
		Demo = true,
		MinSize = Vector2.new(720, 720),
	},
}, function()
	-- Leave the function empty and set Window.Demo to true to create the standard Iris demo window.
end)

-- Don't forget to clean up the windows when the plugin is unloaded!
plugin.Unloading:Connect(function()
	exampleWindow:Destroy()
	demoWindow:Destroy()
end)
