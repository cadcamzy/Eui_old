local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.SkinCloseButton(CharacterFrameCloseButton)
	
	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
	}
	for _, slot in pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local slot = _G["Character"..slot]
		E.StripTextures(slot)
		E.StyleButton(slot,false)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 2)
		
		slot:SetFrameLevel(slot:GetFrameLevel() + 2)
		E.EuiCreateBackdrop(slot)
		slot.backdrop:SetAllPoints()
	end
	
	-- a request by diftraku to color item by rarity on character frame.
	local function ColorItemBorder()
		for _, slot in pairs(slots) do
			-- Colour the equipment slots by rarity
			local target = _G["Character"..slot]
			local slotId, _, _ = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemID("player", slotId)

			if itemId then
				local _, _, rarity, _, _, _, _, _, _, _, _ = GetItemInfo(itemId)
				if rarity and rarity > 1 then
					target.backdrop:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target.backdrop:SetBackdropBorderColor(0.31, 0.45, 0.63)
				end
			else
				target.backdrop:SetBackdropBorderColor(0.31, 0.45, 0.63)
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("PLAYER_ENTERING_WORLD")
	CheckItemBorderColor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)	
	ColorItemBorder()
	
	--Strip Textures
	local charframe = {
		"CharacterFrame",
		"CharacterModelFrame",
		"CharacterFrameInset", 
		"CharacterStatsPane",
		"CharacterFrameInsetRight",
		"PaperDollSidebarTabs",
		"PaperDollEquipmentManagerPane",
		"PaperDollFrameItemFlyout",
	}
	
	CharacterFrameExpandButton:SetSize(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
	E.SkinNextPrevButton(CharacterFrameExpandButton)
	
	E.SkinRotateButton(CharacterModelFrameRotateLeftButton)
	E.SkinRotateButton(CharacterModelFrameRotateRightButton)
	CharacterModelFrameRotateLeftButton:SetPoint("TOPLEFT", CharacterModelFrame, "TOPLEFT", 4, -4)
	CharacterModelFrameRotateRightButton:SetPoint("TOPLEFT", CharacterModelFrameRotateLeftButton, "TOPRIGHT", 4, 0)
	
	--Swap item flyout frame (shown when holding alt over a slot)
	PaperDollFrameItemFlyout:HookScript("OnShow", function()
		E.StripTextures(PaperDollFrameItemFlyoutButtons)
		
		for i=1, PDFITEMFLYOUT_MAXITEMS do
			local button = _G["PaperDollFrameItemFlyoutButtons"..i]
			local icon = _G["PaperDollFrameItemFlyoutButtons"..i.."IconTexture"]
			if button then
				E.StyleButton(button,false)
				
				icon:SetTexCoord(.08, .92, .08, .92)
				button:GetNormalTexture():SetTexture(nil)
				
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)	
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					E.EuiCreateBackdrop(button)
					button.backdrop:SetAllPoints()			
				end
			end
		end
	end)
	
	--Icon in upper right corner of character frame
	E.Kill(CharacterFramePortrait)
	E.EuiCreateBackdrop(CharacterModelFrame)

	local scrollbars = {
		"PaperDollTitlesPaneScrollBar",
		"PaperDollEquipmentManagerPaneScrollBar",
	}
	
	for _, scrollbar in pairs(scrollbars) do
		E.SkinScrollBar(_G[scrollbar])
	end
	
	for _, object in pairs(charframe) do
		E.StripTextures(_G[object])
	end
	
	E.EuiSetTemplate(CharacterFrame)
	
	--Titles
	PaperDollTitlesPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollTitlesPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.Check:SetTexture(nil)
			object.text:SetFont(E.font,12)
			object.text.SetFont = E.dummy
		end
	end)
	
	--Equipement Manager
	E.SkinButton(PaperDollEquipmentManagerPaneEquipSet)
	E.SkinButton(PaperDollEquipmentManagerPaneSaveSet)
	PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneSaveSet:SetWidth(PaperDollEquipmentManagerPaneSaveSet:GetWidth() - 8)
	PaperDollEquipmentManagerPaneEquipSet:SetPoint("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
	PaperDollEquipmentManagerPane:HookScript("OnShow", function(self)
		for x, object in pairs(PaperDollEquipmentManagerPane.buttons) do
			object.BgTop:SetTexture(nil)
			object.BgBottom:SetTexture(nil)
			object.BgMiddle:SetTexture(nil)

			object.Check:SetTexture(nil)
			object.icon:SetTexCoord(.08, .92, .08, .92)
			
			if not object.backdrop then
				E.EuiCreateBackdrop(object)
			end
			
			object.backdrop:SetPoint("TOPLEFT", object.icon, "TOPLEFT", -2, 2)
			object.backdrop:SetPoint("BOTTOMRIGHT", object.icon, "BOTTOMRIGHT", 2, -2)
			object.icon:SetParent(object.backdrop)

			--Making all icons the same size and position because otherwise BlizzardUI tries to attach itself to itself when it refreshes
			object.icon:SetPoint("LEFT", object, "LEFT", 4, 0)
			object.icon.SetPoint = E.dummy
			object.icon:SetSize(36, 36)
			object.icon.SetSize = E.dummy
		end
		E.StripTextures(GearManagerDialogPopup)
		E.EuiSetTemplate(GearManagerDialogPopup)
		GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 4, 0)
		E.StripTextures(GearManagerDialogPopupScrollFrame)
		E.StripTextures(GearManagerDialogPopupEditBox)
		E.EuiSetTemplate(GearManagerDialogPopupEditBox)
		E.SkinButton(GearManagerDialogPopupOkay)
		E.SkinButton(GearManagerDialogPopupCancel)
		
		for i=1, NUM_GEARSET_ICONS_SHOWN do
			local button = _G["GearManagerDialogPopupButton"..i]
			local icon = button.icon
			
			if button then
				E.StripTextures(button)
				E.StyleButton(button,true)
				
				icon:SetTexCoord(.08, .92, .08, .92)
				_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)
				
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)	
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.backdrop then
					E.EuiCreateBackdrop(button)
					button.backdrop:SetAllPoints()			
				end
			end
		end
	end)
	
	--Handle Tabs at bottom of character frame
	for i=1, 4 do
		E.SkinTab(_G["CharacterFrameTab"..i])
	end
	
	--Buttons used to toggle between equipment manager, titles, and character stats
	local function FixSidebarTabCoords()
		for i=1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if tab then
				tab.Highlight:SetTexture(1, 1, 1, 0.3)
				tab.Highlight:SetPoint("TOPLEFT", 3, -4)
				tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
				tab.Hider:SetTexture(0.4,0.4,0.4,0.4)
				tab.Hider:SetPoint("TOPLEFT", 3, -4)
				tab.Hider:SetPoint("BOTTOMRIGHT", -1, 0)
				E.Kill(tab.TabBg)
				
				if i == 1 then
					for i=1, tab:GetNumRegions() do
						local region = select(i, tab:GetRegions())
						region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
						region.SetTexCoord = E.dummy
					end
				end
				E.EuiCreateBackdrop(tab)
				tab.backdrop:SetPoint("TOPLEFT", 1, -2)
				tab.backdrop:SetPoint("BOTTOMRIGHT", 1, -2)	
			end
		end
	end
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
	
	--Stat panels, atm it looks like 7 is the max
	for i=1, 7 do
		E.StripTextures(_G["CharacterStatsPaneCategory"..i])
	end
	
	--Reputation
	local function UpdateFactionSkins()
		E.StripTextures(ReputationListScrollFrame)
		E.StripTextures(ReputationFrame,true)
		for i=1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				statusbar:SetStatusBarTexture(E.normTex)
				
				if not statusbar.backdrop then
					E.EuiCreateBackdrop(statusbar)
				end
				
				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				E.Kill(_G["ReputationBar"..i.."LeftLine"])
				E.Kill(_G["ReputationBar"..i.."BottomLine"])
				_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				
			end		
		end
		E.StripTextures(ReputationDetailFrame)
		E.EuiSetTemplate(ReputationDetailFrame)
		ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)			
	end	
	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)
	
	--Currency
	TokenFrame:HookScript("OnShow", function()
		for i=1, GetCurrencyListSize() do
			local button = _G["TokenFrameContainerButton"..i]
			
			if button then
				E.Kill(button.highlight)
				E.Kill(button.categoryMiddle)	
				E.Kill(button.categoryLeft)	
				E.Kill(button.categoryRight)
				
				if button.icon then
					button.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
		E.StripTextures(TokenFramePopup)
		E.EuiSetTemplate(TokenFramePopup,0.1)
		TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)				
	end)
	
	--Pet
	E.EuiCreateBackdrop(PetModelFrame)
	E.StripTextures(PetPaperDollFrameExpBar)
	PetPaperDollFrameExpBar:SetStatusBarTexture(E.normTex)
	E.EuiCreateBackdrop(PetPaperDollFrameExpBar)
	E.SkinRotateButton(PetModelFrameRotateRightButton)
	E.SkinRotateButton(PetModelFrameRotateLeftButton)
	PetModelFrameRotateRightButton:ClearAllPoints()
	PetModelFrameRotateRightButton:SetPoint("LEFT", PetModelFrameRotateLeftButton, "RIGHT", 4, 0)
	
	local xtex = PetPaperDollPetInfo:GetRegions()
	xtex:SetTexCoord(.12, .63, .15, .55)
	E.EuiCreateBackdrop(PetPaperDollPetInfo)
	PetPaperDollPetInfo:SetSize(24, 24)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)