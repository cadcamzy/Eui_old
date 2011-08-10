local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(GuildControlUI)
	E.StripTextures(GuildControlUIHbar)
	E.EuiSetTemplate(GuildControlUI,.7)
	E.EuiCreateShadow(GuildControlUI)
	
	local function SkinGuildRanks()
		for i=1, GuildControlGetNumRanks() do
			local rankFrame = _G["GuildControlUIRankOrderFrameRank"..i]
			if rankFrame then
				E.SkinButton(rankFrame.downButton)
				E.SkinButton(rankFrame.upButton)
				E.SkinButton(rankFrame.deleteButton)
				
				if not rankFrame.nameBox.backdrop then
					E.SkinEditBox(rankFrame.nameBox)
				end
				
				rankFrame.nameBox.backdrop:SetPoint("TOPLEFT", -2, -4)
				rankFrame.nameBox.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
			end
		end				
	end
	hooksecurefunc("GuildControlUI_RankOrder_Update", SkinGuildRanks)
	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", function()
		E.Delay(1, SkinGuildRanks)
	end)
	
	E.SkinDropDownBox(GuildControlUINavigationDropDown)
	E.SkinDropDownBox(GuildControlUIRankSettingsFrameRankDropDown, 180)
	GuildControlUINavigationDropDownButton:SetWidth(20)
	GuildControlUIRankSettingsFrameRankDropDownButton:SetWidth(20)
	
	for i=1, NUM_RANK_FLAGS do
		if _G["GuildControlUIRankSettingsFrameCheckbox"..i] then
			E.SkinCheckBox(_G["GuildControlUIRankSettingsFrameCheckbox"..i])
		end
	end
	
	E.SkinButton(GuildControlUIRankOrderFrameNewButton)
	
	E.SkinEditBox(GuildControlUIRankSettingsFrameGoldBox)
	GuildControlUIRankSettingsFrameGoldBox.backdrop:SetPoint("TOPLEFT", -2, -4)
	GuildControlUIRankSettingsFrameGoldBox.backdrop:SetPoint("BOTTOMRIGHT", 2, 4)
	E.StripTextures(GuildControlUIRankSettingsFrameGoldBox)
	
	E.StripTextures(GuildControlUIRankBankFrame)
	
	local once = false
	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		local numTabs = GetNumGuildBankTabs()
		if numTabs < MAX_BUY_GUILDBANK_TABS then
			numTabs = numTabs + 1
		end
		for i=1, numTabs do
			local tab = _G["GuildControlBankTab"..i.."Owned"]
			local icon = tab.tabIcon
			local editbox = tab.editBox
			
			icon:SetTexCoord(.08, .92, .08, .92)
			
			if once == false then
				E.SkinButton(_G["GuildControlBankTab"..i.."BuyPurchaseButton"])
				E.StripTextures(_G["GuildControlBankTab"..i.."OwnedStackBox"])
			end
		end
		once = true
	end)
	
	E.SkinDropDownBox(GuildControlUIRankBankFrameRankDropDown, 180)
	GuildControlUIRankBankFrameRankDropDownButton:SetWidth(20)
end

E.SkinFuncs["Blizzard_GuildControlUI"] = LoadSkin