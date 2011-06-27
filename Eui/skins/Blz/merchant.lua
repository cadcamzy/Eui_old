local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local frames = {
		"MerchantBuyBackItem",
		"MerchantFrame",
	}
	
	-- skin main frames
	for i = 1, #frames do
		E.StripTextures(_G[frames[i]],true)
		E.EuiCreateBackdrop(_G[frames[i]],.7)
	end
	MerchantBuyBackItem.backdrop:SetPoint("TOPLEFT", -6, 6)
	MerchantBuyBackItem.backdrop:SetPoint("BOTTOMRIGHT", 6, -6)
	MerchantFrame.backdrop:SetPoint("TOPLEFT", 6, 0)
	MerchantFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 35)
	MerchantFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 60)
	-- skin tabs
	for i= 1, 2 do
		E.SkinTab(_G["MerchantFrameTab"..i])
	end
	
	-- skin icons / merchant slots
	for i = 1, 12 do
		local b = _G["MerchantItem"..i.."ItemButton"]
		local t = _G["MerchantItem"..i.."ItemButtonIconTexture"]
		local item_bar = _G["MerchantItem"..i]
		E.StripTextures(item_bar)
		E.EuiCreateBackdrop(item_bar)
		
		E.StripTextures(b)
		E.StyleButton(b,false)
		E.EuiSetTemplate(b)
		b:SetPoint("TOPLEFT", item_bar, "TOPLEFT", 4, -4)
		t:SetTexCoord(.08, .92, .08, .92)
		t:ClearAllPoints()
		t:SetPoint("TOPLEFT", 2, -2)
		t:SetPoint("BOTTOMRIGHT", -2, 2)
		
		_G["MerchantItem"..i.."MoneyFrame"]:ClearAllPoints()
		_G["MerchantItem"..i.."MoneyFrame"]:SetPoint("BOTTOMLEFT", b, "BOTTOMRIGHT", 3, 0)
		
	end
	
	-- Skin buyback item frame + icon
	E.StripTextures(MerchantBuyBackItemItemButton)
	E.StyleButton(MerchantBuyBackItemItemButton,false)
	E.EuiSetTemplate(MerchantBuyBackItemItemButton)
	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
	MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -2, 2)

	
	E.StyleButton(MerchantRepairItemButton,false)
	E.EuiSetTemplate(MerchantRepairItemButton)
	for i=1, MerchantRepairItemButton:GetNumRegions() do
		local region = select(i, MerchantRepairItemButton:GetRegions())
		if region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\MerchantFrame\\UI-Merchant-RepairIcons" then
			region:SetTexCoord(0.04, 0.24, 0.06, 0.5)
			region:ClearAllPoints()
			region:SetPoint("TOPLEFT", 2, -2)
			region:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end
	
	E.StyleButton(MerchantGuildBankRepairButton)
	E.EuiSetTemplate(MerchantGuildBankRepairButton)
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	MerchantGuildBankRepairButtonIcon:ClearAllPoints()
	MerchantGuildBankRepairButtonIcon:SetPoint("TOPLEFT", 2, -2)
	MerchantGuildBankRepairButtonIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	
	E.StyleButton(MerchantRepairAllButton,false)
	E.EuiSetTemplate(MerchantRepairAllButton)
	MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	MerchantRepairAllIcon:ClearAllPoints()
	MerchantRepairAllIcon:SetPoint("TOPLEFT", 2, -2)
	MerchantRepairAllIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	
	-- Skin misc frames
	MerchantFrame:SetWidth(360)
	E.SkinCloseButton(MerchantFrameCloseButton, MerchantFrame.backdrop)
	E.SkinNextPrevButton(MerchantNextPageButton)
	E.SkinNextPrevButton(MerchantPrevPageButton)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)