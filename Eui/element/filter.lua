Local E, C, L = unpack(EUI)
if not C["filter"].enable == true then return end
		
local class = select(2, UnitClass("player"));
local classcolor = E.RAID_CLASS_COLORS[class];
local active, bars = {}, {};

local MyUnits = {
    player = true,
    vehicle = true,
    pet = true,
}
if filterdb == nil then filterdb = {} end;
local time, Update;
local function OnUpdate(self, elapsed)
	time = self.filter == "CD" and self.expirationTime+self.duration-GetTime() or self.expirationTime-GetTime();
	if ( self:GetParent().Mode == "BAR" ) then
		self.statusbar:SetValue(time);
		self.time:SetFormattedText(SecondsToTimeAbbrev(time));
	end
	if ( time < 0 and self.filter == "CD" ) then
		local id = self:GetParent().Id;
		for index, value in ipairs(active[id]) do
			local spn;
			if value.data.filter == "CD" then
				spn = value.data.slotID;
			else
				spn = GetSpellInfo( value.data.spellID);
			end
		--	local spn = GetSpellInfo( value.data.spellID or value.data.slotID )
			if ( self.spellName == spn) then
				tremove(active[id], index);
				break;
			end
		end
		self:SetScript("OnUpdate", nil);
		Update(self:GetParent());
	end
end

function Update(self)
	local id = self.Id;
	if ( not bars[id] ) then
		bars[id] = {};
	end
	for index, value in ipairs(bars[id]) do
		value:Hide();
	end
	local bar;
	for index, value in ipairs(active[id]) do
		bar = bars[id][index];
		if ( not bar ) then
			bar = CreateFrame("Frame", "EuiFilter"..id.."Frame"..index, self);
			bar:SetWidth(value.data.size);
			bar:SetHeight(value.data.size);
			
			local panel = CreateFrame("Frame", nil, bar)
			E.EuiCreatePanel(panel, value.data.size, value.data.size, "CENTER", bar, "CENTER", 0, 0)
			panel:SetBackdropColor(0, 0, 0,1)
			if C["main"].classcolortheme == true then
				local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
				panel:SetBackdropBorderColor(r, g, b,1)
			else
				panel:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
			end
			panel:SetFrameStrata("MEDIUM")
			panel:SetFrameLevel(bar:GetFrameLevel() - 1)
			
			E.EuiCreateShadow(panel)
			
			bar.icon = bar:CreateTexture(nil, "BACKGROUND")
			bar.icon:SetPoint("TOPLEFT", bar, 2, -2)
			bar.icon:SetPoint("BOTTOMRIGHT", bar, -2, 2)
			bar.icon:SetTexCoord(.08, .92, .08, .92)
			
			if ( index == 1 ) then
				if ( C["filter"].configmode ) then
					bar:SetFrameStrata("MEDIUM");
				end
			--	if filterdb[self.Name]==nil then
				--	bar:SetPoint(unpack(self.setPoint));
				bar:SetAllPoints(_G["EuiFilter"..id])
			--	else
			--		bar:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', filterdb[self.Name]["x"], filterdb[self.Name]["y"])
			--	end			
				
			else
				if ( self.Direction == "UP" ) then
					bar:SetPoint("BOTTOM", bars[id][index-1], "TOP", 0, self.Interval);
				elseif ( self.Direction == "RIGHT" ) then
					bar:SetPoint("LEFT", bars[id][index-1], "RIGHT", self.Mode == "ICON" and self.Interval or value.data.barWidth+self.Interval, 0);
				elseif ( self.Direction == "LEFT" ) then
					bar:SetPoint("RIGHT", bars[id][index-1], "LEFT", self.Mode == "ICON" and -self.Interval or -(value.data.barWidth+self.Interval), 0);
				else
					bar:SetPoint("TOP", bars[id][index-1], "BOTTOM", 0, -self.Interval);
				end
			end
			if ( self.Mode == "ICON" ) then
				bar.count = bar:CreateFontString(nil, "ARTWORK");
				bar.count:SetFont(E.fontp, 12, "OUTLINE");
				bar.count:SetPoint("BOTTOMRIGHT",0,1);
				bar.count:SetJustifyH("RIGHT");

				bar.cooldown = CreateFrame("Cooldown", nil, bar);
				bar.cooldown:SetPoint("TOPLEFT", bar, 2, -2)
				bar.cooldown:SetPoint("BOTTOMRIGHT", bar, -2, 2)
				bar.cooldown:SetReverse();

			else
				bar.statusbar = CreateFrame("StatusBar", nil, bar);
				if ( C["filter"].configmode ) then
					bar.statusbar:SetFrameStrata("MEDIUM");
				end
				bar.statusbar:SetWidth(value.data.barWidth - value.data.size -5);
				bar.statusbar:SetHeight(value.data.size);
				bar.statusbar:SetStatusBarTexture(E.normTex);
				if C["filter"].classcolor == true then
					bar.statusbar:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b, 0.8);
				else
					bar.statusbar:SetStatusBarColor(0.31, 0.45, 0.63, 0.5);
				end
				bar.statusbar:SetPoint("TOPLEFT", bar, "TOPRIGHT", 5, 0);
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(0);
				
				bar.statusbar.bg = bar.statusbar:CreateTexture(nil, "BORDER")
				bar.statusbar.bg:SetAllPoints(bar.statusbar)
				bar.statusbar.bg:SetTexture(E.normTex)
				bar.statusbar.bg:SetVertexColor(0.15, 0.15, 0.15)
				
				local panel = CreateFrame("Frame", nil, bar.statusbar)
				E.EuiCreatePanel(panel, (value.data.barWidth - value.data.size -5), value.data.size, "CENTER", bar.statusbar, "CENTER", 0, 0)
				panel:SetBackdropColor(0, 0, 0)
				panel:SetBackdropBorderColor(0,0,0)
				E.EuiCreateShadow(panel)
				
				bar.time = bar.statusbar:CreateFontString(nil, "ARTWORK");
				bar.time:SetFont(E.fontn, 10, "OUTLINE");
				bar.time:SetPoint("RIGHT", bar.statusbar, -2, 1);
				
				bar.spellname = bar.statusbar:CreateFontString(nil, "ARTWORK");
				bar.spellname:SetFont(E.font, 11, "OUTLINE");
				bar.spellname:SetPoint("LEFT", bar.statusbar, 5, 0);
				bar.spellname:SetPoint("RIGHT", bar.time, "LEFT");
				bar.spellname:SetJustifyH("LEFT");
				
				bar.count = bar.statusbar:CreateFontString(nil, "ARTWORK");
				bar.count:SetFont(E.fontn, 10, "OUTLINE");
				bar.count:SetPoint("RIGHT", bar.statusbar, -40, 1);
				bar.count:SetJustifyH("RIGHT");
			end
			
			tinsert(bars[id], bar);
		end
		
		bar.icon:SetTexture(value.icon)
		bar.count:SetText(value.count > 1 and value.count or "")
		if value.data.filter == "CD" then
			bar.spellName = value.data.slotID
		else
			bar.spellName = GetSpellInfo(value.data.spellID)
		end
	--	bar.spellName = GetSpellInfo( value.data.spellID or value.data.slotID );
		
		
	--	print(bar.spellName.."?");
		if ( self.Mode == "BAR" ) then
			bar.spellname:SetText(value.data.displayName or GetSpellInfo( value.data.spellID ));
		end
		if ( value.duration > 0 ) then
			if ( self.Mode == "ICON" ) then
				CooldownFrame_SetTimer(bar.cooldown, value.data.filter == "CD" and value.expirationTime or value.expirationTime-value.duration, value.duration, 1);
				if ( value.data.filter == "CD" ) then
					bar.expirationTime = value.expirationTime;
					bar.duration = value.duration;
					bar.filter = value.data.filter;
					bar:SetScript("OnUpdate", OnUpdate);
				end
			else
				bar.statusbar:SetMinMaxValues(0, value.duration);
				bar.expirationTime = value.expirationTime;
				bar.duration = value.duration;
				bar.filter = value.data.filter;
				bar:SetScript("OnUpdate", OnUpdate);
			end
		else
			if ( self.Mode == "ICON" ) then
				bar.cooldown:Hide();
			else
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(1);
				bar.time:SetText("");
				bar:SetScript("OnUpdate", nil);
			end
		end
		
		bar:Show();
	end
end


local function OnEvent(self, event, ...)
	local unit = ...;
	if ( ( unit == "target" or unit == "player" ) or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "SPELL_UPDATE_COOLDOWN" ) then
		local data, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, start, enabled, slotLink, shouldConsolidate, spellId, spn;
		local id = self.Id;
		for i=1, #Filger_Spells[class][id], 1 do
			data = Filger_Spells[class][id][i];
			local findspell = false;
			local findspn = false;
			local findID = false;
			if ( data.filter == "BUFF" ) then
				spn = GetSpellInfo( data.spellID )
 				for n = 1, 40 do
					if select(11, UnitBuff(data.unitId, n)) == data.spellID then
						name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff(data.unitId, n);
						findspell = true;
						break;
					end
				end
				if findspell == false then
					name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff(data.unitId or "Player", spn or "33763");

				end
			elseif ( data.filter == "DEBUFF" ) then
				spn = GetSpellInfo( data.spellID ) or Get
 				for n = 1, 40 do
					if select(11, UnitDebuff(data.unitId, n)) == data.spellID then
						name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitDebuff(data.unitId, n);
						findspell = true;
						break;
					end
				end
				if findspell == false then
					name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitDebuff(data.unitId or "Player", spn or "33763");
				end
			else
				if ( data.spellID ) then
					spn = GetSpellInfo( data.spellID )
					start, duration, enabled = GetSpellCooldown( spn );
					_,_,icon = GetSpellInfo( data.spellID );
				else
					slotLink = GetInventoryItemLink("player", data.slotID);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink);
						if ( not data.displayName ) then
							data.displayName = name;
						end
						start, duration, enabled = GetInventoryItemCooldown("player", data.slotID);
						
					end
				end
				count = 0;
				caster = "all";
				findID = true;
			end
			if ( not active[id] ) then
				active[id] = {};
			end
			for index, value in ipairs(active[id]) do
				if ( data.spellID == value.data.spellID ) then
					tremove(active[id], index);
					break;
				end
			end
			if ( ( name and ( data.caster ~= 1 and ( caster == data.caster or data.caster == "all" ) or MyUnits[caster] )) or ( ( enabled or 0 ) > 0 and ( duration or 0 ) > 1.5 ) ) then
				for key, value in pairs(active[id]) do
					if value.data.spellID then
						if GetSpellInfo(value.data.spellID) == spn then
							findspn = true;	
						end
					end
				end
				if findspn == false or findspell == true or findID == true then
					table.insert(active[id], { data = data, icon = icon, count = count, duration = duration, expirationTime = expirationTime or start });
				--	print(data.spellID or data.slotID);
				end
			end
		end
		Update(self);
	end
end

function init(self)
if ( Filger_Spells and Filger_Spells[class] ) then
	for index in pairs(Filger_Spells) do
		if ( index ~= class ) then
			Filger_Spells[index] = nil;
		end
	end
	local data, frame;
	for i=1, #Filger_Spells[class], 1 do
		data = Filger_Spells[class][i];
		frame = CreateFrame("Frame", "EuiFilter"..i, UIParent);
		frame.Id = i;
		frame.Name = data.Name;
		frame.Direction = data.Direction or "DOWN";
		frame.Interval = data.Interval or 2;
		frame.Mode = data.Mode or "ICON";
		frame.setPoint = data.setPoint or "CENTER";
		frame:SetWidth(Filger_Spells[class][i][1] and Filger_Spells[class][i][1].size or 100);
		frame:SetHeight(Filger_Spells[class][i][1] and Filger_Spells[class][i][1].size or 20);
		function frame:ADDON_LOADED(event, name)
			if(name ~= 'Eui') then
				frame:ClearAllPoints()
			end
		end
	--	if filterdb[frame.Name] ~= nil then
	--		frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', filterdb[data.Name]["x"], filterdb[data.Name]["y"]);
	--	else
			frame:SetPoint(unpack(data.setPoint));
	--	end
		function E.EuiFilterMove(frame)
			if E.Movers[frame:GetName()]["moved"] ~= true then
				frame:ClearAllPoints()
				for i = 1, #Filger_Spells[E.MyClass], 1 do
					local data = Filger_Spells[E.MyClass][i]
					if frame:GetName() == data.Name then
						frame:SetPoint(unpack(data.setPoint))
					end
				end
			end
		end
		if frame.Name == "playerbufficon" then E.CreateMover(frame, "EuiFilter"..i.."Mover", L.FILTER_1, nil, E.EuiFilterMove) end
		if frame.Name == "playerbuffbar" then E.CreateMover(frame, "EuiFilter"..i.."Mover", L.FILTER_2, nil, E.EuiFilterMove) end
		if frame.Name == "targetdebufficon" then E.CreateMover(frame, "EuiFilter"..i.."Mover", L.FILTER_3, nil, E.EuiFilterMove) end
		if frame.Name == "targetdebuffbar" then E.CreateMover(frame, "EuiFilter"..i.."Mover", L.FILTER_4, nil, E.EuiFilterMove) end
		if frame.Name == "playercdicon" then E.CreateMover(frame, "EuiFilter"..i.."Mover", L.FILTER_5, nil, E.EuiFilterMove) end
		
		if ( C["filter"].configmode ) then

		else
			for j=1, #Filger_Spells[class][i], 1 do
				data = Filger_Spells[class][i][j];
				if ( data.filter == "CD" ) then
					frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
					break;
				end
			end
			frame:RegisterEvent('ADDON_LOADED')
			frame:RegisterEvent("UNIT_AURA");
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			frame:SetScript("OnEvent", OnEvent);
		end
	end
end
end

local fff=CreateFrame("Frame",nil)
fff:RegisterEvent("PLAYER_ENTERING_WORLD");
fff:SetScript("OnEvent", function()
	fff:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local playerframe, targetframe, portrait
	portrait = 0
	if C["unitframe"].aaaaunit > 0 then
		playerframe = "Ljxx_playerFrame"
		targetframe = "Ljxx_targetFrame"
	else
		playerframe = UIParent
		targetframe = UIParent
	end
	if C["unitframe"].portrait == true and (C["unitframe"].aaaaunit == 1 or C["unitframe"].aaaaunit == 3) then
		portrait = C["unitframe"].playerheight + 6
	end		
	local playBuffBarHeight = 6
	if E.MyClass == 'SHAMAN' or E.MyClass == 'DEATHKNIGHT' or E.MyClass == 'DRUID' or E.MyClass == 'PALADIN' or E.MyClass == 'WARLOCK' then
		if C["unitframe"].aaaaunit == 1 or C["unitframe"].aaaaunit == 2 then
			playBuffBarHeight = 20
		else
			playBuffBarHeight = 16
		end
	end	
	local playBuffIconHeight = 235
	local playCDIconHeight = 190
	local iconsize
	if C["filter"].iconsize < 1 then iconsize = 30 else iconsize = C["filter"].iconsize end
	local cdsize
	if C["filter"].cdsize < 1 then cdsize = 30 else cdsize = C["filter"].cdsize end
		
	Filger_Spells = {
	["ROGUE"] = {		-- 盗贼
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
	},
	["DRUID"] = {		-- 德鲁伊
		{
			Name = "目标BUFF",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 30, unitId = "target", caster = "all", filter = "BUFF" },			-- 法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 53308, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },	-- 纠缠根须
			{ spellID = 33786, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },	-- 旋风
		},
	},
	["HUNTER"] = {		-- 猎人
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 34074, size = 30, unitId = "player", caster = "player", filter = "BUFF" }, --蝰蛇守护
			
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 49012, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--翼龙钉刺
			{ spellID = 34490, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--沉默射击
		},
	},
	["MAGE"] = {		--法师
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 72, unitId = "target", caster = "all", filter = "BUFF" }, 			-- 法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 118, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },	-- 变形术
		},
	},
	["WARRIOR"] = {		--战士
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
	},
	["SHAMAN"] = {		-- 萨满
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 30, unitId = "target", caster = "all", filter = "BUFF" },			-- 法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 7,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 51514, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--妖术
		},
	},
	["PALADIN"] = {		-- 圣骑士
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 60, unitId = "target", caster = "all", filter = "BUFF" }, --法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
	},
	["PRIEST"] = {		-- 牧师
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 60, unitId = "target", caster = "all", filter = "BUFF" },--法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 10955, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--束缚亡灵
			{ spellID = 10890, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--心灵尖啸
			{ spellID = 15487, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--沉默
		},
	},
	["WARLOCK"] = {		-- 术士
		{
			Name = "目标BUFF",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = {  "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 235 },
			
			{ spellID = 23920, size = 60, unitId = "target", caster = "all", filter = "BUFF" },--法术反射
		},

		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 5782, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--恐惧
			{ spellID = 710, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--放逐术
			{ spellID = 11719, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--语言诅咒
		},
	},
	["DEATHKNIGHT"] = {		-- 死亡骑士
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
         --變羊
            { spellID = 118, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --制裁之錘
            { spellID = 853, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --腎擊
            { spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --啃食
            { spellID = 47481, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --沉默
            { spellID = 55021, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --傷殘術
            { spellID = 22570, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --斷筋
           { spellID = 1715, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
         --致殘毒藥
           { spellID = 3775, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
	},
}

--启用玩家冷却图标提示
	if C["filter"].pcdicon == true then
		table.insert(Filger_Spells["ROGUE"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})

		table.insert(Filger_Spells["DRUID"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 10, size = cdsize, filter = "CD" },
			{ slotID = 13, size = cdsize, filter = "CD" },			-- 饰品1
			{ slotID = 14, size = cdsize, filter = "CD" },			-- 饰品2		
		})
		
		table.insert(Filger_Spells["HUNTER"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})		
		
		table.insert(Filger_Spells["MAGE"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})		
		
		table.insert(Filger_Spells["WARRIOR"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})	

		table.insert(Filger_Spells["SHAMAN"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})
		
		table.insert(Filger_Spells["PALADIN"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})		
		
		table.insert(Filger_Spells["PRIEST"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})		
		
		table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})

		table.insert(Filger_Spells["DEATHKNIGHT"],
		{
			Name = "playercdicon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playCDIconHeight },
			
			{ slotID = 13, size = cdsize, filter = "CD" },
			{ slotID = 14, size = cdsize, filter = "CD" },
			{ slotID = 10, size = cdsize, filter = "CD" },
		})
		
	end

--启用玩家BUFF图标提示
	if C["filter"].pbufficon == true then
	table.insert(Filger_Spells["ROGUE"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 3,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight },
			
			{ spellID = 13750, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 冲动
		})
		
	table.insert(Filger_Spells["DRUID"],	
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight },

			{ spellID = 22812, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 树皮术
		})
		
	table.insert(Filger_Spells["HUNTER"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 56453, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--荷枪实弹

		})

	table.insert(Filger_Spells["MAGE"],	
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 44544, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 寒冰指
			{ spellID = 36032, size = iconsize, unitId = "player", caster = "player", filter = "DEBUFF" },       -- 奥术冲击
		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 52437, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--猝死

		})
		
	table.insert(Filger_Spells["SHAMAN"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 12536, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--节能施法

		})
		
	table.insert(Filger_Spells["PALADIN"],
		{
			Name = "playerbufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 54428, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 神圣恳求

		})
		
	table.insert(Filger_Spells["PRIEST"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 586, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--渐隐术

		})
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 63321, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --生命分流雕文
		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 50880, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--冰冷之抓

		})

	end

--启用目标DEBUFF图标
	if C["filter"].tdebufficon == true then
	table.insert(Filger_Spells["ROGUE"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 2094, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 致盲

		})
		
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 770, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },			-- 精灵之火
		
		})		

	table.insert(Filger_Spells["HUNTER"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 1130, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" }, --猎人印记
				
		})
	table.insert(Filger_Spells["PALADIN"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 54499, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--十字军之心

		})		
	table.insert(Filger_Spells["MAGE"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 31589, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 减速
	
		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 47486, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },--致死打击
		})
		
	table.insert(Filger_Spells["SHAMAN"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 49233, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--烈焰震击
		})		

	table.insert(Filger_Spells["PRIEST"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 48125, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --痛

		})		
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 11719, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--语言诅咒

		})		

	table.insert(Filger_Spells["DEATHKNIGHT"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 59879, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--血之疫病
			{ spellID = 59921, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--冰霜疫病

		})	
	end		
		
--启用玩家BUFF计时条
	if C["filter"].pbuffbar == true then
	table.insert(Filger_Spells["ROGUE"],
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },


			{ spellID = 13750, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 冲动
		})
			
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },
			
			{ spellID = 50334, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 狂暴
		
		})
		
	table.insert(Filger_Spells["HUNTER"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },

			{ spellID = 34503, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--破甲虚弱
		})
		
	table.insert(Filger_Spells["MAGE"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		

			{ spellID = 44544, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 寒冰指

		})
		
	table.insert(Filger_Spells["WARRIOR"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		

			{ spellID = 52437, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--猝死

		})

	table.insert(Filger_Spells["SHAMAN"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		

			{ spellID = 12536, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--节能施法

		})
	
	table.insert(Filger_Spells["PALADIN"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },

			{ spellID = 54428, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 神圣恳求

			
		})
	
	table.insert(Filger_Spells["PRIEST"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },	

			{ spellID = 33151, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "all", filter = "BUFF" },--圣光涌动

		})	
	
	table.insert(Filger_Spells["WARLOCK"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },	

			{ spellID = 63321, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --生命分流雕文
		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		

			{ spellID = 50880, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--冰冷之抓
		})
	
	end

--启用目标DEBUFF计时条
	if C["filter"].tdebuffbar == true then
	table.insert(Filger_Spells["ROGUE"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 2094, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 致盲

		})
	
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 770, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },			-- 精灵之火
		
		})
		
	table.insert(Filger_Spells["HUNTER"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 1130, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" }, --猎人印记
			

		})

	table.insert(Filger_Spells["MAGE"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },	

			{ spellID = 31589, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 减速

		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },		

			{ spellID = 47486, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },--致死打击
		})

	table.insert(Filger_Spells["SHAMAN"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },		

			{ spellID = 49233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--烈焰震击
		})
		
	table.insert(Filger_Spells["PRIEST"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 48068, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "BUFF" },--恢复

			
		})
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 172, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--腐蚀术

		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],	
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 59879, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--血之疫病

		})

	table.insert(Filger_Spells["PALADIN"],	
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 59879, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--血之疫病

		})
	end
	
	if filter then
		for n,v in pairs(filter) do
			if filter[n].barWidth then
				table.insert(Filger_Spells[E.MyClass][tonumber(filter[n].k)],{
					spellID = filter[n].spellID,
					size = C["filter"].barheight,
					unitId = filter[n].unitId,
					caster = filter[n].caster,
					barWidth = filter[n].barWidth,
					filter = filter[n].filter
				})
			elseif filter[n].filter == "CD" then
				table.insert(Filger_Spells[E.MyClass][tonumber(filter[n].k)],{
					spellID = filter[n].spellID,
					size = C["filter"].cdsize,
					filter = "CD"
				})
			else	
				table.insert(Filger_Spells[E.MyClass][tonumber(filter[n].k)],{
					spellID = filter[n].spellID,
					size = C["filter"].iconsize,
					unitId = filter[n].unitId,
					caster = filter[n].caster,
					filter = filter[n].filter
				})
			end
		end
	end	
	init()
end)