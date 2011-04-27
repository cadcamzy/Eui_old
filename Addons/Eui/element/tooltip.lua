local E, C = unpack(select(2, ...))
if not C["tooltip"].enable then return end

local EuiTooltip = CreateFrame("Frame", nil, UIParent)

local _G = getfenv(0)
local inspectName
local inspectList = {}
local inspectTime = GetTime()
local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]

local TooltipHolder = CreateFrame("Frame", "TooltipHolder", UIParent)
TooltipHolder:SetWidth(130)
TooltipHolder:SetHeight(22)
TooltipHolder:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")

E.CreateMover(TooltipHolder, "TooltipMover", "鼠标提示")

local gsub, find, format = string.gsub, string.find, string.format

local Tooltips = {GameTooltip,ItemRefTooltip,ShoppingTooltip1,ShoppingTooltip2,ShoppingTooltip3,WorldMapTooltip}

local linkTypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

local classification = {
	worldboss = "|cffAF5050Boss|r",
	rareelite = "|cffAF5050+ Rare|r",
	elite = "|cffAF5050+|r",
	rare = "|cffAF5050Rare|r",
}
 	
local NeedBackdropBorderRefresh = false

--Check if our embed right addon is shown
--[[ local function CheckAddOnShown()
	if E.ChatRightShown == true and E.RightChat and E.RightChat == true then
		return true
	elseif C["skin"].embedright == "Omen" and IsAddOnLoaded("Omen") and OmenAnchor then
		if OmenAnchor:IsShown() then
			return true
		else
			return false
		end
	elseif C["skin"].embedright == "Recount" and IsAddOnLoaded("Recount") and Recount_MainWindow then
		if Recount_MainWindow:IsShown() then
			return true
		else
			return false
		end
	elseif  C["skin"].embedright ==  "Skada" and IsAddOnLoaded("Skada") and SkadaBarWindowSkada then
		if SkadaBarWindowSkada:IsShown() then
			return true
		else
			return false
		end
	else
		return false
	end
end ]]

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	if C["tooltip"].cursor == true then
		self:SetOwner(parent, "ANCHOR_CURSOR")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", C["tooltip"].x, C["tooltip"].y)
	end
	self.default = 1
end)

local function SetRightTooltipPos(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", C["tooltip"].x, C["tooltip"].y)	
	if InCombatLockdown() and C["tooltip"].hideincombat == true then
		self:Hide()
	else
		if TooltipMover and E.Movers["TooltipMover"]["moved"] == true then
			self:SetPoint("BOTTOMRIGHT", TooltipMover, "TOPRIGHT", -1, E.Scale(18))
		else
			self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", C["tooltip"].x, C["tooltip"].y)	
		end
	end
end

GameTooltip:HookScript("OnUpdate",function(self, ...)
--	local inInstance, instanceType = IsInInstance()
 	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		local x, y = GetCursorPosition();
		local effScale = self:GetEffectiveScale();
		self:ClearAllPoints();
		self:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",(x / effScale + (C["tooltip"].x)),(y / effScale + (C["tooltip"].x)))		
	end
	
	if self:GetAnchorType() == "ANCHOR_CURSOR" and NeedBackdropBorderRefresh == true and C["tooltip"].cursor ~= true then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x
		NeedBackdropBorderRefresh = false
		self:SetBackdropColor(.1,.1,.1,.6)
		self:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	elseif self:GetAnchorType() == "ANCHOR_NONE" then
		SetRightTooltipPos(self)
	end
end)

local function Hex(color)
	return string.format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function GetColor(unit)
	if(UnitIsPlayer(unit) and not UnitHasVehicleUI(unit)) then
		local _, class = UnitClass(unit)
		local color = E.RAID_CLASS_COLORS[class]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b
		return Hex(color), r, g, b	
	else
		local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b		
		return Hex(color), r, g, b		
	end
end

local ShortValue = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

-- update HP value on status bar
GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	
	if (value < min) or (value > max) then
		return
	end
	local _, unit = GameTooltip:GetUnit()
	
	-- fix target of target returning nil
	if (not unit) then
		local GMF = GetMouseFocus()
		unit = GMF and GMF:GetAttribute("unit")
	end

	if not self.text then
		self.text = self:CreateFontString(nil, "OVERLAY")
		self.text:SetPoint("CENTER", GameTooltipStatusBar, 0, E.Scale(-3))
		self.text:SetFont(E.font, 11, "THINOUTLINE")
		self.text:Show()
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			local hp = ShortValue(min).." / "..ShortValue(max)
			if UnitIsGhost(unit) then
				self.text:SetText("鬼魂")
			elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
				self.text:SetText("死亡")
			else
				self.text:SetText(hp)
			end
		end
	else
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			self.text:Show()
			local hp = ShortValue(min).." / "..ShortValue(max)
			if min == 0 or min == 1 then
				self.text:SetText("死亡")
			else
				self.text:SetText(hp)
			end
		else
			self.text:Hide()
		end
	end
end)local healthBar = GameTooltipStatusBar
healthBar:ClearAllPoints()
healthBar:SetHeight(E.Scale(5))
healthBar:SetPoint("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", E.Scale(2), E.Scale(-5))
healthBar:SetPoint("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -E.Scale(2), E.Scale(-5))
healthBar:SetStatusBarTexture(E.normTex)


local healthBarBG = CreateFrame("Frame", "StatusBarBG", healthBar)
healthBarBG:SetFrameLevel(healthBar:GetFrameLevel() - 1)
healthBarBG:SetPoint("TOPLEFT", -E.Scale(2), E.Scale(2))
healthBarBG:SetPoint("BOTTOMRIGHT", E.Scale(2), -E.Scale(2))
E.EuiSetTemplate(healthBarBG)
healthBarBG:SetBackdropColor(.1,.1,.1,.6)

-- Add "Targeted By" line
local targetedList = {}
local ClassColors = {};
local token
for class, color in next, E.RAID_CLASS_COLORS do
	ClassColors[class] = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
end

local function AddTargetedBy()
	local numParty, numRaid = GetNumPartyMembers(), GetNumRaidMembers();
	if (numParty > 0 or numRaid > 0) then
		for i = 1, (numRaid > 0 and numRaid or numParty) do
			local unit = (numRaid > 0 and "raid"..i or "party"..i);
			if (UnitIsUnit(unit.."target",token)) and (not UnitIsUnit(unit,"player")) then
				local _, class = UnitClass(unit);
				targetedList[#targetedList + 1] = ClassColors[class];
				targetedList[#targetedList + 1] = UnitName(unit);
				targetedList[#targetedList + 1] = "|r, ";
			end
		end
		if (#targetedList > 0) then
			targetedList[#targetedList] = nil;
			GameTooltip:AddLine(" ",nil,nil,nil,1);
			local line = _G["GameTooltipTextLeft"..GameTooltip:NumLines()];
			if not line then return end
			line:SetFormattedText("被以下玩家选为目标".." (|cffffffff%d|r): %s",(#targetedList + 1) / 3,table.concat(targetedList));
			wipe(targetedList);
		end
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local lines = self:NumLines()
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
	
	-- A mage's mirror images sometimes doesn't return a unit, this would fix it
	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end
	
	-- Sometimes when you move your mouse quicky over units in the worldframe, we can get here without a unit
	if not unit then self:Hide() return end
	
	-- for hiding tooltip on unitframes
--	if (self:GetOwner() ~= UIParent and C["tooltip"].hideuf) then self:Hide() return end

--	if self:GetOwner() ~= UIParent and unit then
--		SetRightTooltipPos(self)
--	end	
	
	-- A "mouseover" unit is better to have as we can then safely say the tip should no longer show when it becomes invalid.
	if (UnitIsUnit(unit,"mouseover")) then
		unit = "mouseover"
	end

	local race = UnitRace(unit)
	local class = UnitClass(unit)
	local level = UnitLevel(unit)
	local guildName, guildRankName, guildRankIndex = GetGuildInfo(unit)
	local name, realm = UnitName(unit)
	local crtype = UnitCreatureType(unit)
	local classif = UnitClassification(unit)
	local title = UnitPVPName(unit)
	local r, g, b = 23/255,132/255,209/255
	local ValColor = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
	local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b

	local color = GetColor(unit)	
	if not color then color = "|CFFFFFFFF" end -- just safe mode for when GetColor(unit) return nil for unit too far away

	_G["GameTooltipTextLeft1"]:SetFormattedText("%s%s%s", color, title or name, realm and realm ~= "" and " - "..realm.."|r" or "|r")
	

	if(UnitIsPlayer(unit)) then
		if UnitIsAFK(unit) then
			self:AppendText((" %s"):format(CHAT_FLAG_AFK))
		elseif UnitIsDND(unit) then 
			self:AppendText((" %s"):format(CHAT_FLAG_DND))
		end

		local offset = 2
		if guildName then
			if UnitIsInMyGuild(unit) then
				_G["GameTooltipTextLeft2"]:SetText("<"..ValColor..guildName.."|r> ["..ValColor..guildRankName.."|r]")
			else
				_G["GameTooltipTextLeft2"]:SetText("<|cff00ff10"..guildName.."|r> [|cff00ff10"..guildRankName.."|r]")
			end
			offset = offset + 1
		end

		for i= offset, lines do
			if _G["GameTooltipTextLeft"..i] and _G["GameTooltipTextLeft"..i]:GetText() and (_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r %s %s%s", r*255, g*255, b*255, level > 0 and level or "??", race, color, class.."|r")
				break
			end
		end
	else
		for i = 2, lines do			
			if _G["GameTooltipTextLeft"..i] and _G["GameTooltipTextLeft"..i]:GetText() and ((_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) or (crtype and _G["GameTooltipTextLeft"..i]:GetText():find("^"..crtype))) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r%s %s", r*255, g*255, b*255, classif ~= "worldboss" and level > 0 and level or "??", classification[classif] or "", crtype or "")
				break
			end
		end
	end

	local pvpLine
	for i = 1, lines do
		if _G["GameTooltipTextLeft"..i] and _G["GameTooltipTextLeft"..i]:GetText() and _G["GameTooltipTextLeft"..i]:GetText() == PVP_ENABLED then
			pvpLine = _G["GameTooltipTextLeft"..i]
			pvpLine:SetText()
			break
		end
	end

	-- ToT line
	if UnitExists(unit.."target") and unit~="player" then
		local hex, r, g, b = GetColor(unit.."target")
		if not r and not g and not b then r, g, b = 1, 1, 1 end
		GameTooltip:AddLine("目标: "..UnitName(unit.."target"), r, g, b)
	end
	
	if C["tooltip"].TargetedBy == true then token = unit AddTargetedBy() end
	
	-- insert talent line
	if (C["tooltip"].ShowTalent and UnitIsPlayer(unit)) then
		local InDistance = CheckInteractDistance(unit, 1)
		local EnableNotifyInspect = (not InspectFrame or not InspectFrame:IsShown()) and (not Examiner or not Examiner:IsShown())
		inspectList[name] = inspectList[name] or {}
		if (inspectList[name].talent) then
			local talentInfo = inspectList[name].talent
			GameTooltip:AddLine("天赋:"..talentInfo)
			--GameTooltip:Show()
		else
			if not EnableNotifyInspect then
				GameTooltip:AddLine("天赋:"..format("|cFFAAAAAA%s|r", "观察时停止读取"))
			else
				if InDistance then
					GameTooltip:AddLine("天赋:读取中")
				else
					GameTooltip:AddLine("天赋:距离过远")
				end
			end
		end
		if (not inspectName) and InDistance and EnableNotifyInspect then
			inspectName = name
			inspectTime = GetTime()
			NotifyInspect(unit)
		else
			if ((GetTime() - inspectTime) > 2.0) then
				inspectName = nil
			end
		end
	end	
	
	-- Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is very bad, so this is a fix
	self.fadeOut = nil
end)

local Colorize = function(self)
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
		
	local reaction = unit and UnitReaction(unit, "player")
	local player = unit and UnitIsPlayer(unit)
	local tapped = unit and UnitIsTapped(unit)
	local tappedbyme = unit and UnitIsTappedByPlayer(unit)
	local connected = unit and UnitIsConnected(unit)
	local dead = unit and UnitIsDead(unit)
	

	if (reaction) and (tapped and not tappedbyme or not connected or dead) then
		r, g, b = 0.55, 0.57, 0.61
		self:SetBackdropBorderColor(r, g, b)
		healthBarBG:SetBackdropBorderColor(r, g, b)
		healthBar:SetStatusBarColor(r, g, b)
	elseif player then
		local class = select(2, UnitClass(unit))
		local c = oUF.colors.class[class]
		if c then
			r, g, b = c[1], c[2], c[3]
		end
		self:SetBackdropBorderColor(r, g, b)
		healthBarBG:SetBackdropBorderColor(r, g, b)
		healthBar:SetStatusBarColor(r, g, b)
	elseif reaction then
		local c = oUF.colors.reaction[reaction]
		r, g, b = c[1], c[2], c[3]
		self:SetBackdropBorderColor(r, g, b)
		healthBarBG:SetBackdropBorderColor(r, g, b)
		healthBar:SetStatusBarColor(r, g, b)
	else
		local _, link = self:GetItem()
		local quality = link and select(3, GetItemInfo(link))
		if quality and quality >= 2 then
			local r, g, b = GetItemQualityColor(quality)
			self:SetBackdropBorderColor(r, g, b)
		else
			self:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
			healthBarBG:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
			healthBar:SetStatusBarColor(0.31, 0.45, 0.63,1)
		end
	end	
	-- need this
	NeedBackdropBorderRefresh = true
end

local SetStyle = function(self)
	E.EuiSetTemplate(self)
	Colorize(self)
end

local function getTalentSpecName(names, nums, colors)
	if nums[1] == 0 and nums[2] == 0 and nums[3] == 0 then
		return _G.NONE, _G.NONE
	else
		local first, second, third, name, text, point
		if nums[1] >= nums[2] then
			if nums[1] >= nums[3] then
				first = 1
				if nums[2] >= nums[3] then second = 2 third = 3 else second = 3	third = 2 end
			else
				first = 3 second = 1 third = 2
			end
		else
			if nums[2] >= nums[3] then
				first = 2
				if nums[1] >= nums[3] then second = 1 third = 3 else second = 3 third = 1 end
			else
				first = 3 second = 2 third = 1
			end
		end
		local first_num = nums[first]
		local second_num = nums[second]
		if first_num*3/4 <= second_num then
			if first_num*3/4 <= nums[third] then
				name = colors[first]:format(names[first]).."/"..colors[second]:format(names[second]).."/"..colors[third]:format(names[third])
				text = names[first].."/"..names[second].."/"..names[third]
			else
				name = colors[first]:format(names[first]).."/"..colors[second]:format(names[second])
				text = names[first].."/"..names[second]
			end
		else
			name = colors[first]:format(names[first])
			text = names[first]
		end
		point = (" |cc8c8c8c8(%s|cc8c8c8c8/%s|cc8c8c8c8/%s|cc8c8c8c8)"):format(colors[1]:format(nums[1]), colors[2]:format(nums[2]), colors[3]:format(nums[3]))
		return name..point, text..(" (%s/%s/%s)"):format(nums[1], nums[2], nums[3])
	end
end

local function talentColor(point, maxValue, order)
	local r,g,b
	local minp, maxp = 0, maxValue
	point = max(0, min(point, maxValue))
	if ( (maxp - minp) > 0 ) then
		point = (point - minp) / (maxp - minp)
	else
		point = 0
	end
	if(point > 0.5) then
		r = 0.1 + (((1-point) * 2)* (1-(0.1)))
		g = 0.9
	else
		r = 1.0
		g = (0.9) - (0.5 - point)* 2 * (0.9)
	end
	r = string.format("%x", (r * 100) * 2.55);
	if ( #r == 1 ) then	r = "0"..r;	end
	g = string.format("%x", (g * 100) * 2.55);
	if ( #g == 1 ) then	g = "0"..g;	end
	b = "18"
	if order then
		return "|cff"..r..g..b.."%s|r"
	else
		return "|cff"..g..r..b.."%s|r"
	end
end

EuiTooltip:RegisterEvent("PLAYER_ENTERING_WORLD")
EuiTooltip:RegisterEvent("INSPECT_TALENT_READY")
EuiTooltip:SetScript("OnEvent", function(self,event,...)
	if (event == "PLAYER_ENTERING_WORLD") then
		for _, tt in pairs(Tooltips) do
			tt:HookScript("OnShow", SetStyle)
		end
	
		E.EuiSetTemplate(FriendsTooltip)
		E.EuiSetTemplate(BNToastFrame)
		E.EuiSetTemplate(DropDownList1MenuBackdrop)
		E.EuiSetTemplate(DropDownList2MenuBackdrop)
		E.EuiSetTemplate(DropDownList1Backdrop)
		E.EuiSetTemplate(DropDownList2Backdrop)
	
		BNToastFrame:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", E.Scale(5), E.Scale(-5))
		end)
		
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
		-- Hide tooltips in combat for actions, pet actions and shapeshift
		if C["tooltip"].hidebuttonscombat == true then
			local CombatHideActionButtonsTooltip = function(self)
				if not IsShiftKeyDown() then
					self:Hide()
				end
			end
	 
			hooksecurefunc(GameTooltip, "SetAction", CombatHideActionButtonsTooltip)
			hooksecurefunc(GameTooltip, "SetPetAction", CombatHideActionButtonsTooltip)
			hooksecurefunc(GameTooltip, "SetShapeshift", CombatHideActionButtonsTooltip)
		end		
	end

	if (event == "INSPECT_TALENT_READY") then
		if (inspectName) then
			local name = inspectName
			inspectName = nil
			local TalentNum = GetNumTalentGroups(true)
			local activeTalent = GetActiveTalentGroup(true)
			local inactiveTalent = 0
			if TalentNum >= 2 then
				if activeTalent == 1 then inactiveTalent = 2;end
				if activeTalent == 2 then inactiveTalent = 1;end
			end

			local name1,_,point1 = GetTalentTabInfo(1,true,nil,activeTalent)
			local name2,_,point2 = GetTalentTabInfo(2,true,nil,activeTalent)
			local name3,_,point3 = GetTalentTabInfo(3,true,nil,activeTalent)
			local color1, color2, color3 = talentColor(point1, 71),talentColor(point2,71),talentColor(point3,71)
			local talent_name, talent_text = getTalentSpecName({name1,name2,name3}, {point1,point2,point3},{color1, color2, color3} )

			local name01,point01
			local name02,point02
			local name03,point03
			local color01, color02, color03
			local talent0_name, talent0_text
			if inactiveTalent ~=0 then
				name01,_,point01 = GetTalentTabInfo(1,true,nil,inactiveTalent)
				name02,_,point02 = GetTalentTabInfo(2,true,nil,inactiveTalent)
				name03,_,point03 = GetTalentTabInfo(3,true,nil,inactiveTalent)
				color01, color02, color03 = talentColor(point01, 71),talentColor(point02,71),talentColor(point03,71)
				talent0_name, talent0_text = getTalentSpecName({name01,name02,name03}, {point01,point02,point03},{color01, color02, color03} )
			end


			if (talent_name and talent_text) then
				local talent_name_show;
				if inactiveTalent == 0 then
					talent_name_show = talent_name
				else
					talent_name_show = talent_name.."\n"..format("|cFFAAAAAA%s|r", "备用:")..talent0_name
				end
				inspectList[name].talent = talent_name_show
				--inspectList[name].text = talent_text
				if (UnitExists("mouseover") and UnitName("mouseover") == name) then
					for i = 3, GameTooltip:NumLines() do
						if string.find((getglobal("GameTooltipTextLeft"..i):GetText() or ""), "天赋:") then
							getglobal("GameTooltipTextLeft"..i):SetText("天赋:"..talent_name_show)
							GameTooltip:AppendText("")
							break
						end
					end
				end
			end
		end
	end
end)


EuiTooltip:SetScript("OnUpdate", function(self, elapsed)
	if(self.elapsed and self.elapsed > 0.1) then
		if FrameStackTooltip then
			local noscalemult = E.mult * C["main"].uiscale
			local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b
			FrameStackTooltip:SetBackdrop({
			  bgFile = E.blank, 
			  edgeFile = E.blank, 
			  tile = false, tileSize = 0, edgeSize = noscalemult, 
			  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
			})
			FrameStackTooltip:SetBackdropColor(.1,.1,.1,.6)
			if C["main"].classcolortheme == true then
				FrameStackTooltip:SetBackdropBorderColor(r, g, b)
			else
				FrameStackTooltip:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
			end	
			FrameStackTooltip.SetBackdropColor = dummy
			FrameStackTooltip.SetBackdropBorderColor = dummy
			self.elapsed = nil
			self:SetScript("OnUpdate", nil)
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

GameTooltip:HookScript("OnTooltipCleared", function(self) self.EuiItemTooltip=nil end)
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if EuiItemTooltip and not self.EuiItemTooltip and (EuiItemTooltip.id or EuiItemTooltip.count) then
		local item, link = self:GetItem()
		local num = GetItemCount(link)
		local left = ""
		local right = ""
		
		if EuiItemTooltip.id and link ~= nil then
			left = "|cFFCA3C3C"..ID.."|r "..link:match(":(%w+)")
		end
		
		if EuiItemTooltip.count and num > 1 then
			right = "|cFFCA3C3C".."数量:".."|r "..num
		end
				
		self:AddLine(" ")
		self:AddDoubleLine(left, right)
		self.EuiItemTooltip = 1
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "Eui" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	EuiItemTooltip = EuiItemTooltip or {count=true,id=true}
end)