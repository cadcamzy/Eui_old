local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(TimeManagerFrame)
	E.EuiSetTemplate(TimeManagerFrame,.7)

	E.SkinCloseButton(TimeManagerCloseButton)

	E.SkinDropDownBox(TimeManagerAlarmHourDropDown, 80)
	E.SkinDropDownBox(TimeManagerAlarmMinuteDropDown, 80)
	E.SkinDropDownBox(TimeManagerAlarmAMPMDropDown, 80)
	
	E.SkinEditBox(TimeManagerAlarmMessageEditBox)
	
	E.SkinButton(TimeManagerAlarmEnabledButton, true)
	TimeManagerAlarmEnabledButton:HookScript("OnClick", function(self)
		E.SkinButton(self)
	end)

	TimeManagerFrame:HookScript("OnShow", function(self)
		E.SkinButton(TimeManagerAlarmEnabledButton)
	end)		
	
	E.SkinCheckBox(TimeManagerMilitaryTimeCheck)
	E.SkinCheckBox(TimeManagerLocalTimeCheck)
	
	E.StripTextures(TimeManagerStopwatchFrame)
	E.EuiSetTemplate(TimeManagerStopwatchCheck)
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
	TimeManagerStopwatchCheck:GetNormalTexture():ClearAllPoints()
	TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	local hover = TimeManagerStopwatchCheck:CreateTexture("frame", nil, TimeManagerStopwatchCheck) -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:SetPoint("TOPLEFT",TimeManagerStopwatchCheck,2,-2)
	hover:SetPoint("BOTTOMRIGHT",TimeManagerStopwatchCheck,-2,2)
	TimeManagerStopwatchCheck:SetHighlightTexture(hover)
	
	E.StripTextures(StopwatchFrame)
	E.EuiCreateBackdrop(StopwatchFrame,.7)
	StopwatchFrame.backdrop:SetPoint("TOPLEFT", 0, -17)
	StopwatchFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 2)
	
	E.StripTextures(StopwatchTabFrame)
	E.SkinCloseButton(StopwatchCloseButton)
	E.SkinNextPrevButton(StopwatchPlayPauseButton)
	E.SkinNextPrevButton(StopwatchResetButton)
	StopwatchPlayPauseButton:SetPoint("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
	StopwatchResetButton:SetPoint("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
end

E.SkinFuncs["Blizzard_TimeManager"] = LoadSkin