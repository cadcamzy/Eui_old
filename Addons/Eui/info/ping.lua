local E, C = unpack(select(2, ...))
if C["info"].latency == 0 or C["info"].enable == false then return end

local int, r, g, pg = 0

local latency = CreateFrame ("StatusBar",nil,UIParent)
latency:SetWidth(70)
latency:SetHeight(10)	
latency:SetStatusBarTexture(E.normTex)
latency:SetMinMaxValues(0,300)
latency:SetValue(300)

local fps = latency:CreateFontString (nil,"OVERLAY")
fps:SetFont(E.fontn,12,"OUTLINE")
fps:SetJustifyH("LEFT")
fps:SetShadowOffset(2,-2)
fps:SetPoint("BOTTOMLEFT",0,-4)

local ping = latency:CreateFontString (nil,"OVERLAY")
	ping:SetFont(E.fontn,10,"OUTLINE")
	ping:SetJustifyH("RIGHT")
	ping:SetShadowOffset(2,-2)
	ping:SetPoint("BOTTOMRIGHT",1.3,-4)

latency:SetScript("OnUpdate", function(self,t)
	int = int - t
	if int <0 then
	fps:SetText(floor(GetFramerate()).."|cfffffffff|r")
	ping:SetText(select(3, GetNetStats()).."|cffffffffms|r")
	int = 2
	
		pg = select(3, GetNetStats())
		self:SetValue(pg)
		if pg < 150 then 
			r,g,b = (pg/150),1,0 
			latency:SetStatusBarColor(r,g,b)
		elseif pg >= 150 and pg<300 then 
			r,g,b = 1,((300-pg)/150),0
			latency:SetStatusBarColor(r,g,b)
		else 
			r,g,b = 1,0,0
			latency:SetStatusBarColor(r,g,b)
		end
			
	end
end)

E.EuiInfo(C["info"].latency,latency)