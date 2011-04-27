local E, C = unpack(select(2, ...))
if C["info"].wowtime == 0 or C["info"].enable == false then return end

local clocks = CreateFrame ("StatusBar",nil,UIParent)
	clocks:SetWidth(70)
	clocks:SetHeight(10)
	clocks:SetStatusBarTexture(E.normTex)
	clocks:SetStatusBarColor(.7,.7,.9,.2)
	clocks:SetMinMaxValues(0,9000)
	clocks:EnableMouse(true)
	
local atime = clocks:CreateFontString (nil,"OVERLAY")
	atime:SetFont(E.fontn,12,"OUTLINE")
	atime:SetJustifyH("LEFT")
	atime:SetShadowOffset(2,-2)
	atime:SetPoint("BOTTOMLEFT",0,-4)
	
local dateval = clocks:CreateFontString (nil,"OVERLAY")
	dateval:SetFont(E.fontn,10,"OUTLINE")
	dateval:SetJustifyH("RIGHT")
	dateval:SetShadowOffset(2,-2)
	dateval:SetPoint("BOTTOMRIGHT",1.3,-4)
	
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
	
	local wgtime = GetWintergraspWaitTime() or 9000
	local pendingCalendarInvites = CalendarGetNumPendingInvites() or 0
	
	self:SetValue(wgtime)
	atime:SetText(date("%H")..":"..date("%M"))
	dateval:SetText(date("%a"))
	
	if C["info"].wgtimenoti == true then
		if wgtime == 60 then 
			E.EuiAlertRun ("冬握即将在1分钟内开始")
		elseif wgtime == 900 then 
			E.EuiAlertRun ("冬握即将在15分钟内开始")
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
		text_f:SetText("冬握提示关闭")
		FadingFrame_Show(mess_f)
	else
		C["info"].wgtimenoti = true
		text_f:SetTextColor(.1,1,.1)
		text_f:SetText("冬握提示开启")
		FadingFrame_Show(mess_f)
	end
end

clocks:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -4, -6)
	GameTooltip:ClearLines()      

		local wgtime = GetWintergraspWaitTime()
		local inInstance, instanceType = IsInInstance()
		if not ( instanceType == "none" ) then
			wgtime = "不可用"
		elseif wgtime == nil then
			wgtime = "正在进行"
		else
			wgtime = form_time(wgtime)    
		end

	GameTooltip:AddDoubleLine("冬握开始时间",wgtime,1,1,1,1,1,1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("游戏时间:",form_time(time_sesion),1,1,1,1,1,1)
	if C["info"].wgtimenoti then
		GameTooltip:AddDoubleLine("冬握提示:","启用",1,1,1,.1,1,.1)
	else
		GameTooltip:AddDoubleLine("冬握提示:" ,"禁用",1,1,1,1,.1,.1)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("点左键显示日历")
	GameTooltip:AddLine("点右键改变提醒设置")
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