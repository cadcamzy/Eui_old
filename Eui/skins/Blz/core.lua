local E, C, L = unpack(EUI)

--if C["skins"].enable ~= true then return end

E.SkinFuncs = {}
E.SkinFuncs["Eui"] = {}

local function SetModifiedBackdrop(self)
	E.EuiSetTemplate(self)
end

local function SetOriginalBackdrop(self)
	E.EuiSetTemplate(self)
end

function E.StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				E.Kill(region)
			else
				region:SetTexture(nil)
			end
		end
	end		
end

function E.SkinButton(f, strip)
	if f:GetName() then
		local l = _G[f:GetName().."Left"]
		local m = _G[f:GetName().."Middle"]
		local r = _G[f:GetName().."Right"]
		
		
		if l then l:SetAlpha(0) end
		if m then m:SetAlpha(0) end
		if r then r:SetAlpha(0) end
	end

	if f.SetNormalTexture then f:SetNormalTexture("") end
	
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	
	if f.SetPushedTexture then f:SetPushedTexture("") end
	
	if f.SetDisabledTexture then f:SetDisabledTexture("") end
	
	if strip then E.StripTextures(f) end
	
	E.EuiSetTemplate(f)
	f:HookScript("OnEnter", SetModifiedBackdrop)
	f:HookScript("OnLeave", SetOriginalBackdrop)
end

function E.SkinScrollBar(frame)
	if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
	if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end
	
	if _G[frame:GetName().."Top"] then
		_G[frame:GetName().."Top"]:SetTexture(nil)
		_G[frame:GetName().."Bottom"]:SetTexture(nil)
		_G[frame:GetName().."Middle"]:SetTexture(nil)
	end
end

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

function E.SkinTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end
	
	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		E.StripTextures(tab)
	end
	
	tab.backdrop = CreateFrame("Frame", nil, tab)
	E.EuiSetTemplate(tab.backdrop)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:SetPoint("TOPLEFT", 10, -3)
	tab.backdrop:SetPoint("BOTTOMRIGHT", -10, 3)				
end

function E.SkinNextPrevButton(btn, horizonal)
	E.EuiSetTemplate(btn)
	btn:SetSize(btn:GetWidth() - 7, btn:GetHeight() - 7)	

	if horizonal then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
		btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)	
	else
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end
	end
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	if btn:GetDisabledTexture() then
		btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
	end
	
	if btn:GetPushedTexture() then
		btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	end
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function E.SkinRotateButton(btn)
	E.EuiSetTemplate(btn)
	btn:SetSize(btn:GetWidth() - 14, btn:GetHeight() - 14)	
	
	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)	
	
	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	
	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())	
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function E.SkinEditBox(frame)
	if _G[frame:GetName().."Left"] then E.Kill(_G[frame:GetName().."Left"]) end
	if _G[frame:GetName().."Middle"] then E.Kill(_G[frame:GetName().."Middle"]) end
	if _G[frame:GetName().."Right"] then E.Kill(_G[frame:GetName().."Right"]) end
	if _G[frame:GetName().."Mid"] then E.Kill(_G[frame:GetName().."Mid"]) end
	E.EuiCreateBackdrop(frame)
	
	if frame:GetName() and frame:GetName():find("Silver") or frame:GetName():find("Copper") then
		frame.backdrop:SetPoint("BOTTOMRIGHT", -12, -2)
	end
end

function E.SkinDropDownBox(frame, width)
	local button = _G[frame:GetName().."Button"]
	if not width then width = 155 end
	
	E.StripTextures(frame)
	frame:SetWidth(width)
	
	_G[frame:GetName().."Text"]:ClearAllPoints()
	_G[frame:GetName().."Text"]:SetPoint("RIGHT", button, "LEFT", -2, 0)

	
	button:ClearAllPoints()
	button:SetPoint("RIGHT", frame, "RIGHT", -10, 3)
	button.SetPoint = E.dummy
	
	E.SkinNextPrevButton(button, true)
	
	E.EuiCreateBackdrop(frame)
	frame.backdrop:SetPoint("TOPLEFT", 20, -2)
	frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function E.SkinCheckBox(frame)
	E.StripTextures(frame)
	E.EuiCreateBackdrop(frame)
	frame.backdrop:SetPoint("TOPLEFT", 4, -4)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
	
	if frame.SetCheckedTexture then
		frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end
	
	if frame.SetDisabledTexture then
		frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	end
	
	frame.SetNormalTexture = E.dummy
	frame.SetPushedTexture = E.dummy
	frame.SetHighlightTexture = E.dummy
end

function E.SkinCloseButton(f, point)
	for i=1, f:GetNumRegions() do
		local region = select(i, f:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
			
			if region:GetTexture() == "Interface\\DialogFrame\\UI-DialogBox-Corner" then
				E.Kill(region)
			end
		end
	end	
	
	if point then
		f:SetPoint("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

local EuiSkin = CreateFrame("Frame")
EuiSkin:RegisterEvent("ADDON_LOADED")
EuiSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then return end
	for _addon, skinfunc in pairs(E.SkinFuncs) do
		if type(skinfunc) == "function" then
			if _addon == addon then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == "table" then
			if _addon == addon then
				for _, skinfunc in pairs(E.SkinFuncs[_addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end)