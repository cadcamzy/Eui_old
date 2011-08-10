local E, C, L, DB = unpack(EUI)
if not C["chat"].enable == true then return end

local AutoApply = true
local def_position = {"BOTTOMLEFT",UIParent,E.Scale(12),E.Scale(10)}
local chat_height = E.Scale(C["chat"].chath)
local chat_width = E.Scale(C["chat"].chatw)
local fontsize = 14
SetCVar("chatStyle", "classic")
local backdrop_tab = {
		  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		  edgeFile = "Interface\\Buttons\\WHITE8x8", 
		  tile = false, tileSize = 0, edgeSize = E.Scale(1), 
		  insets = { left = -E.Scale(1), right = -E.Scale(1), top = -E.Scale(1), bottom = -E.Scale(1)}
		}

local LinkHover = {}; LinkHover.show = {
	["achievement"] = true,
	["enchant"]     = true,
	["glyph"]       = true,
	["item"]        = true,
	["quest"]       = true,
	["spell"]       = true,
	["talent"]      = true,
	["unit"]        = true,}

for i = 1, NUM_CHAT_WINDOWS do
  local cf = _G['ChatFrame'..i]
  if cf then 
    cf:SetFont(E.font, 12, "OUTLINE") 
    cf:SetFrameStrata("LOW")
    cf:SetFrameLevel(2)
  end
  local tab = _G['ChatFrame'..i..'Tab']
  if tab then
    tab:GetFontString():SetFont(E.font, 13, "OUTLINE")
    --fix for color and alpha of undocked frames
    tab:GetFontString():SetTextColor(1,0.7,0)
    tab:SetAlpha(1)
  end
end

---------------- > Sticky Channels
ChatTypeInfo['SAY'].sticky = 1
ChatTypeInfo['YELL'].sticky = 0
ChatTypeInfo['EMOTE'].sticky = 0
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
ChatTypeInfo['RAID_WARNING'].sticky = 0
ChatTypeInfo['BATTLEGROUND'].sticky = 1
ChatTypeInfo['WHISPER'].sticky = 0
ChatTypeInfo['CHANNEL'].sticky = 1


---------------- > Fading alpha
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 1

---------------- > Function to move and scale chatframes 
SetChat = function()
    FCF_SetLocked(ChatFrame1, nil)
	if LjxxuiInstallV401 ~= true then
		FCF_SetChatWindowFontSize(self, ChatFrame1, fontsize) 
	end
    ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("TOPLEFT", EuiLeftChatBackground, "TOPLEFT", E.Scale(2),-E.Scale(2))
	ChatFrame1:SetPoint("BOTTOMRIGHT", EuiLeftChatBackground, "BOTTOMRIGHT", -E.Scale(2), E.Scale(2))
    ChatFrame1:SetWidth(chat_width-E.Scale(19))
    ChatFrame1:SetHeight(chat_height-E.Scale(7))
    ChatFrame1:SetFrameLevel(8)
    ChatFrame1:SetUserPlaced(true)
	for i=1,10 do local cf = _G["ChatFrame"..i] FCF_SetWindowAlpha(cf, 0) end
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")	
end
SlashCmdList["SETCHAT"] = SetChat
SLASH_SETCHAT1 = "/setchat"
if AutoApply then
	local f = CreateFrame"Frame"
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function() SetChat() end)
end

do
	-- Buttons Hiding/moving 
	local kill = function(f) f:Hide() end
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", kill)
	FriendsMicroButton:Hide()
	FriendsMicroButton:SetScript("OnShow", kill)

	for i=1, 10 do
		local cf = _G[format("%s%d", "ChatFrame", i)]
	--fix fading
		local tab = _G["ChatFrame"..i.."Tab"]
		cf:SetFading(false)
	_G["ChatFrame"..i.."TabLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightMiddle"]:SetTexture(nil)
	
		local f = _G["ChatFrame"..i.."ButtonFrame"]
		f.Show = f.Hide 
		f:Hide()
	
	--Unlimited chatframes resizing
		cf:SetMinResize(0,0)
		cf:SetMaxResize(0,0)
	
	--Allow the chat frame to move to the end of the screen
		cf:SetClampedToScreen(false)
		cf:SetClampRectInsets(0,0,0,0)
	
	--EditBox Module
		local ebParts = {'Left', 'Mid', 'Right'}
		local eb = _G['ChatFrame'..i..'EditBox']
		local cf = _G[format("%s%d", "ChatFrame", i)]
	--	for _, ebPart in ipairs(ebParts) do
	--		_G['ChatFrame'..i..'EditBox'..ebPart]:SetTexture(0, 0, 0, 0)
	--		local ebed = _G['ChatFrame'..i..'EditBoxFocus'..ebPart]
	--		ebed:SetTexture(0,0,0,0.8)
	--		ebed:SetHeight(E.Scale(18))
	--	end
		local tex=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
		tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0) tex[11]:SetAlpha(0)
		eb:SetAltArrowKeyMode(false)
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT", cf, "TOPLEFT",  -E.Scale(14), 0)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", E.Scale(12), 0)
	
	--Remove scroll buttons
		local bf = _G['ChatFrame'..i..'ButtonFrame']
		bf:Hide()
		bf:SetScript("OnShow",  kill)
	
	--Scroll to the bottom button
		local function BottomButtonClick(self)
			self:GetParent():ScrollToBottom();
		end
		local bb = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
		bb:SetParent(_G["ChatFrame"..i])
		bb:SetHeight(E.Scale(18))
		bb:SetWidth(E.Scale(18))
		bb:ClearAllPoints()
		bb:SetPoint("RIGHT", EuiTopChatBackground, "RIGHT", -1, 0)
		bb:SetAlpha(0.4)
		bb:RegisterForClicks("AnyDown")
		bb.SetPoint = function() end
		bb:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				BottomButtonClick(bb)
				SetChat()
			elseif button == "RightButton" then
				if LFW_SHOW then
					LFW_SHOW = false
					DEFAULT_CHAT_FRAME:AddMessage("关闭LFW频道");
				else
					LFW_SHOW = true
					DEFAULT_CHAT_FRAME:AddMessage("打开LFW频道");
				end
			end
		end)
	end
end

local editbox = CreateFrame('Button', nil, ChatFrame1EditBox)
editbox:SetBackdrop{
	bgFile = E.normTex,
	edgeFile = E.normTex, 
	tile = false, tileSize = 0, edgeSize = 1, 
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}
editbox:SetAllPoints(EuiTopChatBackground)
editbox:SetFrameLevel(ChatFrame1EditBox:GetFrameLevel()-1)
editbox:Hide()

local function colorize(r,g,b)
	if type(r) == 'table' then
		if r.r then
			r,g,b = r.r, r.g, r.b
		else
			r,g,b = unpack(r)
		end
	end
	if r and g and b then
		editbox:SetBackdropBorderColor(r,g,b)
		editbox:SetBackdropColor(r/5,g/5,b/5, 0.7)
	end
end

hooksecurefunc('ChatEdit_UpdateHeader', function()
	local type = DEFAULT_CHAT_FRAME.editBox:GetAttribute('chatType')
	if ( type == 'CHANNEL' ) then
		local id = GetChannelName(DEFAULT_CHAT_FRAME.editBox:GetAttribute('channelTarget'))
		if id == 0 then	colorize(0.5,0.5,0.5)
		else colorize(ChatTypeInfo[type..id])
		end
	else colorize(ChatTypeInfo[type])
	end
end)

local show_in = function(self,nf)

	self.show_in = self:CreateAnimationGroup("In")
	
	self.show_in.a = self.show_in:CreateAnimation("Translation")
	self.show_in.a:SetOffset(0,-chat_height - 80)
	self.show_in.a:SetDuration(0)
	self.show_in.a:SetOrder(1)
	
	self.show_in.b = self.show_in:CreateAnimation("Translation")
	self.show_in.b:SetOffset(0,chat_height + 80)
	self.show_in.b:SetDuration(.2)
	self.show_in.b:SetOrder(2)
	
	self.show_in.b:SetSmoothing("OUT")
	
end

local show_out = function(self,nf)

	self.show_out = self:CreateAnimationGroup("OUT")
	
	self.show_out.a = self.show_out:CreateAnimation("Translation")
	self.show_out.a:SetOffset(0,-chat_height - 80)
	self.show_out.a:SetDuration(.2)
	self.show_out.a:SetOrder(1)
	
	self.show_out.a:SetSmoothing("IN")
	
end

show_in(ChatFrame1EditBox)
show_in(editbox)
show_out(editbox)

editbox.show_out:SetScript("OnFinished",function() editbox:Hide() end)

ChatFrame1EditBox:HookScript("OnShow", function(self)
	editbox:Show()
	editbox.show_out:Stop()
	editbox.show_in:Play()
	self.show_in:Play()
end)

ChatFrame1EditBox:HookScript("OnHide", function(self)
	editbox.show_in:Stop()
	self.show_in:Stop()
	editbox.show_out:Play()
end)


---------------- > TellTarget function
local function telltarget(msg)
	if not UnitExists("target") or not (msg and msg:len()>0) or not UnitIsFriend("player","target") then return end
	local name, realm = UnitName("target")
	if realm and not UnitIsSameServer("player", "target") then
		name = ("%s-%s"):format(name, realm)
	end
	SendChatMessage(msg, "WHISPER", nil, name)
end
SlashCmdList["TELLTARGET"] = telltarget
SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/ее"
SLASH_TELLTARGET3 = "/wt"

---------------- > Channel names
local gsub = _G.string.gsub
local time = _G.time
local newAddMsg = {}
local chn, rplc
do
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h[BG]|h %s:\32"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h[BGL]|h %s:\32"
	CHAT_GUILD_GET = "|Hchannel:Guild|h[G]|h %s:\32"
	CHAT_PARTY_GET = "|Hchannel:Party|h[P]|h %s:\32"
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h[PL]|h %s:\32"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[PL]|h %s:\32"
	CHAT_OFFICER_GET = "|Hchannel:o|h[O]|h %s:\32"
	CHAT_RAID_GET = "|Hchannel:raid|h[R]|h %s:\32"
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h[RL]|h %s:\32"
	CHAT_RAID_WARNING_GET = "[RW] %s:\32"
	CHAT_WHISPER_INFORM_GET = "to %s: "
	CHAT_WHISPER_GET = "from %s: "
	CHAT_SAY_GET = "%s:\32"
	CHAT_YELL_GET = "%s:\32"
	CHAT_BN_WHISPER_GET = "from %s:\32"
	CHAT_BN_WHISPER_INFORM_GET = "to %s:\32"
	CHAT_BN_WHISPER_SEND = "Tell %s:\32"
	rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
	}
	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn = {
			"%[%d+%. Общий.-%]",
			"%[%d+%. Торговля.-%]",
			"%[%d+%. Оборона: глобальный%]", --Defense: Global
			"%[%d+%. Оборона.-%]", --Defense: Zone
			"%[%d+%. Поиск спутников%]",
			"%[%d+%. Гильдии.-%]",
		}
	elseif L == "deDE" then --German
		chn = {
			"%[%d+%. Allgemein.-%]",
			"%[%d+%. Handel.-%]",
			"%[%d+%. Weltverteidigung%]",
			"%[%d+%. LokaleVerteidigung.-%]",
			"%[%d+%. SucheNachGruppe%]",
			"%[%d+%. Gildenrekrutierung.-%]",
		}
	else --English & any other language not translated above.
		chn = {
			"%[%d+%. General.-%]",
			"%[%d+%. Trade.-%]",
			"%[%d+%. WorldDefense%]",
			"%[%d+%. LocalDefense.-%]",
			"%[%d+%. LookingForGroup%]",
			"%[%d+%. GuildRecruitment.-%]",
		}
	end
end
local function AddMessage(frame, text, ...)
	for i = 1, 6 do
		text = gsub(text, chn[i], rplc[i])
	end
	if CHAT_TIMESTAMP_FORMAT and not text:find("|r") then
		text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
	end
	text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
	return newAddMsg[frame:GetName()](frame, text, ...)
end
do
	for i = 1, 5 do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end
end

---------------- > ChatCopy Module
local lines = {}
do
	--Create Frames/Objects
	local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 3, right = 3, top = 5, bottom = 3}})
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(E.Scale(500))
	frame:SetHeight(E.Scale(400))
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	E.EuiSetTemplate(frame)
	E.EuiCreateShadow(frame)
	local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", E.Scale(8), -E.Scale(30))
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -E.Scale(30), E.Scale(8))

	local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(E.Scale(400))
	editBox:SetHeight(E.Scale(270))
	editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)
	scrollArea:SetScrollChild(editBox)
	
	local close = CreateFrame("Button", "BCMCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	local copyFunc = function(frame, btn)
		local cf = _G[format("%s%d", "ChatFrame", frame:GetID())]
		local _, size = cf:GetFont()
		FCF_SetChatWindowFontSize(cf, cf, 0.01)
		local ct = 1
		for i = select("#", cf:GetRegions()), 1, -1 do
			local region = select(i, cf:GetRegions())
			if region:GetObjectType() == "FontString" then
				lines[ct] = tostring(region:GetText())
				ct = ct + 1
			end
		end
		local lineCt = ct - 1
		local text = table.concat(lines, "\n", 1, lineCt)
		FCF_SetChatWindowFontSize(cf, cf, size)
		BCMCopyFrame:Show()
		BCMCopyBox:SetText(text)
		BCMCopyBox:HighlightText(0)
		wipe(lines)
	end
	local hintFunc = function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOP")
		if SHOW_NEWBIE_TIPS == "1" then
			GameTooltip:AddLine(CHAT_OPTIONS_LABEL, 1, 1, 1)
			GameTooltip:AddLine(NEWBIE_TOOLTIP_CHATOPTIONS, nil, nil, nil, 1)
		end
		GameTooltip:AddLine((SHOW_NEWBIE_TIPS == "1" and "\n" or "").."|TInterface\\Buttons\\UI-GuildButton-OfficerNote-Disabled:27|tDouble-click to copy chat.", 1, 0, 0)
		GameTooltip:Show()
	end
	for i = 1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetScript("OnDoubleClick", copyFunc)
		tab:SetScript("OnEnter", hintFunc)
	end
end

---------------- > Show tooltips when hovering a link in chat (credits to Adys for his LinkHover)
function LinkHover.OnHyperlinkEnter(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] and IsAltKeyDown() then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end
function LinkHover.OnHyperlinkLeave(_this, linkData, link)
	local t = linkData:match("^(.-):")
	if LinkHover.show[t] then
		HideUIPanel(GameTooltip)
	end
end
local function main()
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		frame:SetScript("OnHyperlinkEnter", LinkHover.OnHyperlinkEnter)
		frame:SetScript("OnHyperlinkLeave", LinkHover.OnHyperlinkLeave)
	end
end
main()

if C["chat"].hidejunk == true then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)
	DUEL_WINNER_KNOCKOUT, DUEL_WINNER_RETREAT = "", ""
	DRUNK_MESSAGE_ITEM_OTHER1 = "", ""
	DRUNK_MESSAGE_ITEM_OTHER2 = "", ""
	DRUNK_MESSAGE_ITEM_OTHER3 = "", ""
	DRUNK_MESSAGE_ITEM_OTHER4 = "", ""
	DRUNK_MESSAGE_OTHER1 = "", ""
	DRUNK_MESSAGE_OTHER2 = "", ""
	DRUNK_MESSAGE_OTHER3 = "", ""
	DRUNK_MESSAGE_OTHER4 = "", ""
	DRUNK_MESSAGE_ITEM_SELF1 = "", ""
	DRUNK_MESSAGE_ITEM_SELF2 = "", ""
	DRUNK_MESSAGE_ITEM_SELF3 = "", ""
	DRUNK_MESSAGE_ITEM_SELF4 = "", ""
	DRUNK_MESSAGE_SELF1 = "", ""
	DRUNK_MESSAGE_SELF2 = "", ""
	DRUNK_MESSAGE_SELF3 = "", ""
	DRUNK_MESSAGE_SELF4 = "", ""
	RAID_MULTI_LEAVE = "", ""
	RAID_MULTI_JOIN = "", ""
	ERR_PET_LEARN_ABILITY_S = "", ""
	ERR_PET_LEARN_SPELL_S = "", ""
	ERR_PET_SPELL_UNLEARNED_S = "", ""
end

--TAB切换频道模块
function ChatEdit_CustomTabPressed(self)
   if (self:GetAttribute("chatType") == "SAY") then
      if Ash_Tabcus then
         self:SetAttribute("chatType", "CHANNEL");
         self.text = "/"..Ash_Tabcus.." "..self.text
         ChatEdit_UpdateHeader(self);
      elseif (GetNumPartyMembers()>0) then
         self:SetAttribute("chatType", "PARTY");
         ChatEdit_UpdateHeader(self);
      elseif (GetNumRaidMembers()>0) then
         self:SetAttribute("chatType", "RAID");
         ChatEdit_UpdateHeader(self);
      elseif (GetNumBattlefieldScores()>0) then
         self:SetAttribute("chatType", "BATTLEGROUND");
         ChatEdit_UpdateHeader(self);
      elseif (IsInGuild()) then
         self:SetAttribute("chatType", "GUILD");
         ChatEdit_UpdateHeader(self);
      else
         return;
      end
   elseif (self:GetAttribute("chatType") == "PARTY") then
      if (GetNumRaidMembers()>0) then
         self:SetAttribute("chatType", "RAID");
         ChatEdit_UpdateHeader(self);
      elseif (GetNumBattlefieldScores()>0) then
         self:SetAttribute("chatType", "BATTLEGROUND");
         ChatEdit_UpdateHeader(self);
      elseif (IsInGuild()) then
         self:SetAttribute("chatType", "GUILD");
         ChatEdit_UpdateHeader(self);
      else
         self:SetAttribute("chatType", "SAY");
         ChatEdit_UpdateHeader(self);
      end         
   elseif (self:GetAttribute("chatType") == "RAID") then
      if (GetNumBattlefieldScores()>0) then
         self:SetAttribute("chatType", "BATTLEGROUND");
         ChatEdit_UpdateHeader(self);
      elseif (IsInGuild()) then
         self:SetAttribute("chatType", "GUILD");
         ChatEdit_UpdateHeader(self);
      else
         self:SetAttribute("chatType", "SAY");
         ChatEdit_UpdateHeader(self);
      end
   elseif (self:GetAttribute("chatType") == "BATTLEGROUND") then
      if (IsInGuild) then
         self:SetAttribute("chatType", "GUILD");
         ChatEdit_UpdateHeader(self);
      else
         self:SetAttribute("chatType", "SAY");
         ChatEdit_UpdateHeader(self);
      end
   elseif (self:GetAttribute("chatType") == "GUILD") then
      self:SetAttribute("chatType", "SAY");
      ChatEdit_UpdateHeader(self);
   elseif (self:GetAttribute("chatType") == "CHANNEL") then
      if (GetNumPartyMembers()>0) then
         self:SetAttribute("chatType", "PARTY");
         ChatEdit_UpdateHeader(self);
      elseif (GetNumRaidMembers()>0) then
         self:SetAttribute("chatType", "RAID");
         ChatEdit_UpdateHeader(self);
      elseif (GetNumBattlefieldScores()>0) then
         self:SetAttribute("chatType", "BATTLEGROUND");
         ChatEdit_UpdateHeader(self);
      elseif (IsInGuild()) then
         self:SetAttribute("chatType", "GUILD");
         ChatEdit_UpdateHeader(self);
      else
         self:SetAttribute("chatType", "SAY");
         ChatEdit_UpdateHeader(self);
      end
   end
end 

---------------- > Chat Scroll Module
hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollUp()
			self:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			--only need to scroll twice because of blizzards scroll
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end)

---------------- > afk/dnd msg filter
local data = {}
local chatEvent = function(msg)
	if(data[arg2] and data[arg2] == arg1)then
		return true
	else
		data[arg2] = arg1
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", chatEvent)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", chatEvent)

---------------- > URLCopy Module
local tlds = {
	"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
	"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
	"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
	"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]"}
local gsub = gsub
local filterFunc = function(self, event, msg, ...)
	for i=1, 21 do --Number of TLD's in tlds table
		local newMsg, found = gsub(msg, "(%S-%."..tlds[i].."/?%S*)", "|cffffffff|Hurl:%1|h[%1]|h|r")
		if found > 0 then
			return false, newMsg, ...
		end
	end
	local newMsg, found = gsub(msg, "(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)", "|cffffffff|Hurl:%1|h[%1]|h|r")
	if found > 0 then
		return false, newMsg, ...
	end
end
do
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", filterFunc)
	local currentLink = nil
	ChatFrame_OnHyperlinkShow = function(self, link, text, button)
		if (link):sub(1, 3) == "url" then
			currentLink = (link):sub(5)
			StaticPopup_Show("BCMUrlCopyDialog")
			return
		end
		SetItemRef(link, text, button, self)
	end
	StaticPopupDialogs["BCMUrlCopyDialog"] = {
		text = "URL",
		button2 = TEXT(CLOSE),
		hasEditBox = 1,
		hasWideEditBox = 1,
		showAlert = 1,
		OnShow = function(frame)
			local editBox = _G[frame:GetName().."WideEditBox"]
			editBox:SetText(currentLink)
			currentLink = nil
			editBox:SetBackdropColor(0.1,0.1,0.1,1)
			editBox:SetBackdropBorderColor(0.31, 0.45, 0.63,1)			
			editBox:SetFocus()
			editBox:HighlightText(0)
			local button = _G[frame:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetWidth(E.Scale(200))
			button:SetPoint("CENTER", editBox, "CENTER", 0, -E.Scale(30))
			_G[frame:GetName().."AlertIcon"]:Hide()
		end,
		EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,}
end

if C["chat"].bodylevel > 0 then
	--good players(guildies/friends), maybe(for processing)
	local good, maybe, badboy, filterTable, login = {}, {}, CreateFrame("Frame", "BadBoy_Levels"), {}, nil
	local whisp = L.CHAT_TIP1
	local err = L.CHAT_TIP2

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_,_,msg)
		if msg == ERR_FRIEND_LIST_FULL then
			print("|cFF33FF99BadBoy_Levels|r: ", err) --print a warning if we see a friends full message
			return
		end
		--this is a filter to remove the player added/removed from friends messages when we use it, otherwise they are left alone
		for k in pairs(filterTable) do
			if msg == (ERR_FRIEND_ADDED_S):format(k) or msg == (ERR_FRIEND_REMOVED_S):format(k) then
				return true
			end
		end
	end)

	badboy:RegisterEvent("FRIENDLIST_UPDATE")
	badboy:SetScript("OnEvent", function(_, evt)
		if not login then --run on login only
			login = true
			local num = GetNumFriends()
			for i = 1, num do
				local n = GetFriendInfo(i)
				--add friends to safe list
				if n then good[n] = true end
			end
			return
		end

		local num = GetNumFriends() --get total friends
		for i = 1, num do
			local player, level = GetFriendInfo(i)
			--sometimes a friend will return nil, I have no idea why, so force another update
			if not player then
				ShowFriends()
			else
				if maybe[player] then --do we need to process this person?
					RemoveFriend(player, true) --Remove player from friends list, the 2nd arg "true" is a fake arg added by request of tekkub, author of FriendsWithBenefits
					if type(level) ~= "number" then print("Level wasn't a number, tell BadBoy author! It was:", level) end
					if level < filterTable[player] then
						--lower than level 2, or a level defined by the user = bad,
						--or lower than 58 and class is a Death Knight,
						--so whisper the bad player what level they must be to whisper us
						SendChatMessage(whisp:format(filterTable[player]), "WHISPER", nil, player)
						for _, v in pairs(maybe[player]) do
							for _, p in pairs(v) do
								wipe(p) --remove player data table
							end
							wipe(v) --remove player data table
						end
					else
						good[player] = true --higher = good
						--get all the frames, incase whispers are being recieved in more that one chat frame
						for _, v in pairs(maybe[player]) do
							--get all the chat lines (queued if multiple) for restoration back to the chat frame
							for _, p in pairs(v) do
								--this player is good, we must restore the whisper(s) back to chat
								if IsAddOnLoaded("WIM") then --WIM compat
									WIM.modules.WhisperEngine:CHAT_MSG_WHISPER(unpack(p))
								else
									ChatFrame_MessageEventHandler(unpack(p))
								end
								wipe(p) --remove player data table
							end
							wipe(v) --remove player data table
						end
					end
					wipe(maybe[player]) --remove player data table
					maybe[player] = nil --remove remaining empty table
				end
			end
		end
	end)
	--incoming whisper filtering function
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", function(...)
		--don't filter if good, GM, guild member, or x-server
		local player = select(4, ...)
		if UnitIsInMyGuild(player) or good[player] or player:find("%-") then return end
		local flag = select(8, ...)
		if flag == "GM" then return end

		--RealID support, don't scan people that whisper us via their character instead of RealID
		--that aren't on our friends list, but are on our RealID list.
		for i=1, select(2, BNGetNumFriends()) do
			local toon = BNGetNumFriendToons(i)
			for j=1, toon do
				local _, rName, rGame, rServer = BNGetFriendToonInfo(i, j)
				if rName == player and rGame == "WoW" and rServer == GetRealmName() then
					good[player] = true
					return
				end
			end
		end
	
		if not maybe[player] then maybe[player] = {} end --added to maybe
		local f = ...
		f = f:GetName()
		if IsAddOnLoaded("WIM") and not f:find("WIM") then return true end --WIM compat
		--one table per chatframe, incase we got whispers on 2+ chatframes
		if not maybe[player][f] then maybe[player][f] = {} end
		--one table per id, incase we got more than one whisper from a player whilst still processing
		local id = select(13, ...)
		maybe[player][f][id] = {}
		local n = IsAddOnLoaded("WIM") and 2 or 0 --WIM compat
		for i = 1, select("#", ...) do
			--store all the chat arguments incase we need to add it back (if it's a new good guy)
			maybe[player][f][id][i] = select(i+n, ...)
		end
		--Decide the level to be filtered
		local guid = select(14, ...)
		local _, englishClass = GetPlayerInfoByGUID(guid)
		local level = C["chat"].bodylevel and tonumber(C["chat"].bodylevel)+1 or 2
		if englishClass == "DEATHKNIGHT" then level = 58 end
		--Don't try to add a player to friends several times for 1 whisper (registered to more than 1 chat frame)
		if not filterTable[player] or filterTable[player] ~= level then
			filterTable[player] = level
			AddFriend(player, true) --add player to friends, the 2nd arg "true" is a fake arg added by request of tekkub, author of FriendsWithBenefits
		end
		return true --filter everything not good (maybe) and not GM
	end)

	--outgoing whisper filtering function
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", function(_,_,msg,player)
		if good[player] then return end --Do nothing if on safe list
		if filterTable[player] and msg:find("^BadBoy.*"..filterTable[player]) then return true end --Filter auto-response
		good[player] = true --If we want to whisper someone, they're good
	end)
	
end




if C["chat"].chatbar == true then
	local cbar = CreateFrame("Frame", "favchat", favchat)
	cbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	cbar:RegisterEvent("ADDON_LOADED")

	function cbar:W(button)
		ChatFrame_OpenChat("/w ", SELECTED_DOCK_FRAME);		
	end
	function cbar:S(button)
		ChatFrame_OpenChat("/s ", SELECTED_DOCK_FRAME);	
	end

	function cbar:O(button)
		ChatFrame_OpenChat("/o ", SELECTED_DOCK_FRAME);		
	end
	function cbar:G(button)	
		ChatFrame_OpenChat("/g ", SELECTED_DOCK_FRAME);	
	end

	function cbar:R(button)
		ChatFrame_OpenChat("/raid ", SELECTED_DOCK_FRAME);		
	end
	function cbar:P(button)
		ChatFrame_OpenChat("/p ", SELECTED_DOCK_FRAME);	
	end

	function cbar:GT(button)
		ChatFrame_OpenChat("/1 ", SELECTED_DOCK_FRAME);		
	end
	function cbar:LGT(button)
		ChatFrame_OpenChat("/2 ", SELECTED_DOCK_FRAME);	
	end

	function cbar:Y(button)
		ChatFrame_OpenChat("/y ", SELECTED_DOCK_FRAME);		
	end
	function cbar:YG(button)
		ChatFrame_OpenChat("/4 ", SELECTED_DOCK_FRAME);	
	end
	local space
	space = (C["chat"].chatw - 74 - 18*10) / 11 
	function cbar:Style()
		favchat:ClearAllPoints()
		favchat:SetParent(UIParent)
		s = CreateFrame("Button", "s", favchat)
		s:ClearAllPoints()
		s:SetHighlightTexture(E.highlightTex)
		s:SetParent(favchat)
		s:SetPoint("LEFT", EuiBottomInfobg, "LEFT", 4, 0)
		s:SetWidth(18)
		s:SetHeight(18)
		s:RegisterForClicks("AnyUp")
		s:SetScript("OnClick", cbar.S)
		stex = E.EuiSetFontn(s,E.font,14)
		stex:SetPoint("CENTER",0,0)
		stex:SetText("S")
	--	stex:SetTextColor(23/255,132/255,209/255)
	
		w = CreateFrame("Button", "w", favchat)
		w:ClearAllPoints()
		w:SetHighlightTexture(E.highlightTex)
		w:SetParent(favchat)
		w:SetPoint("LEFT", s, "RIGHT", space, 0)
		w:SetWidth(E.Scale(18))
		w:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(w)
		w:RegisterForClicks("AnyUp")
		w:SetScript("OnClick", cbar.W)
		wtex = E.EuiSetFontn(w,E.font,14)
		wtex:SetPoint("CENTER",0,0)
		wtex:SetText("W")
	--	wtex:SetTextColor(23/255,132/255,209/255)

		g = CreateFrame("Button", "g", favchat)
		g:ClearAllPoints()
		g:SetHighlightTexture(E.highlightTex)
		g:SetParent(favchat)
		g:SetPoint("LEFT", w, "RIGHT", space, 0)
		g:SetWidth(E.Scale(18))
		g:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(g)
		g:RegisterForClicks("AnyUp")
		g:SetScript("OnClick", cbar.G)
		gtex = E.EuiSetFontn(g,E.font,14)
		gtex:SetPoint("CENTER",0,0)
		gtex:SetText("G")
	--	gtex:SetTextColor(23/255,132/255,209/255)
		
		o = CreateFrame("Button", "o", favchat)
		o:ClearAllPoints()
		o:SetHighlightTexture(E.highlightTex)
		o:SetParent(favchat)
		o:SetPoint("LEFT", g, "RIGHT", space, 0)
		o:SetWidth(E.Scale(18))
		o:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(o)
		o:RegisterForClicks("AnyUp")
		o:SetScript("OnClick", cbar.O)
		otex = E.EuiSetFontn(o,E.font,14)
		otex:SetPoint("CENTER",0,0)
		otex:SetText("O")
	--	otex:SetTextColor(23/255,132/255,209/255)
		
		r = CreateFrame("Button", "r", favchat)
		r:ClearAllPoints()
		r:SetHighlightTexture(E.highlightTex)
		r:SetParent(favchat)
		r:SetPoint("LEFT", o, "RIGHT", space, 0)
		r:SetWidth(E.Scale(18))
		r:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(r)
		r:RegisterForClicks("AnyUp")
		r:SetScript("OnClick", cbar.R)
		rtex = E.EuiSetFontn(r,E.font,14)
		rtex:SetPoint("CENTER",0,0)
		rtex:SetText("R")
	--	rtex:SetTextColor(23/255,132/255,209/255)
		
		p = CreateFrame("Button", "p", favchat)
		p:ClearAllPoints()
		p:SetHighlightTexture(E.highlightTex)
		p:SetParent(favchat)
		p:SetPoint("LEFT", r, "RIGHT", space, 0)
		p:SetWidth(E.Scale(18))
		p:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(p)
		p:RegisterForClicks("AnyUp")
		p:SetScript("OnClick", cbar.P)
		ptex = E.EuiSetFontn(p,E.font,14)
		ptex:SetPoint("CENTER",0,0)
		ptex:SetText("P")
	--	ptex:SetTextColor(23/255,132/255,209/255)
		
		gt = CreateFrame("Button", "gt", favchat)
		gt:ClearAllPoints()
		gt:SetHighlightTexture(E.highlightTex)
		gt:SetParent(favchat)
		gt:SetPoint("LEFT", p, "RIGHT", space, 0)
		gt:SetWidth(E.Scale(18))
		gt:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(gt)
		gt:RegisterForClicks("AnyUp")
		gt:SetScript("OnClick", cbar.GT)
		gttex = E.EuiSetFontn(gt,E.font,14)
		gttex:SetPoint("CENTER",0,0)
		gttex:SetText("1")
	--	gttex:SetTextColor(23/255,132/255,209/255)
		
		lgt = CreateFrame("Button", "lgt", favchat)
		lgt:ClearAllPoints()
		lgt:SetHighlightTexture(E.highlightTex)
		lgt:SetParent(favchat)
		lgt:SetPoint("LEFT", gt, "RIGHT", space, 0)
		lgt:SetWidth(E.Scale(18))
		lgt:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(lgt)
		lgt:RegisterForClicks("AnyUp")
		lgt:SetScript("OnClick", cbar.LGT)
		lgttex = E.EuiSetFontn(lgt,E.font,14)
		lgttex:SetPoint("CENTER",0,0)
		lgttex:SetText("2")
	--	lgttex:SetTextColor(23/255,132/255,209/255)
		
		yg = CreateFrame("Button", "yg", favchat)
		yg:ClearAllPoints()
		yg:SetHighlightTexture(E.highlightTex)
		yg:SetParent(favchat)
		yg:SetPoint("LEFT", lgt, "RIGHT", space, 0)
		yg:SetWidth(E.Scale(18))
		yg:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(yg)
		yg:RegisterForClicks("AnyUp")
		yg:SetScript("OnClick", cbar.YG)
		ygtex = E.EuiSetFontn(yg,E.font,14)
		ygtex:SetPoint("CENTER",0,0)
		ygtex:SetText("4")
	--	ygtex:SetTextColor(23/255,132/255,209/255)

		y = CreateFrame("Button", "y", favchat)
		y:ClearAllPoints()
		y:SetHighlightTexture(E.highlightTex)
		y:SetParent(favchat)
		y:SetPoint("LEFT", yg, "RIGHT", space, 0)
		y:SetWidth(E.Scale(18))
		y:SetHeight(E.Scale(18))
	--	E.EuiSetTemplate(y)
		y:RegisterForClicks("AnyUp")
		y:SetScript("OnClick", cbar.Y)
		ytex = E.EuiSetFontn(y,E.font,14)
		ytex:SetPoint("CENTER",0,0)
		ytex:SetText("Y")
	--	ytex:SetTextColor(23/255,132/255,209/255)
		
		chatbarist = true
	end

	function cbar:ADDON_LOADED(event, name)
		self:Style()
	end
	
end