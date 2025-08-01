local UserInputService = game:GetService("UserInputService")
local PluginIris = require(script.Parent.Packages.PluginIris)

local pluginIris = PluginIris(plugin, "Example") -- You can provide an existing toolbar or the id for a new one

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
-- IMPORTANT! You must use the instance of iris passed as an argument to the callback. This is the hack that allows us to use multiple instances of Iris.
exampleWindow:SetCallback(function(plugin: Plugin, iris)
	iris.Button({ "Hello world!" })
	iris.Text({ "This is an example window using PluginIris." })
end)
print(exampleWindow.Iris) -- It's also a public property in case you need to create state or use it otherwise, outside of the callback.

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
})

-- Don't forget to clean up the windows when the plugin is unloaded!
plugin.Unloading:Connect(function()
	exampleWindow:Destroy()
	demoWindow:Destroy()
end)
