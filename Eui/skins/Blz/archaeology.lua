local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(ArchaeologyFrame,true)
	E.StripTextures(ArchaeologyFrameInset,true)
	E.EuiSetTemplate(ArchaeologyFrame,.7)
	E.EuiCreateShadow(ArchaeologyFrame)
	
	E.SkinButton(ArchaeologyFrameArtifactPageSolveFrameSolveButton, true)
	E.SkinButton(ArchaeologyFrameArtifactPageBackButton, true)
	E.SkinDropDownBox(ArchaeologyFrameRaceFilter, 125)
	
	E.StripTextures(ArchaeologyFrameRankBar)
	ArchaeologyFrameRankBar:SetStatusBarTexture(E.normTex)
	E.EuiCreateBackdrop(ArchaeologyFrameRankBar)
	
	E.StripTextures(ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarTexture(E.normTex)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarColor(0.7, 0.2, 0)
	E.EuiCreateBackdrop(ArchaeologyFrameArtifactPageSolveFrameStatusBar)
	
	for i=1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local artifact = _G["ArchaeologyFrameCompletedPageArtifact"..i]
		
		if artifact then
			E.Kill(_G["ArchaeologyFrameCompletedPageArtifact"..i.."Border"])
			E.Kill(_G["ArchaeologyFrameCompletedPageArtifact"..i.."Bg"])
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop = CreateFrame("Frame", nil, artifact)
			E.EuiSetTemplate(_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetPoint("TOPLEFT", _G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"], "TOPLEFT", -2, 2)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetPoint("BOTTOMRIGHT", _G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"], "BOTTOMRIGHT", 2, -2)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"].backdrop:SetFrameLevel(artifact:GetFrameLevel() - 2)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."Icon"]:SetDrawLayer("OVERLAY")
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."ArtifactName"]:SetTextColor(1, 1, 0)
			_G["ArchaeologyFrameCompletedPageArtifact"..i.."ArtifactSubText"]:SetTextColor(0.6, 0.6, 0.6)
		end
	end
	
	for i=1, ARCHAEOLOGY_MAX_RACES do
		local frame = _G["ArchaeologyFrameSummaryPageRace"..i]
		
		if frame then
			frame.raceName:SetTextColor(1, 1, 1)
		end
	end
	
	for i=1, ArchaeologyFrameCompletedPage:GetNumRegions() do
		local region = select(i, ArchaeologyFrameCompletedPage:GetRegions())
		if region:GetObjectType() == "FontString" then
			region:SetTextColor(1, 1, 0)
		end
	end
	
	for i=1, ArchaeologyFrameSummaryPage:GetNumRegions() do
		local region = select(i, ArchaeologyFrameSummaryPage:GetRegions())
		if region:GetObjectType() == "FontString" then
			region:SetTextColor(1, 1, 0)
		end
	end
	
	ArchaeologyFrameCompletedPage.infoText:SetTextColor(1, 1, 1)
	ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 0)
	ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 0)
	ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
	
	ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 1, 0)
	ArchaeologyFrameArtifactPageIcon:SetTexCoord(.08, .92, .08, .92)
	ArchaeologyFrameArtifactPageIcon.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPage)
	E.EuiSetTemplate(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetPoint("TOPLEFT", ArchaeologyFrameArtifactPageIcon, "TOPLEFT", -2, 2)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetPoint("BOTTOMRIGHT", ArchaeologyFrameArtifactPageIcon, "BOTTOMRIGHT", 2, -2)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetFrameLevel(ArchaeologyFrameArtifactPage:GetFrameLevel())
	ArchaeologyFrameArtifactPageIcon:SetParent(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon:SetDrawLayer("OVERLAY")	
	
	ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
	E.SkinCloseButton(ArchaeologyFrameCloseButton)
end

E.SkinFuncs["Blizzard_ArchaeologyUI"] = LoadSkin