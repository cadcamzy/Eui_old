local E, C, L = unpack(EUI)
if C["skins"].enable22 ~= true then return end

local function LoadSkin()
	E.EuiCreateBackdrop(WorldMapFrame,.7)
	WorldMapDetailFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
	E.EuiSetTemplate(WorldMapDetailFrame.backdrop)
	WorldMapDetailFrame.backdrop:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -2, 2)
	WorldMapDetailFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 2, -2)
	WorldMapDetailFrame.backdrop:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() - 2)

	E.SkinCloseButton(WorldMapFrameCloseButton)
	E.SkinCloseButton(WorldMapFrameSizeDownButton)
	E.SkinCloseButton(WorldMapFrameSizeUpButton)
							
	E.SkinDropDownBox(WorldMapLevelDropDown)
	E.SkinDropDownBox(WorldMapZoneMinimapDropDown)
	E.SkinDropDownBox(WorldMapContinentDropDown)
	E.SkinDropDownBox(WorldMapZoneDropDown)
	E.SkinButton(WorldMapZoomOutButton)
	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropDown, "RIGHT", 0, 4)
	WorldMapLevelUpButton:SetPoint("TOPLEFT", WorldMapLevelDropDown, "TOPRIGHT", -2, 8)
	WorldMapLevelDownButton:SetPoint("BOTTOMLEFT", WorldMapLevelDropDown, "BOTTOMRIGHT", -2, 2)
	
	E.SkinCheckBox(WorldMapTrackQuest)
	E.SkinCheckBox(WorldMapQuestShowObjectives)
	E.SkinCheckBox(WorldMapShowDigSites)
	
	--Mini
	local function SmallSkin()
		WorldMapLevelDropDown:ClearAllPoints()
		WorldMapLevelDropDown:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -10, -4)

		WorldMapFrame.backdrop:ClearAllPoints()
		WorldMapFrame.backdrop:SetPoint("TOPLEFT", 2, 2)
		WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	end
	
	--Large
	local function LargeSkin()
		if not InCombatLockdown() then
			WorldMapFrame:SetParent(UIParent)
			WorldMapFrame:EnableMouse(false)
			WorldMapFrame:EnableKeyboard(false)
			SetUIPanelAttribute(WorldMapFrame, "area", "center");
			SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
		end
		
		WorldMapFrame.backdrop:ClearAllPoints()
		WorldMapFrame.backdrop:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -25, 70)
		WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 25, -30)		
	end
	
	local function QuestSkin()
		if not InCombatLockdown() then
			WorldMapFrame:SetParent(UIParent)
			WorldMapFrame:EnableMouse(false)
			WorldMapFrame:EnableKeyboard(false)
			SetUIPanelAttribute(WorldMapFrame, "area", "center");
			SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
		end
		
		WorldMapFrame.backdrop:ClearAllPoints()
		WorldMapFrame.backdrop:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -25, 70)
		WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 325, -235)  
		
		if not WorldMapQuestDetailScrollFrame.backdrop then
			E.EuiCreateBackdrop(WorldMapQuestDetailScrollFrame)
			WorldMapQuestDetailScrollFrame.backdrop:SetPoint("TOPLEFT", -22, 2)
			WorldMapQuestDetailScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 23, -4)
		end
		
		if not WorldMapQuestRewardScrollFrame.backdrop then
			E.EuiCreateBackdrop(WorldMapQuestRewardScrollFrame)
			WorldMapQuestRewardScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 22, -4)				
		end
		
		if not WorldMapQuestScrollFrame.backdrop then
			E.EuiCreateBackdrop(WorldMapQuestScrollFrame)
			WorldMapQuestScrollFrame.backdrop:SetPoint("TOPLEFT", 0, 2)
			WorldMapQuestScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 24, -3)				
		end
	end			
	
	local function FixSkin()
		E.StripTextures(WorldMapFrame)
		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
			LargeSkin()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
			SmallSkin()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
			QuestSkin()
		end

		if not InCombatLockdown() then
			WorldMapFrame:SetScale(1)
			WorldMapFrameSizeDownButton:Show()
			WorldMapFrame:SetFrameLevel(10)
		else
			WorldMapFrameSizeDownButton:Disable()
			WorldMapFrameSizeUpButton:Disable()
		end	
		
		WorldMapFrameAreaLabel:SetFont(E.font, 50, "OUTLINE")
		WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
		WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)	
		
		WorldMapFrameAreaDescription:SetFont(E.font, 40, "OUTLINE")
		WorldMapFrameAreaDescription:SetShadowOffset(2, -2)	
		
		WorldMapZoneInfo:SetFont(E.font, 27, "OUTLINE")
		WorldMapZoneInfo:SetShadowOffset(2, -2)		
	end
	
	WorldMapFrame:HookScript("OnShow", FixSkin)
	hooksecurefunc("WorldMapFrame_SetFullMapView", LargeSkin)
	hooksecurefunc("WorldMapFrame_SetQuestMapView", QuestSkin)
	hooksecurefunc("WorldMap_ToggleSizeUp", FixSkin)
	
	WorldMapFrame:RegisterEvent("PLAYER_LOGIN")
	WorldMapFrame:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			if not GetCVarBool("miniWorldMap") then
				ToggleFrame(WorldMapFrame)				
				ToggleFrame(WorldMapFrame)
			end
		end
	end)
	
	local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
	local fontheight = select(2, WorldMapQuestShowObjectivesText:GetFont())*1.1
	coords:SetFrameLevel(90)
	coords.PlayerText = E.EuiSetFontn(coords, E.font, fontheight, "THINOUTLINE")
	coords.MouseText = E.EuiSetFontn(coords, E.font, fontheight, "THINOUTLINE")
	coords.PlayerText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
	coords.MouseText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
	coords.PlayerText:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "BOTTOMLEFT", 5, 5)
	coords.PlayerText:SetText("Player:   0, 0")
	coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
	coords.MouseText:SetText("Mouse:   0, 0")
	local int = 0
	
	WorldMapFrame:HookScript("OnUpdate", function(self, elapsed)
		--For some reason these buttons aren't functioning correctly, and we can't afford for it to fuckup because toggling to a big map in combat will cause a taint.
		if InCombatLockdown() then
			WorldMapFrameSizeDownButton:Disable()
			WorldMapFrameSizeUpButton:Disable()
		else
			WorldMapFrameSizeDownButton:Enable()
			WorldMapFrameSizeUpButton:Enable()	
		end
		
		if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
			WorldMapFrameSizeUpButton:Hide()
			WorldMapFrameSizeDownButton:Show()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
			WorldMapFrameSizeUpButton:Show()
			WorldMapFrameSizeDownButton:Hide()
		elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
			WorldMapFrameSizeUpButton:Hide()
			WorldMapFrameSizeDownButton:Show()
		end		

		int = int + 1
		
		if int >= 3 then
			local inInstance, _ = IsInInstance()
			local x,y = GetPlayerMapPosition("player")
			x = math.floor(100 * x)
			y = math.floor(100 * y)
			if x ~= 0 and y ~= 0 then
				coords.PlayerText:SetText(PLAYER..":   "..x..", "..y)
			else
				coords.PlayerText:SetText(" ")
			end
			

			local scale = WorldMapDetailFrame:GetEffectiveScale()
			local width = WorldMapDetailFrame:GetWidth()
			local height = WorldMapDetailFrame:GetHeight()
			local centerX, centerY = WorldMapDetailFrame:GetCenter()
			local x, y = GetCursorPosition()
			local adjustedX = (x / scale - (centerX - (width/2))) / width
			local adjustedY = (centerY + (height/2) - y / scale) / height	

			if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
				adjustedX = math.floor(100 * adjustedX)
				adjustedY = math.floor(100 * adjustedY)
				coords.MouseText:SetText(MOUSE_LABEL..":   "..adjustedX..", "..adjustedY)
			else
				coords.MouseText:SetText(" ")
			end
			
			int = 0
		end	
		
		if DropDownList1:GetScale() ~= UIParent:GetScale() then
			DropDownList1:SetScale(UIParent:GetScale())
		end
	end)	
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)