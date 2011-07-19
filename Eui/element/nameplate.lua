-- Would like to say thanks to the following authors for their inspiration
-- tekkub, cael, roth, and luzz 
-- SPECIAL thanks to caelian, I relied heavly on his code
local E, C, L = unpack(EUI)
if C["other"].nameplate ~= true then return end
local shNameplates = {}
local cfg = {}
local mediapath = [=[Interface\AddOns\Eui\media\]=]

--> TEXTURE options (add your own textures here)
	cfg.bartex = 	E.statusbar
	cfg.icontex = 	mediapath.."iconborder"

--> BEHAVIOR options
--	cfg.autohide = true 	--> automatically hide nameplates when OUT OF COMBAT only
--	cfg.autoshow = true		--> automatically show nameplates when IN COMBAT only
	cfg.overlap = 0			--> 0: nameplates overlap and 1: nameplates do NOT overlap
	cfg.threatbloat = 0		--> 0: keeps nameplates consistant size and 1: makes nameplates larger depending on threat percentage
	cfg.tankmode = C["other"].nameplatetank 	--> true: will show custom color overlay/statusbar if you HAVE aggro and false: will show RED overlay if you HAVE aggro
	cfg.namecolor = true	--> true: will show unit names in color of their hostility/pvp or false: will show static color given below
	
--> COLOR options (any RGB percent color of your choosing)
	cfg.colors = {
		hostile = 		{ 0.70, 0.34, 0.34 },	--> Default: red 
		friendlynpc =	{ 0.33, 0.59, 0.33 },	--> Default: green 
		friendly = 		{ 0.31, 0.45, 0.63 },	--> Default: blue 
		neutral = 		{ 0.65, 0.63, 0.35 }, 	--> Default: yellow 
		
	--> tankmode color options (ONLY APPLY if you have tankmode SET to TRUE)
		aggroglow = 	{ 0.15, 0.69, 0.0  }, 	--> If you have aggro, the glow around the nameplate (ONLY WORKS if TANKMODE = true)
		aggro =			{ 0.25, 0.64, 0.32 }, 	--> If you have aggro, the status bar color itself (ONLY WORKS if TANKMODE = true)
	}	
	
--> BACKDROP table for the statusbars (taken from Caelian and edited)
	cfg.backdrop = {
		bgFile   =  mediapath.."borderBackground",
		edgeFile = 	mediapath.."glowTex", 
		edgeSize = 	3,
		insets   = 	{ left = 1, right = 1, top = 1, bottom = 1 }, 
	}
	
--> RAIDICON
	cfg.raidicon = {
		textures = 	"Interface\\TargetingFrame\\UI-RaidTargetingIcons", 
		size = 23,					--> square dimension (in pixels)
		anchor = "BOTTOM",			--> anchor point of the raidicon to the health bar
		anchor2 = "TOP",			--> anchor point of the healthbar to the raidiconssss
		xoffset = 0,				--> x-offset of the anchor
		yoffset = 9,				--> y-offset of the anchor
	}
	
--> SPELLICON
	cfg.spellicon = {
		size = 		20,				--> square dimension (in pixels)
		anchor = 	"LEFT",			--> anchor point of the spell icon to cast bar
		anchor2 = 	"RIGHT",		--> anchor point of the cast bar to spell icon
		xoffset = 	10,				--> x-offset of the anchor
		yoffset =	8,				--> y-offset of the anchor
	}

--> HEALTHBAR 	
	cfg.healthbar = {
		showhpvalue = 	C["other"].nameplatevalue , 		--> show hp value text in healthbar if not at 100% health (always shows hp value for bosses)
		hpallthetime = 	false,		--> shows the hp value of the mob at all times
		width = 		140, 		--> healthbar bar width
		height = 		14,			--> healthbar bar height
		yoffset = 		8, 			--> y-offset of the nameplate itself from the default blizzard nameplate
	}
	
--> CASTBAR
	cfg.castbar = {
		width =		130,			--> castbar bar width
		height = 	10,				--> castbar bar height
		anchor = 	"TOP", 			--> anchor point of the castbar to the health bar
		anchor2 =	"BOTTOM", 		--> anchor point of the healthbar to the cast bar
		xoffset =	0, 				--> x-offset of the anchor 
		yoffset =	-4, 			--> y-offset of the anchor
	}
		
--> CASTTIME
	cfg.casttime = {
		--> Cast time options
		font = 		E.font, 		--> cast time font
		fontSize = 	9, 							--> cast time font size
		fontFlag =  "THINOUTLINE",					--> cast time font flag
		alpha = 	0.85,							--> alpha of cast time	
		anchor = 	"CENTER", 						--> anchor point of cast time to the castbar
		anchor2 =	"LEFT", 						--> anchor point of castbar to the cast time
		xoffset =	0, 								--> x-offset of the anchor 
		yoffset =	0, 								--> y-offset of the anchor
	}	
	
--> SPELL NAME text attributes
	cfg.spellname = {
		font =		E.font,		--> spell name font
		fontSize =	9,								--> spell name font size
		fontFlag = 	"THINOUTLINE",					--> spell name font flag
		color = 	{ 1, 1, 1 },					--> spell name color
		anchor = 	"CENTER", 						--> anchor point of the spell name text to the cast bar
		anchor2 =	"CENTER",						--> anchor point of the cast bar to the spell name text
		xoffset =	0, 								--> x-offset of the anchor 
		yoffset =	0.5, 							--> y-offset of the anchor
	}
	
--> NAME text attributes
	cfg.name = {
		font = 		E.font, 
		fontSize = 	11,	
		fontFlag =  "THINOUTLINE",
		color = 	{ 0.9, 0.8, 0.7 },	
		alpha = 	1,
		uppercase = true,			--> change to false to format in all lower cases
		anchor = 	"BOTTOM", 		--> anchor point of the name text to the health bar
		anchor2 =	"TOP",			--> anchor point of the healtbar to the name text
		xoffset =	3, 				--> x-offset of the anchor 
		yoffset =	0, 				--> y-offset of the anchor
	}
	
--> LEVEL text attributes
	cfg.level = {
		font = 		E.font, 
		fontSize = 	11,
		fontFlag = 	"OUTLINE",
		alpha = 	0.9,
		anchor = 	"RIGHT", 		--> anchor point of the level text to the name text
		anchor2 =	"LEFT", 		--> anchor point of the healthbar to the level text
		xoffset =	-1, 			--> x-offset of the anchor 
		yoffset =	0, 				--> y-offset of the anchor
	}
		
--> HEALTH text attributes
	cfg.health = {
		font = 		E.font, 
		fontSize = 	11,
		fontFlag = 	"THINOUTLINE", 
		color = 	{ 1, 1, 1 }, 
		alpha = 	1, 
		anchor = 	"CENTER", 		--> anchor point of the health text to the health bar 
		anchor2 = 	"CENTER", 		--> anchor point of the health bar to the health text
		xoffset =	0, 				--> x-offset of the anchor 
		yoffset =	0, 				--> y-offset of the anchor
	}

local type = type
shNameplates.eventFrame = CreateFrame("Frame", nil, UIParent)
shNameplates.eventFrame:SetScript("OnEvent", function(self, event, ...)
	if type(self[event] == "function") then
		return self[event](self, event, ...)
	end
end)


-->failsafe
if cfg.healthbar.showhpvalue == false and cfg.healthbar.hpallthetime == true then
	DEFAULT_CHAT_FRAME:AddMessage("|cff649DDFshNameplates:|r |cffFF0000ERROR|r with config settings.  hpallthetime cannot be true if showhpvalue is false!  Values reset to false.")
	cfg.healthbar.showhpvalue = false
	cfg.healthbar.hpallthetime = false
end

-->CVar settings to the way I like it (old school)
local SetCVar = SetCVar
SetCVar("bloattest", 0) -- 1 might make nameplates larger but it fixes the disappearing ones.
SetCVar("bloatnameplates", cfg.threatbloat) -- 1 makes nameplates larger depending on threat percentage.
SetCVar("bloatthreat", 0) -- 1 makes nameplates resize depending on threat gain/loss. Only active when a mob has multiple units on its threat table.

--> Frame behavior and autotoggle
if C["other"].nameplateauto == true then
	shNameplates.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	function shNameplates.eventFrame:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	shNameplates.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	function shNameplates.eventFrame:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

--> Are you local?
local floor, modf, len, lower, gsub, select, upper, sub, find = math.floor, math.modf, string.len, string.lower, string.gsub, select, string.upper, string.sub, string.find
local unpack, UnitIsPVP, UnitIsEnemy = unpack, UnitIsPVP, UnitIsEnemy

---------------------------
--------FUNCTIONS----------
---------------------------
local overlayRegion = overlayRegion
local function IsValidFrame(frame)
	if frame:GetName() and not find(frame:GetName(), "^NamePlate") then -->thank you Csalago!
		return false
	end
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == [=[Interface\Tooltips\Nameplate-Border]=] 
end

local tonumber = tonumber
local format = format
local function round(num, idp)
	return tonumber(format("%." .. (idp or 0) .. "f", num))
end

local UnitName = UnitName
local function IsTarget(self) 
	local tname = UnitName("target")
	if tname == self.name:GetText() then
		return true
	else
		return false
	end
end

local function formatNumber(number)
	if number >= 1e6 then
		return round(number/1e6, 1).."|cffEEEE00m|r"
	elseif number >= 1e3 then
		return round(number/1e3, 1).."|cffEEEE00k|r"
	else
		return number
	end
end

local function nameColoring(self, checker)
	if checker then
		if UnitIsPVP("target") and UnitIsEnemy("target", "player") then
			return self.healthBar:GetStatusBarColor()
		end
	end
	return unpack(cfg.name.color)
end

-->TEKKUB's color gradient function of awesomeness
local function ColorGradient(perc, r1, g1, b1, r2, g2, b2, r3, g3, b3)
	if perc >= 1 then return r3, g3, b3 elseif perc <= 0 then return r1, g1, b1 end
	local segment, relperc = modf(perc*2)
	if segment == 1 then r1, g1, b1, r2, g2, b2 = r2, g2, b2, r3, g3, b3 end
	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

--------------------------
--- SHOW HEALTH UPDATE ---
--------------------------
local function showHealth(self)
	local min, max = self.healthBar:GetMinMaxValues()
	local currentValue = self.healthBar:GetValue()
	local p = (currentValue/max)*100	
	local r, g, b = unpack(cfg.name.color)
	self.name:SetTextColor(nameColoring(self, cfg.namecolor))
	
	if cfg.healthbar.showhpvalue then		
		local r, g, b = ColorGradient(currentValue/max, 1,0,0, 1,1,0, 0,1,0)				
		self.hp:SetTextColor(r, g, b)
		if cfg.healthbar.hpallthetime and p >= 100 then
			--self.hp:SetTextColor(r, g, b)
			if p == 100 then self.hp:SetFormattedText("|cffFFFFFF%s|r |cffffffff:|r %.0f%%", formatNumber(currentValue), p)
			else self.hp:SetFormattedText("|cffFFFFFF%s|r |cffffffff:|r %.1f%%", formatNumber(currentValue), p) end			
			self.hp:SetAlpha(cfg.health.alpha)
			self.name:SetAlpha(1)
			self.healthBar.hpGlow:SetAlpha(1)
		elseif p < 100 then
			self.hp:SetFormattedText("|cffFFFFFF%s|r |cffffffff:|r %.1f%%", formatNumber(currentValue), p)
			--self.hp:SetTextColor(r, g, b)
			self.hp:SetAlpha(cfg.health.alpha)
		else
			self.hp:SetText(" ")
		end
	end	
	
--> for mouse hover display options
	if self.highlight:IsShown() then 
		self.name:SetTextColor(1, 1, 0)
		self.name:SetAlpha(1)
		
		if cfg.healthbar.hpallthetime == false and max == currentValue then
			self.hp:SetTextColor(r, g, b)
			self.hp:SetText(formatNumber(max))
		end
		
		if max ~= currentValue then
			self.hp:SetTextColor(r, g, b)
			self.hp:SetFormattedText("%s / %s", formatNumber(currentValue), formatNumber(max))		
		end
	elseif cfg.healthbar.showhpvalue == false then
		self.hp:SetText(" ")
	end
end

local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo
local function UpdateTime(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	local castname = UnitCastingInfo("target") or UnitChannelInfo("target")
	if self.channeling then
		self.time:SetFormattedText("%.1fs", curValue)
	else
		self.time:SetFormattedText("%.1fs", maxValue - curValue)
	end	
	self.cname:SetText(castname)
end

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	
	if self.elapsed >= 0.2 then
	
		  showHealth(self)--> added show health text into this function b/c of update'abiity
				
		if not self.oldglow:IsShown() then
			self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
			if IsTarget(self) then
				self.healthBar.hpGlow:SetBackdropBorderColor(0.85, 0.85, 0.85)  
				self.healthBar.hpGlow:SetAlpha(0.8)				
			else
				self.healthBar.hpGlow:SetBackdropBorderColor(0.65, 0.65, 0.65)  
				self.healthBar.hpGlow:SetAlpha(0.6)
			end
		else			
			local r, g, b = self.oldglow:GetVertexColor()
			if b + g == 0 then 
				if cfg.tankmode then 
					self.healthBar.hpGlow:SetBackdropBorderColor(unpack(cfg.colors.aggroglow)) --> green glow: highest on threat
					self.healthBar:SetStatusBarColor(unpack(cfg.colors.aggro)) --> green statusbar color
					self.healthBar.hpGlow:SetAlpha(0.9)
				else  
					self.healthBar.hpGlow:SetBackdropBorderColor(0.93, 0.11, 0.11)
					self.healthBar.hpGlow:SetAlpha(0.9)
					self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
				end		
			else --> high on threat
				self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
				self.healthBar.hpGlow:SetBackdropBorderColor(0.93, 0.93, 0.11)
				self.healthBar.hpGlow:SetAlpha(0.9)
			end			
		end	
		
		self.elapsed = 0
	end
end

--------------------
--- UPDATE PLATE ---
--------------------
local UnitLevel = UnitLevel
local function UpdatePlate(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		newr, newg, newb = unpack(cfg.colors.hostile) 
		self.healthBar:SetStatusBarColor(newr, newg, newb)
	elseif r + b == 0 then
		-- Friendly unit
		newr, newg, newb = unpack(cfg.colors.friendlynpc) 
		self.healthBar:SetStatusBarColor(newr, newg, newb) 
	elseif r + g == 0 then
		-- Friendly player
		newr, newg, newb = unpack(cfg.colors.friendly) 
		self.healthBar:SetStatusBarColor(newr, newg, newb)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		newr, newg, newb = unpack(cfg.colors.neutral)
		self.healthBar:SetStatusBarColor(newr, newg, newb)
	else
		-- Hostile player - class colored.
		newr, newg, newb = r, g, b
	end

	self.r, self.g, self.b = newr, newg, newb
	
	if self.castBar:IsShown() then self.castBar:Hide() end
	
	showHealth(self)
	
	self.fade:SetChange(self:GetAlpha())
	self:SetAlpha(0)
	self.ag:Play()
	
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent(), 0, cfg.healthbar.yoffset)
	self.healthBar:SetHeight(cfg.healthbar.height)
	self.healthBar:SetWidth(cfg.healthbar.width)
	
	self.healthBar.hpBackground:SetVertexColor(self.r * 0.25, self.g * 0.25, self.b * 0.25)
	self.healthBar.hpBackground:SetAlpha(0.75)
	self.castBar.IconOverlay:SetVertexColor(self.r, self.g, self.b)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("CENTER", self.healthBar, "TOP", 0, 2)
	self.castBar:SetHeight(cfg.castbar.height)
	self.castBar:SetWidth(cfg.castbar.width)
			
	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)
	
	local oldName = self.oldname:GetText()
	local newName = (len(oldName) > 20) and gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName -->fixes really long names
	
	if not cfg.name.uppercase then 
		self.name:SetText(lower(newName)) 
	else 
		self.name:SetText(newName) 
	end
		
	local level, elite, rare, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint(cfg.level.anchor, self.name, cfg.level.anchor2, cfg.level.xoffset, cfg.level.yoffset) 
	if self.boss:IsShown() then
		self.level:SetText("??B")
		self.level:SetTextColor(1, 0, 0)
		self.level:Show()
	elseif self.elite:IsVisible() and not self.elite:GetTexture() == "Interface\\Tooltips\\EliteNameplateIcon" then
		self.level:SetText("(r)"..level)
	else
		self.level:SetText((elite and "+" or "")..level)
	end	
end

local function FixCastbar(self)
	self.castbarOverlay:Hide()	
	self:SetHeight(cfg.castbar.height)
	self:ClearAllPoints()
	self:SetPoint(cfg.castbar.anchor, self.healthBar, cfg.castbar.anchor2, cfg.castbar.xoffset, cfg.castbar.yoffset)	
end

-->check to see if can't be interrupted
local function ColorCastBar(self, shielded)		
	self:SetStatusBarTexture(cfg.bartex)
	if shielded then
		self:SetStatusBarColor(0.82, 0.22, 0.18)
		self:SetStatusBarTexture([=[Interface\AddOns\shNameplates\media\diag]=])
		self.cbGlow:SetBackdropBorderColor(0.82, 0.22, 0.18) --> RED for NON INTERRUPTABLE	
		self.cbGlow:SetAlpha(0.75)
	else
		self:SetStatusBarColor(0.84, 0.63, 0.14)
		self.cbGlow:SetAlpha(0.25)
	end
end

local function OnSizeChanged(self)
	self.needFix = true
end

local function OnValueChanged(self, curValue)
	UpdateTime(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local function OnShow(self)
	FixCastbar(self)		
	self.channeling  = UnitChannelInfo("target")
	self.IconOverlay:Show()	
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local function OnHide(self)
	self.highlight:Hide()
	self.healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)
end

local function OnEvent(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

--------------------
--- CREATE PLATE ---
--------------------
local CreatePlate = function(frame)
	if frame.done then
		return
	end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	local _, castbarOverlay, shieldedRegion, spellIconRegion= castBar:GetRegions()
	
	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
	
	frame.oldname = nameTextRegion
	nameTextRegion:Hide()
	
	local newNameRegion = frame:CreateFontString(nil, 'OVERLAY')
	newNameRegion:SetParent(healthBar)
	newNameRegion:SetPoint(cfg.name.anchor, healthBar, cfg.name.anchor2, cfg.name.xoffset, cfg.name.yoffset)
	newNameRegion:SetFont(cfg.name.font, cfg.name.fontSize, cfg.name.fontFlag) 
	newNameRegion:SetAlpha(cfg.name.alpha)
	newNameRegion:SetShadowColor(0, 0, 0, 1)
	newNameRegion:SetShadowOffset(0, 0)
	frame.name = newNameRegion
	
	local hpRegion = frame:CreateFontString()
	hpRegion:SetPoint(cfg.health.anchor, healthBar, cfg.health.anchor2, cfg.health.xoffset, cfg.health.yoffset)
	hpRegion:SetFont(cfg.health.font, cfg.health.fontSize, cfg.health.fontFlag)
	frame.hp = hpRegion
	
	frame.level = levelTextRegion
	levelTextRegion:SetFont(cfg.level.font, cfg.level.fontSize, cfg.level.fontFlag)
	levelTextRegion:SetShadowColor(0, 0, 0, 1)
	levelTextRegion:SetShadowOffset(0, 0)
	levelTextRegion:SetAlpha(cfg.level.alpha)

	healthBar:SetStatusBarTexture(cfg.bartex)
	
	healthBar.hpBackground = healthBar:CreateTexture(nil, "BACKGROUND")
	healthBar.hpBackground:SetAllPoints()
	healthBar.hpBackground:SetTexture(cfg.bartex)
			
	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -3, 3) 
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 3, -3)
	healthBar.hpGlow:SetBackdrop(cfg.backdrop)
	healthBar.hpGlow:SetAlpha(0.5)
	healthBar.hpGlow:SetBackdropColor(0, 0, 0, 0)
	healthBar.hpGlow:SetBackdropBorderColor(0, 0, 0)
		
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	--castBar:SetStatusBarTexture(cfg.bartex)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetPoint(cfg.casttime.anchor, castBar, cfg.casttime.anchor2, cfg.casttime.xoffset, cfg.casttime.yoffset)
	castBar.time:SetFont(cfg.casttime.font, cfg.casttime.fontSize, cfg.casttime.fontFlag)
	castBar.time:SetTextColor(1, 1, 1)
	
	-->added for cast name
	castBar.cname = castBar:CreateFontString(nil, "ARTWORK")
	castBar.cname:SetPoint(cfg.spellname.anchor, castBar, cfg.spellname.anchor2, cfg.spellname.xoffset, cfg.spellname.yoffset)
	castBar.cname:SetFont(cfg.spellname.font, cfg.spellname.fontSize, cfg.spellname.fontFlag)
	castBar.cname:SetTextColor(unpack(cfg.spellname.color))
	--castBar.cname:SetShadowColor(0.25, 0.25, .25)
	--castBar.cname:SetShadowOffset(-0.6, 0.6)

	castBar.cbBackground = castBar:CreateTexture(nil, "BACKGROUND")
	castBar.cbBackground:SetAllPoints()
	castBar.cbBackground:SetTexture(cfg.bartex)
	castBar.cbBackground:SetVertexColor(0.2, 0.2, 0.2, 0.75)

	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, -2.5, 2.5)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, 2.5, -2.5)
	castBar.cbGlow:SetBackdrop(cfg.backdrop)
	castBar.cbGlow:SetAlpha(0.5)
	castBar.cbGlow:SetBackdropColor(0, 0, 0, 0)
	castBar.cbGlow:SetBackdropBorderColor(0, 0, 0)

	castBar.HolderA = CreateFrame("Frame", nil, castBar)
	castBar.HolderA:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 1)
	castBar.HolderA:SetAllPoints()

	castBar.spellicon = spellIconRegion
	castBar.spellicon:ClearAllPoints()
	castBar.spellicon:SetParent(castBar)
	castBar.spellicon:SetPoint(cfg.spellicon.anchor, castBar, cfg.spellicon.anchor2, cfg.spellicon.xoffset, cfg.spellicon.yoffset)
	castBar.spellicon:SetSize(cfg.spellicon.size, cfg.spellicon.size)
	
	castBar.HolderB = CreateFrame("Frame", nil, castBar)
	castBar.HolderB:SetFrameLevel(castBar.HolderA:GetFrameLevel() + 2)
	castBar.HolderB:SetAllPoints()

	castBar.IconOverlay = castBar.HolderB:CreateTexture(nil, "OVERLAY")
	castBar.IconOverlay:SetPoint("TOPLEFT", spellIconRegion, -1.5, 1.5)
	castBar.IconOverlay:SetPoint("BOTTOMRIGHT", spellIconRegion, 1.5, -1.5)
	castBar.IconOverlay:SetTexture(cfg.icontex)

	highlightRegion:SetTexture(cfg.bartex)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25, 0.8)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint(cfg.raidicon.anchor, healthBar, cfg.raidicon.anchor2, cfg.raidicon.xoffset, cfg.raidicon.yoffset)
	raidIconRegion:SetSize(cfg.raidicon.size, cfg.raidicon.size)
	raidIconRegion:SetTexture(cfg.raidicon.textures)	

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion
		
	-- animations for initial fade in
	frame.ag	= frame:CreateAnimationGroup()
	frame.fade	= frame.ag:CreateAnimation('Alpha')
	
	frame.fade:SetSmoothing("OUT")
	frame.fade:SetDuration(1)
	frame.fade:SetChange(1)
	
	frame.ag:SetScript('OnFinished', function()
		frame:SetAlpha(frame.fade:GetChange())
		-- otherwise it flashes
	end)
		
	frame:SetScript("OnShow", UpdatePlate)
	frame:SetScript("OnHide", OnHide)
	frame:SetScript("OnUpdate", ThreatUpdate)
	
	frame.done = true
	frame.elapsed = 0

	UpdatePlate(frame)
end

local numKids, lastupdate, i = 0, 0, 0
local WorldFrame, frame = WorldFrame, frame
shNameplates.eventFrame:SetScript("OnUpdate", function(self, elapsed)
	lastupdate = lastupdate + elapsed
	
	if lastupdate > 0.1 then
			
		local newNumKids = WorldFrame:GetNumChildren()--select("#", WorldFrame:GetChildren())
				
		if numKids ~= newNumKids then		
			for i = numKids + 1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())
				
				if IsValidFrame(frame) then
					CreatePlate(frame)
				end
			end	
			numKids = newNumKids			
		end	
		
		lastupdate = 0
	end
end)













