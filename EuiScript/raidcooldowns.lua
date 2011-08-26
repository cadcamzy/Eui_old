local E, C, L, DB = unpack(EUI)
if C["filter"].raid ~= true then return end
local spells = {
	[20484] = 600,	-- XD复生
	[61999] = 600,	-- DK复活盟友
	[20707] = 900,	-- SS灵魂石复活
	[6346] = 180,	-- MS反恐
	[29166] = 180,	-- XD激活
	[32182] = 300,	-- SM英勇
	[2825] = 300,	-- SM嗜血
	[80353] = 300,	-- FS时间扭曲
	[90355] = 300,	-- LR远古狂乱
}

local width, height = C["filter"].raidwidth or 144, C["filter"].raidheight or 12
local num = C["filter"].raidnumber or 10
local holder = CreateFrame("Frame", "EuiRaidCooldowns", UIParent)
E.EuiCreatePanel(holder, width, height, "BOTTOMLEFT", EuiBottomInfoButtonR, "BOTTOMRIGHT", 5, 0)
E.EuiSetTemplate(holder)
holder:Hide()

local floor, mod, format, ipairs = floor, mod, format, ipairs
local GetTime = GetTime
local bars = {}

local function SecondsToTime(seconds)
	local time = ""
	if(seconds >= 60) then
		time = format("%.0f.", floor(seconds * 0.016666666666667))
		seconds = mod(seconds, 60)
	end
	seconds = floor(seconds)
	if(seconds<10) then seconds = "0"..seconds end
	time = format("%s%s", time, seconds)
	return time
end

local function UpdateBars()
    local firsthidden = false
    local lastvisible
    for i, v in ipairs(bars) do
        if(i==1 and not v:IsShown()) then firsthidden = true end
        if(v:IsShown()) then
            v:ClearAllPoints()
           	if(i==1 or firsthidden) then
               	v:SetPoint("BOTTOM", holder, "TOP")
           	else
               	v:SetPoint("BOTTOM", bars[lastvisible], "TOP", 0, 8)
           	end
			firsthidden = false
            lastvisible = i
        end
    end
end

local OnEnter = function(self)
	local c = E.RAID_CLASS_COLORS[select(2, UnitClass(self.name))]
	if c then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddLine(self.name, c.r, c.g, c.b)
		GameTooltip:AddDoubleLine(self.spellname, self.dur:GetText(), 1, 1, 1, 1, 1, 1)
		GameTooltip:Show()
	end
end

local OnLeave = function()
	GameTooltip:Hide()
end

local function OnUpdate(self, elapsed)
	if(not self.start) then return end
	local time = GetTime()
	local progress = floor((time-self.start) / self.duration * 100)
	if(progress>=100) then
		self.start = nil
		self.duration = nil
		self:Hide()
		UpdateBars()
	else
		self:SetValue(progress)
		self.dur:SetFormattedText(SecondsToTime((self.start+self.duration)-time))
		self:SetStatusBarColor(1 - progress/100, progress/100, 0)
	end
--	if GetNumPartyMembers() == 0 then bars = {} end
end

local function OnMouseDown(self, button)
	if(button=="LeftButton") then
		SendChatMessage(format("CD: %s - %s - %s", self.name, self.spellname, self.dur:GetText()), "RAID")
	elseif(button=="RightButton") then
		self.start = nil
		self.duration = nil
		self:Hide()
		UpdateBars()
	end
end

local function CreateBar(index)
	local bar = CreateFrame("StatusBar", nil, UIParent)
	bar:SetStatusBarTexture(E.normTex)
	bar:SetMinMaxValues(0, 100)
	bar:SetHeight(height)
	bar:SetWidth(width)

	bar.dur = E.EuiSetFontn(bar, C["skins"].font, 12, "LEFT")
	bar.dur:SetPoint("LEFT", bar, "LEFT", 1, 0)
	bar.dur:SetShadowOffset(1, -1)
	
	bar.text = E.EuiSetFontn(bar, C["skins"].font, 12, "RIGHT")
	bar.text:SetPoint("RIGHT", bar, "TOPRIGHT", -1, 0)
	bar.text:SetShadowOffset(1, -1)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnUpdate", OnUpdate)
	bar:SetScript("OnMouseDown", OnMouseDown)

	local bg = CreateFrame("Frame", nil, bar)
	bg:SetBackdrop({
		bgFile = E.blackTex, 
		edgeFile = E.glowTex, 
		edgeSize = 1,
	})
	bg:SetBackdropColor(0, 0, 0, .5)
	bg:SetBackdropBorderColor(0, 0, 0)
	bg:SetPoint("TOPLEFT", bar, -2, 2)
	bg:SetPoint("BOTTOMRIGHT", bar, 2, -2)
	bg:SetFrameStrata("BACKGROUND")
	E.EuiSetTemplate(bg,1)
	
	bars[index] = bar
	bar:Hide()
end

for i = 1, num do CreateBar(i) end

local function StartBar(unit, spellname, duration)
	local index = 1
	for i, v in ipairs(bars) do
		if(not v.start) then
			index = i
			break
		end
	end
	local c = E.RAID_CLASS_COLORS[select(2, UnitClass(unit))]
	local bar = bars[index]
	bar.spellname = spellname
	bar.name = UnitName(unit)
	bar.text:SetText(E.utf8sub(bar.name,3,false)..'-'..spellname)
	bar.text:SetTextColor(c.r, c.g, c.b)
	bar.duration = duration
	bar.start = GetTime()
	bar:Show()
	UpdateBars()
end

holder:RegisterEvent"UNIT_SPELLCAST_SUCCEEDED"
holder:SetScript("OnEvent", function(self, event, unit, spell, aa, aaa, spellID)
	if(unit:match("raid") and spells[spellID]) then
		StartBar(unit, spell, spells[spellID])
	end
end)

function E.RaidCooldownPoint(frame)
	if E.Movers["RaidCooldownMover"]["moved"] ~= true then
		EuiRaidCooldowns:ClearAllPoints()
		EuiRaidCooldowns:SetPoint("BOTTOMLEFT", EuiBottomInfoButtonR, "BOTTOMRIGHT", 5, 0)
	end
end

E.CreateMover(EuiRaidCooldowns, "RaidCooldownMover", L.RAIDCOOLDOWN, false, E.RaidCooldownPoint)

function E.RaidCooldownShow()
	if EuiRaidCooldowns:IsShown() then EuiRaidCooldowns:Hide() else EuiRaidCooldowns:Show() end
end