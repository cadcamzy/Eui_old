Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.SkinCloseButton(AuctionFrameCloseButton)
	E.StripTextures(AuctionFrame,true)
	E.EuiSetTemplate(AuctionFrame,.7)
	E.EuiCreateShadow(AuctionFrame)
	
	E.StripTextures(BrowseFilterScrollFrame)
	E.StripTextures(BrowseScrollFrame)
	E.StripTextures(AuctionsScrollFrame)
	E.StripTextures(BidScrollFrame)
	
	E.SkinDropDownBox(BrowseDropDown)
	E.SkinDropDownBox(PriceDropDown)
	E.SkinDropDownBox(DurationDropDown)
	
	E.SkinCheckBox(IsUsableCheckButton)
	E.SkinCheckBox(ShowOnPlayerCheckButton)
	
	--Dress Up Frame
	E.StripTextures(AuctionDressUpFrame)
	E.EuiSetTemplate(AuctionDressUpFrame,.7)
	AuctionDressUpFrame:SetPoint("TOPLEFT", AuctionFrame, "TOPRIGHT", 2, 0)
	E.SkinButton(AuctionDressUpFrameResetButton)
	E.StripTextures(AuctionDressUpFrameCloseButton)
	AuctionDressUpFrameCloseButton:SetNormalTexture(AuctionFrameCloseButton:GetNormalTexture():GetTexture())
	AuctionDressUpFrameCloseButton:SetPushedTexture(AuctionFrameCloseButton:GetPushedTexture():GetTexture())
	AuctionDressUpFrameCloseButton:SetHighlightTexture(AuctionFrameCloseButton:GetHighlightTexture():GetTexture())
	AuctionDressUpFrameCloseButton:SetDisabledTexture(AuctionFrameCloseButton:GetDisabledTexture():GetTexture())
	
	E.SkinRotateButton(AuctionDressUpModelRotateLeftButton)
	E.SkinRotateButton(AuctionDressUpModelRotateRightButton)
	AuctionDressUpModelRotateRightButton:SetPoint("TOPLEFT", AuctionDressUpModelRotateLeftButton, "TOPRIGHT", 4, 0)
	
	--Progress Frame
	E.StripTextures(AuctionProgressFrame)
	E.EuiSetTemplate(AuctionProgressFrame,.7)
	E.EuiCreateShadow(AuctionProgressFrame)
	E.StyleButton(AuctionProgressFrameCancelButton)
	E.EuiSetTemplate(AuctionProgressFrameCancelButton)
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():ClearAllPoints()
	AuctionProgressFrameCancelButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
	AuctionProgressFrameCancelButton:SetSize(28, 28)
	AuctionProgressFrameCancelButton:SetPoint("LEFT", AuctionProgressBar, "RIGHT", 8, 0)
	
	AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)
	
	local backdrop = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
	backdrop:SetPoint("TOPLEFT", AuctionProgressBarIcon, "TOPLEFT", -2, 2)
	backdrop:SetPoint("BOTTOMRIGHT", AuctionProgressBarIcon, "BOTTOMRIGHT", 2, -2)
	E.EuiSetTemplate(backdrop)
	AuctionProgressBarIcon:SetParent(backdrop)
	
	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint("CENTER")
	
	E.StripTextures(AuctionProgressBar)
	E.EuiCreateBackdrop(AuctionProgressBar)
	AuctionProgressBar:SetStatusBarTexture(E.normTex)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)
	
	E.SkinNextPrevButton(BrowseNextPageButton)
	E.SkinNextPrevButton(BrowsePrevPageButton)
	
	local buttons = {
		"BrowseBidButton",
		"BidBidButton",
		"BrowseBuyoutButton",
		"BidBuyoutButton",
		"BrowseCloseButton",
		"BidCloseButton",
		"BrowseSearchButton",
		"AuctionsCreateAuctionButton",
		"AuctionsCancelAuctionButton",
		"AuctionsCloseButton",
		"BrowseResetButton",
		"AuctionsStackSizeMaxButton",
		"AuctionsNumStacksMaxButton",
	}
	
	for _, button in pairs(buttons) do
		E.SkinButton(_G[button])
	end
	
	--Fix Button Positions
	AuctionsCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -4, 0)
	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)		
	E.StripTextures(AuctionsItemButton)
	E.StyleButton(AuctionsItemButton)
	E.EuiSetTemplate(AuctionsItemButton)
	BrowseResetButton:SetPoint("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 81, -74)
	BrowseSearchButton:SetPoint("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)
	
	AuctionsItemButton:SetScript("OnUpdate", function()
		if AuctionsItemButton:GetNormalTexture() then
			AuctionsItemButton:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButton:GetNormalTexture():ClearAllPoints()
			AuctionsItemButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			AuctionsItemButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end)
	
	local sorttabs = {
		"BrowseQualitySort",
		"BrowseLevelSort",
		"BrowseDurationSort",
		"BrowseHighBidderSort",
		"BrowseCurrentBidSort",
		"BidQualitySort",
		"BidLevelSort",
		"BidDurationSort",
		"BidBuyoutSort",
		"BidStatusSort",
		"BidBidSort",
		"AuctionsQualitySort",
		"AuctionsDurationSort",
		"AuctionsHighBidderSort",
		"AuctionsBidSort",
	}
	
	for _, sorttab in pairs(sorttabs) do
		E.Kill(_G[sorttab.."Left"])
		E.Kill(_G[sorttab.."Middle"])
		E.Kill(_G[sorttab.."Right"])
	end
	
	for i=1, 3 do
		E.SkinTab(_G["AuctionFrameTab"..i])
	end
	
	for i=1, NUM_FILTERS_TO_DISPLAY do
		local tab = _G["AuctionFilterButton"..i]
		E.StripTextures(tab)
		E.StyleButton(tab)
	end
	
	local editboxs = {
		"BrowseName",
		"BrowseMinLevel",
		"BrowseMaxLevel",
		"BrowseBidPriceGold",
		"BrowseBidPriceSilver",
		"BrowseBidPriceCopper",
		"BidBidPriceGold",
		"BidBidPriceSilver",
		"BidBidPriceCopper",
		"AuctionsStackSizeEntry",
		"AuctionsNumStacksEntry",
		"StartPriceGold",
		"StartPriceSilver",
		"StartPriceCopper",
		"BuyoutPriceGold",
		"BuyoutPriceSilver",
		"BuyoutPriceCopper"			
	}
	
	for _, editbox in pairs(editboxs) do
		E.SkinEditBox(_G[editbox])
		_G[editbox]:SetTextInsets(1, 1, -1, 1)
	end
	BrowseMaxLevel:SetPoint("LEFT", BrowseMinLevel, "RIGHT", 8, 0)
	AuctionsStackSizeEntry.backdrop:SetAllPoints()
	AuctionsNumStacksEntry.backdrop:SetAllPoints()
	
	for i=1, NUM_BROWSE_TO_DISPLAY do
		local button = _G["BrowseButton"..i]
		local icon = _G["BrowseButton"..i.."Item"]
		
		_G["BrowseButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["BrowseButton"..i.."ItemIconTexture"]:ClearAllPoints()
		_G["BrowseButton"..i.."ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
		_G["BrowseButton"..i.."ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)
		
		E.StyleButton(icon)
		--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
		icon:HookScript("OnUpdate", function() E.Kill(icon:GetNormalTexture()) end)
		
		E.EuiCreateBackdrop(icon)
		icon.backdrop:SetAllPoints()

		E.StripTextures(button)
		E.StyleButton(button)
		_G["BrowseButton"..i.."Highlight"] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())
	end
	
	for i=1, NUM_AUCTIONS_TO_DISPLAY do
		local button = _G["AuctionsButton"..i]
		local icon = _G["AuctionsButton"..i.."Item"]
		
		_G["AuctionsButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["AuctionsButton"..i.."ItemIconTexture"].SetTexCoord = E.dummy
		_G["AuctionsButton"..i.."ItemIconTexture"]:ClearAllPoints()
		_G["AuctionsButton"..i.."ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
		_G["AuctionsButton"..i.."ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)
		
		E.StyleButton(icon)
		--TODO: Find a better method to ensure that the icon:GetNormalTexture doesn't return after clicking
		icon:HookScript("OnUpdate", function() E.Kill(icon:GetNormalTexture()) end)
		
		E.EuiCreateBackdrop(icon)
		icon.backdrop:SetAllPoints()

		E.StripTextures(button)
		E.StyleButton(button)
		_G["AuctionsButton"..i.."Highlight"] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())		
	end
	
	for i=1, NUM_BIDS_TO_DISPLAY do
		local button = _G["BidButton"..i]
		local icon = _G["BidButton"..i.."Item"]
		
		_G["BidButton"..i.."ItemIconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["BidButton"..i.."ItemIconTexture"]:ClearAllPoints()
		_G["BidButton"..i.."ItemIconTexture"]:SetPoint("TOPLEFT", 2, -2)
		_G["BidButton"..i.."ItemIconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)
		
		E.StyleButton(icon)
		icon:HookScript("OnUpdate", function() E.Kill(icon:GetNormalTexture()) end)
		
		E.EuiCreateBackdrop(icon)
		icon.backdrop:SetAllPoints()

		E.StripTextures(button)
		E.StyleButton(button)
		_G["BidButton"..i.."Highlight"] = button:GetHighlightTexture()
		button:GetHighlightTexture():ClearAllPoints()
		button:GetHighlightTexture():SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
		button:GetHighlightTexture():SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
		button:GetPushedTexture():SetAllPoints(button:GetHighlightTexture())			
	end
	
	--[[for i=1, AuctionFrameBrowse:GetNumRegions() do 
		local region = select(i, AuctionFrameBrowse:GetRegions());
		if region:GetObjectType() == "FontString" then 
			print(region:GetText(), region:GetName()) 
		end 
	end]]
	
	--Custom Backdrops
	AuctionFrameBrowse.bg1 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	E.EuiSetTemplate(AuctionFrameBrowse.bg1)
	AuctionFrameBrowse.bg1:SetPoint("TOPLEFT", 20, -103)
	AuctionFrameBrowse.bg1:SetPoint("BOTTOMRIGHT", -575, 40)
	BrowseNoResultsText:SetParent(AuctionFrameBrowse.bg1)
	BrowseSearchCountText:SetParent(AuctionFrameBrowse.bg1)
	BrowseFilterScrollFrame:SetHeight(300) --Adjust scrollbar height a little off

	AuctionFrameBrowse.bg2 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	E.EuiSetTemplate(AuctionFrameBrowse.bg2)
	AuctionFrameBrowse.bg2:SetPoint("TOPLEFT", AuctionFrameBrowse.bg1, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.bg2:SetPoint("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 40)
	BrowseScrollFrame:SetHeight(300) --Adjust scrollbar height a little off
	
	AuctionFrameBid.bg = CreateFrame("Frame", nil, AuctionFrameBid)
	E.EuiSetTemplate(AuctionFrameBid.bg)
	AuctionFrameBid.bg:SetPoint("TOPLEFT", 22, -72)
	AuctionFrameBid.bg:SetPoint("BOTTOMRIGHT", 66, 39)
	BidScrollFrame:SetHeight(332)	

	AuctionsScrollFrame:SetHeight(336)	
	AuctionFrameAuctions.bg1 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	E.EuiSetTemplate(AuctionFrameAuctions.bg1)
	AuctionFrameAuctions.bg1:SetPoint("TOPLEFT", 15, -70)
	AuctionFrameAuctions.bg1:SetPoint("BOTTOMRIGHT", -545, 35)  
	AuctionFrameAuctions.bg1:SetFrameLevel(AuctionFrameAuctions.bg1:GetFrameLevel() - 2)	
	
	AuctionFrameAuctions.bg2 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	E.EuiSetTemplate(AuctionFrameAuctions.bg2)
	AuctionFrameAuctions.bg2:SetPoint("TOPLEFT", AuctionFrameAuctions.bg1, "TOPRIGHT", 3, 0)
	AuctionFrameAuctions.bg2:SetPoint("BOTTOMRIGHT", AuctionFrame, -8, 35)  
	AuctionFrameAuctions.bg2:SetFrameLevel(AuctionFrameAuctions.bg2:GetFrameLevel() - 2)	
end

E.SkinFuncs["Blizzard_AuctionUI"] = LoadSkin