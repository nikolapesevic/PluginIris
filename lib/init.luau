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

	IrisDemo: boolean?,
}

return function(plugin: Plugin, pluginToolbar: PluginToolbar | string)
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

	function p:GetToolbar(): PluginToolbar
		return _p.toolbar
	end

	function p:NewWindow(config: WindowConfig)
		local w, _w = {}, {
			callback = nil :: ((iris: typeof(Iris)) -> ())?,
		}
		local wbin, wcleanup = Bin()
		bin(wcleanup)

		w.Iris = Iris

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

		local window
		local isOpenedState = Iris.State(false)
		wbin(w.Iris:Connect(function()
			if config.IrisDemo then
				w.Iris.ShowDemoWindow()
			else
				window = w.Iris.Window({ _p.toolbar.Name .. " - " .. config.Id, false, false, true }, {
					isOpened = isOpenedState,
				})

				if _w.callback and isOpenedState:get() then
					_w.callback(w.Iris)
				end

				if window.state.isOpened:changed() then
					_w.button:SetActive(window.state.isOpened:get())
				end

				w.Iris.End()
			end
		end))

		local function onToggle()
			if not window then
				return
			end
			window.state.isOpened:set(not window.state.isOpened:get())
			_w.button:SetActive(window.state.isOpened:get())
		end
		_w.button.Click:Connect(onToggle)
		_w.action.Triggered:Connect(onToggle)

		function w:IsOpen(): boolean
			return window.state.isOpened:get()
		end

		function w:Toggle(newState: boolean?): boolean
			if not window then
				return false
			end
			window.state.isOpened:set(if newState ~= nil then newState else not window.state.isOpened:get())
			_w.button:SetActive(window.state.isOpened:get())
			return window.state.isOpened:get()
		end

		function w:SetCallback(renderCallback: (iris: typeof(Iris)) -> ())
			assert(not _w.callback, "You can only set the callback once for each window.")
			_w.callback = renderCallback
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
end
