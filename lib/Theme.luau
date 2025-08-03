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
			TextDisabledColor = getStudioColor(Enum.StudioStyleGuideColor.DimmedText),

			-- Border Colors
			BorderColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			BorderActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected),

			-- Window Background Colors
			WindowBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),
			PopupBgColor = getStudioColor(Enum.StudioStyleGuideColor.Dropdown),

			-- Scrollbar Colors
			ScrollbarGrabColor = getStudioColor(Enum.StudioStyleGuideColor.ScrollBar),

			-- Title Bar Colors
			TitleBgColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),
			TitleBgActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			TitleBgCollapsedColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),

			-- Menu Bar Colors
			MenubarBgColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),

			-- Frame Background Colors
			FrameBgColor = getStudioColor(Enum.StudioStyleGuideColor.InputFieldBackground),
			FrameBgHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover),
			FrameBgActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),

			-- Button Colors
			ButtonColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			ButtonHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover),
			ButtonActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),

			-- Image Colors
			ImageColor = getStudioColor(Enum.StudioStyleGuideColor.MainText),

			-- Slider Colors
			SliderGrabColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			SliderGrabActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),

			-- Header Colors
			HeaderColor = getStudioColor(Enum.StudioStyleGuideColor.Item),
			HeaderHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover),
			HeaderActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected),

			-- Tab Colors
			TabColor = getStudioColor(Enum.StudioStyleGuideColor.Tab),
			TabHoveredColor = getStudioColor(Enum.StudioStyleGuideColor.Tab, Enum.StudioStyleGuideModifier.Hover),
			TabActiveColor = getStudioColor(Enum.StudioStyleGuideColor.Tab, Enum.StudioStyleGuideModifier.Selected),

			-- Selection Colors
			SelectionImageObjectColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			SelectionImageObjectBorderColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),

			-- Table Colors
			TableBorderStrongColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			TableBorderLightColor = getStudioColor(Enum.StudioStyleGuideColor.Border),
			TableRowBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),
			TableRowBgAltColor = getStudioColor(Enum.StudioStyleGuideColor.Item),
			TableHeaderColor = getStudioColor(Enum.StudioStyleGuideColor.Titlebar),

			-- Navigation Colors
			NavWindowingHighlightColor = getStudioColor(
				Enum.StudioStyleGuideColor.Item,
				Enum.StudioStyleGuideModifier.Selected
			),
			NavWindowingDimBgColor = getStudioColor(Enum.StudioStyleGuideColor.MainBackground),

			-- Separator Colors
			SeparatorColor = getStudioColor(Enum.StudioStyleGuideColor.Border),

			-- Check Mark Colors
			CheckMarkColor = getStudioColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator),

			-- Plot Colors
			PlotLinesColor = getStudioColor(Enum.StudioStyleGuideColor.MainText),
			PlotLinesHoveredColor = Color3.fromRGB(255, 110, 89),
			PlotHistogramColor = Color3.fromRGB(230, 179, 0),
			PlotHistogramHoveredColor = Color3.fromRGB(255, 200, 0),

			-- Resize Grip Colors
			ResizeGripColor = getStudioColor(Enum.StudioStyleGuideColor.Button),
			ResizeGripHoveredColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Hover
			),
			ResizeGripActiveColor = getStudioColor(
				Enum.StudioStyleGuideColor.Button,
				Enum.StudioStyleGuideModifier.Pressed
			),
		})
	end
	local event = Studio.ThemeChanged:Connect(update)
	update()

	return function()
		event:Disconnect()
	end
end
