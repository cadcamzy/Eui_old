local E, C = unpack(select(2, ...))
if C["unitframe"].aaaaunit ~= 3 then return end

BuffFrame:Hide()
local _, class = UnitClass('player')
local texture = [[Interface\AddOns\Eui\media\Cabaret.tga]]
local border = [[Interface\AddOns\Eui\media\border.tga]]
local font = E.font
local fontsize = 15
--local height, width = 27, 270
local height, width = C["unitframe"].playerheight, C["unitframe"].playerwidth


local buffsize = 26

-- Buffs/Debuffs
local Debuffs = true
local Buffs = true
local PlayerOnlyDebuffs = false
local DebuffType = true
local CooldownCount = true

-- General Stuff
local PvPIcon = C["unitframe"].showPvP
local Portraits = C["unitframe"].portrait

-- SwingBar
local SwingMeele = true
local SwingRange = false
local SwingClassColors = true

-- Castbar
local CastBars = C["unitframe"].castbar
local Safezone = true
local Latency = true
local ClassColor = C["unitframe"].colorClass 

--RuneFrame:Hide()

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {.31,.45,.63},
		['RAGE'] = {.69,.31,.31},
		['FOCUS'] = {.71,.43,.27},
		['ENERGY'] = {.65,.63,.35},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

oUF.colors.runes = {
	{196/255, 30/255, 58/255};
	{173/255, 217/255, 25/255};
	{35/255, 127/255, 255/255};
	{178/255, 53/255, 240/255};
}
local CheckInterrupt = function(self, unit)
	if unit == "vehicle" then unit = "player" end
	if self.interrupt then
		self.Bg:SetVertexColor(1, 0, 0, 0.6)
	else
		self.Bg:SetVertexColor(0, 0, 0, 0.6)		
	end
end

local function UpdateChannelStart(self, event, unit, name, rank, text)
	if (self.Latency) then
		self.Latency:ClearAllPoints()
		self.Latency:SetPoint('LEFT', self, 'BOTTOMLEFT', 1, -1)

		local _, _, ms = GetNetStats()
		self.Latency:SetFormattedText('%dms', ms)
	end

	if (self.SafeZone) then
		self.SafeZone:SetDrawLayer('ARTWORK')
		self.SafeZone:SetPoint('TOPLEFT', self)
		self.SafeZone:SetPoint('BOTTOMLEFT', self)
	end
	CheckInterrupt(self, unit)
end

local function UpdateCastStart(self, event, unit, name, rank, text, castid)
	if (self.Latency) then
		self.Latency:ClearAllPoints()
		self.Latency:SetPoint('RIGHT', self, 'BOTTOMRIGHT', -1, 1)

		local _, _, ms = GetNetStats()
		self.Latency:SetFormattedText('%dms', ms)
	end

	if (self.SafeZone) then
		self.SafeZone:SetDrawLayer('BORDER')
		self.SafeZone:SetPoint('TOPRIGHT', self)
		self.SafeZone:SetPoint('BOTTOMRIGHT', self)
	end
	CheckInterrupt(self, unit)
end

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub('(.)', string.upper, 1)

	if(unit == 'party' or unit == 'partypet') then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
	elseif(_G[cunit..'FrameDropDown']) then
		ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], 'cursor', 0, 0)
	end
end

local updateRIcon = function(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if(index) then
		self.RIcon:SetText(ICON_LIST[index]..'22|t')
	else
		self.RIcon:SetText()
	end
end

------------------------------
--Tags
------------------------------
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

oUF.TagEvents['AfterRaidName'] = 'UNIT_NAME_UPDATE'
oUF.Tags['AfterRaidName'] = function(unit)
	local Name = utf8sub(UnitName(unit), 2, false)
	return Name
end

local function ShortenValue(value)
	if(value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

oUF.Tags['Afterhealth'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'

	if(status) then
		return status
	elseif(unit == 'target' and UnitCanAttack('player', unit)) then
		return ('%s | %d %%'):format(ShortenValue(min), min / max * 100)
	elseif(unit == 'player' and min ~= max) then
		return ('%d | %d%%'):format(min - max, min / max * 100)
	elseif(unit == 'focus') then
		return ('%d%%'):format(min/max * 100)
	elseif(min ~= max) then
		return ('%s | %s'):format(ShortenValue(min), ShortenValue(max))
	else
		return max
	end
end
oUF.TagEvents['Afterhealth'] = 'UNIT_HEALTH UNIT_MAXHEALTH'

oUF.Tags['Afterpower'] = function(unit)
	local power = UnitPower(unit)
	if(power > 0 and not UnitIsDeadOrGhost(unit)) then
		return power
	end
end
oUF.TagEvents['Afterpower'] = oUF.TagEvents.missingpp

local function UpdateDruidPower(self)
	local bar = self.DruidPower
	local num, str = UnitPowerType('player')
	local min = UnitPower('player', (num ~= 0) and 0 or 3)
	local max = UnitPowerMax('player', (num ~= 0) and 0 or 3)

	bar:SetMinMaxValues(0, max)

	if(min ~= max) then
		bar:SetValue(min)
		bar:SetAlpha(1)

		if(num ~= 0) then
			bar:SetStatusBarColor(unpack(colors.power['MANA']))
			bar.Text:SetFormattedText('%d | %d%%', min, math.floor(min / max * 100))
		else
			bar:SetStatusBarColor(unpack(colors.power['ENERGY']))
			bar.Text:SetText()
		end
	else
		bar:SetAlpha(0)
		bar.Text:SetText()
	end
end

------------------------------
--Aura config
------------------------------

local auraIcon = function(icons, button)
	
	if(DebuffType) then
	  icons.showDebuffType = true
	end 
	
	if(CooldownCount) then
	  button.cd.noCooldownCount = true
	end  
	button.cd.noOCC = true
	button.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
	
	button.overlay:SetTexture(border)
	button.overlay:SetTexCoord(0, 1, 0, 1)
	button.overlay:ClearAllPoints()
	button.overlay:SetPoint('TOPRIGHT', button, 1.35, 1.35)
	button.overlay:SetPoint('BOTTOMLEFT', button, -1.35, -1.35)
	button.overlay.Hide = function(self) self:SetVertexColor(0.35, 0.35, 0.35, 1) end

	button.cd:SetReverse()
	button.cd:ClearAllPoints()
	button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
	button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)

	button.count:SetFont(E.font, 14, 'OUTLINE')
	button.count:ClearAllPoints()
	button.count:SetPoint('BOTTOMRIGHT', 1, 1)
	
	button.remaining = E.EuiSetFontn(button, E.font, 12, "LEFT")
	button.remaining:SetPoint("CENTER", 0 , 2)

	if (not button.background) then
		button.background = button:CreateTexture(nil, 'BACKGROUND')
		button.background:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
		button.background:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
		button.background:SetTexture([[Interface\AddOns\Eui\media\borderBackground]])
		button.background:SetVertexColor(0, 0, 0, 1)
	end
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

------------------------------
--Layout
------------------------------

local func = function(self, unit)
	self.colors = colors
	self.menu = menu
	self.ignoreHealComm = true
	self.DebuffHighlightBackdrop = false
	self.DebuffHighlightFilter = false
	
	self:EnableMouse(true)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks'anyup'
	self:SetAttribute('*type2', 'menu')
	
	E.CreateBorder(self, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)

	local hp = CreateFrame'StatusBar'
--[[	if(unit == 'targettarget')then
		hp:SetHeight(height*.85)
	else
		hp:SetHeight(height*.85)
	end
]]
	if unit =='pet' then
		hp:SetHeight(C["unitframe"].petheight*.85)
	elseif unit =='targettarget' then
		hp:SetHeight(C["unitframe"].totheight*.85)
	elseif unit =='focus' then
		hp:SetHeight(C["unitframe"].focusheight*.85)
	elseif unit =='focustarget' then
		hp:SetHeight(C["unitframe"].focusheight*.8*.85)
	else
		hp:SetHeight(height*.85)
	end

	
	hp:SetStatusBarTexture(texture)
	hp.Smooth = false
	hp:SetStatusBarColor(.25, .25, .25)
	hp.frequentUpdates = true
	hp:SetParent(self)
	hp:SetPoint'TOP'
	hp:SetPoint'LEFT'
	hp:SetPoint'RIGHT'

	local hpbg = hp:CreateTexture(nil, 'BORDER')
	hpbg:SetAllPoints(hp)
	hpbg:SetTexture(0, 0, 0, 0.9)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, 0.9)

	local hpp = hp:CreateFontString(nil, 'OVERLAY')
	hpp:SetFont(font, fontsize, 'OUTLINE')
	hpp:SetPoint('RIGHT',hp, -2, 0)
	self:Tag(hpp, '[raidcolor][Afterhealth]')

	if unit == 'player' then
		hpp:SetPoint('RIGHT',hp, -2, 0)
	elseif unit == 'target' or unit:find("boss%d") then
		hpp:SetPoint('RIGHT',hp, -2, 0)
	elseif unit == 'focus' then
		hpp:SetPoint('RIGHT',hp, -2,0)
	elseif unit == 'focus' or unit == 'pet' or unit == 'targettarget' or unit == 'focustarget' then
		hpp:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT', 500000000, -500000000)
	end

	hp.bg = hpbg
	hp.value = hpp
	self.Health = hp
	self.OverrideUpdateHealth = updateHealth
	

	local pp = CreateFrame'StatusBar'
	--	pp:SetHeight(height*.11)
	if unit =='pet' then
		pp:SetHeight(C["unitframe"].petheight*.11)
	elseif unit =='targettarget' then
		pp:SetHeight(C["unitframe"].totheight*.11)
	elseif unit =='focus' then
		pp:SetHeight(C["unitframe"].focusheight*.11)
	elseif unit =='focustarget' then
		pp:SetHeight(C["unitframe"].focusheight*.8*.11)
	else
		pp:SetHeight(height*.11)
	end
	pp:SetStatusBarTexture(texture)
	pp.frequentUpdates = true
	pp.colorTapping = true
	pp.colorHappiness = true
	pp.colorClass = true
	pp.colorReaction = true
	pp.Smooth = false
	pp:SetParent(self)
	pp:SetPoint('BOTTOM')
	pp:SetPoint('LEFT', .2, 0)
	pp:SetPoint('RIGHT', -.2, 0)

	local ppbg = pp:CreateTexture(nil, 'BORDER')
	ppbg:SetAllPoints(pp)
	ppbg:SetTexture(texture)
	ppbg.multiplier = .3

	local ppp = pp:CreateFontString(nil, 'OVERLAY')
	ppp:SetFont(font, fontsize, 'OUTLINE')
	if unit == 'targettarget' or unit == 'focustarget' or unit == 'focus' then
		ppp:SetPoint('LEFT',hpp,'RIGHT', -5000, 0)
	else
		ppp:SetPoint('LEFT',hpp,'RIGHT', -(C["unitframe"].playerwidth-5), 0)
	end
	self:Tag(ppp, '[raidcolor][Afterpower]')

	pp.value = ppp
	pp.bg = ppbg
	self.Power = pp
	self.PostUpdatePower = updatePower

  --------------------------------
	    --CastBars
  --------------------------------

	if(CastBars)then
		if(unit == 'player' or unit == 'focus' or unit == 'target' or unit == 'pet') then
			self.Castbar = CreateFrame('StatusBar', nil, self)
			self.Castbar:SetStatusBarTexture(texture)
			self.Castbar:SetScale(1)
			self.Castbar:SetStatusBarColor(.25, .25, .25)
			E.CreateBorder(self.Castbar, 11, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

			self.Castbar.Bg = self.Castbar:CreateTexture(nil, 'BACKGROUND')
			self.Castbar.Bg:SetAllPoints(self.Castbar)
			self.Castbar.Bg:SetTexture(texture)
			self.Castbar.Bg:SetVertexColor(0, 0, 0, 0.6)

			if(unit == 'player')then
				local playerColor = E.RAID_CLASS_COLORS[select(2, UnitClass('player'))]
				if(ClassColor)then
					self.Castbar:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
				end
			--	self.Castbar.Icon = self.Castbar:CreateTexture(nil, "ARTWORK")
			--	self.Castbar.Icon:SetHeight(44)
			--	self.Castbar.Icon:SetWidth(44)
			--	self.Castbar.Icon:SetPoint("RIGHT", 52, 7)

			--	self.IconOverlay = self.Castbar:CreateTexture(nil, "OVERLAY")
			--	self.IconOverlay:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT")
			--	self.IconOverlay:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT")
			--	self.IconOverlay:SetTexture(border)
			--	self.IconOverlay:SetVertexColor(0.35, 0.35, 0.35, 1)

			--	self.Castbar.IconBack = self.Castbar:CreateTexture(nil, "BACKGROUND")
			--	self.Castbar.IconBack:SetPoint("TOPLEFT",self.Castbar.Icon,"TOPLEFT",-6,6)
			--	self.Castbar.IconBack:SetPoint("BOTTOMRIGHT",self.Castbar.Icon,"BOTTOMRIGHT",6,-6)
			--	self.Castbar.IconBack:SetTexture([[Interface\AddOns\Eui\media\borderBackground]])
			--	self.Castbar.IconBack:SetVertexColor(0, 0, 0, 1)				
				
				if class == 'SHAMAN' or class == 'DEATHKNIGHT' then
					self.Castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -30)
				else
					self.Castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -10)
				end
				self.Castbar:SetHeight(20)
				self.Castbar:SetWidth(C["unitframe"].playerwidth)
			--	self.Castbar:SetScale(0.8)
				self.Castbar:SetParent(UIParent)

				if(Safezone)then
					self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, 'BORDER')
					self.Castbar.SafeZone:SetTexture('Interface\\Buttons\\WHITE8x8')
					self.Castbar.SafeZone:SetVertexColor(1, 0.5, 0, 1)
				end

				if(Latency)then
					self.Castbar.Latency = self:CreateFontString(nil, 'ARTWORK')
					self.Castbar.Latency:SetFont(font, 12, 'OUTLINE')
					self.Castbar.Latency:SetParent(self.Castbar)
					self.Castbar.Latency:SetDrawLayer('OVERLAY')
					self.Castbar.Latency:SetVertexColor(0.6, 0.6, 0.6)
					self.Castbar.Latency:SetAlpha(1)
				end



			end

			self.Castbar.CustomDelayText = function(self, duration)
				self.Time:SetFormattedText('(|cffff0000-%.1f|r) %.1f | %.1f', self.delay, duration, self.max)
			end
	
			self.Castbar.CustomTimeText = function(self, duration)
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
			end

			self.Castbar.Time = self:CreateFontString(nil, 'ARTWORK')
			self.Castbar.Time:SetFont(font, 13, 'OUTLINE')
			self.Castbar.Time:SetPoint('RIGHT', self.Castbar, 'RIGHT', -7, 0)
			self.Castbar.Time:SetHeight(10)
			self.Castbar.Time:SetJustifyH('RIGHT')
			self.Castbar.Time:SetParent(self.Castbar)

			self.Castbar.Text = self:CreateFontString(nil, 'ARTWORK')
			self.Castbar.Text:SetFont(font, 13, 'OUTLINE')
			self.Castbar.Text:SetPoint('LEFT', self.Castbar, 4, 0)
			self.Castbar.Text:SetPoint('RIGHT', self.Castbar.Time, 'LEFT', -7, 0)
			self.Castbar.Text:SetHeight(10)
			self.Castbar.Text:SetJustifyH('LEFT')
			self.Castbar.Text:SetParent(self.Castbar)
			
			if (unit == 'focus') then
				self.Castbar:SetPoint('CENTER', UIParent, 'CENTER', -10, -10)
				self.Castbar:SetWidth(260)
				self.Castbar:SetHeight(25)
				self.Castbar:SetStatusBarColor(.25, .25, .25)
				 self.Castbar.Icon = self.Castbar:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetHeight(44)
				self.Castbar.Icon:SetWidth(44)
				self.Castbar.Icon:SetPoint("LEFT", -52, 7)
				self.IconOverlay = self.Castbar:CreateTexture(nil, "OVERLAY")
				self.IconOverlay:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT")
				self.IconOverlay:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT")
				self.IconOverlay:SetTexture(border)
				self.IconOverlay:SetVertexColor(0.35, 0.35, 0.35, 1)
				self.Castbar.IconBack = self.Castbar:CreateTexture(nil, "BACKGROUND")
				self.Castbar.IconBack:SetPoint("TOPLEFT",self.Castbar.Icon,"TOPLEFT",-6,6)
				self.Castbar.IconBack:SetPoint("BOTTOMRIGHT",self.Castbar.Icon,"BOTTOMRIGHT",6,-6)
				self.Castbar.IconBack:SetTexture([[Interface\AddOns\Eui\media\borderBackground]])
				self.Castbar.IconBack:SetVertexColor(0, 0, 0, 1)				
			elseif (unit == 'target') then
				self.Castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -10)
				self.Castbar:SetWidth(C["unitframe"].playerwidth)
				self.Castbar:SetHeight(20)
				self.Castbar:SetStatusBarColor(.25, .25, .25)
				self.Castbar:SetParent(self)
			elseif (unit == 'pet') then
			    self.Castbar:SetStatusBarColor(.25, .25, .25)
		        self.Castbar:SetParent(self)
				self.Castbar:SetHeight(22)
				self.Castbar:SetWidth(C["unitframe"].petwidth)
				self.Castbar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 10)
			end
			if unit == 'player' or unit == 'target' or unit == 'focus' then
				self.Castbar.PostCastStart = UpdateCastStart
				self.Castbar.PostChannelStart = UpdateChannelStart
			end
		end

	end

	for _, bar in pairs({
		'MirrorTimer1',
		'MirrorTimer2',
		'MirrorTimer3',
	}) do
		for i, region in pairs({_G[bar]:GetRegions()}) do
			if (region.GetTexture and region:GetTexture() == 'SolidTexture') then
				region:Hide()
			end
		end

		E.CreateBorder(_G[bar], 11, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

		_G[bar..'Border']:Hide()

		_G[bar]:SetParent(UIParent)
		_G[bar]:SetScale(1.132)
		_G[bar]:SetHeight(20)
		_G[bar]:SetWidth(280)

		_G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
		_G[bar..'Background']:SetTexture('Interface\\Buttons\\WHITE8x8')
		_G[bar..'Background']:SetAllPoints(bar)
		_G[bar..'Background']:SetVertexColor(0, 0, 0, 0.5)

		_G[bar..'Text']:SetFont(CastingBarFrameText:GetFont(), 13)
		_G[bar..'Text']:ClearAllPoints()
		_G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)

		_G[bar..'StatusBar']:SetAllPoints(_G[bar])
	end
--------------------------------
	    --Signs
--------------------------------
	if(unit == 'player') then
		local leader = hp:CreateTexture(nil, 'OVERLAY')
		leader:SetHeight(15)
		leader:SetWidth(15)
		leader:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', -5, -2)
		leader:SetTexture('Interface\\GroupFrame\\UI-Group-LeaderIcon')
		self.Leader = leader

		local masterlooter = hp:CreateTexture(nil, 'OVERLAY')
		masterlooter:SetHeight(15)
		masterlooter:SetWidth(15)
		masterlooter:SetPoint('LEFT', leader, 'RIGHT')
		self.MasterLooter = masterlooter
	end
------------------------------
	    --Portraits
------------------------------
	if(Portraits) then
	    local portrait = CreateFrame('PlayerModel', nil, self)
	      portrait:SetBackdrop(backdrop)
	      portrait:SetBackdropColor(0, 0, 0, .9)
	      portrait:SetScript('OnShow', function(self) self:SetCamera(0) end)
	      portrait:SetWidth(height*1.5)
	      portrait:SetHeight(height*1.5)
	      portrait.type = '3D'
	      self.Portrait = portrait

          E.CreateBorder(portrait, 12, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)

	    if(unit == 'player') then
	      portrait:SetPoint('TOPRIGHT', self, 'TOPLEFT', -11, 0)
	    elseif(unit == 'target') then
	      portrait:SetPoint('TOPLEFT', self, 'TOPRIGHT', 11, 0)
	    elseif(unit == 'focus' or unit == 'pet') then
	      portrait:SetPoint('TOPRIGHT', self, 'TOPLEFT', -11, 0)
		  
		end  
	end 
    ------------------------------------
    --ICON
    ------------------------------------

	if(PvPIcon) then
	   local pvp = hp:CreateTexture(nil, 'OVERLAY')
	   pvp:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 18, -45)
	   pvp:SetHeight(28)
	   pvp:SetWidth(28)
	   self.PvP = pvp
    end
	
	if(unit == 'player') then
		self.Resting = self.Power:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetHeight(18)
		self.Resting:SetWidth(20)
		self.Resting:SetPoint('BOTTOMLEFT', -8.5, -8.5)
		self.Resting:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.Resting:SetTexCoord(0,0.5,0,0.421875)
	end
	
	local Combat = hp:CreateTexture(nil, 'OVERLAY')
	Combat:SetHeight(21)
	Combat:SetWidth(21)
	Combat:SetPoint('BOTTOMLEFT', hp, -10, -10)
	self.Combat = Combat

	local ricon = hp:CreateFontString(nil, 'OVERLAY')
	ricon:SetFontObject(GameFontNormalSmall)
	ricon:SetTextColor(1, 1, 1)
	ricon:SetPoint('CENTER', hp, 0, 12)
	ricon:SetHeight(24)
	ricon:SetWidth(24)
	self.RIcon = ricon
	self:RegisterEvent('RAID_TARGET_UPDATE', updateRIcon)
	table.insert(self.__elements, updateRIcon)

	if(unit == 'target') and C["unitframe"].cpoint == true then
		local cpoints = self:CreateFontString(nil, 'OVERLAY')
		cpoints:SetFont(font, 26, 'OUTLINE')
		cpoints:SetPoint('RIGHT', self, 'LEFT', -10, 0)
		cpoints:SetJustifyH('RIGHT')
		self:Tag(cpoints, '[cpoints]')
	end
	
	if(unit == 'player' or unit == 'target' or unit =='focus' or unit == 'pet' or unit == 'targetarget' or unit == 'focustarget') then
		local cbft = hp:CreateFontString(nil, 'OVERLAY')
		cbft:SetPoint('CENTER', self)
		cbft:SetFont(font, 21, 'OUTLINE')
		self.CombatFeedbackText = cbft
		self.CombatFeedbackText.maxAlpha = 1

	end

	if(unit~='player')then
		local name = hp:CreateFontString(nil, 'OVERLAY')
		if(unit == 'targettarget' or unit == 'pet' or unit == 'focustarget') then
			name:SetPoint('CENTER')
			name:SetWidth(150)
		elseif unit == 'focus' then
			name:SetPoint('LEFT', hp, 'LEFT', 2, 0)
			name:SetJustifyH'LEFT'
			name:SetWidth(150)
		else
			name:SetPoint('LEFT', hp, 'LEFT', -2, 27)
			name:SetJustifyH'LEFT'
			name:SetWidth(300)
		end
		name:SetFont(font, fontsize, 'OUTLINE')
		name:SetTextColor(1, 1, 1)
		name:SetHeight(fontsize)
		self.Info = name
		if(unit == 'target')then
			self:Tag(self.Info,'[difficulty][level][shortclassification] [raidcolor][name]')
		else
			self:Tag(self.Info,'[raidcolor][name]')
		end
	--	self:SetAttribute('initial-scale', 0.8)
	end
----------------------------------
-- Auras
----------------------------------
	if unit == 'target' then
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -1, 27)
		Auras.showDebuffType = true
		Auras:SetWidth(C["unitframe"].playerwidth-4)
		Auras:SetHeight(C["unitframe"].playerheight * 2)
		Auras.size = 25
		Auras.spacing = 4
		Auras.gap = true
		Auras.numBuffs = 18
		Auras.numDebuffs = 21
		Auras.PostCreateIcon = auraIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		self.Auras = Auras	
	end

	if(Buffs) and unit ~= 'target' then
		local buffs = CreateFrame('Frame', nil, self)
	--	buffs:SetHeight(width)
	--	buffs:SetWidth(540)
		buffs:SetHeight(width)
		buffs:SetWidth(width*2)
		buffs.PostCreateIcon = auraIcon
	--[[	if(unit == 'player') then
			buffs.initialAnchor = 'TOPLEFT'
			buffs['growth-y'] = 'DOWN'
			buffs['growth-x'] = 'RIGHT'
			buffs:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 5, -5)
			buffs.size = 36
			buffs.spacing = 5
		end]]

		if(unit == 'pet' or unit == 'focus' or unit == 'target') then
			buffs.initialAnchor = 'TOPLEFT'
			buffs['growth-y'] = 'RIGHT'
			buffs['growth-x'] = 'DOWN'
			buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -3, -8)
			buffs.size = 28
			buffs.spacing = 3
		end

		if(unit == 'focus' or unit == 'pet') then
			buffs.num = 2
		elseif(unit=='target') then
			buffs.num = 9
		else
			buffs.num = 40
		end
		self.Buffs = buffs
		buffs.PostUpdateIcon = PostUpdateIcon
	end

	if(Debuffs) and unit ~= 'target' then
		local debuffs = CreateFrame('Frame', nil, self)
		debuffs:SetHeight(width)
		debuffs:SetWidth(width)
		debuffs.PostCreateIcon = auraIcon
		if(unit == 'pet'or unit == 'focus') then
			debuffs:SetPoint('LEFT', self, 'RIGHT', 7, 0)
			debuffs['growth-x'] = 'RIGHT'
			debuffs.initialAnchor = 'LEFT'
			debuffs.size = 28
			debuffs.spacing = 5
		elseif(unit == 'player') then
			debuffs:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 5, -132)
			debuffs['growth-x'] = 'RIGHT'
			debuffs.initialAnchor = 'TOPLEFT'
			
		elseif(unit == 'targettarget' or unit == 'focustarget') then
			debuffs:SetPoint('LEFT', self, 'RIGHT', 20, 5)
			debuffs['growth-x'] = 'RIGHT'
			debuffs.initialAnchor = 'LEFT'
		else
			debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -4, 27)
			debuffs['growth-y'] = 'UP'
			debuffs.initialAnchor = 'BOTTOMLEFT'
			if(PlayerOnlyDebuffs)then
				debuffs.onlyShowPlayer = false
			end
		end
		debuffs.size = 24
		debuffs.spacing = 3
		if(unit == 'player') then
			debuffs.size = 32
			debuffs:SetWidth(500)
			debuffs.spacing = 5
			debuffs.num = 32
		elseif(unit == 'targettarget')  then
			debuffs.num = 0
		elseif(unit=='target') then
			debuffs.num = 20
		else
			debuffs.num = 4
		end
		if unit == 'player' then debuffs.num =0 end
		self.Debuffs = debuffs
		debuffs.PostUpdateIcon = PostUpdateIcon
	end

	if(unit == 'player') then
		if(IsAddOnLoaded('oUF_Swing')) then
			self.Swing = CreateFrame('StatusBar', nil, self)
			self.Swing:SetPoint('TOP', self, 'BOTTOM', 335, -1)
			self.Swing:SetStatusBarTexture(texture)
			self.Swing:SetStatusBarColor(1, 0.7, 0)
			self.Swing:SetHeight(15)
			self.Swing:SetWidth(width)
			self.Swing:SetBackdrop(backdrop)
			self.Swing:SetBackdropColor(0, 0, 0)
			
			local playerColor = E.RAID_CLASS_COLORS[select(2, UnitClass('player'))]
            if(SwingClassColors)then
            self.Swing:SetStatusBarColor(playerColor.r, playerColor.g, playerColor.b)
            end
			
			E.CreateBorder(self.Swing, 12, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

			self.Swing.Text = self.Swing:CreateFontString(nil, 'OVERLAY')
			self.Swing.Text:SetFont(font, 24, 'OUTLINE')
			self.Swing.Text:SetPoint('CENTER', self.Swing)

			self.Swing.bg = self.Swing:CreateTexture(nil, 'BORDER')
			self.Swing.bg:SetAllPoints(self.Swing)
			self.Swing.bg:SetTexture(0, 0, 0, 0.1)
			
			if(SwingMeele)then
			 self.Swing.disableMelee = false
			end
			
			if(SwingRange)then
			 self.Swing.disableRanged = false
            end
        end
    
		if class == 'DEATHKNIGHT' and C["unitframe"].cpoint == true then
			self.Runes = CreateFrame('Frame', nil, UIParent)
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
				if(i == 1) then
					self.Runes[i]:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
				else
					self.Runes[i]:SetPoint('TOPLEFT', self.Runes[i-1], 'TOPRIGHT', 5, 0)
				end
				self.Runes[i]:SetStatusBarTexture(texture)
				self.Runes[i]:SetHeight(10)
				self.Runes[i]:SetWidth((width-20)/6 - 0.85)
				self.Runes[i]:SetBackdrop(backdrop)
				self.Runes[i]:SetBackdropColor(.1, .1, .1)
			--	self.Runes[i]:SetMinMaxValues(0, 1)

				E.CreateBorder(self.Runes[i], 12, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, 'BORDER')
				self.Runes[i].bg:SetAllPoints(self.Runes[i])
				self.Runes[i].bg:SetTexture(0.1, 0.1, 0.1)
			end
		end

		if class == 'SHAMAN' and C["unitframe"].cpoint == true then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame('StatusBar', nil, self)
				self.TotemBar[i]:SetHeight(12)
				self.TotemBar[i]:SetWidth((width-5)/4 - 5)
				if (i == 1) then
					self.TotemBar[i]:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -1, -9)
				else
					self.TotemBar[i]:SetPoint('RIGHT', self.TotemBar[i-1], 'LEFT', -8, 0)
				end

                E.CreateBorder(self.TotemBar[i], 12, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

				self.TotemBar[i]:SetStatusBarTexture(texture)
				self.TotemBar[i]:SetBackdrop(backdrop)
				self.TotemBar[i]:SetBackdropColor(0,0,0,6)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, 'BORDER')
				self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
				self.TotemBar[i].bg:SetTexture(texture)
				self.TotemBar[i].bg.multiplier = 0.3
			end
		end

		if(IsAddOnLoaded('oUF_Experience')) then
			self.Experience = CreateFrame('StatusBar', nil, self)
			self.Experience:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -13)
			self.Experience:SetStatusBarTexture(texture)
			self.Experience:SetStatusBarColor(0,.7,1)
			self.Experience:SetHeight(15)
			self.Experience:SetWidth((unit == 'pet') and 150 or width)
			self.Experience:SetBackdrop(backdrop)
			self.Experience:SetBackdropColor(0, 0, 0, .5)

			self.Experience.Tooltip = true

			E.CreateBorder(self.Experience, 12, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3)

			self.Experience.Text = self.Experience:CreateFontString(nil, 'OVERLAY')
			self.Experience.Text:SetFont(font, fontsize, 'OUTLINE')
			self.Experience.Text:SetPoint('CENTER', self.Experience)
			self.Experience.bg = self.Experience:CreateTexture(nil, 'BORDER')
			self.Experience.bg:SetAllPoints(self.Experience)
			self.Experience.bg:SetTexture(0, 0, 0, .5)
		end

		if(class == 'DRUID') then
			self.DruidPower = CreateFrame('StatusBar', nil, self)
			self.DruidPower:SetPoint('BOTTOM', self.Power, 'TOP')
			self.DruidPower:SetStatusBarTexture(texture)
			self.DruidPower:SetHeight(1)
			self.DruidPower:SetWidth(width)
			self.DruidPower:SetAlpha(0)

			self.DruidPower.Text = self.DruidPower:CreateFontString(nil, 'OVERLAY')
			self.DruidPower.Text:SetFont(font, fontsize, 'OUTLINE')
			self.DruidPower.Text:SetPoint('CENTER', self.DruidPower)
			self.DruidPower.Text:SetTextColor(unpack(colors.power['MANA']))

			self:RegisterEvent('UNIT_MANA', UpdateDruidPower)
			self:RegisterEvent('UNIT_ENERGY', UpdateDruidPower)
			self:RegisterEvent('PLAYER_LOGIN', UpdateDruidPower)
		end

	end

	if(unit =='focus' or unit == 'pet' or unit == 'targetarget' or unit == 'focustarget') then
 --[[	
        self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
 ]]
        self.SpellRange = true
        
        self.SpellRange = {
            insideAlpha = 1,
            outsideAlpha = 0.3,
        }
		
    end

	if unit =='pet' then
		self:SetAttribute('initial-width', C["unitframe"].petwidth)
		self:SetAttribute('initial-height', C["unitframe"].petheight)
	elseif unit =='targettarget' then
		self:SetAttribute('initial-width', C["unitframe"].totwidth)
		self:SetAttribute('initial-height', C["unitframe"].totheight)
	elseif unit =='focus' then
		self:SetAttribute('initial-width', C["unitframe"].focuswidth)
		self:SetAttribute('initial-height', C["unitframe"].focusheight)
	elseif unit =='focustarget' then
		self:SetAttribute('initial-width', C["unitframe"].focuswidth*0.8)
		self:SetAttribute('initial-height', C["unitframe"].focusheight*0.8)
	else
		self:SetAttribute('initial-height', height)
		self:SetAttribute('initial-width', width)
	--	self:SetAttribute('initial-scale', 0.8)
	end
	
	self.disallowVehicleSwap = true

	return self	
    
end

local function menu(self)
	if(self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
	end
end

local function UpdateThreat(self, _, unit)
	if (self.unit ~= unit) then 
        return 
    end

    if (self.Aggro) then
        local threat = UnitThreatSituation(self.unit)
        if (threat == 3) then
            self.Aggro:SetText('|cFFFF0000AGGRO')
            self.Health:SetBackdropColor(0.9, 0, 0) 
        else
            self.Aggro:SetText('')
            self.Health:SetBackdropColor(0, 0, 0) 
        end
    end
end

local function raidlayout(self, unit)
	self.menu = menu
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:SetAttribute('*type2', 'menu')
	self:SetAttribute('initial-height', 38)
	self:SetAttribute('initial-width', 42)
	
	E.CreateBorder(self, 11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)

	self:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1.5, left = -1.5, bottom = -1.5, right = -1.5}})
	self:SetBackdropColor(0, 0, 0, 0.8)

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(bartexture)
	self.Health:SetParent(self)
	self.Health:SetAllPoints(self)
	self.Health.colorClass = true
	self.Health.Smooth = false
	self.Health:SetOrientation('HORIZONTAL')
	self.Health:SetOrientation('VERTICAL')
	
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(bartexture)
	self.Health.bg:SetAlpha(0.4)

	self.Name = self.Health:CreateFontString(nil, 'OVERLAY')
	self.Name:SetPoint('TOP', 0, -12)
	self.Name:SetFont(font, 11, 'OUTLINE')
	self:Tag(self.Name, '|cffffffff[AfterRaidName]|r')
	
    self.MasterLooter = self.Health:CreateTexture('$parentMasterLooterIcon', 'OVERLAY', self)
    self.MasterLooter:SetHeight(12)
    self.MasterLooter:SetWidth(12)
    self.MasterLooter:SetPoint('RIGHT', self.Health, 'TOPRIGHT', 2, 2)

    self.Leader = self.Health:CreateTexture('$parentLeaderIcon', 'OVERLAY', self)
    self.Leader:SetHeight(14)
    self.Leader:SetWidth(14)
    self.Leader:SetPoint('LEFT', self.Health, 'TOPLEFT', -5, 2)

    self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon:SetHeight(17)
    self.RaidIcon:SetWidth(17)
    self.RaidIcon:SetPoint('CENTER', self, 'TOP')
    self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')

    self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
    self.ReadyCheck:SetPoint('TOPRIGHT', self.Health, -7, -7)
    self.ReadyCheck:SetPoint('BOTTOMLEFT', self.Health, 7, 7)
    self.ReadyCheck.delayTime = 4
	self.ReadyCheck.fadeTime = 1
	
    self.Aggro = self.Health:CreateFontString(nil, 'OVERLAY')
    self.Aggro:SetPoint('CENTER', self.Health, 'BOTTOM')
    self.Aggro:SetFont(font, 11, 'OUTLINE')
	
	table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)

	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.3,
	}
	
    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }
	
	return self
end

oUF:RegisterStyle('Aftermathh', func)
oUF:SetActiveStyle'Aftermathh'

if C["raid"].grid == true then
	ptx = (C["raid"].gridw * 5 + 20) / 2 + 4
	pty = C["raid"].gridh * 5 + 20 + C["raid"].gridheight
	
else
	ptx = C["unitframe"].totwidth / 2 + 8
	pty = C["unitframe"].petheight + 162 + 23 + C["actionbar"].petbuttonsize + C["actionbar"].buttonspacing*2	
end	
--if C["actionbar"].actionbarrows > 2 then pty = pty + 33 end

local player = oUF:Spawn('player') 
player:SetPoint('TOPRIGHT', UIParent, 'BOTTOM', -ptx, pty)
local target = oUF:Spawn('target')
target:SetPoint('TOPLEFT', UIParent, 'BOTTOM', ptx, pty)
local tot = oUF:Spawn('targettarget')
tot:SetPoint('BOTTOMLEFT', oUF_AftermathhTarget, "TOPRIGHT", 11, 11)
local pet = oUF:Spawn('pet')
pet:SetPoint('BOTTOMRIGHT', oUF_AftermathhPlayer, "TOPLEFT", -11, 11)
local focus = oUF:Spawn('focus')
focus:SetPoint('LEFT', UIParent, 105, -158)
local fot = oUF:Spawn('focustarget')
fot:SetPoint('BOTTOMLEFT',oUF_AftermathhFocus, "TOPLEFT" ,0, 11)

oUF:DisableBlizzard'party'
--[[ do 
    for k,v in pairs(UnitPopupMenus) do
        for x,y in pairs(UnitPopupMenus[k]) do
            if y == "SET_FOCUS" then
                table.remove(UnitPopupMenus[k],x)
            elseif y == "CLEAR_FOCUS" then
                table.remove(UnitPopupMenus[k],x)
            end
        end
    end
end ]]