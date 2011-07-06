Local E, C, L = unpack(EUI)
if C["info"].wowtime == 0 or C["info"].enable == false then return end

local clocks = CreateFrame ("Frame",nil,UIParent)
	clocks:SetWidth(70)
	clocks:SetHeight(16)
--	clocks:SetStatusBarTexture(E.normTex)
--	clocks:SetStatusBarColor(0.31, 0.45, 0.63,.2)
--	clocks:SetMinMaxValues(0,9000)
	clocks:EnableMouse(true)
	
local atime = clocks:CreateFontString (nil,"OVERLAY")
	atime:SetFont(E.fontn,13)
	atime:SetJustifyH("LEFT")
	atime:SetShadowOffset(2,-2)
	atime:SetPoint("LEFT",2,0)
--	atime:SetTextColor(23/255,132/255,209/255)
	
local dateval = clocks:CreateFontString (nil,"OVERLAY")
	dateval:SetFont(E.fontn,11)
	dateval:SetJustifyH("RIGHT")
	dateval:SetShadowOffset(2,-2)
	dateval:SetPoint("RIGHT",-2,0)
--	dateval:SetTextColor(23/255,132/255,209/255)
	
local mess_f = CreateFrame("Frame",nil,UIParent)
	mess_f:SetScript("OnUpdate", FadingFrame_OnUpdate)
	mess_f:Hide()
	mess_f.fadeInTime = .2
	mess_f.holdTime = 1
	mess_f.fadeOutTime = .3
	mess_f:SetFrameStrata("TOOLTIP")
	mess_f:SetFrameLevel(30)
	
local text_f = mess_f:CreateFontString(nil,"OVERLAY")
	text_f:SetFont(E.fontn,18)
	text_f:SetShadowOffset(1,-1)
	text_f:SetPoint("TOPLEFT",clocks,"BOTTOMLEFT",.3,-8)
	text_f:SetJustifyH("LEFT")
	text_f:SetHeight(18)

local int = 1
local time_sesion = 0

local clocks_update = function(self,t)
	int = int - t
	if int > 0 then return end
		
	int = 1
	time_sesion = time_sesion + 1
	local _,_,_,canQueue,wgtime = GetWorldPVPAreaInfo(2)
	local pendingCalendarInvites = CalendarGetNumPendingInvites() or 0
	
--	self.:SetValue(wgtime)
	atime:SetText(date("%H")..":"..date("%M"))
	dateval:SetText(date("%a"))
	
 	if C["info"].wgtimenoti == true and (canQueue == false) then
		if wgtime == 60 then 
			E.EuiAlertRun (L.INFO_WOWTIME_TIP1)
		elseif wgtime == 900 then 
			E.EuiAlertRun (L.INFO_WOWTIME_TIP2)
		end
	end
end

clocks:SetScript("OnUpdate",clocks_update)

local form_time = function(target)
	local hour = tonumber(format("%01.f", floor(target/3600)))
	local min = format(hour>0 and "%02.f" or "%01.f", floor(target/60 - (hour*60)))
	local sec = format("%02.f", floor(target - hour*3600 - min*60))
	return ((hour>0 and hour..":" or "")..min..":"..sec)
end

local switch_wgtime_a = function()
	if C["info"].wgtimenoti then
		C["info"].wgtimenoti = false
		text_f:SetTextColor(1,.1,.1)
		text_f:SetText(L.INFO_WOWTIME_TIP3)
		FadingFrame_Show(mess_f)
	else
		C["info"].wgtimenoti = true
		text_f:SetTextColor(.1,1,.1)
		text_f:SetText(L.INFO_WOWTIME_TIP4)
		FadingFrame_Show(mess_f)
	end
end

clocks:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(clocks, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:ClearLines()      

		local _,_,isActive,canQueue,wgtime,canEnter = GetWorldPVPAreaInfo(2)
		local inInstance, instanceType = IsInInstance()
		if isActive == true then
			wgtime = L.INFO_WOWTIME_TIP5
		elseif canQueue == true then
			wgtime = form_time(wgtime)..L.INFO_WOWTIME_TIP6
		elseif canEnter ~= true then
			wgtime = L.INFO_WOWTIME_TIP7
		else
			wgtime = form_time(wgtime)    
		end
	if not ( instanceType == "none" ) then wgtime = L.INFO_WOWTIME_TIP7 end
	GameTooltip:AddDoubleLine(L.INFO_WOWTIME_TIP8,wgtime,1,1,1,0.3,1,0.3)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L.INFO_WOWTIME_TIP9,form_time(time_sesion),1,1,1,0.3,1,0.3)
	local oneraid
	for i = 1, GetNumSavedInstances() do
	local name,_,reset,difficulty,locked,extended,_,isRaid,maxPlayers = GetSavedInstanceInfo(i)
	if isRaid and (locked or extended) then
		local tr,tg,tb,diff
		if not oneraid then
			GameTooltip:AddLine(" ")
			oneraid = true
		end

		local function fmttime(sec,table)
		local table = table or {}
		local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
		local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
		local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
		return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
	end
	if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
	if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
		GameTooltip:AddDoubleLine(format("%s |cffaaaaaa(%s%s)",name,maxPlayers,diff),fmttime(reset),20/255,122/255,199/25,tr,tg,tb)
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L.INFO_WOWTIME_TIP10)
	GameTooltip:AddLine(L.INFO_WOWTIME_TIP11)
	GameTooltip:Show()
		
end)

clocks:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

clocks:SetScript("OnMouseDown", function(self,button)
	if button == "LeftButton" then 
		GameTimeFrame:Click()
	elseif button == "RightButton" then
		switch_wgtime_a()
	end
end)

E.EuiInfo(C["info"].wowtime,clocks)