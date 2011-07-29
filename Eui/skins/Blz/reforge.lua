local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(ReforgingFrame)
	E.EuiSetTemplate(ReforgingFrame,.7)
	
	E.StripTextures(ReforgingFrameTopInset)
	E.StripTextures(ReforgingFrameInset)
	E.StripTextures(ReforgingFrameBottomInset)
	
	E.SkinButton(ReforgingFrameRestoreButton, true)
	E.SkinButton(ReforgingFrameReforgeButton, true)
	
	E.SkinDropDownBox(ReforgingFrameFilterOldStat, 180)
	E.SkinDropDownBox(ReforgingFrameFilterNewStat, 180)
	
	E.StripTextures(ReforgingFrameItemButton)
	E.EuiSetTemplate(ReforgingFrameItemButton)
	E.StyleButton(ReforgingFrameItemButton)
	ReforgingFrameItemButtonIconTexture:ClearAllPoints()
	ReforgingFrameItemButtonIconTexture:SetPoint("TOPLEFT", 2, -2)
	ReforgingFrameItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	
	hooksecurefunc("ReforgingFrame_Update", function(self)
		local currentReforge, icon, name, quality, bound, cost = GetReforgeItemInfo()
		if icon then
			ReforgingFrameItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		else
			ReforgingFrameItemButtonIconTexture:SetTexture(nil)
		end
	end)
	
	E.SkinCloseButton(ReforgingFrameCloseButton)
end

E.SkinFuncs["Blizzard_ReforgingUI"] = LoadSkin