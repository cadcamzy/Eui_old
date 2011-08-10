local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.SkinCloseButton(QuestLogFrameCloseButton)
	E.StripTextures(QuestLogFrame)
	E.EuiSetTemplate(QuestLogFrame,.7)
	E.EuiCreateShadow(QuestLogFrame)
	E.StripTextures(QuestLogCount)
	E.EuiSetTemplate(QuestLogCount)
	
	E.StripTextures(EmptyQuestLogFrame)
	
	E.StripTextures(QuestLogFrameShowMapButton)
	E.SkinButton(QuestLogFrameShowMapButton)
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:SetPoint("CENTER")
	QuestLogFrameShowMapButton:SetSize(QuestLogFrameShowMapButton:GetWidth() - 30, QuestLogFrameShowMapButton:GetHeight(), - 40)
	
	local buttons = {
		"QuestLogFrameAbandonButton",
		"QuestLogFramePushQuestButton",
		"QuestLogFrameTrackButton",
		"QuestLogFrameCancelButton",
		"QuestLogFrameCompleteButton",
	}
	E.StripTextures(QuestLogFrameCompleteButton)
	for _, button in pairs(buttons) do
		E.SkinButton(_G[button])
	end
	QuestLogFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
	QuestLogFramePushQuestButton:SetPoint("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)

	for i=1, MAX_NUM_ITEMS do
		E.StripTextures(_G["QuestInfoItem"..i])
		E.StyleButton(_G["QuestInfoItem"..i])
		_G["QuestInfoItem"..i]:SetWidth(_G["QuestInfoItem"..i]:GetWidth() - 4)
		_G["QuestInfoItem"..i]:SetFrameLevel(_G["QuestInfoItem"..i]:GetFrameLevel() + 2)
		_G["QuestInfoItem"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["QuestInfoItem"..i.."IconTexture"]:SetDrawLayer("OVERLAY")
		_G["QuestInfoItem"..i.."IconTexture"]:SetPoint("TOPLEFT", 2, -2)
		_G["QuestInfoItem"..i.."IconTexture"]:SetSize(_G["QuestInfoItem"..i.."IconTexture"]:GetWidth() - 2, _G["QuestInfoItem"..i.."IconTexture"]:GetHeight() - 2)
		E.EuiSetTemplate(_G["QuestInfoItem"..i])
		_G["QuestInfoItem"..i.."Count"]:SetDrawLayer("OVERLAY")
	end
	
	E.StripTextures(QuestInfoSkillPointFrame)
	E.StyleButton(QuestInfoSkillPointFrame)
	QuestInfoSkillPointFrame:SetWidth(QuestInfoSkillPointFrame:GetWidth() - 4)
	QuestInfoSkillPointFrame:SetFrameLevel(QuestInfoSkillPointFrame:GetFrameLevel() + 2)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)
	QuestInfoSkillPointFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFrameIconTexture:SetPoint("TOPLEFT", 2, -2)
	QuestInfoSkillPointFrameIconTexture:SetSize(QuestInfoSkillPointFrameIconTexture:GetWidth() - 2, QuestInfoSkillPointFrameIconTexture:GetHeight() - 2)
	E.EuiSetTemplate(QuestInfoSkillPointFrame)
	QuestInfoSkillPointFrameCount:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFramePoints:ClearAllPoints()
	QuestInfoSkillPointFramePoints:SetPoint("BOTTOMRIGHT", QuestInfoSkillPointFrameIconTexture, "BOTTOMRIGHT")
	
	E.StripTextures(QuestInfoItemHighlight)
	E.EuiSetTemplate(QuestInfoItemHighlight)
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestInfoItemHighlight:SetSize(142, 40)
	
	hooksecurefunc("QuestInfoItem_OnClick", function(self)
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetAllPoints(self)
	end)
	
	--Everything here to make the text a readable color
	local function QuestObjectiveText()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local type, finished
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if (type ~= "spell") then
				numVisibleObjectives = numVisibleObjectives+1
				objective = _G["QuestInfoObjective"..numVisibleObjectives]
				if ( finished ) then
					objective:SetTextColor(1, 1, 0)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end			
	end
	
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material)								
		local textColor = {1, 1, 1}
		local titleTextColor = {1, 1, 0}
		
		-- headers
		QuestInfoTitleHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoDescriptionHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoObjectivesHeader:SetTextColor(unpack(titleTextColor))
		QuestInfoRewardsHeader:SetTextColor(unpack(titleTextColor))
		-- other text
		QuestInfoDescriptionText:SetTextColor(unpack(textColor))
		QuestInfoObjectivesText:SetTextColor(unpack(textColor))
		QuestInfoGroupSize:SetTextColor(unpack(textColor))
		QuestInfoRewardText:SetTextColor(unpack(textColor))
		-- reward frame text
		QuestInfoItemChooseText:SetTextColor(unpack(textColor))
		QuestInfoItemReceiveText:SetTextColor(unpack(textColor))
		QuestInfoSpellLearnText:SetTextColor(unpack(textColor))
		QuestInfoXPFrameReceiveText:SetTextColor(unpack(textColor))	
		
		QuestObjectiveText()
	end)
	
	hooksecurefunc("QuestInfo_ShowRequiredMoney", function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if ( requiredMoney > 0 ) then
			if ( requiredMoney > GetMoney() ) then
				-- Not enough money
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 1, 0)
			end
		end			
	end)		
	
	QuestLogFrame:HookScript("OnShow", function()
		QuestLogScrollFrame:SetHeight(QuestLogScrollFrame:GetHeight() - 4)
		QuestLogDetailScrollFrame:SetHeight(QuestLogScrollFrame:GetHeight() - 4)
		
		E.EuiSetTemplate(QuestLogScrollFrame)
		E.EuiCreateBackdrop(QuestLogDetailScrollFrame)
	end)
	
	--Quest Frame
	E.StripTextures(QuestFrame,true)
	E.StripTextures(QuestFrameDetailPanel,true)
	E.StripTextures(QuestDetailScrollFrame,true)
	E.StripTextures(QuestDetailScrollChildFrame,true)
	E.StripTextures(QuestRewardScrollFrame,true)
	E.StripTextures(QuestRewardScrollChildFrame,true)
	E.StripTextures(QuestFrameProgressPanel,true)
	E.StripTextures(QuestFrameRewardPanel,true)
	E.EuiCreateBackdrop(QuestFrame,.7)
	QuestFrame.backdrop:SetPoint("TOPLEFT", 6, -8)
	QuestFrame.backdrop:SetPoint("BOTTOMRIGHT", -20, 65)
	E.EuiCreateShadow(QuestFrame.backdrop)
	E.SkinButton(QuestFrameAcceptButton, true)
	E.SkinButton(QuestFrameDeclineButton, true)
	E.SkinButton(QuestFrameCompleteButton, true)
	E.SkinButton(QuestFrameGoodbyeButton, true)
	E.SkinButton(QuestFrameCompleteQuestButton, true)
	E.SkinCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)
	
	for i=1, 6 do
		local button = _G["QuestProgressItem"..i]
		local texture = _G["QuestProgressItem"..i.."IconTexture"]
		E.StripTextures(button)
		E.StyleButton(button)
		button:SetWidth(_G["QuestProgressItem"..i]:GetWidth() - 4)
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		texture:SetTexCoord(.08, .92, .08, .92)
		texture:SetDrawLayer("OVERLAY")
		texture:SetPoint("TOPLEFT", 2, -2)
		texture:SetSize(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G["QuestProgressItem"..i.."Count"]:SetDrawLayer("OVERLAY")
		E.EuiSetTemplate(button)
	end
	
	hooksecurefunc("QuestFrameProgressItems_Update", function()
		QuestProgressTitleText:SetTextColor(1, 1, 0)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 0)
		QuestProgressRequiredMoneyText:SetTextColor(1, 1, 0)
	end)
	
	E.StripTextures(QuestNPCModel)
	E.EuiCreateBackdrop(QuestNPCModel,.7)
	QuestNPCModel:SetPoint("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)
	E.StripTextures(QuestNPCModelTextFrame)
	E.EuiCreateBackdrop(QuestNPCModelTextFrame)
	QuestNPCModelTextFrame.backdrop:SetPoint("TOPLEFT", QuestNPCModel.backdrop, "BOTTOMLEFT", 0, -2)
	E.StripTextures(QuestLogDetailFrame)
	E.EuiSetTemplate(QuestLogDetailFrame,.7)
	E.StripTextures(QuestLogDetailScrollFrame)
	E.SkinCloseButton(QuestLogDetailFrameCloseButton)
	
	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
		QuestNPCModel:ClearAllPoints();
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x + 18, y);			
	end)	
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)