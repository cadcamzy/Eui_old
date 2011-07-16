local E, C, L = unpack(EUI)
if E.MyClass ~= "DEATHKNIGHT" or C["class"].dk ~= true then return end

local BS_SPELL = (GetSpellInfo(77535))
local bs = CreateFrame("Frame", nil, UIParent)
bs.text = E.EuiSetFontn(bs, E.font, 14)
bs.text:SetPoint("BOTTOMLEFT",bs,"TOPLEFT",0, 2)
bs.text:SetText("")

local bstime = CreateFrame("Cooldown", nil, bs)
bstime:SetAllPoints(bs)

bs:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
bs:RegisterEvent("PLAYER_LOGIN")

function bs:PLAYER_LOGIN()
	if E.portrait == nil then return end
	bs:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	bs:UnregisterEvent("PLAYER_LOGIN")
	if C["unitframe"].aaaaunit == 2 then
		bs:SetPoint("CENTER", E.portrait, "CENTER", 5, 0)
		bs:SetSize(C["unitframe"].playerheight,C["unitframe"].playerheight)
		bs.text:ClearAllPoints()
		bs.text:SetPoint("LEFT",bs,"RIGHT",4,0)
		bs:SetFrameLevel(E.portrait:GetFrameLevel()+5)
	else
		bs:SetAllPoints(E.portrait)
	end
	
end

function bs:COMBAT_LOG_EVENT_UNFILTERED(...)
	local timestamp, eventtype, hideCaster, 
        srcGUID, srcName, srcFlags,  
        destGUID, destName, destFlags, 
        param9, param10, param11, param12, param13, param14, 
        param15, param16, param17, param18, param19, param20 = ...
		
	if eventtype == "SPELL_AURA_APPLIED" and destName == E.MyName then
		if param10 and param13 then
			if param10 == BS_SPELL then
				local abr = param13 or ""
				bs.text:SetText(abr)
				local _,_,_,_,_,duration,expiration = UnitBuff("player", BS_SPELL)
				bstime:SetCooldown(GetTime(), duration);
			end
		end
	end
	
	if eventtype == "SPELL_AURA_REFRESH" and destName == E.MyName then
		if param10 and param13 then
			if param10 == BS_SPELL then
				bs.text:SetText(param13)
				local _,_,_,_,_,duration,expiration = UnitBuff("player", BS_SPELL)
				bstime:SetCooldown(GetTime(), duration);
			end
		end
	end
	
	if eventtype == "SPELL_AURA_REMOVED" and destName == E.MyName then
		if param10 and param13 then
			if param10 == BS_SPELL then
				bs.text:SetText("")
				bstime:SetCooldown(0,0)
			end
		end
	end	
end