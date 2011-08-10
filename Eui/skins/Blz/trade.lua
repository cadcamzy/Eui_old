local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.StripTextures(TradeFrame,true)
	E.EuiCreateBackdrop(TradeFrame,.7)
	TradeFrame.backdrop:SetPoint("TOPLEFT", 10, -4)
	TradeFrame.backdrop:SetPoint("BOTTOMRIGHT", -16, 35)
	E.SkinButton(TradeFrameTradeButton, true)
	E.SkinButton(TradeFrameCancelButton, true)
	E.SkinCloseButton(TradeFrameCloseButton, TradeFrame.backdrop)
	
	E.SkinEditBox(TradePlayerInputMoneyFrameGold)
	E.SkinEditBox(TradePlayerInputMoneyFrameSilver)
	E.SkinEditBox(TradePlayerInputMoneyFrameCopper)
	
	for i=1, 7 do
		local player = _G["TradePlayerItem"..i]
		local recipient = _G["TradeRecipientItem"..i]
		local player_button = _G["TradePlayerItem"..i.."ItemButton"]
		local recipient_button = _G["TradeRecipientItem"..i.."ItemButton"]
		local player_button_icon = _G["TradePlayerItem"..i.."ItemButtonIconTexture"]
		local recipient_button_icon = _G["TradeRecipientItem"..i.."ItemButtonIconTexture"]
		
		if player_button and recipient_button then
			E.StripTextures(player)
			E.StripTextures(recipient)
			E.StripTextures(player_button)
			E.StripTextures(recipient_button)
			
			player_button_icon:ClearAllPoints()
			player_button_icon:SetPoint("TOPLEFT", player_button, "TOPLEFT", 2, -2)
			player_button_icon:SetPoint("BOTTOMRIGHT", player_button, "BOTTOMRIGHT", -2, 2)
			player_button_icon:SetTexCoord(.08, .92, .08, .92)
			E.EuiSetTemplate(player_button)
			E.StyleButton(player_button)
			player_button.bg = CreateFrame("Frame", nil, player_button)
			E.EuiSetTemplate(player_button.bg)
			player_button.bg:SetPoint("TOPLEFT", player_button, "TOPRIGHT", 4, 0)
			player_button.bg:SetPoint("BOTTOMRIGHT", _G["TradePlayerItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			player_button.bg:SetFrameLevel(player_button:GetFrameLevel() - 3)

			recipient_button_icon:ClearAllPoints()
			recipient_button_icon:SetPoint("TOPLEFT", recipient_button, "TOPLEFT", 2, -2)
			recipient_button_icon:SetPoint("BOTTOMRIGHT", recipient_button, "BOTTOMRIGHT", -2, 2)
			recipient_button_icon:SetTexCoord(.08, .92, .08, .92)
			E.EuiSetTemplate(recipient_button)
			E.StyleButton(recipient_button)
			recipient_button.bg = CreateFrame("Frame", nil, recipient_button)
			E.EuiSetTemplate(recipient_button.bg)
			recipient_button.bg:SetPoint("TOPLEFT", recipient_button, "TOPRIGHT", 4, 0)
			recipient_button.bg:SetPoint("BOTTOMRIGHT", _G["TradeRecipientItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			recipient_button.bg:SetFrameLevel(recipient_button:GetFrameLevel() - 3)					
			
		end
	end
	
	TradeHighlightPlayerTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayer:SetFrameStrata("HIGH")
	TradeHighlightPlayer:SetPoint("TOPLEFT", TradeFrame, "TOPLEFT", 23, -100)
	
	TradeHighlightPlayerEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchant:SetFrameStrata("HIGH")
	
	TradeHighlightRecipientTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipient:SetFrameStrata("HIGH")
	TradeHighlightRecipient:SetPoint("TOPLEFT", TradeFrame, "TOPLEFT", 192, -100)
	
	TradeHighlightRecipientEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchant:SetFrameStrata("HIGH")		
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)