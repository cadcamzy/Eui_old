
local _, YssBossLoot = ...

local YBL_WMS = {}

local L = LibStub("AceLocale-3.0"):GetLocale("YssBossLoot", true)
local BZ = LibStub("LibBabble-Zone-3.0", true):GetUnstrictLookupTable()
local BB = LibStub("LibBabble-Boss-3.0", true):GetUnstrictLookupTable()

do -- following is adapted from Mapster with permission
	YssBossLoot.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	YssBossLoot.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	local blobWasVisible, blobNewScale, blobHideFunc, blobShowFunc, blobScaleFunc

	local archBlobWasVisible, archBlobHideFunc, archBlobShowFunc
	
	local updateFrame, restoreBlobs
	
	function YssBossLoot:PLAYER_REGEN_DISABLED(event)
		if LibStub("AceAddon-3.0"):GetAddon("Mapster", true) then
			self.frame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self.frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self.PLAYER_REGEN_DISABLED = nil
			self.PLAYER_REGEN_ENABLED = nil
		else
			blobHideFunc = function() blobWasVisible = nil end
			blobShowFunc = function() blobWasVisible = true end
			blobScaleFunc = function(self, scale) blobNewScale = scale end
			
			archBlobHideFunc = function() archBlobWasVisible = nil end
			archBlobShowFunc = function() archBlobWasVisible = true end
			
			updateFrame = CreateFrame("Frame")
			restoreBlobs = function()
				WorldMapBlobFrame_CalculateHitTranslations()
				if WorldMapQuestScrollChildFrame.selected and not WorldMapQuestScrollChildFrame.selected.completed then
					WorldMapBlobFrame:DrawBlob(WorldMapQuestScrollChildFrame.selected.questId, true)
				end
				updateFrame:SetScript("OnUpdate", nil)
			end
			
			self.PLAYER_REGEN_DISABLED =  function(self, event)
				blobWasVisible = WorldMapBlobFrame:IsShown()
				blobNewScale = nil
				WorldMapBlobFrame:SetParent(nil)
				WorldMapBlobFrame:ClearAllPoints()
				-- dummy position, off screen, so calculations don't go boom
				WorldMapBlobFrame:SetPoint("TOP", UIParent, "BOTTOM")
				WorldMapBlobFrame:Hide()
				WorldMapBlobFrame.Hide = blobHideFunc
				WorldMapBlobFrame.Show = blobShowFunc
				WorldMapBlobFrame.SetScale = blobScaleFunc

				archBlobWasVisible = WorldMapArchaeologyDigSites:IsShown()
				WorldMapArchaeologyDigSites:SetParent(nil)
				WorldMapArchaeologyDigSites:ClearAllPoints()
				-- dummy position, off screen, so calculations don't go boom
				WorldMapArchaeologyDigSites:SetPoint("TOP", UIParent, "BOTTOM")
				WorldMapArchaeologyDigSites:Hide()
				WorldMapArchaeologyDigSites.Hide = archBlobHideFunc
				WorldMapArchaeologyDigSites.Show = archBlobShowFunc
			end
			self:PLAYER_REGEN_DISABLED(event)
		end
	end

	function YssBossLoot:PLAYER_REGEN_ENABLED(event)
		WorldMapBlobFrame:SetParent(WorldMapFrame)
		WorldMapBlobFrame:ClearAllPoints()
		WorldMapBlobFrame:SetPoint("TOPLEFT", WorldMapDetailFrame)
		WorldMapBlobFrame.Hide = nil
		WorldMapBlobFrame.Show = nil
		WorldMapBlobFrame.SetScale = nil
		if blobWasVisible then
			WorldMapBlobFrame:Show()
			updateFrame:SetScript("OnUpdate", restoreBlobs)
		end
		if blobNewScale then
			WorldMapBlobFrame:SetScale(blobNewScale)
			WorldMapBlobFrame.xRatio = nil
			blobNewScale = nil
		end

		WorldMapArchaeologyDigSites:SetParent(WorldMapFrame)
		WorldMapArchaeologyDigSites:ClearAllPoints()
		WorldMapArchaeologyDigSites:SetPoint("TOPLEFT", WorldMapDetailFrame)
		WorldMapArchaeologyDigSites.Hide = nil
		WorldMapArchaeologyDigSites.Show = nil
		if archBlobWasVisible then
			WorldMapArchaeologyDigSites:Show()
		end

		if WorldMapQuestScrollChildFrame.selected then
			WorldMapBlobFrame:DrawBlob(WorldMapQuestScrollChildFrame.selected.questId, false)
		end
	end
end

local function GetMapType()
	local id = GetCurrentMapAreaID()
	local currCont = YssBossLoot.IDs.type[id]
	if currCont then
		local currZone = YssBossLoot.IDs['r'..currCont][id]
		local currLevel = GetCurrentMapDungeonLevel()
		if currCont ~= "Battlegrounds" then
			for ext, t in pairs(YssBossLoot.MapLevels[currCont]) do
				if t[currZone] then
					currExt = ext
					break
				end
			end
		end
		return currCont, currZone, currLevel, currExt
	end
end

--WorldMapFrame_Update()
local WorldMapDetailFrame = _G['WorldMapDetailFrame']

local oldMapID, oldMapLevel -- lets check if we are on a different map before we update
hooksecurefunc("WorldMapFrame_Update", function(...) --detect ingame map location
	local MapID = GetCurrentMapAreaID()
	local MapLevel = GetCurrentMapDungeonLevel()
	if oldMapID ~= MapID or oldMapLevel ~= MapLevel then
		oldMapID, oldMapLevel = MapID, MapLevel
		YBL_WMS.currCont, YBL_WMS.currZone = nil, nil, nil
		YssBossLoot:ClearBosses(WorldMapDetailFrame)
		if YssBossLoot.LootFrame:IsVisible() then
			YssBossLoot.LootFrame:Hide()
		end
		local currCont, currZone, currLevel, currExt = GetMapType()
		if currCont then
			YssBossLoot:AddBosses(WorldMapDetailFrame, currCont, currZone, currLevel)
			YBL_WMS.currCont = currCont
			YBL_WMS.currZone = currZone
			YBL_WMS.currExt = currExt
		end
	end
end)

local WorldMapContinentButton_OnClick_old = WorldMapContinentButton_OnClick
function WorldMapContinentButton_OnClick(self, arg1, arg2, ...)
	YBL_WMS.currCont = nil
	if YssBossLoot.MapLevels[arg1] then
		SetMapZoom(-1)
		YBL_WMS.currCont = arg1
		YBL_WMS.currExt = arg2
		UIDropDownMenu_SetSelectedID(WorldMapContinentDropDown, self:GetID())
	else
		WorldMapContinentButton_OnClick_old(self, arg1, arg2, ...)
		YBL_WMS.currCont = nil
		YBL_WMS.currExt = nil
	end
end

local WorldMapContinentDropDownText_SetText = WorldMapContinentDropDownText.SetText
function WorldMapContinentDropDownText.SetText(self, text)
	if YBL_WMS.currCont then
		text = YssBossLoot.MapTypes[YBL_WMS.currCont]
	end
	WorldMapContinentDropDownText_SetText(self, text)
end

local info = {}
hooksecurefunc("WorldMapFrame_LoadContinents", function(...)
	wipe(info)

	local sortedLConts = {}
	local rConts = {}
	for c, lc in pairs(YssBossLoot.MapTypes) do
		rConts[lc] = c
		sortedLConts[#sortedLConts+1] = lc
	end
	table.sort(sortedLConts)

	local currCont, currZone, currLevel = GetMapType()
	for i = 1, #sortedLConts do
		wipe(info)
		info.text = NORMAL_FONT_COLOR_CODE..sortedLConts[i]
		info.arg1 = rConts[sortedLConts[i]]
		info.func = WorldMapContinentButton_OnClick
		info.checked = rConts[sortedLConts[i]] == currCont
		if rConts[sortedLConts[i]] ~= "Battlegrounds" then
			info.notClickable = 1
		--	UIDropDownMenu_AddButton(info)
			wipe(info)
			for j, ext in ipairs(YssBossLoot.Ext) do
				info.notClickable = nil
				info.text = "   "..ext
				info.arg1 = rConts[sortedLConts[i]]
				info.arg2 = ext
				info.func = WorldMapContinentButton_OnClick
				info.padding = 32
				info.checked = rConts[sortedLConts[i]] == currCont and ext == currExt
			--	UIDropDownMenu_AddButton(info)
			end
		elseif rConts[sortedLConts[i]] ~= "Battlegrounds" then
			UIDropDownMenu_AddButton(info)
		end
	end
end)

local WorldMapZoneDropDownText_SetText = WorldMapZoneDropDownText.SetText
function WorldMapZoneDropDownText.SetText(self, text)
	if YBL_WMS.currZone then
		text = BZ[YBL_WMS.currZone] or YBL_WMS.currZone
	end
	WorldMapZoneDropDownText_SetText(self, text)
end

local function InstanceClick(button, arg1)
	YBL_WMS.currZone = arg1
	UIDropDownMenu_SetSelectedID(WorldMapZoneDropDown, button:GetID())
	if YssBossLoot.IDs[YBL_WMS.currCont][arg1] then
		SetMapByID(YssBossLoot.IDs[YBL_WMS.currCont][arg1])
	else
		YssBossLoot:NonMapInstance(button, YBL_WMS.currCont, arg1)
	end
end

hooksecurefunc("WorldMapFrame_LoadZones", function(...)
	if YBL_WMS.currCont then
		wipe(info)
		if YBL_WMS.currCont ~= "Battlegrounds" then
			local sortedZones = {}
			local sortedZonesEn = {}
			for z in pairs(YssBossLoot.MapLevels[YBL_WMS.currCont][YBL_WMS.currExt]) do
				sortedZones[#sortedZones+1] = z
			end
			table.sort(sortedZones, function(a,b)
					local minA = tonumber(string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][YBL_WMS.currExt][a], "(%d+)|%d+"))
					local minB = tonumber(string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][YBL_WMS.currExt][b], "(%d+)|%d+"))
					if minA ~= minB then
						return minA > minB
					else
						return a < b
					end
				end)
			for i, z in ipairs(sortedZones) do
				local minL, maxL = string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][YBL_WMS.currExt][z], "(%d+)|(%d+)")
				sortedZones[i] = (BZ[z] or z).." "..ORANGE_FONT_COLOR_CODE..minL.."-"..maxL
				sortedZonesEn[i] = z
			end
			
			for i = 1, #sortedZones do
				info.text = sortedZones[i]
				info.arg1 = sortedZonesEn[i]
				info.func = InstanceClick
				info.checked = sortedZonesEn[i] == YBL_WMS.currZone
				UIDropDownMenu_AddButton(info)
			end
		else
			local sortedZones = {}
			local sortedZonesEn = {}
			for z in pairs(YssBossLoot.MapLevels[YBL_WMS.currCont]) do
				sortedZones[#sortedZones+1] = z
			end
			table.sort(sortedZones, function(a,b)
					local minA = tonumber(string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][a], "(%d+)|%d+"))
					local minB = tonumber(string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][b], "(%d+)|%d+"))
					if minA ~= minB then
						return minA > minB
					else
						return a < b
					end
				end)
			for i, z in ipairs(sortedZones) do
				local minL, maxL = string.match(YssBossLoot.MapLevels[YBL_WMS.currCont][z], "(%d+)|(%d+)")
				sortedZones[i] = (BZ[z] or z).." "..minL.."-"..maxL
				sortedZonesEn[i] = z
			end
			
			for i = 1, #sortedZones do
				info.text = sortedZones[i]
				info.arg1 = sortedZonesEn[i]
				info.func = InstanceClick
				info.checked = sortedZonesEn[i] == YBL_WMS.currZone
				UIDropDownMenu_AddButton(info)
			end
		end
	end
end)

--[==[ bah we can use this to hopefully detect what is causeing map resets
local SetMapByID_old = SetMapByID
function SetMapByID(...)
	SetMapByID_old(...)
	Spew('SetMapByID', debugstack())
end
local SetDungeonMapLevel_old = SetDungeonMapLevel
function SetDungeonMapLevel(...)
	SetDungeonMapLevel_old(...)
	Spew('SetDungeonMapLevel', debugstack())
end
local SetMapZoom_old = SetMapZoom
function SetMapZoom(...)
	SetMapZoom_old(...)
	Spew('SetMapZoom', debugstack())
end
local SetMapToCurrentZone_old = SetMapToCurrentZone
function SetMapToCurrentZone(...)
	SetMapToCurrentZone_old(...)
	Spew('SetMapToCurrentZone', debugstack())
end

function SAVEMAPNAMES()
	YssBossLootMissingTranslations = {}
	local last = ""
	for i=1, 2000 do
		SetMapByID(i)
		local map = GetMapInfo()
		if map and map ~= last then
			YssBossLootMissingTranslations[map] = i.." , "..GetNumDungeonMapLevels()
			last = map
		end
	end
end

]==]--
