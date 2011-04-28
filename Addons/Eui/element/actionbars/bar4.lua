local E, C = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- setup MultiBarRight as bar #4
---------------------------------------------------------------------------

local EuiBar4 = CreateFrame("Frame","EuiBar4",EuiActionBarBackground) -- bottomrightbar
EuiBar4:SetAllPoints(EuiActionBarBackground)
MultiBarRight:SetParent(EuiBar4)

function E.PositionBar4()
	for i= 1, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:ClearAllPoints()
		b:SetAlpha(1)
		b:Show()
		EuiBar4:SetParent(EuiActionBarBackgroundRight)
		if E.actionbar.bottomrows == 3 then
			if i == 1 then
				if C["actionbar"].swaptopbottombar == true then
					b:SetPoint("TOP", MultiBarBottomLeftButton1, "BOTTOM", 0, -E.buttonspacing)
				else
					b:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOP", 0, E.buttonspacing)
				end
			else
				b:SetPoint("LEFT", b2, "RIGHT", E.buttonspacing, 0)
			end
			EuiBar4:SetParent(EuiActionBarBackground)
		elseif E.actionbar.bottomrows ~= 3 and E.actionbar.rightbars > 1 then
			if i == 1 then
				if E.actionbar.rightbars == 2 then
					b:SetPoint("TOPRIGHT", EuiActionBarBackgroundRight, "TOPRIGHT", -E.buttonspacing, -E.buttonspacing)
				else
					b:SetPoint("TOP", EuiActionBarBackgroundRight, "TOP", 0, -E.buttonspacing)
				end
			else
				b:SetPoint("TOP", b2, "BOTTOM", 0, -E.buttonspacing)
			end		
		else
			if i == 1 then
				b:SetPoint("TOPRIGHT", EuiActionBarBackgroundRight, "TOPRIGHT", -E.buttonspacing, -E.buttonspacing)
			else
				b:SetPoint("TOP", b2, "BOTTOM", 0, -E.buttonspacing)
			end	
		end
		
		--Setup Mouseover
		if C["actionbar"].rightbarmouseover == true and not (E.actionbar.bottomrows == 3) then
			b:SetAlpha(0)
			b:HookScript("OnEnter", function() RightBarMouseOver(1) end)
			b:HookScript("OnLeave", function() RightBarMouseOver(0) end)
		end
	end

	-- hide it if needed
	if E.actionbar.rightbars < 1 and not (((E.actionbar.bottomrows == 3) or (E.actionbar.bottomrows ~= 3 and E.actionbar.rightbars > 1)) or (E["actionbar"].bottomrows == 2 and E["actionbar"].rightbars == 2) or (C["actionbar"].rightbar == 2 and E["actionbar"].bottomrows > 1 and E["actionbar"].splitbar == true)) or (E["actionbar"].bottomrows == 2 and E["actionbar"].rightbars == 2 and E["actionbar"].splitbar ~= true) then
		EuiBar4:Hide()
	else
		EuiBar4:Show()
	end
end
