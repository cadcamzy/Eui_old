local EuiWatchFrame = CreateFrame("Frame", "EuiWatchFrame", UIParent)

Local E, C, L = unpack(EUI) -- Import Functions/Constants, Config, Locales
local wideFrame = GetCVar("watchFrameWidth")

local WatchFrameHolder = CreateFrame("Frame", "WatchFrameHolder", UIParent)
WatchFrameHolder:SetWidth(130)
WatchFrameHolder:SetHeight(22)


local function init()
	EuiWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	EuiWatchFrame:RegisterEvent("CVAR_UPDATE")
	EuiWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
		SetCVar("watchFrameWidth", 0)
		EuiWatchFrame:SetWidth(250)
		InterfaceOptionsObjectivesPanelWatchFrameWidth:Hide()
	end)
	
	EuiWatchFrame:ClearAllPoints()
	EuiWatchFrame:SetPoint("TOP", WatchFrameHolder, "TOP", 0, 0)
end

function E.PostWatchMove()
	if E.Movers["WatchFrameMover"]["moved"] == false then
		E.PositionWatchFrame()
	end
end

function E.PositionWatchFrame()
	if fired == true and E.Movers["WatchFrameMover"]["moved"] == true then return end
	
	if WatchFrameMover then
		if E.Movers["WatchFrameMover"]["moved"] == true then return end

		WatchFrameMover:ClearAllPoints()
		if C["actionbar"].rightbar == 2 then
			WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-190), E.Scale(-300))
		elseif C["actionbar"].rightbar == 1 then
			WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-160), E.Scale(-300))
		else
			WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-120), E.Scale(-300))
		end		
	else
		WatchFrameHolder:ClearAllPoints()
		if C["actionbar"].enable and C["actionbar"].rightbar == 2 then
			WatchFrameHolder:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-190), E.Scale(-300))
		elseif C["actionbar"].enable and C["actionbar"].rightbar == 1 then
			WatchFrameHolder:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-160), E.Scale(-300))
		else
			WatchFrameHolder:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-120), E.Scale(-300))
		end
		
		E.CreateMover(WatchFrameHolder, "WatchFrameMover", L.WATCHFRAME, true, E.PostWatchMove)
	end
end

local function setup()
	E.PositionWatchFrame()
	
	local screenheight = GetScreenHeight()
	EuiWatchFrame:SetSize(1,screenheight / 2)
	
	-- template was just to help positioning watch frame.
	--EuiWatchFrame:SetTemplate("Default")
	
	EuiWatchFrame:SetWidth(250)
	
	WatchFrame:SetParent(EuiWatchFrame)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32,-2.5)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = E.dummy

	WatchFrameTitle:SetParent(EuiWatchFrame)
	WatchFrameCollapseExpandButton:SetParent(EuiWatchFrame)
	WatchFrameTitle:Hide()
	WatchFrameTitle.Show = E.dummy
	WatchFrameCollapseExpandButton.Disable = E.dummy
end

EuiWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed then
		if f.elapsed > .5 then
			setup()
			f:Hide()
		end
	end
end)
EuiWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)
