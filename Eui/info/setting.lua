local E, C, L, DB = unpack(EUI)
if C["info"].setting == 0 or C["info"].enable == false then return end

local setting = CreateFrame ("Button", nil, UIParent)
setting:SetWidth(70)
setting:SetHeight(16)
--setting:SetBackdropColor(.7,.7,.9,.2)

local name = setting:CreateFontString (nil,"OVERLAY")
name:SetFont(C["skins"].font,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
name:SetPoint("CENTER")
name:SetText(L.INFO_SETTING_TIP1)
name:SetTextColor(20/255,122/255,199/25)

setting:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and IsAddOnLoaded("EuiSet") then
		HideUIPanel(GameMenuFrame)
		PlaySound("igMainMenuOption")
		if not IsAddOnLoaded("EuiSet") then return end
		local EuiConfig = LibStub("AceAddon-3.0"):GetAddon("EuiConfig")
		if not EuiConfig then return end
		EuiConfig:ShowConfig()
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

StaticPopupDialogs["RESET_UI"] = {
	text = L.INFO_SETTING_TIP2,
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = function() 
		EuiUFpos=nil
		BaudBag_Cfg=nil
		BaudBag_Cache=nil
		JPackDB=nil
	--	LjxxuiInstallV401=nil
		filter=nil
		tgoldDB=nil
		raidtarget=nil
		EuiData[E.myrealm][E.MyName]=nil
		filterdb=nil
		SetChat()
		eSetUI()
		ReloadUI()
	end,
	OnCancel = function() end,
    timeout = 0,
    whileDead = 1,
}

settingMenuDrop = addDrop({
		{ text = "EUI ", isTitle = 1, notCheckable = 1, keepShownOnClick = 0 },
		{ text = L.INFO_SETTING_MENU1, func = function() 
			local spec = GetActiveTalentGroup()
			if spec == 1 then 
				SetActiveTalentGroup(2)
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP3);
			elseif spec == 2 then 
				SetActiveTalentGroup(1)
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP4);
			end
		end },
		{ text = L.INFO_SETTING_MENU2, func = function() CombatLogClearEntries() end },
		{ text = L.INFO_SETTING_MENU3, func = function() 
			if LoggingCombat() then
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP5);
				LoggingCombat(0);
			else
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP6);
				LoggingCombat(1);
			end
		end },
		{ text = L.INFO_SETTING_MENU4, func = function() BattlefieldMgrQueueRequest(1) end },
		{ text = L.INFO_SETTING_MENU5, func = function() BattlefieldMgrQueueRequest(21) end },
		{ text = L.INFO_SETTING_MENU6, func = function() StaticPopup_Show("RESET_UI") end },
		{text = L.INFO_SETTING_MENU7, func=function()
			if LFW_SHOW then
				LFW_SHOW = false
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP7);
			else
				LFW_SHOW = true
				DEFAULT_CHAT_FRAME:AddMessage(L.INFO_SETTING_TIP8);
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
		{text = L.INFO_SETTING_MENU8,
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
		{text = L.INFO_SETTING_MENU9,
			func = function() ToggleFrame(GameMenuFrame) end},	
	})

E.EuiSetTooltip(setting,L.INFO_SETTING_TIP_TITLE, L.INFO_SETTING_TIP_L1, L.INFO_SETTING_TIP_R1, L.INFO_SETTING_TIP_L2, L.INFO_SETTING_TIP_R2)
EuiTopInfobg.setting = setting
E.EuiInfo(C["info"].setting,setting)