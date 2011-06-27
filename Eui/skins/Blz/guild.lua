local E, C = unpack(EUI)

if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(GuildFrame,true)
	E.EuiSetTemplate(GuildFrame,.7)
	E.EuiCreateShadow(GuildFrame)
	E.Kill(GuildLevelFrame)
	
	E.SkinCloseButton(GuildMemberDetailCloseButton)
	E.SkinCloseButton(GuildFrameCloseButton)
	
	local striptextures = {
		"GuildNewPerksFrame",
		"GuildFrameInset",
		"GuildFrameBottomInset",
		"GuildAllPerksFrame",
		"GuildMemberDetailFrame",
		"GuildMemberNoteBackground",
		"GuildInfoFrameInfo",
		"GuildLogContainer",
		"GuildLogFrame",
		"GuildRewardsFrame",
		"GuildMemberOfficerNoteBackground",
		"GuildTextEditContainer",
		"GuildTextEditFrame",
		"GuildRecruitmentRolesFrame",
		"GuildRecruitmentAvailabilityFrame",
		"GuildRecruitmentInterestFrame",
		"GuildRecruitmentLevelFrame",
		"GuildRecruitmentCommentFrame",
		"GuildRecruitmentCommentInputFrame",
		"GuildInfoFrameApplicantsContainer",
		"GuildInfoFrameApplicants",
		"GuildNewsBossModel",
		"GuildNewsBossModelTextFrame",
	}
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)
	for _, frame in pairs(striptextures) do
		E.StripTextures(_G[frame])
	end
	
	E.EuiCreateBackdrop(GuildNewsBossModel,.7)
	E.EuiCreateBackdrop(GuildNewsBossModelTextFrame)
	GuildNewsBossModelTextFrame.backdrop:SetPoint("TOPLEFT", GuildNewsBossModel.backdrop, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)
	
	local buttons = {
		"GuildPerksToggleButton",
		"GuildMemberRemoveButton",
		"GuildMemberGroupInviteButton",
		"GuildAddMemberButton",
		"GuildViewLogButton",
		"GuildControlButton",
		"GuildRecruitmentListGuildButton",
		"GuildTextEditFrameAcceptButton",
		"GuildRecruitmentInviteButton",
		"GuildRecruitmentMessageButton",
		"GuildRecruitmentDeclineButton",
	}
	
	for i, button in pairs(buttons) do
		if i == 1 then
			E.SkinButton(_G[button])
		else
			E.SkinButton(_G[button], true)
		end
	end
	
	local checkbuttons = {
		"Quest", 
		"Dungeon",
		"Raid",
		"PvP",
		"RP",
		"Weekdays",
		"Weekends",
		"LevelAny",
		"LevelMax",
	}
	
	for _, frame in pairs(checkbuttons) do
		E.SkinCheckBox(_G["GuildRecruitment"..frame.."Button"])
	end
	
	E.SkinCheckBox(GuildRecruitmentTankButton:GetChildren())
	E.SkinCheckBox(GuildRecruitmentHealerButton:GetChildren())
	E.SkinCheckBox(GuildRecruitmentDamagerButton:GetChildren())
	
	for i=1,5 do
		E.SkinTab(_G["GuildFrameTab"..i])
	end
	GuildXPFrame:ClearAllPoints()
	GuildXPFrame:SetPoint("TOP", GuildFrame, "TOP", 0, -40)
	
	E.SkinScrollBar(GuildPerksContainerScrollBar)
	
	E.StripTextures(GuildFactionBar)
	GuildFactionBar.progress:SetTexture(E.normTex)
	E.EuiCreateBackdrop(GuildFactionBar)
	GuildFactionBar.backdrop:SetPoint("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -2, 2)
	GuildFactionBar.backdrop:SetPoint("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", -2, 0)
	
	E.Kill(GuildXPBarLeft)
	E.Kill(GuildXPBarRight)
	E.Kill(GuildXPBarMiddle)
	E.Kill(GuildXPBarBG)
	E.Kill(GuildXPBarShadow)
	E.Kill(GuildXPBarCap)
	GuildXPBar.progress:SetTexture(E.normTex)
	E.EuiCreateBackdrop(GuildXPBar)
	GuildXPBar.backdrop:SetPoint("TOPLEFT", GuildXPBar.progress, "TOPLEFT", -2, 2)
	GuildXPBar.backdrop:SetPoint("BOTTOMRIGHT", GuildXPBar, "BOTTOMRIGHT", -2, 4)
	
	E.StripTextures(GuildLatestPerkButton)
	GuildLatestPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	GuildLatestPerkButtonIconTexture:ClearAllPoints()
	GuildLatestPerkButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	E.EuiCreateBackdrop(GuildLatestPerkButton)
	GuildLatestPerkButton.backdrop:SetPoint("TOPLEFT", GuildLatestPerkButtonIconTexture, "TOPLEFT", -2, 2)
	GuildLatestPerkButton.backdrop:SetPoint("BOTTOMRIGHT", GuildLatestPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
	
	E.StripTextures(GuildNextPerkButton)
	GuildNextPerkButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	GuildNextPerkButtonIconTexture:ClearAllPoints()
	GuildNextPerkButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	E.EuiCreateBackdrop(GuildNextPerkButton)
	GuildNextPerkButton.backdrop:SetPoint("TOPLEFT", GuildNextPerkButtonIconTexture, "TOPLEFT", -2, 2)
	GuildNextPerkButton.backdrop:SetPoint("BOTTOMRIGHT", GuildNextPerkButtonIconTexture, "BOTTOMRIGHT", 2, -2)
	
	--Guild Perk buttons list
	for i=1, 8 do
		local button = _G["GuildPerksContainerButton"..i]
		E.StripTextures(button)
		
		if button.icon then
			button.icon:SetTexCoord(.08, .92, .08, .92)
			button.icon:ClearAllPoints()
			button.icon:SetPoint("TOPLEFT", 2, -2)
			E.EuiCreateBackdrop(button)
			button.backdrop:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
			button.backdrop:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end
	
	--Roster
	E.SkinScrollBar(GuildRosterContainerScrollBar)
	E.SkinCheckBox(GuildRosterShowOfflineButton)
	
	
	for i=1, 4 do
		E.StripTextures(_G["GuildRosterColumnButton"..i],true)
	end
	
	E.SkinDropDownBox(GuildRosterViewDropdown, 200)
	
	for i=1, 14 do
		E.SkinButton(_G["GuildRosterContainerButton"..i.."HeaderButton"], true)
	end
	
	--Detail Frame
	E.EuiSetTemplate(GuildMemberDetailFrame,.7)
	E.EuiSetTemplate(GuildMemberNoteBackground)
	E.EuiSetTemplate(GuildMemberOfficerNoteBackground)
	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel() + 5)
	E.SkinDropDownBox(GuildMemberRankDropdown, 175)

	--News
	E.StripTextures(GuildNewsFrame)
	for i=1, 17 do
		E.Kill(_G["GuildNewsContainerButton"..i].header)
	end
	
	E.StripTextures(GuildNewsFiltersFrame)
	E.EuiSetTemplate(GuildNewsFiltersFrame,.7)
	E.SkinCloseButton(GuildNewsFiltersFrameCloseButton)
	
	for i=1, 7 do
		E.SkinCheckBox(_G["GuildNewsFilterButton"..i])
	end
	
	GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	E.SkinScrollBar(GuildNewsContainerScrollBar)
	
	--Info Frame
	E.SkinScrollBar(GuildInfoDetailsFrameScrollBar)
	
	for i=1, 3 do
		E.StripTextures(_G["GuildInfoFrameTab"..i])
	end
	
	local backdrop1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	E.EuiSetTemplate(backdrop1)
	backdrop1:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop1:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	backdrop1:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
	
	local backdrop2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	E.EuiSetTemplate(backdrop2)
	backdrop2:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop2:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	backdrop2:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)	

	local backdrop3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	E.EuiSetTemplate(backdrop3)
	backdrop3:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel() - 1)
	backdrop3:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	backdrop3:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)	
	
	GuildRecruitmentCommentInputFrame:SetTemplate("Default")
	
	for _, button in next, GuildInfoFrameApplicantsContainer.buttons do
		E.Kill(button.selectedTex)
		E.Kill(button:GetHighlightTexture())
		button:SetBackdrop(nil)
	end
	
	--Text Edit Frame
	E.EuiSetTemplate(GuildTextEditFrame,.7)
	E.SkinScrollBar(GuildTextEditScrollFrameScrollBar)
	E.EuiSetTemplate(GuildTextEditContainer)
	for i=1, GuildTextEditFrame:GetNumChildren() do
		local child = select(i, GuildTextEditFrame:GetChildren())
		if child:GetName() == "GuildTextEditFrameCloseButton" and child:GetWidth() == 32 then
			E.SkinCloseButton(child)
		elseif child:GetName() == "GuildTextEditFrameCloseButton" then
			E.SkinButton(child, true)
		end
	end
	
	--Guild Log
	E.SkinScrollBar(GuildLogScrollFrameScrollBar)
	E.EuiSetTemplate(GuildLogFrame,.7)

	--Blizzard has two buttons with the same name, this is a fucked up way of determining that it isn't the other button
	for i=1, GuildLogFrame:GetNumChildren() do
		local child = select(i, GuildLogFrame:GetChildren())
		if child:GetName() == "GuildLogFrameCloseButton" and child:GetWidth() == 32 then
			E.SkinCloseButton(child)
		elseif child:GetName() == "GuildLogFrameCloseButton" then
			E.SkinButton(child, true)
		end
	end
	
	--Rewards
	E.SkinScrollBar(GuildRewardsContainerScrollBar)
	
	for i=1, 8 do
		local button = _G["GuildRewardsContainerButton"..i]
		E.StripTextures(button)
		
		if button.icon then
			button.icon:SetTexCoord(.08, .92, .08, .92)
			button.icon:ClearAllPoints()
			button.icon:SetPoint("TOPLEFT", 2, -2)
			E.EuiCreateBackdrop(button)
			button.backdrop:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
			button.backdrop:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)
			button.icon:SetParent(button.backdrop)
		end
	end
end

E.SkinFuncs["Blizzard_GuildUI"] = LoadSkin