local E, C, L, DB = unpack(EUI)
local oUF = EuiUF or oUF
--[[
	Title: 		oUF_Ljxx
	Version: 	30200
	Requires: 	oUF 1.3.x
	Credits: 	cadcamzy@hotmail.com
]]--
if C["unitframe"].aaaaunit ~= 1 then return end
local pty = 300 --头像基准高度300
local ptx = 250 --玩家与目标间的间隔500/2
--if C["unitframe"].playerx >0 then ptx = C["unitframe"].playerx end
--if C["unitframe"].playery >0 then pty = C["unitframe"].playery end
--if C["raid"].grid == true then pty = pty + 74 end

local playerwidth, petwidth, totwidth, focuswidth, partywidth = 230, 130, 130, 100, 180
local playerheight, petheight, totheight, focuswheight, partyheight = 36, 36, 22, 22, 28

if C["unitframe"].playerwidth >0 then playerwidth = C["unitframe"].playerwidth end
if C["unitframe"].petwidth >0 then petwidth = C["unitframe"].petwidth end
if C["unitframe"].totwidth >0 then totwidth = C["unitframe"].totwidth end
if C["unitframe"].focuswidth >0 then focuswidth = C["unitframe"].focuswidth end
--focuswidth = (playerwidth-8) / 2
if C["unitframe"].playerheight >0 then playerheight = C["unitframe"].playerheight end
if C["unitframe"].petheight >0 then petheight = C["unitframe"].petheight end
if C["unitframe"].totheight >0 then totheight = C["unitframe"].totheight end
if C["unitframe"].focusheight >0 then focusheight = C["unitframe"].focusheight end

if C["raid"].astyle == 0 then
	ptx = (C["raid"].gridw * 5 + 36) / 2 + 4
	pty = C["raid"].gridh * 5 + 72 + C["raid"].gridheight
	
else
	ptx = totwidth / 2 + 8
	pty = petheight + 162 + 23 + C["actionbar"].petbuttonsize + C["actionbar"].buttonspacing*2
end	

local _, class = UnitClass('player')
local font = STANDARD_TEXT_FONT
local fontsize = 12
local fontsizesmall = 9

--if C["skins"].texture < 0 or C["skins"].texture > 9 then C["skins"].texture = 0 end

--local TEXTURE = string.format("Interface\\AddOns\\Eui\\media\\statusbar\\%d", C["skins"].texture)
local TEXTURE = C["skins"].texture

local BACKDROP = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
local SHADOWS = {
	edgeFile = "Interface\\AddOns\\Eui\\media\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function hex(r, g, b)
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function truncate(value)
	if(value >= 1e6) and (not C["unitframe"].totalhpmp == true) then
	--	return gsub(format('%.1fm', value / 1e6), '%.?0+([km])$', '%1')
		return ("%.1fm"):format(value / 1e6)
	elseif(value >= 1e3) and (not C["unitframe"].totalhpmp == true) then
	--	return gsub(format('%.0fk', value / 1e3), '%.?0+([km])$', '%1')
		return ("%.1fk"):format(value / 1e3)
	elseif C["unitframe"].totalhpmp == true then
		return value
	else
		return value
	end
end

local function ColourGradient(perc)
	if perc <= 0.5 then
		return 255, perc*510, 0
	else
		return 510 - perc*510, 255, 0
	end
end



--[[
 	tags
]]--

oUF.Tags['name'] = function(unit)

	local c = (not UnitIsConnected(unit)) and oUF.colors.disconnected or
		(not UnitIsPlayer(unit)) and oUF.colors.reaction[UnitReaction(unit, 'player')] or
		(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) and {1, 0, 0} or {1, 1, 1}
	local cn = oUF.colors.class[select(2, UnitClass(unit))] or {1,1,1}
	if UnitIsPlayer(unit) ~= 1 then cn = {1,.9,0} end
	if C["unitframe"].colorClassName == true then
		return format('|cff%02x%02x%02x%s|r', cn[1] * 255, cn[2] * 255, cn[3] * 255, E.utf8sub(UnitName(unit),7,false))
	else
		return format('|cff%02x%02x%02x%s|r', c[1] * 255, c[2] * 255, c[3] * 255, E.utf8sub(UnitName(unit), 7, false))
	end
end
oUF.TagEvents['name'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION'

oUF.Tags['shortname'] = function(unit)

	local c = (not UnitIsConnected(unit)) and oUF.colors.disconnected or
		(not UnitIsPlayer(unit)) and oUF.colors.reaction[UnitReaction(unit, 'player')] or
		(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) and {1, 0, 0} or {1, 1, 1}
	local cn = oUF.colors.class[select(2, UnitClass(unit))] or {1,1,1}
	if UnitIsPlayer(unit) ~= 1 then cn = {1,.9,0} end
	if C["unitframe"].colorClassName == true then
		return format('|cff%02x%02x%02x%s|r', cn[1] * 255, cn[2] * 255, cn[3] * 255, E.utf8sub(UnitName(unit),3,false))
	else
		return format('|cff%02x%02x%02x%s|r', c[1] * 255, c[2] * 255, c[3] * 255, E.utf8sub(UnitName(unit),3,false))
	end
end
oUF.TagEvents['shortname'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION'


oUF.Tags['difficulty']  = function(unit) 
	local level = UnitLevel(unit); 
	return UnitCanAttack('player', unit) and hex(GetQuestDifficultyColor((level > 0) and level or 99)) or '|cff0090ff'
end

oUF.TagEvents['status'] = 'UNIT_HEALTH'
oUF.Tags['status'] = function(unit)
	return not UnitIsConnected(unit) and PLAYER_OFFLINE or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and DEAD
end

oUF.TagEvents['hp'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags['hp'] = function(unit)
	if unit then
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local r,g,b = ColourGradient(min/max)
		return format('|cff%02x%02x%02x%s|r', r, g, b, truncate(min))
	else
		return ""
	end
end

oUF.TagEvents['hpprec'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags['hpperc'] = function(unit)
	if unit then
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		return format('%s%%', floor(min/max*100))
	else
		return ""
	end
end

oUF.Tags['xdpp'] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	return unit == 'player' and UnitPowerType(unit) ~= 0 and min ~= max and ('|cff5F9BFF%d%%|r |'):format(min / max * 100)
end
oUF.TagEvents['xdpp'] = 'UNIT_MANA UPDATE_SHAPESHIFT_FORM'


oUF.TagEvents['pp'] = oUF.TagEvents['curpp']
oUF.Tags['pp'] = function(unit)
	local power = UnitPower(unit)
	
	if (power > 0 and not UnitIsDeadOrGhost(unit)) then
		local num, str = UnitPowerType(unit)
		local c = oUF.colors.power[str] or oUF.colors.power["RUNES"]
		if C["unitframe"].showpprec == true then
			local pmin, pmax = UnitPower(unit), UnitPowerMax(unit)
			return format('|cff%02x%02x%02x%s|r - %s%%', c[1] * 255, c[2] * 255, c[3] * 255, truncate(power), floor(pmin/pmax*100))
		else
			return format('|cff%02x%02x%02x%s|r', c[1] * 255, c[2] * 255, c[3] * 255, truncate(power))
		end
	end
end

oUF.TagEvents['ppprec'] = 'UNIT_MANA UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags['ppprec'] = function(unit)
	if unit then
		local power = UnitPower(unit)
		local pmin, pmax = UnitPower(unit), UnitPowerMax(unit)
		local hmin, hmax = UnitHealth(unit), UnitHealthMax(unit)
		if (power > 0) then
			local num, str = UnitPowerType(unit)
			local c = oUF.colors.power[str]
			return c and format('%s-|cff%02x%02x%02x%s|r', floor(hmin/hmax*100), c[1] * 255, c[2] * 255, c[3] * 255, floor(pmin/pmax*100))
		else
			return format('%s%%', floor(hmin/hmax*100))
		end
	else
		return ""
	end
end

oUF.Tags["AltPower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ("%s%%"):format(math.floor(cur / max * 100 + 0.5))
	end
end
oUF.TagEvents["AltPower"] = "UNIT_POWER"
	
--[[
 	functions
]]--
local function updateCombo(self, event, unit)
	if(unit == PlayerFrame.unit and unit ~= self.CPoints.unit) then
		self.CPoints.unit = unit
	end
end

local PostUpdateHealth = function(Health, unit, min, max)
	if(UnitIsDead(unit) or UnitIsGhost(unit)) then
		Health:SetValue(0)
	end
--[[  	if (not unit) or (C["unitframe"].colorClass ~= true) or unit == 'player' then return end
	local class = select(2, UnitClass(unit))
	if C["unitframe"].colorClass == true then
		if UnitIsPlayer(unit) then
			Health:SetStatusBarColor(E.RAID_CLASS_COLORS[class].r, E.RAID_CLASS_COLORS[class].g, E.RAID_CLASS_COLORS[class].b)
		else
			Health:SetStatusBarColor(.26,.26,.26,1)
		end
	end ]]
end

local EclipseDirection = function(self)
	local power = UnitPower('player', SPELL_POWER_ECLIPSE)
	if ( GetEclipseDirection() == "sun" ) then
		self.value:SetText(abs(power)..">")
		self.value:SetTextColor(.2,.2,1,1)
	elseif ( GetEclipseDirection() == "moon" ) then
		self.value:SetText("<"..abs(power))
		self.value:SetTextColor(1,1,.3, 1)
	else
		self.value:SetText("")
	end
end

local PostUpdatePower = function(Power, unit, min, max)
	local power = UnitPower(unit)
	if power > 0 then
		if(UnitIsDead(unit) or UnitIsGhost(unit)) then
			Power:SetValue(0)
		end	
		local num, str = UnitPowerType(unit)
		local c = {1,1,1}
		if oUF.colors.power[str] then c = oUF.colors.power[str] end
		Power:SetStatusBarColor(c[1], c[2], c[3])
	end
end

local UpdateCB = function(self, event, unit)
	if unit ~= self.unit then return end
	local uclass = {r=1,g=1,b=1}
	if UnitClass(unit) then
		uclass.r = oUF.colors.class[select(2,UnitClass(unit))][1] or 1
		uclass.g = oUF.colors.class[select(2,UnitClass(unit))][2] or 1
		uclass.b = oUF.colors.class[select(2,UnitClass(unit))][3] or 1
	end
	if UnitIsPlayer(unit) ~= 1 then uclass = {r=1,g=.9,b=0} end
	self.Castbar.Text:SetTextColor(uclass.r, uclass.g, uclass.b)
end

local PostCreateIcon = function(Auras, button)

	E.EuiSetTemplate(button)
	button.cd.noOCC = true
	button.cd.noCooldownCount = true	-- hide CDC CDs
	Auras.disableCooldown = false		-- hide CD spiral
	Auras.showDebuffType = false			-- show debuff border type color 
--[[	
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint"BOTTOMRIGHT"


    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    
    button.overlay:SetTexture([=[Interface\AddOns\Eui\unitframe\textures\iconborder]=])
    button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.overlay:SetTexCoord(0.03, 0.97, 0.03, 0.97)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
]]
	button.cd:SetReverse()
	button.icon:SetPoint("TOPLEFT", 2, -2)
	button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:SetPoint("BOTTOMRIGHT", 1, 0)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C["skins"].font, 10, "THINOUTLINE")
				
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	
	button.remaining = button:CreateFontString(nil, "ARTWORK");
	button.remaining:SetFont(C["skins"].font, 13, "OUTLINE");	
	button.remaining:SetPoint("CENTER", 0 , 2)
	
	button.Glow = CreateFrame("Frame", nil, button)
	button.Glow:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
	button.Glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
	button.Glow:SetFrameStrata("BACKGROUND")	
	button.Glow:SetBackdrop{edgeFile = E.glowTex, edgeSize = 5, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	button.Glow:SetBackdropColor(0, 0, 0, 0)
	button.Glow:SetBackdropBorderColor(0, 0, 0)
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute then
			return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

local CreateAuraTimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
	--	local w = self:GetWidth()
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 and (self.cast == 'player' or self.cast == 'vehicle') then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(1, 0, 0)
				else
					self.remaining:SetTextColor(1, .9, 0)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local PostUpdateIcon
do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}
	PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		local texture = icon.icon
		if(playerUnits[icon.owner]) then
			texture:SetDesaturated(false)
		else
			if icon.debuff then texture:SetDesaturated(true) end
		end
		
		local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

		-- Creating aura timers
		if duration and duration > 0 and (unitCaster == 'player' or unitCaster == 'vehicle') then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon.duration = duration
		icon.timeLeft = expirationTime
		icon.first = true
		icon.cast = unitCaster
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end

end

local AuraFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)	
	local header = icon:GetParent():GetParent():GetParent():GetName()
	local inInstance, instanceType = IsInInstance()
	icon.owner = caster
	icon.isStealable = isStealable
	if UnitDebuff(unit, name)  then
		if unit == "target" or (unit and unit:find("boss%d")) then --Target/Boss Only
			if C["unitframe"].onlyplayer == true then
				-- Show all debuffs on friendly targets
				if UnitIsFriend("player", "target") then return true end
				
				local isPlayer
					
				if(caster == 'player' or caster == 'vehicle') then
					isPlayer = true
				else
					isPlayer = false
				end

				if isPlayer then
					return true
				else
					return false
				end
			else
				return true
			end
		else --Everything else
			return true
		end
	else
		return true
	end
end
	
local CheckInterrupt = function(self, unit)
	if unit == "vehicle" then unit = "player" end

	if self.interrupt and UnitCanAttack("player", unit) then
		self:SetStatusBarColor(1, 0, 0, 0.5)	
	else
		self:SetStatusBarColor(1,1,1,.8)		
	end
end

local channelingTicks = {
	-- warlock
	[GetSpellInfo(689)] = 3, -- "Drain Life"
	[GetSpellInfo(5740)] = 4, -- "Rain of Fire"
	[GetSpellInfo(1120)] = 5, -- "吸取灵魂"
	[GetSpellInfo(755)] = 3, -- "生命通道"

	-- druid
	[GetSpellInfo(44203)] = 4, -- "Tranquility"
	[GetSpellInfo(16914)] = 10, -- "Hurricane"
	-- priest
	[GetSpellInfo(15407)] = 3, -- "Mind Flay"
	[GetSpellInfo(48045)] = 5, -- "Mind Sear"
	[GetSpellInfo(47540)] = 2, -- "Penance"
	-- mage
	[GetSpellInfo(5143)] = 5, -- "Arcane Missiles"
	[GetSpellInfo(10)] = 5, -- "Blizzard"
	[GetSpellInfo(12051)] = 4, -- "Evocation"
}
local ticks = {}
local setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(E.normTex)
				ticks[k]:SetVertexColor(0, 0, 0)
				ticks[k]:SetWidth(1.6)
				ticks[k]:SetHeight(castBar:GetHeight())
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end

local CheckCast = function(self, unit, name, rank, castid)
	self:SetAlpha(1.0)
	self:SetStatusBarColor(1,1,1,.8)
	if unit == "player"then
		if self.casting then
			setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			setBarTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus" ) and self.interrupt then
		self:SetStatusBarColor(1, 0, 0,.8)
	else
		self:SetStatusBarColor(1, 1, 1,.8)
	end
end

-- custom castbar text
local function CustomTimeText(self, duration)
	self.Time:SetFormattedText('%.1f / %.1f', duration, self.max)
end

local function CPointsUpdate(self, event, unit)
	if unit == "pet" then return end
	local cp = UnitExists("vehicle") and GetComboPoints("vehicle", "target") or GetComboPoints("player", "target")
	local cpoints = self.CPoints
	for i = 1, MAX_COMBO_POINTS do
		if i <= cp then
			cpoints[i]:Show()
		else
			cpoints[i]:Hide()
		end
	end
	if self.Auras then
		self.Auras:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 1, cp > 0 and 18 or 4)
	end
end

--[[
 	layout
]]--
local Shared = function(self, unit, isSingle)

	self.menu = E.SpawnMenu

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks"AnyDown"
	self.background = E.CreateBG(self)
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(TEXTURE)
	Health:SetPoint('BOTTOMRIGHT', self, 0, 0)
	Health:SetPoint('TOPLEFT', self, 0, 0)
	Health.frequentUpdates = true
	self.Health = Health
	self.Health.colorTapping = true
	self.Health.colorClass = C["unitframe"].colorClass
	self.Health.colorSmooth = true
	self.Health.colorClassNPC = false
	self.Health.colorClassPet = false
		
	local HealthBG = Health:CreateTexture(nil, "BORDER")
	HealthBG:SetAllPoints(self.Health)
	HealthBG:SetTexture(TEXTURE)
	Health.bg = HealthBG
	Health.bg.multiplier = 0.3
	
    local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(TEXTURE)
	Power:SetParent(self)
	Power:SetFrameLevel(self.Health:GetFrameLevel()+2)
	Power:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
	Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -18)
	Power.backbg = E.CreateBG(Power)
	
	self.Power = Power
	
	Power.bg = Power:CreateTexture(nil, 'BORDER')
	Power.bg:SetAllPoints(Power)
	Power.bg:SetTexture(TEXTURE)
	Power.bg:SetVertexColor(.15,.15,.15)
	Power.bg.multiplier = 0.5
		
	Power.frequentUpdates = true
	Power.colorTapping = true
	Power.colorHappiness = true
	Power.colorClass = false
--	Power.colorReaction = true
	Power.colorDisconnected = true
	
	Health.PostUpdate = PostUpdateHealth
	Power.PostUpdate = PostUpdatePower
	
	
	if unit == "player" or unit == "target" then
		local leader = Health:CreateTexture(nil, "OVERLAY")
		leader:SetWidth(14)
		leader:SetHeight(14)
		leader:SetPoint("TOPLEFT", 17, 8)
		self.Leader = leader

		local MasterLooter = Health:CreateTexture(nil, 'OVERLAY')
		MasterLooter:SetWidth(14)
		MasterLooter:SetHeight(14)
		MasterLooter:SetPoint("TOPLEFT", 31, 8)
		self.MasterLooter = MasterLooter
	
		local RaidIcon = Health:CreateTexture(nil, "OVERLAY")
		RaidIcon:SetPoint("CENTER", 1, 1)
		RaidIcon:SetHeight(16)
		RaidIcon:SetWidth(16)
		RaidIcon:SetTexture("Interface\\AddOns\\Eui\\media\\raidicons.blp")
		
		self.RaidIcon = RaidIcon
	end
	local info = self.Health:CreateFontString(nil, 'OVERLAY')
	info:SetFont(C["skins"].font, fontsize, "OUTLINE")
	info:SetHeight(18)
	info:SetJustifyH('LEFT')
	info.frequentUpdates = 0.1
		
	local value = self.Health:CreateFontString(nil, 'OVERLAY')
	value:SetFont(C["skins"].font, fontsize, "OUTLINE")
	value:SetHeight(18)
	value:SetJustifyH('RIGHT')
	value.frequentUpdates = 0.1

	local valuepp = self.Power:CreateFontString(nil, 'OVERLAY')
	valuepp:SetFont(C["skins"].font, fontsize, "OUTLINE")
	valuepp:SetHeight(18)
	valuepp:SetJustifyH('RIGHT')
	valuepp.frequentUpdates = 0.1	

	if C["unitframe"].portrait == true then
		local portrait = CreateFrame('PlayerModel', nil, self)
	    portrait.bg = E.CreateBG(portrait)
		portrait.bg:SetBackdropColor(.1,.1,.1,1)
	    portrait:SetWidth(playerheight+18)
	    portrait:SetHeight(playerheight+18)
		portrait.PostUpdate = E.PortraitUpdate
	    self.Portrait = portrait
				
		if(unit == 'player') then
			portrait:SetPoint('TOPRIGHT', self, 'TOPLEFT', -8, 0)
			E.portrait = portrait.bg
	    elseif(unit == 'target') then
			portrait:SetPoint('TOPLEFT', self, 'TOPRIGHT', 8, 0)
		end
	end 


	
	if(unit == 'player' or unit == 'target') then
		self:SetWidth(playerwidth)
		self:SetHeight(playerheight)
		Health:SetHeight(playerheight-13)
		info:SetPoint('LEFT', self.Health, 2, 0)
		info:SetWidth(180)
    	self:Tag(info, '[difficulty][smartlevel] [rare]|r[name]')
		
		value:SetPoint('RIGHT', self.Health, -2, 0)
		value:SetWidth(140)
		self:Tag(value, '[hp] - [hpperc]')

		valuepp:SetPoint('RIGHT', self.Power, -2, 1)
		valuepp:SetWidth(100)
		if class == 'DRUID' then
			self:Tag(valuepp, '[xdpp] [pp]') 
		else
			self:Tag(valuepp, '[pp]')
		end
		
	elseif(unit == 'pet' or unit:find("boss%d")) then
	
		self:SetWidth(petwidth)
		self:SetHeight(petheight)
		Health:SetHeight(23)
		
		info:SetPoint('LEFT', self.Health, 2, 0)
		info:SetWidth(98)
    	self:Tag(info, '[name]')
		
		value:SetPoint('RIGHT', self.Health, -2, -0)
		self:Tag(value, '[hpperc]')
		
		valuepp:SetPoint('RIGHT', self.Power, -2, 1)
		valuepp:SetWidth(100)
		self:Tag(valuepp, '[pp]')

	elseif(unit == 'targettarget') then

		self:SetWidth(totwidth)
		self:SetHeight(totheight)

     	Health:SetHeight(18)
     	Power:Hide()
		info:SetPoint('LEFT', self.Health, 2, 0)
		info:SetWidth(98)
    	self:Tag(info, '[shortname]')
    	
		value:SetPoint('RIGHT', self.Health, -2, 0)
		self:Tag(value, '[ppprec]')
	
	elseif(unit == 'focustarget' or unit == 'focus') then
		self:SetWidth(focuswidth)
		self:SetHeight(focusheight)

     	Health:SetHeight(18)
     	Power:Hide()
		
		info:SetPoint('LEFT', self.Health, 2, 0)
		info:SetWidth(98)
    	self:Tag(info, '[shortname]')
    	
		value:SetPoint('RIGHT', self.Health, -2, 0)
		self:Tag(value, '[ppprec]')	
		
	else
		self:SetWidth(110)
		self:SetHeight(20)
		Health:SetHeight(16)
		Power:Hide()
		
		info:SetPoint('LEFT', self.Health,2,0)
		info:SetWidth(50)
		self:Tag(info, '[shortname]')
		
		value:SetPoint('RIGHT', self.Health, -2,0)
		self:Tag(value, '[hpperc]')

	end
	if (unit == 'player' or unit == 'target' or unit == 'focus' or unit == 'vehicle') then
		if C["unitframe"].castbar == true then
			if C["unitframe"].bigcastbar == false then
				local cb = CreateFrame("StatusBar", nil, self)
				cb:SetStatusBarTexture(TEXTURE)
				cb:SetStatusBarColor(1,1,1,.8)
				if unit == 'focus' then
					cb:SetAllPoints(Health)
				else
					cb:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -6)
					cb:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -6)
					cb:SetHeight(18)
				end
				cb:SetToplevel(true)
				cb:SetFrameStrata("MEDIUM")
				self.Castbar = cb
			elseif C["unitframe"].bigcastbar == true then
				--大型施法条
				local unm = {0,500,0,168,0,120}
				local bcb = CreateFrame("StatusBar", "EuiUnitframeCastbar"..unit, UIParent)
				bcb:SetStatusBarTexture(TEXTURE)
				bcb:SetStatusBarColor(1,1,1,.8)
				bcb:SetHeight(24*C["unitframe"].bigcastbarscale)
				bcb:SetWidth(240*C["unitframe"].bigcastbarscale)
				bcb:SetFrameStrata("MEDIUM")
				if unit == 'player' then	
					bcb:SetPoint("BOTTOM", UIParent, "BOTTOM", unm[3], unm[4])
				elseif unit == 'target' then
					bcb:SetPoint("BOTTOM", UIParent, "BOTTOM", unm[5], unm[6])
				elseif unit == 'focus' then
					bcb:SetPoint("BOTTOM", UIParent, "BOTTOM", unm[1], unm[2])
					bcb:SetWidth(300*C["unitframe"].bigcastbarscale)
				end
				
				local i = bcb:CreateTexture(nil, "ARTWORK")
				i:SetWidth(bcb:GetHeight()-2)
				i:SetHeight(bcb:GetHeight()-2)
				i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				i:Show()			
				i:SetPoint("RIGHT", bcb, "LEFT", -6, 0)

				bg = CreateFrame("Frame", nil, bcb)
				bg.bg = E.CreateBG(bg)
				bg:SetAllPoints(i)
				
				self.Castbar = bcb
				self.Castbar.Icon = i
				E.CreateMover(bcb, "EuiUnitframeCastbar"..unit.."Mover", unit.."大型施法条", nil, nil)
				
			end
			self.Castbar.PostCastStart = CheckCast
			self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
			self.Castbar.bg:SetAllPoints(self.Castbar)
			self.Castbar.bg:SetTexture(TEXTURE)
			self.Castbar.bg:SetVertexColor(.15,.15,.15)
				
			self.Castbar.FrameBackdrop = E.CreateBG(self.Castbar)
			
			self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
			if unit == 'focus' and C["unitframe"].bigcastbar ~= true then
				self.Castbar.Text:SetFont(C["skins"].font, fontsizesmall, "OUTLINE")
				self.Castbar.Text:SetHeight(18)
				self.Castbar.Text:SetJustifyH('LEFT')
				self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
			else
				self.Castbar.Text:SetFont(C["skins"].font, fontsize, "OUTLINE")
				self.Castbar.Text:SetHeight(18)				
			end
			
			table.insert(self.__elements, UpdateCB)
			self:RegisterEvent("UNIT_SPELLCAST_START", UpdateCB)
			self:RegisterEvent("UNIT_SPELLCAST_FAILED", UpdateCB)
			self:RegisterEvent("UNIT_SPELLCAST_STOP", UpdateCB)
			self.Castbar.Text:SetJustifyH('LEFT')
			self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
			
			if unit == 'player' then
				local z = self.Castbar:CreateTexture(nil,"ADD")
				z:SetTexture(TEXTURE)
				z:SetBlendMode("ADD")
				z:SetVertexColor(.8,.31,.45,.7)
				z:SetPoint("TOPRIGHT")
				z:SetPoint("BOTTOMRIGHT")
				self.Castbar.SafeZone = z
			end
		
			self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
			self.Castbar.Time:SetFont(C["skins"].font, fontsizesmall, "OUTLINE")
			self.Castbar.Time:SetHeight(18)
			self.Castbar.Time:SetJustifyH('RIGHT')		
			self.Castbar.Time:SetPoint("RIGHT", self.Castbar, -4, 0)
			self.Castbar.CustomTimeText = CustomTimeText
			self.Castbar.PostCastStart = CheckCast
			self.Castbar.PostChannelStart = CheckCast
		end
	end

	--DZ,XD连击点
	if(unit == 'target' and (class == 'ROGUE' or class == 'DRUID')) and C["unitframe"].cpoint == true then
		self.CPoints = CreateFrame('Frame', nil, self)
		self.CPoints:SetWidth(playerwidth)
		self.CPoints:SetHeight(8)
		self.CPoints:SetBackdropColor(0,0,0,0)
		self.CPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 6)		
				
		for i = 1,5 do
			self.CPoints[i] = CreateFrame("StatusBar", self:GetName().."_CPoints"..i, self)
			self.CPoints[i]:SetHeight(8)
			self.CPoints[i]:SetWidth((playerwidth-28)/5)
			self.CPoints[i]:SetStatusBarTexture(TEXTURE)
			self.CPoints[i].backbg = E.CreateBG(self.CPoints[i])	
						
			if (i == 1) then
				self.CPoints[i]:SetPoint("BOTTOMLEFT", self.CPoints, "BOTTOMLEFT", 0, 0)
			else
				self.CPoints[i]:SetPoint("TOPLEFT", self.CPoints[i-1], "TOPRIGHT", 7, 0)
			end	
		end
		self.CPoints[1]:SetStatusBarColor(152/255, 190/255, 24/255)
		self.CPoints[2]:SetStatusBarColor(152/255, 190/255, 24/255)
		self.CPoints[3]:SetStatusBarColor(30/255, 110/255, 220/255)
		self.CPoints[4]:SetStatusBarColor(30/255, 110/255, 220/255)
		self.CPoints[5]:SetStatusBarColor(160/255, 24/255, 48/255)
		self.CPoints.Override = CPointsUpdate
	end
	--DK符文条
	
	if(class == 'DEATHKNIGHT' and unit == 'player') and C["unitframe"].cpoint == true then
		self.Runes = CreateFrame('Frame', nil, self)
		self.Runes:SetWidth(playerwidth)
		self.Runes:SetHeight(8)
		self.Runes:SetBackdropColor(0,0,0,0)
		self.Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 6)
		for i = 1, 6 do
			self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
			self.Runes[i]:SetHeight(8)
			self.Runes[i]:SetWidth((playerwidth -35) /6)
			self.Runes[i]:SetStatusBarTexture(TEXTURE)
			self.Runes[i]:SetBackdrop(BACKDROP)
			self.Runes[i]:SetBackdropColor(.1,.1,.1,1)				
			
			self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
			self.Runes[i].bg:SetAllPoints(self.Runes[i])				
			self.Runes[i].bg:SetTexture(0.3, 0.3, 0.3)
			
			self.Runes[i].FrameBackdrop = E.CreateBG(self.Runes[i])
				
			if (i == 1) then
				self.Runes[i]:SetPoint("BOTTOMLEFT", self.Runes, "BOTTOMLEFT", 0, 0)
			else
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i-1], "TOPRIGHT", 7, 0)
			end	
		end
	end

	--Druid Power Bar
	if unit == 'player' and class == "DRUID" and C["unitframe"].cpoint == true then
		local eclipseBar = CreateFrame('Frame', nil, self)
		eclipseBar:SetWidth(playerwidth)
		eclipseBar:SetHeight(9)
		eclipseBar:SetBackdropColor(0, 0, 0)
		eclipseBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 6)		
		
		eclipseBar.FrameBackdrop = E.CreateBG(eclipseBar)		
		
		local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
		lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
		lunarBar:SetSize(playerwidth, 9)
		lunarBar:SetStatusBarTexture(TEXTURE)
		lunarBar:SetStatusBarColor(.30, .52, .90)
		eclipseBar.LunarBar = lunarBar

		eclipseBar.value = eclipseBar.LunarBar:CreateFontString(nil, "OVERLAY")
		eclipseBar.value:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
		eclipseBar.value:SetJustifyH("CENTER")
		eclipseBar.value:SetPoint("CENTER", lunarBar:GetStatusBarTexture(), "RIGHT",0, 0)
		
		
		local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
		solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
		solarBar:SetSize(playerwidth, 9)
		solarBar:SetStatusBarTexture(TEXTURE)
		solarBar:SetStatusBarColor(.80, .82,  .60)
		eclipseBar.SolarBar = solarBar
		
		self.EclipseBar = eclipseBar
		self.EclipseBar.PostUpdatePower = EclipseDirection
	end

	--warlock or PALADIN bar
	if unit == 'player' and (class == 'WARLOCK' or class == 'PALADIN') and C["unitframe"].cpoint == true then
		local shards = CreateFrame('StatusBar', nil, self)
		shards:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 6)
		shards:SetWidth(playerwidth)
		shards:SetHeight(8)
		shards:SetBackdropColor(0, 0, 0)

		shards.FrameBackdrop = E.CreateBG(shards)		
				
		for id = 1, 3 do
			local shard = CreateFrame("StatusBar", nil, shards)
			shard:SetStatusBarTexture(TEXTURE)
			if class == 'WARLOCK' then
				shard:SetStatusBarColor(148/255, 130/255, 201/255)
			else
				shard:SetStatusBarColor(228/255,225/255,16/255)
			end	
			if id > 1 then
				shard:SetSize((playerwidth-4)/3, 8)
				shard:SetPoint('BOTTOMLEFT', shards[id-1], 'BOTTOMRIGHT', 2, 0)
			else
				shard:SetSize((playerwidth-4)/3, 8)
				shard:SetPoint('BOTTOMLEFT', shards, 'BOTTOMLEFT', 0, 0)
			end

			shards[id] = shard
		end
		if class == 'WARLOCK' then
			shards.Override = E.UpdateShards
			self.SoulShards = shards
		else
			shards.Override = E.UpdateHoly
			self.HolyPower = shards
		end
	end	

	--oUF_Tot
	if(unit == 'player' and class == 'SHAMAN') and C["unitframe"].cpoint == true then
		self.TotemBar = {}
		self.TotemBar.Destroy = true
		for i = 1, 4 do
			self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
			self.TotemBar[i]:SetHeight(8)
			self.TotemBar[i]:SetWidth((playerwidth-21)/4)
		
			if (i == 1) then
				self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 6)
			else
				self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 7, 0)
			end

			self.TotemBar[i]:SetStatusBarTexture(TEXTURE)
			self.TotemBar[i]:SetBackdrop(BACKDROP)
			self.TotemBar[i]:SetBackdropColor(0, 0, 0)
			self.TotemBar[i]:SetMinMaxValues(0, 1)

			self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
			self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
			self.TotemBar[i].bg:SetTexture(TEXTURE)
			self.TotemBar[i].bg.multiplier = 0.25
			
			self.TotemBar[i].FrameBackdrop = E.CreateBG(self.TotemBar[i])
			
		end
	end	


	--[[ oUF_CombatFeedback support
	if (unit == 'player' or unit == 'target') then
		self.CombatFeedbackText = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallRight')
		self.CombatFeedbackText:SetPoint("RIGHT", health, "RIGHT", -2, 0)
	end
]]
	-- 添加战斗标志
	if (unit == 'player') then
		self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
		self.Combat:SetPoint('TOPRIGHT', -1, 7)
		self.Combat:SetHeight(16)
		self.Combat:SetWidth(16)
	--	self.Combat:SetVertexColor(255, 0, 0)	
    end  
	
	-- 添加PVP标志
  -- PvP icon
   if unit == 'player' and C["unitframe"].showPvP == true then
      self.PvP = self.Health:CreateTexture(nil, 'OVERLAY')
      self.PvP:SetWidth(14)
      self.PvP:SetHeight(14)
      self.PvP:SetPoint('TOPLEFT', -1, 7)
      self.PvP:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
      self.PvP:SetTexCoord(0.09, 0.43, 0.08, 0.42)
   end
   
	--五秒回蓝
	if unit == "player" and C["unitframe"].powerspark == true and (class ~= "ROGUE" and class ~= "WARRIOR" and class ~= "DEATHKNIGHT") then
		local spark = Power:CreateTexture(nil, "OVERLAY")
		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spark:SetVertexColor(1, 1, 1, 0.5)
		spark:SetBlendMode("ADD")
		spark:SetHeight(Power:GetHeight()*2)
		spark:SetWidth(Power:GetHeight())
		self.Spark = spark
	end
   
	--自动功击条
	if unit == 'player' and C["unitframe"].swing == true then
		local swing = CreateFrame("StatusBar",nil,self)
		swing:SetStatusBarTexture(TEXTURE)
		swing:SetStatusBarColor(.8,.8,.8)
		swing:SetHeight(1)
		swing:SetWidth(playerwidth-4)
		swing:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
		self.Swing = swing
	end
	
--	if C["unitframe"].boss == true and (unit and unit:find('boss%d')) then
--		self.AltPowerBar = CreateFrame("Frame", nil, self.Power)
--		self.AltPowerBar:SetFrameLevel(self.Power:GetFrameLevel() + 1)
--		self.AltPowerBar:SetAllPoints(self.Power)

--		self.AltPowerBar.text = E.EuiSetFontn(self.AltPowerBar, font, fontsize)
--		self.AltPowerBar.text:SetPoint("LEFT", self.AltPowerBar, "LEFT", 2, 0)
--		self:Tag(self.AltPowerBar.text, "[AltPower]")
--	end
	
--aura
	if unit == 'player' then
		local Debuffs = CreateFrame("Frame", nil, self)
		if (E.MyClass == "DEATHKNIGHT" or E.MyClass == "SHAMAN") and C["unitframe"].playerdebuffnum > 0 then
			Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 18)
		else
			Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 4)
		end
		Debuffs.showDebuffType = true
		Debuffs.initialAnchor = 'BOTTOMLEFT'
		Debuffs:SetHeight(75)
		Debuffs:SetWidth(C["unitframe"].playerwidth)
		Debuffs.num = C["unitframe"].playerdebuffnum
		Debuffs.size = C["unitframe"].bigaurassize
		Debuffs.spacing = 4
		Debuffs['growth-x'] = 'RIGHT'
		Debuffs['growth-y'] = 'UP'
		self.Debuffs = Debuffs

		Debuffs.PostCreateIcon = PostCreateIcon
		Debuffs.PostUpdateIcon = PostUpdateIcon		
	end
	
	if unit == 'target' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 4)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].playerwidth)
		Auras:SetHeight(C["unitframe"].playerheight * 2)
		Auras.size = C["unitframe"].bigaurassize
		Auras.spacing = 4
		Auras.gap = true
		Auras.numBuffs = C["unitframe"].targetbuffs
		Auras.numDebuffs = C["unitframe"].targetdebuffs
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras
		Auras.CustomFilter = AuraFilter
	end

	if unit == 'targettarget' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].totwidth)
		Auras:SetHeight(26)
		Auras.size = C["unitframe"].smallaurassize
		Auras.spacing = 6
		Auras.gap = false
		Auras.numBuffs = 0
		Auras.numDebuffs = C["unitframe"].totdebuffs

		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras
	end

	if unit == 'focus' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].focuswidth)
		Auras:SetHeight(26)
		Auras.size = C["unitframe"].smallaurassize
		Auras.spacing = 6
		Auras.gap = false
		Auras.numBuffs = C["unitframe"].Fbuffs
		Auras.numDebuffs = C["unitframe"].Fdebuffs

		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras
	end
	
	if unit == 'focustarget' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].focuswidth)
		Auras:SetHeight(26)
		Auras.size = C["unitframe"].smallaurassize
		Auras.spacing = 6
		Auras.gap = false
		Auras.numBuffs = 0
		Auras.numDebuffs = 0

		Auras.PostCreateIcon = PostCreateIcon
		self.Auras = Auras
	end
	
	if unit == 'pet' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 4)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].petwidth)
		Auras:SetHeight(18)
		Auras.size = C["unitframe"].bigaurassize
		Auras.spacing = 4
		Auras.gap = true
		Auras.numBuffs = C["unitframe"].petbuffs
		Auras.numDebuffs = C["unitframe"].petdebuffs
		Auras.PostCreateIcon = PostCreateIcon
		self.Auras = Auras
	end
	
	
	
end

oUF:RegisterStyle("Ljxx", Shared)

local spawnHelper = function(self, unit, ...)
	local object = self:Spawn(unit,'Ljxx_'..unit..'Frame')
	object:SetPoint(...)
	return object
end



--[[
 	factory
]]--
oUF:Factory(function(self)
	spawnHelper(self, 'player', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx, pty)
	spawnHelper(self, 'target', 'TOPLEFT', UIParent, 'BOTTOM', ptx, pty)
	spawnHelper(self, 'targettarget', 'TOPLEFT', UIParent, 'BOTTOM', ptx, pty-34-playerheight-16)
	spawnHelper(self, 'focus', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx-focuswidth-8, pty-34-playerheight-16)
	if C["unitframe"].portrait == true then
		spawnHelper(self, 'pet', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx-playerwidth-8-playerheight-28, pty)
	else
		spawnHelper(self, 'pet', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx-playerwidth-12, pty)
	end
	spawnHelper(self, 'focustarget', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx, pty-34-playerheight-16)	
	
	if C["unitframe"].boss == true then
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
end)

if C["raid"].raid == true then
	oUF:DisableBlizzard'party'
end

do
	local PET_DISMISS = "PET_DISMISS"
	if E.MyClass == "HUNTER" then
		PET_DISMISS = nil;
	end
	
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", PET_DISMISS, "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" };
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "RAID_MAINTANK", "RAID_MAINASSIST", "RAID_TARGET_ICON", "SELECT_ROLE", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" };
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end