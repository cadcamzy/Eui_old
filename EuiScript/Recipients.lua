local E, C = unpack(EUI)
if C["other"].recipients ~= true then return end

	RECIPIENTS_LOCALE = {
		["title"] = "Recipients",
		["add"] = "|cff00ff00添加: |r ",
		["remove"] = "|cffff0000刪除: |r ",
		["full"] = "|cffff0000|已达到列表数量上限！r",
		["count"] = "|cffffffff现有|r |cff00ff00%d|r |cffffffff收件人在列表中|r",
		["click open"] = "|cff00ff00点击: 打开/关闭收件人列表。|r",
		["name added"] = "|cff00ff00%s|r 已被添加到邮件收件人列表。",
		["name removed"] = "|cff00ff00%s|r 已从邮件收件人列表中删除。",
		["empty prompt"] = "|cff00ff00你的收件人列表目前是空的，在左边的输入框中填入一个名字，然后点击这个按钮来添加。|r",
	};


local VERSION = GetAddOnMetadata("RecipientsDropDownButton", "Version") or "";
local L = RECIPIENTS_LOCALE;
local LIST_MAX = 49; -- maximum number of the list
local profile = {};

------------------------------------------------------------
-- Internal functions
------------------------------------------------------------
-- Prints a message
local function PrintMessage(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..L["title"]..":|r "..tostring(msg))
end

-- Obtain the name from SendMailNameEditBox
local function GetRecipientName()
	local name = string.trim(SendMailNameEditBox:GetText() or "");
	if name == "" then
		name = nil;
	end
	return name;
end

-- Put a name into SendMailNameEditBox
local function SetRecipientName(name, focus)
	if type(name) == "string" then
		SendMailNameEditBox:SetText(name);
		if focus then
			SendMailNameEditBox:SetFocus();
		else
			SendMailSubjectEditBox:HighlightText(0, -1);
			SendMailSubjectEditBox:SetFocus();
		end
	end
end

-- Finds a name from list, case insensitive
local function FindRecipientName(name)
	if type(name) == "string" then
		name = string.trim(string.lower(name));
		if name ~= "" then
			local i;
			for i = 1, table.getn(profile) do
				if string.lower(profile[i]) == name then
					return i;
				end
			end
		end
	end
	return nil;
end

-- Populates our drop down list
local function RecipientNameDropdownInit()
	local name = GetRecipientName();

	if name then	
		-- Operations
		local info = {};
		local id = FindRecipientName(name);
		if id then
			-- Remove existing name
			info.text = L["remove"]..name;
			info.arg1 = id;
			info.func = function(self, id)
				local name = table.remove(profile, id);
				if name then
					SetRecipientName("", true);
					PrintMessage(string.format(L["name removed"], name));
				end
			end
		else
			-- Add new name
			info.text = L["add"]..name;
			info.arg1 = name;
			info.func = function(self, name)
				if table.getn(profile) < LIST_MAX then
					table.insert(profile, name);
					table.sort(profile);
					PrintMessage(string.format(L["name added"], name));
				else
					PrintMessage(L["full"]);
				end
			end
		end

		UIDropDownMenu_AddButton(info);

		if table.getn(profile) > 0 then
			-- A separator
			UIDropDownMenu_AddButton({ isTitle = 1, textHeight = 1 });
		end
	end	

	-- Populate rest of the menu items with player saved data
	local i;
	for i = 1, math.min(LIST_MAX, table.getn(profile)) do
		local name = profile[i];
		UIDropDownMenu_AddButton({ text = name, arg1 = name, checked = (name == GetRecipientName()), func = function(self, name) SetRecipientName(name) end });
	end	
end


------------------------------------------------------------
-- Our addon frame - A tiny button!
------------------------------------------------------------
CreateFrame("Button", "RecipientsDropDownButton", SendMailNameEditBox);
RecipientsDropDownButton:SetWidth(24);
RecipientsDropDownButton:SetHeight(24);
RecipientsDropDownButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", -6, 0);
RecipientsDropDownButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
RecipientsDropDownButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
RecipientsDropDownButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");

RecipientsDropDownButton:SetScript("OnShow", function(self)
	if not self._menu then -- The menu won't be created until you open SendmailFrame, for resource saving...
		self._menu = CreateFrame("Button", "Recipients_3FEF5056_BCA4_4B80_8D93_8FD3A0B70913", self, "UIDropDownMenuTemplate");
		self._menu:Hide();
		self._menu.point = "TOPLEFT";
		self._menu.relativeTo = SendMailNameEditBox;
		self._menu.relativePoint = "BOTTOMLEFT";
		self._menu.xOffset = -12;
		self._menu.yOffset = 0;
		UIDropDownMenu_Initialize(self._menu, RecipientNameDropdownInit, "MENU");
	end
end);

RecipientsDropDownButton:SetScript("OnHide", function(self)
	CloseDropDownMenus();
end);

RecipientsDropDownButton:SetScript("OnClick", function(self)
	ToggleDropDownMenu(nil, nil, self._menu);
	PlaySound("igMainMenuOptionCheckBoxOn");
end);

RecipientsDropDownButton:SetScript("OnEnter", function(self)
	-- Shows game tooltip when mouse hovers over our button
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:ClearLines();
	GameTooltip:SetText(L["title"]);
	local count = table.getn(profile);
	GameTooltip:AddLine(string.format(L["count"], count));
	if count > 0 or GetRecipientName() then
		GameTooltip:AddLine(L["click open"]);
	else
		GameTooltip:AddLine(L["empty prompt"]);
	end
	GameTooltip:Show();
end);

RecipientsDropDownButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide();
end);

-- User data manipulation
RecipientsDropDownButton:RegisterEvent("VARIABLES_LOADED");
RecipientsDropDownButton:SetScript("OnEvent", function(self, event)
	if type(RecipientsDB) ~= "table" then
		RecipientsDB = {};
	end
	
	local key = (GetRealmName() or "SF").."-"..(UnitFactionGroup("player") or "Default");
	if type(RecipientsDB[key]) ~= "table" then
		RecipientsDB[key] = {};
	end

	profile = RecipientsDB[key];
end);


------------------------------------------------------------
-- Change WOW's stupid behavior
------------------------------------------------------------
hooksecurefunc("SendMailMailButton_OnClick", function()
	RecipientsDropDownButton._recentName = GetRecipientName(); -- Save the name before it gets cleared
end);

hooksecurefunc("SendMailFrame_Reset", function()
	SetRecipientName(RecipientsDropDownButton._recentName); -- Put the name back into SendMailNameEditBox
	RecipientsDropDownButton._recentName = nil;
end);