Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(ItemTextFrame,true)
	E.StripTextures(ItemTextScrollFrame)
	E.EuiSetTemplate(ItemTextFrame,.7)
	E.SkinCloseButton(ItemTextCloseButton)
	E.SkinNextPrevButton(ItemTextPrevPageButton)
	E.SkinNextPrevButton(ItemTextNextPageButton)
	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = E.dummy
	
	local StripAllTextures = {
		"GossipFrameGreetingPanel",
	}			

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	local KillTextures = {
		"GossipFramePortrait",
	}

	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	local buttons = {
		"GossipFrameGreetingGoodbyeButton",
	}

	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end


	for i = 1, NUMGOSSIPBUTTONS do
		obj = select(3,_G["GossipTitleButton"..i]:GetRegions())
		obj:SetTextColor(1,1,1)
	end

	GossipGreetingText:SetTextColor(1,1,1)
	E.EuiCreateBackdrop(GossipFrame,.7)
	GossipFrame.backdrop:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 15, -20)
	GossipFrame.backdrop:SetPoint("BOTTOMRIGHT", GossipFrame, "BOTTOMRIGHT", -30, 65)
	E.SkinCloseButton(GossipFrameCloseButton,GossipFrame.backdrop)
	
	
	--Extreme hackage, blizzard makes button text on quest frame use hex color codes for some reason
	hooksecurefunc("GossipFrameUpdate", function()
		for i=1, NUMGOSSIPBUTTONS do
			local button = _G["GossipTitleButton"..i]
			
			if button:GetFontString() then
				if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
					button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)	
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)