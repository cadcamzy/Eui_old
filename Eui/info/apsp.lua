local E, C, L, DB = unpack(EUI)
if C["info"].apsp == 0 or C["info"].enable == false then return end

local StatAPSP = CreateFrame("Frame",nil,UIParent)
StatAPSP:SetAllPoints(EuiLeftStatBackground)
StatAPSP:EnableMouse(true)
E.EuiSetTooltip(StatAPSP, nil, L.INFO_APSP_L1, L.INFO_APSP_R1)
function E.EuiInfoAPSPShow()
	if StatAPSP:IsShown() then StatAPSP:Hide() else StatAPSP:Show() end
end

local int = 1
local stat = 0
local TextAPSP = E.EuiSetFontn(StatAPSP, C["skins"].font, 14)
--TextAPSP:SetParent(StatAPSP)
TextAPSP:SetPoint("CENTER", StatAPSP, 0, 0)

local function UpdateAP(self, t)
	int = int - t
	if E.MyClass ~= "HUNTER" then
		if int < 0 then
			local base, posBuff, negBuff = UnitAttackPower("player");
			local effective = base + posBuff + negBuff;
			TextAPSP:SetText(effective)
			int = 1
		end
	else
		if int < 0 then
			local base, posBuff, negBuff = UnitRangedAttackPower("player");
			local effective = base + posBuff + negBuff;
			TextAPSP:SetText(effective)
			int = 1
		end
	end
end
	
local function UpdateSP(self, t)
	int = int - t
	if int < 0 then
		TextAPSP:SetText(GetSpellBonusDamage(7))
		int = 1
	end
end

if C["info"].apsp == 1 then
	StatAPSP:SetScript("OnUpdate", UpdateAP)
	stat = 1
else
	StatAPSP:SetScript("OnUpdate", UpdateSP)
	stat =2
end
UpdateAP(StatAPSP, 10)

StatAPSP:SetScript("OnMouseDown", function()
	if stat == 1 then
		StatAPSP:SetScript("OnUpdate", UpdateSP)
		stat = 2
	else
		StatAPSP:SetScript("OnUpdate", UpdateAP)
		stat = 1
	end
end)