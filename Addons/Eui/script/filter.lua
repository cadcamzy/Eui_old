local E, C = unpack(select(2, ...))
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
			local spn = GetSpellInfo( value.data.spellID or value.data.slotID )
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
			bar = CreateFrame("Frame", "FilgerAnker"..id.."Frame"..index, self);
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
				if filterdb[self.Name]==nil then
					bar:SetPoint(unpack(self.setPoint));
				else
					bar:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', filterdb[self.Name]["x"], filterdb[self.Name]["y"])
				end			
				
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
				bar.count:SetFont(E.fontn, 10, "OUTLINE");
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
		bar.spellName = GetSpellInfo( value.data.spellID or value.data.slotID );
		
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
					name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff(data.unitId, spn);

				end
			elseif ( data.filter == "DEBUFF" ) then
				spn = GetSpellInfo( data.spellID )
 				for n = 1, 40 do
					if select(11, UnitDebuff(data.unitId, n)) == data.spellID then
						name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitDebuff(data.unitId, n);
						findspell = true;
						break;
					end
				end
				if findspell == false then
					name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitDebuff(data.unitId, spn);
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
					if GetSpellInfo(value.data.spellID) == spn then
						findspn = true;	
					end
				end
				if findspn == false or findspell == true then
					table.insert(active[id], { data = data, icon = icon, count = count, duration = duration, expirationTime = expirationTime or start });
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
		frame = CreateFrame("Frame", "FilgerAnker"..i, UIParent);
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
		if filterdb[frame.Name] ~= nil then
			frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', filterdb[data.Name]["x"], filterdb[data.Name]["y"]);
		else
			frame:SetPoint(unpack(data.setPoint));
		end
		
		if ( C["filter"].configmode ) then
			frame:SetFrameStrata("DIALOG");
			frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "", insets = { left = 0, right = 0, top = 0, bottom = 0 }});
			E.EuiSetTemplate(frame)
			if frame.Name ~= "playerbufficon" and frame.Name ~= "playerbuffbar" and frame.Name ~= "targetdebufficon" and frame.Name ~= "targetdebuffbar" then frame:Hide() end

			frame:SetMovable(true);
			frame:EnableMouse(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", function(self)
				if(IsShiftKeyDown() or IsAltKeyDown()) then
					self:StartMoving()
				end
			end);
			frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing();
				local x, y = self:GetCenter()
				if (filterdb[self.Name]==nil) then filterdb[self.Name]={}; end
				filterdb[self.Name]["x"]=floor(x+0.5)
				filterdb[self.Name]["y"]=floor(y+0.5)
			end);
			
			frame.text = frame:CreateFontString(nil, "OVERLAY");
			frame.text:SetFont(E.font, 12, "OUTLINE");
			frame.text:SetPoint("CENTER");
			frame.text:SetText(data.Name and data.Name or "FilgerAnker"..i);
			
			for j=1, #Filger_Spells[class][i], 1 do
				data = Filger_Spells[class][i][j];
				if ( not active[i] ) then
					active[i] = {};
				end
				if ( data.spellID ) then
					_,_,spellIcon = GetSpellInfo(data.spellID)
				else
					slotLink = GetInventoryItemLink("player", data.slotID);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, spellIcon = GetItemInfo(slotLink);
					end
				end
				table.insert(active[i], { data = data, icon = spellIcon, count = 9, duration = 0, expirationTime = 0 });
			end
		--	Update(frame);
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
	if C["unitframe"].aaaaunit == 1 then
		playerframe = "oUF_LjxxPlayerPlayer"
		targetframe = "oUF_LjxxTargetTarget"
		if C["unitframe"].portrait == true then
			portrait = C["unitframe"].playerheight + 6
		end	
	elseif C["unitframe"].aaaaunit == 2 then
		playerframe = "oUF_monoPlayerFrame"
		targetframe = "oUF_monoTargetFrame"
	elseif C["unitframe"].aaaaunit == 3 then
		playerframe = "oUF_AftermathhPlayer"
		targetframe = "oUF_AftermathhTarget"
		if C["unitframe"].portrait == true then
			portrait = C["unitframe"].totheight + C["unitframe"].playerheight + 18
		end
	elseif C["unitframe"].aaaaunit == 4 then
		playerframe = "oUF_LjxxB_Player"
		targetframe = "oUF_LjxxB_Target"	
	else
		playerframe = UIParent
		targetframe = UIParent
	end
	local playBuffBarHeight = 5
	if E.MyClass == 'SHAMAN' or E.MyClass == 'DEATHKNIGHT' then playBuffBarHeight = 12 end
	if C["unitframe"].aaaaunit == 4 then playBuffBarHeight = 30 end
	if E.MyClass == 'SHAMAN' or E.MyClass == 'DEATHKNIGHT' and C["unitframe"].aaaaunit == 1 then playBuffBarHeight = 18 end
	local playBuffIconHeight
	playBuffIconHeight = 235
	local iconsize
	if C["filter"].iconsize < 1 then iconsize = 30 else iconsize = C["filter"].iconsize end
	Filger_Spells = {
	["ROGUE"] = {		-- 盗贼
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 灼热之光
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 重力炸弹
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 不稳定的能量
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 无面者的印记
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 萨隆邪铁蒸汽
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 肾击
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 沉默 - 圣殿骑士之盾
		},
	--[[	{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
			{ spellID = 50613, size = 30, filter = "CD" },		-- 奥流之术
			{ spellID = 11305, size = 30, filter = "CD" },		-- 疾跑
			{ spellID = 1766, size = 30, filter = "CD" },		-- 脚踢
			{ spellID = 5277, size = 30, filter = "CD" },		-- 闪避
			{ spellID = 31224, size = 30, filter = "CD" },		-- 暗影斗篷
			{ spellID = 7744, size = 30, filter = "CD" },		-- 亡灵意志
			{ spellID = 13877, size = 30, filter = "CD" },		-- 剑刃乱舞
			{ spellID = 13750, size = 30, filter = "CD" },		-- 冲动
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 灼热之光
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 重力炸弹
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 不稳定的能量
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 无面者的印记
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 萨隆邪铁蒸汽
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 肾击
			{ spellID = 2139, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 法术反制
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 沉默 - 圣殿骑士之盾
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

	--[[	{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 48438, size = 30, filter = "CD" },		-- 野性成长
			{ spellID = 18562, size = 30, filter = "CD" },		-- 迅捷治愈
			{ spellID = 22812, size = 30, filter = "CD" },		-- 树皮术
			{ spellID = 33878, size = 30, filter = "CD" },		-- 裂伤（熊）
			{ spellID = 53312, size = 30, filter = "CD" },		-- 自然之握
			{ spellID = 53201, size = 30, filter = "CD" },		-- 星辰坠落
			{ spellID = 61676, size = 30, filter = "CD" },		-- 低吼
			{ spellID = 5229, size = 30, filter = "CD" },		-- 激怒
			{ spellID = 16857, size = 30, filter = "CD" },		-- 精灵之火（野性）
			{ spellID = 16979, size = 30, filter = "CD" },		-- 野性冲锋 - 熊
			{ spellID = 49376, size = 30, filter = "CD" },		-- 野性冲锋 - 豹
			{ spellID = 8983, size = 30, filter = "CD" },		-- 猛击
			{ spellID = 49802, size = 30, filter = "CD" },		-- 割碎
			{ spellID = 48575, size = 30, filter = "CD" },		-- 畏缩
			{ slotID = 13, size = 30, filter = "CD" },			-- 饰品1
			{ slotID = 14, size = 30, filter = "CD" },			-- 饰品2
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 灼热之光
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 重力炸弹
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 不稳定的能量
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 无面者的印记
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 萨隆邪铁蒸汽
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 肾击
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 沉默 - 圣殿骑士之盾
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
--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 53301, size = 30, filter = "CD" },--爆炸射击
			{ spellID = 19434, size = 30, filter = "CD" },--瞄准射击
			{ spellID = 781, size = 30, filter = "CD" },--逃脱
			{ spellID = 34477, size = 30, filter = "CD" },--误导
			{ spellID = 34026, size = 30, filter = "CD" },--杀戮命令
			{ spellID = 28728, size = 30, filter = "CD" },--假死
			{ spellID = 14311, size = 30, filter = "CD" },--冰冻陷阱
			{ spellID = 49012, size = 30, filter = "CD" },--翼龙钉刺
			{ spellID = 14327, size = 30, filter = "CD" },--恐吓野兽
			{ spellID = 53271, size = 30, filter = "CD" },--主人的召唤
			{ spellID = 19263, size = 30, filter = "CD" },--威慑
			{ spellID = 5116, size = 30, filter = "CD" },--震荡射击
			{ spellID = 48999, size = 30, filter = "CD" },--反击
			{ spellID = 53339, size = 30, filter = "CD" },--猫鼬撕咬
			{ spellID = 19577, size = 30, filter = "CD" },--胁迫
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
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
			
			{ spellID = 63023, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 灼热之光
			{ spellID = 63025, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 重力炸弹
			{ spellID = 62865, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 不稳定的能量
			{ spellID = 63276, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 无面者的印记
			{ spellID = 63322, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 萨隆邪铁蒸汽
			{ spellID = 6770, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 闷棍
			{ spellID = 408, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" }, 			-- 肾击
			{ spellID = 2139, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 法术反制
			{ spellID = 63529, size = 72, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 沉默 - 圣殿骑士之盾
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 118, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },	-- 变形术
		},

--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 1953, size = 30, filter = "CD" },--闪现
			{ spellID = 11831, size = 30, filter = "CD" },--冰霜新星
			{ spellID = 11426, size = 30, filter = "CD" },--寒冰护体
			{ spellID = 2139, size = 30, filter = "CD" },--法术反制
			{ spellID = 44572, size = 30, filter = "CD" },--深度冻结
			{ spellID = 6143, size = 30, filter = "CD" },--防护冰霜结界
			{ spellID = 12043, size = 30, filter = "CD" },--气定神闲
			{ spellID = 12042, size = 30, filter = "CD" },--奥术强化
			{ spellID = 42945, size = 30, filter = "CD" },--冲击波
			{ spellID = 42950, size = 30, filter = "CD" },--龙息术
			{ spellID = 42931, size = 30, filter = "CD" },--冰锥术
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
	},
	["WARRIOR"] = {		--战士
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 3411, size = 30, filter = "CD" },--援护
			{ spellID = 47488, size = 30, filter = "CD" },--盾牌猛击
			{ spellID = 1680, size = 30, filter = "CD" },--旋风斩
			{ spellID = 47486, size = 30, filter = "CD" },--致死打击
			{ spellID = 47502, size = 30, filter = "CD" },--雷霆一击
			{ spellID = 57823, size = 30, filter = "CD" },--复仇
			{ spellID = 7384, size = 30, filter = "CD" },--压制
			{ spellID = 6552, size = 30, filter = "CD" },--拳击
			{ spellID = 72, size = 30, filter = "CD" },--盾击
			{ spellID = 11578, size = 30, filter = "CD" },--冲锋
			{ spellID = 20252, size = 30, filter = "CD" },--拦截
			{ spellID = 2687, size = 30, filter = "CD" },--血性狂暴
			{ spellID = 18449, size = 30, filter = "CD" },--狂暴之怒			
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 灼热之光
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 重力炸弹
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 不稳定的能量
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 无面者的印记
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 萨隆邪铁蒸汽
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 闷棍
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },			-- 肾击
			{ spellID = 2139, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 法术反制
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },		-- 沉默 - 圣殿骑士之盾
		},
		
		{
			Name = "焦点DEBUFF",
			Direction = "UP",
			Interval = 7,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "TOPRIGHT", 5, 28 },
			
			{ spellID = 51514, size = 16, barWidth = 181, scale = 1, unitId = "focus", caster = "player", filter = "DEBUFF" },--妖术
		},

--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 49231, size = 30, filter = "CD" },--大地震击
			{ spellID = 61301, size = 30, filter = "CD" },--激流
			{ spellID = 59159, size = 30, filter = "CD" },--雷霆风暴
			{ spellID = 60043, size = 30, filter = "CD" },--熔岩爆裂
			{ spellID = 60103, size = 30, filter = "CD" },--熔岩猛击
			{ spellID = 49271, size = 30, filter = "CD" },--闪电链
			{ spellID = 57994, size = 30, filter = "CD" },--风剪
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 2139, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},

	--[[	{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 20066, size = 30, filter = "CD" },--忏悔
			{ spellID = 62124, size = 30, filter = "CD" },--清算之手
			{ spellID = 1044, size = 30, filter = "CD" },--自由之手
			{ spellID = 20271, size = 30, filter = "CD" },--圣光审判
			{ spellID = 31789, size = 30, filter = "CD" },--正义防御
			{ spellID = 48801, size = 30, filter = "CD" },--驱邪术
			{ spellID = 10308, size = 30, filter = "CD" },--制裁之锤
			{ spellID = 48819, size = 30, filter = "CD" },--奉献
			{ spellID = 48806, size = 30, filter = "CD" },--愤怒之锤
			{ spellID = 48825, size = 30, filter = "CD" },--神圣震击
			{ spellID = 48952, size = 30, filter = "CD" },--神圣之盾
			{ spellID = 48827, size = 30, filter = "CD" },--复仇者之盾
			{ spellID = 54428, size = 30, filter = "CD" },--神圣恳求
			{ spellID = 61411, size = 30, filter = "CD" },--正义盾击
			{ spellID = 48817, size = 30, filter = "CD" },--神圣愤怒
			{ spellID = 31821, size = 30, filter = "CD" },--光环掌握
			{ spellID = 35395, size = 30, filter = "CD" },--十字军打击
			{ spellID = 20216, size = 30, filter = "CD" },--神恩术
			{ spellID = 53385, size = 30, filter = "CD" },--神圣风暴
			{ spellID = 53595, size = 30, filter = "CD" },--正义之锤
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 2139, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
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

--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 53007, size = 30, filter = "CD" },--苦修
			{ spellID = 33206, size = 30, filter = "CD" },--痛苦压制
			{ spellID = 10060, size = 30, filter = "CD" },--能量灌注
			{ spellID = 10890, size = 30, filter = "CD" },--心灵尖啸
			{ spellID = 48089, size = 30, filter = "CD" },--治疗之环
			{ spellID = 47788, size = 30, filter = "CD" },--守护之魂
			{ spellID = 48113, size = 30, filter = "CD" },--愈合祷言
			{ spellID = 15487, size = 30, filter = "CD" },--沉默
			{ spellID = 48066, size = 30, filter = "CD" },--真言术：盾
			{ spellID = 48135, size = 30, filter = "CD" },--神圣之火
			{ spellID = 48158, size = 30, filter = "CD" },--暗言术：灭
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
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
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 2139, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
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

--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 48438, size = 30, filter = "CD" },--野性成长(XD)?
			{ spellID = 47843, size = 30, filter = "CD" },--痛苦无常
			{ spellID = 59164, size = 30, filter = "CD" },--鬼影缠身
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
	},
	["DEATHKNIGHT"] = {		-- 死亡骑士
		{
			Name = "自身DEBUFF",
			Direction = "UP",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", playerframe, "TOPRIGHT", 0, 320 },
			
			{ spellID = 63023, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63025, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 62865, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63276, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63322, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 6770, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 408, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
			{ spellID = 63529, size = 60, unitId = "player", caster = "all", filter = "DEBUFF" },
		},

--[[		{
			Name = "冷却",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, 202 },
			
			{ spellID = 49206, size = 30, filter = "CD" },--召唤石像鬼
			{ spellID = 47481, size = 30, filter = "CD" },--撕扯
			{ spellID = 47476, size = 30, filter = "CD" },--绞袭
			{ slotID = 13, size = 30, filter = "CD" },
			{ slotID = 14, size = 30, filter = "CD" },
		},]]
	},
}

--启用玩家BUFF图标提示
	if C["filter"].pbufficon == true then
	table.insert(Filger_Spells["ROGUE"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 3,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight },
			
			{ spellID = 51662, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 血之饥渴
			{ spellID = 6774, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 切割
			{ spellID = 13877, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 剑刃乱舞
			{ spellID = 13750, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 冲动
		})
		
	table.insert(Filger_Spells["DRUID"],	
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight },

			{ spellID = 33763, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 生命绽放
			{ spellID = 774, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 回春术
			{ spellID = 8936, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 愈合
			{ spellID = 2893, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 驱毒术
			{ spellID = 61336, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 生存本能
			{ spellID = 52610, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 凶蛮咆哮
			{ spellID = 50334, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 狂暴
			{ spellID = 22812, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 树皮术
			{ spellID = 69369, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 掠食者的迅捷
			{ spellID = 48525, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 月蚀
			{ spellID = 16870, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 节能施法
			{ spellID = 60235, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(精神值提高300点)
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(智力提高300点)
			{ spellID = 60233, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(敏捷提高300点)
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 生命精华(法术急速等级提高505)
			{ spellID = 48517, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 日蚀
			{ spellID = 48518, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 月蚀
		})
		
	table.insert(Filger_Spells["HUNTER"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 56453, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--荷枪实弹
			{ spellID = 60314, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--五色巨龙之怒(饰品)
			{ spellID = 60233, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(敏捷)
			{ spellID = 65019, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--雷神符石(饰品)
			{ spellID = 6150, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --快速射击
			{ spellID = 34837, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--战术大师
			{ spellID = 53224, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--强化稳固射击
			{ spellID = 34503, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--破甲虚弱
		})

	table.insert(Filger_Spells["MAGE"],	
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 44544, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 寒冰指
			{ spellID = 57761, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 火球
			{ spellID = 44448, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 法术连击
			{ spellID = 54490, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 飞弹速射
			{ spellID = 12536, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 节能施法
			{ spellID = 12358, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 冲击
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 伟大
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 生命精华
			{ spellID = 36032, size = iconsize, unitId = "player", caster = "player", filter = "DEBUFF" },       -- 奥术冲击
		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 23920, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--法术反射
			{ spellID = 64568, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--储备血浆(FM)
			{ spellID = 52437, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--猝死
			{ spellID = 46916, size = iconsize, unitId = "player", caster = "all", filter = "BUFF" },--猛击！
			{ spellID = 50227, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--剑盾猛攻
			{ spellID = 60229, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(力量)
		})
		
	table.insert(Filger_Spells["SHAMAN"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 2825, size = iconsize, unitId = "player", caster = "all", filter = "BUFF" },	-- 嗜血
			{ spellID = 49281, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--闪电之盾
			{ spellID = 57960, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--水之护盾
			{ spellID = 49284, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--大地之盾
			{ spellID = 51994, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--践踏(牛头人)
			{ spellID = 32182, size = iconsize, unitId = "player", caster = "all", filter = "BUFF" },--英勇
		--	{ spellID = 51470, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--元素之誓
			{ spellID = 12536, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--节能施法
			{ spellID = 51566, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--波涛汹涌
			{ spellID = 51532, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--漩涡武器
			{ spellID = 60235, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(精神值提高300点)
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(智力提高300点)
			{ spellID = 60233, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(敏捷提高300点)
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },-- 生命精华(法术急速等级提高505)
		})
		
	table.insert(Filger_Spells["PALADIN"],
		{
			Name = "playerbufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 54155, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 纯洁审判
			{ spellID = 53601, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 圣洁护盾
			{ spellID = 54149, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 圣光灌注
			{ spellID = 54428, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 神圣恳求
			{ spellID = 60235, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(精神值提高300点)
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(智力提高300点)
			{ spellID = 60233, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(敏捷提高300点)
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },		-- 生命精华(法术急速等级提高505)
			{ spellID = 59578, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --战争艺术
			{ spellID = 31834, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },  --圣光之赐
		})
		
	table.insert(Filger_Spells["PRIEST"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 48066, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--真言术：盾
			{ spellID = 25222, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--恢复
			{ spellID = 586, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--渐隐术
			{ spellID = 6346, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--防护恐惧结界
			{ spellID = 33151, size = iconsize, unitId = "player", caster = "all", filter = "BUFF" },--圣光涌动
			{ spellID = 63734, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--好运
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(智力)
			{ spellID = 60235, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(精神)
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--生命精华
		})
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},
			{ spellID = 60235, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(精神)
			{ spellID = 60234, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(智力)
			{ spellID = 60062, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--生命精华
			{ spellID = 47383, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--熔火之心
			{ spellID = 63158, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--灭杀
			{ spellID = 54277, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--爆燃
			{ spellID = 18095, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --夜幕
			{ spellID = 34939, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --反冲
			{ spellID = 63321, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" }, --生命分流雕文
		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],
		{
			Name = "playerbufficon",
			Direction = "RIGHT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffIconHeight},

			{ spellID = 60229, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--伟大(力量)
			{ spellID = 66817, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--孤寂
			{ spellID = 53365, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--不洁之力(符文)
			{ spellID = 65014, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--蓝铁灌注(饰品)
			{ spellID = 67117, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--不洁之能
			{ spellID = 49509, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--血之气息
			{ spellID = 50449, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--鲜血复仇
			{ spellID = 55233, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--吸血鬼之血
			{ spellID = 50880, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--冰冷之抓
			{ spellID = 49039, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--巫妖之躯
			{ spellID = 51271, size = iconsize, unitId = "player", caster = "player", filter = "BUFF" },--铜墙铁壁
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
			{ spellID = 50613, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 奥流之术
			{ spellID = 8647, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 破甲
			{ spellID = 6770, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 闷棍
			{ spellID = 6409, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 偷袭
			{ spellID = 51722, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 拆卸
			{ spellID = 408, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 肾击
			{ spellID = 26679, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致命投掷
			{ spellID = 1943, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 割裂
			{ spellID = 703, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 锁喉
			{ spellID = 1776, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 凿击
			{ spellID = 2094, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 致盲
			{ spellID = 16511, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 出血
			{ spellID = 3408, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 减速药膏
			{ spellID = 27186, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致命药膏
			{ spellID = 57978, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致伤药膏
			{ spellID = 57982, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 麻醉药膏
			{ spellID = 51693, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 打劫
			{ spellID = 1766, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 脚踢
		})
		
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 33982, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 裂伤（豹）
			{ spellID = 1822, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 斜掠
			{ spellID = 1079, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 割裂
			{ spellID = 33878, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 裂伤（熊）
			{ spellID = 33745, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 割伤
			{ spellID = 99, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 挫志咆哮
			{ spellID = 48463, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 月火术
			{ spellID = 48468, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 虫群
			{ spellID = 770, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },			-- 精灵之火
			{ spellID = 26989, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },		-- 纠缠根须			
		})		

	table.insert(Filger_Spells["HUNTER"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 49001, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 毒蛇钉刺
			{ spellID = 63672, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 黑箭
			{ spellID = 1130, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" }, --猎人印记
			{ spellID = 3043, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --毒蝎钉刺
			{ spellID = 60053, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --爆炸射击
			{ spellID = 49050, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --瞄准射击					
		})
	table.insert(Filger_Spells["PALADIN"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },

			{ spellID = 20271, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--圣光审判
			{ spellID = 20186, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--智慧审判
			{ spellID = 54499, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--十字军之心
			{ spellID = 53742, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--血之腐蚀
		})		
	table.insert(Filger_Spells["MAGE"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 36032, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 奥术冲击
			{ spellID = 22959, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },          -- 强化灼烧
			{ spellID = 31589, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 减速
			{ spellID = 12848, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 点燃
			{ spellID = 55360, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 活动炸弹	
		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 1715, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },--断筋
			{ spellID = 47465, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--撕裂
			{ spellID = 7386, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },--破甲攻击
			{ spellID = 6343, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--雷霆一击
			{ spellID = 1160, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--挫志怒吼
			{ spellID = 64850, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },--冷酷突击
			{ spellID = 47486, size = iconsize, unitId = "target", caster = "all", filter = "DEBUFF" },--致死打击
		})
		
	table.insert(Filger_Spells["SHAMAN"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 49231, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--大地震击
			{ spellID = 49236, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--冰霜震击
			{ spellID = 49233, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--烈焰震击
		})		

	table.insert(Filger_Spells["PRIEST"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 48068, size = iconsize, unitId = "target", caster = "player", filter = "BUFF" },--恢复
			{ spellID = 41637, size = iconsize, unitId = "target", caster = "player", filter = "BUFF" },--愈合祷言
			{ spellID = 47788, size = iconsize, unitId = "target", caster = "player", filter = "BUFF" },--守护之魂
			{ spellID = 33206, size = iconsize, unitId = "target", caster = "player", filter = "BUFF" },--痛苦压制
			{ spellID = 48125, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --痛
			{ spellID = 48300, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --噬灵疫病
			{ spellID = 48160, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --吸血鬼之触
		})		
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "targetdebufficon",
			Direction = "LEFT",
			Interval = 2,
			Mode = "ICON",
			setPoint = { "BOTTOMRIGHT", targetframe, "TOPRIGHT", 0, 202 },
			{ spellID = 172, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--腐蚀术
			{ spellID = 348, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--献祭
			{ spellID = 980, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--痛苦诅咒
			{ spellID = 47867, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--厄运诅咒
			{ spellID = 11719, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--语言诅咒
			{ spellID = 47843, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--痛苦无常
			{ spellID = 59164, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" }, --鬼影缠身
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
			{ spellID = 49194, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--邪恶虫群
			{ spellID = 49206, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--召唤石像鬼
			{ spellID = 49005, size = iconsize, unitId = "target", caster = "player", filter = "DEBUFF" },--鲜血印记
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

			{ spellID = 51662, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 血之饥渴
			{ spellID = 6774, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 切割
			{ spellID = 13877, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 剑刃乱舞
			{ spellID = 13750, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 冲动
		})
			
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },
			
			{ spellID = 69369, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 掠食者的迅捷
			{ spellID = 48525, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 月蚀
			{ spellID = 16870, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 节能施法
			{ spellID = 52610, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 凶蛮咆哮
			{ spellID = 60233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 伟大(敏捷提高300点)
			{ spellID = 50334, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 狂暴
			{ spellID = 50213, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 猛虎之怒
			{ spellID = 48517, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 日蚀
			{ spellID = 48518, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 月蚀			
		})
		
	table.insert(Filger_Spells["HUNTER"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },

			{ spellID = 56453, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--荷枪实弹
			{ spellID = 60314, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--五色巨龙之怒(饰品)
			{ spellID = 60233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(敏捷)
			{ spellID = 65019, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--雷神符石(饰品)
			{ spellID = 6150, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --快速射击
			{ spellID = 34837, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--战术大师
			{ spellID = 53224, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--强化稳固射击
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
			{ spellID = 57761, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 火球
			{ spellID = 44448, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 法术连击
			{ spellID = 54490, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 飞弹速射
			{ spellID = 12536, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 节能施法
			{ spellID = 12358, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 冲击
			{ spellID = 60234, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 伟大
			{ spellID = 60062, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, 			-- 生命精华
			{ spellID = 36032, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "DEBUFF" },       -- 奥术冲击
		})
		
	table.insert(Filger_Spells["WARRIOR"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		
			{ spellID = 52437, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--猝死
			{ spellID = 46916, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "all", filter = "BUFF" },--猛击！
			{ spellID = 50227, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--剑盾猛攻
			{ spellID = 60229, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(力量)
		})

	table.insert(Filger_Spells["SHAMAN"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		
			{ spellID = 12536, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--节能施法
			{ spellID = 51566, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--波涛汹涌
			{ spellID = 51532, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--漩涡武器
			{ spellID = 60235, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(精神值提高300点)
			{ spellID = 60234, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(智力提高300点)
			{ spellID = 60233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 伟大(敏捷提高300点)
			{ spellID = 60062, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 生命精华(法术急速等级提高505)
		--	{ spellID = 67696, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 自慰
			{ spellID = 71570, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 望远镜
		--	{ spellID = 67385, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },-- 
		})
	
	table.insert(Filger_Spells["PALADIN"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },
			{ spellID = 54155, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 纯洁审判
			{ spellID = 53601, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 圣洁护盾
			{ spellID = 54149, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 圣光灌注
			{ spellID = 54428, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 神圣恳求
			{ spellID = 60235, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(精神值提高300点)
			{ spellID = 60234, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(智力提高300点)
			{ spellID = 60233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 伟大(敏捷提高300点)
			{ spellID = 60062, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },		-- 生命精华(法术急速等级提高505)
			{ spellID = 59578, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --战争艺术
			{ spellID = 31834, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },  --圣光之赐
			{ spellID = 498, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 圣佑
			{ spellID = 1038, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 拯救之手
			{ spellID = 6940, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caset = "all", filter = "BUFF" },	-- 牺牲之手
			{ spellID = 64205, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caset = "all", filter = "BUFF" },	-- 神圣牺牲
			{ spellID = 60229, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 伟大(力量)
			{ spellID = 67753, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- H萨崔娜的抗阻甲虫
			{ spellID = 67699, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 萨崔娜的抗阻甲虫
			{ spellID = 70760, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },	-- 萨崔娜的抗阻甲虫
			
		})
	
	table.insert(Filger_Spells["PRIEST"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },	
			{ spellID = 33151, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "all", filter = "BUFF" },--圣光涌动
			{ spellID = 63734, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--好运
			{ spellID = 60234, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(智力)
			{ spellID = 60235, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(精神)
			{ spellID = 60062, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--生命精华
		})	
	
	table.insert(Filger_Spells["WARLOCK"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },	
			{ spellID = 60235, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(精神)
			{ spellID = 60234, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(智力)
			{ spellID = 60062, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--生命精华
			{ spellID = 47383, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--熔火之心
			{ spellID = 63158, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--灭杀
			{ spellID = 54277, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--爆燃
			{ spellID = 18095, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --夜幕
			{ spellID = 34939, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --反冲
			{ spellID = 63321, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" }, --生命分流雕文
		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],	
		{
			Name = "playerbuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", playerframe, "TOPLEFT", 0, playBuffBarHeight },		
			{ spellID = 60229, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--伟大(力量)
			{ spellID = 67383, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--不洁之力(圣印)
			{ spellID = 66817, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--孤寂
			{ spellID = 65014, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--蓝铁灌注(饰品)
			{ spellID = 67117, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--不洁之能
			{ spellID = 49509, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--血之气息
			{ spellID = 50449, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--鲜血复仇
			{ spellID = 55233, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--吸血鬼之血
			{ spellID = 50880, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--冰冷之抓
			{ spellID = 49039, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--巫妖之躯
			{ spellID = 51271, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "player", caster = "player", filter = "BUFF" },--铜墙铁壁
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
			
			{ spellID = 50613, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 奥流之术
			{ spellID = 8647, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 破甲
			{ spellID = 6770, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 闷棍
			{ spellID = 6409, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 偷袭
			{ spellID = 51722, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 拆卸
			{ spellID = 408, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 肾击
			{ spellID = 26679, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致命投掷
			{ spellID = 1943, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 割裂
			{ spellID = 703, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 锁喉
			{ spellID = 1776, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 凿击
			{ spellID = 2094, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 致盲
			{ spellID = 16511, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 出血
			{ spellID = 3408, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 减速药膏
			{ spellID = 27186, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致命药膏
			{ spellID = 57978, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 致伤药膏
			{ spellID = 57982, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 麻醉药膏
			{ spellID = 51693, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 打劫
			{ spellID = 1766, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },			-- 脚踢
		})
	
	table.insert(Filger_Spells["DRUID"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 33982, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 裂伤（豹）
			{ spellID = 1822, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 斜掠
			{ spellID = 1079, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 割裂
			{ spellID = 33878, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 裂伤（熊）
			{ spellID = 33745, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 割伤
			{ spellID = 99, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 挫志咆哮
			{ spellID = 48463, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 月火术
			{ spellID = 48468, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },	-- 虫群
			{ spellID = 770, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },			-- 精灵之火
			{ spellID = 26989, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },		-- 纠缠根须			
		})
		
	table.insert(Filger_Spells["HUNTER"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 49001, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 毒蛇钉刺
			{ spellID = 63672, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },		-- 黑箭
			{ spellID = 1130, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" }, --猎人印记
			{ spellID = 3043, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --毒蝎钉刺
			{ spellID = 60053, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --爆炸射击
			{ spellID = 49050, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --瞄准射击			

		})

	table.insert(Filger_Spells["MAGE"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },	
			{ spellID = 36032, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 奥术冲击
			{ spellID = 22959, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },          -- 强化灼烧
			{ spellID = 31589, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 减速
			{ spellID = 12848, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 点燃
			{ spellID = 55360, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },       -- 活动炸弹
		})
		
	table.insert(Filger_Spells["WARRIOR"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },		
			{ spellID = 1715, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },--断筋
			{ spellID = 47465, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--撕裂
			{ spellID = 7386, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },--破甲攻击
			{ spellID = 6343, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--雷霆一击
			{ spellID = 1160, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--挫志怒吼
			{ spellID = 64850, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },--冷酷突击
			{ spellID = 47486, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "all", filter = "DEBUFF" },--致死打击
		})

	table.insert(Filger_Spells["SHAMAN"],
		{		
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },		
			{ spellID = 49231, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--大地震击
			{ spellID = 49236, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--冰霜震击
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
			{ spellID = 41637, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "BUFF" },--愈合祷言
			{ spellID = 47788, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "BUFF" },--守护之魂
			{ spellID = 33206, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "BUFF" },--痛苦压制
			{ spellID = 48125, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --痛
			{ spellID = 48300, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --噬灵疫病
			{ spellID = 48160, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --吸血鬼之触
			
		})
		
	table.insert(Filger_Spells["WARLOCK"],
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 172, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--腐蚀术
			{ spellID = 348, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--献祭
			{ spellID = 980, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--痛苦诅咒
			{ spellID = 47867, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--厄运诅咒
			{ spellID = 11719, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--语言诅咒
			{ spellID = 47843, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--痛苦无常
			{ spellID = 59164, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" }, --鬼影缠身
		})
		
	table.insert(Filger_Spells["DEATHKNIGHT"],	
		{
			Name = "targetdebuffbar",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			setPoint = { "BOTTOMLEFT", targetframe, "BOTTOMRIGHT", 5, 0+portrait },
			
			{ spellID = 59879, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--血之疫病
			{ spellID = 59921, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--冰霜疫病
			{ spellID = 49194, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--邪恶虫群
			{ spellID = 49206, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--召唤石像鬼
			{ spellID = 49005, size = C["filter"].barheight, barWidth = C["unitframe"].playerwidth, unitId = "target", caster = "player", filter = "DEBUFF" },--鲜血印记
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