local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	E.SkinCloseButton(MacroFrameCloseButton)
	
	MacroFrame:SetWidth(360)
	
	local buttons = {
		"MacroDeleteButton",
		"MacroNewButton",
		"MacroExitButton",
		"MacroEditButton",
		"MacroFrameTab1",
		"MacroFrameTab2",
		"MacroPopupOkayButton",
		"MacroPopupCancelButton",
	}
	
	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end
	
	for i = 1, 2 do
		tab = _G[format("MacroFrameTab%s", i)]
		tab:SetHeight(22)
	end
	MacroFrameTab1:SetPoint("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
	MacroFrameTab2:SetPoint("LEFT", MacroFrameTab1, "RIGHT", 4, 0)
	

	-- General
	E.StripTextures(MacroFrame)
	E.EuiSetTemplate(MacroFrame,.7)
	E.StripTextures(MacroFrameTextBackground)
	E.EuiCreateBackdrop(MacroFrameTextBackground)
	E.EuiCreateBackdrop(MacroButtonScrollFrame)
	E.StripTextures(MacroPopupFrame)
	E.EuiSetTemplate(MacroPopupFrame,.7)
	E.StripTextures(MacroPopupScrollFrame)
	E.EuiCreateBackdrop(MacroPopupScrollFrame)
	MacroPopupScrollFrame.backdrop:SetPoint("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
	E.EuiCreateBackdrop(MacroPopupEditBox)
	E.StripTextures(MacroPopupEditBox)
	
	--Reposition edit button
	MacroEditButton:ClearAllPoints()
	MacroEditButton:SetPoint("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)
	
	-- Regular scroll bar
	E.SkinScrollBar(MacroButtonScrollFrame)
	
	MacroPopupFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", 5, -2)
	end)
	
	-- Big icon
	E.StripTextures(MacroFrameSelectedMacroButton)
	E.StyleButton(MacroFrameSelectedMacroButton,true)
	MacroFrameSelectedMacroButton:GetNormalTexture():SetTexture(nil)
	E.EuiSetTemplate(MacroFrameSelectedMacroButton)
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(.08, .92, .08, .92)
	MacroFrameSelectedMacroButtonIcon:ClearAllPoints()
	MacroFrameSelectedMacroButtonIcon:SetPoint("TOPLEFT", 2, -2)
	MacroFrameSelectedMacroButtonIcon:SetPoint("BOTTOMRIGHT", -2, 2)
	
	-- temporarily moving this text
	MacroFrameCharLimitText:ClearAllPoints()
	MacroFrameCharLimitText:SetPoint("BOTTOM", MacroFrameTextBackground, 0, -70)
	
	-- Skin all buttons
	for i = 1, MAX_ACCOUNT_MACROS do
		local b = _G["MacroButton"..i]
		local t = _G["MacroButton"..i.."Icon"]
		local pb = _G["MacroPopupButton"..i]
		local pt = _G["MacroPopupButton"..i.."Icon"]
		
		if b then
			E.StripTextures(b)
			E.StyleButton(b,true)
			
			E.EuiSetTemplate(b)
		end
		
		if t then
			t:SetTexCoord(.08, .92, .08, .92)
			t:ClearAllPoints()
			t:SetPoint("TOPLEFT", 2, -2)
			t:SetPoint("BOTTOMRIGHT", -2, 2)
		end

		if pb then
			E.StripTextures(pb)
			E.StyleButton(pb,true)
			
			E.EuiSetTemplate(pb)
		end
		
		if pt then
			pt:SetTexCoord(.08, .92, .08, .92)
			pt:ClearAllPoints()
			pt:SetPoint("TOPLEFT", 2, -2)
			pt:SetPoint("BOTTOMRIGHT", -2, 2)
		end
	end
end

E.SkinFuncs["Blizzard_MacroUI"] = LoadSkin