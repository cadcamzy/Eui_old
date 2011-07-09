local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(TaxiFrame)
	E.EuiCreateBackdrop(TaxiFrame,.7)
	E.EuiCreateBackdrop(TaxiRouteMap)
	TaxiRouteMap.backdrop:SetAllPoints()
	E.SkinCloseButton(TaxiFrameCloseButton)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)