local E, C = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local EuiBar2 = CreateFrame("Frame","EuiBar2",EuiActionBarBackground)
EuiBar2:SetAllPoints(EuiActionBarBackground)
MultiBarBottomLeft:SetParent(EuiBar2)

function E.PositionBar2()
	for i=1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:ClearAllPoints()
		if i == 1 then
			if C["actionbar"].swaptopbottombar == true then
				b:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -E.buttonspacing)
			else
				b:SetPoint("BOTTOM", ActionButton1, "TOP", 0, E.buttonspacing)
			end
		else
			b:SetPoint("LEFT", b2, "RIGHT", E.buttonspacing, 0)
		end
	end
	-- hide it if needed
	if E.actionbar.bottomrows == 1 then
		EuiBar2:Hide()
	else
		EuiBar2:Show()
	end
end
