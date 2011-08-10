local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local checkbox = {
		"LookingForGuildPvPButton",
		"LookingForGuildWeekendsButton",
		"LookingForGuildWeekdaysButton",
		"LookingForGuildRPButton",
		"LookingForGuildRaidButton",
		"LookingForGuildQuestButton",
		"LookingForGuildDungeonButton",
	}
	-- skin checkboxes
	for _, v in pairs(checkbox) do
		E.SkinCheckBox(_G[v])
	end
	

	-- have to skin these checkboxes seperate for some reason o_O
	E.SkinCheckBox(LookingForGuildTankButton.checkButton)
	E.SkinCheckBox(LookingForGuildHealerButton.checkButton)
	E.SkinCheckBox(LookingForGuildDamagerButton.checkButton)
	
	-- skinning other frames
	E.StripTextures(LookingForGuildFrameInset,false)
	E.StripTextures(LookingForGuildFrame)
	E.EuiSetTemplate(LookingForGuildFrame)
	E.Kill(LookingForGuildBrowseButton_LeftSeparator)
	E.Kill(LookingForGuildRequestButton_RightSeparator)
	E.SkinScrollBar(LookingForGuildBrowseFrameContainerScrollBar)
	E.SkinButton(LookingForGuildBrowseButton)
	E.SkinButton(LookingForGuildRequestButton)
	E.SkinCloseButton(LookingForGuildFrameCloseButton)
	E.EuiCreateBackdrop(LookingForGuildCommentInputFrame)
	E.StripTextures(LookingForGuildCommentInputFrame,false)
	
	-- skin container buttons on browse and request page
	for i = 1, 5 do
		local b = _G["LookingForGuildBrowseFrameContainerButton"..i]
		local t = _G["LookingForGuildAppsFrameContainerButton"..i]
		b:SetBackdrop(nil)
		t:SetBackdrop(nil)
	end
	
	-- skin tabs
	for i= 1, 3 do
		E.SkinTab(_G["LookingForGuildFrameTab"..i])
	end
	
	E.StripTextures(GuildFinderRequestMembershipFrame,true)
	E.EuiSetTemplate(GuildFinderRequestMembershipFrame,.7)
	E.SkinButton(GuildFinderRequestMembershipFrameAcceptButton)
	E.SkinButton(GuildFinderRequestMembershipFrameCancelButton)
	E.StripTextures(GuildFinderRequestMembershipFrameInputFrame)
	E.EuiSetTemplate(GuildFinderRequestMembershipFrameInputFrame)
end

E.SkinFuncs["Blizzard_LookingForGuildUI"] = LoadSkin