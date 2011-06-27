local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	--Class Trainer Frame
	local StripAllTextures = {
		"ClassTrainerFrame",
		"ClassTrainerScrollFrameScrollChild",
		"ClassTrainerFrameSkillStepButton",
		"ClassTrainerFrameBottomInset",
	}

	local buttons = {
		"ClassTrainerTrainButton",
	}

	local KillTextures = {
		"ClassTrainerFrameInset",
		"ClassTrainerFramePortrait",
		"ClassTrainerScrollFrameScrollBarBG",
		"ClassTrainerScrollFrameScrollBarTop",
		"ClassTrainerScrollFrameScrollBarBottom",
		"ClassTrainerScrollFrameScrollBarMiddle",
	}

	for i=1,8 do
		E.StripTextures(_G["ClassTrainerScrollFrameButton"..i])
		E.StyleButton(_G["ClassTrainerScrollFrameButton"..i])
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
		E.EuiCreateBackdrop(_G["ClassTrainerScrollFrameButton"..i])
		_G["ClassTrainerScrollFrameButton"..i].backdrop:SetPoint("TOPLEFT", _G["ClassTrainerScrollFrameButton"..i.."Icon"], "TOPLEFT", -2, 2)
		_G["ClassTrainerScrollFrameButton"..i].backdrop:SetPoint("BOTTOMRIGHT", _G["ClassTrainerScrollFrameButton"..i.."Icon"], "BOTTOMRIGHT", 2, -2)
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetParent(_G["ClassTrainerScrollFrameButton"..i].backdrop)
		
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetTexture(1, 1, 1, 0.3)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:ClearAllPoints()
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetPoint("TOPLEFT", 2, -2)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	for _, texture in pairs(KillTextures) do
		E.Kill(_G[texture])
	end

	for i = 1, #buttons do
		E.StripTextures(_G[buttons[i]])
		E.SkinButton(_G[buttons[i]])
	end

	E.SkinDropDownBox(ClassTrainerFrameFilterDropDown, 155)

	E.EuiCreateBackdrop(ClassTrainerFrame,.7)
	ClassTrainerFrame.backdrop:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
	ClassTrainerFrame.backdrop:SetPoint("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")
	E.SkinCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(.08, .92, .08, .92)
	E.EuiCreateBackdrop(ClassTrainerFrameSkillStepButton)
	ClassTrainerFrameSkillStepButton.backdrop:SetPoint("TOPLEFT", ClassTrainerFrameSkillStepButton.icon, "TOPLEFT", -2, 2)
	ClassTrainerFrameSkillStepButton.backdrop:SetPoint("BOTTOMRIGHT", ClassTrainerFrameSkillStepButton.icon, "BOTTOMRIGHT", 2, -2)
	ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.backdrop)

	E.StripTextures(ClassTrainerStatusBar)
	ClassTrainerStatusBar:SetStatusBarTexture(E.normTex)
	E.EuiCreateBackdrop(ClassTrainerStatusBar)
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER")
end

E.SkinFuncs["Blizzard_TrainerUI"] = LoadSkin