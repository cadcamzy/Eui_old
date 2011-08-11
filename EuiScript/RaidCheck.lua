local E, C, L, DB = unpack(EUI)
if C["other"].raidcheck ~= true then return end
local join = string.join
local find = string.find
local format = string.format
local sort = table.sort
local floor = math.floor
local MaxGroup = 5

-------------------------------------------------------------------------------------------------------------------
--	团队Buff检查
-------------------------------------------------------------------------------------------------------------------
local function CheckRaidBuff()

	local CLASS_INDEX = {
		[1] = L.RaidCheckDRUID,
		[2] = L.RaidCheckHUNTER,
		[3] = L.RaidCheckMAGE,
		[4] = L.RaidCheckPRIEST,
		[5] = L.RaidCheckROGUE,
		[6] = L.RaidCheckWARLOCK,
		[7] = L.RaidCheckWARRIOR,
		[8] = L.RaidCheckSHAMAN,
		[9] = L.RaidCheckPALADIN,
		[10]= L.RaidCheckDEATHKNIGHT,
	}

	local CLASS_COUNT = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
		[9] = 0,
		[10]= 0,
	}

	local GROUP_COUNT = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	}

	local Group_NoBuff_Name = {
		-- 坚韧祷言、奥术光辉、野性赐福、精神祷言按小队号记录
		[L.RaidCheckBuffFortitude1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		[L.RaidCheckBuffBrilliance1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		[L.RaidCheckBuffGiftOfWild] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		[L.RaidCheckBuffSpirit1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		-- QS祝福按职业记录
		[L.RaidCheckBuffKings1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		[L.RaidCheckBuff1Wisdom1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
		[L.RaidCheckBuffMight1] = {
			[1] = {["name"]="",["count"]=0,},
			[2] = {["name"]="",["count"]=0,},
			[3] = {["name"]="",["count"]=0,},
			[4] = {["name"]="",["count"]=0,},
			[5] = {["name"]="",["count"]=0,},
			[6] = {["name"]="",["count"]=0,},
			[7] = {["name"]="",["count"]=0,},
			[8] = {["name"]="",["count"]=0,},
		},
	}

	local LostFQBuffNAME = ""
	local HasPRIEST = false
	local HasMAGE = false
	local HasDRUID = false
	local HasPALADINKings = false
	local HasPALADINWisdom = false
	local HasPALADINMight = false
	local NoBuffCount = 0

	-- 遍历团队成员，记录各职业人数，标记团队中是否存在法师、牧师、德鲁伊和圣骑士
	for i = 1, GetNumRaidMembers() do
		local _, _, subgroup, _, class, _, _, online = GetRaidRosterInfo(i)
		if online then
			if subgroup <= MaxGroup then
				if class == L.RaidCheckDRUID then
					CLASS_COUNT[1] = CLASS_COUNT[1] + 1
					HasDRUID = true
				end
				if class == L.RaidCheckHUNTER then
					CLASS_COUNT[2] = CLASS_COUNT[2] + 1
				end
				if class == L.RaidCheckMAGE then
					CLASS_COUNT[3] = CLASS_COUNT[3] + 1
					HasMAGE = true
				end
				if class == L.RaidCheckPRIEST then
					CLASS_COUNT[4] = CLASS_COUNT[4] + 1
					HasPRIEST = true
				end
				if class == L.RaidCheckROGUE then
					CLASS_COUNT[5] = CLASS_COUNT[5] + 1
				end
				if class == L.RaidCheckWARLOCK then
					CLASS_COUNT[6] = CLASS_COUNT[6] + 1
				end
				if class == L.RaidCheckWARRIOR then
					CLASS_COUNT[7] = CLASS_COUNT[7] + 1
				end
				if class == L.RaidCheckSHAMAN then
					CLASS_COUNT[8] = CLASS_COUNT[8] + 1
				end
				if class == L.RaidCheckPALADIN then
					CLASS_COUNT[9] = CLASS_COUNT[9] + 1
				end
				if class == L.RaidCheckDEATHKNIGHT then
					CLASS_COUNT[10] = CLASS_COUNT[10] + 1
				end
				GROUP_COUNT[subgroup] = GROUP_COUNT[subgroup] + 1;
			end
		end
	end

	if CLASS_COUNT[9] >= 1 then HasPALADINKings = true end
	if CLASS_COUNT[9] >= 2 then
		HasPALADINWisdom = true
		HasPALADINMight = true
	end

	for i = 1, GetNumRaidMembers() do
		local name, _, subgroup, _, class = GetRaidRosterInfo(i)
		if subgroup <= MaxGroup then
			local unit = "raid"..i
			local j = 1
			local HasPRIESTFortitude = false
			local HasPRIESTSpirit = false
			local HasMAGEBrilliance = false
			local HasDRUIDWild = false
			local HasPALADINBuffKings = false
		--	local HasPALADINBuffWisdom = false
			local HasPALADINBuffMight = false
			local IsFQ = false
			local HasFQBuff = false

			if not UnitIsConnected(unit) then
				HasPRIESTFortitude = true
				HasPRIESTSpirit = true
				HasMAGEBrilliance = true
				HasDRUIDWild = true
				HasPALADINBuffKings = true
			--	HasPALADINBuffWisdom = true
				HasPALADINBuffMight = true
				IsFQ = true
				HasFQBuff = true
			end

			while UnitBuff(unit, j) do
				local BuffTEXT = UnitBuff(unit, j)
				if find(BuffTEXT, L.RaidCheckBuffFortitude1) or find(BuffTEXT, L.RaidCheckBuffFortitude2) then
					HasPRIESTFortitude = true
				end
				if find(BuffTEXT, L.RaidCheckBuffSpirit1) or find(BuffTEXT, L.RaidCheckBuffSpirit2) then
					HasPRIESTSpirit = true
				end
				if find(BuffTEXT, L.RaidCheckBuffBrilliance1) or find(BuffTEXT, L.RaidCheckBuffBrilliance2) or find(BuffTEXT, L.RaidCheckBuffBrilliance3) then
					HasMAGEBrilliance = true
				end
				if find(BuffTEXT, L.RaidCheckBuffGiftOfWild) or find(BuffTEXT, L.RaidCheckBuffMarkOfWild) or find(BuffTEXT, L.RaidCheckBuffKings1) or find(BuffTEXT, L.RaidCheckBuffKings2) or find(BuffTEXT, L.RaidCheckBuffKings3) then
					HasDRUIDWild = true
					HasPALADINBuffKings = true
				end
				if find(BuffTEXT, L.RaidCheckBuffMight1) or find(BuffTEXT, L.RaidCheckBuffMight2) then
					HasPALADINBuffMight = true
				end
				if UnitPowerType(unit) ~= 0 then		--忽略无蓝条职业的精神
					HasPRIESTSpirit = true
				end
				if class == L.RaidCheckDRUID then
				--忽略野德的智力和智慧（猎豹和熊状态/HP>MP则判定为野德）
				--	if find(BuffTEXT, L.RaidCheckBuffBearForm) or find(BuffTEXT, L.RaidCheckBuffCatForm) or (UnitHealthMax(unit) > (UnitManaMax(unit) * 1.15)) then
					if find(BuffTEXT, L.RaidCheckBuffBearForm) or find(BuffTEXT, L.RaidCheckBuffCatForm) or (GetActiveTalentGroup(unit) == 2) then
						HasMAGEBrilliance = true
					--	HasPALADINBuffWisdom = true
					end
				end
				if class == L.RaidCheckROGUE or class == L.RaidCheckWARRIOR or class == L.RaidCheckDEATHKNIGHT then
				--忽略潜行者、战士和死亡骑士的智力
					HasMAGEBrilliance = true
				end
				j = j + 1
			end
			if HasPRIESTFortitude == false and HasPRIEST == true then
				Group_NoBuff_Name[L.RaidCheckBuffFortitude1][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffFortitude1][subgroup]["name"]..name.."."
				Group_NoBuff_Name[L.RaidCheckBuffFortitude1][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffFortitude1][subgroup]["count"] + 1
				NoBuffCount = NoBuffCount + 1
			end
			if HasPRIESTSpirit == false and HasPRIEST == true then
				Group_NoBuff_Name[L.RaidCheckBuffSpirit1][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffSpirit1][subgroup]["name"]..name.."."
				Group_NoBuff_Name[L.RaidCheckBuffSpirit1][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffSpirit1][subgroup]["count"] + 1
				NoBuffCount = NoBuffCount + 1
			end
			if HasMAGEBrilliance == false and HasMAGE == true then
				Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][subgroup]["name"]..name.."."
				Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][subgroup]["count"] + 1
				NoBuffCount = NoBuffCount + 1
			end
			if HasDRUIDWild == false and HasDRUID == true then
				Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][subgroup]["name"]..name.."."
				Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][subgroup]["count"] + 1
				NoBuffCount = NoBuffCount + 1
			end
			if HasPALADINBuffKings == false and HasPALADINKings == true then
				Group_NoBuff_Name[L.RaidCheckBuffKings1][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffKings1][subgroup]["name"]..name.."."
				Group_NoBuff_Name[L.RaidCheckBuffKings1][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffKings1][subgroup]["count"] + 1
				NoBuffCount = NoBuffCount + 1
			end
			if HasPALADINBuffMight == false and HasPALADINMight == true then
				if (class == L.RaidCheckROGUE) or (class == L.RaidCheckWARRIOR) or (class == L.RaidCheckDEATHKNIGHT) or (class == L.RaidCheckHUNTER) then
					Group_NoBuff_Name[L.RaidCheckBuffMight1][subgroup]["name"] = Group_NoBuff_Name[L.RaidCheckBuffMight1][subgroup]["name"]..name.."."
					Group_NoBuff_Name[L.RaidCheckBuffMight1][subgroup]["count"] = Group_NoBuff_Name[L.RaidCheckBuffMight1][subgroup]["count"] + 1
					NoBuffCount = NoBuffCount + 1
				end
			end
		end
	end

	if NoBuffCount == 0 then
		SendChatMessage(L.RaidCheckMsgFullBuff, "RAID")
		--SendChatMessage(L.RaidCheckMsgFullBuff, "GUILD")
	else
	--	SendChatMessage(format(L.RaidCheckMsgNoBuff, NoBuffCount), "RAID")
		--SendChatMessage(format(L.RaidCheckMsgNoBuff, NoBuffCount), "GUILD")

		local msg = ""

		-- 通报牧师BUFF缺失情况
		if HasPRIEST == true then
			-- 通报耐力BUFF缺失情况
			msg = ""
			for i = 1, MaxGroup do
				if Group_NoBuff_Name[L.RaidCheckBuffFortitude1][i]["name"] ~= "" then
					if Group_NoBuff_Name[L.RaidCheckBuffFortitude1][i]["count"] >= GROUP_COUNT[i] then
						Group_NoBuff_Name[L.RaidCheckBuffFortitude1][i]["name"] = L.RaidCheckMsgNoBuffAll
					end
					msg = msg..format(L.RaidCheckMsgGroup, i, Group_NoBuff_Name[L.RaidCheckBuffFortitude1][i]["name"]).." "
				end
			end
			if msg ~= "" then
				msg = L.RaidCheckMsgFortitude..": "..msg
				SendChatMessage(msg, "RAID")
				--SendChatMessage(msg, "GUILD")
			end
		end

		-- 通报法师BUFF缺失情况
		if HasMAGE == true then
			-- 通报智力BUFF缺失情况
			msg = ""
			for i = 1, MaxGroup do
				if Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][i]["name"] ~= "" then
					if Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][i]["count"] >= GROUP_COUNT[i] then
						Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][i]["name"] = L.RaidCheckMsgNoBuffAll
					end
					msg = msg..format(L.RaidCheckMsgGroup, i, Group_NoBuff_Name[L.RaidCheckBuffBrilliance1][i]["name"]).." "
				end
			end
			if msg ~= "" then
				msg = L.RaidCheckMsgBrilliance..": "..msg
				SendChatMessage(msg, "RAID")
				--SendChatMessage(msg, "GUILD")
			end
		end

		-- 通报德鲁伊BUFF缺失情况
		if HasDRUID == true then
			-- 通报爪子BUFF缺失情况
			msg = ""
			for i = 1, MaxGroup do
				if Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][i]["name"] ~= "" then
					if Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][i]["count"] >= GROUP_COUNT[i] then
						Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][i]["name"] = L.RaidCheckMsgNoBuffAll
					end
					msg = msg..format(L.RaidCheckMsgGroup, i, Group_NoBuff_Name[L.RaidCheckBuffGiftOfWild][i]["name"]).." "
				end
			end
			if msg ~= "" then
				msg = L.RaidCheckMsgWild..": "..msg
				SendChatMessage(msg, "RAID")
				--SendChatMessage(msg, "GUILD")
			end
		end

		-- 通报骑士王者祝福缺失情况
		if HasPALADINKings == true then
			msg = ""
			for i = 1, MaxGroup do
				if Group_NoBuff_Name[L.RaidCheckBuffKings1][i]["name"] ~= "" then
					if Group_NoBuff_Name[L.RaidCheckBuffKings1][i]["count"] >= CLASS_COUNT[i] then
						Group_NoBuff_Name[L.RaidCheckBuffKings1][i]["name"] = L.RaidCheckMsgNoBuffAll
					end
					msg = msg..format(L.RaidCheckBuffKings1, i, Group_NoBuff_Name[L.RaidCheckBuffKings1][i]["name"]).." "
				end
			end
			if msg ~= "" then
				msg = L.RaidCheckMsgKings..": "..msg
				SendChatMessage(msg, "RAID")
				--SendChatMessage(msg, "GUILD")
				
			end
		end

		-- 通报骑士力量祝福缺失情况
		if HasPALADINMight == true then
			msg = ""
			for i = 1, MaxGroup do
				if Group_NoBuff_Name[L.RaidCheckBuffMight1][i]["name"] ~= "" then
					if Group_NoBuff_Name[L.RaidCheckBuffMight1][i]["count"] >= CLASS_COUNT[i] then
						Group_NoBuff_Name[L.RaidCheckBuffMight1][i]["name"] = L.RaidCheckMsgNoBuffAll
					end
					msg = msg..format(L.RaidCheckBuffMight1, i, Group_NoBuff_Name[L.RaidCheckBuffMight1][i]["name"]).." "
				end
			end
			if msg ~= "" then
				msg = L.RaidCheckMsgMight..": "..msg
				SendChatMessage(msg, "RAID")
				--SendChatMessage(msg, "GUILD")
			end
		end

	end
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员到位检查
-------------------------------------------------------------------------------------------------------------------
local function CheckPosition()

	local UnVisiblePlayer = ""
	local DeadPlayer = ""
	local OfflinePlayer = ""
	local UnVisiblePlayerCount = 0
	local DeadPlayerCount = 0
	local OfflinePlayerCount = 0
	local msg = "["..L.RaidCheckMsgPosition.."]"
	local RaidNum = GetNumRaidMembers()

	for i = 1, RaidNum do
		_, _, subgroup = GetRaidRosterInfo(i)
		if subgroup <= MaxGroup then
			local unit = "raid"..i
			if UnitIsConnected(unit) then
				if not UnitIsDeadOrGhost(unit) then
					if not UnitIsVisible(unit) then
						UnVisiblePlayerCount = UnVisiblePlayerCount + 1
						if UnVisiblePlayerCount > 0 and UnVisiblePlayerCount < 20 then
							UnVisiblePlayer = UnVisiblePlayer..UnitName(unit).."."
						end
						if UnVisiblePlayerCount == 20 then
							UnVisiblePlayer = UnVisiblePlayer.." "..L.RaidCheckMsgETC
						end
					end
				else
					DeadPlayerCount = DeadPlayerCount + 1
					if DeadPlayerCount > 0 and DeadPlayerCount < 10 then
						DeadPlayer = DeadPlayer..UnitName(unit).."."
					end
					if DeadPlayerCount == 10 then
						DeadPlayer = DeadPlayer.." "..L.RaidCheckMsgETC
					end
				end
			else
				OfflinePlayerCount = OfflinePlayerCount + 1
				if OfflinePlayerCount > 0 and OfflinePlayerCount < 10 then
					OfflinePlayer = OfflinePlayer..UnitName(unit).."."
				end
				if OfflinePlayerCount == 10 then
					OfflinePlayer = OfflinePlayer.." "..L.RaidCheckMsgETC
				end
			end
		end
	end

	if UnVisiblePlayerCount == 0 and DeadPlayerCount == 0 and OfflinePlayerCount == 0 then
		msg = msg..format(L.RaidCheckMsgAllInPlace, RaidNum)
	else
		msg = msg..format(L.RaidCheckMsgInPlace, (RaidNum - OfflinePlayerCount - DeadPlayerCount - UnVisiblePlayerCount)).."."
		if UnVisiblePlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgUnVisible, UnVisiblePlayerCount)..":"..UnVisiblePlayer
		end
		if DeadPlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgDead, DeadPlayerCount)..":"..DeadPlayer
		end
		if OfflinePlayerCount > 0 then
			msg = msg..format(L.RaidCheckMsgOffline, OfflinePlayerCount)..":"..OfflinePlayer
		end
	end
	
	SendChatMessage(msg, "RAID")
end

-------------------------------------------------------------------------------------------------------------------
--	团队成员合剂检查
-------------------------------------------------------------------------------------------------------------------
local function CheckRaidFlask()

	local FlaskText = RAL_TEXT_CHECK_12
	local FlaskDATA = L.RaidCheckFlaskData
	local FlaskPlayer, NoFlaskPlayer = "", ""
	local FlaskPlayerCount, NoFlaskPlayerCount = 0, 0
	local msg = "["..L.RaidCheckMsgFlask.."]"

	for i = 1,GetNumRaidMembers() do
		_, _, subgroup = GetRaidRosterInfo(i)
		if subgroup <= MaxGroup then
			local unit = "raid"..i
			local j = 1
			local has = 0
			while UnitBuff(unit, j) and has == 0 and UnitIsConnected(unit) do
				for k, v in pairs(FlaskDATA) do
					if find(UnitBuff(unit, j), v) then
						has = 1
						FlaskPlayerCount = FlaskPlayerCount + 1
						FlaskPlayer = FlaskPlayer..UnitName(unit).."."
						break
					end
				end
				j = j + 1
				if not UnitBuff(unit, j) and has == 0 then
					NoFlaskPlayerCount = NoFlaskPlayerCount + 1
					NoFlaskPlayer = NoFlaskPlayer..UnitName(unit).."."
				end
			end
		end
	end

	if FlaskPlayerCount == 0 then
		msg = msg..L.RaidCheckMsgAllNoFlask
	elseif NoFlaskPlayerCount == 0 then
		msg = msg..L.RaidCheckMsgAllHasFlask
	elseif FlaskPlayerCount >= NoFlaskPlayerCount then
		msg = msg..format(L.RaidCheckMsgNoFlask, NoFlaskPlayerCount)..": "..NoFlaskPlayer
	else
		msg = msg..format(L.RaidCheckMsgHasFlask, FlaskPlayerCount)..": "..FlaskPlayer
	end
	SendChatMessage(msg, "RAID")
end

-------------------------------------------------------------------------------------------------------------------
--	创建团队状态检测按钮
-------------------------------------------------------------------------------------------------------------------
local RaidCheckFrameLeft = CreateFrame("Button", "RaidCheckFrameLeft", UIParent)
E.EuiSetTemplate(RaidCheckFrameLeft)
E.StyleButton(RaidCheckFrameLeft)
RaidCheckFrameLeft:SetAllPoints(EuiBottomInfoButtonL)

RaidCheckFrameLeft:SetScript("OnMouseDown", function(self, btn)
	if InCombatLockdown() then return end
	if btn == "LeftButton" then
	--	CheckPosition()
		if RaidUtilityPanel then RaidUtilityPanel:Show() else CheckPosition() end
	elseif btn == "RightButton" then
		DoReadyCheck()
	end
end)

E.EuiSetTooltip(RaidCheckFrameLeft, L.BottomPanelRaidCheck, L.MouseLeftButton, RaidUtilityPanel and L.RAIDCHECK_RAIDTOOL or L.RaidCheckTipLeftButtonOnLeftInfo, L.MouseRightButton, L.RaidCheckTipRightButtonOnLeftInfo)

local RaidCheckFrameRight = CreateFrame("Button", "RaidCheckFrameRight", UIParent)
E.EuiSetTemplate(RaidCheckFrameRight)
E.StyleButton(RaidCheckFrameRight)
RaidCheckFrameRight:SetAllPoints(EuiBottomInfoButtonR)

RaidCheckFrameRight:SetScript("OnMouseDown", function(self, btn)
	if InCombatLockdown() then return end
	if btn == "LeftButton" then
		CheckRaidBuff()
	elseif btn == "RightButton" then
		CheckRaidFlask()
	end
end)

E.EuiSetTooltip(RaidCheckFrameRight, L.BottomPanelRaidCheck, L.MouseLeftButton, L.RaidCheckTipLeftButtonOnRightInfo, L.MouseRightButton, L.RaidCheckTipRightButtonOnRightInfo)