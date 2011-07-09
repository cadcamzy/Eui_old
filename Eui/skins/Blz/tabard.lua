local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(TabardFrame,true)
	E.EuiSetTemplate(TabardFrame,.7)
	E.EuiCreateBackdrop(TabardModel)
	E.SkinButton(TabardFrameCancelButton)
	E.SkinButton(TabardFrameAcceptButton)
	E.SkinCloseButton(TabardFrameCloseButton)
	E.SkinRotateButton(TabardCharacterModelRotateLeftButton)
	E.SkinRotateButton(TabardCharacterModelRotateRightButton)
	E.StripTextures(TabardFrameCostFrame)
	E.StripTextures(TabardFrameCustomizationFrame)
	
	for i=1, 5 do
		local custom = "TabardFrameCustomization"..i
		E.StripTextures(_G[custom])
		E.SkinNextPrevButton(_G[custom.."LeftButton"])
		E.SkinNextPrevButton(_G[custom.."RightButton"])
		
		
		if i > 1 then
			_G[custom]:ClearAllPoints()
			_G[custom]:SetPoint("TOP", _G["TabardFrameCustomization"..i-1], "BOTTOM", 0, -6)
		else
			local point, anchor, point2, x, y = _G[custom]:GetPoint()
			_G[custom]:SetPoint(point, anchor, point2, x, y+4)
		end
	end
	
	TabardCharacterModelRotateLeftButton:SetPoint("BOTTOMLEFT", 4, 4)
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
	TabardCharacterModelRotateLeftButton.SetPoint = E.dummy
	TabardCharacterModelRotateRightButton.SetPoint = E.dummy
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)