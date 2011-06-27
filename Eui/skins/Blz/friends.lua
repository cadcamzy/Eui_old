local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

--Social Frame
local function SkinSocialHeaderTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		tex:SetTexture(nil)
	end
	tab:GetHighlightTexture():SetTexture(nil)
	tab.backdrop = CreateFrame("Frame", nil, tab)
	E.EuiSetTemplate(tab.backdrop)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:SetPoint("TOPLEFT", 3, -8)
	tab.backdrop:SetPoint("BOTTOMRIGHT", -6, 0)
end

local function LoadSkin()
	local StripAllTextures = {
		"FriendsListFrame",
		"FriendsTabHeader",
		"FriendsFrameFriendsScrollFrame",
		"WhoFrameColumnHeader1",
		"WhoFrameColumnHeader2",
		"WhoFrameColumnHeader3",
		"WhoFrameColumnHeader4",
		"ChannelListScrollFrame",
		"ChannelRoster",
		"FriendsFramePendingButton1",
		"FriendsFramePendingButton2",
		"FriendsFramePendingButton3",
		"FriendsFramePendingButton4",
		"ChannelFrameDaughterFrame",
		"AddFriendFrame",
		"AddFriendNoteFrame",
	}			

	local KillTextures = {
		"FriendsFrameTopLeft",
		"FriendsFrameTopRight",
		"FriendsFrameBottomLeft",
		"FriendsFrameBottomRight",
		"ChannelFrameVerticalBar",
		"FriendsFrameBroadcastInputLeft",
		"FriendsFrameBroadcastInputRight",
		"FriendsFrameBroadcastInputMiddle",
		"ChannelFrameDaughterFrameChannelNameLeft",
		"ChannelFrameDaughterFrameChannelNameRight",
		"ChannelFrameDaughterFrameChannelNameMiddle",
		"ChannelFrameDaughterFrameChannelPasswordLeft",
		"ChannelFrameDaughterFrameChannelPasswordRight",				
		"ChannelFrameDaughterFrameChannelPasswordMiddle",			
	}

	local buttons = {
		"FriendsFrameAddFriendButton",
		"FriendsFrameSendMessageButton",
		"WhoFrameWhoButton",
		"WhoFrameAddFriendButton",
		"WhoFrameGroupInviteButton",
		"ChannelFrameNewButton",
		"FriendsFrameIgnorePlayerButton",
		"FriendsFrameUnsquelchButton",
		"FriendsFramePendingButton1AcceptButton",
		"FriendsFramePendingButton1DeclineButton",
		"FriendsFramePendingButton2AcceptButton",
		"FriendsFramePendingButton2DeclineButton",
		"FriendsFramePendingButton3AcceptButton",
		"FriendsFramePendingButton3DeclineButton",
		"FriendsFramePendingButton4AcceptButton",
		"FriendsFramePendingButton4DeclineButton",
		"ChannelFrameDaughterFrameOkayButton",
		"ChannelFrameDaughterFrameCancelButton",
		"AddFriendEntryFrameAcceptButton",
		"AddFriendEntryFrameCancelButton",
		"AddFriendInfoFrameContinueButton",
	}			

	for _, button in pairs(buttons) do
		E.SkinButton(_G[button])
	end
	--Reposition buttons
	WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -2, 0)
	WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -2, 0)
	WhoFrameGroupInviteButton:SetPoint("BOTTOMRIGHT", WhoFrame, "BOTTOMRIGHT", -44, 82)
	--Resize Buttons
	WhoFrameWhoButton:SetSize(WhoFrameWhoButton:GetWidth() - 4, WhoFrameWhoButton:GetHeight())
	WhoFrameAddFriendButton:SetSize(WhoFrameAddFriendButton:GetWidth() - 4, WhoFrameAddFriendButton:GetHeight())
	WhoFrameGroupInviteButton:SetSize(WhoFrameGroupInviteButton:GetWidth() - 4, WhoFrameGroupInviteButton:GetHeight())
	E.SkinEditBox(WhoFrameEditBox)
	WhoFrameEditBox:SetHeight(WhoFrameEditBox:GetHeight() - 15)
	WhoFrameEditBox:SetPoint("BOTTOM", WhoFrame, "BOTTOM", -10, 108)
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() + 17)
	
	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end
	E.StripTextures(FriendsFrame,true)

	E.SkinEditBox(AddFriendNameEditBox)
	E.EuiSetTemplate(AddFriendFrame,.7)
	
	--Who Frame
	local function UpdateWhoSkins()
		E.StripTextures(WhoListScrollFrame)
	end
	--Channel Frame
	local function UpdateChannel()
		E.StripTextures(ChannelRosterScrollFrame)
	end
	--BNet Frame
	E.EuiCreateBackdrop(FriendsFrameBroadcastInput)
	E.EuiCreateBackdrop(ChannelFrameDaughterFrameChannelName)
	E.EuiCreateBackdrop(ChannelFrameDaughterFrameChannelPassword)

	ChannelFrame:HookScript("OnShow", UpdateChannel)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateChannel)

	WhoFrame:HookScript("OnShow", UpdateWhoSkins)
	hooksecurefunc("FriendsFrame_OnEvent", UpdateWhoSkins)

	E.EuiCreateBackdrop(ChannelFrameDaughterFrame,.7)
	E.EuiCreateBackdrop(FriendsFrame,.7)
	FriendsFrame.backdrop:SetPoint( "TOPLEFT", FriendsFrame, "TOPLEFT", 11,-12)
	FriendsFrame.backdrop:SetPoint( "BOTTOMRIGHT", FriendsFrame, "BOTTOMRIGHT", -35, 76)
	E.SkinCloseButton(ChannelFrameDaughterFrameDetailCloseButton,ChannelFrameDaughterFrame)
	E.SkinCloseButton(FriendsFrameCloseButton,FriendsFrame.backdrop)
	E.SkinDropDownBox(WhoFrameDropDown,150)
	E.SkinDropDownBox(FriendsFrameStatusDropDown,70)

	--Bottom Tabs
	for i=1, 4 do
		E.SkinTab(_G["FriendsFrameTab"..i])
	end

	for i=1, 3 do
		SkinSocialHeaderTab(_G["FriendsTabHeaderTab"..i])
	end

	local function Channel()
		for i=1, MAX_DISPLAY_CHANNEL_BUTTONS do
			local button = _G["ChannelButton"..i]
			if button then
				E.StripTextures(button)
				button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
				
				_G["ChannelButton"..i.."Text"]:SetFont(E.font, 12)
			end
		end
	end
	hooksecurefunc("ChannelList_Update", Channel)
	
	--View Friends BN Frame
	E.EuiCreateBackdrop(FriendsFriendsFrame,.7)

	local StripAllTextures = {
		"FriendsFriendsFrame",
		"FriendsFriendsList",
		"FriendsFriendsNoteFrame",
	}

	local buttons = {
		"FriendsFriendsSendRequestButton",
		"FriendsFriendsCloseButton",
	}

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	for _, button in pairs(buttons) do
		E.SkinButton(_G[button])
	end

	E.SkinEditBox(FriendsFriendsList)
	E.SkinEditBox(FriendsFriendsNoteFrame)
	E.SkinDropDownBox(FriendsFriendsFrameDropDown,150)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)