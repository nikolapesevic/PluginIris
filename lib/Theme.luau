local Iris = require(script.Parent.Parent.Iris)
local Studio = settings().Studio

local function skew(color: Color3, float: number): Color3
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v + (v < 0.5 and float or -float), 0, 1))
end

local function getStudioColor(colorType, modifier: Enum.StudioStyleGuideModifier?)
	modifier = modifier or Enum.StudioStyleGuideModifier.Default
	local color = Studio.Theme:GetColor(colorType, modifier)
	return colorType == Enum.StudioStyleGuideColor.Button and skew(color, 0.05) or color -- We have to skew button colors a bit to get a proper contrast!
end

return function(iris: typeof(Iris))
	local function update()
		iris.UpdateGlobalConfig({})
	end
	local event = Studio.ThemeChanged:Connect(update)
	update()

	return function()
		event:Disconnect()
	end
end
