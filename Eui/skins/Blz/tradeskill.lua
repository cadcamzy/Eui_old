Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(TradeSkillFrame,true)
	E.StripTextures(TradeSkillListScrollFrame)
	E.StripTextures(TradeSkillDetailScrollFrame)
	E.StripTextures(TradeSkillFrameInset)
	E.StripTextures(TradeSkillExpandButtonFrame)
	E.StripTextures(TradeSkillDetailScrollChildFrame)
	
	E.EuiSetTemplate(TradeSkillFrame,.7)
	E.EuiCreateShadow(TradeSkillFrame)
	TradeSkillFrame:SetHeight(TradeSkillFrame:GetHeight() + 12)
	E.StripTextures(TradeSkillRankFrame)
	E.EuiCreateBackdrop(TradeSkillRankFrame)
	TradeSkillRankFrame:SetStatusBarTexture(E.normTex)
	
	E.SkinButton(TradeSkillCreateButton, true)
	E.SkinButton(TradeSkillCancelButton, true)
	E.SkinButton(TradeSkillFilterButton, true)
	E.SkinButton(TradeSkillCreateAllButton, true)
	E.SkinButton(TradeSkillViewGuildCraftersButton, true)
	
	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75)
	TradeSkillLinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)
	E.Kill(TradeSkillLinkButton:GetHighlightTexture())
	E.EuiCreateBackdrop(TradeSkillLinkButton)
	TradeSkillLinkButton:SetSize(17, 14)
	TradeSkillLinkButton:SetPoint("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
	E.SkinEditBox(TradeSkillFrameSearchBox)
	E.SkinEditBox(TradeSkillInputBox)
	E.SkinNextPrevButton(TradeSkillDecrementButton)
	E.SkinNextPrevButton(TradeSkillIncrementButton)
	TradeSkillIncrementButton:SetPoint("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
	
	E.SkinCloseButton(TradeSkillFrameCloseButton)
	
	local once = false
	hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
		E.StyleButton(TradeSkillSkillIcon)
		if TradeSkillSkillIcon:GetNormalTexture() then
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			TradeSkillSkillIcon:GetNormalTexture():ClearAllPoints()
			TradeSkillSkillIcon:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			TradeSkillSkillIcon:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		end
		E.EuiSetTemplate(TradeSkillSkillIcon)

		for i=1, MAX_TRADE_SKILL_REAGENTS do
			local button = _G["TradeSkillReagent"..i]
			local icon = _G["TradeSkillReagent"..i.."IconTexture"]
			local count = _G["TradeSkillReagent"..i.."Count"]
			
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:SetDrawLayer("OVERLAY")
			if not icon.backdrop then
				icon.backdrop = CreateFrame("Frame", nil, button)
				icon.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)
				E.EuiSetTemplate(icon.backdrop)
				icon.backdrop:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
				icon.backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
			end
			
			icon:SetParent(icon.backdrop)
			count:SetParent(icon.backdrop)
			count:SetDrawLayer("OVERLAY")
			
			if i > 2 and once == false then
				local point, anchoredto, point2, x, y = button:GetPoint()
				button:ClearAllPoints()
				button:SetPoint(point, anchoredto, point2, x, y - 3)
				once = true
			end
			
			E.Kill(_G["TradeSkillReagent"..i.."NameFrame"])
		end
	end)
	
	
	--Guild Crafters
	E.StripTextures(TradeSkillGuildFrame)
	E.EuiSetTemplate(TradeSkillGuildFrame,.7)
	TradeSkillGuildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
	E.StripTextures(TradeSkillGuildFrameContainer)
	E.EuiSetTemplate(TradeSkillGuildFrameContainer)
	E.SkinCloseButton(TradeSkillGuildFrameCloseButton)
end

E.SkinFuncs["Blizzard_TradeSkillUI"] = LoadSkin