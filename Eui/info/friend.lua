local E, C, L, DB = unpack(EUI)
if C["info"].friend == 0 or C["info"].enable == false then return end
--if UnitLevel("player") == 80 then return end

local friend = CreateFrame ("Frame",nil,UIParent)
friend:SetWidth(70)
friend:SetHeight(16)	
friend:EnableMouse(true)

local tthead = {r=0.4,g=0.78,b=1}
local ttsubh = {r=0.75,g=0.9,b=1}

local name = friend:CreateFontString (nil,"OVERLAY")
name:SetFont(C["skins"].font,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)

function friend:ShowBar()
	local total, online = GetNumFriends()
	local totalBNet, numBNetOnline = BNGetNumFriends()
	
	name:SetText("好友"..":"..online+numBNetOnline)
--	friend:SetStatusBarColor(170/255, 70/255,  70/255)
--	friend:SetMinMaxValues(min(0, online), total)
--	friend:SetValue(online)
	
	friend:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			ShowFriends()
			self.hovered = true
			local total, online = GetNumFriends()
			local name, level, class, zone, connected, status, note, classc, levelc, zone_r, zone_g, zone_b, grouped
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:ClearLines()
			if online > 0 then
				GameTooltip:AddDoubleLine(L.INFO_FRIEND_TIP1, format(L.INFO_FRIEND_TIP2 .. "%s/%s",online+numBNetOnline,total+totalBNet),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				-- name, level, class, area, connected, status, note
				for i = 1, total do
					name, level, class, zone, connected, status, note = GetFriendInfo(i)
					if not connected then break end
					if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
					for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
					if GetLocale() ~= "enUS" then -- feminine class localization (unsure if it's really needed)
						for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
					end
					classc, levelc = (CUSTOM_CLASS_COLORS or E.RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
					if UnitInParty(name) or UnitInRaid(name) then grouped = "|cffaaaaaa*|r" else grouped = "" end
					GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,grouped," "..status),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
					if self.altdown and note then GameTooltip:AddLine("  "..note,ttsubh.r,ttsubh.g,ttsubh.b,1) end
				end
				GameTooltip:Show()
			end
			
			local totalBNet, numBNetOnline = BNGetNumFriends()
			if numBNetOnline > 0 then
				GameTooltip:AddLine' '
				local presenceID, givenName, surname, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level
				local groupedTable = { "|cffaaaaaa*|r", "" } 
				for i = 1, totalBNet do
					presenceID, givenName, surname, toonName, toonID, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
					if isOnline then
						_, _, _, realmName, _, faction, race, class, _, zoneName, level = BNGetToonInfo(presenceID)
						if client == "WoW" then
							if (isAFK == true) then status = "AFK" elseif (isDND == true) then status = "DND" else status = "" end
							classc, levelc = (RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(zoneName)
							if classc == nil then classc = GetQuestDifficultyColor(zoneName) end
							if UnitInParty(toonName) or UnitInRaid(toonName) then grouped = 1 else grouped = 2 end
							GameTooltip:AddDoubleLine(format("%s |cff%02x%02x%02x(%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r", client,levelc.r*255,levelc.g*255,levelc.b*255,zoneName,classc.r*255,classc.g*255,classc.b*255,toonName,groupedTable[grouped], 255, 0, 0, status),surname.." "..givenName,238,238,238,238,238,238)
						else
							GameTooltip:AddDoubleLine(format("%s (%s)", client, toonName), format("%s %s", surname,givenName), .9, .9, .9, .9, .9, .9)
						end
					end
				end
				GameTooltip:Show()
			end
			if online == 0 and numBNetOnline == 0 then GameTooltip:Hide() end
		end		
	end)
	friend:SetScript("OnMouseDown", function() ToggleFriendsFrame(1) end)
	friend:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Event Stuff -----------
--------------------------
local frame = CreateFrame("Frame",nil,UIParent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("FRIENDLIST_UPDATE")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function()
	friend:ShowBar()
end)

EuiTopInfobg.friend = friend
E.EuiInfo(C["info"].friend,friend)