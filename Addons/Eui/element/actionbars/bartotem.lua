-- we just use default totem bar for shaman
-- we parent it to our shapeshift bar.
-- This is approx the same script as it was in WOTLK Eui version.
local E, C = unpack(select(2, ...))

local EUICF = C
local EUIDB = E
local EUIL = L

if EUICF["actionbar"].enable ~= true then return end
if EUIDB.MyClass ~= "SHAMAN" then return end

if MultiCastActionBarFrame then
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame:SetParent(EuiShiftBar)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", EuiShiftBar, "BOTTOMLEFT", -2, -2)

	hooksecurefunc("MultiCastActionButton_Update",function(actionbutton) if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end end)

	MultiCastActionBarFrame.SetParent = EUIDB.dummy
	MultiCastActionBarFrame.SetPoint = EUIDB.dummy
	MultiCastRecallSpellButton.SetPoint = EUIDB.dummy -- bug fix, see http://www.tukui.org/v2/forums/topic.php?id=2405
	
	if EUICF["actionbar"].shapeshiftmouseover == true then
		MultiCastActionBarFrame:SetAlpha(0)
		MultiCastActionBarFrame:HookScript("OnEnter", function() MultiCastActionBarFrame:SetAlpha(1) end)
		MultiCastActionBarFrame:HookScript("OnLeave", function() MultiCastActionBarFrame:SetAlpha(0) end)
	end
end
