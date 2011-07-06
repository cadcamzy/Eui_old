--定义整个界面的背景板
Local E, C, L = unpack(EUI)
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
mini:SetFrameStrata("LOW")
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

--顶部信息条
local topinfobg = CreateFrame("Frame", "EuiTopInfobg", UIParent)
E.EuiCreatePanel(topinfobg, 700, 18, "TOP", UIParent, "TOP", 0, 0)
E.EuiSetTemplate(topinfobg)
local i = 9
if C["info"].wowtime == 0 then i = i - 1 end
if C["info"].latency == 0 then i = i - 1 end
if C["info"].bag == 0 then i = i - 1 end
if C["info"].durability == 0 then i = i - 1 end
if C["info"].memory == 0 then i = i - 1 end
if C["info"].xp == 0 then i = i - 1 end
if C["info"].setting == 0 then i = i - 1 end
if C["info"].guild == 0 then i = i - 1 end
if C["info"].friend == 0 then i = i - 1 end
if i == 0 then topinfobg:SetWidth(1) else topinfobg:SetWidth(74 * i + 4) end

local function infolr(a1,a2,lr)
	if lr == true then
		if a1.r == false then
			a1.text:SetTextColor(1,0,0)
		else
			a1.text:SetTextColor(23/255,132/255,209/255)
		end
		a1.r = not a1.r
	else
		if a2.r == false then
			a2.text:SetTextColor(1,0,0)
		else
			a2.text:SetTextColor(23/255,132/255,209/255)
		end
		a2.r = not a2.r
	end
	
	if a1.r == true and a2.r == true then
		EuiTopInfobg:Hide()
		a1:ClearAllPoints()
		EuiTopInfobg:ClearAllPoints()
		a2:ClearAllPoints()
		a1:SetPoint("TOPRIGHT", UIParent, "TOP", -2, 0)
		a2:SetPoint("TOPLEFT", UIParent, "TOP", 2, 0)			
	elseif a1.r == false and a2.r == false then
		EuiTopInfobg:Show()
		a1:ClearAllPoints()
		EuiTopInfobg:ClearAllPoints()
		a2:ClearAllPoints()
		a1.left = false
		a2.right = false
		EuiTopInfobg:SetPoint("TOP", UIParent, "TOP", 0, 0)
		a1:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
		a2:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)			
	end
	if lr == true then
		return a1
	else
		return a2
	end
end

--顶部信息条按钮L
local topinfol = CreateFrame("Button", "EuiInfoButtonL", UIParent)
topinfol:SetWidth(18)
topinfol:SetHeight(18)
topinfol:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
topinfol.left = false
topinfol.r = false
E.EuiSetTemplate(topinfol, 1)
E.StyleButton(topinfol)
topinfol.text = E.EuiSetFontn(topinfol, E.font, 14)
topinfol.text:SetTextColor(23/255,132/255,209/255)
topinfol.text:SetText("<")
topinfol.text:SetPoint("CENTER")
topinfol:SetScript("OnMouseDown", function(self, btn)
	if btn == "LeftButton" and topinfol.r == false then
		if topinfol.left == false and EuiInfoButtonR.right == false then
		--信息条在屏幕中间,点击后往左移.
			EuiInfoButtonL:ClearAllPoints()
			EuiTopInfobg:ClearAllPoints()
			EuiInfoButtonR:ClearAllPoints()
			EuiInfoButtonL:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 2, 0)
			EuiTopInfobg:SetPoint("TOPLEFT", EuiInfoButtonL, "TOPRIGHT", 2, 0)
			EuiInfoButtonR:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)
			EuiInfoButtonL.left = true
			EuiInfobar["EuiTopInfobg"].left = true
		elseif topinfol.left == false and EuiInfoButtonR.right == true then
			--信息条靠左,点击后移回中间.
			EuiInfoButtonL:ClearAllPoints()
			EuiTopInfobg:ClearAllPoints()
			EuiInfoButtonR:ClearAllPoints()
			EuiTopInfobg:SetPoint("TOP", UIParent, "TOP", 0, 0)
			EuiInfoButtonL:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
			EuiInfoButtonR:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)
			EuiInfoButtonR.right = false
			EuiInfobar["EuiTopInfobg"].right = false
		end
	elseif btn == "RightButton" then
		EuiInfoButtonL = infolr(EuiInfoButtonL, EuiInfoButtonR, true)
	end	
end)

--顶部信息条按钮R
local topinfor = CreateFrame("Button", "EuiInfoButtonR", UIParent)
topinfor:SetWidth(18)
topinfor:SetHeight(18)
topinfor:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)
topinfor.right = false
topinfor.r = false
E.EuiSetTemplate(topinfor, 1)
E.StyleButton(topinfor)
topinfor.text = E.EuiSetFontn(topinfor, E.font, 14)
topinfor.text:SetTextColor(23/255,132/255,209/255)
topinfor.text:SetText(">")
topinfor.text:SetPoint("CENTER")
topinfor:SetScript("OnMouseDown", function(self, btn)
	if btn == "LeftButton" and topinfor.r == false then
		if topinfor.right == false and topinfol.left == false then
			--信息条在屏幕中间,点击后往右移
			EuiTopInfobg:ClearAllPoints()
			EuiInfoButtonR:ClearAllPoints()
			EuiInfoButtonL:ClearAllPoints()
			EuiInfoButtonR:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -2, 0)
			EuiTopInfobg:SetPoint("TOPRIGHT", EuiInfoButtonR, "TOPLEFT", -2, 0)
			EuiInfoButtonL:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
			EuiInfoButtonR.right = true
			EuiInfobar["EuiTopInfobg"].right = true
		elseif topinfol.left == true and EuiInfoButtonR.right == false then
			--信息条靠右,点击后移回中间.
			EuiTopInfobg:ClearAllPoints()
			EuiInfoButtonR:ClearAllPoints()
			EuiInfoButtonL:ClearAllPoints()
			EuiTopInfobg:SetPoint("TOP", UIParent, "TOP", 0, 0)
			EuiInfoButtonR:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)
			EuiInfoButtonL:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
			EuiInfoButtonL.left = false
			EuiInfobar["EuiTopInfobg"].left = false
		end
	elseif btn == "RightButton" then
		EuiInfoButtonR = infolr(EuiInfoButtonL, EuiInfoButtonR, false)
	end	
end)

--底部信息条左按钮
local bottominfobgL = CreateFrame("Frame", "EuiBottomInfoButtonL", UIParent)
bottominfobgL:SetWidth(10)
bottominfobgL:SetHeight(16)
bottominfobgL:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 2, 4)
E.EuiSetTemplate(bottominfobgL)

--底部信息条
local bottominfobg = CreateFrame("Frame", "EuiBottomInfobg", UIParent)
--bottominfobg:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 2, 4)
--bottominfobg:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", C["chat"].chatw+2, 20)
bottominfobg:SetPoint("BOTTOMLEFT", EuiBottomInfoButtonL, "BOTTOMRIGHT", 2, 0)
bottominfobg:SetPoint("TOPRIGHT", EuiBottomInfoButtonL, "BOTTOMRIGHT", C["chat"].chatw+2-24, 16)
bottominfobg:RegisterEvent('ADDON_LOADED')
bottominfobg:SetScript('OnEvent', function(self, event, addon)
	if EuiInfobar == nil then EuiInfobar = {} end
	if EuiInfobar["EuiTopInfobg"] == nil then
		EuiInfobar["EuiTopInfobg"] = {}
		EuiInfobar["EuiTopInfobg"].left = false
		EuiInfobar["EuiTopInfobg"].right = false
	end
	if EuiInfobar["EuiTopInfobg"].left == true and EuiInfobar["EuiTopInfobg"].right == true then
		EuiInfobar["EuiTopInfobg"].left = false
		EuiInfobar["EuiTopInfobg"].right = false
	end
	if EuiInfobar["EuiTopInfobg"].left == true and EuiInfobar["EuiTopInfobg"].right ~= true then
		EuiInfoButtonL:ClearAllPoints()
		EuiTopInfobg:ClearAllPoints()
		EuiInfoButtonR:ClearAllPoints()
		EuiInfoButtonL:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 2, 0)
		EuiTopInfobg:SetPoint("TOPLEFT", EuiInfoButtonL, "TOPRIGHT", 2, 0)
		EuiInfoButtonR:SetPoint("TOPLEFT", EuiTopInfobg, "TOPRIGHT", 2, 0)
		EuiInfoButtonL.left = true
		EuiInfoButtonR.right = false
	elseif EuiInfobar["EuiTopInfobg"].left ~= true and EuiInfobar["EuiTopInfobg"].right == true then
		EuiTopInfobg:ClearAllPoints()
		EuiInfoButtonR:ClearAllPoints()
		EuiInfoButtonL:ClearAllPoints()
		EuiInfoButtonR:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -2, 0)
		EuiTopInfobg:SetPoint("TOPRIGHT", EuiInfoButtonR, "TOPLEFT", -2, 0)
		EuiInfoButtonL:SetPoint("TOPRIGHT", EuiTopInfobg, "TOPLEFT", -2, 0)
		EuiInfoButtonR.right = true
		EuiInfoButtonL.left = false
	end
end)

bottominfobg:SetFrameStrata("BACKGROUND")
E.EuiSetTemplate(bottominfobg, alpha)
--E.EuiCreateShadow(bottominfobg)

local infoleftRbutton = CreateFrame("Button", "EuiInfoLeftRButton", EuiBottomInfobg)
infoleftRbutton:SetHighlightTexture(E.highlightTex)
infoleftRbutton:SetPoint("TOPRIGHT", EuiBottomInfobg, "TOPRIGHT", 0, -2)
infoleftRbutton:SetPoint("BOTTOMLEFT", EuiBottomInfobg, "BOTTOMLEFT", (C["chat"].chatw - 80), 2)
infoleftRbutton.text = E.EuiSetFontn(infoleftRbutton, E.font, 14)
infoleftRbutton.text:SetTextColor(23/255,132/255,209/255)
infoleftRbutton.text:SetText("UnLock")
infoleftRbutton.text:SetPoint("CENTER")

--底部信息条右按钮
local bottominfobgR = CreateFrame("Frame", "EuiBottomInfoButtonR", UIParent)
bottominfobgR:SetWidth(10)
bottominfobgR:SetHeight(16)
bottominfobgR:SetPoint("LEFT", "EuiBottomInfobg", "RIGHT", 2,0)
E.EuiSetTemplate(bottominfobgR)

--chatlayout
if C["chat"].enable == true then
	local leftchatbg = CreateFrame("Frame", "EuiLeftChatBackground", EuiBottomInfobg)
	E.EuiCreatePanel(leftchatbg, C["chat"].chatw, C["chat"].chath, "BOTTOMLEFT", EuiBottomInfobg, "TOPLEFT", -12, 4)
	E.EuiSetTemplate(leftchatbg,alpha)
	E.EuiCreateShadow(leftchatbg)
	
	local topchatbg = CreateFrame("Frame", "EuiTopChatBackground", EuiBottomInfobg)
	E.EuiCreatePanel(topchatbg, C["chat"].chatw, 22, "BOTTOMLEFT", EuiLeftChatBackground, "TOPLEFT", 0, 2)
	E.EuiSetTemplate(topchatbg, alpha)
	E.EuiCreateShadow(topchatbg)
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
function E.EuiActionBarBackgroundMove(frame)
	if E.Movers[frame:GetName()]["moved"] ~= true then
		frame:ClearAllPoints()
		if C["actionbar"].bottompetbar ~= true then
			frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
		else
			frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, (E.buttonsize + (E.buttonspacing * 2)) + E.Scale(8))
		end
	end
end
E.CreateMover(barbg, "EuiActionBarBackgroundMover", L.LAYOUT_MAINBAR, nil, E.EuiActionBarBackgroundMove)

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
	function E.EuiPetActionBarBackgroundMove(frame)
		if E.Movers[frame:GetName()]["moved"] ~= true then
			frame:ClearAllPoints()
			if C["actionbar"].bottompetbar ~= true then
				frame:SetPoint("RIGHT", UIParent, "RIGHT", E.Scale(-6), E.Scale(-13.5))
			else
				frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, E.Scale(4))
			end
		end
	end
	E.CreateMover(petbg, "EuiPetActionBarBackgroundMover", L.LAYOUT_PETBAR, nil, E.EuiPetActionBarBackgroundMove)
	
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

-- raid backgound layout
if C["raid"].raid == true then
	local raidbg = CreateFrame("Frame", "EuiRaidBackground", UIParent)
	if C["raid"].astyle == 0 then
		E.EuiCreatePanel(raidbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, C["raid"].gridheight)
		if C["raid"].grouphv == true then
			raidbg:SetWidth(C["raid"].gridw * 5 + 32)
			raidbg:SetHeight(C["raid"].gridh * C["raid"].raidgroups + 18 *(C["raid"].raidgroups - 1))
		else	
			raidbg:SetWidth(C["raid"].gridw * C["raid"].raidgroups + 18* (C["raid"].raidgroups -1))
			raidbg:SetHeight(C["raid"].gridh * 5 + 80)
		end
	elseif C["raid"].astyle == 1 then
		E.EuiCreatePanel(raidbg, 1, 1, "TOPLEFT", UIParent, "TOPLEFT", 10, -10)
		raidbg:SetWidth(C["raid"].nogridw)
		raidbg:SetHeight(C["raid"].nogridh*C["raid"].raidgroups*20 + 72*C["raid"].raidgroups+ C["raid"].groupspace * (C["raid"].raidgroups - 1))
	elseif C["raid"].astyle == 2 then
		E.EuiCreatePanel(raidbg, 1, 1, "BOTTOMLEFT", EuiTopChatBackground, "TOPLEFT", 0, 24)
		raidbg:SetWidth(C["chat"].chatw)
		raidbg:SetHeight(C["raid"].nogridh* floor(C["raid"].raidgroups/2)*20 + 72* floor(C["raid"].raidgroups/2)+ C["raid"].groupspace * (floor(C["raid"].raidgroups/2) - 1))
	end
	function E.EuiRaidBackgroundMove(frame)
		if E.Movers[frame:GetName()]["moved"] ~= true then
			frame:ClearAllPoints()
			if C["raid"].astyle == 0 then
				frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, C["raid"].gridheight)
			elseif C["raid"].astyle == 1 then
				frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
			elseif C["raid"].astyle == 2 then
				frame:SetPoint("BOTTOMLEFT", EuiTopChatBackground, "TOPLEFT", 0, 10)
			end
		end
	end
	E.CreateMover(raidbg, "EuiRaidBackgroundMover", L.LAYOUT_RAID, nil, E.EuiRaidBackgroundMove)
end