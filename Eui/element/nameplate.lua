--Credits to Dawn and Darth Android for some key pieces / referance
local E, C = unpack(select(2, ...))
if C["other"].nameplate ~= true then return end
local showhealth = C["other"].nameplatevalue -- Display health on nameplates, disabling this will make the nameplate thinner automatically
local overlap = false	-- Allow nameplates to overlap each other
local enhancethreat = true --[[ Color health by color, good color is nonthreat mobs if your a dps/healer, good color is threat mobs if your a tank. 
If this is false, the border will change red with threat, yellow with high/losing threat, gray otherwise]]
local classicons = true --Display class icons above class nameplates

local TEXTURE = [=[Interface\AddOns\Eui\media\nameTex.tga]=]
local FONT = STANDARD_TEXT_FONT
local blankTex = [=[Interface\AddOns\eNameplates\media\textures\blank.tga]=]
local Role = "Caster" --Melee,Caster,Tank
local FONTSIZE = 11
local FONTFLAG = "THINOUTLINE"
local hpHeight = 12
local hpWidth = 110
local iconSize = 25	--Size of all Icons, RaidIcon/ClassIcon/Castbar Icon
local cbHeight = 5
local cbWidth = 110
local goodcolor = {75/255,  175/255, 76/255}
local badcolor = {0.78, 0.25, 0.25}
local transitioncolor = {218/255, 197/255, 92/255} --High Threat, Losing Threat color
local hostilecolor = {0.78, 0.25, 0.25}
local friendlyplayercolor = {75/255,  175/255, 76/255}
local neutralcolor = {218/255, 197/255, 92/255}
local friendlynpccolor = {0.31, 0.45, 0.63}


-- Nameplate Filter, Add the Nameplates name exactly here that you do NOT want to see
PlateBlacklist = {
	--Shaman Totems
	["Earth Elemental Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Resistance Totem"] = true,
	["Flametongue Totem"] = true,
	["Frost Resistance Totem"] = true,
	["Healing Stream Totem"] = true,
	["Magma Totem"] = true,
	["Mana Spring Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Searing Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneskin Totem"] = true,
	["Strength of Earth Totem"] = true,
	["Windfury Totem"] = true,
	["Totem of Wrath"] = true,
	["Wrath of Air Totem"] = true,
	["Spirit Link Totem"] = true,

	--Army of the Dead
	["Army of the Dead Ghoul"] = true,

	--Hunter Trap
	["Venomous Snake"] = true,
	["Viper"] = true,

	--Test
	--["Unbound Seer"] = true,
}

--Dont Touch
local pairs = pairs

local numChildren = -1
local frames = {}
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/UIParent:GetScale()
local noscalemult = mult * UIParent:GetScale()
local dummy = function() end
local myclass = select(2, UnitClass("player"))

--Change defaults if we are showing health text or not
if showhealth ~= true then
	hpHeight = 7
	iconSize = 20
end

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
SetCVar("ShowClassColorInNameplate",1)
SetCVar("showVKeyCastbar",1)
if overlap == true then
	SetNamePlateMotionType(1)
else
	SetNamePlateMotionType(3)  -- 1=overlapping, 2=stacking, 3=spreading
end

--[[ --Check Player's Role
local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	if GetCombatRating(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)*0.02828 > GetDodgeChance() then
		resilience = true
	else
		resilience = false
	end
	
	if ((myclass == "PALADIN" and tree == 2) or 
	(myclass == "WARRIOR" and tree == 3) or 
	(myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or myclass == "ROGUE" or myclass == "HUNTER" or (myclass == "SHAMAN" and tree == 2) then
			Role = "Melee"
		else
			Role = "Caster"
		end
	end
end	
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole() ]]

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
			object.SetTexture = dummy
		elseif (object:GetObjectType() == 'FontString') then
			object.ClearAllPoints = dummy
			object.SetFont = dummy
			object.SetPoint = dummy
			object:Hide()
			object.Show = dummy
			object.SetText = dummy
			object.SetShadowOffset = dummy
		else
			object:Hide()
			object.Show = dummy
		end
	end
end

local function CheckBlacklist(frame) --, ...)
	if PlateBlacklist[frame.name:GetText()] or (UnitLevel("player") ~= 1 and frame.oldlevel:GetText() == '1') then
		frame:SetScript("OnUpdate", nil) --function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.oldlevel:Hide()
	end
end

local function HideDrunkenText(frame) --, ...)
	if frame and frame.oldlevel and frame.oldlevel:IsShown() then
		frame.oldlevel:Hide()
	end
end

local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame:IsShown() then
			functionToRun(frame, ...)
		end
	end
end

local goodR, goodG, goodB = unpack(goodcolor)
local badR, badG, badB = unpack(badcolor)
local transitionR, transitionG, transitionB = unpack(transitioncolor)
local function UpdateThreat(frame, elapsed)
	-- elapsed unusued because calling function already throttling for us
	frame.hp:Show()
	
	if not enhancethreat then
		if(frame.region:IsShown()) then
			local _, val = frame.region:GetVertexColor()
			if(val > 0.7) then
				frame.healthborder_tex1:SetTexture(transitionR, transitionG, transitionB)
				frame.healthborder_tex2:SetTexture(transitionR, transitionG, transitionB)
				frame.healthborder_tex3:SetTexture(transitionR, transitionG, transitionB)
				frame.healthborder_tex4:SetTexture(transitionR, transitionG, transitionB)
			else
				frame.healthborder_tex1:SetTexture(badR, badG, badB)
				frame.healthborder_tex2:SetTexture(badR, badG, badB)
				frame.healthborder_tex3:SetTexture(badR, badG, badB)
				frame.healthborder_tex4:SetTexture(badR, badG, badB)
			end
		else
			frame.healthborder_tex1:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex2:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex3:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex4:SetTexture(0.6, 0.6, 0.6)
		end
	else
		if not frame.region:IsShown() then
			if InCombatLockdown() and (not frame.hasclass) and (not frame.isFriendly) then
				--No Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.hpbg:SetTexture(badR, badG, badB, 0.25)
				else
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.25)
				end		
			else
				--Set colors to their original, not in combat
				frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
			end
		else
			--Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.region:GetVertexColor()
			if g + b == 0 then
				--Have Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.hpbg:SetTexture(goodR, goodG, goodB, 0.25)
				else
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.hpbg:SetTexture(badR, badG, badB, 0.25)
				end
			else
				--Losing/Gaining Threat
				frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)	
				frame.hp.hpbg:SetTexture(transitionR, transitionG, transitionB, 0.25)
			end
		end
	end
	
	-- show current health value
	local minHealth, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100
	
	if showhealth == true then
		frame.hp.value:SetText(ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth/maxHealth)*100))))
	end
		
	--Change frame style if the frame is our target or not
	if UnitName("target") == frame.name:GetText() and frame:GetAlpha() == 1 then
		--Targetted Unit
		frame.name:SetTextColor(1, 1, 0)
	else
		--Not Targetted
		frame.name:SetTextColor(1, 1, 1)
	end
	
	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasclass or frame.isFriendly then
		if(d <= 50 and d >= 20) then
			frame.healthborder_tex1:SetTexture(1, 1, 0)
			frame.healthborder_tex2:SetTexture(1, 1, 0)
			frame.healthborder_tex3:SetTexture(1, 1, 0)
			frame.healthborder_tex4:SetTexture(1, 1, 0)
		elseif(d < 20) then
			frame.healthborder_tex1:SetTexture(1, 0, 0)
			frame.healthborder_tex2:SetTexture(1, 0, 0)
			frame.healthborder_tex3:SetTexture(1, 0, 0)
			frame.healthborder_tex4:SetTexture(1, 0, 0)
		else
			frame.healthborder_tex1:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex2:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex3:SetTexture(0.6, 0.6, 0.6)
			frame.healthborder_tex4:SetTexture(0.6, 0.6, 0.6)
		end
	elseif (not frame.hasclass) and (not frame.isFriendly) and enhancethreat then
		frame.healthborder_tex1:SetTexture(0.6, 0.6, 0.6)
		frame.healthborder_tex2:SetTexture(0.6, 0.6, 0.6)
		frame.healthborder_tex3:SetTexture(0.6, 0.6, 0.6)
		frame.healthborder_tex4:SetTexture(0.6, 0.6, 0.6)
	end
end

local function Colorize(frame)
	local r,g,b = frame.hp:GetStatusBarColor()
	if frame.hasclass then frame.isFriendly = false return end
	
	if g+b == 0 then -- hostile
		r,g,b = unpack(hostilecolor)
		frame.isFriendly = false
	elseif r+b == 0 then -- friendly npc
		r,g,b = unpack(friendlynpccolor)
		frame.isFriendly = true
	elseif r+g > 1.95 then -- neutral
		r,g,b = unpack(neutralcolor)
		frame.isFriendly = false
	elseif r+g == 0 then -- friendly player
		r,g,b = unpack(friendlyplayercolor)
		frame.isFriendly = true
	else -- enemy player
		frame.isFriendly = false
	end
	frame.hp:SetStatusBarColor(r,g,b)
end

local function UpdateObjects(frame)
	local frame = frame:GetParent()
	
	local r, g, b = frame.hp:GetStatusBarColor()
	local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
	local classname
	
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(hpWidth, hpHeight)	
	frame.hp:SetPoint('TOP', frame, 'TOP', 0, -noscalemult*3)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	frame.healthbarbackdrop_tex:ClearAllPoints()
	frame.healthbarbackdrop_tex:SetPoint("TOPLEFT", frame.hp, "TOPLEFT", -noscalemult*3, noscalemult*3)
	frame.healthbarbackdrop_tex:SetPoint("BOTTOMRIGHT", frame.hp, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
		
	--Class Icons
	for class, color in pairs(E.RAID_CLASS_COLORS) do
		if E.RAID_CLASS_COLORS[class].r == r and E.RAID_CLASS_COLORS[class].g == g and E.RAID_CLASS_COLORS[class].b == b then
			classname = class
		end
	end
	if (classname) then
		texcoord = CLASS_BUTTONS[classname]
		if texcoord then
			frame.hasclass = true
		else
			texcoord = {0.5, 0.75, 0.5, 0.75}
			frame.hasclass = false
		end
	else
		texcoord = {0.5, 0.75, 0.5, 0.75}
		frame.hasclass = false
	end
	
	if frame.hp.rcolor == 0 and frame.hp.gcolor == 0 and frame.hp.bcolor ~= 0 then
		texcoord = {0.5, 0.75, 0.5, 0.75}
		frame.hasclass = true
	end
	frame.class:SetTexCoord(texcoord[1],texcoord[2],texcoord[3],texcoord[4])
	
	if not classicons then
		frame.class:SetAlpha(0)
	end
	
	--create variable for original colors
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	frame.hp.hpbg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.25)
	
	--Set the name text
	frame.name:SetText(frame.oldname:GetText())
	
	--Setup level text
	local level, elite, mylevel = tonumber(frame.oldlevel:GetText()), frame.elite:IsShown(), UnitLevel("player")
	frame.hp.level:ClearAllPoints()
	if showhealth then
		frame.hp.level:SetPoint("RIGHT", frame.hp, "RIGHT", 2, 0)
	else
		frame.hp.level:SetPoint("RIGHT", frame.hp, "LEFT", -1, 0)
	end
	
	frame.hp.level:SetTextColor(frame.oldlevel:GetTextColor())
	if frame.boss:IsShown() then
		frame.hp.level:SetText("B")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	elseif not elite and level == mylevel then
		frame.hp.level:Hide()
	else
		frame.hp.level:SetText(level..(elite and "+" or ""))
	end
	
	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)

	HideObjects(frame)
end

local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(cbWidth, cbHeight)
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -8)
	frame:GetStatusBarTexture():SetHorizTile(true)

	if(not frame.shield:IsShown()) then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end
	
	local frame = frame:GetParent()
	frame.castbarbackdrop_tex:ClearAllPoints()
	frame.castbarbackdrop_tex:SetPoint("TOPLEFT", frame.cb, "TOPLEFT", -noscalemult*3, noscalemult*3)
	frame.castbarbackdrop_tex:SetPoint("BOTTOMRIGHT", frame.cb, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
end	

local function UpdateCastText(frame, curValue)
	local minValue, maxValue = frame:GetMinMaxValues()
	
	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		frame.name:SetText(select(1, (UnitChannelInfo("target"))))
	end
	
	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		frame.name:SetText(select(1, (UnitCastingInfo("target"))))
	end
end

local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local function OnHide(frame)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.hasclass = nil
	frame.isFriendly = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
end

local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldname, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local _, cbborder, cbshield, cbicon = cb:GetRegions()
	frame.healthOriginal = hp
	
	--Just make sure these are correct
	hp:SetFrameLevel(9)
	cb:SetFrameLevel(9)
	
	
	-- Create Cast Icon Backdrop frame
	local healthbarbackdrop_tex = hp:CreateTexture(nil, "BACKGROUND")
	healthbarbackdrop_tex:SetPoint("TOPLEFT", hp, "TOPLEFT", -noscalemult*3, noscalemult*3)
	healthbarbackdrop_tex:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
	healthbarbackdrop_tex:SetTexture(0.1, 0.1, 0.1)
	frame.healthbarbackdrop_tex = healthbarbackdrop_tex
	
	--Create our fake border.. fuck blizz
	local healthbarborder_tex1 = hp:CreateTexture(nil, "BORDER")
	healthbarborder_tex1:SetPoint("TOPLEFT", hp, "TOPLEFT", -noscalemult*2, noscalemult*2)
	healthbarborder_tex1:SetPoint("TOPRIGHT", hp, "TOPRIGHT", noscalemult*2, noscalemult*2)
	healthbarborder_tex1:SetHeight(noscalemult)
	healthbarborder_tex1:SetTexture(0.6, 0.6, 0.6)	
	frame.healthborder_tex1 = healthbarborder_tex1
	
	local healthbarborder_tex2 = hp:CreateTexture(nil, "BORDER")
	healthbarborder_tex2:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", -noscalemult*2, -noscalemult*2)
	healthbarborder_tex2:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", noscalemult*2, -noscalemult*2)
	healthbarborder_tex2:SetHeight(noscalemult)
	healthbarborder_tex2:SetTexture(0.6, 0.6, 0.6)	
	frame.healthborder_tex2 = healthbarborder_tex2
	
	local healthbarborder_tex3 = hp:CreateTexture(nil, "BORDER")
	healthbarborder_tex3:SetPoint("TOPLEFT", hp, "TOPLEFT", -noscalemult*2, noscalemult*2)
	healthbarborder_tex3:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", noscalemult*2, -noscalemult*2)
	healthbarborder_tex3:SetWidth(noscalemult)
	healthbarborder_tex3:SetTexture(0.6, 0.6, 0.6)	
	frame.healthborder_tex3 = healthbarborder_tex3
	
	local healthbarborder_tex4 = hp:CreateTexture(nil, "BORDER")
	healthbarborder_tex4:SetPoint("TOPRIGHT", hp, "TOPRIGHT", noscalemult*2, noscalemult*2)
	healthbarborder_tex4:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -noscalemult*2, -noscalemult*2)
	healthbarborder_tex4:SetWidth(noscalemult)
	healthbarborder_tex4:SetTexture(0.6, 0.6, 0.6)	
	frame.healthborder_tex4 = healthbarborder_tex4
	
	hp:SetStatusBarTexture(TEXTURE)
	frame.hp = hp
	
	--Actual Background for the Healthbar
	hp.hpbg = hp:CreateTexture(nil, 'BORDER')
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1,1,1,0.25)  
	
	--Create Overlay Highlight
	frame.overlay = overlay
	frame.overlay:SetTexture(1,1,1,0.15)
	frame.overlay:SetAllPoints(hp)
	
	--Create Name
	hp.level = hp:CreateFontString(nil, "OVERLAY")
	hp.level:SetFont(FONT, FONTSIZE, FONTFLAG)
	hp.level:SetTextColor(1, 1, 1)
	hp.level:SetShadowOffset(mult, -mult)	
	
	--Needed for level text
	frame.oldlevel = oldlevel
	frame.boss = bossicon
	frame.elite = elite
	
	--Create Health Text
	if showhealth then
		hp.value = hp:CreateFontString(nil, "OVERLAY")	
		hp.value:SetFont(FONT, FONTSIZE, FONTFLAG)
		hp.value:SetPoint("LEFT", hp, 2, 0)
		hp.value:SetTextColor(1,1,1)
		hp.value:SetShadowOffset(mult, -mult)
	end
	
	-- Create Cast Bar Backdrop frame
	local castbarbackdrop_tex = cb:CreateTexture(nil, "BACKGROUND")
	castbarbackdrop_tex:SetPoint("TOPLEFT", cb, "TOPLEFT", -noscalemult*3, noscalemult*3)
	castbarbackdrop_tex:SetPoint("BOTTOMRIGHT", cb, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
	castbarbackdrop_tex:SetTexture(0.1, 0.1, 0.1)
	frame.castbarbackdrop_tex = castbarbackdrop_tex
	
	--Create our fake border.. fuck blizz
	local castbarborder_tex1 = cb:CreateTexture(nil, "BORDER")
	castbarborder_tex1:SetPoint("TOPLEFT", cb, "TOPLEFT", -noscalemult*2, noscalemult*2)
	castbarborder_tex1:SetPoint("TOPRIGHT", cb, "TOPRIGHT", noscalemult*2, noscalemult*2)
	castbarborder_tex1:SetHeight(noscalemult)
	castbarborder_tex1:SetTexture(0.6, 0.6, 0.6)	
	
	local castbarborder_tex2 = cb:CreateTexture(nil, "BORDER")
	castbarborder_tex2:SetPoint("BOTTOMLEFT", cb, "BOTTOMLEFT", -noscalemult*2, -noscalemult*2)
	castbarborder_tex2:SetPoint("BOTTOMRIGHT", cb, "BOTTOMRIGHT", noscalemult*2, -noscalemult*2)
	castbarborder_tex2:SetHeight(noscalemult)
	castbarborder_tex2:SetTexture(0.6, 0.6, 0.6)	
	
	local castbarborder_tex3 = cb:CreateTexture(nil, "BORDER")
	castbarborder_tex3:SetPoint("TOPLEFT", cb, "TOPLEFT", -noscalemult*2, noscalemult*2)
	castbarborder_tex3:SetPoint("BOTTOMLEFT", cb, "BOTTOMLEFT", noscalemult*2, -noscalemult*2)
	castbarborder_tex3:SetWidth(noscalemult)
	castbarborder_tex3:SetTexture(0.6, 0.6, 0.6)	
	
	local castbarborder_tex4 = cb:CreateTexture(nil, "BORDER")
	castbarborder_tex4:SetPoint("TOPRIGHT", cb, "TOPRIGHT", noscalemult*2, noscalemult*2)
	castbarborder_tex4:SetPoint("BOTTOMRIGHT", cb, "BOTTOMRIGHT", -noscalemult*2, -noscalemult*2)
	castbarborder_tex4:SetWidth(noscalemult)
	castbarborder_tex4:SetTexture(0.6, 0.6, 0.6)	
	
	--Setup CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)		
	cbicon:SetSize(iconSize, iconSize)
	cbicon:SetTexCoord(.07, .93, .07, .93)
	cbicon:SetDrawLayer("OVERLAY")

	-- Create Cast Icon Backdrop frame
	local casticonbackdrop_tex = cb:CreateTexture(nil, "BACKGROUND")
	casticonbackdrop_tex:SetPoint("TOPLEFT", cbicon, "TOPLEFT", -noscalemult*3, noscalemult*3)
	casticonbackdrop_tex:SetPoint("BOTTOMRIGHT", cbicon, "BOTTOMRIGHT", noscalemult*3, -noscalemult*3)
	casticonbackdrop_tex:SetTexture(0.1, 0.1, 0.1)
	
	local casticonborder_tex = cb:CreateTexture(nil, "BORDER")
	casticonborder_tex:SetPoint("TOPLEFT", cbicon, "TOPLEFT", -noscalemult*2, noscalemult*2)
	casticonborder_tex:SetPoint("BOTTOMRIGHT", cbicon, "BOTTOMRIGHT", noscalemult*2, -noscalemult*2)
	casticonborder_tex:SetTexture(0.6, 0.6, 0.6)	
	
	--Create Health Backdrop Frame
	local casticonbackdrop2_tex = cb:CreateTexture(nil, "ARTWORK")
	casticonbackdrop2_tex:SetPoint("TOPLEFT", cbicon, "TOPLEFT", -noscalemult, noscalemult)
	casticonbackdrop2_tex:SetPoint("BOTTOMRIGHT", cbicon, "BOTTOMRIGHT", noscalemult, -noscalemult)
	casticonbackdrop2_tex:SetTexture(0.1, 0.1, 0.1)
	
	--Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "LEFT", -1, 0)
	cb.time:SetFont(FONT, FONTSIZE, FONTFLAG)
	cb.time:SetTextColor(1, 1, 1)
	cb.time:SetShadowOffset(mult, -mult)

	--Create Cast Name Text
	cb.name = cb:CreateFontString(nil, "ARTWORK")
	cb.name:SetPoint("TOP", cb, "BOTTOM", 0, -3)
	cb.name:SetFont(FONT, FONTSIZE, FONTFLAG)
	cb.name:SetTextColor(1, 1, 1)
	cb.name:SetShadowOffset(mult, -mult)
	
	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', OnSizeChanged)
	cb:HookScript('OnValueChanged', OnValueChanged)	
	cb:SetStatusBarTexture(TEXTURE)
	frame.cb = cb

	--Create Name Text
	local name = hp:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', -10, 3)
	name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 10, 3)
	name:SetFont(FONT, FONTSIZE, FONTFLAG)
	name:SetShadowOffset(mult, -mult)
	frame.oldname = oldname
	frame.name = name
		
	--Reposition and Resize RaidIcon
	raidicon:ClearAllPoints()
	raidicon:SetPoint("BOTTOM", hp, "TOP", 0, 16)
	raidicon:SetSize(iconSize*1.4, iconSize*1.4)
	frame.raidicon = raidicon
	
	--Create Class Icon
	local cIconTex = hp:CreateTexture(nil, "OVERLAY")
	cIconTex:SetPoint("BOTTOM", hp, "TOP", 0, 16)
	cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	cIconTex:SetSize(iconSize, iconSize)
	frame.class = cIconTex
	
	--Hide Old Stuff
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)
	
	UpdateObjects(hp)
	UpdateCastbar(cb)
	
	frame.hp:HookScript('OnShow', UpdateObjects)
	frame:HookScript('OnHide', OnHide)
	frames[frame] = true
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()

		if (not frames[frame]) and
		   (frame:GetName() and frame:GetName():find'^NamePlate%d') and
		   (region and region:GetObjectType() == 'Texture' and region:GetTexture() == [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=])
		then
			SkinObjects(frame)
			frame.region = region
		end
	end
end


CreateFrame('Frame'):SetScript('OnUpdate', function(self, elapsed)
	if(self.elapsed and self.elapsed > 0.2) then
		if(WorldFrame:GetNumChildren() ~= numChildren) then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end

		for frame in pairs(frames) do
			UpdateThreat(frame, self.elapsed)
		end
		
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
	
	ForEachPlate(CheckBlacklist)
	ForEachPlate(HideDrunkenText)
end)

if C["other"].nameplateauto == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")
	NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end
	
	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
	
	function NamePlates:PLAYER_ENTERING_WORLD()
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
end
