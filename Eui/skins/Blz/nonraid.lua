local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local StripAllTextures = {
		"RaidInfoFrame",
		"RaidInfoInstanceLabel",
		"RaidInfoIDLabel",
	}

	local KillTextures = {
		"RaidInfoScrollFrameScrollBarBG",
		"RaidInfoScrollFrameScrollBarTop",
		"RaidInfoScrollFrameScrollBarBottom",
		"RaidInfoScrollFrameScrollBarMiddle",
	}
	local buttons = {
		"RaidFrameConvertToRaidButton",
		"RaidFrameRaidInfoButton",
		"RaidFrameNotInRaidRaidBrowserButton",
		"RaidInfoExtendButton",
		"RaidInfoCancelButton",
	}

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	for i = 1, #buttons do
		E.SkinButton(_G[buttons[i]])
	end
	E.StripTextures(RaidInfoScrollFrame)
	E.EuiCreateBackdrop(RaidInfoFrame,.7)
	RaidInfoFrame.backdrop:SetPoint( "TOPLEFT", RaidInfoFrame, "TOPLEFT")
	RaidInfoFrame.backdrop:SetPoint( "BOTTOMRIGHT", RaidInfoFrame, "BOTTOMRIGHT")
	E.SkinCloseButton(RaidInfoCloseButton,RaidInfoFrame)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)