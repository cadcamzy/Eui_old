local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local frames = {
		"AchievementFrame",
		"AchievementFrameCategories",
		"AchievementFrameSummary",
		"AchievementFrameHeader",
		"AchievementFrameSummaryCategoriesHeader",
		"AchievementFrameSummaryAchievementsHeader",
		"AchievementFrameStatsBG",
		"AchievementFrameAchievements",
		"AchievementFrameComparison",
		"AchievementFrameComparisonHeader",
		"AchievementFrameComparisonSummaryPlayer",
		"AchievementFrameComparisonSummaryFriend",
	}
	
	for _, frame in pairs(frames) do
		E.StripTextures(_G[frame],true)
	end
	
	local noname_frames = {
		"AchievementFrameStats",
		"AchievementFrameSummary",
		"AchievementFrameAchievements",
		"AchievementFrameComparison"
	}
	
	for _, frame in pairs(noname_frames) do
		for i=1, _G[frame]:GetNumChildren() do
			local child = select(i, _G[frame]:GetChildren())
			if child and not child:GetName() then
				child:SetBackdrop(nil)
			end
		end
	end
	
	E.EuiCreateBackdrop(AchievementFrame,.7)
	AchievementFrame.backdrop:SetPoint("TOPLEFT", 0, 6)
	AchievementFrame.backdrop:SetPoint("BOTTOMRIGHT")
	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:SetPoint("TOPLEFT", AchievementFrame.backdrop, "TOPLEFT", -30, -8)
	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPoint("LEFT", AchievementFrameHeaderTitle, "RIGHT", 2, 0)
	
	--Backdrops
	E.EuiCreateBackdrop(AchievementFrameCategoriesContainer)
	AchievementFrameCategoriesContainer.backdrop:SetPoint("TOPLEFT", 0, 4)
	AchievementFrameCategoriesContainer.backdrop:SetPoint("BOTTOMRIGHT", -2, -3)
	E.EuiCreateBackdrop(AchievementFrameAchievementsContainer)
	AchievementFrameAchievementsContainer.backdrop:SetPoint("TOPLEFT", 0, 2)
	AchievementFrameAchievementsContainer.backdrop:SetPoint("BOTTOMRIGHT", -3, -3)
	
	E.SkinCloseButton(AchievementFrameCloseButton, AchievementFrame.backdrop)
	E.SkinDropDownBox(AchievementFrameFilterDropDown)
	AchievementFrameFilterDropDown:SetPoint("TOPRIGHT", AchievementFrame, "TOPRIGHT", -44, 5)
	
	-- ScrollBars
	E.SkinScrollBar(AchievementFrameCategoriesContainerScrollBar)
	E.SkinScrollBar(AchievementFrameAchievementsContainerScrollBar)
	E.SkinScrollBar(AchievementFrameStatsContainerScrollBar)
	E.SkinScrollBar(AchievementFrameComparisonContainerScrollBar)
	E.SkinScrollBar(AchievementFrameComparisonStatsContainerScrollBar)
	
	--Tabs
	for i = 1, 3 do
		E.SkinTab(_G["AchievementFrameTab"..i])
		_G["AchievementFrameTab"..i]:SetFrameLevel(_G["AchievementFrameTab"..i]:GetFrameLevel() + 2)
	end
	
	local function SkinStatusBar(bar)
		E.StripTextures(bar)
		bar:SetStatusBarTexture(E.normTex)
		bar:SetStatusBarColor(4/255, 179/255, 30/255)
		E.EuiCreateBackdrop(bar)
		
		if _G[bar:GetName().."Title"] then
			_G[bar:GetName().."Title"]:SetPoint("LEFT", 4, 0)
		end

		if _G[bar:GetName().."Label"] then
			_G[bar:GetName().."Label"]:SetPoint("LEFT", 4, 0)
		end
		
		if _G[bar:GetName().."Text"] then
			_G[bar:GetName().."Text"]:SetPoint("RIGHT", -4, 0)
		end
	end

	SkinStatusBar(AchievementFrameSummaryCategoriesStatusBar)
	SkinStatusBar(AchievementFrameComparisonSummaryPlayerStatusBar)
	SkinStatusBar(AchievementFrameComparisonSummaryFriendStatusBar)
	AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	AchievementFrameComparisonSummaryFriendStatusBar.text:SetPoint("CENTER")
	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 45, -20)
	
	for i=1, 8 do
		local frame = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local button = _G["AchievementFrameSummaryCategoriesCategory"..i.."Button"]
		local highlight = _G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]
		SkinStatusBar(frame)
		E.StripTextures(button)
		E.StripTextures(highlight)
		
		_G[highlight:GetName().."Middle"]:SetTexture(1, 1, 1, 0.3)
		_G[highlight:GetName().."Middle"]:SetAllPoints(frame)
	end
	
	AchievementFrame:HookScript("OnShow", function()
		for i=1, 20 do
			local frame = _G["AchievementFrameCategoriesContainerButton"..i]
			local lastframe = _G["AchievementFrameCategoriesContainerButton"..i-1]
			
			E.StripTextures(frame)
			E.StyleButton(frame)				
		end	
	end)
	
	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i=1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local frame = _G["AchievementFrameSummaryAchievement"..i]
			E.Kill(_G["AchievementFrameSummaryAchievement"..i.."Highlight"])
			E.StripTextures(frame)
			
			
			_G["AchievementFrameSummaryAchievement"..i.."Description"]:SetTextColor(0.6, 0.6, 0.6)
			
			if not frame.backdrop then
				E.EuiCreateBackdrop(frame)
				frame.backdrop:SetPoint("TOPLEFT", 2, -2)
				frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

				E.Kill(_G["AchievementFrameSummaryAchievement"..i.."IconBling"])
				E.Kill(_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"])
				E.EuiSetTemplate(_G["AchievementFrameSummaryAchievement"..i.."Icon"])
				_G["AchievementFrameSummaryAchievement"..i.."Icon"]:SetHeight(_G["AchievementFrameSummaryAchievement"..i.."Icon"]:GetHeight() - 14)
				_G["AchievementFrameSummaryAchievement"..i.."Icon"]:SetWidth(_G["AchievementFrameSummaryAchievement"..i.."Icon"]:GetWidth() - 14)
				_G["AchievementFrameSummaryAchievement"..i.."Icon"]:ClearAllPoints()
				_G["AchievementFrameSummaryAchievement"..i.."Icon"]:SetPoint("LEFT", 6, 0)
				_G["AchievementFrameSummaryAchievement"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				_G["AchievementFrameSummaryAchievement"..i.."IconTexture"]:ClearAllPoints()
				_G["AchievementFrameSummaryAchievement"..i.."IconTexture"]:SetPoint("TOPLEFT", 2, -2)
				_G["AchievementFrameSummaryAchievement"..i.."IconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)
			end
		end				
	end)
	
	for i=1, 7 do
		local frame = _G["AchievementFrameAchievementsContainerButton"..i]
		E.Kill(_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"])
		E.StripTextures(frame, true)
		frame.SetBackdropBorderColor = E.dummy

		--Initiate fucked up method of creating a backdrop
		frame.bg1 = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg1:SetDrawLayer("BACKGROUND", 4)
		frame.bg1:SetTexture(E.normTex) --Default TukUI users this is normTex, glossTex doesn't exist
		frame.bg1:SetVertexColor(0.1, 0.1, 0.1)
		frame.bg1:SetPoint("TOPLEFT", E.mult*4, -E.mult*4)
		frame.bg1:SetPoint("BOTTOMRIGHT", -E.mult*4, E.mult*4)				
		
		frame.bg2 = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg2:SetDrawLayer("BACKGROUND", 3)
		frame.bg2:SetTexture(0,0,0)
		frame.bg2:SetPoint("TOPLEFT", E.mult*3, -E.mult*3)
		frame.bg2:SetPoint("BOTTOMRIGHT", -E.mult*3, E.mult*3)
		
		frame.bg3 = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg3:SetDrawLayer("BACKGROUND", 2)
		frame.bg3:SetTexture(0.31, 0.45, 0.63)
		frame.bg3:SetPoint("TOPLEFT", E.mult*2, -E.mult*2)
		frame.bg3:SetPoint("BOTTOMRIGHT", -E.mult*2, E.mult*2)			

		frame.bg4 = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg4:SetDrawLayer("BACKGROUND", 1)
		frame.bg4:SetTexture(0,0,0)
		frame.bg4:SetPoint("TOPLEFT", E.mult, -E.mult)
		frame.bg4:SetPoint("BOTTOMRIGHT", -E.mult, E.mult)					


		
		_G["AchievementFrameAchievementsContainerButton"..i.."Description"]:SetTextColor(0.6, 0.6, 0.6)
		_G["AchievementFrameAchievementsContainerButton"..i.."Description"].SetTextColor = E.dummy
		_G["AchievementFrameAchievementsContainerButton"..i.."HiddenDescription"]:SetTextColor(1, 1, 1)
		_G["AchievementFrameAchievementsContainerButton"..i.."HiddenDescription"].SetTextColor = E.dummy
		
		E.Kill(_G["AchievementFrameAchievementsContainerButton"..i.."IconBling"])
		E.Kill(_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"])
		E.EuiSetTemplate(_G["AchievementFrameAchievementsContainerButton"..i.."Icon"])
		_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:SetHeight(_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:GetHeight() - 14)
		_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:SetWidth(_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:GetWidth() - 14)
		_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:ClearAllPoints()
		_G["AchievementFrameAchievementsContainerButton"..i.."Icon"]:SetPoint("LEFT", 6, 0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]:ClearAllPoints()
		_G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]:SetPoint("TOPLEFT", 2, -2)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)		
		
		
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"].oborder = "Don't use sharp border" --Needed for ElvUI only
		E.StripTextures(_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"])
		E.EuiSetTemplate(_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"])
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:SetSize(12, 12)
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:GetCheckedTexture():SetPoint("TOPLEFT", -4, 4)
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:GetCheckedTexture():SetPoint("BOTTOMRIGHT", 4, -4)
		
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:ClearAllPoints()
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 5)
		
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"].ClearAllPoints = E.dummy
		_G["AchievementFrameAchievementsContainerButton"..i.."Tracked"].SetPoint = E.dummy
	end

	
	local compares = {
		"Player",
		"Friend"
	}
	
	for _, compare in pairs(compares) do
		for i=1, 9 do
			local frame = "AchievementFrameComparisonContainerButton"..i..compare
			
			E.StripTextures(_G[frame])
			E.Kill(_G[frame.."Background"])
			
			_G[frame].SetBackdropBorderColor = E.dummy		
			
			if _G[frame.."Description"] then
				_G[frame.."Description"]:SetTextColor(0.6, 0.6, 0.6)
				_G[frame.."Description"].SetTextColor = E.dummy
			end

			--Initiate fucked up method of creating a backdrop
			_G[frame].bg1 = _G[frame]:CreateTexture(nil, "BACKGROUND")
			_G[frame].bg1:SetDrawLayer("BACKGROUND", 4)
			_G[frame].bg1:SetTexture(E.normTex) --Default TukUI users this is normTex, glossTex doesn't exist
			_G[frame].bg1:SetVertexColor(0.1, 0.1, 0.1)
			_G[frame].bg1:SetPoint("TOPLEFT", E.mult*4, -E.mult*4)
			_G[frame].bg1:SetPoint("BOTTOMRIGHT", -E.mult*4, E.mult*4)				
			
			_G[frame].bg2 = _G[frame]:CreateTexture(nil, "BACKGROUND")
			_G[frame].bg2:SetDrawLayer("BACKGROUND", 3)
			_G[frame].bg2:SetTexture(0,0,0)
			_G[frame].bg2:SetPoint("TOPLEFT", E.mult*3, -E.mult*3)
			_G[frame].bg2:SetPoint("BOTTOMRIGHT", -E.mult*3, E.mult*3)
			
			_G[frame].bg3 = _G[frame]:CreateTexture(nil, "BACKGROUND")
			_G[frame].bg3:SetDrawLayer("BACKGROUND", 2)
			_G[frame].bg3:SetTexture(0.31, 0.45, 0.63)
			_G[frame].bg3:SetPoint("TOPLEFT", E.mult*2, -E.mult*2)
			_G[frame].bg3:SetPoint("BOTTOMRIGHT", -E.mult*2, E.mult*2)			

			_G[frame].bg4 = _G[frame]:CreateTexture(nil, "BACKGROUND")
			_G[frame].bg4:SetDrawLayer("BACKGROUND", 1)
			_G[frame].bg4:SetTexture(0,0,0)
			_G[frame].bg4:SetPoint("TOPLEFT", E.mult, -E.mult)
			_G[frame].bg4:SetPoint("BOTTOMRIGHT", -E.mult, E.mult)	
			
			
			if compare == "Friend" then
				_G[frame.."Shield"]:SetPoint("TOPRIGHT", _G["AchievementFrameComparisonContainerButton"..i.."Friend"], "TOPRIGHT", -20, -3)
			end
							
			E.Kill(_G[frame.."IconBling"])
			E.Kill(_G[frame.."IconOverlay"])
			E.EuiSetTemplate(_G[frame.."Icon"])
			_G[frame.."Icon"]:SetHeight(_G[frame.."Icon"]:GetHeight() - 14)
			_G[frame.."Icon"]:SetWidth(_G[frame.."Icon"]:GetWidth() - 14)
			_G[frame.."Icon"]:ClearAllPoints()
			_G[frame.."Icon"]:SetPoint("LEFT", 6, 0)
			_G[frame.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			_G[frame.."IconTexture"]:ClearAllPoints()
			_G[frame.."IconTexture"]:SetPoint("TOPLEFT", 2, -2)
			_G[frame.."IconTexture"]:SetPoint("BOTTOMRIGHT", -2, 2)					
		end
	end
	
	for i=1, 20 do
		local frame = _G["AchievementFrameStatsContainerButton"..i]
		E.StyleButton(frame)
		
		_G["AchievementFrameStatsContainerButton"..i.."BG"]:SetTexture(1, 1, 1, 0.2)
		E.Kill(_G["AchievementFrameStatsContainerButton"..i.."HeaderLeft"])
		E.Kill(_G["AchievementFrameStatsContainerButton"..i.."HeaderRight"])
		E.Kill(_G["AchievementFrameStatsContainerButton"..i.."HeaderMiddle"])
		
		local frame = "AchievementFrameComparisonStatsContainerButton"..i
		E.StripTextures(_G[frame])
		E.StyleButton(_G[frame])
	
		_G[frame.."BG"]:SetTexture(1, 1, 1, 0.2)
		E.Kill(_G[frame.."HeaderLeft"])
		E.Kill(_G[frame.."HeaderRight"])
		E.Kill(_G[frame.."HeaderMiddle"])			
	end
	
	
	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local frame = _G["AchievementFrameProgressBar"..index]
		if frame then
			if not frame.skinned then
				E.StripTextures(frame)
				frame:SetStatusBarTexture(E.normTex)
				frame:SetStatusBarColor(4/255, 179/255, 30/255)
				frame:SetFrameLevel(frame:GetFrameLevel() + 3)
				
				frame:SetHeight(frame:GetHeight() - 2)
				
				--Initiate fucked up method of creating a backdrop
				frame.bg1 = frame:CreateTexture(nil, "BACKGROUND")
				frame.bg1:SetDrawLayer("BACKGROUND", -7)
				frame.bg1:SetTexture(0.31, 0.45, 0.63)
				frame.bg1:SetPoint("TOPLEFT", -E.mult*3, E.mult*3)
				frame.bg1:SetPoint("BOTTOMRIGHT", E.mult*3, -E.mult*3)
				
				frame.bg2 = frame:CreateTexture(nil, "BACKGROUND")
				frame.bg2:SetDrawLayer("BACKGROUND", -6)
				frame.bg2:SetTexture(0.31, 0.45, 0.63)
				frame.bg2:SetPoint("TOPLEFT", -E.mult*2, E.mult*2)
				frame.bg2:SetPoint("BOTTOMRIGHT", E.mult*2, -E.mult*2)					

				frame.bg3 = frame:CreateTexture(nil, "BACKGROUND")
				frame.bg3:SetDrawLayer("BACKGROUND", -5)
				frame.bg3:SetTexture(0.31, 0.45, 0.63)
				frame.bg3:SetPoint("TOPLEFT", -E.mult, E.mult)
				frame.bg3:SetPoint("BOTTOMRIGHT", E.mult, -E.mult)		
				
				frame.text:ClearAllPoints()
				frame.text:SetPoint("CENTER", frame, "CENTER", 0, -1)
				frame.text:SetJustifyH("CENTER")
				
				if index > 1 then
					frame:ClearAllPoints()
					frame:SetPoint("TOP", _G["AchievementFrameProgressBar"..index-1], "BOTTOM", 0, -5)
					frame.SetPoint = E.dummy
					frame.ClearAllPoints = E.dummy
				end
				
				frame.skinned = true
			end

		end
	end)
	
	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas = 0, 0
		for i = 1, numCriteria do	
			local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString = GetAchievementCriteriaInfo(id, i)
			
			if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then
				metas = metas + 1;
				local metaCriteria = AchievementButton_GetMeta(metas);				
				if ( objectivesFrame.completed and completed ) then
					metaCriteria.label:SetShadowOffset(0, 0)
					metaCriteria.label:SetTextColor(1, 1, 1, 1);
				elseif ( completed ) then
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(0, 1, 0, 1);
				else
					metaCriteria.label:SetShadowOffset(1, -1)
					metaCriteria.label:SetTextColor(.6, .6, .6, 1);
				end				
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1;
				local criteria = AchievementButton_GetCriteria(textStrings);				
				if ( objectivesFrame.completed and completed ) then
					criteria.name:SetTextColor(1, 1, 1, 1);
					criteria.name:SetShadowOffset(0, 0);
				elseif ( completed ) then
					criteria.name:SetTextColor(0, 1, 0, 1);
					criteria.name:SetShadowOffset(1, -1);
				else
					criteria.name:SetTextColor(.6, .6, .6, 1);
					criteria.name:SetShadowOffset(1, -1);
				end		
			end
		end
	end)
end

E.SkinFuncs["Blizzard_AchievementUI"] = LoadSkin