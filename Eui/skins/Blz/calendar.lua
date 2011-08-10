local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local frames = {
		"CalendarFrame",
	}
	
	for _, frame in pairs(frames) do
		E.StripTextures(_G[frame])
	end
	
	E.EuiSetTemplate(CalendarFrame,.7)
	E.SkinCloseButton(CalendarCloseButton)
	CalendarCloseButton:SetPoint("TOPRIGHT", CalendarFrame, "TOPRIGHT", -4, -4)
	
	E.SkinNextPrevButton(CalendarPrevMonthButton)
	E.SkinNextPrevButton(CalendarNextMonthButton)
	
	do --Handle drop down button, this one is differant than the others
		local frame = CalendarFilterFrame
		local button = CalendarFilterButton

		E.StripTextures(frame)
		frame:SetWidth(155)
		
		_G[frame:GetName().."Text"]:ClearAllPoints()
		_G[frame:GetName().."Text"]:SetPoint("RIGHT", button, "LEFT", -2, 0)

		
		button:ClearAllPoints()
		button:SetPoint("RIGHT", frame, "RIGHT", -10, 3)
		button.SetPoint = E.dummy
		
		E.SkinNextPrevButton(button, true)
		
		E.EuiCreateBackdrop(frame)
		frame.backdrop:SetPoint("TOPLEFT", 20, 2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	end
	
	
	--backdrop
	local bg = CreateFrame("Frame", "CalendarFrameBackdrop", CalendarFrame)
	E.EuiSetTemplate(bg)
	bg:SetPoint("TOPLEFT", 10, -72)
	bg:SetPoint("BOTTOMRIGHT", -8, 3)
	
	E.EuiSetTemplate(CalendarContextMenu)
	CalendarContextMenu.SetBackdropColor = E.dummy
	CalendarContextMenu.SetBackdropBorderColor = E.dummy
	
	--Boost frame levels
	for i=1, 42 do
		_G["CalendarDayButton"..i]:SetFrameLevel(_G["CalendarDayButton"..i]:GetFrameLevel() + 1)
	end
	
	--CreateEventFrame
	E.StripTextures(CalendarCreateEventFrame)
	E.EuiSetTemplate(CalendarCreateEventFrame,.7)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	E.StripTextures(CalendarCreateEventTitleFrame)
	
	E.SkinButton(CalendarCreateEventCreateButton, true)
	E.SkinButton(CalendarCreateEventMassInviteButton, true)
	E.SkinButton(CalendarCreateEventInviteButton, true)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 1)
	CalendarCreateEventInviteEdit:SetWidth(CalendarCreateEventInviteEdit:GetWidth() - 2)
	
	E.StripTextures(CalendarCreateEventInviteList)
	E.EuiSetTemplate(CalendarCreateEventInviteList)
	
	E.SkinEditBox(CalendarCreateEventInviteEdit)
	E.SkinEditBox(CalendarCreateEventTitleEdit)
	E.SkinDropDownBox(CalendarCreateEventTypeDropDown, 120)
	
	E.StripTextures(CalendarCreateEventDescriptionContainer)
	E.EuiSetTemplate(CalendarCreateEventDescriptionContainer)
	
	E.SkinCloseButton(CalendarCreateEventCloseButton)
	
	E.SkinCheckBox(CalendarCreateEventLockEventCheck)
	
	E.SkinDropDownBox(CalendarCreateEventHourDropDown, 68)
	E.SkinDropDownBox(CalendarCreateEventMinuteDropDown, 68)
	E.SkinDropDownBox(CalendarCreateEventAMPMDropDown, 68)
	E.SkinDropDownBox(CalendarCreateEventRepeatOptionDropDown, 120)
	CalendarCreateEventIcon:SetTexCoord(.08, .92, .08, .92)
	CalendarCreateEventIcon.SetTexCoord = E.dummy
	
	E.StripTextures(CalendarCreateEventInviteListSection)
	
	CalendarClassButtonContainer:HookScript("OnShow", function()
		for i, class in ipairs(CLASS_SORT_ORDER) do
			local button = _G["CalendarClassButton"..i]
			E.StripTextures(button)
			E.EuiCreateBackdrop(button)
			
			local tcoords = CLASS_ICON_TCOORDS[class]
			local buttonIcon = button:GetNormalTexture()
			buttonIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			buttonIcon:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02) --F U C K I N G H A X
		end
		
		CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)
		
		E.StripTextures(CalendarClassTotalsButton)
		E.EuiCreateBackdrop(CalendarClassTotalsButton)
	end)
	
	--Texture Picker Frame
	E.StripTextures(CalendarTexturePickerFrame)
	E.StripTextures(CalendarTexturePickerTitleFrame)
	
	E.EuiSetTemplate(CalendarTexturePickerFrame,.7)
	
	E.SkinScrollBar(CalendarTexturePickerScrollBar)
	E.SkinButton(CalendarTexturePickerAcceptButton, true)
	E.SkinButton(CalendarTexturePickerCancelButton, true)
	E.SkinButton(CalendarCreateEventInviteButton, true)
	E.SkinButton(CalendarCreateEventRaidInviteButton, true)
	
	--Mass Invite Frame
	E.StripTextures(CalendarMassInviteFrame)
	E.EuiSetTemplate(CalendarMassInviteFrame,.7)
	E.StripTextures(CalendarMassInviteTitleFrame)
	
	E.SkinCloseButton(CalendarMassInviteCloseButton)
	E.SkinButton(CalendarMassInviteGuildAcceptButton)
	E.SkinButton(CalendarMassInviteArenaButton2)
	E.SkinButton(CalendarMassInviteArenaButton3)
	E.SkinButton(CalendarMassInviteArenaButton5)
	E.SkinDropDownBox(CalendarMassInviteGuildRankMenu, 130)
	
	E.SkinEditBox(CalendarMassInviteGuildMinLevelEdit)
	E.SkinEditBox(CalendarMassInviteGuildMaxLevelEdit)
	
	--Raid View
	E.StripTextures(CalendarViewRaidFrame)
	E.EuiSetTemplate(CalendarViewRaidFrame,.7)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	E.StripTextures(CalendarViewRaidTitleFrame)
	E.SkinCloseButton(CalendarViewRaidCloseButton)
	
	--Holiday View
	E.StripTextures(CalendarViewHolidayFrame,true)
	E.EuiSetTemplate(CalendarViewHolidayFrame,.7)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	E.StripTextures(CalendarViewHolidayTitleFrame)
	E.SkinCloseButton(CalendarViewHolidayCloseButton)
	
	-- Event View
	E.StripTextures(CalendarViewEventFrame)
	E.EuiSetTemplate(CalendarViewEventFrame,.7)
	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	E.StripTextures(CalendarViewEventTitleFrame)
	E.StripTextures(CalendarViewEventDescriptionContainer)
	E.EuiSetTemplate(CalendarViewEventDescriptionContainer,.7)
	E.StripTextures(CalendarViewEventInviteList)
	E.EuiSetTemplate(CalendarViewEventInviteList,.7)
	E.StripTextures(CalendarViewEventInviteListSection)
	E.SkinCloseButton(CalendarViewEventCloseButton)
	E.SkinScrollBar(CalendarViewEventInviteListScrollFrameScrollBar)
	
	local buttons = {
		"CalendarViewEventAcceptButton",
		"CalendarViewEventTentativeButton",
		"CalendarViewEventRemoveButton",
		"CalendarViewEventDeclineButton",
	}

	for _, button in pairs(buttons) do
		E.SkinButton(_G[button])
	end	
end

E.SkinFuncs["Blizzard_Calendar"] = LoadSkin