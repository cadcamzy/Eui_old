local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(TaxiFrame)
	E.EuiCreateBackdrop(TaxiFrame,.7)
	E.EuiCreateBackdrop(TaxiRouteMap)
	TaxiRouteMap.backdrop:SetAllPoints()
	E.SkinCloseButton(TaxiFrameCloseButton)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)