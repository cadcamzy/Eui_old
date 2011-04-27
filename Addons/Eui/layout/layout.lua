--定义整个界面的背景板
local E, C = unpack(select(2, ...))
--透明背景
local alpha
if C["main"].alpha == true then
	alpha = 0.1
else
	alpha = 0.7
end

--Minimap
local mini = CreateFrame("Frame", "EuiMinimap", Minimap)
E.EuiCreatePanel(mini, E.Scale(144+4), E.Scale(144+4), "CENTER", Minimap, "CENTER", 0, 0)
mini:ClearAllPoints()
mini:SetPoint("TOPLEFT", E.Scale(-2), E.Scale(2))
mini:SetPoint("BOTTOMRIGHT", E.Scale(2), E.Scale(-2))
E.EuiCreateShadow(EuiMinimap)

if C["info"].apsp ~= 0 then
	local leftstat = CreateFrame("Frame", "EuiLeftStatBackground", UIParent)
	E.EuiCreatePanel(leftstat, E.Scale(1), E.Scale(1), "TOPLEFT", EuiMinimap, "BOTTOMLEFT", 0, - E.Scale(4))
	E.EuiSetTemplate(leftstat,alpha)
	E.EuiCreateShadow(leftstat)
	leftstat:SetHeight(18)
	if C["info"].dps == 0 then
		leftstat:SetWidth(EuiMinimap:GetWidth())
	else
		leftstat:SetWidth(EuiMinimap:GetWidth() / 2 - E.Scale(4))
	end
	function E.InfoapspPostion(frame)
		if E.Movers["Infoapsp"]["moved"] ~= true then
			Infoapsp:ClearAllPoints()
			Infoapsp:SetPoint("TOPLEFT", EuiMinimap, "BOTTOMLEFT", 0, - E.Scale(4))
		end	
	end
	E.CreateMover(EuiLeftStatBackground, "Infoapsp", "AP/SP", false, E.InfoapspPostion)	
	
end
if C["info"].dps ~= 0 then
	local rightstat = CreateFrame("Frame", "EuiRightStatBackground", UIParent)
	E.EuiCreatePanel(rightstat, E.Scale(1), E.Scale(1), "TOPRIGHT", EuiMinimap, "BOTTOMRIGHT", 0, - E.Scale(4))
	E.EuiSetTemplate(rightstat,alpha)
	E.EuiCreateShadow(rightstat)
	rightstat:SetHeight(18)
	if C["info"].apsp == 0 then
		rightstat:SetWidth(EuiMinimap:GetWidth())
	else
		rightstat:SetWidth(EuiMinimap:GetWidth() / 2 - E.Scale(4))
	end
	function E.InfodpsPostion(frame)
		if E.Movers["Infodps"]["moved"] ~= true then
			Infodps:ClearAllPoints()
			Infodps:SetPoint("TOPRIGHT", EuiMinimap, "BOTTOMRIGHT", 0, - E.Scale(4))
		end	
	end
	E.CreateMover(EuiRightStatBackground, "Infodps", "DPS/HPS", false, E.InfodpsPostion)
end

--chatlayout
if C["chat"].enable == true then
	local bottomchatbg = CreateFrame("Frame", "EuiBottomBackground", UIParent)
	E.EuiCreatePanel(bottomchatbg, C["chat"].chatw - 60, 18, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 6, 4)
	E.EuiSetTemplate(bottomchatbg, alpha)
	E.EuiCreateShadow(bottomchatbg)

	local leftchatbg = CreateFrame("Frame", "EuiLeftChatBackground", EuiBottomBackground)
	E.EuiCreatePanel(leftchatbg, C["chat"].chatw, C["chat"].chath, "BOTTOMLEFT", EuiBottomBackground, "TOPLEFT", 0, 2)
	E.EuiSetTemplate(leftchatbg,alpha)
	E.EuiCreateShadow(leftchatbg)
	
	local topchatbg = CreateFrame("Frame", "EuiTopChatBackground", EuiBottomBackground)
	E.EuiCreatePanel(topchatbg, C["chat"].chatw, 22, "BOTTOMLEFT", EuiLeftChatBackground, "TOPLEFT", 0, 2)
	E.EuiSetTemplate(topchatbg, alpha)
	E.EuiCreateShadow(topchatbg)
	
	local infoleftRbutton = CreateFrame("Button", "EuiInfoLeftRButton", EuiInfoLeft)
	E.EuiSetTemplate(infoleftRbutton)
	infoleftRbutton:SetPoint("BOTTOMLEFT", EuiBottomBackground, "BOTTOMRIGHT", 2, 0)
	infoleftRbutton:SetPoint("TOPRIGHT", EuiLeftChatBackground, "BOTTOMRIGHT", 0, -2)
	infoleftRbutton.text = E.EuiSetFontn(infoleftRbutton)
	infoleftRbutton.text:SetText("UnLock")
	infoleftRbutton.text:SetPoint("CENTER")
end

--actionbar layout

-- BUTTON SIZES
E.buttonsize = E.Scale(C["actionbar"].buttonsize)
E.buttonspacing = E.Scale(C["actionbar"].buttonspacing)
E.petbuttonsize = E.Scale(C["actionbar"].petbuttonsize)

-- MAIN ACTION BAR
local barbg = CreateFrame("Frame", "EuiActionBarBackground", UIParent)
if C["actionbar"].bottompetbar ~= true then
	E.EuiCreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
else
	E.EuiCreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, (E.buttonsize + (E.buttonspacing * 2)) + E.Scale(8))
end
barbg:SetWidth(((E.buttonsize * 12) + (E.buttonspacing * 13)))
barbg:SetFrameStrata("LOW")
barbg:SetHeight(E.buttonsize + (E.buttonspacing * 2))
E.EuiSetTemplate(barbg,alpha)
E.EuiCreateShadow(barbg)

if C["actionbar"].enable ~= true then
	barbg:SetAlpha(0)
end

--SPLIT BAR PANELS
local splitleft = CreateFrame("Frame", "EuiSplitActionBarLeftBackground", EuiActionBarBackground)
E.EuiCreatePanel(splitleft, (E.buttonsize * 3) + (E.buttonspacing * 4), EuiActionBarBackground:GetHeight(), "RIGHT", EuiActionBarBackground, "LEFT", E.Scale(-4), 0)
splitleft:SetFrameLevel(EuiActionBarBackground:GetFrameLevel())
splitleft:SetFrameStrata(EuiActionBarBackground:GetFrameStrata())

local splitright = CreateFrame("Frame", "EuiSplitActionBarRightBackground", EuiActionBarBackground)
E.EuiCreatePanel(splitright, (E.buttonsize * 3) + (E.buttonspacing * 4), EuiActionBarBackground:GetHeight(), "LEFT", EuiActionBarBackground, "RIGHT", E.Scale(4), 0)
splitright:SetFrameLevel(EuiActionBarBackground:GetFrameLevel())
splitright:SetFrameStrata(EuiActionBarBackground:GetFrameStrata())
E.EuiSetTemplate(splitleft, alpha)
E.EuiSetTemplate(splitright, alpha)
E.EuiCreateShadow(splitleft)
E.EuiCreateShadow(splitright)

-- RIGHT BAR
if C["actionbar"].enable == true then
	local barbgr = CreateFrame("Frame", "EuiActionBarBackgroundRight", EuiActionBarBackground)
	E.EuiCreatePanel(barbgr, 1, (E.buttonsize * 12) + (E.buttonspacing * 13), "RIGHT", UIParent, "RIGHT", E.Scale(-4), E.Scale(-8))
	barbgr:Hide()
	E.AnimGroup(EuiActionBarBackgroundRight, E.Scale(350), 0, 0.4)

	local petbg = CreateFrame("Frame", "EuiPetActionBarBackground", UIParent)
	if C["actionbar"].bottompetbar ~= true then
		E.EuiCreatePanel(petbg, E.petbuttonsize + (E.buttonspacing * 2), (E.petbuttonsize * 10) + (E.buttonspacing * 11), "RIGHT", UIParent, "RIGHT", E.Scale(-6), E.Scale(-13.5))
	else
		E.EuiCreatePanel(petbg, (E.petbuttonsize * 10) + (E.buttonspacing * 11), E.petbuttonsize + (E.buttonspacing * 2), "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
	end
	
	local ltpetbg = CreateFrame("Frame", "EuiLineToPetActionBarBackground", petbg)
	if C["actionbar"].bottompetbar ~= true then
		E.EuiCreatePanel(ltpetbg, 30, 265, "LEFT", petbg, "RIGHT", 0, 0)
	else
		E.EuiCreatePanel(ltpetbg, 265, 30, "BOTTOM", petbg, "TOP", 0, 0)
	end
	
	ltpetbg:SetScript("OnShow", function(self)
		self:SetFrameStrata("BACKGROUND")
		self:SetFrameLevel(0)
	end)
	E.EuiSetTemplate(barbgr, alpha)
	E.EuiSetTemplate(petbg, alpha)
	E.EuiCreateShadow(barbgr)
	E.EuiCreateShadow(petbg)
end

-- VEHICLE BAR
if C["actionbar"].enable == true then
	local vbarbg = CreateFrame("Frame", "EuiVehicleBarBackground", UIParent)
	E.EuiCreatePanel(vbarbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
	vbarbg:SetWidth(((E.buttonsize * 11) + (E.buttonspacing * 12))*1.2)
	vbarbg:SetHeight((E.buttonsize + (E.buttonspacing * 2))*1.2)
	E.EuiSetTemplate(vbarbg, alpha)
	E.EuiCreateShadow(vbarbg)
end