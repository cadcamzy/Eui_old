local E, C = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- Setup Vehicle Bar
---------------------------------------------------------------------------

local vbar = CreateFrame("Frame", "EuiVehicleBar", EuiVehicleBarBackground, "SecureHandlerStateTemplate")
vbar:ClearAllPoints()
vbar:SetAllPoints(EuiVehicleBarBackground)

vbar:RegisterEvent("UNIT_ENTERED_VEHICLE")
vbar:RegisterEvent("UNIT_DISPLAYPOWER")
vbar:RegisterEvent("PLAYER_LOGIN")
vbar:RegisterEvent("PLAYER_ENTERING_WORLD")
vbar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
			button = _G["VehicleMenuBarActionButton"..i]
			self:SetFrameRef("VehicleMenuBarActionButton"..i, button)
		end	
		
		self:SetAttribute("_onstate-vehicleupdate", [[
			if newstate == "s1" then
				self:GetParent():Show()
			else
				self:GetParent():Hide()
			end
		]])
		
		RegisterStateDriver(self, "vehicleupdate", "[vehicleui]s1;s2")
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
			button = _G["VehicleMenuBarActionButton"..i]
			button:SetSize(E.buttonsize*1.2, E.buttonsize*1.2)
			button:ClearAllPoints()
			button:SetParent(EuiVehicleBar)
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", EuiVehicleBar, E.buttonspacing*1.2, E.buttonspacing*1.2)
			else
				local previous = _G["VehicleMenuBarActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", E.buttonspacing*1.2, 0)
			end
		end
	else
		VehicleMenuBar_OnEvent(self, event, ...)
	end
end)

--Create our custom Vehicle Button Hotkeys, because blizzard is fucking gay and won't let us reposition the default ones
do
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		_G["EuiVehicleHotkey"..i] = _G["VehicleMenuBarActionButton"..i]:CreateFontString("EuiVehicleHotkey"..i, "OVERLAY", nil)
		_G["EuiVehicleHotkey"..i]:ClearAllPoints()
		_G["EuiVehicleHotkey"..i]:SetPoint("TOPRIGHT", 0, E.Scale(-3))
		_G["EuiVehicleHotkey"..i]:SetFont(E.font, 14, "OUTLINE")
		_G["EuiVehicleHotkey"..i].ClearAllPoints = E.dummy
		_G["EuiVehicleHotkey"..i].SetPoint = E.dummy
		
		if not C["actionbar"].hotkey == true then
			_G["EuiVehicleHotkey"..i]:SetText("")
			_G["EuiVehicleHotkey"..i]:Hide()
			_G["EuiVehicleHotkey"..i].Show = E.dummy
		else
			_G["EuiVehicleHotkey"..i]:SetText(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetText())
		end
	end
end

local UpdateVehHotkeys = function()
	if not UnitHasVehicleUI("player") then return end
	if C["actionbar"].hotkey ~= true then return end
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		_G["EuiVehicleHotkey"..i]:SetText(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetText())
		_G["EuiVehicleHotkey"..i]:SetTextColor(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetTextColor())
	end
end

local VehTextUpdate = CreateFrame("Frame")
VehTextUpdate:RegisterEvent("UNIT_ENTERING_VEHICLE")
VehTextUpdate:RegisterEvent("UNIT_ENTERED_VEHICLE")
VehTextUpdate:SetScript("OnEvent", UpdateVehHotkeys)

-- vehicle button under minimap
local vehicle = CreateFrame("Button", nil, UIParent, "SecureHandlerClickTemplate")
vehicle:SetWidth(E.Scale(26))
vehicle:SetHeight(E.Scale(26))
vehicle:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -E.Scale(2), E.Scale(2))
vehicle:SetNormalTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
vehicle:SetPushedTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
vehicle:SetHighlightTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
E.EuiSetTemplate(vehicle)
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)
RegisterStateDriver(vehicle, "visibility", "[vehicleui][target=vehicle,noexists] hide;show")

-- vehicle on vehicle bar, dont need to have a state driver.. its parented to vehicle bar
local vehicle2 = CreateFrame("BUTTON", nil, EuiVehicleBarBackground, "SecureActionButtonTemplate")
vehicle2:SetWidth(E.buttonsize*1.2)
vehicle2:SetHeight(E.buttonsize*1.2)
vehicle2:SetPoint("RIGHT", EuiVehicleBarBackground, "RIGHT", -E.buttonspacing*1.2, 0)
vehicle2:RegisterForClicks("AnyUp")
vehicle2:SetNormalTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
vehicle2:SetPushedTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
vehicle2:SetHighlightTexture("Interface\\AddOns\\Eui\\media\\vehicleexit")
E.EuiSetTemplate(vehicle2)
vehicle2:SetScript("OnClick", function() VehicleExit() end)