local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(PetitionFrame,true)
	E.EuiSetTemplate(PetitionFrame,.7)
	E.EuiCreateShadow(PetitionFrame)
	
	E.SkinButton(PetitionFrameRequestButton)
	E.SkinButton(PetitionFrameRenameButton)
	E.SkinButton(PetitionFrameCancelButton)
	E.SkinCloseButton(PetitionFrameCloseButton)
	
	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)
	
	for i=1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(1, 1, 1)
	end
	
	PetitionFrameInstructions:SetTextColor(1, 1, 1)
	
	PetitionFrameRenameButton:SetPoint("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:SetPoint("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
	PetitionFrame:SetHeight(PetitionFrame:GetHeight() - 80)
	
	PetitionFrameCancelButton:SetPoint("BOTTOMRIGHT", PetitionFrame, "BOTTOMRIGHT", -40, 20)
	PetitionFrameRequestButton:SetPoint("BOTTOMLEFT", PetitionFrame, "BOTTOMLEFT", 22, 20)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)