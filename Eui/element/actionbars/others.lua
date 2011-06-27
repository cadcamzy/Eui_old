local E, C = unpack(EUI) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local EuiOnLogon = CreateFrame("Frame")
EuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
EuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")	
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)
--[[ 	if C["actionbar"].rankwatch == true then
		if not lasttime then lasttime =0 end
		if (GetTime() - lasttime) > 300 then
			for i=1,72 do
				local a,_,c,d = GetActionInfo(i)
				if a=="spell" and c=="spell" then
					local name,rank=GetSpellInfo(d)
					local _,maxrank = GetSpellInfo(name)
					if rank~=maxrank then
						print("警告:"..name.."不是最高等级")
						print("将自动调整"..name.."为最高等级")
						PickupSpell(name);
						PlaceAction(i);
						ClearCursor(); 						
						lasttime = GetTime()
					end
				end
			end
		end
	end	 ]]
	if C["actionbar"].showgrid == true then
		ActionButton_HideGrid = E.dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("BonusActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)