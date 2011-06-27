local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(DressUpFrame,true)
	E.EuiCreateBackdrop(DressUpFrame,.7)
	E.EuiCreateShadow(DressUpFrame.backdrop)
	DressUpFrame.backdrop:SetPoint("TOPLEFT", 6, 0)
	DressUpFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 70)
	
	E.SkinButton(DressUpFrameResetButton)
	E.SkinButton(DressUpFrameCancelButton)
	E.SkinCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)
	E.SkinRotateButton(DressUpModelRotateLeftButton)
	E.SkinRotateButton(DressUpModelRotateRightButton)
	DressUpModelRotateRightButton:SetPoint("TOPLEFT", DressUpModelRotateLeftButton, "TOPRIGHT", 2, 0)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)