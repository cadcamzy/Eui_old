local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(GuildBankFrame)
	E.EuiSetTemplate(GuildBankFrame,.7)
	E.StripTextures(GuildBankEmblemFrame,true)
	
	--Close button doesn't have a fucking name, extreme hackage
	for i=1, GuildBankFrame:GetNumChildren() do
		local child = select(i, GuildBankFrame:GetChildren())
		if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
			E.SkinCloseButton(child)
		end
	end
	
	E.SkinButton(GuildBankFrameDepositButton, true)
	E.SkinButton(GuildBankFrameWithdrawButton, true)
	E.SkinButton(GuildBankInfoSaveButton, true)
	E.SkinButton(GuildBankFramePurchaseButton, true)
	
	GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)

	E.StripTextures(GuildBankInfoScrollFrame)
	E.StripTextures(GuildBankTransactionsScrollFrame)
	
	GuildBankFrame.inset = CreateFrame("Frame", nil, GuildBankFrame)
	E.EuiSetTemplate(GuildBankFrame.inset)
	GuildBankFrame.inset:SetPoint("TOPLEFT", 30, -65)
	GuildBankFrame.inset:SetPoint("BOTTOMRIGHT", -20, 63)
	
	for i=1, NUM_GUILDBANK_COLUMNS do
		E.StripTextures(_G["GuildBankColumn"..i])
		
		for x=1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..x]
			local icon = _G["GuildBankColumn"..i.."Button"..x.."IconTexture"]
			E.StripTextures(button)
			E.StyleButton(button)
			E.EuiSetTemplate(button)
			
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			icon:SetTexCoord(.08, .92, .08, .92)
		end
	end
	
	for i=1, 8 do
		local button = _G["GuildBankTab"..i.."Button"]
		local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]
		E.StripTextures(_G["GuildBankTab"..i],true)
		
		E.StripTextures(button)
		E.StyleButton(button,true)
		E.EuiSetTemplate(button)
		
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", 2, -2)
		texture:SetPoint("BOTTOMRIGHT", -2, 2)
		texture:SetTexCoord(.08, .92, .08, .92)
	end
	
	for i=1, 4 do
		E.SkinTab(_G["GuildBankFrameTab"..i])
	end
	
	--Popup
	E.StripTextures(GuildBankPopupFrame)
	E.StripTextures(GuildBankPopupScrollFrame)
	E.EuiSetTemplate(GuildBankPopupFrame,.7)
	GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	E.SkinButton(GuildBankPopupOkayButton)
	E.SkinButton(GuildBankPopupCancelButton)
	E.SkinEditBox(GuildBankPopupEditBox)
	E.Kill(GuildBankPopupNameLeft)
	E.Kill(GuildBankPopupNameRight)
	E.Kill(GuildBankPopupNameMiddle)
	
	for i=1, 16 do
		local button = _G["GuildBankPopupButton"..i]
		local icon = _G[button:GetName().."Icon"]
		E.StripTextures(button)
		E.EuiSetTemplate(button)
		E.StyleButton(button,true)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 2)
		icon:SetTexCoord(.08, .92, .08, .92)
	end
end

E.SkinFuncs["Blizzard_GuildBankUI"] = LoadSkin