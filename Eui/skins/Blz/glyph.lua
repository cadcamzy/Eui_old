local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	--GLYPHS TAB
	E.EuiCreateBackdrop(GlyphFrameSparkleFrame)
	GlyphFrameSparkleFrame.backdrop:SetPoint( "TOPLEFT", GlyphFrameSparkleFrame, "TOPLEFT", 3, -3 )
	GlyphFrameSparkleFrame.backdrop:SetPoint( "BOTTOMRIGHT", GlyphFrameSparkleFrame, "BOTTOMRIGHT", -3, 3 )
	E.SkinEditBox(GlyphFrameSearchBox)
	E.SkinDropDownBox(GlyphFrameFilterDropDown, 212)
	
	GlyphFrameBackground:SetParent(GlyphFrameSparkleFrame)
	GlyphFrameBackground:SetPoint("TOPLEFT", 4, -4)
	GlyphFrameBackground:SetPoint("BOTTOMRIGHT", -4, 4)
	
	for i=1, 9 do
		_G["GlyphFrameGlyph"..i]:SetFrameLevel(_G["GlyphFrameGlyph"..i]:GetFrameLevel() + 5)
	end
	
	for i=1, 3 do
		E.StripTextures(_G["GlyphFrameHeader"..i])
	end

	local function Glyphs(self, first, i)
		local button = _G["GlyphFrameScrollFrameButton"..i]
		local icon = _G["GlyphFrameScrollFrameButton"..i.."Icon"]

		if first then
			E.StripTextures(button)
		end

		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			E.SkinButton(button)
		end
	end

	for i=1, 10 do
		Glyphs(nil, true, i)
	end

	GlyphFrameClearInfoFrameIcon:SetTexCoord(.08, .92, .08, .92)
	GlyphFrameClearInfoFrameIcon:ClearAllPoints()
	GlyphFrameClearInfoFrameIcon:SetPoint("TOPLEFT", 2, -2)
	GlyphFrameClearInfoFrameIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	
	E.EuiCreateBackdrop(GlyphFrameClearInfoFrame)
	GlyphFrameClearInfoFrame.backdrop:SetAllPoints()
	E.StyleButton(GlyphFrameClearInfoFrame)
	GlyphFrameClearInfoFrame:SetSize(25, 25)
	
	E.SkinScrollBar(GlyphFrameScrollFrameScrollBar)

	local StripAllTextures = {
		"GlyphFrameScrollFrame",
		"GlyphFrameSideInset",
		"GlyphFrameScrollFrameScrollChild",
	}

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end
end

E.SkinFuncs["Blizzard_GlyphUI"] = LoadSkin