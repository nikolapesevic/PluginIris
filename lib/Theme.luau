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
		iris.UpdateGlobalConfig({
			TextColor = getStudioColor(Enum.StudioStyleGuideColor.MainText),
			TextTransparency = 0,
			TextDisabledColor = getStudioColor(Enum.StudioStyleGuideColor.DimmedText),
			TextDisabledTransparency = 0,

			-- Border Colors
			BorderColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			BorderTransparency = 0,
			BorderActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected),
			BorderActiveTransparency = 0,

			-- Window Background Colors
			WindowBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),
			WindowBgTransparency = 0,
			PopupBgColor = getStudioColor(Enum.StudioStyleGuideColor.Dropdown),
			PopupBgTransparency = 0,

			-- Scrollbar Colors
			ScrollbarGrabColor = getStudioColor(Enum.StudioStyleGuideColor.ScrollBar),
			ScrollbarGrabTransparency = 0,

			-- Title Bar Colors
			TitleBgColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),
			TitleBgTransparency = 0,
			TitleBgActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			TitleBgActiveTransparency = 0,
			TitleBgCollapsedColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),
			TitleBgCollapsedTransparency = 0.3,

			-- Menu Bar Colors
			MenubarBgColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),
			MenubarBgTransparency = 0,

			-- Frame Background Colors
			FrameBgColor = getStudioColor(Enum.StudioStyleGuideColor.InputFieldBackground),
			FrameBgTransparency = 0,
			FrameBgHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover),
			FrameBgHoveredTransparency = 0,
			FrameBgActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			FrameBgActiveTransparency = 0,

			-- Button Colors
			ButtonColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			ButtonTransparency = 0,
			ButtonHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover),
			ButtonHoveredTransparency = 0,
			ButtonActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),
			ButtonActiveTransparency = 0,

			-- Image Colors
			ImageColor = getStudioColor(Enum.StudioStyleGuideColor.MainText),
			ImageTransparency = 0,

			-- Slider Colors
			SliderGrabColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			SliderGrabTransparency = 0,
			SliderGrabActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),
			SliderGrabActiveTransparency = 0,

			-- Header Colors
			HeaderColor = getStudioColor(Enum.StudioStyleGuideColor.Item),
			HeaderTransparency = 0.3,
			HeaderHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover),
			HeaderHoveredTransparency = 0,
			HeaderActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected),
			HeaderActiveTransparency = 0,

			-- Tab Colors
			TabColor = getStudioColor(Enum.StudioStyleGuideColor.Tab),
			TabTransparency = 0,
			TabHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Tab, Enum.StudioStyleGuideModifier.Hover),
			TabHoveredTransparency = 0,
			TabActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Tab, Enum.StudioStyleGuideModifier.Selected),
			TabActiveTransparency = 0,

			-- Selection Colors
			SelectionImageObjectColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			SelectionImageObjectTransparency = 0.5,
			SelectionImageObjectBorderColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			SelectionImageObjectBorderTransparency = 0,

			-- Table Colors
			TableBorderStrongColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			TableBorderStrongTransparency = 0,
			TableBorderLightColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			TableBorderLightTransparency = 0.5,
			TableRowBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),
			TableRowBgTransparency = 1,
			TableRowBgAltColor = getStudioColor(Enum.StudioStyleGuideColor.Item),
			TableRowBgAltTransparency = 0.9,
			TableHeaderColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),
			TableHeaderTransparency = 0,

			-- Navigation Colors
			NavWindowingHighlightColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			NavWindowingHighlightTransparency = 0.3,
			NavWindowingDimBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),
			NavWindowingDimBgTransparency = 0.3,

			-- Separator Colors
			SeparatorColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			SeparatorTransparency = 0,

			-- Check Mark Colors
			CheckMarkColor = getStudioColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator),
			CheckMarkTransparency = 0,

			-- Plot Colors
			PlotLinesColor = getStudioColor(Enum.StudioStyleGuideColor.MainText),
			PlotLinesTransparency = 0.4,
			PlotLinesHoveredColor = Color3.fromRGB(255, 110, 89),
			PlotLinesHoveredTransparency = 0,
			PlotHistogramColor = Color3.fromRGB(230, 179, 0),
			PlotHistogramTransparency = 0,
			PlotHistogramHoveredColor = Color3.fromRGB(255, 200, 0),
			PlotHistogramHoveredTransparency = 0,

			-- Resize Grip Colors
			ResizeGripColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			ResizeGripTransparency = 0.8,
			ResizeGripHoveredColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Hover
			),
			ResizeGripHoveredTransparency = 0.5,
			ResizeGripActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),
			ResizeGripActiveTransparency = 0.2,
		})
	end
	local event = Studio.ThemeChanged:Connect(update)
	update()

	return function()
		event:Disconnect()
	end
end
