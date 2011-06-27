local E, C = unpack(EUI)

if not C["other"].map == true then return end

WORLDMAP_WINDOWED_SIZE = C["other"].mapscale --Slightly increase the size of blizzard small map
local mapscale = WORLDMAP_WINDOWED_SIZE

local ft = E.font -- Map font
local fontsize = 22 -- Map Font Size

local mapbg = CreateFrame("Frame", nil, WorldMapDetailFrame)
	mapbg:SetBackdrop( { 
	bgFile = E.blank, 
	edgeFile = E.blank, 
	tile = false, edgeSize = E.mult, 
	insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult }
})

--Create move button for map
local movebutton = CreateFrame ("Frame", nil, WorldMapFrameSizeUpButton)
movebutton:SetHeight(E.Scale(32))
movebutton:SetWidth(E.Scale(32))
movebutton:SetPoint("TOP", WorldMapFrameSizeUpButton, "BOTTOM", E.Scale(-1), E.Scale(4))
movebutton:SetBackdrop( { 
	bgFile = "Interface\\AddOns\\Eui\\media\\cross",
})
movebutton:EnableMouse(true)

movebutton:SetScript("OnMouseDown", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapScreenAnchor:ClearAllPoints()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:StartMoving();
end)

movebutton:SetScript("OnMouseUp", function()
	local maplock = GetCVar("advancedWorldMap")
	if maplock ~= "1" then return end
	WorldMapFrame:StopMovingOrSizing()
	WorldMapScreenAnchor:StartMoving()
	WorldMapScreenAnchor:SetPoint("TOPLEFT", WorldMapFrame)
	WorldMapScreenAnchor:StopMovingOrSizing()
end)


-- look if map is not locked
local MoveMap = GetCVarBool("advancedWorldMap")
if MoveMap == nil then
	SetCVar("advancedWorldMap", 1)
end

-- new frame to put zone and title text in
local ald = CreateFrame ("Frame", nil, WorldMapButton)
ald:SetFrameStrata("HIGH")
ald:SetFrameLevel(0)

--for the larger map
local alds = CreateFrame ("Frame", nil, WorldMapButton)
alds:SetFrameStrata("HIGH")
alds:SetFrameLevel(0)

local SmallerMapSkin = function()
	-- don't need this
	E.Kill(WorldMapTrackQuest)

	-- map glow
	E.EuiCreateShadow(mapbg)
	
	-- map border and bg
	mapbg:SetBackdropColor(.1,.1,.1)
	mapbg:SetBackdropBorderColor(.31,.45,.63)
	mapbg:SetScale(1 / mapscale)
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, E.Scale(-2), E.Scale(2))
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, E.Scale(2), E.Scale(-2))
	mapbg:SetFrameStrata("MEDIUM")
	mapbg:SetFrameLevel(20)
	mapbg:SetAlpha(C["other"].mapalpha)
	
	WorldMapDetailFrame:SetAlpha(C["other"].mapalpha)
	-- move buttons / texts and hide default border
	WorldMapButton:SetAllPoints(WorldMapDetailFrame)
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapFrame:SetClampedToScreen(true) 
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	WorldMapTitleButton:Show()	
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", E.Scale(3), E.Scale(-18))
	WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeUpButton:SetFrameLevel(18)
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", E.Scale(3), E.Scale(3))
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	WorldMapFrameCloseButton:SetFrameLevel(18)
	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapFrameMiniBorderRight, "TOPRIGHT", E.Scale(-66), E.Scale(7))
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("TOP", WorldMapDetailFrame, E.Scale(0), -E.Scale(10))
	WorldMapFrameTitle:SetFont(ft, fontsize, "OUTLINE")
	WorldMapFrameTitle:SetShadowOffset(E.mult, -E.mult)
	WorldMapFrameTitle:SetParent(ald)		
	WorldMapTitleButton:SetFrameStrata("MEDIUM")
	WorldMapTooltip:SetFrameStrata("TOOLTIP")

	
	WorldMapQuestShowObjectives:SetParent(ald)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, E.Scale(10))
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:SetFont(ft, fontsize*.7, "THINOUTLINE")
	WorldMapQuestShowObjectivesText:SetShadowOffset(E.mult, -E.mult)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", E.Scale(-4), E.Scale(1))
	
	--WorldMapShowDigSites:SetParent(ald)
	--WorldMapShowDigSites:ClearAllPoints()
	--WorldMapShowDigSites:SetPoint("BOTTOM", WorldMapQuestShowObjectives, "TOP", 0, E.Scale(2))
	--WorldMapShowDigSites:SetFrameStrata("HIGH")
	--WorldMapShowDigSitesText:ClearAllPoints()
	--WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapShowDigSites, "LEFT", E.Scale(-4), E.Scale(1))
	--WorldMapShowDigSitesText:SetFont(ft, fontsize, "THINOUTLINE")
	--WorldMapShowDigSitesText:SetShadowOffset(E.mult, -E.mult)		
	
	WorldMapFrameAreaFrame:SetFrameStrata("DIALOG")
	WorldMapFrameAreaFrame:SetFrameLevel(20)
	WorldMapFrameAreaLabel:SetFont(ft, fontsize*3, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)
	
	-- 3.3.3, hide the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(0)
	WorldMapLevelDropDown:SetScale(0.00001)

	-- fix tooltip not hidding after leaving quest # tracker icon
	hooksecurefunc("WorldMapQuestPOI_OnLeave", function() WorldMapTooltip:Hide() end)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

local BiggerMapSkin = function()
	-- 3.3.3, show the dropdown added into this patch
	WorldMapLevelDropDown:SetAlpha(1)
	WorldMapLevelDropDown:SetScale(1)
	
	local fs = fontsize*0.7
	
	WorldMapQuestShowObjectives:SetParent(ald)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT")
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:SetFont(ft, fs, "THINOUTLINE")
	WorldMapQuestShowObjectivesText:SetShadowOffset(E.mult, -E.mult)
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", E.Scale(-4), E.Scale(1))
	
	--WorldMapShowDigSites:SetParent(ald)
	--WorldMapShowDigSites:ClearAllPoints()
	--WorldMapShowDigSites:SetPoint("BOTTOM", WorldMapQuestShowObjectives, "TOP", 0, E.Scale(1))
	--WorldMapShowDigSites:SetFrameStrata("HIGH")
	--WorldMapShowDigSitesText:ClearAllPoints()
	--WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapShowDigSites, "LEFT", E.Scale(-4), E.Scale(1))
	--WorldMapShowDigSitesText:SetFont(ft, fs, "THINOUTLINE")
	--WorldMapShowDigSitesText:SetShadowOffset(E.mult, -E.mult)	
	
	WorldMapFrameAreaFrame:SetFrameStrata("DIALOG")
	WorldMapFrameAreaFrame:SetFrameLevel(20)
	WorldMapFrameAreaLabel:SetFont(ft, fs*3, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)
	
end
hooksecurefunc("WorldMap_ToggleSizeUp", function() BiggerMapSkin() end)

mapbg:SetScript("OnShow", function(self)
	local SmallerMap = GetCVarBool("miniWorldMap")
	if SmallerMap == nil then
		BiggerMapSkin()
	end
	self:SetScript("OnShow", function() end)
end)

local addon = CreateFrame('Frame')
addon:RegisterEvent('PLAYER_ENTERING_WORLD')
addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("PLAYER_REGEN_DISABLED")
addon:RegisterEvent("WORLD_MAP_UPDATE")
addon:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		ShowUIPanel(WorldMapFrame)
		HideUIPanel(WorldMapFrame)
	elseif event == "WORLD_MAP_UPDATE" then
		if (GetNumDungeonMapLevels() == 0) then
			WorldMapLevelUpButton:Hide()
			WorldMapLevelDownButton:Hide()
		else
			WorldMapLevelUpButton:Show()
			WorldMapLevelDownButton:Show()
			WorldMapLevelUpButton:ClearAllPoints()
			WorldMapLevelUpButton:SetPoint("BOTTOM", WorldMapFrameTitle, "LEFT", -E.Scale(8), 1)
			WorldMapLevelUpButton:SetFrameStrata("HIGH")
			WorldMapLevelUpButton:SetFrameLevel(90)
			WorldMapLevelDownButton:ClearAllPoints()
			WorldMapLevelDownButton:SetPoint("TOP", WorldMapFrameTitle, "LEFT", -E.Scale(8), -1)
			WorldMapLevelDownButton:SetFrameStrata("HIGH")
			WorldMapLevelDownButton:SetFrameLevel(90)
		end	
	elseif event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeDownButton:Disable() 
		WorldMapFrameSizeUpButton:Disable()
		HideUIPanel(WorldMapFrame)
		WatchFrame.showObjectives = nil
		WorldMapQuestShowObjectives:SetChecked(false)
		WorldMapQuestShowObjectives:Hide()
		WorldMapTitleButton:Hide()
		WorldMapBlobFrame:Hide()
		WorldMapPOIFrame:Hide()

		WorldMapQuestShowObjectives.Show = E.dummy
		WorldMapTitleButton.Show = E.dummy
		WorldMapBlobFrame.Show = E.dummy
		WorldMapPOIFrame.Show = E.dummy       

		WatchFrame_Update()
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeDownButton:Enable()
		WorldMapFrameSizeUpButton:Enable()
		WorldMapQuestShowObjectives.Show = WorldMapQuestShowObjectives:Show()
		WorldMapTitleButton.Show = WorldMapTitleButton:Show()
		WorldMapBlobFrame.Show = WorldMapBlobFrame:Show()
		WorldMapPOIFrame.Show = WorldMapPOIFrame:Show()

		WorldMapQuestShowObjectives:Show()
		WorldMapTitleButton:Show()

		WatchFrame.showObjectives = true
		WorldMapQuestShowObjectives:SetChecked(true)

		WorldMapBlobFrame:Show()
		WorldMapPOIFrame:Show()

		WatchFrame_Update()
	end
end)

local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
local fontheight = select(2, WorldMapQuestShowObjectivesText:GetFont())*1.1
coords.PlayerText = coords:CreateFontString(nil, "OVERYLAY")
coords.MouseText = coords:CreateFontString(nil, "OVERLAY")
coords.PlayerText:SetFont(E.font, fontheight, "THINOUTLINE")
coords.MouseText:SetFont(E.font, fontheight, "THINOUTLINE")
coords.PlayerText:SetShadowOffset(E.mult, -E.mult)
coords.MouseText:SetShadowOffset(E.mult, -E.mult)
coords.PlayerText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
coords.MouseText:SetTextColor(WorldMapQuestShowObjectivesText:GetTextColor())
coords.PlayerText:SetPoint("TOPLEFT", WorldMapButton, "TOPLEFT", 5, -5)
coords.PlayerText:SetText("Player:   0, 0")
coords.MouseText:SetPoint("TOPLEFT", coords.PlayerText, "BOTTOMLEFT", 0, -5)
coords.MouseText:SetText("Mouse:   0, 0")

local int = 0
coords:SetScript("OnUpdate", function(self, elapsed)
	int = int + 1
	
	if int >= 3 then
		local inInstance, _ = IsInInstance()
		local x,y = GetPlayerMapPosition("player")
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			self.PlayerText:SetText(PLAYER..":   "..x..", "..y)
		else
			self.PlayerText:SetText(" ")
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
end)

----------------------------------------------------------------------------------------
--	New raid/party members MapBlips(by Nevcairiel)
----------------------------------------------------------------------------------------
	local f = CreateFrame("Frame", "MapBlips", UIParent)
	function f:OverrideWorldMapUnit_Update(unit)
		if unit == nil then return end
		f:OnUpdate(unitFrame.icon, unitFrame.unit)
	end
	function f:gen_icon(unit, cond, party)
		local u = _G[unit]
		local icon = u.icon
		if cond then
			u.elapsed = 0.5
			u:SetScript("OnUpdate", function(self, elapsed)
				self.elapsed = self.elapsed - elapsed
				if self.elapsed <= 0 then
					self.elapsed = 0.5
					MapBlips:OnUpdate(self.icon, self.unit)
				end
			end)
			u:SetScript("OnEvent", nil)
			if party then
				icon:SetTexture("Interface\\AddOns\\Eui\\media\\Party")
			end
		else
			u.elapsed = nil
			u:SetScript("OnUpdate", nil)
			u:SetScript("OnEvent", WorldMapUnit_OnEvent)
		end
	end
	function f:OnUpdate(icon, unit)
		if not (icon and unit) then return end
		local _, uname = UnitClass(unit)
		if not uname then return end
		if string.find(unit, "raid", 1, true) then
			local _, _, group = GetRaidRosterInfo(string.sub(unit, 5))
			if not group then return end
			icon:SetTexture(string.format("Interface\\AddOns\\Eui\\media\\Group%d", group))
		end
		local col = RAID_CLASS_COLORS[uname]
		if col then
			icon:SetVertexColor(col.r, col.g, col.b)
		end
	end
	local function OnInit()
		for i = 1, 4 do
			f:gen_icon(string.format("WorldMapParty%d", i), true, true)
		end
		for i = 1, 40 do
			f:gen_icon(string.format("WorldMapRaid%d", i), true)
		end
		WorldMapUnit_Update = f.OverrideWorldMapUnit_Update;
		f:UnregisterEvent("PLAYER_LOGIN")
		f.PLAYER_LOGIN = nil
	end
	f:RegisterEvent("PLAYER_LOGIN") 
	f:SetScript("OnEvent", OnInit)
