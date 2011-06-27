
local _, YssBossLoot = ...

local broker = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

local L = LibStub("AceLocale-3.0"):GetLocale("YssBossLoot", true)
local BZ = LibStub("LibBabble-Zone-3.0", true):GetUnstrictLookupTable()

local last_ldb_anchor

local hovertip
function YssBossLoot:SetupLDB()
	self.ldbp = LibStub("LibDataBroker-1.1"):NewDataObject("YssBossLoot", {
		icon = "Interface\\Addons\\YssBossLoot\\Art\\skullwhite",
		label = "|cFF33FF99YssBossLoot|r",
		type = "launcher",
		text  = "YssBossLoot",
		OnClick = function(clickedFrame, button)
			if button == "RightButton" then
				InterfaceOptionsFrame_OpenToCategory(YssBossLoot.optframe.YBL)
			else
				ToggleDropDownMenu(1, nil, YssBossLoot.LDBdrop, clickedFrame, 0, 0)
				last_ldb_anchor = clickedFrame
			end
			if hovertip and hovertip.Hide then
				hovertip:Hide()
			end
		end,
		OnTooltipShow = function(tt)
			tt:AddLine('YssBossLoot')
			tt:AddLine(L["|cffffff00Left Click|r to select Instance"])
			tt:AddLine(L["|cffffff00Right Click|r to open Options"])
			hovertip = tt
		end,
	})
	icon:Register("YssBossLoot", YssBossLoot.ldbp, YssBossLoot.db.profile.LibDBIcon)
end


YssBossLoot.LDBdrop = CreateFrame("Frame", "YssBossLoot_FilterMenu")
YssBossLoot.LDBdrop.onHide = function(...)
	MenuParent = nil
	MenuItem = nil
	MenuEquipSlot = nil
end

YssBossLoot.LDBdrop.HideMenu = function()
    if UIDROPDOWNMENU_OPEN_MENU == YssBossLoot.LDBdrop then
        CloseDropDownMenus()
    end
end

local function InstanceClick(button, arg1, arg2)
	if YssBossLoot.IDs[arg1][arg2] then
		ShowUIPanel(WorldMapFrame)
		SetMapByID(YssBossLoot.IDs[arg1][arg2])
	else
		YssBossLoot:NonMapInstance(button, arg1, arg2)
	end
end

local function sillyBlizzardCheckmarkRemover(button)
	ToggleDropDownMenu(1, nil, YssBossLoot.LDBdrop, last_ldb_anchor, 0, 0)
	ToggleDropDownMenu(1, nil, YssBossLoot.LDBdrop, last_ldb_anchor, 0, 0)
end

local info, sortedList, miscList = {}, {}, {}
YssBossLoot.LDBdrop.initialize = function(self, level)
	if not level then return end
	wipe(info)
	wipe(sortedList)
	wipe(miscList)
    if level == 1 then
		local sortedLConts = {}
		local rConts = {}
		for c, lc in pairs(YssBossLoot.MapTypes) do
			rConts[lc] = c
			sortedLConts[#sortedLConts+1] = lc
		end
		table.sort(sortedLConts)

		for i = 1, #sortedLConts do
			wipe(info)
			info.text = NORMAL_FONT_COLOR_CODE..sortedLConts[i]
			if rConts[sortedLConts[i]] ~= "Battlegrounds" then
				info.notClickable = 1
				UIDropDownMenu_AddButton(info)
				wipe(info)
				for j, ext in ipairs(YssBossLoot.Ext) do
					info.notClickable = nil
					info.text = "   "..ext
					info.value = {rConts[sortedLConts[i]], ext}
					info.func = sillyBlizzardCheckmarkRemover
					info.padding = 32
					info.hasArrow = true
					UIDropDownMenu_AddButton(info)
				end
			else
				UIDropDownMenu_AddButton(info)
			end
		end
	elseif level == 2 then
		local currCont = UIDROPDOWNMENU_MENU_VALUE[1]
		local currExt = UIDROPDOWNMENU_MENU_VALUE[2]

		if currCont ~= "Battlegrounds" then
			local sortedZones = {}
			local sortedZonesEn = {}
			for z in pairs(YssBossLoot.MapLevels[currCont][currExt]) do
				sortedZones[#sortedZones+1] = z
			end
			table.sort(sortedZones, function(a,b)
					local minA = tonumber(string.match(YssBossLoot.MapLevels[currCont][currExt][a], "(%d+)|%d+"))
					local minB = tonumber(string.match(YssBossLoot.MapLevels[currCont][currExt][b], "(%d+)|%d+"))
					if minA ~= minB then
						return minA > minB
					else
						return a < b
					end
				end)
			for i, z in ipairs(sortedZones) do
				local minL, maxL = string.match(YssBossLoot.MapLevels[currCont][currExt][z], "(%d+)|(%d+)")
				sortedZones[i] = (BZ[z] or z).." "..ORANGE_FONT_COLOR_CODE..minL.."-"..maxL
				sortedZonesEn[i] = z
			end

			for i = 1, #sortedZones do
				info.text = sortedZones[i]
				info.arg1 = currCont
				info.arg2 = sortedZonesEn[i]
				info.func = InstanceClick
				UIDropDownMenu_AddButton(info, level)
			end
		else
			local sortedZones = {}
			local sortedZonesEn = {}
			for z in pairs(YssBossLoot.MapLevels[currCont]) do
				sortedZones[#sortedZones+1] = z
			end
			table.sort(sortedZones, function(a,b)
					local minA = tonumber(string.match(YssBossLoot.MapLevels[currCont][a], "(%d+)|%d+"))
					local minB = tonumber(string.match(YssBossLoot.MapLevels[currCont][b], "(%d+)|%d+"))
					if minA ~= minB then
						return minA > minB
					else
						return a < b
					end
				end)
			for i, z in ipairs(sortedZones) do
				local minL, maxL = string.match(YssBossLoot.MapLevels[currCont][z], "(%d+)|(%d+)")
				sortedZones[i] = (BZ[z] or z).." "..minL.."-"..maxL
				sortedZonesEn[i] = z
			end

			for i = 1, #sortedZones do
				info.text = sortedZones[i]
				info.arg1 = currCont
				info.arg2 = sortedZonesEn[i]
				info.func = InstanceClick
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end