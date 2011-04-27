local E, C = unpack(select(2, ...))
if C["unitframe"].aaaaunit ~= 2 then return end
local cfg = CreateFrame("Frame")
local lib = CreateFrame("Frame")
local cast = CreateFrame("Frame")
-----------------------------
-- MEDIA
-----------------------------
local MediaPath = "Interface\\Addons\\Eui\\media\\"
cfg.statusbar_texture = MediaPath.."statusbar"
cfg.auratex = MediaPath.."iconborder" 
cfg.font = STANDARD_TEXT_FONT
cfg.bfont = STANDARD_TEXT_FONT
cfg.backdrop_texture = MediaPath.."backdrop"
cfg.backdrop_edge_texture = MediaPath.."backdrop_edge"

-----------------------------
-- CONFIG
-----------------------------

--config variables
cfg.showtot = true
cfg.showpet = true
cfg.showfocus = true
cfg.interruptcb = {1, 0, 0} --color setting for uninterruptable casts
cfg.stylebuffs = true -- replacing default buff frame
cfg.BUFFpos = {"TOPRIGHT", "UIParent", "TOPRIGHT", -195, -20} -- buffs position

if select(2, UnitClass("player")) =="SHAMAN" or select(2, UnitClass("player")) == "DEATHKNIGHT" then
	cfg.DEBUFFpos = {"BOTTOMLEFT", "oUF_monoPlayerFrame", "TOPLEFT", 2, 14} -- debuffs position
else
	cfg.DEBUFFpos = {"BOTTOMLEFT", "oUF_monoPlayerFrame", "TOPLEFT", 1.5, 4} -- debuffs position
end
cfg.BFIsize = 24 -- buff frame icon size
cfg.playerauras = false -- small aura frame for player
cfg.auratimers = true -- aura timers
cfg.ATIconSizeThreshold = 16 -- how big some icon should be to display the custom timer
cfg.ATSize = 9 -- aura timer font size
cfg.RMalpha = 0.6 -- raid mark alpha
cfg.RMsize = 16 -- raid mark size
cfg.focusCBuserplaced = true -- false to lock focus cast bar to the focus frame
cfg.focusCBwidth = 205 -- focus cb width
cfg.focusCBheight = 15 -- focus cb height

local ptx
local pty
if C["raid"].grid == true then
	ptx = (C["raid"].gridw * 5 + 20) / 2 + 4
	pty = C["raid"].gridh * 5 + 20 + C["raid"].gridheight
	
else
	ptx = C["unitframe"].totwidth / 2 + 8
	pty = C["unitframe"].petheight + 162 + 23 + C["actionbar"].petbuttonsize + C["actionbar"].buttonspacing*2
end
--if C["actionbar"].actionbarrows > 2 then pty = pty + 33 end
-- Frames position
cfg.Ppos = {"TOPRIGHT","UIParent","BOTTOM", -ptx, pty} -- player
cfg.Tpos = {"TOPLEFT","UIParent","BOTTOM", ptx, pty} -- target
--	cfg.focusCBposition = {"TOP",UIParent,"BOTTOM",10,362} 
cfg.Fpos = {'TOPRIGHT', 'UIParent', 'BOTTOM', -ptx-8-(C["unitframe"].playerwidth-8)/2, pty-34-C["unitframe"].playerheight} -- focus
cfg.FTpos = {"TOPRIGHT", 'UIParent', 'BOTTOM', -ptx, pty-34-C["unitframe"].playerheight} -- focusTarget
cfg.PEpos = {'TOPRIGHT', 'UIParent', 'BOTTOM', -ptx-C["unitframe"].playerwidth-8, pty} -- pet
cfg.TTpos = {'TOPLEFT', 'UIParent', 'BOTTOM', ptx, pty-34-C["unitframe"].playerheight} -- ToT

-- Size and scale
cfg.Pwidth = C["unitframe"].playerwidth -- Player frame
cfg.Pheight = C["unitframe"].playerheight
cfg.Pscale = 1

cfg.Twidth = C["unitframe"].playerwidth -- Target frame
cfg.Theight = C["unitframe"].playerheight
cfg.Tscale = 1

cfg.PTTwidth = C["unitframe"].petwidth -- Pet and ToT frames(原133)
cfg.PTTheight = C["unitframe"].petheight
cfg.PTTscale = 1

cfg.Fwidth =  (cfg.Pwidth-8) / 2 --Focus frame 110
cfg.Fheight = C["unitframe"].focusheight
cfg.Fscale = 1
cfg.colorClass = C["unitframe"].colorClass --palyer and target show colorClass
-----------------------------
-- FUNCTIONS
-----------------------------
local SVal = function(val)
if val then
	if (val >= 1e6) then
return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end
end

local function utf8sub(string, i, dots)
	if string then
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and '..' or '')
		else
			return string
		end
	end
	end
end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

pcolors = setmetatable({
	power = setmetatable({
		['MANA']= { 95/255, 155/255, 255/255 }, 
		['RAGE']= { 250/255,  75/255,  60/255 }, 
		['FOCUS']   = { 255/255, 209/255,  71/255 },
		['ENERGY']  = { 200/255, 255/255, 200/255 }, 
		['RUNIC_POWER'] = {   0/255, 209/255, 255/255 },
		["AMMOSLOT"]		= { 200/255, 255/255, 200/255 },
		["FUEL"]			= { 250/255,  75/255,  60/255 },
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},	
		["POWER_TYPE_HEAT"] = {0.55,0.57,0.61},
  	["POWER_TYPE_OOZE"] = {0.76,1,0},
  	["POWER_TYPE_BLOOD_POWER"] = {0.7,0,1},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

oUF.Tags['mono:info'] = function(u) 
	local level = UnitLevel(u)
	local race = UnitRace(u) or nil
	local typ = UnitClassification(u)
	local color = GetQuestDifficultyColor(level)
	
	if level <= 0 then
		level = "??" 
		color.r, color.g, color.b = 1, 0, 0
	end
	
	if typ=="rareelite" then
		return hex(color)..level..'r+'
	elseif typ=="elite" then
		return hex(color)..level..'+'
	elseif typ=="rare" then
		return hex(color)..level..'r'
	else
		if u=="target" and UnitIsPlayer("target") then
		if level == 80 then level = "" end
			return hex(color)..level.." |cffFFFFFF"..race.."|r"
		else
			return hex(color)..level
		end
	end
end
oUF.TagEvents['mono:info'] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

oUF.Tags['mono:hp']  = function(u) -- THIS IS FUCKING MADNESS!!! 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['mono:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		local def = oUF.Tags['missinghp'](u) or 0
		local min, max = UnitHealth(u), UnitHealthMax(u)
		if u == "player" or u == "target" then
			if C["unitframe"].totalhpmp == true then
				return min.." | "..per
			else
				return SVal(min).." | "..per
			end
		elseif u == "focus" or u == "pet" or u == "focustarget" or u == "targettarget" then
			return per
		else
			if UnitIsPlayer(u) and not UnitIsEnemy("player",u) then
				if min~=max then 
					return SVal(max).." | |cffe15f8b"..-def.."|r"
				else
					return SVal(min).." | "..per 
				end
			else
				return SVal(min).." | "..per
			end
		end
	end
end
oUF.TagEvents['mono:hp'] = 'UNIT_HEALTH'

oUF.Tags['mono:hpperc']  = function(u) 
	local per = oUF.Tags['perhp'](u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['mono:DDG'](u)
	elseif min~=max and per < 90 then
		return per.."%"
	end
end
oUF.TagEvents['mono:hpperc'] = 'UNIT_HEALTH'

oUF.Tags['mono:pp'] = function(u)
	local _, str = UnitPowerType(u)
	if str then
		return hex(pcolors.power[str])..SVal(UnitPower(u))
	end
end
oUF.TagEvents['mono:pp'] = 'UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER'

oUF.Tags['mono:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (u == "pet") and GetPetHappiness() then
		return hex(oUF.colors.happiness[GetPetHappiness()])
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['mono:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags['mono:name'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 12, true)
end
oUF.TagEvents['mono:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['mono:longname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 20, true)
end
oUF.TagEvents['mono:longname'] = 'UNIT_NAME_UPDATE'

oUF.Tags['mono:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.TagEvents['mono:DDG'] = 'UNIT_HEALTH'

oUF.Tags['mono:druidpower'] = function(u)
	local min, max = UnitPower(u, 0), UnitPowerMax(u, 0)
	return u == 'player' and UnitPowerType(u) ~= 0 and min ~= max and ('|cff5F9BFF%d%%|r |'):format(min / max * 100)
end
oUF.TagEvents['mono:druidpower'] = 'UNIT_MANA UPDATE_SHAPESHIFT_FORM'

-----------------------------
-- local variables
-----------------------------
oUF.colors.power['MANA'] = {.3,.45,.65}
oUF.colors.power['RAGE'] = {.7,.3,.3}
oUF.colors.power['FOCUS'] = {.7,.45,.25}
oUF.colors.power['ENERGY'] = {.65,.65,.35}
oUF.colors.power['RUNIC_POWER'] = {.45,.45,.75}
oUF.colors.power['AMMOSLOT'] = {.8,.6,0}
oUF.colors.power['FUEL'] = {0,.55,.5}
oUF.colors.power['POWER_TYPE_STEAM'] = {.55,.57,.61}
oUF.colors.power['POWER_TYPE_PYRITE'] = {.6,.09,.17}
oUF.colors.power['POWER_TYPE_HEAT'] = {.9,.45,.1}
oUF.colors.power['POWER_TYPE_OOZE'] = {.1,.1,.9}
oUF.colors.power['POWER_TYPE_BLOOD_POWER'] = {.9,.1,.1}
local _, pType = UnitPowerType("player")
local pcolor = oUF.colors.power[pType] or {.3,.45,.65}
local class = select(2, UnitClass("player"))

-----------------------------
-- FUNCTIONS
-----------------------------
cast.CustomTimeText = function(self, duration)
	self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
end
local channelingTicks = {
	-- warlock
	[GetSpellInfo(1120)] = 5, -- drain soul
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(5740)] = 3, -- rain of fire
	-- druid
	[GetSpellInfo(740)] = 4, -- Tranquility
	[GetSpellInfo(16914)] = 10, -- Hurricane
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(48045)] = 5, -- mind sear
	[GetSpellInfo(47540)] = 2, -- penance
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(10)] = 5, -- blizzard
	[GetSpellInfo(12051)] = 4, -- evocation
}
local ticks = {}
cast.setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(cfg.statusbar_texture)
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

cast.CheckCast = function(self, unit, name, rank, castid)
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if unit == "player"then
		if self.casting then
			cast.setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			cast.setBarTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus" or unit == "party") and self.interrupt then
		self:SetStatusBarColor(1,0,0,.8)
	else
		self:SetStatusBarColor(255/255, 128/255, 128/255,1)
	end
end

--fontstring func
lib.gen_fontstring = function(f, name, size, outline)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(name, size, outline)
	fs:SetShadowColor(0,0,0,1)
	return fs
end

--backdrop table
local backdrop_tab = { 
	bgFile = cfg.backdrop_texture, 
	edgeFile = cfg.backdrop_edge_texture,
	tile = false, tileSize = 0, edgeSize = 5, 
	insets = {left = 5, right = 5, top = 5, bottom = 5,},
}

--backdrop func
lib.gen_backdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,1)
end

--right click menu
lib.menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)
	if(cunit == 'Vehicle') then
		cunit = 'Player'
	end
	if unit == "party" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

--init func
lib.init = function(f)
	f:SetAttribute("initial-height", f.height)
	f:SetAttribute("initial-width", f.width)
	f:SetAttribute("initial-scale", f.scale)
	f:SetPoint("CENTER",UIParent,"CENTER",0,0)
	f.menu = lib.menu
	f:RegisterForClicks("AnyUp")
	f:SetAttribute("*type2", "menu")
	f:SetScript("OnEnter", UnitFrame_OnEnter)
	f:SetScript("OnLeave", UnitFrame_OnLeave)
end

------ [Building frames]
--gen healthbar func
lib.gen_hpbar = function(f)
--statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	s:SetHeight(f.height-9)
	s:SetWidth(f.width)
	s:SetPoint("TOPLEFT", f, "TOPLEFT",0,0)
	s:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0,0)
	
	s:SetAlpha(0.66)
	s:SetOrientation("HORIZONTAL") 
	if f.mystyle ~= "player" and f.mystyle ~="target" and f.mystyle~="pet" then
		s:SetHeight(f.height)
	end
--helper
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-4,4)
	h:SetPoint("BOTTOMRIGHT",4,-4)
	lib.gen_backdrop(h)
--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(cfg.statusbar_texture)
	b:SetAllPoints(s)
	f.Health = s
	f.Health.bg = b
end
--gen hp strings func
lib.gen_hpstrings = function(f, unit)
--creating helper frame here so our font strings don't inherit healthbar parameters
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(f.Health)
	h:SetFrameLevel(15)
	local valsize
	if f.mystyle == "arenatarget" or f.mystyle == "partypet" then valsize = 11 else valsize = 13 end 
	local name = lib.gen_fontstring(h, cfg.font, 13, "THINOUTLINE")
	local hpval = lib.gen_fontstring(h, cfg.font, valsize, "THINOUTLINE")
	if f.mystyle == "target" or f.mystyle == "tot" then
		name:SetPoint("RIGHT", f.Health, "RIGHT",-3,0)
		hpval:SetPoint("LEFT", f.Health, "LEFT",3,0)
		name:SetJustifyH("RIGHT")
		name:SetPoint("LEFT", hpval, "RIGHT", 5, 0)
	else
		name:SetPoint("LEFT", f.Health, "LEFT",3,0)
		hpval:SetPoint("RIGHT", f.Health, "RIGHT",-3,0)
		name:SetJustifyH("LEFT")
		name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
	end
	f:Tag(name, '[mono:color][mono:longname]')
	f:Tag(hpval, '[mono:hp]')
end

--gen swing func
lib.gen_swing = function(f)
	local swing = CreateFrame("StatusBar",nil,f)
	swing:SetStatusBarTexture(cfg.statusbar_texture)
	swing:SetStatusBarColor(.8,.8,.8)
	swing:SetHeight(1)
	swing:SetWidth(f.width-28)
	swing:SetPoint("TOP", f.Health, "BOTTOM", 0, -1)
	if f.mystyle == "player" and C["unitframe"].swing == true then
		swing:Show()
	else
		swing:Hide()
	end
	f.Swing = swing
end

--gen powerbar func
lib.gen_ppbar = function(f)
--statusbar
	if f.mystyle ~= "player" and f.mystyle ~= "target" and f.mystyle ~= "pet" then return end
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	s:SetHeight(9)
	s:SetWidth(f.width-28)
	s:SetPoint("TOP",f.Health,"BOTTOM",0,-2)
	if f.mystyle == "player" and C["unitframe"].powerspark == true then
--Powerspark func
	local spark = s:CreateTexture(nil, "OVERLAY")
	spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	spark:SetVertexColor(1, 1, 1, 0.5)
	spark:SetBlendMode("ADD")
	spark:SetHeight(s:GetHeight()*2)
	spark:SetWidth(s:GetHeight())
		--Options and settings
		--spark.rtl = true
		--Make the spark go from Right To Left instead
		--Defaults to false
		--spark.manatick = true
		--Show mana regen ticks outside FSR (like the energy ticker)
		--Defaults to false
		--spark.highAlpha = 1
		--What alpha setting to use for the FSR and energy spark
		--Defaults to spark:GetAlpha()
		--spark.lowAlpha = 0.25
		--What alpha setting to use for the mana regen ticker
		--Defaults to highAlpha / 4
	f.Spark = spark
	end
--helper
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-4,4)
	h:SetPoint("BOTTOMRIGHT",4,-4)
	lib.gen_backdrop(h)
--bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(cfg.statusbar_texture)
	b:SetAllPoints(s)
	f.Power = s
	f.Power.bg = b
end
 
	
--filling up powerbar with text strings
lib.gen_ppstrings = function(f, unit)
--helper frame
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(f.Power)
	h:SetFrameLevel(10)
	local fh
	if f.mystyle == "arena" then fh = 9 else fh = 11 end
	local pp = lib.gen_fontstring(h, cfg.font, fh, "THINOUTLINE")
	local info = lib.gen_fontstring(h, cfg.font, fh, "THINOUTLINE")
	if f.mystyle == "target" or f.mystyle == "tot" then
		info:SetPoint("RIGHT", f.Power, "RIGHT",-3,0)
		pp:SetPoint("LEFT", f.Power, "LEFT",3,0)
		info:SetJustifyH("RIGHT")
	else
		info:SetPoint("LEFT", f.Power, "LEFT",3,0)
		pp:SetPoint("RIGHT", f.Power, "RIGHT",-5,0)
		info:SetJustifyH("LEFT")
	end
	if class == "DRUID" then
		f:Tag(pp, '[mono:druidpower] [mono:pp]')
	else
		f:Tag(pp, '[mono:pp]')
	end
	f:Tag(info, '[mono:info]')
end

--3d portrait behind hp bar
lib.gen_portrait = function(f)
	local p = CreateFrame("PlayerModel", nil, f.Health)
	p:SetFrameStrata("BACKGROUND")
	p:SetWidth(f.Health:GetWidth()-2)
	p:SetHeight(f.Health:GetHeight()-2)
	p:SetPoint("TOP", f.Health, "TOP", 0, -2)
	f.Portrait = p
end

------ [Castbar, +mirror castbar too!]
--gen castbar
lib.gen_castbar = function(f)
	if C["unitframe"].castbar == true then 
		local s = CreateFrame("StatusBar", "oUF_monoCastbar"..f.mystyle, f)
		s:SetWidth(f.width-28)
		s:SetHeight(22)
		s:SetStatusBarTexture(cfg.statusbar_texture)
		s:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
		s:SetFrameLevel(9)
--color
		s.CastingColor = {pcolor[1], pcolor[2], pcolor[3]}
		s.CompleteColor = {0.12, 0.86, 0.15}
		s.FailColor = {1.0, 0.09, 0}
		s.ChannelingColor = {pcolor[1], pcolor[2], pcolor[3]}
--helper
		local h = CreateFrame("Frame", nil, s)
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-4,4)
		h:SetPoint("BOTTOMRIGHT",4,-4)
		lib.gen_backdrop(h)
--backdrop
		local b = s:CreateTexture(nil, "BACKGROUND")
		b:SetTexture(cfg.statusbar_texture)
		b:SetAllPoints(s)
		b:SetVertexColor(pcolor[1]*0.2,pcolor[2]*0.2,pcolor[3]*0.2,0.7)
--spark
		sp = s:CreateTexture(nil, "OVERLAY")
		sp:SetBlendMode("ADD")
		sp:SetAlpha(0.5)
		sp:SetHeight(s:GetHeight()*2.5)
--spell text
		local txt = lib.gen_fontstring(s, cfg.font, 11, "THINOUTLINE")
		txt:SetPoint("LEFT", 2, 0)
		txt:SetJustifyH("LEFT")
--time
		local t = lib.gen_fontstring(s, cfg.font, 12, "THINOUTLINE")
		t:SetPoint("RIGHT", -2, 0)
		txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
--icon
		local i = s:CreateTexture(nil, "ARTWORK")
		-- i:SetSize(s:GetHeight()-2,s:GetHeight()-2)
		i:SetWidth(s:GetHeight()-2)
		i:SetHeight(s:GetHeight()-2)
		i:SetPoint("RIGHT", s, "LEFT", -4.5, 0)
		i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		i:Show()
--helper2 for icon
		local h2 = CreateFrame("Frame", nil, s)
		h2:SetFrameLevel(0)
		h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
		h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
		lib.gen_backdrop(h2)
		if f.mystyle == "player" then
--latency only for player unit
			local z = s:CreateTexture(nil,"ADD")
			z:SetTexture(cfg.statusbar_texture)
			z:SetVertexColor(.8,.31,.45)
			z:SetPoint("TOPRIGHT")
			z:SetPoint("BOTTOMRIGHT")
			s.SafeZone = z
		end
		if f.mystyle == "focus" and cfg.focusCBuserplaced then
			s:SetAllPoints(f.Health)
			s:SetToplevel(true)
			
	--[[ 		
			s:SetPoint(unpack(cfg.focusCBposition))
			s:SetWidth(cfg.focusCBwidth)
			s:SetHeight(cfg.focusCBheight)
			i:SetWidth(s:GetHeight()-2)
			i:SetHeight(s:GetHeight()-2)
			sp:SetHeight(s:GetHeight()*2.5) ]]
		elseif f.mystyle == "pet" then
			s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
			s:SetScale(f:GetScale())
			s:SetSize(s:GetWidth()-2, f.height/3)
			i:SetPoint("RIGHT", s, "LEFT", -2, 0)
			h2:SetFrameLevel(9)
			b:Hide() txt:Hide() t:Hide() h:Hide()
		else
			s:SetPoint("TOPRIGHT",f.Power,"BOTTOMRIGHT",0,-4)
		end
		s.CustomTimeText = cast.CustomTimeText
		s.PostCastStart = cast.CheckCast
		s.PostChannelStart = cast.CheckCast
		f.Castbar = s
		f.Castbar.Text = txt
		f.Castbar.Time = t
		f.Castbar.Icon = i
		f.Castbar.Spark = sp
	end
end
--gen Mirror Cast Bar
lib.gen_mirrorcb = function(f)
	for _, bar in pairs({'MirrorTimer1','MirrorTimer2','MirrorTimer3',}) do 
		for i, region in pairs({_G[bar]:GetRegions()}) do
			if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
				region:Hide()
			end
		end
		_G[bar..'Border']:Hide()
		_G[bar]:SetParent(UIParent)
		_G[bar]:SetScale(1)
		_G[bar]:SetHeight(16)
		_G[bar]:SetWidth(280)
		_G[bar]:SetBackdropColor(.1,.1,.1)
		_G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
		_G[bar..'Background']:SetTexture(cfg.statusbar_texture)
		_G[bar..'Background']:SetAllPoints(bar)
		_G[bar..'Background']:SetVertexColor(.15,.15,.15,.75)
		_G[bar..'Text']:SetFont(cfg.font, 14)
		_G[bar..'Text']:ClearAllPoints()
		_G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)
		_G[bar..'StatusBar']:SetAllPoints(_G[bar])
--glowing borders
		local h = CreateFrame("Frame", nil, _G[bar])
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-4,4)
		h:SetPoint("BOTTOMRIGHT",4,-4)
		lib.gen_backdrop(h)
	end
end

------ [Auras, all of them!]
-- Creating our own timers with blackjack and hookers!
lib.FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute * 5 then
			return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

lib.CreateAuraTimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		local w = self:GetWidth()
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 and w > cfg.ATIconSizeThreshold then
				local time = lib.FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(1, 0, 0)
				else
					self.remaining:SetTextColor(0.84, 0.75, 0.65)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

lib.PostUpdateIcon = function(self, unit, icon, index, offset)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
-- Debuff desaturation
	if unitCaster ~= 'player' and unitCaster ~= 'vehicle' and not UnitIsFriend('player', unit) and icon.debuff then
		icon.icon:SetDesaturated(true)
		if C["unitframe"].onlyplayer == true then icon:Hide() end --只显示玩家施放的DEBUFF
	else
		icon.icon:SetDesaturated(false)
	end
-- Creating aura timers
	if duration and duration > 0 and (unitCaster == 'player' or unitCaster == 'vehicle') then
		icon.remaining:Show()
	else
		icon.remaining:Hide()
	end
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", lib.CreateAuraTimer)
end
-- creating aura icons
lib.PostCreateIcon = function(self, button)
	button.cd:SetReverse()
	button.cd.noOCC = true
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetDrawLayer("BACKGROUND")
--count
	button.count:ClearAllPoints()
	button.count:SetJustifyH("RIGHT")
	button.count:SetPoint("BOTTOMRIGHT", 2, -2)
	button.count:SetTextColor(0.7,0.7,0.7)
--helper
	local h = CreateFrame("Frame", nil, button)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-4,4)
	h:SetPoint("BOTTOMRIGHT",4,-4)
	lib.gen_backdrop(h)
--another helper frame for our fontstring to overlap the cd frame
	local h2 = CreateFrame("Frame", nil, button)
	h2:SetAllPoints(button)
	h2:SetFrameLevel(10)
	button.remaining = lib.gen_fontstring(h2, cfg.bfont, cfg.ATSize, "THINOUTLINE")
	button.remaining:SetPoint("TOP", 0, -2)
--overlay texture for debuff types display
	button.overlay:SetTexture(cfg.auratex)
	button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -1.6, 1.6)
	button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1.6, -1.6)
	button.overlay:SetTexCoord(0.03, 0.96, 0.03, 0.96)
	button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
end

--auras for certain frames
lib.createAuras = function(f)
	a = CreateFrame('Frame', nil, f)
	if f.mystyle=="target" then
		a:SetPoint('BOTTOMLEFT', f.Health, 'TOPLEFT', 1.5, 2)
		a['growth-x'] = 'RIGHT'
		a['growth-y'] = 'UP' 
		a.initialAnchor = 'BOTTOMLEFT'
	else
		a:SetPoint('TOPLEFT', f.Health, 'BOTTOMLEFT', 1.5, -2)
		a['growth-x'] = 'RIGHT'
		a['growth-y'] = 'DOWN' 
		a.initialAnchor = 'TOPLEFT'
	end
	a.gap = true
	a.spacing = 4
	a.size = 20
	a.showDebuffType = true
	if f.mystyle=="target" or (f.mystyle=="player" and cfg.playerauras) then
		if f.mystyle=="player" and (class == "DEATHKNIGHT" or (class == "SHAMAN")) then 
-- making space for rune or totem bar
			a:SetPoint('BOTTOMLEFT', f.Health, 'TOPLEFT', 1, 6+f.height/3)
		end
		a:SetHeight((a.size+a.spacing)*2)
		a:SetWidth((a.size+a.spacing)*9)
		a.numBuffs = 20 
		a.numDebuffs = 20
	elseif f.mystyle=="focus" or f.mystyle=="focustarget" then
		a.size = 18
		a.spacing = 4.5
		a:SetHeight((a.size+a.spacing)*2)
		a:SetWidth((a.size+a.spacing)*5)
		a.numBuffs = C["unitframe"].Fbuffs 
		a.numDebuffs = C["unitframe"].Fdebuffs 
	end
	f.Auras = a
	a.PostCreateIcon = lib.PostCreateIcon
	a.PostUpdateIcon = lib.PostUpdateIcon
end
-- buffs
lib.createBuffs = function(f)
--Hiding Deafault Player's buff frames
	if cfg.stylebuffs then
		_G["BuffFrame"]:Hide()
		_G["BuffFrame"]:UnregisterAllEvents()
		_G["BuffFrame"]:SetScript("OnUpdate", nil)
	end
	b = CreateFrame("Frame", nil, f)
	b.initialAnchor = "TOPLEFT"
	b["growth-y"] = "DOWN"
	b.num = 5
	b.size = 18
	b.spacing = 4.5
	b:SetHeight((b.size+b.spacing)*2)
	b:SetWidth((b.size+b.spacing)*12)
	if f.mystyle=="player" and cfg.stylebuffs then
		b:SetPoint(unpack(cfg.BUFFpos))
		b.initialAnchor = "TOPRIGHT"
		b['growth-x'] = "LEFT"
		b.size = cfg.BFIsize
		b:SetWidth((b.size+b.spacing+1) * 15)
		b.num = 0 --在原EUI头像中已有定义,这儿设为0取消.
		b.spacing = 6
	elseif f.mystyle=="pet" then
		b.initialAnchor = "BOTTOMLEFT"
		b:SetPoint("BOTTOMLEFT", f.Health, "TOPLEFT", 1, 2)
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
		b.num = 4
	elseif f.mystyle=="tot" then
		b:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 1, -2)
		b.num = 0
	end
	b.PostCreateIcon = lib.PostCreateIcon
	b.PostUpdateIcon = lib.PostUpdateIcon
	f.Buffs = b
end
--debuffs
lib.createDebuffs = function(f)
	d = CreateFrame("Frame", nil, f)
	d.initialAnchor = "TOPRIGHT"
	d["growth-y"] = "DOWN"
	d.num = 5
	d.size = 18
	d.spacing = 4.5
	d:SetHeight((d.size+d.spacing)*2)
	d:SetWidth((d.size+d.spacing) * 5)
	d.showDebuffType = true
	if f.mystyle=="player" and cfg.stylebuffs then
		d:SetPoint(unpack(cfg.DEBUFFpos))
		d.size = cfg.BFIsize
		d:SetWidth((d.size+d.spacing) * 15)
		d.initialAnchor = "BOTTOMLEFT"
		d['growth-x'] = "RIGHT"
		d['growth-y'] = 'UP'
		d.num = C["unitframe"].playerdebuffnum
		d.spacing = 6
	elseif f.mystyle=="pet" then
		d:SetPoint("TOPLEFT", f.Health, "TOPRIGHT", d.spacing, -1)
		d.initialAnchor = "TOPLEFT"
		d.num = 0
	elseif f.mystyle=="tot" then
		d:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", d.spacing, -2)
		d.initialAnchor = "TOPLEFT"
		d['growth-x'] = "RIGHT"
		d['growth-y'] = "DOWN"
		d.num = C["unitframe"].totdebuffs
	end
	d.PostCreateIcon = lib.PostCreateIcon
	d.PostUpdateIcon = lib.PostUpdateIcon
	f.Debuffs = d
end

------ [Extra functionality]
--gen DK runes
lib.gen_Runes = function(f)
	if class ~= "DEATHKNIGHT" or C["unitframe"].cpoint ~= true then return
	else
		local runeloadcolors = {
		[1] = {0.59, 0.31, 0.31},
		[2] = {0.59, 0.31, 0.31},
		[3] = {0.33, 0.51, 0.33},
		[4] = {0.33, 0.51, 0.33},
		[5] = {0.31, 0.45, 0.53},
		[6] = {0.31, 0.45, 0.53},}
		f.Runes = CreateFrame("Frame", nil, f)
		for i = 1, 6 do
			r = CreateFrame("StatusBar", f:GetName().."_Runes"..i, f)
			-- r:SetSize(f.width/6 - 2, f.height/3)
			r:SetWidth(f.width/6 - 2)
			r:SetHeight(8)
			if (i == 1) then
				r:SetPoint("BOTTOMLEFT", f.Health, "TOPLEFT", 1, 3)
			else
				r:SetPoint("TOPLEFT", f.Runes[i-1], "TOPRIGHT", 2, 0)
			end
			r:SetStatusBarTexture(cfg.statusbar_texture)
			--r:GetStatusBarTexture():SetHorizTile(false)
			r:SetStatusBarColor(unpack(runeloadcolors[i]))
			r.bd = r:CreateTexture(nil, "BORDER")
			r.bd:SetAllPoints()
			r.bd:SetTexture(cfg.statusbar_texture)
			r.bd:SetVertexColor(0.15, 0.15, 0.15)
			f.b = CreateFrame("Frame", nil, r)
			f.b:SetPoint("TOPLEFT", r, "TOPLEFT", -4, 4)
			f.b:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", 4, -5)
			f.b:SetBackdrop(backdrop_tab)
			f.b:SetBackdropColor(0, 0, 0, 0)
			f.b:SetBackdropBorderColor(0,0,0,1)
			f.Runes[i] = r
		end
	end
end
--gen TotemBar for shamans
lib.gen_TotemBar = function(f)
	if class ~= "SHAMAN" or C["unitframe"].cpoint ~= true then return
	else
		f.TotemBar = {} 
		for i = 1, 4 do 
			tb = CreateFrame("StatusBar", nil, f) 
--tb:SetSize(f.width/4 - 2, f.height/3)
			tb:SetWidth(f.width/4 - 2)
			tb:SetHeight(8)
			tb:SetStatusBarTexture(cfg.statusbar_texture)
			tb:SetMinMaxValues(0, 1) 
			if (i == 1) then 
				tb:SetPoint("BOTTOMLEFT", f.Health, "TOPLEFT", 1, 1)
			else 
				tb:SetPoint("TOPLEFT", f.TotemBar[i-1], "TOPRIGHT", 2, 0) 
			end 
			tb.bd = tb:CreateTexture(nil, "BORDER")
			tb.bd:SetAllPoints()
			tb.bd:SetTexture(cfg.statusbar_texture)
			tb.bd:SetVertexColor(0.15, 0.15, 0.15)
			tb.bg = CreateFrame("Frame", nil, tb)
			tb.bg:SetPoint("TOPLEFT", tb, "TOPLEFT", -4, 4)
			tb.bg:SetPoint("BOTTOMRIGHT", tb, "BOTTOMRIGHT", 4, -5)
			tb.bg:SetBackdrop(backdrop_tab)
			tb.bg:SetBackdropColor(0,0,0,0)
			tb.bg:SetBackdropBorderColor(0,0,0,1)
			f.TotemBar[i] = tb
		end 
	end
end
--gen combo points
lib.CPUpdate = function(self, event, unit)
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
		self.Auras:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 1.5, cp > 0 and 14 or 4)
	end
end

lib.gen_CPoints = function(f)
	if f.mystyle == 'target' and C["unitframe"].cpoint == true then
		f.CPoints = {}
		for i = 1, MAX_COMBO_POINTS do
			cp = CreateFrame("Frame",nil,f)
 -- cp:SetSize(f.width/5 - 2, f.height/3)
			cp:SetWidth(f.width/5 - 2)
			cp:SetHeight(8)
			if i == 1 then
				cp:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 1, 3)
			else
				cp:SetPoint('TOPLEFT', f.CPoints[i-1], 'TOPRIGHT', 2, 0)
			end
			cp.bd = cp:CreateTexture(nil,"LOW")
			cp.bd:SetAllPoints(cp)
			cp.bd:SetTexture(cfg.statusbar_texture)
			cp.bg = CreateFrame("Frame", nil, cp)
			cp.bg:SetPoint("TOPLEFT", cp, "TOPLEFT", -4, 4)
			cp.bg:SetPoint("BOTTOMRIGHT", cp, "BOTTOMRIGHT", 4, -5)
			cp.bg:SetBackdrop(backdrop_tab)
			cp.bg:SetBackdropColor(0,0,0,0)
			cp.bg:SetBackdropBorderColor(0,0,0,1)
			f.CPoints[i] = cp
		end
		f.CPoints[1].bd:SetVertexColor(.3,.6,.3)
		f.CPoints[2].bd:SetVertexColor(.3,.6,.3)
		f.CPoints[3].bd:SetVertexColor(.6,.6,.3)
		f.CPoints[4].bd:SetVertexColor(.6,.6,.3)
		f.CPoints[5].bd:SetVertexColor(.7,.3,.3)
		f.CPoints.Update = lib.CPUpdate
	end
end
--gen combat and LFD icons
lib.gen_InfoIcons = function(f)
	local h = CreateFrame("Frame",nil,f)
	h:SetAllPoints(f.Health)
	h:SetFrameLevel(10)
--combat icon
	if f.mystyle == 'player' then
		f.Combat = h:CreateTexture(nil, 'OVERLAY')
		f.Combat = h:CreateTexture(nil, "OVERLAY")
		f.Combat:SetPoint('TOPRIGHT', -1, 7)
		f.Combat:SetHeight(14)
		f.Combat:SetWidth(14)
	--	f.Combat:SetVertexColor(255, 0, 0)	
	end	 
	
-- PvP icon
	if f.mystyle == 'player' and C["unitframe"].showPvP == true then
		f.PvP = h:CreateTexture(nil, 'OVERLAY')
		f.PvP:SetWidth(14)
		f.PvP:SetHeight(14)
		f.PvP:SetPoint('TOPLEFT', -1, 7)
		f.PvP:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		f.PvP:SetTexCoord(0.09, 0.43, 0.08, 0.42)
	end	
--Leader icon
	li = h:CreateTexture(nil, "OVERLAY")
	li:SetPoint("TOPLEFT", f, 0, 6)
 -- li:SetSize(12,12)
	li:SetWidth(12)
	li:SetHeight(12)
	f.Leader = li
--Assist icon
	ai = h:CreateTexture(nil, "OVERLAY")
	ai:SetPoint("TOPLEFT", f, 0, 6)
	--ai:SetSize(12,12)
	ai:SetWidth(12)
	ai:SetHeight(12)
	f.Assistant = ai
--ML icon
	local ml = h:CreateTexture(nil, 'OVERLAY')
	--ml:SetSize(12,12)
	ml:SetWidth(12)
	ml:SetHeight(12)
	ml:SetPoint('LEFT', f.Leader, 'RIGHT')
	f.MasterLooter = ml
end
--gen raid mark icons
lib.gen_RaidMark = function(f)
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)
	h:SetAlpha(cfg.RMalpha)
	local ri = h:CreateTexture(nil,'OVERLAY',h)
	ri:SetPoint("CENTER", f, "CENTER", 0, 0)
	--ri:SetSize(cfg.RMsize, cfg.RMsize)
	ri:SetWidth(cfg.RMsize)
	ri:SetHeight(cfg.RMsize)
	f.RaidIcon = ri
end
--gen Temporary enchant frame
lib.gen_tempench = function(f)
	if cfg.stylebuffs then
		local ench,i = {},0
		for i = 1,2 do
			ench[i] = _G["TempEnchant"..i]
			_G["TempEnchant"..i.."Border"]:Hide()
		--_G["TempEnchant"..i.."Duration"]:SetFont(cfg.font, 9, "THINOUTLINE")
			ench[i]:ClearAllPoints()
			ench[i]:SetWidth(30)
			ench[i]:SetHeight(30)
			ench[i]:Show()
			if i==1 then 
				ench[i]:SetPoint("TOPRIGHT", f, "TOPLEFT", -10, 0)
			elseif i==2 then
				ench[i]:SetPoint("RIGHT", ench[i-1], "LEFT", -10, 0)
			end
--helper frame for nifty background
			local h = CreateFrame("Frame", nil, ench[i])
			h:SetFrameLevel(20)
			h:SetPoint("TOPLEFT",-3.5,3.5)
			h:SetPoint("BOTTOMRIGHT",3.5,-3.5)
			h:SetBackdrop(backdrop_tab);
			h:SetBackdropColor(0,0,0,0)
			h:SetBackdropBorderColor(0,0,0,1)
		end
	end
end
--gen hilight texture
lib.gen_highlight = function(f)
	local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
	end
	local OnLeave = function(f)
		UnitFrame_OnLeave(f)
		f.Highlight:Hide()
	end
	f:SetScript("OnEnter", OnEnter)
	f:SetScript("OnLeave", OnLeave)
	local hl = f.Health:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(f.Health)
	hl:SetTexture(cfg.backdrop_texture)
	hl:SetVertexColor(.5,.5,.5,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	f.Highlight = hl
end

-- oUF_CombatFeedback
lib.gen_combat_feedback = function(f)
	local h = CreateFrame("Frame", nil, f.Health)
	h:SetAllPoints(f.Health)
	h:SetFrameLevel(30)
	local cfbt = lib.gen_fontstring(h, cfg.font, 18, "THINOUTLINE")
	cfbt:SetPoint("CENTER", f.Health, "BOTTOM", 0, -1)
	cfbt.maxAlpha = 0.75
	cfbt.ignoreEnergize = true
	f.CombatFeedbackText = cfbt
end

-----------------------------
-- STYLE FUNCTIONS
-----------------------------
local function genStyle(self)
	lib.init(self)
	lib.gen_hpbar(self)
	lib.gen_hpstrings(self)
	lib.gen_ppbar(self)
	lib.gen_highlight(self)
	lib.gen_RaidMark(self)
end

  --the player style
local function CreatePlayerStyle(self)
	self.width = cfg.Pwidth
	self.height = cfg.Pheight
	self.scale = cfg.Pscale
	self.mystyle = "player"
	genStyle(self)
	self.Health.frequentUpdates = true
	self.Health.Smooth = false
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.bg.multiplier = 0.1
	self.Power.frequentUpdates = true
	self.Power.Smooth = false
	self.Power.colorPower = true
	self.Health.colorClass = cfg.colorClass
	self.Health.colorClassNPC = false
	self.Power.bg.multiplier = 0.3
	lib.gen_castbar(self)
	if C["unitframe"].portrait == true then
		lib.gen_portrait(self)
	end
	lib.createBuffs(self)
	lib.createDebuffs(self)
	lib.gen_mirrorcb(self)
	lib.gen_ppstrings(self)
	lib.gen_Runes(self)
	lib.gen_TotemBar(self)
	lib.gen_InfoIcons(self)
	lib.gen_tempench(self)
	if cfg.playerauras then
		lib.createAuras(self)
	end
	lib.gen_combat_feedback(self)
	lib.gen_swing(self)--平砍计时条
end  
  
  --the target style
local function CreateTargetStyle(self)
	self.width = cfg.Twidth
	self.height = cfg.Theight
	self.scale = cfg.Tscale
	self.mystyle = "target"
	genStyle(self)
	self.Health.frequentUpdates = true
	self.Health.Smooth = false
	self.Health.colorDisconnected = true
	self.Health.colorHappiness = true
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.bg.multiplier = 0.1
	self.Power.frequentUpdates = true
	self.Power.Smooth = false
	self.Power.colorPower = true
	self.Power.bg.multiplier = 0.3
	self.Health.colorClass = cfg.colorClass
	self.Health.colorClassNPC = false
	lib.gen_castbar(self)
	if C["unitframe"].portrait == true then
		lib.gen_portrait(self)
	end
	lib.createAuras(self)
	lib.gen_ppstrings(self)
	lib.gen_CPoints(self)
	lib.gen_combat_feedback(self)
end  
  
  --the tot style
local function CreateToTStyle(self)
	self.width = C["unitframe"].totwidth
	self.height = C["unitframe"].totheight
	self.scale = cfg.PTTscale
	self.mystyle = "tot"
	genStyle(self)
	self.Health.frequentUpdates = true
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.colorDisconnected = true
	self.Health.colorHappiness = true
	self.Health.colorClass = false
	self.Health.bg.multiplier = 0.1
--	self.Power.colorPower = true
--	self.Power.bg.multiplier = 0.3
	lib.createBuffs(self)
	lib.createDebuffs(self)
end 
  
  --the pet style
local function CreatePetStyle(self)
	self.width = cfg.PTTwidth
	self.height = cfg.PTTheight
	self.scale = cfg.PTTscale
	self.mystyle = "pet"
	self.disallowVehicleSwap = true
	genStyle(self)
	self.Health.frequentUpdates = true
	self.Health.colorDisconnected = true
	self.Health.colorHappiness = true
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.bg.multiplier = 0.1
	self.Power.frequentUpdates = true
	self.Power.colorPower = true
	self.Power.bg.multiplier = 0.3
--	lib.gen_castbar(self)
	lib.createBuffs(self)
	lib.createDebuffs(self)
end  

  --the focus style
local function CreateFocusStyle(self)
	self.width = cfg.Fwidth
	self.height = cfg.Fheight
	self.scale = cfg.Fscale
	self.mystyle = "focus"
	genStyle(self)
	self.Health.frequentUpdates = true
	self.Health.colorDisconnected = true
	self.Health.colorHappiness = true
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.bg.multiplier = 0.1
--	self.Power.frequentUpdates = true
--	self.Power.colorPower = true
--	self.Power.bg.multiplier = 0.3
	lib.gen_castbar(self)
	lib.createAuras(self)
end
  
  --the focus target style
local function CreateFotStyle(self)
	self.width = cfg.Fwidth
	self.height = cfg.Fheight
	self.scale = cfg.Fscale
	self.mystyle = "focustarget"
	genStyle(self)
	self.Health.frequentUpdates = true
	self.Health.colorDisconnected = true
	self.Health.colorHappiness = true
	self.colors.smooth = {1,0,0, .7,.41,.44, .3,.3,.3}
	self.Health.colorSmooth = true
	self.Health.bg.multiplier = 0.1
--	self.Power.frequentUpdates = true
--	self.Power.colorPower = true
--	self.Power.bg.multiplier = 0.3
--	lib.gen_castbar(self)
	lib.createAuras(self)
end

oUF:RegisterStyle("monoPlayer", CreatePlayerStyle)
oUF:SetActiveStyle("monoPlayer")
oUF:Spawn("player", "oUF_monoPlayerFrame"):SetPoint(unpack(cfg.Ppos))

oUF:RegisterStyle("monoTarget", CreateTargetStyle)
oUF:SetActiveStyle("monoTarget")
oUF:Spawn("target", "oUF_monoTargetFrame"):SetPoint(unpack(cfg.Tpos))
  
if cfg.showpet then
	oUF:RegisterStyle("monoPet", CreatePetStyle)
	oUF:SetActiveStyle("monoPet")
	oUF:Spawn("pet", "oUF_monoPetFrame"):SetPoint(unpack(cfg.PEpos))
end
  
if cfg.showtot then
	oUF:RegisterStyle("monoToT", CreateToTStyle)
	oUF:SetActiveStyle("monoToT")
	oUF:Spawn("targettarget", "oUF_mono_ToTFrame"):SetPoint(unpack(cfg.TTpos))
end
  
if cfg.showfocus then
	oUF:RegisterStyle("monoFocus", CreateFocusStyle)
	oUF:SetActiveStyle("monoFocus")
	oUF:Spawn("focus", "oUF_monoFocusFrame"):SetPoint(unpack(cfg.Fpos))
	oUF:RegisterStyle("monoFoT", CreateFotStyle)
	oUF:SetActiveStyle("monoFoT")
	oUF:Spawn("focustarget", "oUF_mono_FoTFrame"):SetPoint(unpack(cfg.FTpos))	
else
	oUF:DisableBlizzard'focus'
end

oUF:DisableBlizzard'party'