local E, C = unpack(select(2, ...))
if C["info"].durability == 0 or C["info"].enable == false then return end

local durability = CreateFrame ("StatusBar",nil,UIParent)
	durability:SetWidth(70)
	durability:SetHeight(10)
	durability:SetStatusBarTexture(E.normTex)
	durability:SetStatusBarColor(.7,.7,.9,.8)
	durability:SetMinMaxValues(0,100)
	durability:SetValue(0)
	durability:EnableMouse(true)
	
local name = durability:CreateFontString (nil,"OVERLAY")
	name:SetFont(E.fontn,12,"OUTLINE")
	name:SetJustifyH("RIGHT")
	name:SetShadowOffset(2,-2)
	name:SetPoint("BOTTOMRIGHT",1.3,-4)
		
local Slots = {
	[1] = {1, "头", 1000},
	[2] = {3, "肩", 1000},
	[3] = {5, "胸", 1000},
	[4] = {6, "腰", 1000},
	[5] = {9, "腕", 1000},
	[6] = {10, "手", 1000},
	[7] = {7, "腿", 1000},
	[8] = {8, "脚", 1000},
	[9] = {16, "主手", 1000},
	[10] = {17, "副手", 1000},
	[11] = {18, "远程武器", 1000}
}

local Total = 0
local current, max

local function OnEvent(self)
	
	local r,g,b
		
	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end

	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	
	if Total > 0 then
		local dura = floor(Slots[1][3]*100)
		durability:SetValue(dura)
		name:SetText(floor(Slots[1][3]*100).."%|cffffffff".."D".."|r")
	else
		name:SetText("100%|cffffffff".."D".."|r")
	end
		
	self:SetScript("OnEnter", function()
		GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -4, -6)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine("耐久度",floor(Slots[1][3]*100).." %",1,1,1,r,g,b)
		GameTooltip:AddDoubleLine(" ")
		for i = 1, 11 do
			if Slots[i][3] ~= 1000 then
				green = Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:Show()	
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Total = 0
end
	
durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
durability:RegisterEvent("MERCHANT_SHOW")
durability:RegisterEvent("PLAYER_ENTERING_WORLD")
durability:SetScript("OnEvent", OnEvent)
durability:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	
E.EuiInfo(C["info"].durability,durability)