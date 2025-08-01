local Input = require(script.Input)
local Bin = require(script.Parent.Bin)
local Theme = require(script.Theme)

local DEFAULT_ICON = "rbxassetid://112054744712799"

type WindowConfig = {
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

	function p:NewWindow<T>(config: WindowConfig)
		local w, _w = {}, {
			callback = nil :: ((plugin: Plugin, iris: typeof(_p.iris)) -> ())?,
		}
		local bin, cleanup = Bin()

		-- Provide a clone of Iris, so we can use multiple unrelated instances of it, EWWW what a hack!
		w.Iris = require(_p.irisInternal:Clone()) :: typeof(_p.iris)

		bin(Theme(w.Iris))
		w.Iris.UpdateGlobalConfig({
			UseScreenGUIs = false,
		})

		_w.button = _p.toolbar:CreateButton(
			config.Id .. "ToggleButton",
			(config.Button and config.Button.Tooltip) or "Toggle " .. config.Id .. " plugin window",
			(config.Button and config.Button.Icon) or DEFAULT_ICON
		)
		_w.button.ClickableWhenViewportHidden = true

		_w.action = plugin:CreatePluginAction(
			config.Id .. "ToggleAction",
			config.Id,
			(config.Button and config.Button.Tooltip) or "Toggle " .. config.Id .. " plugin window",
			(config.Button and config.Button.Icon) or DEFAULT_ICON,
			true
		)

		_w.window = plugin:CreateDockWidgetPluginGui(
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
		_w.window.Title = config.Window and config.Window.Title or config.Id
		_w.window.Name = config.Window and config.Window.Title or config.Id
		_w.window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		_w.input = Input() -- This somehow helps with Iris input handling, not sure, but recommended with Iris plugin example, read source for more...
		_w.input.SinkFrame.Parent = _w.window
		w.Iris.Internal._utility.UserInputService = _w.input :: any
		w.Iris.Disabled = not _w.window.Enabled -- Windows can restore, and thus Iris must be immediately enabled
		_w.button:SetActive(_w.window.Enabled) -- Button should reflect the window state

		w.Iris.Init(_w.window :: any)
		bin(w.Iris:Connect(function()
			if config.Window and config.Window.Demo then
				local window = w.Iris.ShowDemoWindow()
				window.state.size:set(_w.window.AbsoluteSize)
				window.state.position:set(Vector2.zero)
				window.arguments.NoTitleBar = true
				window.arguments.NoCollapse = true
				window.arguments.NoClose = true
				window.arguments.NoMove = true
				window.arguments.NoResize = true
			else
				local window = w.Iris.Window({ "", true, false, true, true, true, false, true })
				window.state.size:set(_w.window.AbsoluteSize)
				window.state.position:set(Vector2.zero)

				if _w.callback then
					_w.callback(plugin, w.Iris)
				end

				w.Iris.End()
			end
		end))

		_w.window:BindToClose(function()
			_w.window.Enabled = false
			w.Iris.Disabled = true
			_w.button:SetActive(false)
		end)

		local function onToggle()
			_w.window.Enabled = not _w.window.Enabled
			w.Iris.Disabled = not _w.window.Enabled
			_w.button:SetActive(_w.window.Enabled)
		end
		_w.button.Click:Connect(onToggle)
		_w.action.Triggered:Connect(onToggle)

		function w:IsOpen(): boolean
			return _w.window.Enabled
		end

		function w:Toggle(newState: boolean?): boolean
			_w.window.Enabled = if newState ~= nil then newState else not _w.window.Enabled
			_w.button:SetActive(_w.window.Enabled)
			return _w.window.Enabled
		end

		function w:SetCallback(renderCallback: (plugin: Plugin, iris: typeof(_p.iris)) -> ())
			_w.callback = renderCallback
		end

		function w:Destroy()
			_w.window.Enabled = false

			w.Iris.Disabled = true
			w.Iris.Shutdown()

			_w.input:Destroy()

			cleanup()
		end

		return w
	end

	return p
end
