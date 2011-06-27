local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local buttons = {
		"PVPFrameLeftButton",
		"PVPFrameRightButton",
		"PVPColorPickerButton1",
		"PVPColorPickerButton2",
		"PVPColorPickerButton3",
		"PVPBannerFrameAcceptButton",
	}
	
--	if not E.IsPTRVersion() then
		tinsert(buttons, "PVPHonorFrameWarGameButton")
--	end
	
	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end

	local KillTextures = {
		"PVPHonorFrameBGTex",
		"PVPHonorFrameInfoScrollFrameScrollBar",
		"PVPConquestFrameInfoButtonInfoBG",
		"PVPConquestFrameInfoButtonInfoBGOff",
		"PVPTeamManagementFrameFlag2GlowBG",
		"PVPTeamManagementFrameFlag3GlowBG",
		"PVPTeamManagementFrameFlag5GlowBG",
		"PVPTeamManagementFrameFlag2HeaderSelected",
		"PVPTeamManagementFrameFlag3HeaderSelected",
		"PVPTeamManagementFrameFlag5HeaderSelected",
		"PVPTeamManagementFrameFlag2Header",
		"PVPTeamManagementFrameFlag3Header",
		"PVPTeamManagementFrameFlag5Header",
		"PVPTeamManagementFrameWeeklyDisplayLeft",
		"PVPTeamManagementFrameWeeklyDisplayRight",
		"PVPTeamManagementFrameWeeklyDisplayMiddle",
		"PVPBannerFramePortrait",
		"PVPBannerFramePortraitFrame",
		"PVPBannerFrameInset",
		"PVPBannerFrameEditBoxLeft",
		"PVPBannerFrameEditBoxRight",
		"PVPBannerFrameEditBoxMiddle",
		"PVPBannerFrameCancelButton_LeftSeparator",
	}

	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	local StripAllTextures = {
		"PVPFrame",
		"PVPFrameInset",
		"PVPHonorFrame",
		"PVPConquestFrame",
		"PVPTeamManagementFrame",
		"PVPHonorFrameTypeScrollFrame",
		"PVPFrameTopInset",
		"PVPTeamManagementFrameInvalidTeamFrame",
		"PVPBannerFrame",
		"PVPBannerFrameCustomization1",
		"PVPBannerFrameCustomization2",
		"PVPBannerFrameCustomizationFrame",
	}

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	local function ArenaHeader(self, first, i)
		local button = _G["PVPTeamManagementFrameHeader"..i]

		if first then
			E.StripTextures(button)
		end
	end

	for i=1, 4 do
		ArenaHeader(nil, true, i)
	end	

	E.EuiCreateBackdrop(PVPBannerFrameEditBox)
	PVPBannerFrameEditBox.backdrop:SetPoint( "TOPLEFT", PVPBannerFrameEditBox, "TOPLEFT" ,-5,-5)
	PVPBannerFrameEditBox.backdrop:SetPoint( "BOTTOMRIGHT", PVPBannerFrameEditBox, "BOTTOMRIGHT",5,5)
	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(1,1,1)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(1,1,1)
	E.EuiCreateBackdrop(PVPTeamManagementFrameInvalidTeamFrame)
	PVPTeamManagementFrameInvalidTeamFrame:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel()+1)
	PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetPoint( "TOPLEFT", PVPTeamManagementFrameInvalidTeamFrame, "TOPLEFT")
	PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetPoint( "BOTTOMRIGHT", PVPTeamManagementFrameInvalidTeamFrame, "BOTTOMRIGHT")
	PVPTeamManagementFrameInvalidTeamFrame.backdrop:SetFrameLevel(PVPTeamManagementFrameInvalidTeamFrame:GetFrameLevel())

--	if not E.IsPTRVersion() then
		E.StripTextures(PVPFrameConquestBar)
		PVPFrameConquestBar:SetStatusBarTexture(E.normTex)
		E.EuiCreateBackdrop(PVPFrameConquestBar)
--	else
--		E.Kill(PVPFrameConquestBarLeft)
--		E.Kill(PVPFrameConquestBarRight)
--		E.Kill(PVPFrameConquestBarMiddle)
--		E.Kill(PVPFrameConquestBarBG)
--		E.Kill(PVPFrameConquestBarShadow)
--		PVPFrameConquestBar.progress:SetTexture(E.normTex)
--		E.EuiCreateBackdrop(PVPFrameConquestBar)
--		PVPFrameConquestBar.backdrop:SetPoint("TOPLEFT", PVPFrameConquestBar.progress, "TOPLEFT", -2, 2)
--		PVPFrameConquestBar.backdrop:SetPoint("BOTTOMRIGHT", PVPFrameConquestBar, "BOTTOMRIGHT", -2, 2)			
--	end
	
	E.EuiCreateBackdrop(PVPBannerFrame,.7)
	PVPBannerFrame.backdrop:SetPoint( "TOPLEFT", PVPBannerFrame, "TOPLEFT")
	PVPBannerFrame.backdrop:SetPoint( "BOTTOMRIGHT", PVPBannerFrame, "BOTTOMRIGHT")
	E.EuiCreateBackdrop(PVPBannerFrameCustomization1)
	PVPBannerFrameCustomization1.backdrop:SetPoint( "TOPLEFT", PVPBannerFrameCustomization1LeftButton, "TOPRIGHT" ,2,0)
	PVPBannerFrameCustomization1.backdrop:SetPoint( "BOTTOMRIGHT", PVPBannerFrameCustomization1RightButton, "BOTTOMLEFT",-2,0)
	E.EuiCreateBackdrop(PVPBannerFrameCustomization2)
	PVPBannerFrameCustomization2.backdrop:SetPoint( "TOPLEFT", PVPBannerFrameCustomization2LeftButton, "TOPRIGHT",2,0)
	PVPBannerFrameCustomization2.backdrop:SetPoint( "BOTTOMRIGHT", PVPBannerFrameCustomization2RightButton, "BOTTOMLEFT",-2,0)
	E.SkinCloseButton(PVPBannerFrameCloseButton,PVPBannerFrame)
	E.SkinNextPrevButton(PVPBannerFrameCustomization1LeftButton)
	PVPBannerFrameCustomization1LeftButton:SetHeight(PVPBannerFrameCustomization1:GetHeight())
	E.SkinNextPrevButton(PVPBannerFrameCustomization1RightButton)
	PVPBannerFrameCustomization1RightButton:SetHeight(PVPBannerFrameCustomization1:GetHeight())
	E.SkinNextPrevButton(PVPBannerFrameCustomization2LeftButton)
	PVPBannerFrameCustomization2LeftButton:SetHeight(PVPBannerFrameCustomization1:GetHeight())
	E.SkinNextPrevButton(PVPBannerFrameCustomization2RightButton)
	PVPBannerFrameCustomization2RightButton:SetHeight(PVPBannerFrameCustomization1:GetHeight())
	E.EuiCreateBackdrop(PVPFrame,.7)
	PVPFrame.backdrop:SetPoint( "TOPLEFT", PVPFrame, "TOPLEFT")
	PVPFrame.backdrop:SetPoint( "BOTTOMRIGHT", PVPFrame, "BOTTOMRIGHT")
	E.SkinCloseButton(PVPFrameCloseButton,PVPFrame)
	E.SkinNextPrevButton(PVPTeamManagementFrameWeeklyToggleLeft)
	E.SkinNextPrevButton(PVPTeamManagementFrameWeeklyToggleRight)
	PVPColorPickerButton1:SetHeight(PVPColorPickerButton1:GetHeight()-5)
	PVPColorPickerButton2:SetHeight(PVPColorPickerButton1:GetHeight())
	PVPColorPickerButton3:SetHeight(PVPColorPickerButton1:GetHeight())
	
	--War Games
--	if E.IsPTRVersion() then
--		E.SkinButton(WarGameStartButton, true)
--		E.StripTextures(WarGamesFrame)
--		E.SkinScrollBar(WarGamesFrameScrollFrameScrollBar)
		
--		WarGameStartButton:ClearAllPoints()
--		WarGameStartButton:SetPoint("LEFT", PVPFrameLeftButton, "RIGHT", 2, 0)
--		WarGamesFrameDescription:SetTextColor(1, 1, 1)
--	end
	
	--Freaking gay Cancel Button FFSlocal
	local f = PVPBannerFrameCancelButton
	local l = _G[f:GetName().."Left"]
	local m = _G[f:GetName().."Middle"]
	local r = _G[f:GetName().."Right"]
	if l then l:SetAlpha(0) end
	if m then m:SetAlpha(0) end
	if r then r:SetAlpha(0) end
	E.EuiCreateBackdrop(f)
	f:SetFrameLevel(PVPBannerFrameAcceptButton:GetFrameLevel()+1)
	f.backdrop:SetPoint( "TOPLEFT", PVPBannerFrameAcceptButton, "TOPLEFT", PVPBannerFrame:GetWidth()-PVPBannerFrameAcceptButton:GetWidth()-10,0)
	f.backdrop:SetPoint( "BOTTOMRIGHT", PVPBannerFrameAcceptButton, "BOTTOMRIGHT", PVPBannerFrame:GetWidth()-PVPBannerFrameAcceptButton:GetWidth()-10, 0)
	f.backdrop:SetFrameLevel(f:GetFrameLevel()-1)
	
	--Bottom Tabs
--	if not E.IsPTRVersion() then
		for i=1,3 do
			E.SkinTab(_G["PVPFrameTab"..i])
		end
--	else
--		for i=1,4 do
--			E.SkinTab(_G["PVPFrameTab"..i])
--		end			
--	end
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)