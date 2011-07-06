 Local E, C, L = unpack(EUI)
---------------------------------------------------- UI Scale
--VideoOptionsResolutionPanelUIScaleSlider:Hide()
--VideoOptionsResolutionPanelUseUIScale:Hide()

Cresolution = GetCurrentResolution()
Cgetscreenresolution = select(Cresolution, GetScreenResolutions())

scalefix = CreateFrame("Frame")
scalefix:RegisterEvent("PLAYER_ENTERING_WORLD")
scalefix:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if Cgetscreenresolution == "800x600"
		or Cgetscreenresolution == "1024x768"
		or Cgetscreenresolution == "720x576"
		or Cgetscreenresolution == "1024x600" -- eeepc reso
		or Cgetscreenresolution == "1152x864" then
		SetCVar("useUiScale", 0)
	else
		SetCVar("useUiScale", 1)
		SetMultisampleFormat(1)	-- 多重采样率，可以设置为1，2，4，8
		if C["ui"].uiscale > 1 then C["ui"].uiscale = 1 end
		if C["ui"].uiscale < 0.64 then C["ui"].uiscale = 0.64 end
		SetCVar("uiScale", C["ui"].uiscale)
	end
	
end)

function E.EuiScale()
	if not (Cgetscreenresolution == "1680x945"
		or Cgetscreenresolution == "2560x1440" 
		or Cgetscreenresolution == "1680x1050" 
		or Cgetscreenresolution == "1920x1080" 
		or Cgetscreenresolution == "1920x1200" 
		or Cgetscreenresolution == "1600x900" 
		or Cgetscreenresolution == "2048x1152" 
		or Cgetscreenresolution == "1776x1000" 
		or Cgetscreenresolution == "2560x1600"
		or Cgetscreenresolution == "1440x900"
		or Cgetscreenresolution == "1366x768"
		or Cgetscreenresolution == "1280x800"		
		or Cgetscreenresolution == "1600x1200") then
		C["ui"].autoscale = false	
	end

	if C["ui"].autoscale == true then
	--	C["main"].uiscale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		C["ui"].uiscale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
E.EuiScale()

E.mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/C["ui"].uiscale
function E.Scale(x)
    return E.mult*math.floor(x/E.mult+.5)
end

---------------------------------------------------- Questlog Position
if C["main"].lockquest == true then
	hooksecurefunc(WatchFrame,"SetPoint",function(_,_,parent) -- 任务
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			WatchFrame:ClearAllPoints();
			WatchFrame:SetPoint("TOPRIGHT","UIParent","TOPRIGHT",-50,-200);
			WatchFrame:SetPoint("BOTTOMRIGHT","UIParent","BOTTOMRIGHT",-200,160);
		end
	end);
	
	hooksecurefunc(DurabilityFrame,"SetPoint",function(self,_,parent) -- 耐久度
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			DurabilityFrame:ClearAllPoints();
			DurabilityFrame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-100,60);
		end
	end);

	hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- 载具
		if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
			VehicleSeatIndicator:ClearAllPoints();
			VehicleSeatIndicator:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", -100, 160);
		end
	end);
end

---------------------------------------------------- Auto Invite
if C["main"].autoinvite == true then
local abw = CreateFrame("frame")
abw:RegisterEvent("CHAT_MSG_WHISPER")
abw:SetScript("OnEvent", function(self,event,arg1,arg2)
    if (not UnitExists("party1") or IsPartyLeader("player")) and arg1:lower():match(C["main"].invitetext) then
        InviteUnit(arg2)
    end
end)
end

---------------------------------------------------- Readycheck Warning
local ShowReadyCheckHook = function(self, initiator, timeLeft)
	if initiator ~= "player" then
		PlaySound("ReadyCheck")
	end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

---------------------------------------------------- No Errors
if C["main"].noerrors == true then 
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE") 
end

---------------------------------------------------- AutoLoot
if C["main"].autoloot == true then
function SimpleAutoLoot_OnEvent()
	if(GetNumRaidMembers() > 0) then
		if GetCVar("autoLootDefault") == "1" then
			DEFAULT_CHAT_FRAME:AddMessage(L.L_DISLOOT, 0, 1, 1 )
			SetCVar("autoLootDefault", "0")
		end
	else
		if GetCVar("autoLootDefault") == "0" then
			DEFAULT_CHAT_FRAME:AddMessage(L.L_ENLOOT, 0, 1, 1 )
			SetCVar("autoLootDefault", "1")
		end
	end
end

local frame = CreateFrame("Frame", "SimpleAutoLootFrame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")

frame:SetScript("OnEvent", SimpleAutoLoot_OnEvent)
end

---------------------------------------------------- Remove errors in combat
if C["main"].noerrorsincombat == true and C["main"].noerrors == false then 
	local neic = CreateFrame("Frame")
	local OnEvent = function(self, event, ...) self[event](self, event, ...) end
	neic:SetScript("OnEvent", OnEvent)
	local function PLAYER_REGEN_DISABLED()
		UIErrorsFrame:Hide()
	end
	local function PLAYER_REGEN_ENABLED()
		UIErrorsFrame:Show()
	end
	neic:RegisterEvent("PLAYER_REGEN_DISABLED")
	neic["PLAYER_REGEN_DISABLED"] = PLAYER_REGEN_DISABLED
	neic:RegisterEvent("PLAYER_REGEN_ENABLED")
	neic["PLAYER_REGEN_ENABLED"] = PLAYER_REGEN_ENABLED
end

---------------------------------------------------- Move UIErrors frame
if C["main"].moveuierrors == true then
UIErrorsFrame:ClearAllPoints()
UIErrorsFrame:SetPoint("TOP", UIParent, "TOP", 0, -20)
UIErrorsFrame.SetPoint = dummy
end


---------------------------------------------------- Ignore Duel 
if C["main"].ignoreduel == true then
local dd = CreateFrame("Frame")
    dd:RegisterEvent("DUEL_REQUESTED")
    dd:SetScript("OnEvent", function(self, event, name)
        HideUIPanel(StaticPopup1)
        CancelDuel()
		E.EuiAlertRun(L.L_DUEL..name,0,1,1) -- new info text
    end)
end

---------------------------------------------------- Auto resurection
if C["main"].autorez == true then
	local ar = CreateFrame("Frame")
	local OnEvent = function(self, event, ...) self[event](self, event, ...) end
	ar:SetScript("OnEvent", OnEvent)
	local function PLAYER_DEAD()
	if MiniMapBattlefieldFrame.status and MiniMapBattlefieldFrame.status=="active" then
		RepopMe()
	end
	end
	ar:RegisterEvent("PLAYER_DEAD")
	ar["PLAYER_DEAD"] = PLAYER_DEAD
end

---------------------------------------------------- Auto Roll
if E.MyLevel == MAX_PLAYER_LEVEL and C["main"].autoroll == true then
	local agog = CreateFrame("Frame", nil, UIParent)
	agog:RegisterEvent("START_LOOT_ROLL")
	agog:SetScript("OnEvent", function(_, _, id)
	if not id then return end 
	if select(2,GetLootRollItemInfo(id)) == select(1, GetItemInfo(43297)) or select(2,GetLootRollItemInfo(id)) == select(1, GetItemInfo(45912)) then return end
	if(id and select(4, GetLootRollItemInfo(id))==2 and not (select(5, GetLootRollItemInfo(id)))) then
		if RollOnLoot(id, 3) then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end	
	end)
end

if C["main"].disableconfirm == true  then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:RegisterEvent("CONFIRM_LOOT_ROLL")
	acd:RegisterEvent("LOOT_BIND_CONFIRM")
	acd:SetScript("OnEvent", function(self, event, ...)
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
	end)
end

---------------------------------------------------- Auto repair & sell crap
local arsc = CreateFrame("Frame")
	arsc:RegisterEvent("MERCHANT_SHOW")
	arsc:SetScript("OnEvent", function()
    if(C["main"].autorepair == true and CanMerchantRepair()) then
        local cost = GetRepairAllCost()
        if(not cost or cost==0) then return end

        local CanGuildRepair = C["main"].autorepairguild == true and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney()>cost and GetGuildBankMoney()>cost
        if(CanGuildRepair) then
            RepairAllItems(1)
            E.EuiAlertRun(format(L.L_COST.."%.1f"..L.L_GOLD, cost * 0.0001),0,1,1)
			print(format("|cff00ffff"..L.L_COST.."%.1f"..L.L_GOLD.."|r", cost * 0.0001))
        elseif(GetMoney()>cost) then
            RepairAllItems()
            E.EuiAlertRun(format(L.L_COST.."%.1f"..L.L_GOLD, cost * 0.0001),0,1,1)
			print(format("|cff00ffff"..L.L_COST.."%.1f"..L.L_GOLD.."|r", cost * 0.0001))
        end
    end

    if C["main"].sellgreycrap == true then
        local bag, slot 
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if link and (select(3, GetItemInfo(link))==0) then
                    UseContainerItem(bag, slot)
                end
            end
        end
    end
end)

---------------------------------------------------- Accept Invites 
if C["main"].acceptinvites == true then
    local IsFriend = function(name)
        for i=1, GetNumFriends() do if(GetFriendInfo(i)==name) then return true end end
        if(IsInGuild()) then for i=1, GetNumGuildMembers() do if(GetGuildRosterInfo(i)==name) then return true end end end
    end

    local ai = CreateFrame("Frame")
    ai:RegisterEvent("PARTY_INVITE_REQUEST")
    ai:SetScript("OnEvent", function(frame, event, name)
        if(IsFriend(name)) then
			E.EuiAlertRun(L.L_INVITE..name,0,1,1)
			print(format("|cff00ffff"..L.L_INVITE..name))
            AcceptGroup()
            for i = 1, 4 do
                local frame = _G["StaticPopup"..i]
                if(frame:IsVisible() and frame.which=="PARTY_INVITE") then
                    frame.inviteAccepted = 1
                    StaticPopup_Hide("PARTY_INVITE")
                    return
                end
            end
        else
            SendWho(name)
        end
    end)
end

---------------------------------------------------- ALT+Click to buy a stack
if C["main"].bugstack == true then
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick;
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(this:GetID())));
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(this:GetID());
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(this:GetID(), floor(maxStack / quantity));
		end;
	end;
	savedMerchantItemButton_OnModifiedClick(self, ...);
end;
end

---------------------------------------------------- Some slash commands
SlashCmdList["FRAME"] = function() print(GetMouseFocus():GetName()) end
SLASH_FRAME1 = "/gn"

SlashCmdList["GETPARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/ticket"
SLASH_TICKET2 = "/gm"

SlashCmdList["DISABLE_ADDON"] = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/dis"

SlashCmdList["ENABLE_ADDON"] = function(s) EnableAddOn(s) end
SLASH_ENABLE_ADDON1 = "/en"

---------------------------------------------------- Addon's Group
local raidaddons = {    -- Raid时使用的插件
    "sThreatMeter2", 
	"Engravings",
	"Skada",
	"SkadaDamage",
	"SkadaHealing",
	"SkadaFailbot",
	"RatingBuster",
    "DBM-Core",
	"BigWigs",
	"CheckForConsumables",
	"AntiSlack",
	"BigBrother",
	"Omen",
	"Recount",
}

local pvpaddons = {     -- PVP时使用的插件
    "Gladius", 
	"Engravings",
	"ArenaHistorian",
	"SpellAlerter",
	"PreformAVEnabler",
	"DRTracker",
	"RatingBuster",
	"SSArena",
	"ArenaCountDown",
	"Capping",
	"BattleInfo",
}

local soloaddons = {     -- Solo时使用的插件
    "QuestHelper",
	"LightHeaded",
	"Cartographer",
	"QuestLibrary",
	"MapNotes",
	"Carbonite",
}

local tradeaddons = {    -- 商业活动时使用的插件 
    "BaudAuction",
}

SlashCmdList["CHANGEADDONS"] = function(s)
    if(s and s=="raid") then
        for i in pairs(pvpaddons) do
            DisableAddOn(pvpaddons[i])
        end
		for i in pairs(soloaddons) do
            DisableAddOn(soloaddons[i])
        end
		for i in pairs(tradeaddons) do
            DisableAddOn(tradeaddons[i])
        end		
        for i in pairs(raidaddons) do
            EnableAddOn(raidaddons[i])
        end
        ReloadUI()
    elseif(s and s=="pvp") then
        for i in pairs(raidaddons) do
            DisableAddOn(raidaddons[i])
        end
		for i in pairs(soloaddons) do
            DisableAddOn(soloaddons[i])
        end
		for i in pairs(tradeaddons) do
            DisableAddOn(tradeaddons[i])
        end	
        for i in pairs(pvpaddons) do
            EnableAddOn(pvpaddons[i])
        end
        ReloadUI()
    elseif(s and s=="solo") then
        for i in pairs(raidaddons) do
            DisableAddOn(raidaddons[i])
        end
        for i in pairs(pvpaddons) do
            DisableAddOn(pvpaddons[i])
        end
		for i in pairs(tradeaddons) do
            DisableAddOn(tradeaddons[i])
        end	
		for i in pairs(soloaddons) do
            EnableAddOn(soloaddons[i])
        end
        ReloadUI()
    elseif(s and s=="trade") then
        for i in pairs(raidaddons) do
            DisableAddOn(raidaddons[i])
        end
        for i in pairs(pvpaddons) do
            DisableAddOn(pvpaddons[i])
        end
		for i in pairs(tradeaddons) do
            DisableAddOn(tradeaddons[i])
        end	
		for i in pairs(soloaddons) do
            DisableAddOn(soloaddons[i])
        end
		for i in pairs(tradeaddons) do
            EnableAddOn(tradeaddons[i])
        end	
        ReloadUI()
    else
		print(L.L_RAID)
		print(L.L_SOLO)
		print(L.L_PVP)
		print(L.L_TRADE)
    end
end
SLASH_CHANGEADDONS1 = "/ad"


---------------------------------------------------- Hide spam from talent respec
if C["main"].talentspam == true then
local spamFilterMatch1 = string.gsub(ERR_LEARN_ABILITY_S:gsub('%.', '%.'), '%%s', '(.*)')
local spamFilterMatch2 = string.gsub(ERR_LEARN_SPELL_S:gsub('%.', '%.'), '%%s', '(.*)')
local spamFilterMatch3 = string.gsub(ERR_SPELL_UNLEARNED_S:gsub('%.', '%.'), '%%s', '(.*)')
local primarySpecSpellName = GetSpellInfo(63645)
local secondarySpecSpellName = GetSpellInfo(63644)

local groupNamesCaps = {
	"Primary",
	"Secondary"
}

specCache = {}
	
HideSpam = CreateFrame("Frame");
HideSpam:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
HideSpam:RegisterEvent("UNIT_SPELLCAST_START");
HideSpam:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");

HideSpam.filter = function(self, event, msg, ...)
	if strfind(msg, spamFilterMatch1) then
		return true
	elseif strfind(msg, spamFilterMatch2) then
		return true
	elseif strfind(msg, spamFilterMatch3) then
		return true
	end
	return false, msg, ...
end

HideSpam:SetScript("OnEvent", function( self, event, ...)

	local unit, spellName = ...
	
	if(event == "UNIT_SPELLCAST_START") then
		if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
		end
	
	elseif(event == "UNIT_SPELLCAST_INTERRUPTED") then
		if unit == "player" and (spellName == primarySpecSpellName or spellName == secondarySpecSpellName) then
			ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)
		end
	
	elseif(event == "ACTIVE_TALENT_GROUP_CHANGED") then
		for i = 1, GetNumTalentGroups() do
			specCache[i] = specCache[i] or {}
			local thisCache = specCache[i]
			TalentFrame_UpdateSpecInfoCache(thisCache, false, false, i)
			if thisCache.primaryTabIndex and thisCache.primaryTabIndex ~= 0 then
				thisCache.specName = thisCache[thisCache.primaryTabIndex].name
				thisCache.mainTabIcon = thisCache[thisCache.primaryTabIndex].icon
			elseif thisCache.secondaryTabIndex and thisCache.secondaryTabIndex ~= 0 then
				thisCache.specName = thisCache[thisCache.secondaryTabIndex].name
				thisCache.mainTabIcon = thisCache[thisCache.secondaryTabIndex].icon
			else
				thisCache.specName = "|cffff0000Talents undefined!|r"
				thisCache.mainTabIcon = "Interface\\Icons\\Ability_Seal"
			end
			thisCache.specGroupName = groupNamesCaps[i]
		end

		local activeGroupNum = GetActiveTalentGroup()
		if specCache[activeGroupNum].totalPointsSpent > 1 then
			local s = specCache[activeGroupNum];
			print(L.L_TALENT.."|cff6adb54".. s.specName .." ("..
			s[1].pointsSpent .."/"..
			s[2].pointsSpent .."/"..
			s[3].pointsSpent ..")|r"..L.L_TALENT_S)
		end
		
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.filter)

	end

end);
end


---------------------------------------------------- Quest Automation
if C["main"].questauto == true then
local qauto = CreateFrame('Frame')
qauto.completed_quests = {}
qauto.uncompleted_quests = {}

function qauto:canAutomate ()
	if IsShiftKeyDown() then
		return false
	else
		return true
	end
end

function qauto:strip_text (text)
	if not text then return end
	text = text:gsub('%[.*%]%s*','')
	text = text:gsub('|c%x%x%x%x%x%x%x%x(.+)|r','%1')
	text = text:gsub('(.+) %(.+%)', '%1')
	text = text:trim()
	return text
end

function qauto:QUEST_PROGRESS ()
	if not self:canAutomate() then return end
	if IsQuestCompletable() then
		CompleteQuest()
	end
end

function qauto:QUEST_LOG_UPDATE ()
	if not self:canAutomate() then return end
	local start_entry = GetQuestLogSelection()
	local num_entries = GetNumQuestLogEntries()
	local title
	local is_complete
	local no_objectives

	self.completed_quests = {}
	self.uncompleted_quests = {}

	if num_entries > 0 then
		for i = 1, num_entries do
			SelectQuestLogEntry(i)
			title, _, _, _, _, _, is_complete = GetQuestLogTitle(i)
			no_objectives = GetNumQuestLeaderBoards(i) == 0
			if title and (is_complete or no_objectives) then
				self.completed_quests[title] = true
			else
				self.uncompleted_quests[title] = true
			end
		end
	end

	SelectQuestLogEntry(start_entry)
end

function qauto:GOSSIP_SHOW ()
	if not self:canAutomate() then return end

	local button
	local text

	for i = 1, 32 do
		button = _G['GossipTitleButton' .. i]
		if button:IsVisible() then
			text = self:strip_text(button:GetText())
			if button.type == 'Available' then
				button:Click()
			elseif button.type == 'Active' then
				if self.completed_quests[text] then
					button:Click()
				end
			end
		end
	end
end

function qauto:QUEST_GREETING (...)
	if not self:canAutomate() then return end

	local button
	local text

	for i = 1, 32 do
		button = _G['QuestTitleButton' .. i]
		if button:IsVisible() then
			text = self:strip_text(button:GetText())
			if self.completed_quests[text] then
				button:Click()
			elseif not self.uncompleted_quests[text] then
				button:Click()
			end
		end
	end
end

function qauto:QUEST_DETAIL ()
	if not self:canAutomate() then return end
	AcceptQuest()
end

function qauto:QUEST_COMPLETE (event)
	if not self:canAutomate() then return end
	if GetNumQuestChoices() <= 1 then
		GetQuestReward(QuestFrameRewardPanel.itemChoice)
	end
end

function qauto.onevent (self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end

qauto:SetScript('OnEvent', qauto.onevent)
qauto:RegisterEvent('GOSSIP_SHOW')
qauto:RegisterEvent('QUEST_COMPLETE')
qauto:RegisterEvent('QUEST_DETAIL')
qauto:RegisterEvent('QUEST_FINISHED')
qauto:RegisterEvent('QUEST_GREETING')
qauto:RegisterEvent('QUEST_LOG_UPDATE')
qauto:RegisterEvent('QUEST_PROGRESS')

_G.idQuestAutomation = qauto
end


---------------------------------------------------- Quest Icons
if C["main"].questicons == true then
local _G = getfenv(0)

-- Tries to deal with incompatabilities that other mods cause
local function stripStupid(text)
	if( not text ) then
		return nil
	end
	
	-- Strip [<level crap>] <quest title>
	text = string.gsub(text, "%[(.+)%]", "")
	-- Strip color codes
	text = string.gsub(text, "|c%x%x%x%x%x%x%x%x(.+)|r", "%1")
	-- Strip (low level) at the end of a quest
	text = string.gsub(text, "(.+) %((.+)%)", "%1")
	
	text = string.trim(text)
	text = string.lower(text)
	return text
end

function checkQuestText(buttonText, texture)
	buttonText = stripStupid(buttonText)
	
	for i=1, GetNumQuestLogEntries() do
		local questName, _, _, _, _, _, isComplete = GetQuestLogTitle(i)
		
		if( buttonText == stripStupid(questName) ) then
			if( ( isComplete and isComplete > 0 ) or GetNumQuestLeaderBoards(i) == 0 ) then
				SetDesaturation(texture, nil)
				return
			end
			break
		end
	end
		
	SetDesaturation(texture, true)
end

local function updateGossipIcons()
	if( not GossipFrame:IsVisible() ) then
		return
	end
	
	for i=1, GossipFrame.buttonIndex do
		local button = _G["GossipTitleButton" .. i]
		if( button:IsVisible() ) then
			if( button.type == "Active" ) then
				checkQuestText(button:GetText(), _G[button:GetName() .. "GossipIcon"])
			else
				SetDesaturation(_G[button:GetName() .. "GossipIcon"], nil)
			end
		end
	end
end

local function updateQuestIcons()
	if( not QuestFrameGreetingPanel:IsVisible() ) then
		return
	end
	
	for i=1, (GetNumActiveQuests() + GetNumAvailableQuests()) do
		local button = _G["QuestTitleButton" .. i]
		if( button:IsVisible() ) then
			if( button.isActive == 1 ) then
				checkQuestText(button:GetText(), (button:GetRegions()))
			else
				SetDesaturation((button:GetRegions()), nil)
			end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_GREETING")
frame:RegisterEvent("GOSSIP_SHOW")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:SetScript("OnEvent", function(self, event)
	updateQuestIcons()
	updateGossipIcons()
end)
end

---------------------------------------------------- Addons settings
--[[ General settings config ]]
eSetUI = function()
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotFormat", "JPG")				-- 截屏图像格式，"TGA" 或 "JPG"
	SetCVar("screenshotQuality", 10)				-- 截屏时JPEG的图像质量，需要截屏图像格式为JPG
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("buffDurations", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("scriptErrors", 0)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("gxTextureCacheSize", 512)	
	SetCVar("autoLootDefault", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("ChatBubbles", 0)
	SetCVar("ChatBubblesParty", 0)
	SetCVar("deselectOnClick", 1)
	SetCVar("autoLootDefault", 1)
end

local Boost = function()
	SetCVar("ffx", 0)
	SetCVar("hwPCF", 1)
end

--[[ DBM settings ]]
local _, class = UnitClass("player")
local t = E.RAID_CLASS_COLORS[class]
local r, g, b = t.r, t.g, t.b
--[[
local UploadBoss = function()
    if(DBM_SavedOptions) then table.wipe(DBM_SavedOptions) end

    DBM_SavedOptions = {
        ["ShowMinimapButton"] = true,
        ["ShowWarningsInChat"] = true,
        ["RangeFramePoint"] = "TOPRIGHT",
        ["RaidWarningSound"] = "Sound\\Doodad\\BellTollNightElf.wav",
        ["SpecialWarningSound"] = "Sound\\Spells\\PVPFlagTaken.wav",
        ["AutoRespond"] = false,
        ["StatusEnabled"] = false,
        ["RaidWarningPosition"] = {["Y"] = -150, ["X"] = 0, ["Point"] = "TOP"},
        ["Enabled"] = true,
        ["RangeFrameX"] = -270,
        ["RangeFrameY"] = -250,
        ["WarningIconLeft"] = true,
        ["WarningColors"] = {{["b"] = b, ["g"] = g, ["r"] = r,},
                             {["b"] = b, ["g"] = g, ["r"] = r,},
                             {["b"] = b, ["g"] = g, ["r"] = r,},
                             {["b"] = b, ["g"] = g, ["r"] = r,},},
        ["WarningIconRight"] = true,
        ["ShowFakedRaidWarnings"] = true,
        ["ShowMinimapButton"] = true,
        ["HPFramePoint"] = "TOPLEFT",
        ["HPFrameX"] = 240,
        ["HPFrameY"] = -240,
        ["SpamBlockRaidWarning"] = true,
        ["SpamBlockBossWhispers"] = false,
        ["HideBossEmoteFrame"] = false,
    }

    if(DBT_SavedOptions) then table.wipe(DBT_SavedOptions) end

    DBT_SavedOptions = {
        ["DBM"] = {
            ["StartColorR"] = r,
            ["StartColorG"] = g,
            ["StartColorB"] = b,
            ["EndColorR"] = r,
            ["EndColorG"] = g,
            ["EndColorB"] = b,
            ["Scale"] = 1,
            ["Width"] = 250,
            ["TimerX"] = -143,
            ["TimerY"] = -250,
            ["BarXOffset"] = 0,
            ["BarYOffset"] = 2,
            ["IconLeft"] = false,
            ["IconRight"] = false,
            ["ExpandUpwards"] = false,
            ["Texture"] = "Interface\\AddOns\\Eui\\media\\normTex",
            ["HugeBarsEnabled"] = false,
            ["HugeBarXOffset"] = 0,
            ["HugeBarYOffset"] = 0,
            ["HugeWidth"] = 200,
            ["HugeTimerY"] = -190,
            ["HugeTimerPoint"] = "TOPLEFT",
            ["HugeTimerX"] = 150,
            ["HugeScale"] = 1.05,
            ["TimerPoint"] = "TOPRIGHT",
        },
    }
    DBM_SavedOptions["ep_settings"] = true
    DBM_SavedOptions["ShowMinimapButton"] = false
end
]]
--[[ Recount Settings ]]
local recount = function()
	if RecountDB or RecountPerCharDB then
		table.wipe(RecountDB)
		table.wipe(RecountPerCharDB)
	end
	RecountDB = {
	["ep_setiings"] = true,
	["profileKeys"] = {
		[""] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["GraphWindowY"] = 0,
			["MainWindow"] = {
				["ShowScrollbar"] = false,
				["Position"] = {
					["y"] = -10.40647875656032,
					["x"] = -20,
					["w"] = 300,
					["h"] = 200,
				},
				["BarText"] = {
					["NumFormat"] = 3,
				},
				["RowHeight"] = 16,
				["RowSpacing"] = 1,
			},
			["Colors"] = {
				["Window"] = {
					["Background"] = {
						["a"] = 0,
						["r"] = 0.0392156862745098,
						["g"] = 0.06666666666666667,
					},
					["Title"] = {
						["a"] = 0,
						["r"] = 0.8313725490196078,
						["g"] = 0.7176470588235294,
						["b"] = 1,
					},
					["Title Text"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["Bar"] = {
					["Bar Text"] = {
						["a"] = 1,
						["b"] = 0.592156862745098,
						["g"] = 0.592156862745098,
						["r"] = 0.592156862745098,
					},
					["Total Bar"] = {
						["a"] = 1,
						["r"] = 0.2,
						["g"] = 0.2,
						["b"] = 0.2,
					},
				},
			},
			["DetailWindowY"] = 104.0000005623091,
			["DetailWindowX"] = -20,
			["BarTextColorSwap"] = true,
			["GraphWindowX"] = 0,
			--["Locked"] = true,
			["BarTexture"] = "Flat",
			["CurDataSet"] = "CurrentFightData",
			["ClampToScreen"] = true,
			["GraphWindowX"] = 0,
			["MainWindowWidth"] = 300,
			["MainWindowHeight"] = 200,
		},
	},
}
	--RecountPerCharDB = { },
	RecountDB["ep_setiings"] = true
	--RecountPerCharDB["ep_setiings"] = true
end

--[[ MSBT Settings ]]
local msbt = function()
		MSBTProfiles_SavedVars = {
			["profiles"] = {
				["Default"] = {
					["scrollAreas"] = {
						["Static"] = {
							["disabled"] = true,
						},
						["Outgoing"] = {
							["direction"] = "Up",
							["behavior"] = "MSBT_NORMAL",
							["stickyDirection"] = "Up",
							["stickyBehavior"] = "MSBT_NORMAL",
							["offsetX"] = 300,
							["offsetY"] = -140,
							["animationStyle"] = "Straight",
							["stickyAnimationStyle"] = "Static",
						},
						["Incoming"] = {
							["direction"] = "Up",
							["behavior"] = "MSBT_NORMAL",
							["stickyDirection"] = "Up",
							["stickyBehavior"] = "MSBT_NORMAL",
							["offsetX"] = -300,
							["offsetY"] = -140,
							["animationStyle"] = "Straight",
							["stickyAnimationStyle"] = "Static",
						},
					},
					["creationVersion"] = "5.4.78",
				},
			},
			["profileKeys"] = {
				[""] = "Default",
			},
			["ep_setiings"] = true,
		}
end

local dxe = function()
	if(DXEDB) then table.wipe(DXEDB) end
	if(DXEIconDB) then table.wipe(DXEIconDB) end
	DXEDB = {
		["profiles"] = {
			["Default"] = {
				["Positions"] = {
					["DXEPane"] = {
						["yOfs"] = -20,
						["xOfs"] = 20,
						["point"] = "TOPLEFT",
						["relativePoint"] = "TOPLEFT",
					},
					["DXEAlertsTopStackAnchor"] = {
						["point"] = "BOTTOMLEFT",
						["relativePoint"] = "BOTTOMLEFT",
						["yOfs"] = 185,
						["xOfs"] = 21,
					},
					["DXEArrowsAnchor2"] = {
						["yOfs"] = -34,
						["xOfs"] = -111,
					},
					["DXEAlertsCenterStackAnchor"] = {
						["yOfs"] = 25,
						["xOfs"] = 3,
					},
					["DXEArrowsAnchor1"] = {
						["yOfs"] = -34,
						["xOfs"] = -4,
					},
					["DXEArrowsAnchor3"] = {
						["yOfs"] = -34,
						["xOfs"] = 98,
					},
				},
				["Pane"] = {
					["Show"] = false,
				},
			},
		},
	}
	DXEIconDB = {
		["hide"] = true,
	}
end

--[[ Slash commands handling ]]
local pr = function(msg)
    print("|cff00ffffEUI:|r", tostring(msg))
end

SLASH_eset1 = "/eset"
SlashCmdList["eset"] = function(msg)
    if(msg=="msbt") then
        msbt()
        ReloadUI()
    elseif(msg=="ui") then
        eSetUI()
        ReloadUI()
	elseif(msg=="recount") then
        recount()
        ReloadUI()
    elseif(msg=="boss") then
        UploadBoss()
        ReloadUI()
    elseif(msg=="boost") then
        Boost()
        ReloadUI()
    elseif(msg=="dxe") then
        dxe()
        ReloadUI()
    elseif(msg=="all") then
		eSetUI()
		msbt()
		recount()
		UploadBoss()
		Boost()
		dxe()
        ReloadUI()
    else
		pr(L.L_UI)
		pr(L.L_BOOST)
		pr(L.L_RECOUNT)
		pr(L.L_MSBT)
		pr(L.L_DBM)
        pr(L.L_ESET)
        pr(L.L_DXE)
    end
end

---------------------------------------------------- Quest Level
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", update)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", update)

---------------------------------------------------- Combat Notification
if C["main"].combatnoti == true then
	local CombatNotification = CreateFrame ("Frame")
		CombatNotification:RegisterEvent("PLAYER_REGEN_ENABLED")
		CombatNotification:RegisterEvent("PLAYER_REGEN_DISABLED")
		CombatNotification:SetScript("OnEvent", function (self,event)
			if (UnitIsDead("player")) then return end
			if event == "PLAYER_REGEN_ENABLED" then
				E.EuiAlertRun("LEAVING COMBAT",0.1,1,0.1)
			else
				E.EuiAlertRun("ENTERING COMBAT",1,0.1,0.1)
			end	
		end)
end


----------------------------------------------------------------------------------------
-- capture bar update position
----------------------------------------------------------------------------------------

local function captureupdate()
	local nexty = 0
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local cb = _G["WorldStateCaptureBar"..i]
		if cb and cb:IsShown() then
			cb:ClearAllPoints()
			cb:SetPoint("TOP", UIParent, "TOP", -20, -120)
			nexty = nexty + cb:GetHeight()
		end
	end
end

hooksecurefunc("WorldStateAlwaysUpFrame_Update", captureupdate)


--创建两个用于解DBUFF的宏,并绑定到鼠标滚轮上
local Debuffmw = CreateFrame("Frame")
Debuffmw:RegisterEvent("PLAYER_ENTERING_WORLD")
Debuffmw:SetScript("OnEvent", function(self, event)
	if C["raid"].raid == true then
		--Hide Biz RaidFrame...
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer:Hide()	
	end
	if C["clickset"].aamouse ~= true then
		if GetMacroInfo("epDebuffa") then DeleteMacro("epDebuffa") end
		if GetMacroInfo("epDebuffb") then DeleteMacro("epDebuffb") end
		return
	end
	local _, class = UnitClass("player")
	local CanDispel = {
		PRIEST = { 527, 528, },
		SHAMAN = { 370, 51886, },
		PALADIN = { 4987, },
		MAGE = { 475, },
		DRUID = { 2782, },
		ROGUE = {},
		HUNTER = {},
		WARRIOR = {},
		WARLOCK = {},
		DEATHKNIGHT = {},
	}
	if select(2, GetNumMacros()) > 34 then
    print(L.CLICKSET_MOUSE_ERR)
		return
	end
--local index_a = CreateMacro("Debuff_1", _, "/cast [target=mouseover] 清洁术;",1)
	if GetMacroInfo("EuiDebuffa") then DeleteMacro("EuiDebuffa") end
	if GetMacroInfo("EuiDebuffb") then DeleteMacro("EuiDebuffb") end
	local macroa, macrob
	local indexa, indexb
	if CanDispel[class][1] and IsSpellKnown(CanDispel[class][1]) then
		macroa = GetSpellInfo(CanDispel[class][1]) or ""
		index_a = CreateMacro("EuiDebuffa", 1, "/cast [target=mouseover] "..macroa..";", 1)
		local a=SetBinding("ALT-MOUSEWHEELUP", "CAMERAZOOMIN")
		local b=SetBinding("ALT-MOUSEWHEELDOWN", "CAMERAZOOMOUT")
		if a and b then
			SaveBindings(2)
			print(L.CLICKSET_TIP1)
			print(L.CLICKSET_TIP2)
			print(L.CLICKSET_TIP3)
		end
	end
	if CanDispel[class][2] and IsSpellKnown(CanDispel[class][2]) then
		macrob = GetSpellInfo(CanDispel[class][2]) or ""
		index_b = CreateMacro("EuiDebuffb", 1, "/cast [target=mouseover] "..macrob..";", 1)
	end
	if index_a then SetBindingMacro("MOUSEWHEELUP", index_a) end
	if index_b then SetBindingMacro("MOUSEWHEELDOWN", index_b) end

end)

StaticPopupDialogs["INSTALL_UI"] = {
	text = L.INSTALLUI_TEXT,
	button1 = ACCEPT,
	button2 = CANCEL,
    OnAccept = function() 
		eSetUI()
		msbt()
		SetChat()
		recount()
	--	UploadBoss()
		Boost()
		dxe()
		LjxxuiInstallV401 = true
        ReloadUI()
	end,
	OnCancel = function() LjxxuiInstallV401 = false end,
    timeout = 0,
    whileDead = 1,
}


local LjxxuiOnLogon = CreateFrame("Frame")
LjxxuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
LjxxuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if LjxxuiInstallV401 ~= true then
		E.EuiSetTemplate(StaticPopup_Show("INSTALL_UI"))
	end
end)


--[[ hooksecurefunc("UnitPopup_OnClick", function(self)
	if self.value == "SET_FOCUS" or self.value == "CLEAR_FOCUS" then
		print("请使用Shift+左键来设定/取消焦点")
		if StaticPopup1Button2 then StaticPopup1Button2:Click() end
		return
	end
end) ]]






