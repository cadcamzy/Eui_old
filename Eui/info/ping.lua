local E, C, L = unpack(EUI)
if C["info"].latency == 0 or C["info"].enable == false then return end

local int, r, g, pg = 0

local latency = CreateFrame ("Frame",nil,UIParent)
latency:SetWidth(70)
latency:SetHeight(16)	
--latency:SetStatusBarTexture(E.normTex)
--latency:SetMinMaxValues(0,300)
--latency:SetValue(300)
latency:EnableMouse(true)

local fps = latency:CreateFontString (nil,"OVERLAY")
fps:SetFont(E.fontn,13)
fps:SetJustifyH("LEFT")
fps:SetShadowOffset(2,-2)
fps:SetPoint("LEFT",2,0)
--fps:SetTextColor(23/255,132/255,209/255)

local ping = latency:CreateFontString (nil,"OVERLAY")
	ping:SetFont(E.fontn,11)
	ping:SetJustifyH("RIGHT")
	ping:SetShadowOffset(2,-2)
	ping:SetPoint("RIGHT", -2,0)

latency:SetScript("OnUpdate", function(self,t)
	int = int - t
	if int <0 then
	fps:SetText(floor(GetFramerate()).."f")
	ping:SetText((select(3, GetNetStats())+select(4,GetNetStats())).."ms")
	int = 2
	E.EuiSetTooltip(latency,L.INFO_PING_TIP_TITLE..floor(GetFramerate()).."f", L.INFO_PING_TIP_L1, select(3, GetNetStats()).."ms", L.INFO_PING_TIP_L2, select(4, GetNetStats()).."ms")
	
		pg = select(3, GetNetStats()) + select(4,GetNetStats())
	--	self:SetValue(pg)
		if pg < 150 then 
			r,g,b = (pg/150),1,0 
		--	latency:SetStatusBarColor(r,g,b)
			ping:SetTextColor(r,g,b,1)
		elseif pg >= 150 and pg<300 then 
			r,g,b = 1,((300-pg)/150),0
		--	latency:SetStatusBarColor(r,g,b)
			ping:SetTextColor(r,g,b,1)
		else 
			r,g,b = 1,0,0
		--	latency:SetStatusBarColor(r,g,b)
			ping:SetTextColor(r,g,b,1)
		end
			
	end
end)




E.EuiInfo(C["info"].latency,latency)