local E, C, L = unpack(EUI)
local f = CreateFrame("Frame", nil, UIParent)
UnitItemLevelDB = {}

function GetUnitItemLevel(unit)
	local items = {}

	if unit and UnitIsPlayer(unit) and CheckInteractDistance(unit, 1) then
		for i = 1, 18, 1 do
			local itemID = GetInventoryItemID(unit, i) or 0
			local itemLevel = select(4, GetItemInfo(itemID))

			if itemLevel and itemLevel > 0 and i ~= 4 then
				tinsert(items, itemLevel)
			end
		end
	end

	local count, sum = #(items), TableSum(items)

	if sum >= count and count > 0 then
		if floor(sum/count)+0.5 < sum/count then
			return ceil(sum/count)
		else
			return floor(sum/count)
		end
	else
		return nil
	end
end

function GetUnitItemLevelGUID(unitGUID)
	local unitID, items = nil, {}

	if UnitGUID("player") == unitGUID then
		unitID = "player"
	elseif UnitGUID("mouseover") == unitGUID then
		unitID = "mouseover"
	elseif UnitGUID("target") == unitGUID then
		unitID = "target"
	elseif UnitGUID("focus") == unitGUID then
		unitID = "focus"
	end

	for i = 1, 4, 1 do
		if UnitGUID("party"..i) == unitGUID then unitID = "party"..i end
	end

	for i = 1, 40, 1 do
		if UnitGUID("raid"..i) == unitGUID then unitID = "raid"..i end
	end

	return GetUnitItemLevel(unitID)
end

local function GetGUIDByName(name)
	for k, v in pairs(UnitItemLevelDB) do
		if name == select(6, GetPlayerInfoByGUID(k)) then return k end
	end
end

function TableSum(table)
	local retVal = 0

	for _, n in ipairs(table) do
		retVal = retVal + n
	end

	return retVal
end

local function Round(num)
	if (floor(num) + 0.5) < num then
		num = ceil(num)
	else
		num = floor(num)
	end

	return num
end

local orig_GuildRoster_Update
local orig_InspectGuildFrame_Update

function newInspectGuildFrame_Update()
	if InspectFrame.unit == nil or InspectFrame:IsVisible() == false then return end
	orig_InspectGuildFrame_Update()
end

function newGuildRoster_Update()
	orig_GuildRoster_Update()

	local index = GetGuildRosterSelection()
	local name = GetGuildRosterInfo(index)
	local unitGUID = GetGUIDByName(name)

	if unitGUID and UnitItemLevelDB[unitGUID] then
		GuildMemberItemLevelFrameText:SetText(L.TOOLTIP_LV1.."|cffffffff"..(UnitItemLevelDB[unitGUID].equipped or "???").." ("..(UnitItemLevelDB[unitGUID].average or "???")..")", .1, .1, .1)
		GuildMemberItemLevelFrame:Show()
	else
		GuildMemberItemLevelFrameText:SetText(L.TOOLTIP_LV1.."??? (???)", .1, .1, 1)
		GuildMemberItemLevelFrame:Hide()
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local name, unit = self:GetUnit()

	if unit and UnitIsPlayer(unit) then
		local unitGUID = UnitGUID(unit)

		if UnitItemLevelDB[unitGUID] and ( not UnitItemLevelDB[unitGUID].equipped ) then
			UnitItemLevelDB[unitGUID] = nil
		end

		if CheckInteractDistance(unit, 1) and unitGUID ~= UnitGUID("player") and not UnitItemLevelDB[unitGUID] then
			NotifyInspect(unit)
			self:AddLine(" ")
			self:AddLine("|cffff0000"..L.TOOLTIP_LV2)
			self:AddLine("|cffffff00"..L.TOOLTIP_LV3)
		elseif UnitItemLevelDB[unitGUID] then
			local equipped, average = UnitItemLevelDB[unitGUID].equipped or "?", UnitItemLevelDB[unitGUID].average or "?"

			self:AddLine(" ")
			self:AddLine(L.TOOLTIP_LV1.."|cffff8000"..equipped.." |r(|cffff8000"..average.."|r)", 1, 1, 1)
		elseif unit == "player" then
			local equipped, average = GetUnitItemLevel("player"), Round(GetAverageItemLevel())
			self:AddLine(" ")
			self:AddLine(L.TOOLTIP_LV1.."|cffff8000"..equipped.." |r(|cffff8000"..average.."|r)", 1, 1, 1)
		end
	end
end)

local function OnEvent(self, event, ...)
	local isInstance, instanceType = IsInInstance()

	if event == "INSPECT_READY" then
		local unitGUID = select(1, ...)

		UnitItemLevelDB[unitGUID] = { ["equipped"] = GetUnitItemLevelGUID(unitGUID) }
	end

	if event == "UNIT_INVENTORY_CHANGED" then
		local unitID = ...

		if unitID ~= "player" then
			UnitItemLevelDB[UnitGUID(unitID)] = nil
		else
			if IsInGuild() then
				SendAddonMessage("EAILT", UnitGUID("player")..":"..(GetUnitItemLevel("player") or 0)..":"..(Round(GetAverageItemLevel()) or 0), "GUILD")
			end

			if isInstance then
				if instanceType == "raid" then
					SendAddonMessage("EAILT", UnitGUID("player")..":"..(GetUnitItemLevel("player") or 0)..":"..(Round(GetAverageItemLevel()) or 0), "RAID")
				elseif instanceType == "party" then
					SendAddonMessage("EAILT", UnitGUID("player")..":"..(GetUnitItemLevel("player") or 0)..":"..(Round(GetAverageItemLevel()) or 0), "PARTY")
				end
			end

			UnitItemLevelDB[UnitGUID(unitID)] = { ["equipped"] = GetUnitItemLevel("player"), ["average"] = Round(GetAverageItemLevel()) }
		end
	end

	if event == "GUILD_ROSTER_UPDATE" then
		if IsInGuild() and UnitGUID("player") then
			local equipped, average = GetUnitItemLevel("player") or 0, Round(GetAverageItemLevel()) or 0
			SendAddonMessage("EAILT", UnitGUID("player")..":"..equipped..":"..average, "GUILD")
			UnitItemLevelDB[UnitGUID("player")] = { ["equipped"] = GetUnitItemLevel("player"), ["average"] = Round(GetAverageItemLevel()) }
		end
	elseif event == "RAID_ROSTER_UPDATE" then
		if UnitGUID("player") and isInstance and instanceType == "raid" then
			SendAddonMessage("EAILT", UnitGUID("player")..":"..(GetUnitItemLevel("player") or 0)..":"..(Round(GetAverageItemLevel()) or 0), "RAID")
		end
	elseif event == "PARTY_MEMBERS_CHANGED" then
		if UnitGUID("player") and isInstance and instanceType == "party" then
			SendAddonMessage("EAILT", UnitGUID("player")..":"..(GetUnitItemLevel("player") or 0)..":"..(Round(GetAverageItemLevel()) or 0), "PARTY")
		end
	elseif event == "VARIABLES_LOADED" then
		LoadAddOn("Blizzard_GuildUI")
		LoadAddOn("Blizzard_InspectUI")

		orig_GuildRoster_Update = GuildRoster_Update
		GuildRoster_Update = newGuildRoster_Update

		orig_InspectGuildFrame_Update = InspectGuildFrame_Update
		InspectGuildFrame_Update = newInspectGuildFrame_Update

		local iframe = CreateFrame("Frame", "GuildMemberItemLevelFrame", GuildMemberDetailFrame)

		iframe:SetBackdrop(GuildMemberDetailFrame:GetBackdrop())
		iframe:SetSize(GuildMemberDetailFrame:GetWidth(), 50)
		iframe:SetPoint("TOP", GuildMemberDetailFrame, "BOTTOM", 0, -5)
		iframe:Show()
		E.EuiSetTemplate(iframe)

		local txt = iframe:CreateFontString("GuildMemberItemLevelFrameText", "OVERLAY", "GameFontNormalSmall")

		txt:SetSize(iframe:GetWidth()-40, 50)
		txt:SetJustifyH("LEFT")
		txt:SetPoint("LEFT", iframe, "LEFT", 20, 0)
		txt:Show()

		PAPERDOLL_STATINFO["EQUIPPEDILVL"] = {
			updateFunc = function(statFrame, unit)
				PaperDollFrame_SetLabelAndText(statFrame, "Equipped iLvl", GetUnitItemLevel("player"))
				statFrame:Show()
			end
		}
		tinsert(PAPERDOLL_STATCATEGORIES["GENERAL"].stats, 4, "EQUIPPEDILVL")
	end

	if event == "CHAT_MSG_ADDON" then
		local prefix, msg, chan, sender = ...

		if prefix == "EAILT" and sender ~= UnitName("player") then
			local unitGUID, equipped, average = strsplit(":", msg)

			UnitItemLevelDB[unitGUID] = { ["equipped"] = equipped, ["average"] = average }
		end
	end
end

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GUILD_ROSTER_UPDATE")
f:RegisterEvent("VARIABLES_LOADED")

f:SetScript("OnEvent", OnEvent)
