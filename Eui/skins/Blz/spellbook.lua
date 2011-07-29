local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.SkinCloseButton(SpellBookFrameCloseButton)
	
	local StripAllTextures = {
		"SpellBookFrame",
		"SpellBookFrameInset",
		"SpellBookSpellIconsFrame",
		"SpellBookSideTabsFrame",
		"SpellBookPageNavigationFrame",
	}
	
	local KillTextures = {
		"SpellBookPage1",
		"SpellBookPage2",
	}
	
	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end
	
	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end
	
	local pagebackdrop = CreateFrame("Frame", nil, SpellBookPage1:GetParent())
	E.EuiSetTemplate(pagebackdrop,.7)
	pagebackdrop:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", 50, -50)
	pagebackdrop:SetPoint("BOTTOMRIGHT", SpellBookPage1, "BOTTOMRIGHT", 15, 35)

	E.SkinNextPrevButton(SpellBookPrevPageButton)
	E.SkinNextPrevButton(SpellBookNextPageButton)
	
	--Skin SpellButtons
	local function SpellButtons(self, first)
		for i=1, SPELLS_PER_PAGE do
			local button = _G["SpellButton"..i]
			local icon = _G["SpellButton"..i.."IconTexture"]
			
			if first then
				--button:StripTextures()
				for i=1, button:GetNumRegions() do
					local region = select(i, button:GetRegions())
					if region:GetObjectType() == "Texture" then
						if region:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then
							region:SetTexture(nil)
						end
					end
				end
			end
			
			if _G["SpellButton"..i.."Highlight"] then
				_G["SpellButton"..i.."Highlight"]:SetTexture(1, 1, 1, 0.3)
				_G["SpellButton"..i.."Highlight"]:ClearAllPoints()
				_G["SpellButton"..i.."Highlight"]:SetAllPoints(icon)
			end

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetAllPoints()

				if not button.backdrop then
					E.EuiCreateBackdrop(button)
				end
			end	
			
			local r, g, b = _G["SpellButton"..i.."SpellName"]:GetTextColor()

			if r < 0.8 then
				_G["SpellButton"..i.."SpellName"]:SetTextColor(0.6, 0.6, 0.6)
			end
			_G["SpellButton"..i.."SubSpellName"]:SetTextColor(0.6, 0.6, 0.6)
			_G["SpellButton"..i.."RequiredLevelString"]:SetTextColor(0.6, 0.6, 0.6)
		end
	end
	SpellButtons(nil, true)
	hooksecurefunc("SpellButton_UpdateButton", SpellButtons)
	
	SpellBookPageText:SetTextColor(0.6, 0.6, 0.6)
	
	--Skill Line Tabs
	for i=1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]
		E.Kill(_G["SpellBookSkillLineTab"..i.."Flash"])
		if tab then
			E.StripTextures(tab)
			tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			tab:GetNormalTexture():ClearAllPoints()
			tab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			tab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			
			E.EuiCreateBackdrop(tab)
			tab.backdrop:SetAllPoints()
			E.StyleButton(tab,true)
			
			local point, relatedTo, point2, x, y = tab:GetPoint()
			tab:SetPoint(point, relatedTo, point2, 1, y)
		end
	end
	
	local function SkinSkillLine()
		for i=1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			local _, _, _, _, isGuild = GetSpellTabInfo(i)
			if isGuild then
				tab:GetNormalTexture():ClearAllPoints()
				tab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
				tab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)	
				tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)					
			end
		end
	end
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", SkinSkillLine)
	E.EuiSetTemplate(SpellBookFrame,.7)
	E.EuiCreateShadow(SpellBookFrame)
	
	--Profession Tab
	local professionbuttons = {
		"PrimaryProfession1SpellButtonTop",
		"PrimaryProfession1SpellButtonBottom",
		"PrimaryProfession2SpellButtonTop",
		"PrimaryProfession2SpellButtonBottom",
		"SecondaryProfession1SpellButtonLeft",
		"SecondaryProfession1SpellButtonRight",
		"SecondaryProfession2SpellButtonLeft",
		"SecondaryProfession2SpellButtonRight",
		"SecondaryProfession3SpellButtonLeft",
		"SecondaryProfession3SpellButtonRight",
		"SecondaryProfession4SpellButtonLeft",
		"SecondaryProfession4SpellButtonRight",		
	}
	
	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4",
	}
	
	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 1, 0)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end
	
	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local button = _G[button]
		E.StripTextures(button)
		
		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				E.EuiCreateBackdrop(button)
				button.backdrop:SetAllPoints()
			end
		end					
	end
	
	local professionstatusbars = {
		"PrimaryProfession1StatusBar",	
		"PrimaryProfession2StatusBar",	
		"SecondaryProfession1StatusBar",	
		"SecondaryProfession2StatusBar",	
		"SecondaryProfession3StatusBar",	
		"SecondaryProfession4StatusBar",
	}
	
	for _, statusbar in pairs(professionstatusbars) do
		local statusbar = _G[statusbar]
		E.StripTextures(statusbar)
		statusbar:SetStatusBarTexture(E.normTex)
		statusbar:SetStatusBarColor(0, 220/255, 0)
		E.EuiCreateBackdrop(statusbar)
		
		statusbar.rankText:ClearAllPoints()
		statusbar.rankText:SetPoint("CENTER")
	end
	
	--Mounts/Companions
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i]
		local icon = _G["SpellBookCompanionButton"..i.."IconTexture"]
		E.StripTextures(button)
		E.StyleButton(button,false)
		
		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			
			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				E.EuiCreateBackdrop(button)
				button.backdrop:SetAllPoints()
			end
		end					
	end
	
	E.SkinButton(SpellBookCompanionSummonButton)
	E.StripTextures(SpellBookCompanionModelFrame)
	E.StripTextures(SpellBookCompanionModelFrameShadowOverlay)
	E.Kill(SpellBookCompanionsModelFrame)
	E.EuiSetTemplate(SpellBookCompanionModelFrame)
	
	E.SkinRotateButton(SpellBookCompanionModelFrameRotateRightButton)
	E.SkinRotateButton(SpellBookCompanionModelFrameRotateLeftButton)
	SpellBookCompanionModelFrameRotateRightButton:SetPoint("TOPLEFT", SpellBookCompanionModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)
	
	
	--Bottom Tabs
	for i=1, 5 do
		E.SkinTab(_G["SpellBookFrameTabButton"..i])
	end
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)