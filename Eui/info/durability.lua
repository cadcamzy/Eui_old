local E, C, L = unpack(EUI)
if C["info"].durability == 0 or C["info"].enable == false then return end

--状态报告
local MyData = {};
function StatReport_GetSpellText()
	local text = "";
	text = text..MyData.SSP..L.INFO_DURABILITY_STAT1;
	text = text..", ";
	text = text..MyData.SHIT..L.INFO_DURABILITY_STAT2;
	text = text..", ";
	text = text..format("%.1f%%", MyData.SCRIT)..L.INFO_DURABILITY_STAT3;
	text = text..", ";
	text = text..MyData.SHASTE..L.INFO_DURABILITY_STAT4;
	text = text..", ";
	text = text..MyData.MP..L.INFO_DURABILITY_STAT5;
	return text;
end

function StatReport_GetHealText()
	local text = "";
	text = text..MyData.SHP..L.INFO_DURABILITY_STAT6;
	text = text..", ";
	text = text..format("%.1f%%", MyData.SCRIT)..L.INFO_DURABILITY_STAT3;
	text = text..", ";
	text = text..MyData.SHASTE..L.INFO_DURABILITY_STAT4;
	text = text..", ";
	text = text..MyData.MP..L.INFO_DURABILITY_STAT5;
	text = text..", ";
	text = text..MyData.SMR.."/"..L.INFO_DURABILITY_STAT7;
	return text;
end

function StatReport_GetSpellAndHealText()
	local text = "";
	text = text..MyData.SSP..L.INFO_DURABILITY_STAT1;
	text = text..", ";
	text = text..MyData.SHP..L.INFO_DURABILITY_STAT6;
	text = text..", ";
	text = text..MyData.SHIT..L.INFO_DURABILITY_STAT2;
	text = text..", ";
	text = text..format("%.1f%%", MyData.SCRIT)..L.INFO_DURABILITY_STAT3;
	text = text..", ";
	text = text..MyData.SHASTE..L.INFO_DURABILITY_STAT4;
	text = text..", ";
	text = text..MyData.MP..L.INFO_DURABILITY_STAT5;
	text = text..", ";
	text = text..MyData.SMR.."/"..L.INFO_DURABILITY_STAT7;
	return text;
end

function StatReport_GetMeleeText()
	local text = "";
	text = text..MyData.MAP..L.INFO_DURABILITY_STAT8;
	text = text..", ";
	text = text..MyData.MHIT..L.INFO_DURABILITY_STAT2;
	text = text..", ";
	text = text..format("%.1f%%", MyData.MCRIT)..L.INFO_DURABILITY_STAT3;
	text = text..", ";
	text = text..MyData.MEXPER..L.INFO_DURABILITY_STAT9;
--	text = text..", ";
--	text = text..MyData.Penetr.."%破甲"
	return text;
end

function StatReport_GetRangedText()
	local text = "";
	text = text..MyData.RAP..L.INFO_DURABILITY_STAT8;
	text = text..", ";
	text = text..MyData.RHIT..L.INFO_DURABILITY_STAT2;
	text = text..", ";
	text = text..format("%.1f%%", MyData.RCRIT)..L.INFO_DURABILITY_STAT3;
--	text = text..", ";
--	text = text..MyData.Penetr.."%破甲"	
	return text;
end

function StatReport_GetTankText()
	local text = "";
	text = text..MyData.HP..L.INFO_DURABILITY_STAT10;
--	text = text..", ";
--	text = text..MyData.DEF.."防御";
	text = text..", ";
	text = text..format("%.1f%%", MyData.DODGE)..L.INFO_DURABILITY_STAT11;
	text = text..", ";
	text = text..format("%.1f%%", MyData.PARRY)..L.INFO_DURABILITY_STAT12;
	text = text..", ";
	text = text..format("%.1f%%", MyData.BLOCK)..L.INFO_DURABILITY_STAT13;
	text = text..", ";
	text = text..MyData.ARMOR..L.INFO_DURABILITY_STAT14;
	return text;
end

function StatReport_TalentData()
	local group = GetActiveTalentGroup(isInspect);
	-- Get points per tree, and set "primaryTree" to the tree with most points
	local primaryTree = 1;
	local current = {};
	for i = 1, 3 do
		local _, _, _, _, pointsSpent = GetTalentTabInfo(i,isInspect,nil,group);
		current[i] = pointsSpent;
		if (current[i] > current[primaryTree]) then
			primaryTree = i;
		end
	end
	local _, tabName = GetTalentTabInfo(primaryTree,isInspect,nil,group);
	current.tree = tabName;
	-- Az: Clear Inspect, as we are done using it
	if (isInspect) then
		ClearInspectPlayer();
	end
	-- Customise output. Use TipTac setting if it exists, otherwise just use formatting style one.
	local talentFormat = (TipTac_Config and TipTac_Config.talentFormat or 1);
	if (current[primaryTree] == 0) then
		current.format = "No Talents";
	elseif (talentFormat == 1) then
		current.format = " ("..current[1].."/"..current[2].."/"..current[3]..")";
	elseif (talentFormat == 2) then
		current.format = current.tree;
	elseif (talentFormat == 3) then
		current.format = current[1].."/"..current[2].."/"..current[3];
	end
	return current.tree or L.INFO_DURABILITY_NO, current.format

end

function StatReport_UnitAttackPower()
	local base, posBuff, negBuff = UnitAttackPower("player");
	return floor(base + posBuff + negBuff);
end

function StatReport_UnitRangedAttackPower()
	local base, posBuff, negBuff = UnitRangedAttackPower("player");
	return floor(base + posBuff + negBuff);
end

function StatReport_GetSpellBonusDamage()
	local SSP = GetSpellBonusDamage(2);
	for i=3, 7 do
		SSP = max(SSP, GetSpellBonusDamage(i));
	end
	return floor(SSP);
end

function StatReport_GetSpellCritChance()
	local SCRIT = GetSpellCritChance(2);
	for i=3, 7 do
		SCRIT = max(SCRIT, GetSpellCritChance(i));
	end
	return SCRIT;
end

function StatReport_UnitDefense()
	local baseDEF, posDEF = UnitDefense("player");
	return floor(baseDEF + posDEF);
end

function StatReport_UpdateMyData()
	MyData.Name = UnitName("player");							--名称
	MyData.LV = UnitLevel("player");							--等级
	MyData.CLASS, MyData.CLASS_EN = UnitClass("player");		--职业
	MyData.HP = UnitHealthMax("player");						--生命值
	MyData.MP = UnitManaMax("player");							--法力值
	MyData.TKEY, MyData.TDATA = StatReport_TalentData();		--天赋
	MyData.ILVL = GetAverageItemLevel();						--平均装备等级
	MyData.Mastery = format("%.2f", GetMastery());								--精通点数
	--基础属性
	MyData.STR = UnitStat("player", 1);							--力量
	MyData.AGI = UnitStat("player", 2);							--敏捷
	MyData.STA = UnitStat("player", 3);							--耐力
	MyData.INT = UnitStat("player", 4);							--智力
	MyData.SPI = UnitStat("player", 5);							--精神

	--近战
	MyData.MAP = StatReport_UnitAttackPower();					--强度
	MyData.MHIT = GetCombatRating(6);							--命中等级
	MyData.MCRIT = GetCritChance();								--爆击率%
	MyData.MEXPER = GetExpertise();								--精准
--	MyData.Penetr = floor(GetArmorPenetration());						--破甲等级
	--远程
	MyData.RAP = StatReport_UnitRangedAttackPower();			--强度
	MyData.RHIT = GetCombatRating(7);							--命中等级
	MyData.RCRIT = GetRangedCritChance();						--爆击率%
	--法术
	MyData.SSP = StatReport_GetSpellBonusDamage();				--伤害加成
	MyData.SHP = GetSpellBonusHealing();						--治疗加成
	MyData.SHIT = GetCombatRating(8);							--命中等级
	MyData.SCRIT = StatReport_GetSpellCritChance();				--爆击率
	MyData.SHASTE = GetCombatRating(20);						--急速等级
	MyData.SMR = floor(GetManaRegen()*5);						--法力回复（每5秒）
	--防御
	_,_,MyData.ARMOR = UnitArmor("player");						--护甲
	MyData.DEF = StatReport_UnitDefense();						--防御
	MyData.DODGE = GetDodgeChance();							--躲闪%
	MyData.PARRY = GetParryChance();							--招架%
	MyData.BLOCK = GetBlockChance();							--格挡%
	MyData.CRDEF = GetCombatRating(15);							--韧性
end



local durability = CreateFrame ("Frame", nil,UIParent)
	durability:SetWidth(70)
	durability:SetHeight(16)
--	durability:SetStatusBarTexture(E.normTex)
--	durability:SetStatusBarColor(0.31, 0.45, 0.63,.8)
--	durability:SetMinMaxValues(0,100)
--	durability:SetValue(0)
	durability:EnableMouse(true)
	
local name = durability:CreateFontString (nil,"OVERLAY")
	name:SetFont(E.fontn,13)
	name:SetJustifyH("RIGHT")
	name:SetShadowOffset(2,-2)
	name:SetPoint("CENTER",0,0)
--	name:SetTextColor(23/255,132/255,209/255)
		
local Slots = {
	[1] = {1, L.INFO_DURABILITY_SLOTS1, 1000},
	[2] = {3, L.INFO_DURABILITY_SLOTS2, 1000},
	[3] = {5, L.INFO_DURABILITY_SLOTS3, 1000},
	[4] = {6, L.INFO_DURABILITY_SLOTS4, 1000},
	[5] = {9, L.INFO_DURABILITY_SLOTS5, 1000},
	[6] = {10, L.INFO_DURABILITY_SLOTS6, 1000},
	[7] = {7, L.INFO_DURABILITY_SLOTS7, 1000},
	[8] = {8, L.INFO_DURABILITY_SLOTS8, 1000},
	[9] = {16, L.INFO_DURABILITY_SLOTS9, 1000},
	[10] = {17, L.INFO_DURABILITY_SLOTS10, 1000},
	[11] = {18, L.INFO_DURABILITY_SLOTS11, 1000}
}

local Total = 0
local current, max

local function OnEvent(self)
	
	local r,g,b
		
	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end

	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	
	if Total > 0 then
		local dura = floor(Slots[1][3]*100)
	--	durability:SetValue(dura)
		name:SetText(floor(Slots[1][3]*100).."%".."D")
	else
		name:SetText("100".."%".."D")
	end
		
	self:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L.INFO_DURABILITY_TIP1,floor(Slots[1][3]*100).." %",1,1,1,r,g,b)
		GameTooltip:AddDoubleLine(" ")
		for i = 1, 11 do
			if Slots[i][3] ~= 1000 then
				green = Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:AddDoubleLine(" ")
		GameTooltip:AddDoubleLine(L.INFO_DURABILITY_TIP2,"",0.92, 0.94, 0.15,1,1,1)
		GameTooltip:Show()	
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Total = 0
end
	
durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
durability:RegisterEvent("MERCHANT_SHOW")
durability:RegisterEvent("PLAYER_ENTERING_WORLD")
durability:SetScript("OnEvent", OnEvent)
durability:SetScript("OnMouseDown", function(self,arg1)
	if arg1=='LeftButton' then
		ToggleCharacter("PaperDollFrame")
	else
		--发送状态报告
		local msg = "EUI"..L.INFO_DURABILITY_TIP3
		StatReport_UpdateMyData()
		msg = msg..MyData.CLASS;
		msg = msg..", ";
		msg = msg..MyData.TKEY..L.INFO_DURABILITY_TIP4..MyData.TDATA;
		msg = msg..", ";
		msg = msg..L.INFO_DURABILITY_TIP5..MyData.ILVL;
		msg = msg..", ";
		msg = msg..L.INFO_DURABILITY_TIP6..MyData.Mastery;

		msg = msg..", ";
		if MyData.CLASS_EN == "MAGE" or MyData.CLASS_EN == "WARLOCK" then
			msg = msg..StatReport_GetSpellText();
		end
		if MyData.CLASS_EN == "ROGUE" then
			msg = msg..StatReport_GetMeleeText();
		end
		if MyData.CLASS_EN == "HUNTER" then
			msg = msg..StatReport_GetRangedText();
		end
		if MyData.CLASS_EN == "DRUID" then
			if MyData.TKEY == GetTalentTabInfo(1) then
				msg = msg..StatReport_GetSpellText();
			elseif MyData.TKEY == GetTalentTabInfo(2) then
				if MyData.DODGE > 30 then
					msg = msg..StatReport_GetTankText();
				else
					msg = msg..StatReport_GetMeleeText();
				end
			elseif MyData.TKEY == GetTalentTabInfo(3) then
				msg = msg..StatReport_GetHealText();
			else
				msg = msg..StatReport_GetMeleeText();
			end
		end
		if MyData.CLASS_EN == "SHAMAN" then
			if MyData.TKEY == GetTalentTabInfo(1) then
				msg = msg..StatReport_GetSpellText();
			elseif MyData.TKEY == GetTalentTabInfo(2) then
				msg = msg..StatReport_GetMeleeText();
			elseif MyData.TKEY == GetTalentTabInfo(3) then
				msg = msg..StatReport_GetHealText();
			else
				msg = msg..StatReport_GetMeleeText();
			end
		end
		if MyData.CLASS_EN == "PALADIN" then
			if MyData.TKEY == GetTalentTabInfo(1) then
				msg = msg..StatReport_GetHealText();
			elseif MyData.TKEY == GetTalentTabInfo(2) then
				msg = msg..StatReport_GetTankText();
			elseif MyData.TKEY == GetTalentTabInfo(3) then
				msg = msg..StatReport_GetMeleeText();
			else
				msg = msg..StatReport_GetMeleeText();
			end
		end
		if MyData.CLASS_EN == "PRIEST" then
			if MyData.TKEY == GetTalentTabInfo(1) then
				msg = msg..StatReport_GetSpellAndHealText();
			elseif MyData.TKEY == GetTalentTabInfo(2) then
				msg = msg..StatReport_GetHealText();
			elseif MyData.TKEY == GetTalentTabInfo(3) then
				msg = msg..StatReport_GetSpellText();
			else
				msg = msg..StatReport_GetSpellText();
			end
		end
		if MyData.CLASS_EN == "WARRIOR" then
			if MyData.TKEY == GetTalentTabInfo(1) then
				msg = msg..StatReport_GetMeleeText();
			elseif MyData.TKEY == GetTalentTabInfo(2) then
				msg = msg..StatReport_GetMeleeText();
			elseif MyData.TKEY == GetTalentTabInfo(3) then
				msg = msg..StatReport_GetTankText();
			else
				msg = msg..StatReport_GetMeleeText();
			end
		end
		if MyData.CLASS_EN == "DEATHKNIGHT" then
			if (MyData.DODGE + MyData.PARRY) > 35 then
				msg = msg..StatReport_GetTankText();
			else
				msg = msg..StatReport_GetMeleeText();
			end
		end

		if MyData.CRDEF > (200*(MyData.LV/70)) then
			msg = msg..", ";
			msg = msg..MyData.CRDEF..L.INFO_DURABILITY_TIP7;
		end	
		
		if IsAddOnLoaded("GearScoreLite") then
			msg = msg..", ";
			msg = msg.."GS:"..GearScore_GetScore(UnitName("player"), "player");
		end
		
		if ChatFrame1EditBox:IsShown() then
			ChatFrame1EditBox:Insert(msg);
		else
			local ExistMSG = ChatFrame1EditBox:GetText() or "";
			ChatFrame1EditBox:SetText(ExistMSG..msg);
			ChatEdit_SendText(ChatFrame1EditBox);
			ChatFrame1EditBox:SetText("");
			ChatFrame1EditBox:Hide();
		end
	end
end)
	
E.EuiInfo(C["info"].durability,durability)