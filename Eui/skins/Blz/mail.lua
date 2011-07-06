Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(MailFrame,true)
	E.EuiCreateBackdrop(MailFrame,.7)
	MailFrame.backdrop:SetPoint("TOPLEFT", 4, 0)
	MailFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, 74)
	E.EuiCreateShadow(MailFrame.backdrop)
	MailFrame:SetWidth(360)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local bg = _G["MailItem"..i]
		E.StripTextures(bg)
		E.EuiCreateBackdrop(bg)
		bg.backdrop:SetPoint("TOPLEFT", 2, 1)
		bg.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
		
		local b = _G["MailItem"..i.."Button"]
		E.StripTextures(b)
		E.EuiSetTemplate(b)
		E.StyleButton(b)

		local t = _G["MailItem"..i.."ButtonIcon"]
		t:SetTexCoord(.08, .92, .08, .92)
		t:ClearAllPoints()
		t:SetPoint("TOPLEFT", 2, -2)
		t:SetPoint("BOTTOMRIGHT", -2, 2)
	end
	
	E.SkinCloseButton(InboxCloseButton)
	E.SkinNextPrevButton(InboxPrevPageButton)
	E.SkinNextPrevButton(InboxNextPageButton)

	E.StripTextures(MailFrameTab1)
	E.StripTextures(MailFrameTab2)
	E.SkinTab(MailFrameTab1)
	E.SkinTab(MailFrameTab2)

	-- send mail
	E.StripTextures(SendMailScrollFrame,true)
	E.EuiSetTemplate(SendMailScrollFrame)

	E.SkinScrollBar(SendMailScrollFrameScrollBar)
	
	E.SkinEditBox(SendMailNameEditBox)
	E.SkinEditBox(SendMailSubjectEditBox)
	E.SkinEditBox(SendMailMoneyGold)
	E.SkinEditBox(SendMailMoneySilver)
	E.SkinEditBox(SendMailMoneyCopper)
	
	SendMailNameEditBox.backdrop:SetPoint("BOTTOMRIGHT", 2, 0)
	SendMailSubjectEditBox.backdrop:SetPoint("BOTTOMRIGHT", 2, 0)
	E.StripTextures(SendMailFrame)
	
	local function MailFrameSkin()
		for i = 1, ATTACHMENTS_MAX_SEND do				
			local b = _G["SendMailAttachment"..i]
			if not b.skinned then
				E.StripTextures(b)
				E.EuiSetTemplate(b)
				E.StyleButton(b)
				b.skinned = true
			end
			local t = b:GetNormalTexture()
			if t then
				t:SetTexCoord(.08, .92, .08, .92)
				t:ClearAllPoints()
				t:SetPoint("TOPLEFT", 2, -2)
				t:SetPoint("BOTTOMRIGHT", -2, 2)
			end
		end
	end
	hooksecurefunc("SendMailFrame_Update", MailFrameSkin)
	
	E.SkinButton(SendMailMailButton)
	E.SkinButton(SendMailCancelButton)
	
	-- open mail (cod)
	E.StripTextures(OpenMailFrame,true)
	E.EuiCreateBackdrop(OpenMailFrame,.7)
	OpenMailFrame.backdrop:SetPoint("TOPLEFT", 4, 0)
	OpenMailFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, 74)
	E.EuiCreateShadow(OpenMailFrame.backdrop)
	OpenMailFrame:SetWidth(360)
	
	E.SkinCloseButton(OpenMailCloseButton)
	E.SkinButton(OpenMailReportSpamButton)
	E.SkinButton(OpenMailReplyButton)
	E.SkinButton(OpenMailDeleteButton)
	E.SkinButton(OpenMailCancelButton)
	
	E.StripTextures(OpenMailScrollFrame,true)
	E.EuiSetTemplate(OpenMailScrollFrame)

	E.SkinScrollBar(OpenMailScrollFrameScrollBar)
	
	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	E.Kill(OpenMailArithmeticLine)
	
	E.StripTextures(OpenMailLetterButton)
	E.EuiSetTemplate(OpenMailLetterButton)
	E.StyleButton(OpenMailLetterButton)
	OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)						
	OpenMailLetterButtonIconTexture:ClearAllPoints()
	OpenMailLetterButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	OpenMailLetterButtonIconTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	
	E.StripTextures(OpenMailMoneyButton)
	E.EuiSetTemplate(OpenMailMoneyButton)
	E.StyleButton(OpenMailMoneyButton)
	OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)						
	OpenMailMoneyButtonIconTexture:ClearAllPoints()
	OpenMailMoneyButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	OpenMailMoneyButtonIconTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	
	for i = 1, ATTACHMENTS_MAX_SEND do				
		local b = _G["OpenMailAttachmentButton"..i]
		E.StripTextures(b)
		E.EuiSetTemplate(b)
		E.StyleButton(b)
		
		local t = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		if t then
			t:SetTexCoord(.08, .92, .08, .92)
			t:ClearAllPoints()
			t:SetPoint("TOPLEFT", 2, -2)
			t:SetPoint("BOTTOMRIGHT", -2, 2)
		end				
	end
	
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)
	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -2, 0)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)