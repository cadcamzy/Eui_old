local E, C, L, DB = unpack(EUI)
if C["skins"].skada ~= true then return end

local SkadaSkin = CreateFrame("Frame")
SkadaSkin:RegisterEvent("PLAYER_LOGIN")
SkadaSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skada") then
		local TEXTURE = C["skins"].texture
		local function StripOptions(options)
			options.baroptions.args.bartexture = nil
			options.baroptions.args.barspacing = nil
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
			options.windowoptions = nil
			options.baroptions.args.barfont = nil
			options.titleoptions.args.font = nil
		end

		-- Hook the bar mod
		local barmod = Skada.displays["bar"]
			-- Strip options
			barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
			barmod.AddDisplayOptions = function(self, win, options)
			self:AddDisplayOptions_(win, options)
			StripOptions(options)
		end
		for k, options in pairs(Skada.options.args.windows.args) do
			if options.type == "group" then
				StripOptions(options.args)
			end
		end

		-- Override settings from in-game GUI
		local titleBG = {
			bgFile = E.blank,
			tile = false,
			tileSize = 1
		}		
		
		-- Override settings from in-game GUI
		barmod.ApplySettings_ = barmod.ApplySettings
		barmod.ApplySettings = function(self, win)
		   win.db.enablebackground = true
			win.db.background.borderthickness = 12
			barmod:ApplySettings_(win)
		--	layout:PositionSkadaWindow(win)
			if win.db.enabletitle then
				win.bargroup.button:SetBackdrop(titleBG)
			end
			win.bargroup:SetTexture(TEXTURE)
			win.bargroup:SetSpacing(2)
		--	win.bargroup:SetFont(config.font,config.fontSize, config.fontFlags)
			local titlefont = CreateFont("TitleFont"..win.db.name)
		--	titlefont:SetFont(config.font,config.fontSize, config.fontFlags)
			win.bargroup.button:SetNormalFontObject(titlefont)
			local color = win.db.title.color
			win.bargroup.button:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
		--	skin:SkinBackgroundFrame(win.bargroup)
			win.bargroup:SortBars()
			win.bargroup:SetBackdrop(titleBG)
			
		end

		-- Override bar style
		barmod.Update_ = barmod.Update
		barmod.Update = function(self, win)
		barmod:Update_(win)
		local nr = 1
		for i, data in ipairs(win.dataset) do
			if data.id then
				local barid = data.id
				local barlabel = data.label      
				local bar = win.bargroup:GetBar(barid)
					if bar then
						E.EuiSetTemplate(bar)
						bar:SetTexture(TEXTURE)
					end
				end
			end
		end
		
		-- Update pre-existing displays
		for k, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
		end

	end
end)

local xpoint
--if C["actionbar"].longstyle == true then
	xpoint = (C["actionbar"].buttonsize * 9) + (C["actionbar"].buttonspacing * 12)
--else
--	xpoint = (C["actionbar"].buttonsize * 6) + (C["actionbar"].buttonspacing * 9)
--end

----------------------------------------------------------------------------------------
--	Skada settings(by Spark)
----------------------------------------------------------------------------------------
local function EuiUploadSkada()
	if (SkadaDB) then table.wipe(SkadaDB) end
	SkadaDB = {
		["profiles"] = {
			["Default"] = {
				["modules"] = {
					["notankwarnings"] = true,
				},
				["hidepvp"] = true,
				["onlykeepbosses"] = true,
				["windows"] = {
					{
						["point"] = "BOTTOM", 
						["barmax"] = 6,
						["scale"] = 1,
						["x"] = xpoint+108, 
						["y"] = 96, 
						["title"] = {
							["fontsize"] = 11,
							["borderthickness"] = 2,
							["texture"] = "Armory",
							["bordertexture"] = "Armory",	
						},
						["barheight"] = 16,
						["spark"] = false,
						["enabletitle"] = true,
						["barwidth"] = 200,
						["barspacing"] = 3, 
						["barfontsize"] = 11,
						["bartexture"] = "",
						["barcolor"] = {
							["a"] = 0.7,
							["b"] = 0.63,
							["g"] = 0.45,
							["r"] = 0.31,
						},
					}, -- [1]
				},
				["tooltippos"] = "topright",
				["icon"] = {
					["hide"] = true,
				},
				["showranks"] = false,
			},
		},
	}

	if LjxxuiInstallV401 == true then
	end
	SkadaDB.InstalledBars = LjxxuiInstallV401
end

StaticPopupDialogs["SETTINGS_SKADA"] = {
	text = "设置Skada皮肤",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() EuiUploadSkada() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

----------------------------------------------------------------------------------------
--	On logon function
----------------------------------------------------------------------------------------
local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if IsAddOnLoaded("Skada") then
		if SkadaDB.InstalledBars ~= LjxxuiInstallV401 then
			StaticPopup_Show("SETTINGS_SKADA")
		end
	end
end)
