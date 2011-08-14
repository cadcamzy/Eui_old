local E, C, L, DB = unpack(EUI)
if C["other"].minimap ~= true then return end
local mP = E.EuiCreateFrame(Minimap, 0, "BACKGROUND")
mP:SetPoint("TOPLEFT",-3,3)
mP:SetPoint("BOTTOMRIGHT",3,-3)
E.EuiSetTemplate(mP)

Minimap:SetScale(1)
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint('TOPRIGHT', UIParent, -10, -20)
--Minimap:SetSize(C["main"].minimapsize - 4, C["main"].minimapsize - 4)

function E.PostMinimapMove(frame)

	if E.Movers[frame:GetName()]["moved"] ~= true then
		frame:ClearAllPoints()
		frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", E.Scale(-6), E.Scale(-6))
	end
end

E.CreateMover(Minimap, "MinimapMover", "小地图", nil, E.PostMinimapMove)

Minimap:SetFrameLevel(2)
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')	
--MinimapToggleButton:Hide()
-- 隐藏边框
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- 隐藏放大/缩小按钮
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- 隐藏声音聊天框
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- 隐藏游戏时间
GameTimeFrame:Hide()

-- 隐藏区域框
MinimapZoneTextButton:Hide()

-- 隐藏追踪按钮
MiniMapTracking:Hide()

-- 隐藏邮件按钮
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 3, 4)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Eui\\media\\mail")
MiniMapMailBorder:Hide()

-- 移动战场图标
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, 3, 0)
MiniMapBattlefieldBorder:Hide()

-- 隐藏世界地图图标
MiniMapWorldMapButton:Hide()

-- 移动3.3旗帜
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

-- 公会随机旗帜
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
GuildInstanceDifficulty:SetScale(0.85)

local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", E.Scale(2), E.Scale(1))
	MiniMapLFGFrameBorder:Hide()
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)

LFDSearchStatus:SetClampedToScreen(true)
LFDDungeonReadyStatus:SetClampedToScreen(true)
E.EuiSetTemplate(LFDSearchStatus)

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

mP:RegisterEvent("ADDON_LOADED")
mP:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TimeManager" then
		-- Hide Game Time
		E.Kill(TimeManagerClockButton)
	elseif addon == "Blizzard_FeedbackUI" then
		E.Kill(FeedbackUIButton)
	end
end)

if FeedbackUIButton then
	FeedbackUIButton:Kill()
end

--Hax so i don't have to localize this word, remove '/' and capitalize first letter
local calendar_string = "日历"

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
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
	{text = calendar_string,
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
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
	{text = "游戏选项",
    func = function() ToggleFrame(GameMenuFrame) end},
}
E.EuiSetTemplate(menuFrame)
Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "MiddleButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)

function GetMinimapShape() return 'SQUARE' end

local m_zone = CreateFrame("Frame", m_zone, UIParent)
	E.EuiSetTemplate(m_zone)
	m_zone:SetHeight(20)
	m_zone:SetFrameLevel(5)
	m_zone:SetPoint("TOPLEFT",Minimap)
	m_zone:SetPoint("TOPRIGHT",Minimap)
	m_zone:SetFrameLevel(Minimap:GetFrameLevel()+1)
	E.EuiSetAnim(m_zone,true,0,50)
	m_zone:Hide()

local m_zone_text = m_zone:CreateFontString(nil,"Overlay")
	m_zone_text:SetFont(C["skins"].font,13)
	m_zone_text:SetShadowOffset(1,-1)
	m_zone_text:SetPoint("LEFT",4.3,1.3)
	m_zone_text:SetPoint("RIGHT",-4.7,1.3)
	m_zone_text:SetJustifyH("CENTER")
	m_zone_text:SetHeight(13)
	
	
local m_coord = CreateFrame("Frame", m_coord, UIParent)
	E.EuiSetTemplate(m_coord)
	m_coord:SetHeight(20)
	m_coord:SetPoint("BOTTOMLEFT",Minimap)
	m_coord:SetWidth(45)
	m_coord:SetFrameLevel(Minimap:GetFrameLevel()+1)
	E.EuiSetAnim(m_coord,true,-50,0)
	m_coord:Hide()	
	
local m_coord_text = m_coord:CreateFontString(nil,"Overlay")
	m_coord_text:SetFont(C["skins"].font,10)
	m_coord_text:SetShadowOffset(1,-1)
	m_coord_text:SetPoint("Center",-.7,1.3)
	m_coord_text:SetJustifyH("LEFT")
	
Minimap:SetScript("OnEnter",function()
	m_zone.anim_o:Stop()
	m_coord.anim_o:Stop()
	m_zone:Show()
	m_coord:Show()
	m_coord.anim:Play()
	m_zone.anim:Play()
end)

Minimap:SetScript("OnLeave",function()
	m_coord.anim:Stop()
	m_coord.anim_o:Play()
	m_zone.anim:Stop()
	m_zone.anim_o:Play()
end)

m_coord_text:SetText("00,00")

local ela,go = 0,false

m_coord.anim:SetScript("OnFinished",function() go = true end)
m_coord.anim_o:SetScript("OnPlay",function() go = false end)

local coord_Update = function(self,t)
	ela = ela - t
	if ela > 0 or not(go) then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		m_coord_text:SetText("X _ X")
	else
		if x < 10 then 
			xt = "0"..x
		else 
			xt = x 
		end
		if y < 10 then 
			yt = "0"..y 
		else 
			yt = y 
		end
		m_coord_text:SetText(xt..","..yt)
	end
	ela = .2
end

m_coord:SetScript("OnUpdate",coord_Update)

local zone_Update = function()
	local pvp = GetZonePVPInfo()
	m_zone_text:SetText(GetMinimapZoneText())
	if pvp == "friendly" then
		m_zone_text:SetTextColor(0.1, 1.0, 0.1)
	elseif pvp == "sanctuary" then
		m_zone_text:SetTextColor(0.41, 0.8, 0.94)
	elseif pvp == "arena" or pvp == "hostile" then
		m_zone_text:SetTextColor(1.0, 0.1, 0.1)
	elseif pvp == "contested" then
		m_zone_text:SetTextColor(1.0, 0.7, 0.0)
	else
		m_zone_text:SetTextColor(1.0, 1.0, 1.0)
	end
end

m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent",zone_Update) 

local a,k = CreateFrame("Frame"),4
a:SetScript("OnUpdate",function(self,t)
k = k - t
if k > 0 then return end
self:Hide()
zone_Update()
end)