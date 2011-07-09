--Create a Mover frame

local E, C, L = unpack(EUI) -- Import Functions/Constants, Config, Locales

E.CreatedMovers = {}

local print = function(...)
	return print('|cff1784d1EUI:|r', ...)
end

local function CreateMover(parent, name, text, overlay, postdrag)
	if not parent then return end --If for some reason the parent isnt loaded yet
	
	if overlay == nil then overlay = true end
	
	if EuiData == nil then EuiData = {} end
	if EuiData[E.myrealm] == nil then EuiData[E.myrealm] = {} end
	if EuiData[E.myrealm][E.MyName] == nil then EuiData[E.myrealm][E.MyName] = {} end
	if EuiData[E.myrealm][E.MyName]["movers"] == nil then EuiData[E.myrealm][E.MyName]["movers"] = {} end
	if EuiData[E.myrealm][E.MyName]["movers"][name] == nil then EuiData[E.myrealm][E.MyName]["movers"][name] = {} end
	
	E.Movers = EuiData[E.myrealm][E.MyName]["movers"]
	
	local p, p2, p3, p4, p5 = parent:GetPoint()
	
	if E.Movers[name]["moved"] == nil then 
		E.Movers[name]["moved"] = false 
		
		E.Movers[name]["p"] = nil
		E.Movers[name]["p2"] = nil
		E.Movers[name]["p3"] = nil
		E.Movers[name]["p4"] = nil
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetPoint(p, p2, p3, p4, p5)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight())

	local f2 = CreateFrame("Button", name, UIParent)
	f2:SetFrameLevel(parent:GetFrameLevel() + 1)
	f2:SetWidth(parent:GetWidth())
	f2:SetHeight(parent:GetHeight())
	if overlay == true then
		f2:SetFrameStrata("DIALOG")
	else
		f2:SetFrameStrata("BACKGROUND")
	end
	f2:SetPoint("CENTER", f, "CENTER")
--	f2:SetTemplate("Default", true)
	E.EuiSetTemplate(f2)
	f2:RegisterForDrag("LeftButton", "RightButton")
	f2:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
		self:StartMoving() 
	end)
	
	f2:SetScript("OnDragStop", function(self) 
		if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
		self:StopMovingOrSizing()
	
		E.Movers[name]["moved"] = true
		local p, _, p2, p3, p4 = self:GetPoint()
		E.Movers[name]["p"] = p
		E.Movers[name]["p2"] = p2
		E.Movers[name]["p3"] = p3
		E.Movers[name]["p4"] = p4
		
		if postdrag ~= nil and type(postdrag) == 'function' then
			postdrag(self)
		end
	end)	
	
	parent:ClearAllPoints()
	parent:SetPoint(p3, f2, p3, 0, 0)
	parent.ClearAllPoints = E.dummy
	parent.SetAllPoints = E.dummy
	parent.SetPoint = E.dummy
	
	if E.Movers[name]["moved"] == true then
		f:ClearAllPoints()
		f:SetPoint(E.Movers[name]["p"], UIParent, E.Movers[name]["p3"], E.Movers[name]["p4"], E.Movers[name]["p5"])
	end
	
	local fs = f2:CreateFontString(nil, "OVERLAY")
	fs:SetFont(E.font, 11, "THINOUTLINE")
	fs:SetShadowOffset(E.mult*1.2, -E.mult*1.2)
	fs:SetJustifyH("CENTER")
	fs:SetPoint("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(23/255,132/255,209/255)
	f2:SetFontString(fs)
	f2.text = fs
	
	f2:SetScript("OnEnter", function(self) 
		self.text:SetTextColor(1, 1, 1)
		self:SetBackdropBorderColor(23/255,132/255,209/255)
	end)
	f2:SetScript("OnLeave", function(self)
		self.text:SetTextColor(23/255,132/255,209/255)
	--	self:SetTemplate("Default", true)
		E.EuiSetTemplate(self)
	end)
	
	f2:SetMovable(true)
	f2:Hide()	
	
	if postdrag ~= nil and type(postdrag) == 'function' then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self, event)
			postdrag(f2)
			self:UnregisterAllEvents()
		end)
	end	
end

function E.CreateMover(parent, name, text, overlay, postdrag)
	local p, p2, p3, p4, p5 = parent:GetPoint()

	if E.CreatedMovers[name] == nil then 
		E.CreatedMovers[name] = {}
		E.CreatedMovers[name]["parent"] = parent
		E.CreatedMovers[name]["text"] = text
		E.CreatedMovers[name]["overlay"] = overlay
		E.CreatedMovers[name]["postdrag"] = postdrag
		E.CreatedMovers[name]["p"] = p
		E.CreatedMovers[name]["p2"] = p2 or "UIParent"
		E.CreatedMovers[name]["p3"] = p3
		E.CreatedMovers[name]["p4"] = p4
		E.CreatedMovers[name]["p5"] = p5
	end	
	
	--Post Variables Loaded..
	if EuiData ~= nil then
		CreateMover(parent, name, text, overlay, postdrag)
	end
end

function E.ToggleMovers()
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	for name, _ in pairs(E.CreatedMovers) do
		if _G[name]:IsShown() then
			_G[name]:Hide()
		else
			_G[name]:Show()
		end
	end
end

function E.ResetMovers(arg)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	if arg == "" then
		for name, _ in pairs(E.CreatedMovers) do
			local n = _G[name]
			_G[name]:ClearAllPoints()
			_G[name]:SetPoint(E.CreatedMovers[name]["p"], E.CreatedMovers[name]["p2"], E.CreatedMovers[name]["p3"], E.CreatedMovers[name]["p4"], E.CreatedMovers[name]["p5"])
			
			E.Movers[name]["moved"] = false 
			
			E.Movers[name]["p"] = nil
			E.Movers[name]["p2"] = nil
			E.Movers[name]["p3"] = nil
			E.Movers[name]["p4"] = nil	
			
			for key, value in pairs(E.CreatedMovers[name]) do
				if key == "postdrag" and type(value) == 'function' then
					value(n)
				end
			end
		end	
	else
		for name, _ in pairs(E.CreatedMovers) do
			for key, value in pairs(E.CreatedMovers[name]) do
				local mover
				if key == "text" then
					if arg == value then 
						_G[name]:ClearAllPoints()
						_G[name]:SetPoint(E.CreatedMovers[name]["p"], E.CreatedMovers[name]["p2"], E.CreatedMovers[name]["p3"], E.CreatedMovers[name]["p4"], E.CreatedMovers[name]["p5"])						
						
						E.Movers[name]["moved"] = false 
						
						E.Movers[name]["p"] = nil
						E.Movers[name]["p2"] = nil
						E.Movers[name]["p3"] = nil
						E.Movers[name]["p4"] = nil	

						if E.CreatedMovers[name]["postdrag"] ~= nil and type(E.CreatedMovers[name]["postdrag"]) == 'function' then
							E.CreatedMovers[name]["postdrag"](_G[name])
						end
					end
				end
			end	
		end
	end
end

local function SetMoverButtonScript()
	--Toggle UI lock button
	EuiInfoLeftRButton:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
			
		E.ToggleMovers()
		
		if C["actionbar"].enable == true then
			E.ToggleABLock()
		end

		if EuiUF or oUF then
			E.MoveUF()
		end	
		
		if C["threat"].enable == true then
			E.ThreatShow()
		end
		
		if C["info"].apsp ~= 0 then
			E.EuiInfoDPSShow()
		end

		if C["info"].dps ~= 0 then
			E.EuiInfoAPSPShow()
		end
		
		if EuiInfoLeftRButton.hovered == true then
			local locked = false
			GameTooltip:ClearLines()
			for name, _ in pairs(E.CreatedMovers) do
				if _G[name]:IsShown() then
					locked = true
				else
					locked = false
				end
			end	
			
			if locked ~= true then
				--GameTooltip:AddLine(UNLOCK.." "..BUG_CATEGORY5,1,1,1)
			--else
				--GameTooltip:AddLine(LOCK.." "..BUG_CATEGORY5,23/255,132/255,209/255)
			end
		end
		GameTooltip:Show()
	end)
	
	EuiInfoLeftRButton:SetScript("OnEnter", function(self)
		EuiInfoLeftRButton.hovered = true
		if InCombatLockdown() then return end
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, E.Scale(6));
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, E.mult)
		GameTooltip:ClearLines()
		
		local locked = false
		for name, _ in pairs(E.CreatedMovers) do
			if _G[name]:IsShown() then
				locked = true
				break
			else
				locked = false
			end
		end	
		
		if locked ~= true then
			--GameTooltip:AddLine(UNLOCK.." "..BUG_CATEGORY5,1,1,1)
		--else
			--GameTooltip:AddLine(LOCK.." "..BUG_CATEGORY5,23/255,132/255,209/255)
		end
		GameTooltip:Show()
	end)

	EuiInfoLeftRButton:SetScript("OnLeave", function(self)
		EuiInfoLeftRButton.hovered = false
		GameTooltip:Hide()
	end)	
end

local loadmovers = CreateFrame("Frame")
loadmovers:RegisterEvent("ADDON_LOADED")
loadmovers:RegisterEvent("PLAYER_REGEN_DISABLED")
loadmovers:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon ~= "Eui" then return end
		for name, _ in pairs(E.CreatedMovers) do
			local n = name
			local p, t, o, pd
			for key, value in pairs(E.CreatedMovers[name]) do
				if key == "parent" then
					p = value
				elseif key == "text" then
					t = value
				elseif key == "overlay" then
					o = value
				elseif key == "postdrag" then
					pd = value
				end
			end
			CreateMover(p, n, t, o, pd)
		end
		
		SetMoverButtonScript()
		self:UnregisterEvent("ADDON_LOADED")
	else
		local err = false
		for name, _ in pairs(E.CreatedMovers) do
			if _G[name]:IsShown() then
				err = true
				_G[name]:Hide()
			end
		end
			if err == true then
				print(ERR_NOT_IN_COMBAT)			
			end		
	end
end)