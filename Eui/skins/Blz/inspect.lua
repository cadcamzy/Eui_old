Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(InspectFrame,true)
	E.StripTextures(InspectFrameInset,true)
	E.StripTextures(InspectTalentFramePointsBar)
	E.EuiCreateBackdrop(InspectFrame,.7)
	InspectFrame.backdrop:SetAllPoints()
	E.SkinCloseButton(InspectFrameCloseButton)
	
	for i=1, 4 do
		E.SkinTab(_G["InspectFrameTab"..i])
	end
	
	E.Kill(InspectModelFrameBorderTopLeft)
	E.Kill(InspectModelFrameBorderTopRight)
	E.Kill(InspectModelFrameBorderTop)
	E.Kill(InspectModelFrameBorderLeft)
	E.Kill(InspectModelFrameBorderRight)
	E.Kill(InspectModelFrameBorderBottomLeft)
	E.Kill(InspectModelFrameBorderBottomRight)
	E.Kill(InspectModelFrameBorderBottom)
	E.Kill(InspectModelFrameBorderBottom2)
	E.Kill(InspectModelFrameBackgroundOverlay)
	E.EuiCreateBackdrop(InspectModelFrame)
	
	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
	}
	for _, slot in pairs(slots) do
		local icon = _G["Inspect"..slot.."IconTexture"]
		local slot = _G["Inspect"..slot]
		E.StripTextures(slot)
		E.StyleButton(slot,false)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 2)
		
		slot:SetFrameLevel(slot:GetFrameLevel() + 2)
		E.EuiCreateBackdrop(slot)
		slot.backdrop:SetAllPoints()
	end		
	
	E.SkinRotateButton(InspectModelFrameRotateLeftButton)
	E.SkinRotateButton(InspectModelFrameRotateRightButton)
	InspectModelFrameRotateRightButton:SetPoint("TOPLEFT", InspectModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)
	
	E.Kill(InspectPVPFrameBottom)
	E.Kill(InspectGuildFrameBG)
	InspectPVPFrame:HookScript("OnShow", function() E.Kill(InspectPVPFrameBG) end)
	
	for i=1, 3 do
		E.StripTextures(_G["InspectPVPTeam"..i])
		E.StripTextures(_G["InspectTalentFrameTab"..i])
	end
	
	InspectTalentFrame.bg = CreateFrame("Frame", nil, InspectTalentFrame)
	E.EuiSetTemplate(InspectTalentFrame.bg)
	InspectTalentFrame.bg:SetPoint("TOPLEFT", InspectTalentFrameBackgroundTopLeft, "TOPLEFT", -2, 2)
	InspectTalentFrame.bg:SetPoint("BOTTOMRIGHT", InspectTalentFrameBackgroundBottomRight, "BOTTOMRIGHT", -20, 52)
	InspectTalentFrame.bg:SetFrameLevel(InspectTalentFrame.bg:GetFrameLevel() - 2)
	
	for i = 1, MAX_NUM_TALENTS do
		local button = _G["InspectTalentFrameTalent"..i]
		local icon = _G["InspectTalentFrameTalent"..i.."IconTexture"]
		if button then
			E.StripTextures(button)
			E.StyleButton(button)
			E.EuiSetTemplate(button)
			button.SetHighlightTexture = E.dummy
			button.SetPushedTexture = E.dummy
			button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			button:GetPushedTexture():SetTexCoord(.08, .92, .08, .92)
			button:GetHighlightTexture():SetAllPoints(icon)
			button:GetPushedTexture():SetAllPoints(icon)
			
			if button.Rank then
				button.Rank:SetFont(E.font, 12, "THINOUTLINE")
				button.Rank:ClearAllPoints()
				button.Rank:SetPoint("BOTTOMRIGHT")
			end		
			
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			icon:SetTexCoord(.08, .92, .08, .92)
		end
	end		
end

E.SkinFuncs["Blizzard_InspectUI"] = LoadSkin