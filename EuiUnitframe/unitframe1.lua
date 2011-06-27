local E, C = unpack(EUI)
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
	ptx = (C["raid"].gridw * 5 + 20) / 2 + 4
	pty = C["raid"].gridh * 5 + 20 + C["raid"].gridheight
	
else
	ptx = totwidth / 2 + 8
	pty = petheight + 162 + 23 + C["actionbar"].petbuttonsize + C["actionbar"].buttonspacing*2
end	

local _, class = UnitClass('player')
local font = STANDARD_TEXT_FONT
local fontsize = 12
local fontsizesmall = 9

if C["skins"].texture < 0 or C["skins"].texture > 9 then C["skins"].texture = 0 end

local TEXTURE = string.format("Interface\\AddOns\\Eui\\media\\statusbar\\%d", C["skins"].texture)

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
	button.count:SetFont(E.fontn, 10, "THICKOUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
			
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	
	button.remaining = E.EuiSetFontn(button, E.font, 12, "LEFT")
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
					self.remaining:SetTextColor(1, 0.9, 0)
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
			if C["unitframe"].onlyplayer == true then icon:Hide() end --只显示玩家施放的DEBUFF			
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

local function CreateShadow(f)
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -4, 4)
	shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	shadow:SetBackdrop(SHADOWS)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
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
	self:SetBackdrop({
		  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		  edgeFile = "Interface\\Buttons\\WHITE8x8", 
		  tile = false, tileSize = 0, edgeSize = 1, 
		  insets = { left = -1, right = -1, top = -1, bottom = -1}
		})
	self:SetBackdropColor(.1,.1,.1,1)
	self:SetBackdropBorderColor(.3,.3,.3,1)	
	CreateShadow(self)
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	
	if C["other"].focuser == true then
		local modifier = "shift" -- shift, alt or ctrl
		local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any

		local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
		f:SetAttribute("type1","macro")
		f:SetAttribute("macrotext","/focus mouseover")
		SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

		self:SetAttribute('shift-type1', 'focus')
	end	
	
	
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(TEXTURE)
--	Health:SetStatusBarColor(.26,.26,.26,1)
	Health:SetPoint('BOTTOMRIGHT', self, -2, 2)
	Health:SetPoint('TOPLEFT', self, 2, -2)
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

	local powerbg = CreateFrame("Frame", nil, self)
	powerbg:SetBackdrop(self:GetBackdrop())
	powerbg:SetBackdropColor(.1,.1,.1,1)
	powerbg:SetBackdropBorderColor(.3,.3,.3,1)
	powerbg:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
	powerbg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -16)
	
	CreateShadow(powerbg)
	
    local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(TEXTURE)
	Power:SetParent(self)
	Power:SetFrameLevel(powerbg:GetFrameLevel()+1)
	Power:SetPoint('TOPLEFT', powerbg,'TOPLEFT', 2, -2)
	Power:SetPoint('BOTTOMRIGHT', powerbg,'BOTTOMRIGHT', -2, 2)
	self.Power = Power
	self.Power.powerbg = powerbg
	
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
	info:SetFont(E.font, fontsize, "OUTLINE")
	info:SetHeight(18)
	info:SetJustifyH('LEFT')
	info.frequentUpdates = 0.1
		
	local value = self.Health:CreateFontString(nil, 'OVERLAY')
	value:SetFont(E.font, fontsize, "OUTLINE")
	value:SetHeight(18)
	value:SetJustifyH('RIGHT')
	value.frequentUpdates = 0.1

	local valuepp = self.Power:CreateFontString(nil, 'OVERLAY')
	valuepp:SetFont(E.font, fontsize, "OUTLINE")
	valuepp:SetHeight(18)
	valuepp:SetJustifyH('RIGHT')
	valuepp.frequentUpdates = 0.1	

	if C["unitframe"].portrait == true then
		local portrait = CreateFrame('PlayerModel', nil, self)
	    portrait:SetBackdrop(self:GetBackdrop())
		portrait:SetBackdropColor(.1,.1,.1,1)
		portrait:SetBackdropBorderColor(.3,.3,.3,1)	
	    portrait:SetWidth(playerheight+16)
	    portrait:SetHeight(playerheight+16)
		portrait.PostUpdate = E.PortraitUpdate
	    self.Portrait = portrait
		CreateShadow(portrait)
		
		if(unit == 'player') then
			portrait:SetPoint('TOPRIGHT', self, 'TOPLEFT', -4, 0)
	    elseif(unit == 'target') then
			portrait:SetPoint('TOPLEFT', self, 'TOPRIGHT', 4, 0)
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

	elseif(unit == 'targettarget') then

		self:SetWidth(totwidth)
		self:SetHeight(totheight)

     	Health:SetHeight(18)
     	Power:Hide()
		Power.powerbg:Hide()
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
		Power.powerbg:Hide()
		
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
		Power.powerbg:Hide()
		
		info:SetPoint('LEFT', self.Health,2,0)
		info:SetWidth(50)
		self:Tag(info, '[shortname]')
		
		value:SetPoint('RIGHT', self.Health, -2,0)
		self:Tag(value, '[hpperc]')

	end
	if (unit == 'player' or unit == 'target' or unit == 'focus') then
		if C["unitframe"].castbar == true then
			if C["unitframe"].bigcastbar == false then
				local cb = CreateFrame("StatusBar", nil, self)
				cb:SetStatusBarTexture(TEXTURE)
				cb:SetStatusBarColor(1,1,1,.8)
				if unit == 'focus' then
					cb:SetAllPoints(Health)
				else
					cb:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -8)
					cb:SetPoint("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -8)
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
				bg:SetBackdrop(self:GetBackdrop())
				bg:SetBackdropColor(.1,.1,.1,1)
				bg:SetBackdropBorderColor(.3,.3,.3,1)	
				bg:SetFrameLevel(1)
				CreateShadow(bg)
				bg:SetPoint("TOPLEFT", i, "TOPLEFT", -2 , 2)
				bg:SetPoint("BOTTOMRIGHT", i, "BOTTOMRIGHT", 2, -2)
				
				self.Castbar = bcb
				self.Castbar.Icon = i
				E.CreateMover(bcb, "EuiUnitframeCastbar"..unit.."Mover", unit.."大型施法条", nil, nil)
				
			end
			self.Castbar.PostCastStart = CheckCast
			self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
			self.Castbar.bg:SetAllPoints(self.Castbar)
			self.Castbar.bg:SetTexture(TEXTURE)
			self.Castbar.bg:SetVertexColor(.15,.15,.15)
				
			self.FrameBackdrop = CreateFrame("Frame", nil, self)
			self.FrameBackdrop:SetParent(self.Castbar)
			self.FrameBackdrop:SetPoint("TOPLEFT", self.Castbar, "TOPLEFT", -2, 2)
			self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMRIGHT", 2, -2)
			self.FrameBackdrop:SetFrameStrata("BACKGROUND")
			self.FrameBackdrop:SetBackdrop {
				bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeFile = "Interface\\Buttons\\WHITE8x8", 
				tile = false, tileSize = 0, edgeSize = 1, 
				insets = { left = -1, right = -1, top = -1, bottom = -1}
			}
			self.FrameBackdrop:SetFrameLevel(1)
			self.FrameBackdrop:SetBackdropColor(.1,.1,.1,1)
			self.FrameBackdrop:SetBackdropBorderColor(.3,.3,.3,1)
			

			self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
			if unit == 'focus' and C["unitframe"].bigcastbar ~= true then
				self.Castbar.Text:SetFont(E.font, fontsizesmall, "OUTLINE")
				self.Castbar.Text:SetHeight(18)
				self.Castbar.Text:SetJustifyH('LEFT')
				self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
			else
				self.Castbar.Text:SetFont(E.font, fontsize, "OUTLINE")
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
			self.Castbar.Time:SetFont(E.font, fontsizesmall, "OUTLINE")
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
		self.CPoints:SetWidth(playerwidth-4)
		self.CPoints:SetHeight(8)
		self.CPoints:SetBackdropColor(0,0,0,0)
		self.CPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)		
				
		for i = 1,5 do
			self.CPoints[i] = CreateFrame("StatusBar", self:GetName().."_CPoints"..i, self)
			self.CPoints[i]:SetHeight(8)
			self.CPoints[i]:SetWidth((playerwidth-4-16)/5)
			self.CPoints[i]:SetStatusBarTexture(TEXTURE)
			self.CPoints[i]:SetBackdrop(BACKDROP)
			self.CPoints[i]:SetBackdropColor(.1,.1,.1,1)				

			self.CPoints[i].bg = CreateFrame("Frame", nil, self.CPoints[i])
			self.CPoints[i].bg:SetPoint("TOPLEFT", self.CPoints[i], "TOPLEFT", -2, 2)
			self.CPoints[i].bg:SetPoint("BOTTOMRIGHT", self.CPoints[i], "BOTTOMRIGHT", 2, -2)
			self.CPoints[i].bg:SetBackdrop(self:GetBackdrop())
			self.CPoints[i].bg:SetBackdropColor(.1,.1,.1,1)
			self.CPoints[i].bg:SetBackdropBorderColor(.3,.3,.3,1)	
			CreateShadow(self.CPoints[i].bg)
			self.CPoints[i].bg:SetFrameLevel(self.CPoints[i]:GetFrameLevel()-1)
			
			if (i == 1) then
				self.CPoints[i]:SetPoint("BOTTOMLEFT", self.CPoints, "BOTTOMLEFT", 0, 0)
			else
				self.CPoints[i]:SetPoint("TOPLEFT", self.CPoints[i-1], "TOPRIGHT", 4, 0)
			end	
		end
		self.CPoints[1]:SetStatusBarColor(152/255, 190/255, 24/255)
		self.CPoints[2]:SetStatusBarColor(152/255, 190/255, 24/255)
		self.CPoints[3]:SetStatusBarColor(30/255, 110/255, 220/255)
		self.CPoints[4]:SetStatusBarColor(30/255, 110/255, 220/255)
		self.CPoints[5]:SetStatusBarColor(160/255, 24/255, 48/255)
		self.CPoints.Update = CPointsUpdate
	end
	--DK符文条
	
	if(class == 'DEATHKNIGHT' and unit == 'player') and C["unitframe"].cpoint == true then
		self.Runes = CreateFrame('Frame', nil, self)
		self.Runes:SetWidth(playerwidth-4)
		self.Runes:SetHeight(8)
		self.Runes:SetBackdropColor(0,0,0,0)
		self.Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)
		for i = 1, 6 do
			self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
			self.Runes[i]:SetHeight(8)
			self.Runes[i]:SetWidth((playerwidth-4 -20) /6)
			self.Runes[i]:SetStatusBarTexture(TEXTURE)
			self.Runes[i]:SetBackdrop(BACKDROP)
			self.Runes[i]:SetBackdropColor(.1,.1,.1,1)				
			
			self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
			self.Runes[i].bg:SetAllPoints(self.Runes[i])				
			self.Runes[i].bg:SetTexture(0.3, 0.3, 0.3)
			
			self.Runes[i].FrameBackdrop = CreateFrame("Frame", nil, self.Runes[i])
			self.Runes[i].FrameBackdrop:SetPoint("TOPLEFT", self.Runes[i], "TOPLEFT", -2, 2)
			self.Runes[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", self.Runes[i], "BOTTOMRIGHT", 2, -2)
			self.Runes[i].FrameBackdrop:SetBackdrop(self:GetBackdrop())
			self.Runes[i].FrameBackdrop:SetBackdropColor(.1,.1,.1,1)
			self.Runes[i].FrameBackdrop:SetBackdropBorderColor(.3,.3,.3,1)	
			CreateShadow(self.Runes[i].FrameBackdrop)
			self.Runes[i].FrameBackdrop:SetFrameLevel(self.Runes[i]:GetFrameLevel()-1)			
				
			if (i == 1) then
				self.Runes[i]:SetPoint("BOTTOMLEFT", self.Runes, "BOTTOMLEFT", 0, 0)
			else
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i-1], "TOPRIGHT", 4, 0)
			end	
		end
	end

	--Druid Power Bar
	if unit == 'player' and class == "DRUID" and C["unitframe"].cpoint == true then
		local eclipseBar = CreateFrame('Frame', nil, self)
		eclipseBar:SetWidth(playerwidth-4)
		eclipseBar:SetHeight(8)
		eclipseBar:SetBackdropColor(0, 0, 0)
		eclipseBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)		
		
				
		eclipseBar.FrameBackdrop = CreateFrame("Frame", nil, eclipseBar)
		eclipseBar.FrameBackdrop:SetPoint("TOPLEFT", eclipseBar, "TOPLEFT", -2, 2)
		eclipseBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", eclipseBar, "BOTTOMRIGHT", 2, -2)
		eclipseBar.FrameBackdrop:SetBackdrop(self:GetBackdrop())
		eclipseBar.FrameBackdrop:SetBackdropColor(.1,.1,.1,1)
		eclipseBar.FrameBackdrop:SetBackdropBorderColor(.3,.3,.3,1)	
		CreateShadow(eclipseBar.FrameBackdrop)
		eclipseBar.FrameBackdrop:SetFrameLevel(eclipseBar:GetFrameLevel()-1)		
		
		
		local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
		lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
		lunarBar:SetSize(playerwidth-4, 8)
		lunarBar:SetStatusBarTexture(TEXTURE)
		lunarBar:SetStatusBarColor(.30, .52, .90)
		eclipseBar.LunarBar = lunarBar

		local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
		solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
		solarBar:SetSize(playerwidth-4, 8)
		solarBar:SetStatusBarTexture(TEXTURE)
		solarBar:SetStatusBarColor(.80, .82,  .60)
		eclipseBar.SolarBar = solarBar
		
		self.EclipseBar = eclipseBar
	end

	--warlock or PALADIN bar
	if unit == 'player' and (class == 'WARLOCK' or class == 'PALADIN') and C["unitframe"].cpoint == true then
		local shards = CreateFrame('StatusBar', nil, self)
		shards:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)		
		shards:SetWidth(playerwidth-4)
		shards:SetHeight(8)
		shards:SetBackdropColor(0, 0, 0)

		shards.FrameBackdrop = CreateFrame("Frame", nil, shards)
		shards.FrameBackdrop:SetPoint("TOPLEFT", shards, "TOPLEFT", -2, 2)
		shards.FrameBackdrop:SetPoint("BOTTOMRIGHT", shards, "BOTTOMRIGHT", 2, -2)
		shards.FrameBackdrop:SetBackdrop(self:GetBackdrop())
		shards.FrameBackdrop:SetBackdropColor(.1,.1,.1,1)
		shards.FrameBackdrop:SetBackdropBorderColor(.3,.3,.3,1)	
		CreateShadow(shards.FrameBackdrop)
		shards.FrameBackdrop:SetFrameLevel(shards:GetFrameLevel()-1)		
				
		for id = 1, 3 do
			local shard = CreateFrame("StatusBar", nil, shards)
			shard:SetStatusBarTexture(TEXTURE)
			if class == 'WARLOCK' then
				shard:SetStatusBarColor(148/255, 130/255, 201/255)
			else
				shard:SetStatusBarColor(228/255,225/255,16/255)
			end	
			if id > 1 then
				shard:SetSize((playerwidth-8)/3, 8)
				shard:SetPoint('BOTTOMLEFT', shards[id-1], 'BOTTOMRIGHT', 2, 0)
			else
				shard:SetSize((playerwidth-8)/3, 8)
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
			self.TotemBar[i]:SetWidth((playerwidth-4-12)/4)
		
			if (i == 1) then
				self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 5)
			else
				self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 4, 0)
			end

			self.TotemBar[i]:SetStatusBarTexture(TEXTURE)
			self.TotemBar[i]:SetBackdrop(BACKDROP)
			self.TotemBar[i]:SetBackdropColor(0, 0, 0)
			self.TotemBar[i]:SetMinMaxValues(0, 1)

			self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
			self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
			self.TotemBar[i].bg:SetTexture(TEXTURE)
			self.TotemBar[i].bg.multiplier = 0.25
			
			self.TotemBar[i].FrameBackdrop = CreateFrame("Frame", nil, self.TotemBar[i])
			self.TotemBar[i].FrameBackdrop:SetPoint("TOPLEFT", self.TotemBar[i], "TOPLEFT", -2, 2)
			self.TotemBar[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", self.TotemBar[i], "BOTTOMRIGHT", 2, -2)
			self.TotemBar[i].FrameBackdrop:SetBackdrop(self:GetBackdrop())
			self.TotemBar[i].FrameBackdrop:SetBackdropColor(.1,.1,.1,1)
			self.TotemBar[i].FrameBackdrop:SetBackdropBorderColor(.3,.3,.3,1)	
			CreateShadow(self.TotemBar[i].FrameBackdrop)
			self.TotemBar[i].FrameBackdrop:SetFrameStrata("BACKGROUND")
			
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
	
--aura
	if unit == 'player' then
		local Debuffs = CreateFrame("Frame", nil, self)
		if (E.MyClass == "DEATHKNIGHT" or E.MyClass == "SHAMAN") and C["unitframe"].playerdebuffnum > 0 then
			Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 18)
		else
			Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 4)
		end
		Debuffs.showDebuffType = true
		Debuffs.initialAnchor = 'BOTTOMLEFT'
		Debuffs:SetHeight(75)
		Debuffs:SetWidth(C["unitframe"].playerwidth-4)
		Debuffs.num = C["unitframe"].playerdebuffnum
		Debuffs.size = 25
		Debuffs.spacing = 4
		Debuffs['growth-x'] = 'RIGHT'
		Debuffs['growth-y'] = 'UP'
		self.Debuffs = Debuffs

		Debuffs.PostCreateIcon = PostCreateIcon
		Debuffs.PostUpdateIcon = PostUpdateIcon		
	end
	
	if unit == 'target' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 4)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].playerwidth-4)
		Auras:SetHeight(C["unitframe"].playerheight * 2)
		Auras.size = 25
		Auras.spacing = 4
		Auras.gap = true
		Auras.numBuffs = C["unitframe"].targetbuffs
		Auras.numDebuffs = C["unitframe"].targetdebuffs
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras		
	end

	if unit == 'targettarget' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 1, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(132)
		Auras:SetHeight(26)
		Auras.size = 21
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
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 1, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(132)
		Auras:SetHeight(26)
		Auras.size = 21
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
		Auras:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 1, 2)
		Auras.showDebuffType = true
		Auras:SetWidth(132)
		Auras:SetHeight(26)
		Auras.size = 21
		Auras.spacing = 6
		Auras.gap = false
		Auras.numBuffs = 0
		Auras.numDebuffs = 0

		Auras.PostCreateIcon = PostCreateIcon
		self.Auras = Auras
	end
	
	if unit == 'pet' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 4)
		Auras.showDebuffType = true
		Auras:SetWidth(130)
		Auras:SetHeight(18)
		Auras.size = 16
		Auras.spacing = 4
		Auras.gap = true
		Auras.numBuffs = 4
		Auras.numDebuffs = 3
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
		spawnHelper(self, 'pet', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx-playerwidth-8-playerheight-16, pty)
	else
		spawnHelper(self, 'pet', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx-playerwidth-8, pty)
	end
	spawnHelper(self, 'focustarget', 'TOPRIGHT', UIParent, 'BOTTOM', -ptx, pty-34-playerheight-16)	
	
end)

oUF:DisableBlizzard'party'

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "CONVERT_TO_PARTY", "CONVERT_TO_RAID", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
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