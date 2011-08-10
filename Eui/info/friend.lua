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
name:SetFont(E.fontn,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)

function friend:ShowBar()
	local online, total = 0, GetNumFriends()
	for i = 0, total do
		if select(5, GetFriendInfo(i)) then
			online = online + 1
		end
	end
	name:SetText("好友"..":"..online)
--	friend:SetStatusBarColor(170/255, 70/255,  70/255)
--	friend:SetMinMaxValues(min(0, online), total)
--	friend:SetValue(online)
	
	friend:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			ShowFriends()
			self.hovered = true
			local online, total = 0, GetNumFriends()
			local name, level, class, zone, connected, status, note, classc, levelc, zone_r, zone_g, zone_b, grouped
			for i = 0, total do if select(5, GetFriendInfo(i)) then online = online + 1 end end
		--	friend:SetStatusBarColor(170/255, 70/255,  70/255)
		--	friend:SetMinMaxValues(min(0, online), total)
		--	friend:SetValue(online)
			if online > 0 then
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(L.INFO_FRIEND_TIP1, format(L.INFO_FRIEND_TIP2 .. "%s/%s",online,total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
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
			else GameTooltip:Hide() end
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

E.EuiInfo(C["info"].friend,friend)