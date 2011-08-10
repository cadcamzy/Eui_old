local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local buttons = {
		"BarberShopFrameOkayButton",
		"BarberShopFrameCancelButton",
		"BarberShopFrameResetButton",
	}
	BarberShopFrameOkayButton:SetPoint("RIGHT", BarberShopFrameSelector4, "BOTTOM", 2, -50)
	
	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end
	

	for i = 1, 4 do
		local f = _G["BarberShopFrameSelector"..i]
		local f2 = _G["BarberShopFrameSelector"..i-1]
		E.SkinNextPrevButton(_G["BarberShopFrameSelector"..i.."Prev"])
		E.SkinNextPrevButton(_G["BarberShopFrameSelector"..i.."Next"])
		
		if i ~= 1 then
			f:ClearAllPoints()
			f:SetPoint("TOP", f2, "BOTTOM", 0, -3)			
		end
		
		if f then
			E.StripTextures(f)
		end
	end
	
	BarberShopFrameSelector1:ClearAllPoints()
	BarberShopFrameSelector1:SetPoint("TOP", 0, -12)
	
	BarberShopFrameResetButton:ClearAllPoints()
	BarberShopFrameResetButton:SetPoint("BOTTOM", 0, 12)

	E.StripTextures(BarberShopFrame)
	E.EuiSetTemplate(BarberShopFrame, .1)
	BarberShopFrame:SetSize(BarberShopFrame:GetWidth() - 30, BarberShopFrame:GetHeight() - 56)
	
	E.StripTextures(BarberShopFrameMoneyFrame)
	E.EuiCreateBackdrop(BarberShopFrameMoneyFrame)
	E.Kill(BarberShopFrameBackground)
	
	E.Kill(BarberShopBannerFrameBGTexture)
	E.Kill(BarberShopBannerFrame)
	
	E.StripTextures(BarberShopAltFormFrameBorder)
	BarberShopAltFormFrame:SetPoint( "BOTTOM", BarberShopFrame, "TOP", 0, 5 )
	E.StripTextures(BarberShopAltFormFrame)
	E.EuiCreateBackdrop(BarberShopAltFormFrame,.7)
end

E.SkinFuncs["Blizzard_BarbershopUI"] = LoadSkin