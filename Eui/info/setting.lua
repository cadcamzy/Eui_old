local E, C = unpack(EUI)
if C["info"].setting == 0 or C["info"].enable == false then return end

local setting = CreateFrame ("Button", nil, UIParent)
setting:SetWidth(70)
setting:SetHeight(16)
--setting:SetBackdropColor(.7,.7,.9,.2)

local name = setting:CreateFontString (nil,"OVERLAY")
name:SetFont(E.fontn,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
name:SetText("设 置")
name:SetTextColor(20/255,122/255,199/25)

setting:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and IsAddOnLoaded("EuiSet") then
		HideUIPanel(GameMenuFrame)
		PlaySound("igMainMenuOption")
		if not EuiSetGui or not EuiSetGui:IsShown() then
			CreateEuiSetGui()
		else
			EuiSetGui:Hide()
		end 
	elseif button == "RightButton" then
		ToggleDropDownMenu(1, nil, settingMenuDrop, self, 0, -5)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	end
end)

local function addDrop(array)
	local info = array
	
	local function dropDown_create(self, level)
		 for i, j in pairs(info) do
			UIDropDownMenu_AddButton(j, level)
		 end
	end

	local setting = CreateFrame("Frame", "setting", nil, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(setting, dropDown_create, "MENU", level)
	return setting
end

settingMenuDrop = addDrop({
		{ text = "EUI ", isTitle = 1, notCheckable = 1, keepShownOnClick = 0 },
		{ text = "切换天赋 ", func = function() 
			local spec = GetActiveTalentGroup()
			if spec == 1 then 
				SetActiveTalentGroup(2)
				DEFAULT_CHAT_FRAME:AddMessage("已启用副天赋!");
			elseif spec == 2 then 
				SetActiveTalentGroup(1)
				DEFAULT_CHAT_FRAME:AddMessage("已启用主天赋!");
			end
		end },
		{ text = "清除战斗记录 ", func = function() CombatLogClearEntries() end },
		{ text = "开关战斗日志 ", func = function() 
			if LoggingCombat() then
				DEFAULT_CHAT_FRAME:AddMessage("战斗记录将关闭!");
				LoggingCombat(0);
			else
				DEFAULT_CHAT_FRAME:AddMessage("战斗记录将开启!");
				LoggingCombat(1);
			end
		end },
		{ text = "加入冬拥湖 ", func = function() BattlefieldMgrQueueRequest(1) end },
		{ text = "重设UI界面 ", func = function()
			EuiUFpos=nil
			BaudBag_Cfg=nil
			BaudBag_Cache=nil
			JPackDB=nil
			LjxxuiInstallV401=nil
			filter=nil
			tgoldDB=nil
			raidtarget=nil
			EuiData[E.myrealm][E.MyName]=nil
			filterdb=nil
			SetChat()
			eSetUI()
			ReloadUI()
		end },
		{text = "开/关LFW频道", func=function()
			if LFW_SHOW then
				LFW_SHOW = false
				DEFAULT_CHAT_FRAME:AddMessage("关闭LFW频道");
			else
				LFW_SHOW = true
				DEFAULT_CHAT_FRAME:AddMessage("打开LFW频道");
			end;
		end},
		{text = "--------", func=function() end},
		{text = CHARACTER_BUTTON,
			func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON,
			func = function() if InCombatLockdown() then return end ToggleFrame(SpellBookFrame) end},
		{text = TALENTS_BUTTON,
			func = function()
			if not PlayerTalentFrame then
				LoadAddOn("Blizzard_TalentUI")
			end
			if not GlyphFrame then
				LoadAddOn("Blizzard_GlyphUI")
			end
			PlayerTalentFrame_Toggle()
		end},
		{text = TIMEMANAGER_TITLE,
			func = function() ToggleFrame(TimeManagerFrame) end},
		{text = ACHIEVEMENT_BUTTON,
			func = function() ToggleAchievementFrame() end},
		{text = QUESTLOG_BUTTON,
			func = function() ToggleFrame(QuestLogFrame) end},
		{text = SOCIAL_BUTTON,
			func = function() ToggleFriendsFrame(1) end},
		{text = "日历",
			func = function() GameTimeFrame:Click() end},
		{text = PLAYER_V_PLAYER,
			func = function() ToggleFrame(PVPFrame) end},
		{text = ACHIEVEMENTS_GUILD_TAB,
			func = function()
			if IsInGuild() then
				if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
					GuildFrame_Toggle()
				else
				if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
				if not LookingForGuildFrame then return end
				LookingForGuildFrame_Toggle()
			end
		end},
		{text = LFG_TITLE,
			func = function() ToggleFrame(LFDParentFrame) end},
		{text = LOOKING_FOR_RAID,
			func = function() ToggleFrame(LFRParentFrame) end},
		{text = HELP_BUTTON,
			func = function() ToggleHelpFrame() end},
		{text = "游戏选项",
			func = function() ToggleFrame(GameMenuFrame) end},	
	})

----------------
--Setup Exp Tooltip
--[[ setting:SetScript("OnEnter", function()
	local lg
	local tltext
	if LoggingCombat() then
		lg = "启用"
	else
		lg = "禁用"
	end
	GameTooltip:SetOwner(setting, "ANCHOR_BOTTOMRIGHT");
    GameTooltip:ClearLines()
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(string.format('战斗日志: %s', lg))
	GameTooltip:AddLine("左击打开插件设置界面")
	GameTooltip:AddLine("右击设置有更多功能!!!")
    GameTooltip:Show()
	end)
setting:SetScript("OnLeave", function() GameTooltip:Hide() end)
 ]]
E.EuiSetTooltip(setting,"EUI控制台", "鼠标左键", "打开EUI控制台", "鼠标右键", "更多辅助功能")

E.EuiInfo(C["info"].setting,setting)