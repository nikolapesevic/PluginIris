local Input = require(script.Input)
local Bin = require(script.Parent.Bin)
local Theme = require(script.Theme)

local DEFAULT_ICON = "rbxassetid://112054744712799"

export type WindowConfig = {
	Id: string,

	Button: {
		Icon: string?,
		Tooltip: string?,
	}?,

	Window: {
		Demo: boolean?,
		Title: string?,
		MinSize: Vector2?,
	}?,
}

return function(plugin: Plugin, pluginToolbar: PluginToolbar | string)
	local p, _p = {}, {}

	if typeof(pluginToolbar) == "string" then
		_p.toolbar = plugin:CreateToolbar(pluginToolbar)
		_p.toolbar.Name = pluginToolbar .. "Toolbar"
	else
		_p.toolbar = pluginToolbar
	end

	_p.iris = require(script.Parent.Iris)
	_p.irisInternal = script.Parent._Index[script.Parent.Iris.Source:match('%["([^"]+)"%]')]["iris"]

	function p:GetToolbar(): PluginToolbar
		return _p.toolbar
	end

	function p:NewWindow<T>(config: WindowConfig, irisCallback: (plugin: Plugin, iris: typeof(_p.iris)) -> (), ...)
		local w, _w = {}, {}
		local bin, cleanup = Bin()

		-- Provide a clone of Iris, so we can use multiple unrelated instances of it, EWWW what a hack!
		_w.iris = require(_p.irisInternal:Clone()) :: typeof(_p.iris)

		bin(Theme(_w.iris))
		_w.iris.UpdateGlobalConfig({
			UseScreenGUIs = false,
		})

		_w.Button = _p.toolbar:CreateButton(
			config.Id .. "ToggleButton",
			(config.Button and config.Button.Tooltip) or "Toggle " .. config.Id .. " plugin window",
			(config.Button and config.Button.Icon) or DEFAULT_ICON
		)
		_w.Button.ClickableWhenViewportHidden = true

		_w.Action = plugin:CreatePluginAction(
			config.Id .. "ToggleAction",
			config.Id,
			(config.Button and config.Button.Tooltip) or "Toggle " .. config.Id .. " plugin window",
			(config.Button and config.Button.Icon) or DEFAULT_ICON,
			true
		)

		_w.Window = plugin:CreateDockWidgetPluginGui(
			config.Id,
			DockWidgetPluginGuiInfo.new(
				Enum.InitialDockState.Float,
				false,
				false,
				(config.Window and config.Window.MinSize) and config.Window.MinSize.X or 256,
				(config.Window and config.Window.MinSize) and config.Window.MinSize.Y or 256,
				(config.Window and config.Window.MinSize) and config.Window.MinSize.X or 256,
				(config.Window and config.Window.MinSize) and config.Window.MinSize.Y or 256
			)
		)
		_w.Window.Title = config.Window and config.Window.Title or config.Id
		_w.Window.Name = config.Window and config.Window.Title or config.Id
		_w.Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		_w.input = Input() -- This somehow helps with Iris input handling, not sure, but recommended with Iris plugin example, read source for more...
		_w.input.SinkFrame.Parent = _w.Window
		_w.iris.Internal._utility.UserInputService = _w.input :: any
		_w.iris.Disabled = not _w.Window.Enabled -- Windows can restore, and thus Iris must be immediately enabled
		_w.Button:SetActive(_w.Window.Enabled) -- Button should reflect the window state

		_w.iris.Init(_w.Window :: any)
		bin(_w.iris:Connect(function()
			if config.Window and config.Window.Demo then
				local window = _w.iris.ShowDemoWindow()
				window.state.size:set(_w.Window.AbsoluteSize)
				window.state.position:set(Vector2.zero)
				window.arguments.NoTitleBar = true
				window.arguments.NoCollapse = true
				window.arguments.NoClose = true
				window.arguments.NoMove = true
				window.arguments.NoResize = true
			else
				local window = _w.iris.Window({ "", true, false, true, true, true, false, true })
				window.state.size:set(_w.Window.AbsoluteSize)
				window.state.position:set(Vector2.zero)

				irisCallback(plugin, _w.iris)

				_w.iris.End()
			end
		end))

		_w.Window:BindToClose(function()
			_w.Window.Enabled = false
			_w.iris.Disabled = true
			_w.Button:SetActive(false)
		end)

		local function onToggle()
			_w.Window.Enabled = not _w.Window.Enabled
			_w.iris.Disabled = not _w.Window.Enabled
			_w.Button:SetActive(_w.Window.Enabled)
		end
		_w.Button.Click:Connect(onToggle)
		_w.Action.Triggered:Connect(onToggle)

		function w:IsOpen(): boolean
			return _w.Window.Enabled
		end

		function w:Toggle(newState: boolean?): boolean
			_w.Window.Enabled = if newState ~= nil then newState else not _w.Window.Enabled
			return _w.Window.Enabled
		end

		function w:Destroy()
			_w.Window.Enabled = false

			_w.iris.Disabled = true
			_w.iris.Shutdown()

			_w.input:Destroy()

			cleanup()
		end

		return w
	end

	return p
end
