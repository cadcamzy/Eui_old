local E, C, L, DB = unpack(EUI)
if C["info"].dps == 0 or C["info"].enable == false then return end

local StatDPS = CreateFrame("Frame",nil,UIParent)
StatDPS:SetAllPoints(EuiRightStatBackground)

function E.EuiInfoDPSShow()
	if StatDPS:IsShown() then StatDPS:Hide() else StatDPS:Show() end
end

if C["info"].dps == 1 then
    local events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
    local player_id = UnitGUID("player")
    local dmg_total, last_dmg_amount = 0, 0
    local cmbt_time = 0

    local pet_id = UnitGUID("pet")
     
	local Text = E.EuiSetFontn(StatDPS, C["skins"].font, 14)
    Text:SetText("0.0")
	
	Text:SetPoint("CENTER", StatDPS, 0, 0)
    
    StatDPS:EnableMouse(true)
    StatDPS:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
    StatDPS:RegisterEvent("PLAYER_LOGIN")

    StatDPS:SetScript("OnUpdate", function(self, elap)
        if UnitAffectingCombat("player") then
			cmbt_time = cmbt_time + elap
			if cmbt_time > 0 and Text:GetText() == "0.0" then
				CombatLogClearEntries()
			end
        end
       
        Text:SetText(getDPS())
    end)
     
    function StatDPS:PLAYER_LOGIN()
		StatDPS:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		StatDPS:RegisterEvent("PLAYER_REGEN_ENABLED")
		StatDPS:RegisterEvent("PLAYER_REGEN_DISABLED")
		StatDPS:RegisterEvent("UNIT_PET")
    
		player_id = UnitGUID("player")
       
		StatDPS:UnregisterEvent("PLAYER_LOGIN")
    end
     
    function StatDPS:UNIT_PET(unit)
		if unit == "player" then
			pet_id = UnitGUID("pet")
		end
	end
     
    -- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
    function StatDPS:COMBAT_LOG_EVENT_UNFILTERED(...)		   
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end

		-- only use events from the player
		local id = select(4, ...)
		   
		if id == player_id or id == pet_id then
			if select(2, ...) == "SWING_DAMAGE" then
				last_dmg_amount = select(10, ...)
			else
				last_dmg_amount = select(13, ...)
			end
			
		--	if select(10, ...) == 77535 then print("77535") end
			
			dmg_total = dmg_total + last_dmg_amount
		end       
    end
     
    function getDPS()
        if (dmg_total == 0) then
			return ("0.0 ")
        else
			return string.format("%.1f ", (dmg_total or 0) / (cmbt_time or 1))
        end
    end

     
    function StatDPS:PLAYER_REGEN_ENABLED()
        Text:SetText(getDPS())
    end
	
	function StatDPS:PLAYER_REGEN_DISABLED()
        cmbt_time = 0
        dmg_total = 0
        last_dmg_amount = 0
    end
     
    StatDPS:SetScript("OnMouseDown", function (self, button, down)
        cmbt_time = 0
        dmg_total = 0
        last_dmg_amount = 0
    end)
end

--------------------------------------------------------------------
-- SUPPORT FOR HPS Feed... 
--------------------------------------------------------------------

if C["info"].dps == 2 then
	local events = {SPELL_HEAL = true, SPELL_PERIODIC_HEAL = true}
	local player_id = UnitGUID("player")
	local actual_heals_total, cmbt_time = 0
 
	local hText = E.EuiSetFontn(StatDPS, C["skins"].font, 14)
	hText:SetText("0.0")
	hText:SetPoint("CENTER", StatDPS, 0, 0)
 
	StatDPS:EnableMouse(true)
	StatDPS:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
	StatDPS:RegisterEvent("PLAYER_LOGIN")
 
	StatDPS:SetScript("OnUpdate", function(self, elap)
		if UnitAffectingCombat("player") then
			StatDPS:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			cmbt_time = cmbt_time + elap
			if cmbt_time > 0 and hText:GetText() == "0.0" then
				CombatLogClearEntries()
			end
		else
			StatDPS:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
		hText:SetText(get_hps())
	end)
 
	function StatDPS:PLAYER_LOGIN()
		StatDPS:RegisterEvent("PLAYER_REGEN_ENABLED")
		StatDPS:RegisterEvent("PLAYER_REGEN_DISABLED")
 
		player_id = UnitGUID("player")
     
		StatDPS:UnregisterEvent("PLAYER_LOGIN")
	end
 
  -- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function StatDPS:COMBAT_LOG_EVENT_UNFILTERED(...)         
     -- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end
		if event == "PLAYER_REGEN_DISABLED" then return end

     -- only use events from the player
		local id = select(4, ...)
		if id == player_id then
			amount_healed = select(14, ...)
			amount_over_healed = select(15, ...)
       -- add to the total the healed amount subtracting the overhealed amount
			actual_heals_total = actual_heals_total + math.max(0, amount_healed - amount_over_healed)
		end
	end
 
	function StatDPS:PLAYER_REGEN_ENABLED()
		hText:SetText(get_hps)
	end
   
	function StatDPS:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		actual_heals_total = 0
	end
     
	StatDPS:SetScript("OnMouseDown", function (self, button, down)
		cmbt_time = 0
		actual_heals_total = 0
	end)
 
	function get_hps()
		if (actual_heals_total == 0) then
			return ("0.0 ")
		else
			return string.format("%.1f ", (actual_heals_total or 0) / (cmbt_time or 1))
		end
	end

end