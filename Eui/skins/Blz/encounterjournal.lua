local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net

local function LoadSkin()
	E.StripTextures(EncounterJournal,true)
	
	EncounterJournal.backdrop = EncounterJournal:CreateTexture(nil, "BACKGROUND")
	EncounterJournal.backdrop:SetDrawLayer("BACKGROUND", -7)
	EncounterJournal.backdrop:SetTexture(0, 0, 0)
	EncounterJournal.backdrop:SetPoint("TOPLEFT", EncounterJournal, "TOPLEFT", -E.mult*3, E.mult*3)
	EncounterJournal.backdrop:SetPoint("BOTTOMRIGHT", EncounterJournal, "BOTTOMRIGHT", E.mult*3, -E.mult*3)
	
	EncounterJournal.backdrop2 = EncounterJournal:CreateTexture(nil, "BACKGROUND")
	EncounterJournal.backdrop2:SetDrawLayer("BACKGROUND", -6)
	EncounterJournal.backdrop2:SetTexture(.31,.45,.62)
	EncounterJournal.backdrop2:SetPoint("TOPLEFT", EncounterJournal, "TOPLEFT", -E.mult*2, E.mult*2)
	EncounterJournal.backdrop2:SetPoint("BOTTOMRIGHT", EncounterJournal, "BOTTOMRIGHT", E.mult*2, -E.mult*2)						

	EncounterJournal.backdrop3 = EncounterJournal:CreateTexture(nil, "BACKGROUND")
	EncounterJournal.backdrop3:SetDrawLayer("BACKGROUND", -5)
	EncounterJournal.backdrop3:SetTexture(0, 0, 0)
	EncounterJournal.backdrop3:SetPoint("TOPLEFT", EncounterJournal, "TOPLEFT", -E.mult, E.mult)
	EncounterJournal.backdrop3:SetPoint("BOTTOMRIGHT", EncounterJournal, "BOTTOMRIGHT", E.mult, -E.mult)					

	EncounterJournal.backdrop4 = EncounterJournal:CreateTexture(nil, "BACKGROUND")
	EncounterJournal.backdrop4:SetDrawLayer("BACKGROUND", -4)
	EncounterJournal.backdrop4:SetTexture(.1,.1,.1)
	EncounterJournal.backdrop4:SetAllPoints()						
	
	E.StripTextures(EncounterJournalNavBar,true)
	E.StripTextures(EncounterJournalNavBarOverlay,true)
	
	E.EuiCreateBackdrop(EncounterJournalNavBar)
	EncounterJournalNavBar.backdrop:SetPoint("TOPLEFT", -2, 0)
	EncounterJournalNavBar.backdrop:SetPoint("BOTTOMRIGHT")
	E.SkinButton(EncounterJournalNavBarHomeButton, true)
	
	E.SkinEditBox(EncounterJournalSearchBox)
	E.SkinCloseButton(EncounterJournalCloseButton)
	
	E.StripTextures(EncounterJournalInset,true)
	EncounterJournal:HookScript("OnShow", function()
		if not EncounterJournalInstanceSelect.backdrop then						
			EncounterJournalInstanceSelect.backdrop = EncounterJournalInstanceSelect:CreateTexture(nil, "BACKGROUND")
			EncounterJournalInstanceSelect.backdrop:SetDrawLayer("BACKGROUND", -3)
			EncounterJournalInstanceSelect.backdrop:SetTexture(0, 0, 0)
			EncounterJournalInstanceSelect.backdrop:SetPoint("TOPLEFT", EncounterJournalInstanceSelect.bg, "TOPLEFT", -E.mult*3, E.mult*3)
			EncounterJournalInstanceSelect.backdrop:SetPoint("BOTTOMRIGHT", EncounterJournalInstanceSelect.bg, "BOTTOMRIGHT", E.mult*3, -E.mult*3)
			
			EncounterJournalInstanceSelect.backdrop2 = EncounterJournalInstanceSelect:CreateTexture(nil, "BACKGROUND")
			EncounterJournalInstanceSelect.backdrop2:SetDrawLayer("BACKGROUND", -2)
			EncounterJournalInstanceSelect.backdrop2:SetTexture(.31,.45,.62)
			EncounterJournalInstanceSelect.backdrop2:SetPoint("TOPLEFT", EncounterJournalInstanceSelect.bg, "TOPLEFT", -E.mult*2, E.mult*2)
			EncounterJournalInstanceSelect.backdrop2:SetPoint("BOTTOMRIGHT", EncounterJournalInstanceSelect.bg, "BOTTOMRIGHT", E.mult*2, -E.mult*2)						

			EncounterJournalInstanceSelect.backdrop3 = EncounterJournalInstanceSelect:CreateTexture(nil, "BACKGROUND")
			EncounterJournalInstanceSelect.backdrop3:SetDrawLayer("BACKGROUND", -1)
			EncounterJournalInstanceSelect.backdrop3:SetTexture(0, 0, 0)
			EncounterJournalInstanceSelect.backdrop3:SetPoint("TOPLEFT", EncounterJournalInstanceSelect.bg, "TOPLEFT", -E.mult, E.mult)
			EncounterJournalInstanceSelect.backdrop3:SetPoint("BOTTOMRIGHT", EncounterJournalInstanceSelect.bg, "BOTTOMRIGHT", E.mult, -E.mult)								
		end
		
		if not EncounterJournalEncounterFrameInfo.backdrop then						
			EncounterJournalEncounterFrameInfo.backdrop = EncounterJournalEncounterFrameInfo:CreateTexture(nil, "BACKGROUND")
			EncounterJournalEncounterFrameInfo.backdrop:SetDrawLayer("BACKGROUND", -3)
			EncounterJournalEncounterFrameInfo.backdrop:SetTexture(0, 0, 0)
			EncounterJournalEncounterFrameInfo.backdrop:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoBG, "TOPLEFT", -E.mult*3, E.mult*3)
			EncounterJournalEncounterFrameInfo.backdrop:SetPoint("BOTTOMRIGHT", EncounterJournalEncounterFrameInfoBG, "BOTTOMRIGHT", E.mult*3, -E.mult*3)
			
			EncounterJournalEncounterFrameInfo.backdrop2 = EncounterJournalEncounterFrameInfo:CreateTexture(nil, "BACKGROUND")
			EncounterJournalEncounterFrameInfo.backdrop2:SetDrawLayer("BACKGROUND", -2)
			EncounterJournalEncounterFrameInfo.backdrop2:SetTexture(.31,.45,.62)
			EncounterJournalEncounterFrameInfo.backdrop2:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoBG, "TOPLEFT", -E.mult*2, E.mult*2)
			EncounterJournalEncounterFrameInfo.backdrop2:SetPoint("BOTTOMRIGHT", EncounterJournalEncounterFrameInfoBG, "BOTTOMRIGHT", E.mult*2, -E.mult*2)						

			EncounterJournalEncounterFrameInfo.backdrop3 = EncounterJournalEncounterFrameInfo:CreateTexture(nil, "BACKGROUND")
			EncounterJournalEncounterFrameInfo.backdrop3:SetDrawLayer("BACKGROUND", -1)
			EncounterJournalEncounterFrameInfo.backdrop3:SetTexture(0, 0, 0)
			EncounterJournalEncounterFrameInfo.backdrop3:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoBG, "TOPLEFT", -E.mult, E.mult)
			EncounterJournalEncounterFrameInfo.backdrop3:SetPoint("BOTTOMRIGHT", EncounterJournalEncounterFrameInfoBG, "BOTTOMRIGHT", E.mult, -E.mult)								
		end	
		EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoBossTab:SetPoint("LEFT", EncounterJournalEncounterFrameInfoEncounterTile, "RIGHT", -10, 4)
		EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
		EncounterJournalEncounterFrameInfoLootTab:SetPoint("LEFT", EncounterJournalEncounterFrameInfoBossTab, "RIGHT", -24, 0)
		
		EncounterJournalEncounterFrameInfoBossTab:SetFrameStrata("HIGH")
		EncounterJournalEncounterFrameInfoLootTab:SetFrameStrata("HIGH")
		
		EncounterJournalEncounterFrameInfoBossTab:SetScale(0.75)
		EncounterJournalEncounterFrameInfoLootTab:SetScale(0.75)
		
		EncounterJournalEncounterFrameInfoLootScrollFrameFilter:SetScript("OnShow", function()
			EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
			EncounterJournalEncounterFrameInfoBossTab:SetPoint("LEFT", EncounterJournalEncounterFrameInfoLootScrollFrameFilter, "RIGHT", 0, 0)	
			EncounterJournalEncounterFrameInfoEncounterTile:Hide()
		end)

		EncounterJournalEncounterFrameInfoLootScrollFrameFilter:SetScript("OnHide", function()
			EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
			EncounterJournalEncounterFrameInfoBossTab:SetPoint("LEFT", EncounterJournalEncounterFrameInfoEncounterTile, "RIGHT", -10, 4)	
			EncounterJournalEncounterFrameInfoEncounterTile:Show()
		end)		
	end)
		
	E.SkinScrollBar(EncounterJournalInstanceSelectScrollFrameScrollBar, 4)
	E.SkinScrollBar(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar, 4)
	E.SkinScrollBar(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar, 4)

	EncounterJournalEncounterFrameInfoBossTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:GetHighlightTexture():SetTexture(nil)

	EncounterJournalEncounterFrameInfoLootTab:GetNormalTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetPushedTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetDisabledTexture():SetTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:GetHighlightTexture():SetTexture(nil)		
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)