local CoreGui = game:GetService("CoreGui")
local Bin = require(script.Parent.Bin)
local Iris = require(script.Parent.Iris)
local Theme = require(script.Theme)

local DEFAULT_ICON = "rbxassetid://112054744712799"

export type Iris = typeof(Iris)

type WindowConfig = {
	Id: string,

	Icon: string?,
	Tooltip: string?,
	NoToolbar: boolean?,

	IrisArgs: {
		NoTitleBar: boolean?,
		NoBackground: boolean?,
		NoClose: boolean?,
		NoCollapse: boolean?,
		NoMove: boolean?,
		NoScrollbar: boolean?,
		NoResize: boolean?,
	}?,
	DefaultSize: Vector2?,
	DefaultPosition: Vector2?,

	IrisDemo: boolean?,
}

type IrisWindow = typeof(Iris.Window({}))

local initialized = false
return {
	Iris = Iris,

	newToolbar = function(plugin: Plugin, pluginToolbar: PluginToolbar | string)
		assert(not initialized, "Iris can only be initialized once per plugin.")
		initialized = true

		local p, _p = {}, {}
		local bin, cleanup = Bin()

		if typeof(pluginToolbar) == "string" then
			_p.toolbar = plugin:CreateToolbar(pluginToolbar)
			_p.toolbar.Name = pluginToolbar
		else
			_p.toolbar = pluginToolbar
		end

		_p.screenGui = Instance.new("ScreenGui")
		_p.screenGui.Name = _p.toolbar.Name .. "ScreenGui"
		_p.screenGui.ResetOnSpawn = false
		_p.screenGui.IgnoreGuiInset = true
		_p.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		_p.screenGui.Parent = CoreGui

		_p.themeCleanup = Theme(Iris)

		Iris.Init(_p.screenGui :: any)
		Iris.UpdateGlobalConfig({
			IgnoreGuiInset = true,
		})

		function p:Get(): PluginToolbar
			return _p.toolbar
		end

		function p:NewWindow(config: WindowConfig)
			local w, _w = {}, {
				callback = nil :: ((iris: typeof(Iris)) -> ())?,
			}
			local wbin, wcleanup = Bin()
			bin(wcleanup)

			if not config.NoToolbar then
				_w.button = _p.toolbar:CreateButton(
					config.Id,
					config.Tooltip or "Toggle " .. config.Id .. " plugin window",
					config.Icon or DEFAULT_ICON
				)
				_w.button.ClickableWhenViewportHidden = true

				_w.action = plugin:CreatePluginAction(
					config.Id .. "ToggleAction",
					config.Id,
					config.Tooltip or "Toggle " .. config.Id .. " plugin window",
					config.Icon or DEFAULT_ICON,
					true
				)
			end

			local function cfgDefault(config: any, key: string, default: boolean): boolean
				local value = config and config[key] or nil
				if value ~= nil then
					return value
				else
					return default
				end
			end

			local isOpenedState = Iris.State(false)
			wbin(Iris:Connect(function()
				if config.IrisDemo then
					Iris.ShowDemoWindow()
				else
					local window = Iris.Window({
						_p.toolbar.Name .. " - " .. config.Id,
						cfgDefault(config.IrisArgs, "NoTitleBar", false),
						cfgDefault(config.IrisArgs, "NoBackground", false),
						cfgDefault(config.IrisArgs, "NoCollapse", true),
						cfgDefault(config.IrisArgs, "NoClose", false),
						cfgDefault(config.IrisArgs, "NoMove", false),
						cfgDefault(config.IrisArgs, "NoScrollbar", false),
						cfgDefault(config.IrisArgs, "NoResize", false),
					}, {
						isOpened = isOpenedState,
						size = config.DefaultSize and Iris.State(config.DefaultSize) or nil,
						position = config.DefaultPosition and Iris.State(config.DefaultPosition) or nil,
					})
					_w.window = window -- Need it outside of the render cycle

					if _w.callback and isOpenedState:get() then
						_w.callback(window :: any)
					end

					if window.state.isOpened:changed() and not config.NoToolbar then
						_w.button:SetActive(window.state.isOpened:get())
					end

					Iris.End()
				end
			end))

			local function onToggle()
				if not _w.window then
					return
				end
				_w.window.state.isOpened:set(not _w.window.state.isOpened:get())
				if not config.NoToolbar then
					_w.button:SetActive(_w.window.state.isOpened:get())
				end
			end
			if not config.NoToolbar then
				_w.button.Click:Connect(onToggle)
				_w.action.Triggered:Connect(onToggle)
			end

			function w:IsOpen(): boolean
				return _w.window.state.isOpened:get()
			end

			function w:Toggle(newState: boolean?): boolean
				if not _w.window then
					return false
				end
				_w.window.state.isOpened:set(if newState ~= nil then newState else not _w.window.state.isOpened:get())
				if not config.NoToolbar then
					_w.button:SetActive(_w.window.state.isOpened:get())
				end
				return _w.window.state.isOpened:get()
			end

			function w:SetCallback(callback: (window: IrisWindow) -> ())
				assert(not _w.callback, "You can only set the callback once for each window.")
				_w.callback = callback :: any
			end

			function w:Destroy()
				wcleanup()
			end

			return w
		end

		function p:Destroy()
			cleanup()
			Iris.Shutdown()
			_p.themeCleanup()
			_p.screenGui:Destroy()
		end

		return p
	end,
}
