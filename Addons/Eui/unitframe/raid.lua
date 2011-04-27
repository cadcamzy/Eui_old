local E, C = unpack(select(2, ...))
if not C["raid"].raid == true then return end

if C["raid"].texture == 0 then
	BarTexture = "Interface\\AddOns\\Eui\\media\\nameTex"
elseif C["raid"].texture == 1 then
	BarTexture = "Interface\\AddOns\\Eui\\media\\dM2"
elseif C["raid"].texture == 2 then
	BarTexture = "Interface\\AddOns\\Eui\\media\\statusbar"
else
	BarTexture = "Interface\\AddOns\\Eui\\media\\nameTex"
end
	
updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

ShortValueNegative = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

MLAnchorUpdate = function (self)
	if self.Leader:IsShown() then
		self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
	else
		self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
	end
end

local utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

oUF.TagEvents['getnamecolor'] = 'UNIT_HAPPINESS'
oUF.Tags['getnamecolor'] = function(unit)
	local reaction = UnitReaction(unit, 'player')
	if (unit == 'pet' and GetPetHappiness()) then
		local c = oUF.colors.happiness[GetPetHappiness()]
		return string.format('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
	elseif (UnitIsPlayer(unit)) then
		return _TAGS['raidcolor'](unit)
	elseif (reaction) then
		local c = oUF.colors.reaction[reaction]
		return string.format('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = .84,.75,.65
		return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
	end
end

oUF.TagEvents['nameshort'] = 'UNIT_NAME_UPDATE'
oUF.Tags['nameshort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 3, false)
end

oUF.TagEvents['namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags['namelong'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 20, true)
end

oUF.TagEvents['hpprec'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags['hpprec'] = function(unit)
	if unit then
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		return format('%s%%', floor(min/max*100))
	else
		return ""
	end
end

local _, class = UnitClass("player")
local DebuffTypeColor = { };
DebuffTypeColor["Magic"] = { r = 0.20, g = 0.60, b = 1.00 };
DebuffTypeColor["Curse"] = { r = 0.60, g = 0.00, b = 1.00 };
DebuffTypeColor["Disease"] = { r = 0.60, g = 0.40, b = 0 };
DebuffTypeColor["Poison"] = { r = 0.00, g = 0.60, b = 0 }; 	

local CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Poison = true, Disease = true, Curse = true, },
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, },
	ROGUE = {},
	HUNTER = {},
	WARRIOR = {},
	WARLOCK = {},
	DEATHKNIGHT = {},
	}

local ClickSets_Setsopt = {}
local classopt
if C["clickset"].aadefault == true then
	ClickSets_Setsopt = E.ClickSets_Sets
	classopt = class
else
	ClickSets_Setsopt = C
	classopt = "clickset"
end


local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	local dtype
	local i = 1
	local candel = 1
	if UnitIsPlayer(self.unit) then
		while (true) do
			dtype = select(5, UnitDebuff(self.unit, i))
			if CanDispel[class][dtype] then candel = i end
			if (not select(3, UnitDebuff(self.unit, i))) then
				if i > 1 then dtype = select(5, UnitDebuff(self.unit, candel)) end
				break;
			end
			i = i +1
		end
	end
	if (threat == 3) then
		if dtype then
			if CanDispel[class][dtype] then
				if self.panel then
					self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
					self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
					self.panel:SetBackdropBorderColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
					self.panel:SetBackdropColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
				else
					self.Name:SetTextColor(1,0.1,0.1)
				end
			end
		else
			if self.panel then
				self.panel:SetBackdropBorderColor(.67,.06,.24,1)
				self.panel:SetBackdropColor(.67,.06,.24,1)
				self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
				self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)					
			else
				self.Name:SetTextColor(1,0.1,0.1)
			end
		end
	else
		if dtype then
			if CanDispel[class][dtype] then
				if self.panel then
					self.panel:SetBackdropBorderColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
					self.panel:SetBackdropColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
					self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
					self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
				else
					self.Name:SetTextColor(1,0.1,0.1)
				end
			end
		else
			if self.panel then
				self.panel:SetBackdropBorderColor(0,0,0,0.01)
				self.panel:SetBackdropColor(0,0,0,0.01)
				self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
				self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
			else
				self.Name:SetTextColor(1,1,1)
			end
		end
	end
	
end

local PostUpdateHealthRaid = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."D/C".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."DEAD".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."GHOST".."|r")
		end
	else
	--	local r, g, b
	--	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
	--		r, g, b = 75/255,  175/255, 76/255
	--		health:SetStatusBarColor(r, g, b)
	--		health.bg:SetTexture(.1, .1, .1)
	--	end
		
		if min ~= max then
			health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
		else
			health.value:SetText(" ")
		end
	end
end

local iconsize = C["raid"].hotsize
local countOffsets = {
	TOPLEFT = {iconsize, 0},
	TOPRIGHT = {-iconsize, 0},
	BOTTOMLEFT = {iconsize, 0},
	BOTTOMRIGHT = {iconsize, 0},
	LEFT = {iconsize, 0},
	RIGHT = {-iconsize, 0},
	TOP = {0, 0},
	BOTTOM = {0, 0},
	}

local function CreateAuraWatchIcon(self, icon)
	E.EuiSetTemplate(icon)
	icon.icon:SetPoint("TOPLEFT", 1, -1)
	icon.icon:SetPoint("BOTTOMRIGHT", -1, 1)
	icon.icon:SetTexCoord(.08, .92, .08, .92)
	icon.icon:SetDrawLayer("ARTWORK")
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	icon.overlay:SetTexture()
end
	
local function createAuraWatch(self,unit)
	local auras = CreateFrame("Frame", nil, self)
    auras:SetPoint("TOPLEFT", health, 1, -1)
	auras:SetPoint("BOTTOMRIGHT", health, -1, 1)
	
	local debuffs = spellIDs

    auras.presentAlpha = 1
    auras.missingAlpha = 0
    auras.icons = {}
    auras.PostCreateIcon = CreateAuraWatchIcon
	
	local buffs = {}
	local debuffs = E.debuffids
	
	if (E.buffids["ALL"]) then
		for key, value in pairs(E.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (E.buffids[class]) then
		for key, value in pairs(E.buffids[class]) do
			tinsert(buffs, value)
		end
	end
	
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:SetWidth(iconsize)
			icon:SetHeight(iconsize)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(E.normTex)
			if (spell[3]) then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end
			icon.text=tex
			if C["raid"].hottime ~= true then
				icon.noOCC = true
			else
				icon.noOCC = false
			end
			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(E.fontn, 8, "OUTLINE")
			count:SetPoint("CENTER", unpack(countOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	
	if (debuffs) then
		for key, spellID in pairs(debuffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spellID
			icon.anyUnit = true
		--	icon:SetWidth(16.11)
		--	icon:SetHeight(16.11)
			icon:SetSize(16,16)
			icon:SetPoint("CENTER", 0, -1)
			icon.noOCC = true
			
			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(E.fontn, 8, "THINOUTLINE")
			count:SetPoint("BOTTOMRIGHT", 2, 2)
			count:SetTextColor(1,.9,0)
			icon.count = count

			auras.icons[spellID] = icon
		end
	end

		
    self.AuraWatch = auras
end

-- ------------------------------------------------------------------------
-- Layout
-- ------------------------------------------------------------------------

local function Shared(self, unit)

	self.menu = SpawnMenu
	self:SetAttribute('*type2', 'menu')
	
	--ClickSets_Setsopt[class]
	local key_tmp
	if E.ClickSets_Sets then
		if (ClickSets_Setsopt[classopt]) then
			for key, value in pairs(ClickSets_Setsopt[classopt]) do
				key_tmp = string.gsub(key,"z","-")
				if value ~= 0 and key ~= "aadefault" and key ~= "aamouse" then
					self:SetAttribute(key_tmp, 'spell')
					self:SetAttribute(string.gsub(key_tmp,"type",'spell'), GetSpellInfo(value))
				elseif value == 0 and key ~= "aadefault" and key ~= "aamouse" then
					self:SetAttribute(string.gsub(key,"z","-"), nil)
					self:SetAttribute(string.gsub(string.gsub(key,"z","-"),"type",'spell'), nil)
				end
			end
		end
	end

	--self.colors = oUF.colors
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	if C["raid"].grid == true then
		self:SetAttribute('initial-height', C["raid"].gridh)
		self:SetAttribute('initial-width', C["raid"].gridw)
	else
		self:SetAttribute('initial-height', C["raid"].nogridh)
		self:SetAttribute('initial-width', C["raid"].nogridw)
	end
	
	
	self:SetBackdrop({
		  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		  edgeFile = [=[Interface\Buttons\WHITE8x8]=], 
		  tile = false, tileSize = 0, edgeSize = 1, 
		  insets = { left = -1, right = -1, top = -1, bottom = -1}
		})
	self:SetBackdropColor(.1,.1,.1,1)
	self:SetBackdropBorderColor(.3,.3,.3,1)	
	
	health = CreateFrame('StatusBar', nil, self)
	health:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
	health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	
	if C["raid"].grid == true and GridHealthVettical == true then
		health:SetOrientation('VERTICAL')
	end
	health:SetStatusBarTexture(BarTexture)

	self.Health = health

    --LFDRole icon
    if self:GetAttribute("unitsuffix") ~= "target" and self:GetAttribute("unitsuffix") ~= "pet" then 
		self.LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
		self.LFDRole:SetWidth(14)
        self.LFDRole:SetHeight(14)
		self.LFDRole:SetPoint('LEFT', -4, 0)
    end	
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(.08,.08,.08)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg
	
	health.value = health:CreateFontString(nil, "OVERLAY")
	if C["raid"].grid == true then
		health.value:SetPoint("BOTTOM", health, 0, 2)
	else
		health.value:SetPoint("RIGHT", health, -2, 0)
	end
	health.value:SetFont(E.fontn, 10, "THINOUTLINE")
	health.value:SetTextColor(1,1,1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value
	
	health.PostUpdate = PostUpdateHealthRaid
	
	health.colorDisconnected = true
	health.colorClass = C["raid"].raidColorClass
	health.colorSmooth = true
	health.frequentUpdates = true
	health.colorTapping = true

	local powerbg = CreateFrame("Frame",nil,self)
	powerbg:SetBackdrop(self:GetBackdrop())
	powerbg:SetBackdropColor(.1,.1,.1,1)
	powerbg:SetBackdropBorderColor(.3,.3,.3,1)
	powerbg:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 6, 3)
	powerbg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -6, -3)
	powerbg:SetFrameLevel(health:GetFrameLevel()+1)
	
	local power = CreateFrame("StatusBar", nil, powerbg)
	power:SetStatusBarTexture(BarTexture)
	power:SetParent(powerbg)
	power:SetFrameLevel(powerbg:GetFrameLevel()+1)
	power:SetPoint("TOPLEFT", powerbg, "TOPLEFT", 2, -2)
	power:SetPoint("BOTTOMRIGHT", powerbg, "BOTTOMRIGHT", -2, 2)
	self.Power = power
	
	power.bg = power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(0.3,0.3,.3)
	power.bg.multiplier = 0.4
		
	
 	power.colorTapping = true
	power.colorDisconnected = true
	power.colorPower = true
	power.colorReaction = true
	power.frequentUpdates = true

	local panel = CreateFrame("Frame", nil, self)
	panel:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
	panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
	panel:SetBackdrop( {
        bgFile = E.normTex,
        edgeFile = E.normTex,
        tile = false, tileSize = 0, edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
	panel:SetFrameLevel(health:GetFrameLevel()-1)
    panel:SetBackdropColor(0,0,0)
    panel:SetBackdropBorderColor(0,0,0)
	self.panel = panel

	local name = health:CreateFontString(nil, "OVERLAY")
	if C["raid"].grid == true then
		name:SetPoint("TOP", health, 0, -3)
	else
		name:SetPoint("LEFT", health, 6, 1)
	end
	name:SetFont(E.font, 11, "THINOUTLINE")
	name:SetShadowOffset(1, -1)
	if C["raid"].grid == true then
		self:Tag(name, "[getnamecolor][nameshort]")
	else
		self:Tag(name, "[getnamecolor][namelong]")
	end
	
	local range = {
		insideAlpha = 1, 
		outsideAlpha = 0.4
	}
	self.Range = range	
	
	if self:GetParent():GetName():match"oUF_EUI_MT" or unit:find("boss%d") then
		self:SetAttribute('initial-height', C["raid"].gridh-10)
		self:SetAttribute('initial-width', C["raid"].gridw+20)
		name:SetFont(E.font, 9, "OUTLINE")
		name:SetPoint("CENTER",health,-2,0)
		self:Tag(name, "[getnamecolor][nameshort] - [hpprec]")
		health.value:ClearAllPoints()
		self.Range.outsideAlpha = 1
			
	end

	if self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "pet" then
		if C["raid"].grid == true then
			self:SetAttribute('initial-height', C["raid"].gridh * 0.7)
		else
			self:SetAttribute('initial-width', C["raid"].nogridw * 0.7)
			self:Tag(name, "[getnamecolor][nameshort]")
		end
		health.value:ClearAllPoints()
		name:SetPoint("CENTER",health,-2,0)
		self.Range.outsideAlpha = 1
	end
	
	self.Name = name	
	
	if C["raid"].raidthreat == true then
		table.insert(self.__elements, UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
		self:RegisterEvent('UNIT_AURA', UpdateThreat)
	end
		
	local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetHeight(16)
	RaidIcon:SetWidth(16)
	if C["raid"].grid == true then
		RaidIcon:SetPoint('CENTER', self, 'TOP', 0, -4)
	else
		RaidIcon:SetPoint('CENTER', self, 'LEFT')
	end
	RaidIcon:SetTexture("Interface\\AddOns\\Eui\\media\\raidicons.blp")
	self.RaidIcon = RaidIcon
	
	local Leader = health:CreateTexture(nil, "OVERLAY")
	Leader:SetHeight(14)
	Leader:SetWidth(14)
	Leader:SetPoint("TOPLEFT", 2, 8)
	self.Leader = Leader
	
	-- master looter
	local MasterLooter = health:CreateTexture(nil, "OVERLAY")
	MasterLooter:SetHeight(14)
	MasterLooter:SetWidth(14)
	self.MasterLooter = MasterLooter
	self:RegisterEvent("PARTY_LEADER_CHANGED", MLAnchorUpdate)
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", MLAnchorUpdate)

	local ReadyCheck = power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetHeight(12)
	ReadyCheck:SetWidth(12)
	ReadyCheck:SetPoint('CENTER') 	
	self.ReadyCheck = ReadyCheck	

--	self.DebuffHighlightAlpha = 1
--	self.DebuffHighlightBackdrop = true
--	self.DebuffHighlightFilter = true
	
	if C["raid"].raidaurawatch == true then
		createAuraWatch(self,unit)
    end

	self:RegisterEvent("UNIT_PET", updateAllElements)

	return self
end

local NUM_RAID_GROUPS --显示的小队数量
NUM_RAID_GROUPS = C["raid"].raidgroups
if NUM_RAID_GROUPS > 8 or NUM_RAID_GROUPS < 1 then NUM_RAID_GROUPS = 5 end

if C["raid"].showParty == true then
	oUF:RegisterStyle('oUF_EUI_Party', Shared)
	oUF:SetActiveStyle('oUF_EUI_Party')
	local party
	local showpartytarget
	if C["raid"].showPartyTarget == true then
		showpartytarget = "oUF_Party"
	else
		showpartytarget = "oUF_PartyNoTarget"
	end
	if C["raid"].grid == true then
		local pty = C["raid"].gridh * 5 + 20 + C["raid"].gridheight
		party = oUF:SpawnHeader("oUF_Party", nil, "party",
			"showSolo", false,
			"showPlayer", true, 
			"showParty", true,
			"showRaid", true,			
			"xOffset", 5,
			"point", "LEFT",
			"template", showpartytarget.."H"
		)	
		party:SetPoint("TOP", UIParent, "BOTTOM", 0, pty)
	else
		party = oUF:SpawnHeader("oUF_PartyDPS", nil, "party",
		"showSolo", false,
		"showPlayer", true, 
		"showParty", true,
		"showRaid", true,	
		"yOffset", 28,
		"point", "BOTTOM",
		"template", showpartytarget.."V"
		)		
		party:SetPoint("BOTTOMLEFT", UIParent, "LEFT", 22, -70)
	end
end

if C["raid"].mt == true then
	oUF:RegisterStyle('oUF_EUI_MT', Shared)
	oUF:SetActiveStyle('oUF_EUI_MT')
	local tank = oUF:SpawnHeader(
		nil, nil, 'raid',
		'ShowRaid', true,
		'yOffset', -4,
		'groupFilter', 'MAINTANK',
		'template', 'oUF_Mtt'
		)
	tank:SetPoint("BOTTOMRIGHT", -200, 160)
end

if C["raid"].boss == true then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = function() return end
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end
	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
		if i == 1 then
			boss[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 452, 560)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
		end
	end
end	

oUF:Factory(function(self)
	for i = 1, NUM_RAID_GROUPS do
		oUF:RegisterStyle('oUF_EUI_RAID'..i, Shared)
		oUF:SetActiveStyle("oUF_EUI_RAID"..i)
	end
	local raid = {}
	if C["raid"].grid == true then
		if C["raid"].grouphv == true then --队伍为横排
			for i = 1, NUM_RAID_GROUPS do
				raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					"showParty", true,
					"showPlayer", true,
					"showRaid", true,
					"xoffset", 5,
					"yOffset", 5,
					"point", "LEFT",
					"groupFilter", tostring(i),
					"groupingOrder", tostring(i),
					"groupBy", "GROUP",
					"maxColumns", 5,
					"unitsPerColumn", 5,
					"columnSpacing", 5		
				)
			end
			if C["raid"].raidDirection == true then --1队排在下面
				for i = 1, NUM_RAID_GROUPS do
					if i == 1 then
						raid[1]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -(C["raid"].gridw * 5 + 5 * 4)/2, C["raid"].gridheight)
						raid[1]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", (C["raid"].gridw * 5 + 5 * 4)/2, C["raid"].gridheight)
					else
						raid[i]:SetPoint('BOTTOMLEFT', "oUF_EUI_raid"..tostring(i-1), 'TOPLEFT', 0, 5)
						raid[i]:SetPoint('BOTTOMRIGHT', "oUF_EUI_raid"..tostring(i-1), 'TOPRIGHT', 0, 5)
					end
				end
			else --5队排在下面.
				for i = 1, NUM_RAID_GROUPS, 1 do
					if i == 1 then
						raid[1]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -(C["raid"].gridw * 5 + 5 * 4)/2, C["raid"].gridheight + C["raid"].gridh * (NUM_RAID_GROUPS-1) + 5*(NUM_RAID_GROUPS-1))
						raid[1]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", (C["raid"].gridw * 5 + 5 * 4)/2, C["raid"].gridheight + C["raid"].gridh * (NUM_RAID_GROUPS-1) + 5*(NUM_RAID_GROUPS-1))					
					else
						raid[i]:SetPoint('TOPLEFT', "oUF_EUI_raid"..tostring(i-1), 'BOTTOMLEFT', 0, -5)
						raid[i]:SetPoint('TOPRIGHT', "oUF_EUI_raid"..tostring(i-1), 'BOTTOMRIGHT', 0, -5)
					end
				end
			end
		else
			for i = 1, NUM_RAID_GROUPS do --小队竖排
				raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					"showParty", true,
					"showPlayer", true,
					"showRaid", true,
					"xoffset", 0,
					"yOffset", 5,
					"point", "BOTTOM",
					"groupFilter", tostring(i),
					"groupingOrder", tostring(i),
					"groupBy", "GROUP",
					"maxColumns", 1,
					"unitsPerColumn", 5,
					"columnSpacing", 3,
					"columnAnchorPoint", raidDirection
				)
			end
			raid[ceil(NUM_RAID_GROUPS / 2)]:SetPoint('BOTTOM', UIParent, 0, C["raid"].gridheight)
			for i = ceil(NUM_RAID_GROUPS / 2) - 1, 1, -1 do
				raid[i]:SetPoint('BOTTOMRIGHT', "oUF_EUI_raid"..tostring(i + 1), 'BOTTOMLEFT', -5, 0)
			end
			for i = ceil(NUM_RAID_GROUPS / 2) + 1, NUM_RAID_GROUPS do
				raid[i]:SetPoint('BOTTOMLEFT', "oUF_EUI_raid"..tostring(i - 1), 'BOTTOMRIGHT', 5, 0)
			end
		end		
	else
		for i = 1, NUM_RAID_GROUPS do
		  raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
			"showParty", true,
			"showPlayer", true, 
			"showRaid", true, 
			"xoffset", 0,
			"yOffset", -5,
			"point", "TOP",
			"groupFilter", tostring(i),
			"groupingOrder", tostring(i),
			"groupBy", "GROUP",
			"maxColumns", 1,
			"unitsPerColumn", 5,
			"columnSpacing", 3,
			"columnAnchorPoint", raidDirection		
		  )
		  if i == 1 then
			raid[i]:SetPoint('TOPLEFT', UIParent, 10, -20)
		  elseif i > 1 and i < 6 then
			if C["raid"].groupspace < 0 then C["raid"].groupspace = 3 end
		    raid[i]:SetPoint('TOPLEFT', "oUF_EUI_raid"..tostring(i-1), 'BOTTOMLEFT', 0, -C["raid"].groupspace)	
		  elseif i > 5 then --小队超过5队时,第6队排到第5队的右边
		    raid[i]:SetPoint('BOTTOMLEFT', "oUF_EUI_raid"..tostring(i-5), 'BOTTOMRIGHT', 16, 0)
		  end
		end
	end
end)