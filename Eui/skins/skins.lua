local E, C, L, DB = unpack(EUI)
if C["skins"].askins ~= true then return end

local function SetModifiedBackdrop(self)
	if C["main"].classcolortheme == true then
		local r = C["main"]["classcolorcustom"].r
		local g = C["main"]["classcolorcustom"].g
		local b = C["main"]["classcolorcustom"].b
		self:SetBackdropBorderColor(r, g, b,1)
	else
		self:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
end

local function SetOriginalBackdrop(self)
	self:SetBackdropColor(.1,.1,.1,1)
	if C["main"].classcolortheme == true then
		local r = C["main"]["classcolorcustom"].r
		local g = C["main"]["classcolorcustom"].g
		local b = C["main"]["classcolorcustom"].b	
		self:SetBackdropBorderColor(r, g, b,1)
	else
		self:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
end

local function SkinButton(f)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end
	
	if f.SetNormalTexture then
		f:SetNormalTexture("")
	end
	
	if f.SetHighlightTexture then
		f:SetHighlightTexture("")
	end
	
	if f.SetPushedTexture then
		f:SetPushedTexture("")
	end
	
	if f.SetDisabledTexture then
		f:SetDisabledTexture("")
	end
	E.EuiSetTemplate(f)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

local ePuiSkin = CreateFrame("Frame")
ePuiSkin:RegisterEvent("ADDON_LOADED")
ePuiSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end
	
	if IsAddOnLoaded("RaidAlerter") then
		if RaidAlerter_Attack_Frame then
			E.EuiSkinFadedPanel(RaidAlerter_Attack_Frame)
			RaidAlerter_Attack_Frame:SetNormalTexture(E.blank)
			RaidAlerter_Attack_Frame:SetPushedTexture(E.blank)
			RaidAlerter_Attack_Frame:SetHighlightTexture(E.blank)
		end
	end
	
	if IsAddOnLoaded("FriendsMenuXP") then
		if FriendsMenuXPSecure then
			FriendsMenuXPSecure:SetBackdrop(E.backdrop)
			E.EuiSetTemplate(FriendsMenuXPSecure)
		end
		if FriendsMenuXP then
			FriendsMenuXP:SetBackdrop(E.backdrop)
			E.EuiSetTemplate(FriendsMenuXP)
		end
	end
	-- stuff not in Blizzard load-on-demand
		-- Blizzard frame we want to reskin
		local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"GameMenuFrame",
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"LFDDungeonReadyStatus",
		"BNToastFrame",
		"TicketStatusFrameButton",
		"DropDownList1MenuBackdrop",
		"DropDownList2MenuBackdrop",
		"DropDownList1Backdrop",
		"DropDownList2Backdrop",
		"LFDSearchStatus",
		"AutoCompleteBox",
		"ConsolidatedBuffsTooltip",
		"ReadyCheckFrame",
		"StackSplitFrame",
		"CharacterFrame",
		}
		
		for i = 1, getn(skins) do
			E.EuiSetTemplate(_G[skins[i]])
			if _G[skins[i]] ~= _G["GhostFrameContentsFrame"] or _G[skins[i]] ~= _G["AutoCompleteBox"] then -- frame to blacklist from create shadow function
				E.EuiCreateShadow(_G[skins[i]])
			end
			_G[skins[i]]:SetBackdropColor(.1,.1,.1,0.8)
		end
		
		local ChatMenus = {
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",		
		}
		--
		for i = 1, getn(ChatMenus) do
			if _G[ChatMenus[i]] == _G["ChatMenu"] then
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) E.EuiSetTemplate(self) self:SetBackdropColor(.1,.1,.1,0.8) self:ClearAllPoints() self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end)
			else
				_G[ChatMenus[i]]:HookScript("OnShow", function(self) E.EuiSetTemplate(self) self:SetBackdropColor(.1,.1,.1,0.8) end)
			end
		end
		
		-- reskin popup buttons
		for i = 1, 3 do
			for j = 1, 3 do
				SkinButton(_G["StaticPopup"..i.."Button"..j])
			end
		end
		
		-- reskin all esc/menu buttons
		local BlizzardMenuButtons = {
			"Options", 
			"SoundOptions", 
			"UIOptions", 
			"Keybindings", 
			"Macros",
			"Ratings",
			"AddOns", 
			"Logout", 
			"Quit", 
			"Continue", 
			"MacOptions",
			"Help"
		}
		
		for i = 1, getn(BlizzardMenuButtons) do
			local ePuiMenuButtons = _G["GameMenuButton"..BlizzardMenuButtons[i]]
			if ePuiMenuButtons then
				SkinButton(ePuiMenuButtons)
			end
		end
		
		if IsAddOnLoaded("OptionHouse") then
			SkinButton(GameMenuButtonOptionHouse)
		end
		
		-- skin return to graveyard button
		
		-- hide header textures and move text/buttons.
		local BlizzardHeader = {
			"GameMenuFrame", 
			"InterfaceOptionsFrame", 
			"AudioOptionsFrame", 
			"VideoOptionsFrame",
		--	"ColorPickerFrame"
		}
		
		for i = 1, getn(BlizzardHeader) do
			local title = _G[BlizzardHeader[i].."Header"]			
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
				end
			end
		end
		
		-- here we reskin all "normal" buttons
		local BlizzardButtons = {
		"VideoOptionsFrameOkay", 
		"VideoOptionsFrameCancel", 
		"VideoOptionsFrameDefaults", 
		"VideoOptionsFrameApply", 
		"AudioOptionsFrameOkay", 
		"AudioOptionsFrameCancel", 
		"AudioOptionsFrameDefaults", 
		"InterfaceOptionsFrameDefaults", 
		"InterfaceOptionsFrameOkay", 
		"InterfaceOptionsFrameCancel",
		"ReadyCheckFrameYesButton",
		"ReadyCheckFrameNoButton",
		"StackSplitOkayButton",
		"StackSplitCancelButton",
		"RolePollPopupAcceptButton"
		}
		
		for i = 1, getn(BlizzardButtons) do
		local ePuiButtons = _G[BlizzardButtons[i]]
			if ePuiButtons then
				SkinButton(ePuiButtons)
			end
		end
		
		-- if a button position is not really where we want, we move it here
		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)
		_G["ColorPickerCancelButton"]:ClearAllPoints()
		_G["ColorPickerOkayButton"]:ClearAllPoints()
		_G["ColorPickerCancelButton"]:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -6, 6)
		_G["ColorPickerOkayButton"]:SetPoint("RIGHT",_G["ColorPickerCancelButton"],"LEFT", -4,0)
		_G["ReadyCheckFrameYesButton"]:SetParent(_G["ReadyCheckFrame"])
		_G["ReadyCheckFrameNoButton"]:SetParent(_G["ReadyCheckFrame"]) 
		_G["ReadyCheckFrameYesButton"]:SetPoint("RIGHT", _G["ReadyCheckFrame"], "CENTER", -1, 0)
		_G["ReadyCheckFrameNoButton"]:SetPoint("LEFT", _G["ReadyCheckFrameYesButton"], "RIGHT", 3, 0)
		_G["ReadyCheckFrameText"]:SetParent(_G["ReadyCheckFrame"])	
		_G["ReadyCheckFrameText"]:ClearAllPoints()
		_G["ReadyCheckFrameText"]:SetPoint("TOP", 0, -12)
		
		-- others
		_G["ReadyCheckListenerFrame"]:SetAlpha(0)
		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if self.initiator then if UnitIsUnit("player", self.initiator) then  self:Hide() end end end) -- bug fix, don't show it if initiator
		_G["StackSplitFrame"]:GetRegions():Hide()
		E.EuiSetTemplate(LFDDungeonReadyDialog)
		E.EuiCreateShadow(LFDDungeonReadyDialog)
		SkinButton(LFDDungeonReadyDialogEnterDungeonButton)
		SkinButton(LFDDungeonReadyDialogLeaveQueueButton)
		E.EuiSetTemplate(RolePollPopup)
		E.EuiCreateShadow(RolePollPopup)
	
end)