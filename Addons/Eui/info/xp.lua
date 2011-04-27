local E, C = unpack(select(2, ...))
if C["info"].xp == 0 or C["info"].enable == false then return end
--if UnitLevel("player") == 80 then return end

local xp = CreateFrame ("StatusBar",nil,UIParent)
xp:SetWidth(70)
xp:SetHeight(10)	
xp:SetStatusBarTexture(E.normTex)
xp:EnableMouse(true)

local name = xp:CreateFontString (nil,"OVERLAY")
name:SetFont(E.fontn,12,"OUTLINE")
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("BOTTOMRIGHT",1.3,-4)

local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, "仇恨", "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, "敌对", "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, "冷漠", "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, "中立", "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, "友善", "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, "尊敬", "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, "崇敬", "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, "崇拜","FF9bff9b"},
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
		
		xp:SetStatusBarColor(.7,.7,.9,.2)
		xp:SetMinMaxValues(min(0, XP), maxXP)
		xp:SetValue(XP)	

		--Setup Exp Tooltip
		xp:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("TOPLEFT", xp, "BOTTOMLEFT", -4, -6)
			GameTooltip:ClearLines()
			GameTooltip:AddLine("经验:")
			GameTooltip:AddLine(string.format('当前: %s/%s (%d%%)', CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100))
			GameTooltip:AddLine(string.format('剩余: %s', CommaValue(maxXP-XP)))	
			if restXP then
				GameTooltip:AddLine(string.format('|cffb3e1ff休息: %s (%d%%)', CommaValue(restXP), restXP/maxXP*100))
			end
			if GetWatchedFactionInfo() then
				local name, rank, min, max, value = GetWatchedFactionInfo()
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(string.format('声望: %s', name))
				GameTooltip:AddLine(string.format('等级: |c'..colorize(rank)..'%s|r', FactionInfo[rank][2]))
				GameTooltip:AddLine(string.format('数值: %s/%s (%d%%)', CommaValue(value-min), CommaValue(max-min), (value-min)/(max-min)*100))
				GameTooltip:AddLine(string.format('剩余: %s', CommaValue(max-value)))
			end
			GameTooltip:Show()
		end)
		xp:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
		--Send experience info in chat
		xp:SetScript("OnMouseDown", function()
			if GetNumRaidMembers() > 0 then
				SendChatMessage("我当前经验为: "..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","RAID")
			elseif GetNumPartyMembers() > 0 then
				SendChatMessage("我当前经验为: "..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","PARTY")
			else
				SendChatMessage("我当前经验为: "..CommaValue(XP).."/"..CommaValue(maxXP).." ("..floor((XP/maxXP)*100).."%) .","SAY")
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
			xp:SetStatusBarColor(unpack(FactionInfo[rank][1]))
			xp:SetMinMaxValues(min, max)
			xp:SetValue(value)
			--Setup Exp Tooltip
			xp:SetScript("OnEnter", function()
                GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("TOPLEFT", xp, "BOTTOMLEFT", -4, -6)
			    GameTooltip:ClearLines()
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(string.format('声望: %s', name2))
				GameTooltip:AddLine(string.format('等级: |c'..colorize(rank)..'%s|r', FactionInfo[rank][2]))
				GameTooltip:AddLine(string.format('数值: %s/%s (%d%%)', CommaValue(value-min), CommaValue(max-min), (value-min)/(max-min)*100))
				GameTooltip:AddLine(string.format('剩余: %s', CommaValue(max-value)))
    			GameTooltip:Show()
			end)
			xp:SetScript("OnLeave", function() GameTooltip:Hide() end)
		else
			name:SetText("Null")
			xp:SetStatusBarColor(0,0,0)
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