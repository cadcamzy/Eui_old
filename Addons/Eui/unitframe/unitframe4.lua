local E,C = unpack(select(2, ...))
if C["unitframe"].aaaaunit ~= 4 then return end
----------------------------------------------------------
-- Config
----------------------------------------------------------
local castbars = C["unitframe"].castbar           -- Enable or Disable the Castbars

-- Heights
local hpheight = C["unitframe"].playerheight * 5 / 6    -- Player & Target 14
local shpheight = 15           -- Target of Target, Focus, and Pet 10
local ppheight = C["unitframe"].playerheight / 6              -- Power 2
local cbheight = 15

-- Widths
local hpwidth = C["unitframe"].playerwidth           -- Player, Focus, Pet and Target 288
local shpwidth = 156            -- Target of Target, and Focus width 196

-- Initial Positions (shift+alt+drag to move)
--local pty
if C["unitframe"].playery >0 then pty = C["unitframe"].playery else pty = 300 end
if C["raid"].grid == true then pty = pty + 94 end

playerx = -C["unitframe"].playerx
playery = pty

targetx = C["unitframe"].playerx
targety = pty

totx = 0
toty = pty + C["unitframe"].playerwidth/2

focusx = 20
focusy = -220

petx = 0
pety = pty



-- Texures and fonts
local texture = "Interface\\Buttons\\WHITE8x8"
local fontsize = 11
local font = STANDARD_TEXT_FONT
local TEXTURE = [[Interface\AddOns\Eui\media\dm2]]
local BACKDROP = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
------------------------------------------------------
-- Boring Presets
------------------------------------------------------
local function Backdrop(frame)
    frame:SetBackdrop({bgFile = texture, insets = {top = -2, left = -2, bottom = -2, right = -2}})
	frame:SetBackdropColor(0, 0, 0, 1)
end

oUF.colors.power['MANA'] = {26/255, 139/255, 255/255}
local function updateCombo(self, event, unit)
	if(unit == PlayerFrame.unit and unit ~= self.CPoints.unit) then
		self.CPoints.unit = unit
	end
end

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub('(.)', string.upper, 1)
	if(unit == 'party' or unit == 'partypet') then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
	elseif(_G[cunit..'FrameDropDown']) then
		ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], "cursor", 0, 0)
	end
end

local CheckInterrupt = function(self, unit)
	if unit == "vehicle" then unit = "player" end

	if self.interrupt and UnitCanAttack("player", unit) then
		self:SetStatusBarColor(1, 0, 0, 0.5)	
	else
		self:SetStatusBarColor(.1, .4, .7,.8)		
	end
end

local CheckCast = function(self, unit, name, rank, castid)
	CheckInterrupt(self, unit)
end

local CheckChannel = function(self, unit, name, rank)
	CheckInterrupt(self, unit)
end
------------------------------------------------------------------------
--      Layout
------------------------------------------------------------------------
local function layout(self, unit)
	self.menu = menu
	self:RegisterForClicks('AnyDown')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:SetAttribute('*type2', 'menu')
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton","RightButton")
    self:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
    self:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    self:SetUserPlaced(true)
    
-- Health
    local hp = CreateFrame('StatusBar', nil, self)
    hp:SetStatusBarTexture(texture)
    hp:SetAllPoints(self)
    
    Backdrop(hp)
    hpbg = hp:CreateTexture(nil, 'BORDER')
    hpbg:SetAllPoints(hp)
    hpbg:SetTexture(texture)
    hpbg:SetVertexColor(0.16,0.16,0.16,1)
    
    hp.colorClass = true
    hp.colorReaction = true
	hp.colorTapping = true
    hp.frequentUpdates = true
    
    self.Health = hp

-- Power
	pp = CreateFrame('StatusBar', nil, self)
    pp:SetStatusBarTexture(texture)
    pp:SetHeight(ppheight)
    pp:SetPoint("BOTTOM", hp, "TOP", 0, 2)
    pp:SetParent(self)
	pp:SetPoint'LEFT'
	pp:SetPoint'RIGHT'
    
    Backdrop(pp)
    ppbg = pp:CreateTexture(nil, 'BORDER')
	ppbg:SetAllPoints(pp)
	ppbg:SetTexture(texture)
	ppbg:SetVertexColor(0.16,0.16,0.16,1)

    pp.colorPower = true
    pp.frequentUpdates = true
    pp.frequentUpdates = true
    
    self.Power = pp
    
-----------------------------------------------------------------------
--      Texts
-----------------------------------------------------------------------
local function gradient(perc)
	if perc <= 0.5 then
		return 255, perc*510, 0
	else
		return 510 - perc*510, 255, 0
	end
end
local function truncate(value)
	if(value >= 1e6) then
		return gsub(format('%.2fm', value / 1e6), '%.?0+([km])$', '%1')
	elseif(value >= 1e5) then
		return gsub(format('%.1fk', value / 1e3), '%.?0+([km])$', '%1')
	else
		return value
	end
end
local numberize = function(v)
	if v <= 9999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 10000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

oUF.TagEvents['hp'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags['hp'] = function(unit)
	local r,g,b = gradient(UnitHealth(unit)/UnitHealthMax(unit))
    return format('|cff%02x%02x%02x %s |cffFFFFFF | |r|cff%02x%02x%02x%d%%|r', 
    r, g, b, numberize(UnitHealth(unit)), 
    r, g, b, floor((UnitHealth(unit)/UnitHealthMax(unit))*1000)/10)
end

oUF.TagEvents['pp'] = oUF.TagEvents['curpp']
oUF.Tags['pp'] = function(unit)
	local num, str = UnitPowerType(unit)
	local c = oUF.colors.power[str]
	return c and format('|cff%02x%02x%02x%s|r', c[1] * 255, c[2] * 255, c[3] * 255, numberize(oUF.Tags['curpp'](unit)))
end

oUF.TagEvents['[name]'] = 'UNIT_NAME_UPDATE'
oUF.Tags['[name]'] = function(unit)	
	local name = UnitName(unit)
	return (string.len(name) > 16) and string.gsub(name, "%s?(.)%S+%s", "%1. ") or name
end

-- [[ Health Text ]] --
local curhealth = hp:CreateFontString(nil, 'OVERLAY')
curhealth:SetFont(font, fontsize, "OUTLINE")
self:Tag(curhealth, '[hp]')
curhealth.frequentUpdates = 0.1

-- [[ Power Text ]] --
local curpower = hp:CreateFontString(nil, 'OVERLAY')
curpower:SetFont(font, fontsize, "OUTLINE")
self:Tag(curpower, '[pp]')
curpower.frequentUpdates = 0.1

-- [[ Name Text ]] --
local unitnames = hp:CreateFontString(nil, 'OVERLAY')
unitnames:SetFont(font, fontsize, "OUTLINE")
self:Tag(unitnames,'[name]')

--[[ raid icon ]]--
self.RaidIcon = hp:CreateTexture(nil, "OVERLAY")
self.RaidIcon:SetHeight(16)
self.RaidIcon:SetWidth(16)
self.RaidIcon:SetPoint('Center', self, 0, 0)
self.RaidIcon:SetTexture'Interface\\TargetingFrame\\UI-RaidTargetingIcons'

--[[ castbar format ]]--
local CastBarTime = function(self, duration)
    if self.channeling then
	    self.Time:SetFormattedText("%.1f", duration)
        self.Time:SetFont(font, fontsize, "OUTLINE")
    elseif self.casting then
	    self.Time:SetFormattedText("%.1f", self.max - duration)
        self.Time:SetFont(font, fontsize, "OUTLINE")
    end
end
-----------------------------------------------------------------------
--      Buffs / Debuffs
-----------------------------------------------------------------------
local function PostCreateAura(element, button)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
    
    icBorder = CreateFrame("Frame", nil)
    icBorder:SetParent(button)
    icBorder:SetFrameLevel(0)
    icBorder:SetPoint("TOPLEFT", button, "TOPLEFT")
    icBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
    Backdrop(icBorder)
    
    button.cd:SetReverse()
	button.cd.noCooldownCount = true
end
    --[[ buffs ]]--
	self.Buffs = CreateFrame("Frame", nil, self)
	self.Buffs.size = 18
	self.Buffs:SetHeight(self.Buffs.size)
	self.Buffs:SetWidth(hpwidth)
	self.Buffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 2, -6)
	self.Buffs.initialAnchor = 'TOPLEFT'
	self.Buffs["growth-y"] = 'DOWN'
	self.Buffs.num = 36
	self.Buffs.spacing = 6
    self.Buffs.PostCreateIcon = PostCreateAura

    --[[ debuffs ]]--
	self.Debuffs = CreateFrame("Frame", nil, self)
if unit == "target" then
	self.Debuffs.size = 22
	self.Debuffs:SetHeight(self.Debuffs.size)
	self.Debuffs:SetWidth(hpwidth)
    	--self.Debuffs:SetPoint('TOPLEFT', oUF.units.player, 'BOTTOMLEFT', 2, -6)
	self.Debuffs:SetPoint('BOTTOMLEFT',self,'TOPLEFT' , 2, 30)
	self.Debuffs.initialAnchor = 'TOPLEFT'
	self.Debuffs["growth-y"] = 'UP'
	self.Debuffs.num = 16
	self.Debuffs.spacing = 6
       --self.Debuffs.onlyShowPlayer = true
    self.Debuffs.PostCreateIcon = PostCreateAura
elseif unit == "focus" then
	self.Debuffs.size = 22
	self.Debuffs:SetHeight(self.Debuffs.size)
	self.Debuffs:SetWidth(hpwidth)
	self.Debuffs:SetPoint('TOPLEFT',self,'BOTTOMLEFT' , 2, -6)
	self.Debuffs.initialAnchor = 'TOPLEFT'
	self.Debuffs["growth-y"] = 'DOWN'
	self.Debuffs.num = 8
	self.Debuffs.spacing = 6
       --self.Debuffs.onlyShowPlayer = true
    self.Debuffs.PostCreateIcon = PostCreateAura--]]
elseif unit == "targettarget" then
	self.Debuffs.size = 16
	self.Debuffs:SetHeight(self.Debuffs.size)
	self.Debuffs:SetWidth(C["unitframe"].totwidth)
	self.Debuffs:SetPoint('BOTTOMLEFT',self,'TOPLEFT' , 2, 26)
	self.Debuffs.initialAnchor = 'TOPLEFT'
	self.Debuffs["growth-y"] = 'UP'
	self.Debuffs.num = 4
	self.Debuffs.spacing = 4
       --self.Debuffs.onlyShowPlayer = true
    self.Debuffs.PostCreateIcon = PostCreateAura

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

	end

end

-----------------------------------------------------------------------
--      Cast Bars
-----------------------------------------------------------------------
    if (castbars == true) then
        self.Castbar = CreateFrame('StatusBar', nil, self)
        self.Castbar:SetFrameLevel(3)
        self.Castbar:SetStatusBarTexture(texture) 
        self.Castbar:SetStatusBarColor(.1, .4, .7)
        
		self.castbarpp = self.Castbar:CreateFontString(nil, 'OVERLAY')
		self.castbarpp:SetFont(font, fontsize, "OUTLINE")
		self.castbarpp:SetJustifyH("LEFT")
		self.castbarpp:SetShadowOffset(2,-2)
		self.castbarpp:SetPoint("CENTER", self, "CENTER", 0,0)
		self.castbarpp:SetText(UnitPower(unit))
		
		self.Castbar:RegisterEvent("UNIT_MANA")
		self.Castbar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		self.Castbar:RegisterEvent("UNIT_HEALTH")
		self.Castbar:SetScript("OnEvent", function()
			local minp, maxp = UnitPower(unit, 0), UnitPowerMax(unit, 0)
			if unit == 'player' then
				if minp ~=maxp then		
					self.castbarpp:SetText(format('%s | |cff5F9BFF%s%%|r' ,minp ,floor(minp / maxp * 100)))
				else
					self.castbarpp:SetText(format('|cff5F9BFF%s|r', minp))
				end
			elseif unit == 'target' then
				local minh, maxh = UnitHealth(unit), UnitHealthMax(unit)
				if UnitPower(unit) > 0 then
					self.castbarpp:SetText(format('%d%% | |cff5F9BFF%d%%|r' ,floor(minh / maxh * 100), floor(minp / maxp * 100)))
				else
					self.castbarpp:SetText(format('%d%%' ,floor(minh / maxh * 100)))
				end
			end
		end)
		
        Backdrop(self.Castbar)
        cbbg = self.Castbar:CreateTexture(nil, 'BORDER')
        cbbg:SetAllPoints(self.Castbar)
        cbbg:SetTexture(texture)
        cbbg:SetVertexColor(0.16,0.16,0.16,1)
        
        self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Text:SetFont(font, fontsize, "OUTLINE")
        
        self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY')
        self.Castbar.Time:SetFont(font, fontsize, "OUTLINE")

        self.Castbar.Icon = self.Castbar:CreateTexture(nil, "ARTWORK")
        self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	    self.Castbar.Icon:SetDrawLayer('ARTWORK')
        
        cbBorder = CreateFrame("Frame", nil)
        cbBorder:SetParent(self.Castbar)
        cbBorder:SetFrameLevel(0)
        cbBorder:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT")
        cbBorder:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT")
        Backdrop(cbBorder)
		
        self.Castbar:SetHeight(cbheight)
		self.Castbar.PostCastStart = CheckCast
		self.Castbar.PostChannelStart = CheckChannel
        
        if unit=='pet' then
            self.Castbar:SetWidth(C["unitframe"].petwidth)
            self.Castbar:SetPoint('CENTER', oUF.units.pet, 'CENTER', 0, 17)
            self.Castbar.Text:SetPoint('LEFT', self.Castbar, 0, 15)
            self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -2, 15)
        elseif unit=='focus' then
            self.Castbar.Icon:SetHeight(50)
            self.Castbar.Icon:SetWidth(50)
            self.Castbar.Icon:SetPoint("Center", 0, -36)
            self.Castbar:SetWidth(300)
            self.Castbar:SetHeight(10)
            self.Castbar:SetPoint('CENTER', UIParent, 0, 200) 
            self.Castbar.Text:SetPoint('Left', self.Castbar, 0, 16)
            self.Castbar.Time:SetPoint('Right', self.Castbar, -2, 16)
        elseif unit=='target' then
            self.Castbar:SetWidth(hpwidth)
            self.Castbar:SetPoint('BOTTOM', pp, 'TOP', 0, 2)
            
            self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar, "TOPRIGHT", 6, -2)
            self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", (hpheight+ppheight+cbheight+6), 2)
            
            self.Castbar.Text:SetPoint("RIGHT", self, "RIGHT", -2, 0)  
            self.Castbar.Time:SetPoint('LEFT', self, "LEFT", 2, 0)
        elseif unit=='player' then
            self.Castbar:SetWidth(hpwidth)
            self.Castbar:SetPoint('BOTTOMRIGHT', pp, 'TOPRIGHT', 0, 2)
              
            self.Castbar.Icon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -(hpheight+ppheight+cbheight+6), 2)
            self.Castbar.Icon:SetPoint("TOPRIGHT", self.Castbar, "TOPLEFT", -6, -2)
            
            self.Castbar.Text:SetPoint("LEFT", self, "LEFT", 2, 0)
            self.Castbar.Time:SetPoint('RIGHT', self, "RIGHT", -2, 0)
            
            self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,"ARTWORK")
            self.Castbar.SafeZone:SetTexture(texture)
            self.Castbar.SafeZone:SetVertexColor(0.85,0.10,0.10,0.20)
            self.Castbar.SafeZone:SetPoint("TOPRIGHT")
            self.Castbar.SafeZone:SetPoint("BOTTOMRIGHT")	
        end
    end
--[[ combo points ]]--
local localized, class = UnitClass('player')    
    if unit=='target' and C["unitframe"].cpoint == true then
        if class == 'ROGUE' or class == 'DRUID' then
        self.CPoints = {}
            for i = 1, MAX_COMBO_POINTS do
                self.CPoints[i] = CreateFrame('StatusBar', nil, self)
                self.CPoints[i]:SetFrameStrata("HIGH")
                self.CPoints[i]:SetStatusBarTexture(texture)
                self.CPoints[i]:SetStatusBarColor(1, 0.8, 0)
                self.CPoints[i]:SetHeight(2)
                self.CPoints[i]:SetWidth((hpwidth / MAX_COMBO_POINTS)-2)
                Backdrop(self.CPoints[i])
            if (i == 1) then
                self.CPoints[i]:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 1, 18)
            else
                self.CPoints[i]:SetPoint('LEFT', self.CPoints[i-1], 'RIGHT', 2, 0)
            end
		end
    end
end
if class == 'DEATHKNIGHT' and unit == 'player' and C["unitframe"].cpoint == true then
	self.Runes = CreateFrame('Frame', nil, self)
	for i = 1, 6 do
		self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
        self.Runes[i]:SetFrameStrata("HIGH")
        self.Runes[i]:SetStatusBarTexture(texture)
		self.Runes[i]:SetWidth((hpwidth / 6)-2)
		self.Runes[i]:SetHeight(2)
		self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
		self.Runes[i].bg:SetAllPoints(self.Runes[i])				
		self.Runes[i].bg:SetTexture(0.3, 0.3, 0.3)
        Backdrop(self.Runes[i])	
		if (i == 1) then
			self.Runes[i]:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 1, 18)
		else
			self.Runes[i]:SetPoint("LEFT", self.Runes[i-1], "RIGHT", 2, 0)
		end														
	end
end
if class == "SHAMAN" and unit == 'player' and C["unitframe"].cpoint == true then
	self.TotemBar = CreateFrame('Frame', nil, self)
	for i = 1, 4 do
		self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
		self.TotemBar[i]:SetHeight(2)
		self.TotemBar[i]:SetWidth(hpwidth/4 -1)
			
		if (i == 1) then
			self.TotemBar[i]:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 1, 18)
		else
			self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 1, 0)
		end
		self.TotemBar[i]:SetStatusBarTexture(TEXTURE)
		self.TotemBar[i]:SetBackdrop(BACKDROP)
		self.TotemBar[i]:SetBackdropColor(0, 0, 0)
		self.TotemBar[i]:SetMinMaxValues(0, 1)
		self.TotemBar[i].destroy = true
					
		self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
		self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
		self.TotemBar[i].bg:SetTexture(TEXTURE)
		self.TotemBar[i].bg.multiplier = 0.25

	end
end
--[[
if(class == "WARLOCK" and unit == 'player') then
    local color = self.colors.power["SOUL_SHARDS"]
	self.SoulShards = CreateFrame("Frame", nil, self)
	for i = 1, 3 do
		self.SoulShards[i] = CreateFrame("StatusBar", self:GetName().."_Shards"..i, self)
        self.SoulShards[i]:SetFrameStrata("HIGH")
		self.SoulShards[i]:SetHeight(2)
		self.SoulShards[i]:SetWidth((hpwidth/3)-2)
		self.SoulShards[i]:SetStatusBarTexture(texture)
        self.SoulShards[i]:SetStatusBarColor(color[1], color[2], color[3])	
		Backdrop(self.SoulShards[i])
		if (i == 1) then
			self.SoulShards[i]:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 1, 18)
		else                                                     
			self.SoulShards[i]:SetPoint('LEFT', self.SoulShards[i-1], "RIGHT", 2, 0)
		end	
	end
end
if(class == "PALADIN" and unit == 'player') then
	self.HolyPower = CreateFrame("Frame", nil, self)
	for i = 1, 3 do
		self.HolyPower[i] = CreateFrame("StatusBar", self:GetName().."_HolyPower"..i, self)
        self.HolyPower[i]:SetFrameStrata("HIGH")
		self.HolyPower[i]:SetHeight(2)
		self.HolyPower[i]:SetWidth((hpwidth/3)-2)
		self.HolyPower[i]:SetStatusBarTexture(texture)
        self.HolyPower[i]:SetStatusBarColor(1, 0.8, 0)
		Backdrop(self.HolyPower[i])
		if (i == 1) then
			self.HolyPower[i]:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 1, 18)
		else                                                     
			self.HolyPower[i]:SetPoint('LEFT', self.HolyPower[i-1], "RIGHT", 2, 0)
		end	
	end
end
]]--

-----------------------------------------------------------------------
--      Frame Settings
-----------------------------------------------------------------------
    if unit=='player' or unit=='target' then
        curhealth:SetPoint("BOTTOM", self, "TOP", 0, 4+ppheight)
        if unit == 'target' then
            curpower:SetPoint('BOTTOMLEFT', self, "TOPLEFT", 2, 4+ppheight)
            unitnames:SetPoint('BOTTOMRIGHT', self, "TOPRIGHT", -2, 4+ppheight)
			self.Buffs.PostUpdateIcon = PostUpdateIcon
			self.Debuffs.PostUpdateIcon = PostUpdateIcon
        elseif unit=='player' then
            self.Buffs:Hide()
			self.Debuffs:Hide()
            curpower:SetPoint('BOTTOMRIGHT', self, "TOPRIGHT", -2, 4+ppheight)
            unitnames:SetPoint('BOTTOMLEFT', self, "TOPLEFT", 2, 4+ppheight)
        end
    end

	if unit=='focus' or unit=='targettarget' or unit=='pet' or unit:find("boss%d") then
        curhealth:Hide()
		curpower:Hide()
        self.Buffs:Hide()
        self.Debuffs:Hide()
        if unit=='targettarget' then
            self.Power:Hide()
            unitnames:SetPoint("BOTTOM", self, "TOP", 0, 4)
			self.Debuffs:Show()
        elseif unit =='pet' then
            self.Power:Hide()
            unitnames:SetPoint("TOP", self, "BOTTOM", 0, -4)
        elseif unit=='focus' then
            self.Debuffs:Show()
            --unitnames:SetPoint('Center', self, 0, -shpheight-3)
			unitnames:SetPoint('BOTTOM', self, "TOP", -C["unitframe"].focusheight-3)
		else
			self.Power:Hide()
            unitnames:SetPoint("TOP", self, "BOTTOM", 0, -4)
        end
    end
end

oUF:RegisterStyle('LjxxB_', layout)
local Player = oUF:Spawn("player")
Player:SetPoint("BOTTOM",UIPrent,"BOTTOM", playerx, playery)
Player:SetHeight(hpheight)
Player:SetWidth(hpwidth)

local Target = oUF:Spawn("target")
Target:SetPoint("BOTTOM", targetx, targety)
Target:SetHeight(hpheight)
Target:SetWidth(hpwidth)

local ToT = oUF:Spawn("targettarget")
ToT:SetPoint("BOTTOM", totx, toty)
ToT:SetHeight(C["unitframe"].totheight/2)
ToT:SetWidth(C["unitframe"].totwidth)

local Focus = oUF:Spawn("focus")
Focus:SetPoint("LEFT", focusx, focusy)
Focus:SetHeight(C["unitframe"].focusheight)
Focus:SetWidth(C["unitframe"].focuswidth)

local Pet = oUF:Spawn("pet")
Pet:SetPoint("BOTTOM", petx, pety)
Pet:SetHeight(C["unitframe"].petheight/2)
Pet:SetWidth(C["unitframe"].petwidth)

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