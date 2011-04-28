local E, C = unpack(select(2, ...))
local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local function colorGuildRank(rankIndex)
	local r, g, b = 1, 1, 1
	local pct = rankIndex / GuildControlGetNumRanks()
	if pct <= 1.0 and pct >= 0.5 then
		r, g, b = (1.0-pct)*2, 1, 0
	elseif pct >= 0 and pct < 0.5 then
		r, g, b = 1, pct*2, 0
	end
	return r, g, b
end

local function colorCode(color)
	return format("|CFF%2x%2x%2x", color.r*255, color.g*255, color.b*255)
end

hooksecurefunc("GuildStatus_Update", function()
	local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
	local myZone = GetRealZoneText()
    local name, rankIndex, level, zone, online, classFileName
    local color, zcolor, lcolor, r, g, b

	for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
		name, _, rankIndex, level, _, zone, _, _, online, _, classFileName = GetGuildRosterInfo(guildOffset + i)
		if not name then break end

		color = E.RAID_CLASS_COLORS[classFileName] or NORMAL_FONT_COLOR
        zcolor = zone == myZone and GREEN_FONT_COLOR or HIGHLIGHT_FONT_COLOR
		lcolor = GetQuestDifficultyColor(level) or HIGHLIGHT_FONT_COLOR
		r, g, b = colorGuildRank(rankIndex)

		if online then
			_G["GuildFrameButton"..i.."Name"]:SetTextColor(color.r, color.g, color.b)
			_G["GuildFrameButton"..i.."Zone"]:SetTextColor(zcolor.r, zcolor.g, zcolor.b)
			_G["GuildFrameButton"..i.."Level"]:SetTextColor(lcolor.r, lcolor.g, lcolor.b)
			_G["GuildFrameGuildStatusButton"..i.."Name"]:SetTextColor(color.r, color.g, color.b)
			_G["GuildFrameGuildStatusButton"..i.."Rank"]:SetTextColor(r, g, b)
		else
			_G["GuildFrameButton"..i.."Name"]:SetTextColor(color.r/2, color.g/2, color.b/2)
			_G["GuildFrameButton"..i.."Zone"]:SetTextColor(zcolor.r/2, zcolor.g/2, zcolor.b/2)
			_G["GuildFrameButton"..i.."Level"]:SetTextColor(lcolor.r/2, lcolor.g/2, lcolor.b/2)
			_G["GuildFrameGuildStatusButton"..i.."Name"]:SetTextColor(color.r/2, color.g/2, color.b/2)
			_G["GuildFrameGuildStatusButton"..i.."Rank"]:SetTextColor(r/2, g/2, b/2)
		end
	end
end)


hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	local menu = UIDropDownMenu_GetSelectedID(WhoFrameDropDown)
	local myZone = GetRealZoneText()
	local myGuild = GetGuildInfo("player")
	local myRace = UnitRace("player")
	local myInfo = { myZone, myGuild, myRace }
	local name, guild, level, race, zone, classFileName, columnTable, color

	for i=1, WHOS_TO_DISPLAY, 1 do
		name, guild, level, race, _, zone, classFileName = GetWhoInfo(whoOffset + i)
		if not name then break end

		color = E.RAID_CLASS_COLORS[classFileName] or NORMAL_FONT_COLOR
		_G["WhoFrameButton"..i.."Name"]:SetTextColor(color.r, color.g, color.b)

		color = GetQuestDifficultyColor(level) or HIGHLIGHT_FONT_COLOR
		_G["WhoFrameButton"..i.."Level"]:SetTextColor(color.r, color.g, color.b)

		columnTable = { zone, guild, race }
		color = columnTable[menu] == myInfo[menu] and GREEN_FONT_COLOR or HIGHLIGHT_FONT_COLOR
		_G["WhoFrameButton"..i.."Variable"]:SetTextColor(color.r, color.g, color.b)
	end
end)


hooksecurefunc(FriendsFrameFriendsScrollFrame, "buttonFunc", function(button, index, fristButton)
	local nameText, infoText
	local myZone = GetRealZoneText()

	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local name, level, class, area, connected = GetFriendInfo(button.id)
		if connected then
		    local color = E.RAID_CLASS_COLORS[BC[class]] or NORMAL_FONT_COLOR
		    local lcolor = GetQuestDifficultyColor(level) or HIGHLIGHT_FONT_COLOR
		    nameText = colorCode(color) .. name .. "|r, " .. LEVEL .. colorCode(lcolor) .. level .. "|r " .. colorCode(color) .. class .. "|r"
		    if area == myZone then
				infoText = format("|cff00ff00%s|r", area)
			end
		end
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local _, givenName, surname, toonName, toonID, client, isOnline = BNGetFriendInfo(button.id)
		if isOnline and client == BNET_CLIENT_WOW then
			local _, toonName, _, _, _, _, class, _, zoneName = BNGetToonInfo(toonID)
			if givenName and surname and toonName then
				local color = E.RAID_CLASS_COLORS[BC[class]] or NORMAL_FONT_COLOR
				nameText = format(BATTLENET_NAME_FORMAT, givenName, surname) .." ".. FRIENDS_WOW_NAME_COLOR_CODE .. "(" .. colorCode(color) .. toonName .. "|r" .. FRIENDS_WOW_NAME_COLOR_CODE .. ")"
				if zoneName == myZone then
					infoText = format("|cff00ff00%s|r", zoneName)
				end
			end
		end
	end
    if nameText then button.name:SetText(nameText) end
    if infoText then button.info:SetText(infoText) end
end)


hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, _, _, _, _, _, class = SearchLFGGetResults(index)
	local color
	if name ~= UnitName("player") then
		color = E.RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
		button.name:SetTextColor(color.r, color.g, color.b)
		color = GetQuestDifficultyColor(level) or HIGHLIGHT_FONT_COLOR
		button.level:SetTextColor(color.r, color.g, color.b)
	end
end)


hooksecurefunc("WorldStateScoreFrame_Update", function()
	local isArena = IsActiveBattlefieldArena()
	local numScores = GetNumBattlefieldScores()
    local name, faction, classToken, index, color, n, s

	for i=1, MAX_WORLDSTATE_SCORE_BUTTONS do
		index = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame) + i
        if index <= numScores then
            name, _, _, _, _, faction, _, _, _, classToken = GetBattlefieldScore(index)
            if name and classToken then
                color = E.RAID_CLASS_COLORS[classToken]
                _G["WorldStateScoreButton" .. i .. "NameText"]:SetTextColor(color.r, color.g, color.b)
                n, s = strsplit("-", name, 2)
                if n == UnitName("player") then
                    n = "> " .. n .. " <"
                end
                if s then
                    if isArena then
                        n = n.."|cffffffff-|r"..(faction==0 and "|cff20ff20" or "|cffffd200")..s.."|r"
                    else
                        n = n.."|cffffffff-|r"..(faction==0 and "|cffff2020" or "|cff00aef0")..s.."|r"
                    end
                end
                _G["WorldStateScoreButton" .. i .. "NameText"]:SetText(n)
            end
        end
	end
end)


hooksecurefunc("PVPTeamDetails_Update", function(id)
	local numMembers = GetNumArenaTeamMembers(id, 1)
    local teamPlayed = select(4, GetArenaTeam(id))
	local name, rank, class, online, played, ncolor, ccolor, pcolor, playedPct

    for i=1, numMembers, 1 do
        name, rank, _, class, online, played = GetArenaTeamRosterInfo(id, i)
        ncolor = rank == 0 and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR
        ccolor = E.RAID_CLASS_COLORS[BC[class]] or NORMAL_FONT_COLOR
        pcolor = teamPlayed >= 10 and played/teamPlayed >= 0.3 and GREEN_FONT_COLOR or RED_FONT_COLOR
        if name == UnitName("player") then
            _G["PVPTeamDetailsButton"..i.."NameText"]:SetText("|cff00ff00@ |r"..name)
        end
		if online then
		    _G["PVPTeamDetailsButton"..i.."NameText"]:SetTextColor(ncolor.r, ncolor.g, ncolor.b)
            _G["PVPTeamDetailsButton"..i.."ClassText"]:SetTextColor(ccolor.r, ccolor.g, ccolor.b)
            if not PVPTeamDetails.season then
                _G["PVPTeamDetailsButton"..i.."PlayedText"]:SetTextColor(pcolor.r, pcolor.g, pcolor.b)
            end
		else
	    	_G["PVPTeamDetailsButton"..i.."NameText"]:SetTextColor(ncolor.r/2, ncolor.g/2, ncolor.b/2)
            _G["PVPTeamDetailsButton"..i.."ClassText"]:SetTextColor(ccolor.r/2, ccolor.g/2, ccolor.b/2)
            if not PVPTeamDetails.season then
                _G["PVPTeamDetailsButton"..i.."PlayedText"]:SetTextColor(pcolor.r/2, pcolor.g/2, pcolor.b/2)
            end
		end
	end
end)