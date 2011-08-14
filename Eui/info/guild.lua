local E, C, L, DB = unpack(EUI)
if C["info"].guild == 0 or C["info"].enable == false then return end
--if UnitLevel("player") == 80 then return end

local guild = CreateFrame ("Frame",nil,EuiTopInfobg)
guild:SetWidth(70)
guild:SetHeight(16)	
guild:EnableMouse(true)


local tthead = {r=0.4,g=0.78,b=1}
local ttsubh = {r=0.75,g=0.9,b=1}
	
local name = guild:CreateFontString(nil,"OVERLAY")
name:SetFont(C["skins"].font,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)
guild.name = name

function guild:ShowBar()
	if IsInGuild() then
		GuildRoster()
		local numOnline = (GetNumGuildMembers())
	--	name:SetText("公会:"..numOnline)
		local online, total, gmotd = 0, GetNumGuildMembers(true), GetGuildRosterMOTD()
		for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end
	--	guild:SetStatusBarColor(75/255,  175/255, 75/255)
	--	guild:SetMinMaxValues(min(0, online), total)
	--	guild:SetValue(online)
		name:SetText(L.INFO_GUILD_TIP1..":"..online)
	else
		name:SetText(L.INFO_GUILD_TIP1)
	--	guild:SetStatusBarColor(0,0,0,0)
	end
	
	
	guild:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			if IsInGuild() then
				GuildRoster()
				local name, rank, level, zone, note, officernote, connected, status, class, zone_r, zone_g, zone_b, classc, levelc
				local online, total, gmotd = 0, GetNumGuildMembers(true), GetGuildRosterMOTD()
				for i = 0, total do if select(9, GetGuildRosterInfo(i)) then online = online + 1 end end
			--	guild:SetStatusBarColor(75/255,  175/255, 75/255)
			--	guild:SetMinMaxValues(min(0, online), total)
			--	guild:SetValue(online)
				
				GameTooltip:SetOwner(guild, "ANCHOR_BOTTOMRIGHT");				
				
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(GetGuildInfo'player',format("%s: %d/%d",L.INFO_GUILD_TIP1,online,total),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
				GameTooltip:AddLine' '
				if gmotd ~= "" then GameTooltip:AddLine(format("  %s |cffaaaaaa- |cffffffff%s",GUILD_MOTD,gmotd),ttsubh.r,ttsubh.g,ttsubh.b,1) end
				if online > 1 then
					GameTooltip:AddLine' '
					for i = 1, total do
						if online <= 1 then
							if online > 1 then GameTooltip:AddLine(format(L.INFO_GUILD_TIP2, online - modules.Guild.maxguild),ttsubh.r,ttsubh.g,ttsubh.b) end
							break
						end
						-- name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName
						name, rank, _, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
						if connected and name ~= UnitName'player' then
							if GetRealZoneText() == zone then zone_r, zone_g, zone_b = 0.3, 1.0, 0.3 else zone_r, zone_g, zone_b = 0.65, 0.65, 0.65 end
							classc, levelc = (CUSTOM_CLASS_COLORS or E.RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
							if IsShiftKeyDown() then
								GameTooltip:AddDoubleLine(name.." |cff999999- |cffffffff"..rank,zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
								if note ~= "" then GameTooltip:AddLine('  "'..note..'"',ttsubh.r,ttsubh.g,ttsubh.b,1) end
								if officernote ~= "" then GameTooltip:AddLine("  o: "..officernote,0.3,1,0.3,1) end
							else
								GameTooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s",levelc.r*255,levelc.g*255,levelc.b*255,level,name,' '..status),zone,classc.r,classc.g,classc.b,zone_r,zone_g,zone_b)
							end
						end
					end
				end
				GameTooltip:Show()
			end
		end
	end)
	guild:SetScript("OnLeave", function() GameTooltip:Hide() end)
	guild:SetScript("OnMouseDown", function() 
		if IsInGuild() then
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end)	
end

-- Event Stuff -----------
--------------------------
local frame = CreateFrame("Frame",nil,UIParent)
frame:RegisterEvent("GUILD_ROSTER_SHOW")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_GUILD_UPDATE")
frame:RegisterEvent("FRIENDLIST_UPDATE")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function()
	guild:ShowBar()
end)

E.EuiInfo(C["info"].guild,guild)