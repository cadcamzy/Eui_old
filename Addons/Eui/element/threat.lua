local E,C = unpack(select(2, ...))
if not C["threat"].enable == true then return end
local direction = "down"
local threatguid, threatunit, threatlist, threatbars = "", "target", {}, {};

local euithreatframe = CreateFrame("Frame", "EuiThreatFrame", UIParent);
E.EuiCreatePanel(euithreatframe, 1, 1, "TOPLEFT", UIParent, "TOPLEFT", 10, -60)
euithreatframe:SetWidth(C["threat"].width+ E.Scale(4))
euithreatframe:SetHeight(C["threat"].height * C["threat"].bars + (C["threat"].spacing*(C["threat"].bars-1)) + E.Scale(4))
E.EuiSetTemplate(euithreatframe)
E.EuiCreateShadow(euithreatframe)
EuiThreatFrame:Hide()
local euithreatframetop = CreateFrame("Frame",nil, EuiThreatFrame)
E.EuiCreatePanel(euithreatframetop, 1, 1, "BOTTOM", EuiThreatFrame, "TOP", 0, C["threat"].spacing)
euithreatframetop:SetWidth(C["threat"].width+ E.Scale(4))
euithreatframetop:SetHeight(C["threat"].height+ E.Scale(4))
E.EuiSetTemplate(euithreatframetop,1)
euithreatframetop.text = euithreatframetop:CreateFontString(nil,"OVERLAY")
euithreatframetop.text:SetFont(E.fontn,12,"OUTLINE")
euithreatframetop.text:SetPoint("LEFT", euithreatframetop, "LEFT", 2, 0)
euithreatframetop.text:SetText("仇 恨")
euithreatframetop.text:SetShadowOffset(1,-1)
--[[ local ebarbg={}
for i=1,C["threat"].bars do
	ebarbg[i] = CreateFrame("Frame", nil, EuiThreatFrame)
	ebarbg[i]:SetWidth(C["threat"].width)
	ebarbg[i]:SetHeight(C["threat"].height)
	if i == 1 then
		ebarbg[i]:SetPoint("TOPLEFT", EuiThreatFrame, "TOPLEFT", E.Scale(2), -E.Scale(2))
		ebarbg[i]:SetPoint("TOPRIGHT", EuiThreatFrame, "TOPRIGHT", -E.Scale(2), -E.Scale(2))
	else
		ebarbg[i]:SetPoint("TOP", ebarbg[i-1], "BOTTOM", 0, -C["threat"].spacing)
	end
	E.EuiSetTemplate(ebarbg[i])
end ]]


local function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local function short_value(value)
	local strLen = strlen(value);
	local retString = value;
	if ( strLen > 6 ) then
		retString = string.sub(value, 1, -7)..SECOND_NUMBER_CAP;
	elseif ( strLen > 3 ) then
		retString = string.sub(value, 1, -4)..FIRST_NUMBER_CAP;
	end
	return retString;
end

local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local function GetThreat(unit, pet)
	if ( UnitName(pet or unit) == UNKNOWN or not UnitIsVisible(pet or unit) ) then
		return;
	end
	
	local tperc, _, tvalue = select(3, UnitDetailedThreatSituation(pet or unit, threatunit));
	local name = pet and UnitName(unit) .. ": " .. UnitName(pet) or UnitName(unit);
	
	for index, value in ipairs(threatlist) do
		if ( value.name == name ) then
			tremove(threatlist, index);
			break;
		end
	end
	if tvalue and tvalue < 0 then
		tvalue = tvalue + 410065408;
	end
	table.insert(threatlist, {
		name = name,
		class = select(2, UnitClass(unit)),
		tperc = tperc or 0,
		tvalue = tvalue or 0,
	});
end

local function AddThreat(unit, pet)
	if ( UnitExists(pet) ) then
		GetThreat(unit);
		GetThreat(unit, pet);
	else
		if ( GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 ) then
			GetThreat(unit);
		end
	end
end

local function SortThreat(a, b)
	if direction == "down" then
		return a.tperc > b.tperc;
	end
	return a.tperc < b.tperc;
end

local function OnUpdateBar(self, elpased)
	if ( self.moveTo == self.value ) then
		self:SetScript("OnUpdate", nil);
	else
		if ( self.moveTo > self.value ) then
			self.value = self.value+1;
		elseif ( self.moveTo < self.value ) then
			self.value = self.value-1;
		end
		self:SetValue(self.value);
	end
end

local function UpdateThreatBars()
	for index, value in ipairs(threatbars) do
		value:Hide();
	end
	table.sort(threatlist, SortThreat);
	local bar, class, r, g, b, text;
	for index, value in ipairs(threatlist) do
		if ( index > C["threat"].bars ) then
			return;
		end
		bar = threatbars[index];
		if ( not bar ) then
			bar = CreateFrame("StatusBar", "eThreatBar"..index, UIParent);
			bar:SetWidth(C["threat"].width);
			bar:SetHeight(C["threat"].height);
			bar:SetStatusBarTexture(E.normTex);
			bar:SetMinMaxValues(0, 100);
			bar:SetValue(0);
			if ( index == 1 ) then
				bar:SetPoint("TOPLEFT", EuiThreatFrame, "TOPLEFT", E.Scale(2), -E.Scale(2));
				bar:SetPoint("TOPRIGHT", EuiThreatFrame, "TOPRIGHT", -E.Scale(2), -E.Scale(2));
			else
				bar:SetPoint("TOP", threatbars[index-1], "BOTTOM", 0, -C["threat"].spacing);
			end
			
			bar:SetBackdropColor(0, 0, 0, 1)
			bar:SetBackdropBorderColor(0, 0, 0, 1)
			
			bar.bg = bar:CreateTexture(nil, "BORDER")
			bar.bg:SetAllPoints(bar)
			bar.bg:SetTexture(E.normTex)
			bar.bg:SetVertexColor(0.15, 0.15, 0.15)
			
			local panel = CreateFrame("Frame", nil, bar)
			E.EuiCreatePanel(panel, C["threat"].width, C["threat"].height, "CENTER", bar, "CENTER", 0, 0)
			panel:SetBackdropColor(0, 0, 0)
			panel:SetBackdropBorderColor(0, 0, 0)
			E.EuiCreateShadow(panel)
			E.EuiSetTemplate(panel)

			bar.textright = bar:CreateFontString("$parentTextRight", "ARTWORK");
			bar.textright:SetFont(E.fontn, 10, "OUTLINE");
			bar.textright:SetShadowOffset(0, 0);
			bar.textright:SetShadowColor(0, 0, 0, 0.8);
			bar.textright:SetJustifyH("RIGHT");
			bar.textright:SetPoint("RIGHT", -1, 1);
			bar.textright:SetTextColor(1, 1, 1, 1);
			
			bar.textleft = bar:CreateFontString("$parentTextLeft", "ARTWORK");
			bar.textleft:SetFont(E.font, 11);
			bar.textleft:SetShadowOffset(1, -1);
			bar.textleft:SetShadowColor(0, 0, 0, 0.8);
			bar.textleft:SetJustifyH("LEFT");
			bar.textleft:SetPoint("LEFT", 1, 1);
			bar.textleft:SetPoint("RIGHT", bar.textright, "LEFT", -1, 1);
			
			tinsert(threatbars, bar);
		end
		
		
		bar.moveTo = tonumber(format("%d", value.tperc));
		bar.value = tonumber(format("%d", bar:GetValue()));
		if ( bar.value > 100 ) then
			bar.value = 100;
		elseif ( bar.value < 0 ) then
			bar.value = 0;
		end
		bar:SetScript("OnUpdate", OnUpdateBar);
			
		if ( value.name == UnitName("player") ) then
			bar.textleft:SetTextColor(1, 1, 1, 1);
			bar:SetStatusBarColor(0.8, 0, 0, 0.8);
		else
			class = E.RAID_CLASS_COLORS[value.class];
			bar.textleft:SetTextColor(class.r, class.g, class.b, 1);
			bar:SetStatusBarColor(0.31, 0.45, 0.63, 0.5);
		end
		
		r, g, b = ColorGradient(((value.tperc > 100 and 100 or value.tperc)/100), 0, 1, 0, 1, 1, 0, 1, 0, 0);
		text = string.gsub("$value [$perc%]", "$value", comma_value(tonumber(format("%d", value.tvalue/100))));
		text = string.gsub(text, "$shortvalue", short_value(tonumber(format("%d", value.tvalue/100))));
		text = string.gsub(text, "$perc", string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, value.tperc));
		text = string.gsub(text, "$name", value.name);
		bar.textright:SetText(text);
		
		text = string.gsub("$name", "$value", comma_value(tonumber(format("%d", value.tvalue/100))));
		text = string.gsub(text, "$shortvalue", short_value(tonumber(format("%d", value.tvalue/100))));
		text = string.gsub(text, "$perc", string.format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, value.tperc));
		text = string.gsub(text, "$name", value.name);
		bar.textleft:SetText(text);
		
		bar:Show();
	end
end

local function OnEvent(self, event, ...)
	local unit = ...;
	if ( event == "ADDON_LOADED" ) then
		self:SetPoint("TOPLEFT", EuiThreatFrame, "TOPLEFT", E.Scale(2), -E.Scale(2));
		self:SetPoint("TOPRIGHT", EuiThreatFrame, "TOPRIGHT", -E.Scale(2), -E.Scale(2));
		direction = "down"
		self:SetWidth(C["threat"].width);
		self:SetHeight(C["threat"].height);
		self:UnregisterEvent(event);
	end
	if ( event == "UNIT_THREAT_LIST_UPDATE" ) then
		if UnitIsPlayer("target") and UnitCanAttack("player", "focus") then
			threatunit = "focus"
		elseif UnitCanAttack("player", "target") then
			threatunit = "target"
		end
		if ( unit and UnitExists(unit) and UnitGUID(unit) == threatguid and UnitCanAttack("player", threatunit) ) then
			if ( GetNumRaidMembers() > 0 ) then
				for i=1, GetNumRaidMembers(), 1 do
					AddThreat("raid"..i, "raid"..i.."pet");
				end
				EuiThreatFrame:Show();
			elseif ( GetNumPartyMembers() > 0 ) then
				AddThreat("player", "pet");
				for i=1, GetNumPartyMembers(), 1 do
					AddThreat("party"..i, "party"..i.."pet");
				end
				EuiThreatFrame:Show();
			else
				AddThreat("player", "pet");
			end
			UpdateThreatBars();
		end
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		if ( UnitExists("target") and not UnitIsDead("target") and not UnitIsPlayer("target") ) then
			threatguid = UnitGUID("target");
		elseif UnitIsPlayer("target") and UnitCanAttack("player", "focus") then
			threatguid = UnitGUID("focus"); --如果目标是友方单位,焦点是敌对单位的话,显示焦点仇恨.		
		else
			threatguid = "";
		end
		wipe(threatlist);
		UpdateThreatBars();
	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		EuiThreatFrame:Hide();
		wipe(threatlist);
		UpdateThreatBars();
	end
end

local eThreatFrame = CreateFrame("Frame", "eThreat", EuiThreatFrame);
eThreatFrame:SetClampedToScreen(true);
eThreatFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE");
eThreatFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
eThreatFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
eThreatFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
eThreatFrame:RegisterEvent("ADDON_LOADED");
eThreatFrame:SetScript("OnEvent", OnEvent);

function E.ThreatPoint(frame)
	if E.Movers["ThreatMover"]["moved"] ~= true then
		ThreatMover:ClearAllPoints()
		ThreatMover:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
	end	
end

E.CreateMover(EuiThreatFrame, "ThreatMover", "仇恨框架", false, E.ThreatPoint)

function E.ThreatShow()
	if EuiThreatFrame:IsShown() then EuiThreatFrame:Hide() end
end

function E.ThreatTest()
	table.insert(threatlist, { name = PLAYER.." 1", class = "WARRIOR", tperc = 100, tvalue = 100*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 2", class = "ROGUE", tperc = 90, tvalue = 90*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 3", class = "HUNTER", tperc = 80, tvalue = 80*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 4", class = "PRIEST", tperc = 70, tvalue = 70*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 5", class = "DRUID", tperc = 60, tvalue = 60*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 6", class = "WARLOCK", tperc = 50, tvalue = 50*1000*1000 });
	table.insert(threatlist, { name = PLAYER.." 7", class = "MAGE", tperc = 40, tvalue = 40*1000*1000 });
	UpdateThreatBars();
end
if C["threat"].test == true then
	E.ThreatTest()
end