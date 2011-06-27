--Create interactable actionbars
local E, C = unpack(EUI) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

local function Button_OnEnter(self)
	self.Text:SetTextColor(1, 1, 1)
	self:SetBackdropBorderColor(23/255,132/255,209/255)
end

local function Button_OnLeave(self)
	self.Text:SetTextColor(23/255,132/255,209/255)
	E.EuiSetTemplate(self)
end

local function Button_OnEvent(self, event)
	if self:IsShown() then self:Hide() end
end

local btnnames = {}

local function CreateMoverButton(name, text)
	local b = CreateFrame("Button", name, UIParent)
	E.EuiSetTemplate(b)
	b:RegisterEvent("PLAYER_REGEN_DISABLED")
	b:SetScript("OnEvent", Button_OnEvent)
	b:SetScript("OnEnter", Button_OnEnter)
	b:SetScript("OnLeave", Button_OnLeave)
	b:EnableMouse(true)
	b:Hide()
	E.EuiCreateShadow(b)
	tinsert(btnnames, tostring(name))
	
	local t = b:CreateFontString(nil, "OVERLAY", b)
	t:SetFont(E.font,14,"THINOUTLINE")
	t:SetShadowOffset(E.mult, -E.mult)
	t:SetShadowColor(0, 0, 0)
	t:SetPoint("CENTER")
	t:SetJustifyH("CENTER")
	t:SetText(text)
	t:SetTextColor(23/255,132/255,209/255)
	b.Text = t
end

local function SaveBars(var, val)
	E["actionbar"][var] = val
	E.PositionAllBars()
end

function E.ToggleABLock()
	if InCombatLockdown() then return end
	
	if E.ABLock == true then
		E.ABLock = false
	else
		E.ABLock = true
	end
	
	for i, btnnames in pairs(btnnames) do
		if E.ABLock == false then
			_G[btnnames]:EnableMouse(false)
			_G[btnnames]:Hide()
			EuiInfoLeftRButton.text:SetTextColor(20/255,122/255,199/25)
			EuiInfoLeftRButton.text:SetText("UnLock")
			if E.align then Grid_Hide() end 
		else
			_G[btnnames]:EnableMouse(true)
			if btnnames == "RightBarBig" and not (E["actionbar"].rightbars ~= 0 or (E["actionbar"].bottomrows == 3 and E["actionbar"].splitbar == true)) then
				_G[btnnames]:Show()
			elseif btnnames ~= "RightBarBig" then
				_G[btnnames]:Show()
			end
			EuiInfoLeftRButton.text:SetTextColor(23/255,132/255,209/255)
			EuiInfoLeftRButton.text:SetText("Lock")
			if E.align then Grid_Show() end --ÏÔÊ¾alignµÄÍø¸ñ
		end
	end
end

--Create our buttons
do
	CreateMoverButton("LeftSplit", "<")
	CreateMoverButton("RightSplit", ">")
	CreateMoverButton("TopMainBar", "+")
	CreateMoverButton("RightBarBig", "<")
	CreateMoverButton("RightBarInc", "<")
	CreateMoverButton("RightBarDec", ">")
end

--Position & Size our buttons after variables loaded
local barloader = CreateFrame("Frame")
barloader:RegisterEvent("PLAYER_ENTERING_WORLD")
barloader:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if EuiData == nil then EuiData = {} end
	if EuiData[E.myrealm] == nil then EuiData[E.myrealm] = {} end
	if EuiData[E.myrealm][E.MyName] == nil then EuiData[E.myrealm][E.MyName] = {} end
	if EuiData[E.myrealm][E.MyName]["actionbar"] == nil then EuiData[E.myrealm][E.MyName]["actionbar"] = {} end
	
	E["actionbar"] = EuiData[E.myrealm][E.MyName]["actionbar"]
	
	--Default settings
	if E["actionbar"].splitbar == nil then E["actionbar"].splitbar = true end
	if E["actionbar"].bottomrows == nil then E["actionbar"].bottomrows = 1 end
	if E["actionbar"].rightbars == nil then E["actionbar"].rightbars = 0 end
	
	if E["actionbar"].splitbar == true then
		LeftSplit:SetPoint("TOPRIGHT", EuiSplitActionBarLeftBackground, "TOPLEFT", E.Scale(-4), 0)
		LeftSplit:SetPoint("BOTTOMLEFT", EuiSplitActionBarLeftBackground, "BOTTOMLEFT", E.Scale(-19), 0)
		LeftSplit.Text:SetText(">")
		
		RightSplit:SetPoint("TOPLEFT", EuiSplitActionBarRightBackground, "TOPRIGHT", E.Scale(4), 0)
		RightSplit:SetPoint("BOTTOMRIGHT", EuiSplitActionBarRightBackground, "BOTTOMRIGHT", E.Scale(19), 0)
		RightSplit.Text:SetText("<")
	else
		LeftSplit:SetPoint("TOPRIGHT", EuiMainMenuBar, "TOPLEFT", E.Scale(-4), 0)
		LeftSplit:SetPoint("BOTTOMLEFT", EuiMainMenuBar, "BOTTOMLEFT", E.Scale(-19), 0)	
		
		RightSplit:SetPoint("TOPLEFT", EuiMainMenuBar, "TOPRIGHT", E.Scale(4), 0)
		RightSplit:SetPoint("BOTTOMRIGHT", EuiMainMenuBar, "BOTTOMRIGHT", E.Scale(19), 0)
	end
	
	if E["actionbar"].bottomrows == 3 then
		TopMainBar.Text:SetText("-")
	else
		TopMainBar.Text:SetText("+")
	end
	
	TopMainBar:SetPoint("BOTTOMLEFT", EuiMainMenuBar, "TOPLEFT", 0, E.Scale(4))
	TopMainBar:SetPoint("TOPRIGHT", EuiMainMenuBar, "TOPRIGHT", 0, E.Scale(19))
	
	if EuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
		RightBarBig:SetPoint("TOPRIGHT", EuiPetBar, "LEFT", E.Scale(-3), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", EuiPetBar, "LEFT", E.Scale(-19), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))			
	else
		RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", E.Scale(-1), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", E.Scale(-16), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))		
	end
	
	EuiPetBar:HookScript("OnShow", function(self)
		if C["actionbar"].bottompetbar == true then return end
		if InCombatLockdown() then return end
		RightBarBig:ClearAllPoints()
		RightBarBig:SetPoint("TOPRIGHT", EuiPetBar, "LEFT", E.Scale(-3), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", EuiPetBar, "LEFT", E.Scale(-19), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))	
	end)
	
	EuiPetBar:HookScript("OnHide", function(self)
		if InCombatLockdown() then return end
		if C["actionbar"].bottompetbar == true then return end
		RightBarBig:ClearAllPoints()
		RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", E.Scale(-1), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", E.Scale(-16), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))
	end)
	
	RightBarBig:HookScript("OnEnter", function()
		if InCombatLockdown() then return end
		RightBarBig:ClearAllPoints()
		if EuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
			RightBarBig:SetPoint("TOPRIGHT", EuiPetBar, "LEFT", E.Scale(-3), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
			RightBarBig:SetPoint("BOTTOMLEFT", EuiPetBar, "LEFT", E.Scale(-19), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))			
		else
			RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", E.Scale(-1), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
			RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", E.Scale(-16), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))		
		end
	end)
	
	if E["actionbar"].rightbars ~= 0 or (E["actionbar"].bottomrows == 3 and E["actionbar"].splitbar == true) then
		RightBarBig:Hide()
	end
	
	RightBarInc:SetParent(EuiActionBarBackgroundRight)
	RightBarDec:SetParent(EuiActionBarBackgroundRight)
	
	--Disable some default button stuff
	if C["actionbar"].rightbarmouseover == true then
		RightBarInc:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		RightBarInc:SetScript("OnLeave", function() RightBarMouseOver(0) end)
		RightBarDec:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		RightBarDec:SetScript("OnLeave", function() RightBarMouseOver(0) end)	
	else
		RightBarInc:SetScript("OnEnter", function() end)
		RightBarInc:SetScript("OnLeave", function() end)
		RightBarDec:SetScript("OnEnter", function() end)
		RightBarDec:SetScript("OnLeave", function() end)	
	end

	RightBarDec:SetAlpha(1)
	RightBarInc:SetAlpha(1)
	
	RightBarInc:SetPoint("TOPLEFT", EuiActionBarBackgroundRight, "BOTTOMLEFT", 0, E.Scale(-4))
	RightBarInc:SetPoint("BOTTOMRIGHT", EuiActionBarBackgroundRight, "BOTTOM", E.Scale(-2), E.Scale(-19))
	
	RightBarDec:SetPoint("TOPRIGHT", EuiActionBarBackgroundRight, "BOTTOMRIGHT", 0, E.Scale(-4))
	RightBarDec:SetPoint("BOTTOMLEFT", EuiActionBarBackgroundRight, "BOTTOM", E.Scale(2), E.Scale(-19))
	
	E.ABLock = false
	EuiInfoLeftRButton.text:SetTextColor(20/255,122/255,199/25)
	EuiInfoLeftRButton.text:SetText("UnLock")
	E.PositionAllBars()
end)

--Setup button clicks
do
	LeftSplit:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end	
		if E["actionbar"].splitbar ~= true then
			SaveBars("splitbar", true)
			LeftSplit.Text:SetText(">")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", EuiSplitActionBarLeftBackground, "TOPLEFT", E.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", EuiSplitActionBarLeftBackground, "BOTTOMLEFT", E.Scale(-19), 0)
			
			RightSplit.Text:SetText("<")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", EuiSplitActionBarRightBackground, "TOPRIGHT", E.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", EuiSplitActionBarRightBackground, "BOTTOMRIGHT", E.Scale(19), 0)				
		else
			SaveBars("splitbar", false)
			LeftSplit.Text:SetText("<")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", EuiMainMenuBar, "TOPLEFT", E.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", EuiMainMenuBar, "BOTTOMLEFT", E.Scale(-19), 0)
			
			RightSplit.Text:SetText(">")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", EuiMainMenuBar, "TOPRIGHT", E.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", EuiMainMenuBar, "BOTTOMRIGHT", E.Scale(19), 0)
		end
	end)
	
	RightSplit:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if E["actionbar"].splitbar ~= true then
			SaveBars("splitbar", true)
			LeftSplit.Text:SetText(">")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", EuiSplitActionBarLeftBackground, "TOPLEFT", E.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", EuiSplitActionBarLeftBackground, "BOTTOMLEFT", E.Scale(-19), 0)
			
			RightSplit.Text:SetText("<")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", EuiSplitActionBarRightBackground, "TOPRIGHT", E.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", EuiSplitActionBarRightBackground, "BOTTOMRIGHT", E.Scale(19), 0)				
		else
			SaveBars("splitbar", false)
			LeftSplit.Text:SetText("<")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", EuiMainMenuBar, "TOPLEFT", E.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", EuiMainMenuBar, "BOTTOMLEFT", E.Scale(-19), 0)
			
			RightSplit.Text:SetText(">")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", EuiMainMenuBar, "TOPRIGHT", E.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", EuiMainMenuBar, "BOTTOMRIGHT", E.Scale(19), 0)
		end
	end)
	
	TopMainBar:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if E["actionbar"].bottomrows == 1 then
			SaveBars("bottomrows", 2)
			TopMainBar.Text:SetText("+")
		elseif E["actionbar"].bottomrows == 2 then
			SaveBars("bottomrows", 3)
			TopMainBar.Text:SetText("-")
		elseif E["actionbar"].bottomrows == 3 then
			SaveBars("bottomrows", 1)
			TopMainBar.Text:SetText("+")
		end
	end)
	
	RightBarBig:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		if C["actionbar"].rightbarmouseover ~= true then 
			E.SlideIn(EuiActionBarBackgroundRight)
		else
			EuiActionBarBackgroundRight:SetAlpha(0)
		end
		SaveBars("rightbars", 1)
		self:Hide()
	end)
	
	RightBarInc:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if E["actionbar"].rightbars == 1 then
			SaveBars("rightbars", 2)
		elseif E["actionbar"].rightbars == 2 then
			SaveBars("rightbars", 3)
		elseif E["actionbar"].rightbars == 3 then
			SaveBars("rightbars", 0)
			RightBarBig:Show()
			RightBarBig:ClearAllPoints()
			if EuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
				RightBarBig:SetPoint("TOPRIGHT", EuiPetBar, "LEFT", E.Scale(-3), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", EuiPetBar, "LEFT", E.Scale(-19), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))			
			else
				RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", E.Scale(-1), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", E.Scale(-16), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))		
			end			
		end		
		if C["actionbar"].rightbarmouseover == true then 
			RightBarMouseOver(1)
		end
	end)
	
	RightBarDec:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if E["actionbar"].rightbars == 1 then
			SaveBars("rightbars", 0)
			RightBarBig:Show()
			RightBarBig:ClearAllPoints()
			if EuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
				RightBarBig:SetPoint("TOPRIGHT", EuiPetBar, "LEFT", E.Scale(-3), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", EuiPetBar, "LEFT", E.Scale(-19), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))			
			else
				RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", E.Scale(-1), (EuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", E.Scale(-16), -(EuiActionBarBackgroundRight:GetHeight() * 0.2))		
			end
		elseif E["actionbar"].rightbars == 2 then
			SaveBars("rightbars", 1)
		elseif E["actionbar"].rightbars == 3 then
			SaveBars("rightbars", 2)
		end		
		
		if C["actionbar"].rightbarmouseover == true then 
			RightBarMouseOver(1)
		end
	end)
end