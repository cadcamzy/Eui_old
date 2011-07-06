--团队目标检测通告
Local E, C, L = unpack(EUI)
if C["raid"].raidtarget ~= true then return end
--位置初始化
if not raidtarget then
	raidtarget = {}
	raidtarget.FrameX = 50
	raidtarget.FrameY = -50
	raidtarget.FramePoint = "CENTER"
	raidtarget.type = 1
	raidtarget.class = "all"
end

local function setType(self, t)
	if t == 1 then
		raidtarget.type = 1
	elseif t == 2 then
		raidtarget.type =2
	end
	onUpdate(self, raidtarget.type, raidtarget.class)
end

local function setClass(self, c)
	if c == "all" then
		raidtarget.class = "all"
	elseif c == "ROGUE" then
		raidtarget.class = "ROGUE"
	elseif c == "DRUID" then
		raidtarget.class = "DRUID"
	elseif c == "HUNTER" then
		raidtarget.class = "HUNTER"
	elseif c == "MAGE" then
		raidtarget.class = "MAGE"
	elseif c == "WARRIOR" then
		raidtarget.class = "WARRIOR"
	elseif c == "SHAMAN" then
		raidtarget.class = "SHAMAN"
	elseif c == "PALADIN" then
		raidtarget.class = "PALADIN"
	elseif c == "PRIEST" then
		raidtarget.class = "PRIEST"
	elseif c == "WARLOCK" then
		raidtarget.class = "WARLOCK"
	elseif c == "DEATHKNIGHT" then
		raidtarget.class = "DEATHKINGHT"
	end
	onUpdate(self, raidtarget.type, raidtarget.class)
end	


local function initializeDropdown(dropdownFrame, level, menu)
	local info
	if level == 1 then
		info = UIDropDownMenu_CreateInfo()
		info.text = "功能模块"
		info.notCheckable = true
		info.hasArrow = true
		info.menuList = "type"
		UIDropDownMenu_AddButton(info, 1)
			
		info = UIDropDownMenu_CreateInfo()
		info.text = "监视对象"
		info.notCheckable = true
		info.hasArrow = true
		info.menuList = "class"
		UIDropDownMenu_AddButton(info, 1)
			
	elseif level == 2 then
		if menu == "type" then
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视目标不同的队友"
			info.func = setType
			info.arg1 = 1
			info.checked = (raidtarget.type == 1)
			UIDropDownMenu_AddButton(info, 2)
			
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视目标相同的队友"
			info.func = setType
			info.arg1 = 2
			info.checked = (raidtarget.type == 2)
			UIDropDownMenu_AddButton(info, 2)
		
		elseif menu == "class" then
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视全职业队友"
			info.func = setClass
			info.arg1 = "all"
			info.checked = (raidtarget.class == "all")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视盗贼队友"
			info.func = setClass
			info.arg1 = "ROGUE"
			info.checked = (raidtarget.class == "ROGUE")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视德鲁伊队友"
			info.func = setClass
			info.arg1 = "DRUID"
			info.checked = (raidtarget.class == "DRUID")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视猎人队友"
			info.func = setClass
			info.arg1 = "HUNTER"
			info.checked = (raidtarget.class == "HUNTER")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视法师队友"
			info.func = setClass
			info.arg1 = "MAGE"
			info.checked = (raidtarget.class == "MAGE")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视战士队友"
			info.func = setClass
			info.arg1 = "WARRIOR"
			info.checked = (raidtarget.class == "WARRIOR")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视萨满队友"
			info.func = setClass
			info.arg1 = "SHAMAN"
			info.checked = (raidtarget.class == "SHAMAN")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视圣骑士队友"
			info.func = setClass
			info.arg1 = "PALADIN"
			info.checked = (raidtarget.class == "PALADIN")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视牧师队友"
			info.func = setClass
			info.arg1 = "PRIEST"
			info.checked = (raidtarget.class == "PRIEST")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视术士队友"
			info.func = setClass
			info.arg1 = "WARLOCK"
			info.checked = (raidtarget.class == "WARLOCK")
			UIDropDownMenu_AddButton(info, 2)			
		
			info = UIDropDownMenu_CreateInfo()
			info.text = "监视死亡骑士队友"
			info.func = setClass
			info.arg1 = "DEATHKNIGHT"
			info.checked = (raidtarget.class == "DEATHKNIGHT")
			UIDropDownMenu_AddButton(info, 2)			
		end
	end
end


local function onUpdate(self, t, c)
	self:ClearLines()
	local t = t or 1
 	if t == 1 then
		self:SetText("与您目标不同的队友", 1, 1, 1)
	elseif t == 2 then
		self:SetText("与您目标相同的队友", 1, 1, 1)
	end
	if GetNumRaidMembers() < 1 then
		_G["EuiRaidTargetFrame"]:SetScale(0.00001)
		_G["EuiRaidTargetFrame"]:SetAlpha(0)
		_G["EuiRaidTargetFrame"]:SetPoint("LEFT",UIParent,"LEFT",50000,0)
		return
	else
		_G["EuiRaidTargetFrame"]:SetScale(1)
		_G["EuiRaidTargetFrame"]:SetAlpha(1)
		_G["EuiRaidTargetFrame"]:SetPoint(raidtarget.FramePoint, UIParent, raidtarget.FramePoint, raidtarget.FrameX, raidtarget.FrameY)
	end
	local color
	local pot = UnitName("target")
	local class = c or "all"
	local tclass
	if not pot then return end
	for i = 1,GetNumRaidMembers() do
		local unit = "raid"..i;
		MSG_NAME = UnitName(unit);
		tclass = select(2, UnitClass(unit))
		MSG_TARNAME = UnitName(unit.."target");
		color = E.RAID_CLASS_COLORS[select(2, UnitClass(unit))] or {r=1,g=1,b=1}
		if i == 1 then self:AddLine(" ") end
		if UnitName(unit.."target") and not UnitIsDeadOrGhost(unit) and not UnitIsUnit(unit, "player") and class == "all" then
			if t == 1 then
				if pot ~= MSG_TARNAME then
					self:AddLine(tostring(floor(i/5)+1)..". "..UnitName(unit), color.r, color.g, color.b)
				end
			elseif t == 2 then
				if pot == MSG_TARNAME then
					self:AddLine(tostring(floor(i/5)+1)..". "..UnitName(unit), color.r, color.g, color.b)
				end
			end
		elseif UnitName(unit.."target") and not UnitIsDeadOrGhost(unit) and not UnitIsUnit(unit, "player") and class == tclass then
			if t == 1 then
				if pot ~= MSG_TARNAME then
					self:AddLine(tostring(floor(i/5)+1)..". "..UnitName(unit), color.r, color.g, color.b)
				end
			elseif t == 2 then
				if pot == MSG_TARNAME then
					self:AddLine(tostring(floor(i/5)+1)..". "..UnitName(unit), color.r, color.g, color.b)
				end
			end
		end
	end
	--	self:SetText(self:GetText().." ("..tostring(self:NumLines()-1)..")")
	self:Show()
end

local function createFrame()
	local frame = CreateFrame("GameTooltip", "EuiRaidTargetFrame", UIParent, "GameTooltipTemplate")
	local dropdownFrame = CreateFrame("Frame", "EuiRaidTargetFrameDropdown", frame, "UIDropDownMenuTemplate")
	frame:SetFrameStrata("DIALOG")
--	frame:SetTexture(nil)
	frame:SetPoint(raidtarget.FramePoint, UIParent, raidtarget.FramePoint, raidtarget.FrameX, raidtarget.FrameY)
	frame:SetHeight(64)
	frame:SetWidth(64)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetMovable()
	GameTooltip_OnLoad(frame)
	frame:SetPadding(16)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		ValidateFramePosition(self)
		local point, _, _, x, y = self:GetPoint(1)
		raidtarget.FrameX = x
		raidtarget.FrameY = y
		raidtarget.FramePoint = point
	end)

	frame:SetScript("OnUpdate", function(self, e)
		onUpdate(self, raidtarget.type, raidtarget.class)
	end)

	frame:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			UIDropDownMenu_Initialize(dropdownFrame, initializeDropdown, "MENU")
			ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 10, -10)
		end
	end)
	return frame
end



frame=createFrame()
frame:Show()
E.EuiSkinFadedPanel(frame)
frame:SetOwner(UIParent, "ANCHOR_PRESERVE")
onUpdate(frame, raidtarget.type, raidtarget.class)

frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
