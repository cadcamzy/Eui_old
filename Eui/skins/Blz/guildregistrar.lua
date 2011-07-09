local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(GuildRegistrarFrame,true)
	E.EuiSetTemplate(GuildRegistrarFrame,.7)
	E.StripTextures(GuildRegistrarGreetingFrame)
	E.SkinButton(GuildRegistrarFrameGoodbyeButton)
	E.SkinButton(GuildRegistrarFrameCancelButton)
	E.SkinButton(GuildRegistrarFramePurchaseButton)
	E.SkinCloseButton(GuildRegistrarFrameCloseButton)
	E.SkinEditBox(GuildRegistrarFrameEditBox)
	for i=1, GuildRegistrarFrameEditBox:GetNumRegions() do
		local region = select(i, GuildRegistrarFrameEditBox:GetRegions())
		if region:GetObjectType() == "Texture" then
			if region:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Left" or region:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Right" then
				E.Kill(region)
			end
		end
	end
	
	GuildRegistrarFrameEditBox:SetHeight(20)
	
	for i=1, 2 do
		_G["GuildRegistrarButton"..i]:GetFontString():SetTextColor(1, 1, 1)
	end
	
	GuildRegistrarPurchaseText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 0)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)