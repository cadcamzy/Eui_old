local E, C = unpack(EUI)
local oUF = EuiUF or oUF
if not C["raid"].raid == true then return end

if C["skins"].texture < 0 or C["skins"].texture > 9 then C["skins"].texture = 0 end

TEXTURE = string.format("Interface\\AddOns\\Eui\\media\\statusbar\\%d", C["skins"].texture)
	
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


oUF.TagEvents['getnamecolor'] = 'UNIT_HAPPINESS'
oUF.Tags['getnamecolor'] = function(unit)
	local reaction = UnitReaction(unit, 'player')
	if (unit == 'pet' and E.MyClass == 'HUNTER') then
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
	return E.utf8sub(name, 4, false)
end

oUF.TagEvents['namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags['namelong'] = function(unit)
	local name = UnitName(unit)
	return E.utf8sub(name, 20, true)
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
	SHAMAN = { Magic = false, Curse = true, },
	PALADIN = { Magic = false, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Magic = false, Curse = true, Poison = true, },
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
	if event == 'CHARACTER_POINTS_CHANGED' then
		if class == "PALADIN" then
		--Check to see if we have the 'Sacred Cleansing' talent.
			if E.CheckForKnownTalent(53551) then
				CanDispel[class].Magic = true
			else
				CanDispel[class].Magic = false	
			end
		elseif class == "SHAMAN" then
			--Check to see if we have the 'Improved Cleanse Spirit' talent.
			if E.CheckForKnownTalent(77130) then
				CanDispel[class].Magic = true
			else
				CanDispel[class].Magic = false	
			end
		elseif class == "DRUID" then
			--Check to see if we have the 'Nature's Cure' talent.
			if E.CheckForKnownTalent(88423) then
				CanDispel[class].Magic = true
			else
				CanDispel[class].Magic = false	
			end
		end
	end
	
	if (threat == 3) then
		if dtype then
			if CanDispel[class][dtype] then
				if self.panel then
					self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
					self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
					self.panel:SetBackdropBorderColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
				--	self.panel:SetBackdropColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
				else
					self.Name:SetTextColor(1,0.1,0.1)
				end
			end
		else
			if self.panel then
				self.panel:SetBackdropBorderColor(.67,.06,.24,1)
			--	self.panel:SetBackdropColor(.67,.06,.24,1)
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
				--	self.panel:SetBackdropColor(DebuffTypeColor[dtype].r, DebuffTypeColor[dtype].g, DebuffTypeColor[dtype].b,1)
					self.panel:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
					self.panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
				else
					self.Name:SetTextColor(1,0.1,0.1)
				end
			end
		else
			if self.panel then
				self.panel:SetBackdropBorderColor(0,0,0,0.01)
			--	self.panel:SetBackdropColor(0,0,0,0.01)
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
			if IsSpellKnown(spell[1]) then
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
			
				if icon.spellID == 974 then icon.noOCC = true end
			
				local count = icon:CreateFontString(nil, "OVERLAY")
				count:SetFont(E.fontn, 8, "OUTLINE")
				count:SetPoint("CENTER", unpack(countOffsets[spell[2]]))
				icon.count = count

				auras.icons[spell[1]] = icon
			end
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
			if ((key % 2) == 0) then
				icon:SetPoint("RIGHT", self, "CENTER", -2, -4)
			else
				icon:SetPoint("LEFT", self, "CENTER", 2, -4)
			end
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

	if C["other"].focuser == true then
		local modifier = "shift" -- shift, alt or ctrl
		local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any

		local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
		f:SetAttribute("type1","macro")
		f:SetAttribute("macrotext","/focus mouseover")
		SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

		self:SetAttribute('shift-type1', 'focus')
	end
	
	--ClickSets_Setsopt[class]
	local key_tmp
	if E.ClickSets_Sets then
		if (ClickSets_Setsopt[classopt]) then
			for key, value in pairs(ClickSets_Setsopt[classopt]) do
				key_tmp = string.gsub(key,"z","-")
				if value ~= 0 and key ~= "aadefault" and key ~= "aamouse" then
					self:SetAttribute(key_tmp, 'spell')
					if C["clickset"].aadefault == true then
						self:SetAttribute(string.gsub(key_tmp,"type",'spell'), GetSpellInfo(value))
					else
						self:SetAttribute(string.gsub(key_tmp,"type",'spell'), value)
					end
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
	
	if C["raid"].astyle == 0 then
		self:SetAttribute('initial-height', C["raid"].gridh)
		self:SetAttribute('initial-width', C["raid"].gridw)
	elseif C["raid"].astyle == 1 then
		self:SetAttribute('initial-height', C["raid"].nogridh)
		self:SetAttribute('initial-width', C["raid"].nogridw)
	elseif C["raid"].astyle == 2 then
		if C["raid"].nogridw * 2 > (C["chat"].chatw - 6) then C["raid"].nogridw = (C["chat"].chatw - 6) / 2 end
		self:SetAttribute('initial-height', C["raid"].nogridh)
		self:SetAttribute('initial-width', C["raid"].nogridw)
	end
	
	self.background = E.CreateBG(self)	
	self.background:SetBackdropColor(.1,.1,.1,1)
	if C["raid"].portrait == true then
		health = E.ReverseBar(self)
		health.StatusBarColor = {1, 0, 0}
	else
		health = CreateFrame("StatusBar", nil, self)
	end		

	health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	
	if C["raid"].astyle == 0 and GridHealthVettical == true then
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
	if C["raid"].astyle == 0 then
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
	health.colorSmooth = not(C["raid"].portrait)
	health.frequentUpdates = true
	health.colorTapping = true

	local power = CreateFrame("StatusBar", nil, self)
	power:SetStatusBarTexture(BarTexture)
	power:SetFrameLevel(self.Health:GetFrameLevel()+1)
	power:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
	power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -10)
	power.backbg = E.CreateBG(power)
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
	if C["raid"].astyle == 0 then
		name:SetPoint("TOP", health, 0, -2)
	else
		name:SetPoint("LEFT", health, 6, 1)
	end
	name:SetFont(E.font, 11, "THINOUTLINE")
	name:SetShadowOffset(1, -1)
	if C["raid"].astyle == 0 then
		self:Tag(name, "[getnamecolor][nameshort]")
	else
		self:Tag(name, "[getnamecolor][namelong]")
	end
	
	local range = {
		insideAlpha = 1, 
		outsideAlpha = 0.4
	}
	self.Range = range	

	if C["raid"].portrait == true then
		local portrait = CreateFrame('PlayerModel', nil, self)
	    portrait.bg = E.CreateBG(portrait)
		portrait.PostUpdate = E.PortraitUpdate
	    portrait:SetAllPoints(health)
		portrait.type = '3D'
	    self.Portrait = portrait

		local overlay = CreateFrame("Frame", nil, self)
		overlay:SetFrameLevel(0)
	
		health.bg:ClearAllPoints()
		health.bg:SetPoint('BOTTOMLEFT', health:GetStatusBarTexture(), 'BOTTOMRIGHT')
		health.bg:SetPoint('TOPRIGHT', health)
		health.bg:SetDrawLayer("OVERLAY", 7)
		health.bg:SetParent(overlay)		
	end 
	
 	if self:GetParent():GetName():match"oUF_MainTank" or unit:find("boss%d") then
		self:SetAttribute('initial-height', C["raid"].gridh-10)
		self:SetAttribute('initial-width', C["raid"].gridw+20)
		name:SetFont(E.font, 9, "OUTLINE")
		name:SetPoint("CENTER",health,-2,0)
		self:Tag(name, "[getnamecolor][nameshort] - [hpprec]")
		health.value:ClearAllPoints()
		self.Range.outsideAlpha = 1
			
	end

 	if self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "pet" then
		if C["raid"].astyle == 0 then
			self:SetAttribute('initial-height', C["raid"].gridh * 0.7)
		else
			self:SetAttribute('initial-width', C["raid"].nogridw * 0.6)
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
		self:RegisterEvent('CHARACTER_POINTS_CHANGED', UpdateThreat)
	end
		
	local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetHeight(16)
	RaidIcon:SetWidth(16)
	if C["raid"].astyle == 0 then
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

--	self:RegisterEvent("UNIT_PET", updateAllElements)

	return self
end

local NUM_RAID_GROUPS --显示的小队数量
NUM_RAID_GROUPS = C["raid"].raidgroups
if NUM_RAID_GROUPS > 8 or NUM_RAID_GROUPS < 1 then NUM_RAID_GROUPS = 5 end

oUF:RegisterStyle("EUI", Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("EUI")
	if C["raid"].showParty == true then
		local showpartytarget
		if C["raid"].showPartyTarget == true then
			showpartytarget = "oUF_Party"
		else
			showpartytarget = "oUF_PartyNoTarget"
		end
		if C["raid"].astyle == 0 then
			local party = self:SpawnHeader("oUF_Party", nil, "party",
				'oUF-initialConfigFunction', [[
					local header = self:GetParent()
					self:SetWidth(header:GetAttribute('initial-width'))
					self:SetHeight(header:GetAttribute('initial-height'))
				]],
				'initial-width', C["raid"].gridw,
				'initial-height', C["raid"].gridh,		
				"showSolo", false,
				"showPlayer", true, 
				"showParty", true,
				"showRaid", true,			
				"xOffset", 8,
				"point", "LEFT"
			)
			party:SetPoint("TOPLEFT", EuiRaidBackground, "TOPLEFT", 0, 0)
			if C["raid"].showPartyTarget == true then
				local partytarget = self:SpawnHeader("oUF_PartyTarget", nil, "party",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
						self:SetAttribute("unitsuffix", "target")
					]],
					'initial-width', C["raid"].gridw,
					'initial-height', C["raid"].gridh*.7,		
					"showSolo", false,
					"showPlayer", true, 
					"showParty", true,
					"showRaid", true,			
					"xOffset", 8,
					"point", "LEFT"
				)	
				partytarget:SetPoint("TOP", party, "BOTTOM", 0, -18)		
				local partypet = self:SpawnHeader("oUF_PartyPet", nil, "party",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
						self:SetAttribute("useOwnerUnit", "true")
						self:SetAttribute("unitsuffix", "pet")
					]],
					'initial-width', C["raid"].gridw,
					'initial-height', C["raid"].gridh*.7,		
					"showSolo", false,
					"showPlayer", true, 
					"showParty", true,
					"showRaid", true,			
					"xOffset", 8,
					"point", "LEFT"
				)
				partypet:SetPoint("TOP", partytarget, "BOTTOM", 0, -18)
			end
		else
			local party = self:SpawnHeader("oUF_Party", nil, "party",
				'oUF-initialConfigFunction', [[
					local header = self:GetParent()
					self:SetWidth(header:GetAttribute('initial-width'))
					self:SetHeight(header:GetAttribute('initial-height'))
				]],	
				'initial-width', C["raid"].nogridw,
				'initial-height', C["raid"].nogridh,		
				"showSolo", false,
				"showPlayer", true, 
				"showParty", true,
				"showRaid", true,	
				"yOffset", 18,
				"point", "BOTTOM"
			)
			party:SetPoint("LEFT", EuiRaidBackground, 0, 0)
			if C["raid"].showPartyTarget == true then
				local partytarget = self:SpawnHeader("oUF_PartyTarget", nil, "party",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
						self:SetAttribute("unitsuffix", "target")
					]],
					'initial-width', C["raid"].nogridw*.7,
					'initial-height', C["raid"].nogridh,		
					"showSolo", false,
					"showPlayer", true, 
					"showParty", true,
					"showRaid", true,			
					"yOffset", 18,
					"point", "LEFT"
				)	
				partytarget:SetPoint("BOTTOMLEFT", party, "BOTTOMRIGHT", 8, 0)		
				local partypet = self:SpawnHeader("oUF_PartyPet", nil, "party",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
						self:SetAttribute("useOwnerUnit", "true")
						self:SetAttribute("unitsuffix", "pet")
					]],
					'initial-width', C["raid"].nogridw*.7,
					'initial-height', C["raid"].nogridh,		
					"showSolo", false,
					"showPlayer", true, 
					"showParty", true,
					"showRaid", true,			
					"yOffset", 18,
					"point", "LEFT"
				)
				partypet:SetPoint("BOTTOMLEFT", partytarget, "BOTTOMRIGHT", 8, 0)
			end			
		end
	end

	if C["raid"].mt == true then
		local tank = self:SpawnHeader("oUF_MainTank", nil, 'raid',
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],	
			'initial-width', C["raid"].gridw+20,
			'initial-height', C["raid"].gridh-8,		
			'ShowRaid', true,
			'yOffset', -20
			)
        if oRA3 then
            tank:SetAttribute("initial-unitWatch", true)
            tank:SetAttribute("nameList", table.concat(oRA3:GetSortedTanks(), ","))

            local tankhandler = {}
            function tankhandler:OnTanksUpdated(event, tanks) 
                tank:SetAttribute("nameList", table.concat(tanks, ","))
            end
            oRA3.RegisterCallback(tankhandler, "OnTanksUpdated")
        else			
			tank:SetAttribute('groupFilter', 'MAINTANK')
		end
		tank:SetPoint("BOTTOMRIGHT", -200, 160)
		local tanktarget = self:SpawnHeader("oUF_MainTankTarget", nil, 'raid',
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
				self:SetAttribute("unitsuffix", "target")
			]],	
			'initial-width', C["raid"].gridw+20,
			'initial-height', C["raid"].gridh-8,		
			'ShowRaid', true,
			'yOffset', -20,
			'groupFilter', 'MAINTANK'
			)
		tanktarget:SetPoint("TOPLEFT", tank, "TOPRIGHT", 5, 0)
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
			boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
			if i == 1 then
				boss[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 452, 560)
			else
				boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
			end
		end
	end	

	local raid = {}
	if C["raid"].astyle == 0 then
		if C["raid"].grouphv == true then --队伍为横排
			for i = 1, NUM_RAID_GROUPS do
				raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
					]],
					'initial-width', C["raid"].gridw,
					'initial-height', C["raid"].gridh,	
					"showParty", true,
					"showPlayer", true,
					"showRaid", true,
					"xoffset", 8,
					"yOffset", 18,
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
					raid[i]:SetPoint("BOTTOMLEFT", EuiRaidBackground, "BOTTOMLEFT", 0, C["raid"].gridh * (i - 1) + 18*(i - 1))
				end
			else --5队排在下面.
				for i = 1, NUM_RAID_GROUPS, 1 do
					raid[i]:SetPoint("BOTTOMLEFT", EuiRaidBackground, "BOTTOMLEFT", 0, C["raid"].gridh * (NUM_RAID_GROUPS-i) + 18*(NUM_RAID_GROUPS-i))
				end
			end
		else
			for i = 1, NUM_RAID_GROUPS do --小队竖排
				raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
					]],
					'initial-width', C["raid"].gridw,
					'initial-height', C["raid"].gridh,				
					"showParty", true,
					"showPlayer", true,
					"showRaid", true,
					"xoffset", 0,
					"yOffset", 18,
					"point", "BOTTOM",
					"groupFilter", tostring(i),
					"groupingOrder", tostring(i),
					"groupBy", "GROUP",
					"maxColumns", 1,
					"unitsPerColumn", 5,
					"columnSpacing", 3,
					"columnAnchorPoint", raidDirection
				)
				raid[i]:SetPoint("TOPLEFT", EuiRaidBackground, "TOPLEFT", (C["raid"].gridw + 8)*(i - 1), 0)
			end
		end		
	elseif C["raid"].astyle == 1 then
		for i = 1, NUM_RAID_GROUPS do
			raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
					]],
					'initial-width', C["raid"].nogridw,
					'initial-height', C["raid"].nogridh,		
				"showParty", true,
				"showPlayer", true, 
				"showRaid", true, 
				"xoffset", 0,
				"yOffset", -18,
				"point", "TOP",
				"groupFilter", tostring(i),
				"groupingOrder", tostring(i),
				"groupBy", "GROUP",
				"maxColumns", 1,
				"unitsPerColumn", 5,
				"columnSpacing", 3,
				"columnAnchorPoint", raidDirection		
			)
			if i > 5 then --小队超过5队时,第6队排到第5队的右边
				raid[i]:SetPoint('BOTTOMLEFT', "oUF_EUI_raid"..tostring(i-5), 'BOTTOMRIGHT', 16, 0)
			else
				raid[i]:SetPoint("TOPLEFT", EuiRaidBackground, "TOPLEFT", 0, -(C["raid"].nogridh * 5 + 72 + C["raid"].groupspace)*(i-1))
			end
		end
	elseif C["raid"].astyle == 2 then
		for i = 1, NUM_RAID_GROUPS do
			raid[i] = self:SpawnHeader("oUF_EUI_raid"..i, nil, "raid",
					'oUF-initialConfigFunction', [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute('initial-width'))
						self:SetHeight(header:GetAttribute('initial-height'))
					]],
					'initial-width', C["raid"].nogridw,
					'initial-height', C["raid"].nogridh,			
				"showParty", true,
				"showPlayer", true, 
				"showRaid", true, 
				"xoffset", 0,
				"yOffset", -18,
				"point", "TOP",
				"groupFilter", tostring(i),
				"groupingOrder", tostring(i),
				"groupBy", "GROUP",
				"maxColumns", 1,
				"unitsPerColumn", 5,
				"columnSpacing", 3,
				"columnAnchorPoint", raidDirection		
			)
			if i%2 == 1 then
				raid[i]:SetPoint("BOTTOMLEFT", EuiRaidBackground, "BOTTOMLEFT", 0, (C["raid"].nogridh * 5 + 72 + C["raid"].groupspace) * floor(i / 2))
			else
				raid[i]:SetPoint("BOTTOMRIGHT", EuiRaidBackground, "BOTTOMRIGHT", 0, (C["raid"].nogridh * 5 + 72 + C["raid"].groupspace) * (i / 2 - 1))
			end			
		end
	end
end)