local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(ItemSocketingFrame)
	E.EuiSetTemplate(ItemSocketingFrame,.7)
	E.StripTextures(ItemSocketingScrollFrame)
	E.EuiCreateBackdrop(ItemSocketingScrollFrame,.7)

	for i = 1, MAX_NUM_SOCKETS  do
		local button = _G["ItemSocketingSocket"..i]
		local button_bracket = _G["ItemSocketingSocket"..i.."BracketFrame"]
		local button_bg = _G["ItemSocketingSocket"..i.."Background"]
		local button_icon = _G["ItemSocketingSocket"..i.."IconTexture"]
		E.StripTextures(button)
		E.StyleButton(button,false)
		E.EuiSetTemplate(button)
		E.Kill(button_bracket)
		E.Kill(button_bg)
		button_icon:SetTexCoord(.08, .92, .08, .92)
		button_icon:ClearAllPoints()
		button_icon:SetPoint("TOPLEFT", 2, -2)
		button_icon:SetPoint("BOTTOMRIGHT", -2, 2)
		ItemSocketingFrame:HookScript("OnUpdate", function(self)
			gemColor = GetSocketTypes(i)
			local color = GEM_TYPE_INFO[gemColor]
			button:SetBackdropColor(color.r, color.g, color.b, 0.15)
			button:SetBackdropBorderColor(color.r, color.g, color.b)
		end)
	end
	
	E.Kill(ItemSocketingFramePortrait)
	ItemSocketingSocketButton:ClearAllPoints()
	ItemSocketingSocketButton:SetPoint("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -5, 5)
	E.SkinButton(ItemSocketingSocketButton)
	E.SkinCloseButton(ItemSocketingCloseButton)
end

E.SkinFuncs["Blizzard_ItemSocketingUI"] = LoadSkin