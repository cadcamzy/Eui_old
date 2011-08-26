local E, C, L, DB = unpack(EUI)
if C["info"].memory == 0 or C["info"].enable == false then return end

local memory = CreateFrame ("Frame", nil,UIParent)
memory:SetWidth(70)
memory:SetHeight(16)	
memory:EnableMouse(true)

local name = memory:CreateFontString (nil,"OVERLAY")
name:SetFont(C["skins"].font,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)

local function formatMem(memory, color)
	if color then
		statColor = { "", "" }
	else
		statColor = { "", "" }
	end

	local mult = 10^1
	if memory > 999 then
		local mem = floor((memory/1024) * mult + 0.5) / mult
		if mem % 1 == 0 then
			return mem..string.format(".0%smb%s", unpack(statColor))
		else
			return mem..string.format("%smb%s", unpack(statColor))
		end
	else
		local mem = floor(memory * mult + 0.5) / mult
		if mem % 1 == 0 then
			return mem..string.format(".0%skb%s", unpack(statColor))
		else
			return mem..string.format("%skb%s", unpack(statColor))
		end
	end

end

local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory
local function RefreshMem(self)
	Memory = {}
	UpdateAddOnMemoryUsage()
	Total = 0
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end
	
	MEMORY_TEXT = formatMem(Total, true)
	table.sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)
	
	-- Setup Memory tooltip
	self:SetScript("OnEnter", function()
		--if not InCombatLockdown() then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
		--	GameTooltip:ClearAllPoints()
		--	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -4, -6)
			GameTooltip:ClearLines()
			for i = 1, #Memory do
				if Memory[i][3] then 
					local red = Memory[i][2]/Total*2
					local green = 1 - red
					GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)						
				end
			end
			GameTooltip:Show()
		--end
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local int, int2 = 5, 1
local function Update(self, t)
	int = int - t
	int2 = int2 - t
	if int < 0 then
		RefreshMem(self)
		int = 5
	end
	if int2 < 0 then
		name:SetText(MEMORY_TEXT)
		int2 = 1
	end
end

memory:SetScript("OnMouseDown", function() collectgarbage("collect") Update(memory, 10) end)
memory:SetScript("OnUpdate", Update) 
Update(memory, 10)
EuiTopInfobg.memory = memory
E.EuiInfo(C["info"].memory,memory)