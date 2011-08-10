local E, C, L, DB = unpack(EUI)
if C["info"].xp == 0 or C["info"].enable == false then return end
--if UnitLevel("player") == 80 then return end

local xp = CreateFrame ("Frame",nil,UIParent)
xp:SetWidth(70)
xp:SetHeight(16)	
xp:EnableMouse(true)

local name = xp:CreateFontString (nil,"OVERLAY")
name:SetFont(E.fontn,13)
name:SetJustifyH("RIGHT")
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)

local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, L.INFO_XP_FACTION1, "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, L.INFO_XP_FACTION2, "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, L.INFO_XP_FACTION3, "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, L.INFO_XP_FACTION4, "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, L.INFO_XP_FACTION5, "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, L.INFO_XP_FACTION6, "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, L.INFO_XP_FACTION7, "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, L.INFO_XP_FACTION8,"FF9bff9b"},
}

local ShortValue = function(value)
	if value >= 1e3 or value <= -1e3 then
		return ("%.0fk"):format(value / 1e3):gsub("%.?+([km])$", "%1")
	else
		return value
	end
end

local function CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local function colorize(r)
	return FactionInfo[r][3]
end


function xp.ShowBar()
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()
		local percXP = floor(XP/maxXP*100)
		local str
		--Setup Text
		if restXP then
			str = format("%s%%|cffb3e1ff+%d%%|r", percXP, restXP/maxXP*100)
		else
			str = format("%s%%", percXP)
		end
		name:SetText(str)
		--Setup Bar
		
	--	xp:SetStatusBarColor(.7,.7,.9,.2)
	--	xp:SetMinMaxValues(min(0, XP), maxXP)
	--	xp:SetValue(XP)	

		--Setup Exp Tooltip
		xp:SetScript("OnEnter", function()
			GameTooltip:SetOwner(xp, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L.INFO_XP_FACTION_TIP1)
			GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP2, CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100))
			GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP3, CommaValue(maxXP-XP)))	
			if restXP then
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP4, CommaValue(restXP), restXP/maxXP*100))
			end
			if GetWatchedFactionInfo() then
				local name, rank, min, max, value = GetWatchedFactionInfo()
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP5, name))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP6..colorize(rank)..'%s|r', FactionInfo[rank][2]))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP7, CommaValue(value-min), CommaValue(max-min), (value-min)/(max-min)*100))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP8, CommaValue(max-value)))
			end
			GameTooltip:Show()
		end)
		xp:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		--Send experience info in chat
		xp:SetScript("OnMouseDown", function()
			if GetNumRaidMembers() > 0 then
				SendChatMessage(L.INFO_XP_FACTION_TIP9..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","RAID")
			elseif GetNumPartyMembers() > 0 then
				SendChatMessage(L.INFO_XP_FACTION_TIP9..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","PARTY")
			else
				SendChatMessage(L.INFO_XP_FACTION_TIP9..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","SAY")
			end
		end)
	else
		if GetWatchedFactionInfo() then
			local name2, rank, min, max, value = GetWatchedFactionInfo()
			local str
			--Setup Text
			str = format("%d (%d%%)", value-min, (value-min)/(max-min)*100)
			name:SetText(str)
			--Setup Bar
		--	xp:SetStatusBarColor(unpack(FactionInfo[rank][1]))
		--	xp:SetMinMaxValues(min, max)
		--	xp:SetValue(value)
			--Setup Exp Tooltip
			xp:SetScript("OnEnter", function()
				GameTooltip:SetOwner(xp, "ANCHOR_BOTTOMRIGHT");
			    GameTooltip:ClearLines()
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP5, name2))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP6..colorize(rank)..'%s|r', FactionInfo[rank][2]))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP7, CommaValue(value-min), CommaValue(max-min), (value-min)/(max-min)*100))
				GameTooltip:AddLine(string.format(L.INFO_XP_FACTION_TIP8, CommaValue(max-value)))
    			GameTooltip:Show()
			end)
			xp:SetScript("OnLeave", function() GameTooltip:Hide() end)
		else
			name:SetText("Null")
		--	xp:SetStatusBarColor(0,0,0)
			--xp:SetStatusBarColor(.7,.7,.9,.2)
		end
		
	end
end

-- Event Stuff -----------
--------------------------
local frame = CreateFrame("Frame",nil,UIParent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_FACTION");
frame:RegisterEvent("PLAYER_XP_UPDATE");
frame:RegisterEvent("UPDATE_EXHAUSTION");
frame:SetScript("OnEvent", function()
	xp.ShowBar()
end)

E.EuiInfo(C["info"].xp,xp)