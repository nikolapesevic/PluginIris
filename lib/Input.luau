-- Taken from https://github.com/SirMallard/Iris/blob/main/src/libraries/UserInputService/init.lua
-- Modified to use with different Signal library and be instanced instead of a top-level module.
-- Contains an unchanged public API when Instanced for compatibility with private Iris internals.

local UserInputService = game:GetService("UserInputService")
local Bin = require(script.Parent.Parent.Bin)
local Signal = require(script.Parent.Parent.Signal)

return function()
	local p, _p = {}, {}
	local bin, cleanup = Bin()

	p.X = 0
	p.Y = 0
	p.KeyDown = {}

	p.SinkFrame = bin(Instance.new("Frame"))
	p.SinkFrame.Name = "SinkFrame"
	p.SinkFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	p.SinkFrame.Position = UDim2.fromScale(0.5, 0.5)
	p.SinkFrame.Size = UDim2.fromScale(1, 1)
	p.SinkFrame.BackgroundTransparency = 1
	p.SinkFrame.ZIndex = 1024 ^ 2

	p.InputBegan = Signal()
	p.InputChanged = Signal()
	p.InputEnded = Signal()
	p.MouseMoved = Signal()
	p.TouchTapInWorld = Signal()

	local function inputBegan(input: InputObject)
		p.KeyDown[input.KeyCode] = true
		p.InputBegan:Fire(input, true)
	end

	local function inputChanged(input: InputObject)
		p.InputChanged:Fire(input, true)
	end

	local function inputEnded(input: InputObject)
		p.KeyDown[input.KeyCode] = nil
		p.InputEnded:Fire(input, true)
	end

	local function mouseMoved(x: number, y: number)
		p.X = x
		p.Y = y
	end

	bin(p.SinkFrame.InputBegan:Connect(inputBegan))
	bin(p.SinkFrame.InputChanged:Connect(inputChanged))
	bin(p.SinkFrame.InputEnded:Connect(inputEnded))
	bin(p.SinkFrame.MouseMoved:Connect(mouseMoved))
	bin(UserInputService.InputBegan:Connect(inputBegan))
	bin(UserInputService.InputChanged:Connect(inputChanged))
	bin(UserInputService.InputEnded:Connect(inputEnded))

	function p:GetMouseLocation()
		return Vector2.new(p.X, p.Y)
	end

	function p:IsKeyDown(keyCode: Enum.KeyCode)
		if p.KeyDown[keyCode] == true then
			return true
		end
		return false
	end

	function p:Destroy()
		cleanup()
	end

	return p
end
