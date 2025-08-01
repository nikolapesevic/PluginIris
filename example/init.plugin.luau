local PluginIris = require(script.Parent.Packages.PluginIris)

local pluginIris = PluginIris(plugin, "example") -- You can provide an existing toolbar or the id for a new one

-- You can also get the toolbar from the plugin, this is also useful for adding non-IrisPlugin buttons
print(pluginIris:GetToolbar())

local window = pluginIris:NewWindow({
	Id = "Example",
	Button = {},
	Window = {},
}, function(plugin: Plugin, iris)
	iris.Button({ "Hello world!" })
	iris.Text({ "This is an example window using PluginIris." })
end)

local window2 = pluginIris:NewWindow({
	Id = "Example 2",
	Button = {},
	Window = {},
}, function(plugin: Plugin, iris)
	iris.Button({ "Another window huh?" })
	iris.Text({ "Just another example to confirm multiple instances of Iris work!" })
end)

plugin.Unloading:Connect(function()
	window:Destroy()
	window2:Destroy()
end)
