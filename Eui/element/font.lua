
local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end


	-- To alter the fonts here is how the SetFont command works.
	-- You can use ONE of the 4 types.  To not use a specific variable simply replace
	-- its value with the word "nil" without the quotes.
	--
	-- Syntax:
	--	Simple:
	--		SetFont(BLIZZARD_NAME, FONT_NAME, FONT_SIZE, style);
	--		where:
	--		FONT_NAME = one of the font names defined above
	--		FONT_SIZE = one of the font sizes defined above
	--		style = a blizzard style variable.
	--			Style vars: nil, "OUTLINE", "THICKOUTLINE", "MONOCHROME",
	--				"OUTLINE, MONOCHROME", "THICKOUTLINE, MONOCHROME"
	--
	--	Alpha:
	--		SetFont(BLIZZARD_NAME, FONT_NAME, FONT_SIZE, style, alpha);
	--		where:
	--		alpha = opacity level from 0-255 for the font
	--
	--	Color:
	--	SetFont(BLIZZARD_NAME, FONT_NAME, FONT_SIZE, style, alpha, r, g, b, shadow_r, shadow_g, shadow_b, shadow_x, shadow_y);
	--		where:
	--		r,g,b = color values from 0-255 for red, blue and green of the font
	--
	--	Shadow:
	--	SetFont(BLIZZARD_NAME, FONT_NAME, FONT_SIZE, style, alpha, r, g, b, shadow_r, shadow_g, shadow_b, shadow_x, shadow_y);
	--		where:
	--		shadow_r,shadow_g,shadow_b = shadow color values from 0-255 for red, blue and green of the shadow
	--		shadow_x, shadow_y = numeric offset for x and y.
	--			for x: negative moves left, positive moves right
	--			for y: negative moves up, positive moves down

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	local Normal = STANDARD_TEXT_FONT
--	local fontn = [[Interface\AddOns\Eui\media\fontn.ttf]]
	local fontn = STANDARD_TEXT_FONT
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	
	-- Game engine fonts
	UNIT_NAME_FONT     = Normal
	NAMEPLATE_FONT     = Normal
--	DAMAGE_TEXT_FONT   = Normal
	STANDARD_TEXT_FONT = Normal

	-- Base fonts
	SetFont(AchievementFont_Small,             	Normal, 12)
	SetFont(InvoiceFont_Med,                    Normal, 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small,                  Normal, 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large,                     Normal, 15, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, Normal, 13, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            Normal, 30, "THICKOUTLINE", 30)
	SetFont(NumberFont_Outline_Large,           Normal, 15, "OUTLINE")		--任务奖励部分数字
	SetFont(NumberFont_Outline_Med,             fontn, 	11, "OUTLINE")		--背包堆叠数字
	SetFont(NumberFont_Shadow_Med,              Normal, 14)
	SetFont(NumberFont_Shadow_Small,            Normal, 12)
	SetFont(QuestFont_Large,                    Normal, 16)
	SetFont(QuestFont_Shadow_Huge,              Normal, 19, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(ReputationDetailFont,               Normal, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small,                    Normal, 11)
	SetFont(SystemFont_InverseShadow_Small,     Normal, 11)
	SetFont(SystemFont_Large,                   Normal, 17)
	SetFont(SystemFont_Med1,                    Normal, 13)
	SetFont(SystemFont_Med2,                    Normal, 14, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3,                    Normal, 15)
	SetFont(SystemFont_OutlineThick_Huge2,      Normal, 22, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4,  	Normal, 27, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF,    	Normal, 31, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small,           Normal, 13, "OUTLINE")
	SetFont(SystemFont_Shadow_Huge1,            Normal, 20)
	SetFont(SystemFont_Shadow_Huge3,            Normal, 25)
	SetFont(SystemFont_Shadow_Large,            Normal, 17)
	SetFont(SystemFont_Shadow_Med1,             Normal, 13)
	SetFont(SystemFont_Shadow_Med3,             Normal, 15)
	SetFont(SystemFont_Shadow_Outline_Huge2,    Normal, 22, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            Normal, 11)		-- 人物面板属性字体
	SetFont(SystemFont_Small,                   Normal, 12)
	SetFont(SystemFont_Tiny,                    Normal, 11)
	SetFont(GameTooltipHeader,                  Normal, 13, "OUTLINE")
	SetFont(Tooltip_Med,                        Normal, 12)
	SetFont(Tooltip_Small,                      Normal, 11)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge,   				Normal, 27, "THICKOUTLINE")
	SetFont(CombatTextFont,              		Normal, 26)
	SetFont(ErrorFont,                			Normal, 13, nil, 60)
	SetFont(QuestFontNormalSmall,       		Normal, 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont,        			Normal, 31, "THICKOUTLINE",  40, nil, nil, 0, 0, 0, 1, -1)

	-- Zone fonts
	SetFont(ZoneTextString,						Normal, 20, "OUTLINE");
	SetFont(PVPInfoTextString,					Normal, 20, "OUTLINE");
	SetFont(SubZoneTextString,					Normal, 20, "OUTLINE");
	PVPInfoTextString:SetText("");
	
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
	for i=1,7 do
		local f = _G["ChatFrame"..i]
		local font, size = f:GetFont()
		f:SetFont(Normal, size)
	end

--	local function FixTitleFont() for _,butt in pairs(PlayerTitlePickerScrollFrame.buttons) do butt.text:SetFontObject(GameFontHighlightSmallLeft) end end
--	hooksecurefunc("PlayerTitleFrame_UpdateTitles", FixTitleFont)
--	FixTitleFont()
end)