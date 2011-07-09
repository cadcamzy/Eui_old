local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local frames = {
		"HelpFrameLeftInset",
		"HelpFrameMainInset",
		"HelpFrameKnowledgebase",
	--	"HelpFrameHeader",
		"HelpFrameKnowledgebaseErrorFrame",
	}
	
	local buttons = {
		"HelpFrameAccountSecurityOpenTicket",
		"HelpFrameReportLagLoot",
		"HelpFrameReportLagAuctionHouse",
		"HelpFrameReportLagMail",
		"HelpFrameReportLagMovement",
		"HelpFrameReportLagSpell",
		"HelpFrameReportLagChat",
		"HelpFrameReportAbuseOpenTicket",
		"HelpFrameOpenTicketHelpTopIssues",
		"HelpFrameOpenTicketHelpOpenTicket",
		"HelpFrameKnowledgebaseSearchButton",
		"HelpFrameKnowledgebaseNavBarHomeButton",
		"HelpFrameCharacterStuckStuck",
		"GMChatOpenLog",
		"HelpFrameTicketSubmit",
		"HelpFrameTicketCancel",
	}
	
	-- skin main frames
	for i = 1, #frames do
		E.StripTextures(_G[frames[i]],true)
		E.EuiCreateBackdrop(_G[frames[i]])
	end
	E.StripTextures(_G["HelpFrameHeader"],true)
	E.EuiCreateBackdrop(_G["HelpFrameHeader"],1)
		
	HelpFrameHeader:SetFrameLevel(HelpFrameHeader:GetFrameLevel() + 2)
	HelpFrameKnowledgebaseErrorFrame:SetFrameLevel(HelpFrameKnowledgebaseErrorFrame:GetFrameLevel() + 2)
	
	E.StripTextures(HelpFrameTicketScrollFrame)
	E.EuiCreateBackdrop(HelpFrameTicketScrollFrame)
	HelpFrameTicketScrollFrame.backdrop:SetPoint("TOPLEFT", -4, 4)
	HelpFrameTicketScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 6, -4)
	for i=1, HelpFrameTicket:GetNumChildren() do
		local child = select(i, HelpFrameTicket:GetChildren())
		if not child:GetName() then
			E.StripTextures(child)
		end
	end
	
	E.SkinScrollBar(HelpFrameKnowledgebaseScrollFrame2ScrollBar)
	
	-- skin sub buttons
	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]],true)
		E.SkinButton(_G[buttons[i]], true)
		
		if _G[buttons[i]].text then
			_G[buttons[i]].text:ClearAllPoints()
			_G[buttons[i]].text:SetPoint("CENTER")
			_G[buttons[i]].text:SetJustifyH("CENTER")				
		end
	end
	
	-- skin main buttons
	for i = 1, 6 do
		local b = _G["HelpFrameButton"..i]
		E.SkinButton(b, true)
		b.text:ClearAllPoints()
		b.text:SetPoint("CENTER")
		b.text:SetJustifyH("CENTER")
	end	
	
	-- skin table options
	for i = 1, HelpFrameKnowledgebaseScrollFrameScrollChild:GetNumChildren() do
		local b = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		E.StripTextures(b,true)
		E.SkinButton(b, true)
	end
	
	-- skin misc items
	HelpFrameKnowledgebaseSearchBox:ClearAllPoints()
	HelpFrameKnowledgebaseSearchBox:SetPoint("TOPLEFT", HelpFrameMainInset, "TOPLEFT", 13, -10)
	E.Kill(HelpFrameKnowledgebaseNavBarOverlay)
	
--	if E.IsPTRVersion() then
--		E.StripTextures(HelpFrameKnowledgebaseNavBar)
--	end
	
	E.StripTextures(HelpFrame,.7)
	E.EuiCreateBackdrop(HelpFrame,.7)
	E.SkinEditBox(HelpFrameKnowledgebaseSearchBox)
	E.SkinScrollBar(HelpFrameKnowledgebaseScrollFrameScrollBar)
	E.SkinCloseButton(HelpFrameCloseButton, HelpFrame.backdrop)	
	E.SkinCloseButton(HelpFrameKnowledgebaseErrorFrameCloseButton, HelpFrameKnowledgebaseErrorFrame.backdrop)
	
	--Hearth Stone Button
	E.StyleButton(HelpFrameCharacterStuckHearthstone)
	E.EuiSetTemplate(HelpFrameCharacterStuckHearthstone)
	HelpFrameCharacterStuckHearthstone.IconTexture:ClearAllPoints()
	HelpFrameCharacterStuckHearthstone.IconTexture:SetPoint("TOPLEFT", 2, -2)
	HelpFrameCharacterStuckHearthstone.IconTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	HelpFrameCharacterStuckHearthstone.IconTexture:SetTexCoord(.08, .92, .08, .92)
	
	local function navButtonFrameLevel(self)
		for i=1, #self.navList do
			local navButton = self.navList[i]
			local lastNav = self.navList[i-1]
			if navButton and lastNav then
				navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
			end
		end			
	end
	
	hooksecurefunc("NavBar_AddButton", function(self, buttonData)
		local navButton = self.navList[#self.navList]
		
		
		if not navButton.skinned then
			E.SkinButton(navButton, true)
			navButton.skinned = true
			
			navButton:HookScript("OnClick", function()
				navButtonFrameLevel(self)
			end)
		end
		
		navButtonFrameLevel(self)
	end)
	
	E.SkinButton(HelpFrameGM_ResponseNeedMoreHelp)
	E.SkinButton(HelpFrameGM_ResponseCancel)
	for i=1, HelpFrameGM_Response:GetNumChildren() do
		local child = select(i, HelpFrameGM_Response:GetChildren())
		if child and child:GetObjectType() == "Frame" and not child:GetName() then
			E.EuiSetTemplate(child)
		end
	end
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)