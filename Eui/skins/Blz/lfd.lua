local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local StripAllTextures = {
		"LFDParentFrame",
		"LFDQueueFrame",
		"LFDQueueFrameSpecific",
		"LFDQueueFrameRandom",
		"LFDQueueFrameRandomScrollFrame",
		"LFDQueueFrameCapBar",
		"LFDDungeonReadyDialog",
	}
	
	local KillTextures = {
		"LFDQueueFrameBackground",
		"LFDParentFrameInset",
		"LFDParentFrameEyeFrame",
		"LFDQueueFrameRoleButtonTankBackground",
		"LFDQueueFrameRoleButtonHealerBackground",
		"LFDQueueFrameRoleButtonDPSBackground",
		"LFDDungeonReadyDialogBackground",
	}
	local buttons = {
		"LFDQueueFrameFindGroupButton",
		"LFDQueueFrameCancelButton",
		"LFDQueueFramePartyBackfillBackfillButton",
		"LFDQueueFramePartyBackfillNoBackfillButton",
	}

	local checkButtons = {
		"LFDQueueFrameRoleButtonTank",
		"LFDQueueFrameRoleButtonHealer",
		"LFDQueueFrameRoleButtonDPS",
		"LFDQueueFrameRoleButtonLeader",
	}
	
	for _, object in pairs(checkButtons) do
		_G[object].checkButton:SetFrameLevel(_G[object].checkButton:GetFrameLevel() + 2)
		E.SkinCheckBox(_G[object].checkButton)
	end
	
	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		local dungeonID = LFDQueueFrame.type
		if type(dungeonID) == "string" then return end
		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)
		
		for i=1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
			local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
			local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
			local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon1"]
			local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon2"]
			local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon3"]
			
			if button then
				local __texture = _G[button:GetName().."IconTexture"]:GetTexture()
				E.StripTextures(button)
				icon:SetTexture(__texture)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				if not button.backdrop then
					E.EuiCreateBackdrop(button)
					button.backdrop:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
					button.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
					icon:SetParent(button.backdrop)
					icon.SetPoint = E.dummy
					
					if count then
						count:SetParent(button.backdrop)
					end
					if role1 then
						role1:SetParent(button.backdrop)
					end
					if role2 then
						role2:SetParent(button.backdrop)
					end
					if role3 then
						role3:SetParent(button.backdrop)
					end							
				end
			end
		end				
	end)
	
	hooksecurefunc("LFDQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID, mode, submode)
		for _, object in pairs(checkButtons) do
			local button = _G[object]
			if not ( button.checkButton:GetChecked() ) then
				button.checkButton:SetDisabledTexture(nil)	
			else
				button.checkButton:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")	
			end
		end
		
		local oldTex = button.enableButton:GetDisabledCheckedTexture():GetTexture()
		if not button.enableButton:GetChecked() then
			button.enableButton:SetDisabledTexture(nil)
		else
			button.enableButton:SetDisabledTexture(oldTex)	
		end
	end)
	
	
	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end	

	for i=1, NUM_LFD_CHOICE_BUTTONS do
		E.SkinCheckBox(_G["LFDQueueFrameSpecificListButton"..i.."EnableButton"])
	end
	
	LFDQueueFrameCapBar:SetPoint("LEFT", 40, 0)
	E.EuiSetTemplate(LFDDungeonReadyDialog,.7)
	E.EuiCreateShadow(LFDDungeonReadyDialog)
	E.StripTextures(LFDQueueFrameSpecificListScrollFrame)
	LFDQueueFrameSpecificListScrollFrame:SetHeight(LFDQueueFrameSpecificListScrollFrame:GetHeight() - 8)
	E.EuiCreateBackdrop(LFDParentFrame,.7)
	LFDParentFrame.backdrop:SetPoint( "TOPLEFT", LFDParentFrame, "TOPLEFT")
	LFDParentFrame.backdrop:SetPoint( "BOTTOMRIGHT", LFDParentFrame, "BOTTOMRIGHT")
	E.SkinCloseButton(LFDParentFrameCloseButton,LFDParentFrame)
	E.SkinCloseButton(LFDDungeonReadyDialogCloseButton,LFDDungeonReadyDialog)
	E.SkinDropDownBox(LFDQueueFrameTypeDropDown, 300)
	LFDQueueFrameTypeDropDown:SetPoint("RIGHT",-10,0)
	E.EuiCreateBackdrop(LFDQueueFrameCapBar,.7)
	LFDQueueFrameCapBar.backdrop:SetPoint( "TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", 1, -1)
	LFDQueueFrameCapBar.backdrop:SetPoint( "BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", -1, 1 )
	LFDQueueFrameCapBarProgress:SetTexture(E.normTex)
	LFDQueueFrameCapBarCap1:SetTexture(E.normTex)
	LFDQueueFrameCapBarCap2:SetTexture(E.normTex)
	E.SkinScrollBar(LFDQueueFrameSpecificListScrollFrameScrollBar)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)