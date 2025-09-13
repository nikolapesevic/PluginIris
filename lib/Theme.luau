local Iris = require(script.Parent.Parent.Iris)
local Studio = settings().Studio

local function skew(color: Color3, float: number): Color3
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v + (v < 0.5 and float or -float), 0, 1))
end

return function(iris: typeof(Iris))
	local function update()
		if Studio.Theme.Name == "Light" then
			Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorLight)
			Iris.UpdateGlobalConfig({
				FrameBgColor = Iris.TemplateConfig.colorLight.SeparatorColor,
			})
		else
			Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
			Iris.UpdateGlobalConfig({
				WindowBgColor = Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
				TitleBgColor = skew(Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground), 0.1),
				MenubarBgColor = skew(Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground), -0.05),
			})
		end
	end
	local event = Studio.ThemeChanged:Connect(update)
	update()

	return function()
		event:Disconnect()
	end
end
