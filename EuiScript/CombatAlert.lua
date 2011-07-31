local E, C, L = unpack(EUI) -- Import Functions/Constants, Config, Locales
--Author: fgprodigal
--Modify: ljxx.net
E.imsg = CreateFrame("Frame", "ComatAlert")
E.imsg:SetSize(418, 72)
E.imsg:SetPoint("TOP", 0, -190)
E.imsg:Hide()
E.imsg.bg = E.imsg:CreateTexture(nil, 'BACKGROUND')
E.imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
E.imsg.bg:SetPoint('BOTTOM')
E.imsg.bg:SetSize(326, 103)
E.imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
E.imsg.bg:SetVertexColor(1, 1, 1, 0.6)

E.imsg.lineTop = E.imsg:CreateTexture(nil, 'BACKGROUND')
E.imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
E.imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
E.imsg.lineTop:SetPoint("TOP")
E.imsg.lineTop:SetSize(418, 7)
E.imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

E.imsg.lineBottom = E.imsg:CreateTexture(nil, 'BACKGROUND')
E.imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
E.imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
E.imsg.lineBottom:SetPoint("BOTTOM")
E.imsg.lineBottom:SetSize(418, 7)
E.imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

E.imsg.text = E.imsg:CreateFontString(nil, 'ARTWORK', 'GameFont_Gigantic')
E.imsg.text:SetPoint("BOTTOM", 0, 12)
E.imsg.text:SetTextColor(1, 0.82, 0)
E.imsg.text:SetJustifyH("CENTER")

local timer = 0

E.imsg:SetScript("OnShow", function(self)
	timer = 0
	self:SetScript("OnUpdate", function(self, elasped)
		timer = timer + elasped
		if (timer<0.5) then self:SetAlpha(timer*2) end
		if (timer>2.5 and timer<3) then self:SetAlpha(1-(timer-1)*2) end
		if (timer>=4.5 ) then self:Hide() end
	end)
end)