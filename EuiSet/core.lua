local EuiConfig = LibStub("AceAddon-3.0"):NewAddon("EuiConfig", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EuiConfig", false)
local LSM = LibStub("LibSharedMedia-3.0")
local db
local defaults
local DEFAULT_WIDTH = 815
local DEFAULT_HEIGHT = 555
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

function EuiConfig:LoadDefaults()
	local E, _, _, DB = unpack(EUI)
	--Defaults
	defaults = {
		profile = {
			main = DB["main"],
			ui = DB["ui"],
			other = DB["other"],
			nameplate = DB["nameplate"],
			chat = DB["chat"],
			filter = DB["filter"],
			unitframe = DB["unitframe"],
			raid = DB["raid"],
			actionbar = DB["actionbar"],
			tooltip = DB["tooltip"],
			threat = DB["threat"],
			info = DB["info"],
			clickset = DB["clickset"], 
			skins = DB["skins"],
			class = DB["class"],
			nameplate = DB["nameplate"],
		},
	}
end	

function EuiConfig:OnInitialize()	
	EuiConfig:RegisterChatCommand("cfg", "ShowConfig")
	EuiConfig:RegisterChatCommand("eui", "ShowConfig")
	
	self.OnInitialize = nil
end

function EuiConfig:ShowConfig() 
	ACD[ACD.OpenFrames.EuiConfig and "Close" or "Open"](ACD,"EuiConfig") 
end

function EuiConfig:Load()
	self:LoadDefaults()

	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("EuiConfig", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	
	self:SetupOptions()
end

function EuiConfig:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("CFG_RELOAD")
end


function EuiConfig:SetupOptions()
	AC:RegisterOptionsTable("EuiConfig", self.GenerateOptions)
	ACD:SetDefaultSize("EuiConfig", DEFAULT_WIDTH, DEFAULT_HEIGHT)

	--Create Profiles Table
	self.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	AC:RegisterOptionsTable("EuiProfiles", self.profile)
	self.profile.order = -10
	
	self.SetupOptions = nil
end

function EuiConfig.GenerateOptions()
	if EuiConfig.noconfig then assert(false, EuiConfig.noconfig) end
	if not EuiConfig.Options then
		EuiConfig.GenerateOptionsInternal()
		EuiConfig.GenerateOptionsInternal = nil
	end
	return EuiConfig.Options
end

function EuiConfig.GenerateOptionsInternal()
	local E, C, _, DB = unpack(EUI)

	StaticPopupDialogs["CFG_RELOAD"] = {
		text = L["CFG_RELOAD"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}
	
	EuiConfig.Options = {
		type = "group",
		name = "Eui".." "..GetAddOnMetadata("Eui", "Version"),
		args = {
			Eui_Header = {
				order = 1,
				type = "header",
				name = GetAddOnMetadata("EuiSet", "Version"),
				width = "full",		
			},
			main = {
				order = 2,
				type = "group",
				name = L["main"],
				desc = L["main"],
				get = function(info) return db.main[ info[#info] ] end,
				set = function(info, value) db.main[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					autoinvite = {
						order = 1,
						type = "toggle",
						name = L["main_autoinvite"],
					},
					invitetext = {
						order = 2,
						name = L["main_invitetext"],
					--	desc = L["main_invitetext_desc"],
						type = "input",
					--	get = function(info) return C["invitetext"] end,
					--	set = function(info, value)
					--			C["invitetext"] = value
					},					
					noerrors = {
						order = 3,
						name = L["main_noerrors"],
					--	desc = L["main_noerrors_desc"],
						type = "toggle",
					},
					noerrorsincombat = {
						order = 4,
						name = L["main_noerrorsincombat"],
					--	desc = L["main_noerrorsincombat_desc"],
						type = "toggle",
					},
					moveuierrors = {
						order = 5,
						name = L["main_moveuierrors"],
					--	desc = L["main_moveuierrors_desc"],
						type = "toggle",
					},
					ignoreduel = {
						order = 6,
						name = L["main_ignoreduel"],
					--	desc = L["main_ignoreduel_desc"],
						type = "toggle",
					},
					autoroll = {
						order = 7,
						name = L["main_autoroll"],
					--	desc = L["main_autoroll_desc"],
						type = "toggle",
					},
					disableconfirm = {
						order = 8,
						name = L["main_disableconfirm"],
					--	desc = L["main_disableconfirm_desc"],
						type = "toggle",
					},
					autoloot = {
						order = 9,
						type = "toggle",
						name = L["main_autoloot"],
					--	desc = L["main_autoloot_desc"],	
					},
					autorepair = {
						order = 10,
						type = "toggle",
						name = L["main_autorepair"],
					--	desc = L["main_autorepair_desc"],
					},
					autorepairguild = {
						order = 11,
						type = "toggle",
						name = L["main_autorepairguild"],
					--	desc = L["main_autorepairguild_desc"],					
					},
					sellgreycrap = {
						order = 12,
						type = "toggle",
						name = L["main_sellgreycrap"],
					--	desc = L["main_sellgreycrap_desc"],					
					},
					acceptinvites = {
						order = 13,
						type = "toggle",
						name = L["main_acceptinvites"],
					--	desc = L["main_acceptinvites_desc"],					
					},
					buystack = {
						order = 14,
						type = "toggle",
						name = L["main_buystack"],
					--	desc = L["main_bugstack_desc"],					
					},
					alttotrade = {
						order = 15,
						type = "toggle",
						name = L["main_alttotrade"],
					--	desc = L["main_alttotrade_desc"],					
					},
					talentspam = {
						order = 16,
						type = "toggle",
						name = L["main_talentspam"],
					--	desc = L["main_talentspam_desc"],					
					},
					questauto = {
						order = 17,
						type = "toggle",
						name = L["main_questauto"],
					--	desc = L["main_questauto_desc"],					
					},
					questicons = {
						order = 18,
						type = "toggle",
						name = L["main_questicons"],
					--	desc = L["main_questicons_desc"],					
					},
					autorez = {
						order = 19,
						type = "toggle",
						name = L["main_autorez"],
					--	desc = L["main_autorez_desc"],					
					},
					combatnoti = {
						order = 20,
						type = "toggle",
						name = L["main_combatnoti"],
					--	desc = L["main_combatnoti_desc"],					
					},
					lockquest = {
						order = 21,
						type = "toggle",
						name = L["main_lockquest"],
					--	desc = L["main_lockquest_desc"],					
					},
					alpha = {
						order = 22,
						type = "toggle",
						name = L["main_alpha"],
					--	desc = L["main_alpha_desc"],					
					},
					classcolortheme = {
						order = 23,
						type = "toggle",
						name = L["main_classcolortheme"],
					--	desc = L["main_classcolortheme_desc"],					
					},
					classcolorcustom = {
						type = "color",
						order = 24,
						name = L["main_classcolorcustom"],
					--	desc = L["main_classcolorcustom"],
						disabled = function() return not db.main.classcolortheme end,
						hasAlpha = false,
						get = function(info)
							local t = db.main[ info[#info] ]
							return t.r, t.g, t.b, t.a
						end,
						set = function(info, r, g, b)
							db.main[ info[#info] ] = {}
							local t = db.main[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							StaticPopup_Show("CFG_RELOAD")
						end,				
					},
				},
			},
			ui = {
				order = 1,
				type = "group",
				name = L["ui"],
				desc = L["ui"],
				get = function(info) return db.ui[ info[#info] ] end,
				set = function(info, value) db.ui[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					autoscale = {
						order = 1,
						type = "toggle",
						name = L["ui_autoscale"],
					},
					uiscale = {
						order = 2,
						name = L["ui_uiscale"],
						disabled = function(info) return db.ui.autoscale end,
						type = "range",
						min = 0.64, max = 1, step = 0.01,
					},
					multisampleprotect = {
						order = 3,
						name = L["ui_multisampleprotect"],
						type = "toggle",
					},
				},
			},
			nameplate = {
				order = 3,
				type = "group",
				name = L["nameplate"],
				get = function(info) return db.nameplate[ info[#info] ] end,
				set = function(info, value) db.nameplate[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["nameplate"],
					},				
					enable = {
						type = "toggle",
						order = 2,
						name = ENABLE,
						desc = L["nameplate_enable"],
						set = function(info, value)
							db.nameplate[ info[#info] ] = value; 
							StaticPopup_Show("CFG_RELOAD")
						end,
					},
					group1 = {
						type = "group",
						order = 3,
						name = L["nameplate_group1"],
						guiInline = true,		
						disabled = function() return not db.nameplate.enable end,
						args = {
							showhealth = {
								type = "toggle",
								order = 1,
								name = L["nameplate_showhealth"],
							},
							enhancethreat = {
								type = "toggle",
								order = 2,
								name = L["nameplate_enhancethreat"],
							},
							combat = {
								type = "toggle",
								order = 3,
								name = L["nameplate_combat"],
							},
							trackauras = {
								type = "toggle",
								order = 4,
								name = L["nameplate_trackauras"],
							},
							trackccauras = {
								type = "toggle",
								order = 5,
								name = L["nameplate_trackccauras"],				
							},
							width = {
								type = "range",
								order = 6,
								name = L["nameplate_width"],
								type = "range",
								min = 50, max = 150, step = 1,		
								set = function(info, value) db.nameplate[ info[#info] ] = value; C.nameplate[ info[#info] ] = value end,
							},
							showlevel = {
								type = "toggle",
								order = 7,
								name = L["nameplate_showlevel"],
							},
							Colors = {
								type = "group",
								order = 8,
								name = L["nameplate_Colors"],
								guiInline = true,	
								get = function(info)
									local t = db.nameplate[ info[#info] ]
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b)
									db.nameplate[ info[#info] ] = {}
									local t = db.nameplate[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									StaticPopup_Show("CFG_RELOAD")
								end,	
								disabled = function() return (not db.nameplate.enhancethreat or not db.nameplate.enable) end,								
								args = {
									goodcolor = {
										type = "color",
										order = 1,
										name = L["nameplate_goodcolor"],
										hasAlpha = false,
									},		
									badcolor = {
										type = "color",
										order = 2,
										name = L["nameplate_badcolor"],
										hasAlpha = false,
									},
									goodtransitioncolor = {
										type = "color",
										order = 3,
										name = L["nameplate_goodtransitioncolor"],
										hasAlpha = false,									
									},
									badtransitioncolor = {
										type = "color",
										order = 4,
										name = L["nameplate_badtransitioncolor"],
										hasAlpha = false,									
									},									
								},
							},
						},
					},
				},
			},
			other = {
				order = 15,
				type = "group",
				name = L["other"],
				desc = L["other"],
				get = function(info) return db.other[ info[#info] ] end,
				set = function(info, value) db.other[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					mail = {
						order = 5,
						type = "toggle",
						name = L["other_mail"],
					},
					cooldown = {
						order = 6,
						type = "toggle",
						name = L["other_cooldown"],
					},
					tab = {
						order = 7,
						type = "toggle",
						name = L["other_tab"],
					},
					loot = {
						order = 8,
						type = "toggle",
						name = L["other_loot"],
					},
					recipients = {
						order = 9,
						type = "toggle",
						name = L["other_recipients"],
					},
					sr = {
						order = 10,
						type = "toggle",
						name = L["other_sr"],
					},
					focuser = {
						order = 11,
						type = "toggle",
						name = L["other_focuser"],
					},
					ratings = {
						order = 12,
						type = "toggle",
						name = L["other_ratings"],
					},
					hb = {
						order = 13,
						type = "toggle",
						name = L["other_hb"],
					},
					spellid = {
						order = 14,
						type = "toggle",
						name = L["other_spellid"],
					},
					mbb = {
						order = 15,
						type = "toggle",
						name = L["other_mbb"],
					},
					minimap = {
						order = 16,
						type = "toggle",
						name = L["other_minimap"],
					},
					buff = {
						order = 17,
						type = "toggle",
						name = L["other_buff"],
					},
--[[ 					xct = {
						order = 18,
						type = "toggle",
						name = L["other_xct"],
					}, ]]
					raidcheck = {
						order = 19,
						type = "toggle",
						name = L["other_raidcheck"],
					},
					raidbuffreminder = {
						order = 20,
						type = "toggle",
						name = L["other_raidbuffreminder"],
					},
					bossnotes = {
						order = 21,
						type = "toggle",
						name = L["other_bossnotes"],
					},
				},
			},
			chat = {
				order = 4,
				type = "group",
				name = L["chat"],
				desc = L["chat"],
				get = function(info) return db.chat[ info[#info] ] end,
				set = function(info, value) db.chat[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["chat_enable"],
					},
					chat_group1 = {
						order = 2,
						type = "group",
						name = L["chat_group1"],
						disabled = function() return not db.chat.enable end,
						guiInline = true,
						args = {
							chatw = {
								order =3,
								name = L["chat_chatw"],
								type = "range",
								min = 100, max = 1000, step = 1,
							},
							chath = {
								order = 4,
								name = L["chat_chath"],
								type = "range",
								min = 100, max = 1000, step = 1,
							},
						},
					},
					chat_group2 = {
						order = 3,
						type = "group",
						name = L["chat_group2"],
						disabled = function() return not db.chat.enable end,
						guiInline = true,
						args = {
							hidejunk = {
								order = 2,
								name = L["chat_hidejunk"],
								type = "toggle",
							},
							chatbar = {
								order = 5,
								name = L["chat_chatbar"],
								type = "toggle",
							},
							chatguard = {
								order = 6,
								name = L["chat_chatguard"],
								type = "toggle",
							},
							LFW = {
								order = 7,
								name = L["chat_LFW"],
								type = "toggle",
							},
							bodylevel = {
								order = 8,
								name = L["chat_bodylevel"],
								type = "range",
								min = 1, max = 85, step = 1,
							},
						},
					},
				},
			},
			filter = {
				order = 5,
				type = "group",
				name = L["filter"],
				desc = L["filter"],
				get = function(info) return db.filter[ info[#info] ] end,
				set = function(info, value) db.filter[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					filter_group1 = {
						order = 1,
						type = "group",
						name = L["filter_group1"],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["filter_enable"],
							},
							classcolor = {
								order = 2,
								name = L["filter_classcolor"],
								disabled = function(info) return not db.filter.enable end,
								type = "toggle",
							},
							float = {
								order = 3,
								name = L["filter_float"],
								disabled = function(info) return not db.other.cooldown end,
								type = "toggle",
							},	
							barheight = {
								order = 2,
								name = L["filter_classcolor"],
								disabled = function(info) return not db.filter.enable end,
								type = "toggle",
							},
							cdsize = {
								order = 2,
								name = L["filter_cdsize"],
								disabled = function(info) return not db.filter.enable end,
								type = "range",
								min = 1, max = 100, step = 1,
							},							
						},
					},		
					filter_group2 = {
						order = 2,
						type = "group",
						name = L["filter_group2"],
						guiInline = true,
						args = {
							raid = {
								order = 1,
								name = L["filter_raid"],
								type = "toggle",
							},
							raidwidth = {
								order = 2,
								name = L["filter_raidwidth"],
								disabled = function(info) return not db.filter.raid end,
								type = "range",
								min = 1, max = 100, step = 1,
							},	
							raidheight = {
								order = 3,
								name = L["filter_raidheight"],
								disabled = function(info) return not db.filter.raid end,
								type = "range",
								min = 1, max = 100, step = 1,
							},
							raidnumber = {
								order = 4,
								name = L["filter_raidnumber"],
								disabled = function(info) return not db.filter.raid end,
								type = "range",
								min = 1, max = 100, step = 1,
							},
						},
					},	
					filter_group3 = {
						order = 3,
						type = "group",
						name = L["filter_group3"],
						guiInline = true,
						args = {
							coolline = {
								order = 2,
								name = L["filter_coolline"],
								type = "toggle",
							},
							coollinew = {
								order = 2,
								name = L["filter_classcolor"],
								disabled = function(info) return not db.filter.coolline end,
								type = "range",
								min = 10, max = 1000, step = 1,
							},
							coollineh = {
								order = 2,
								name = L["filter_classcolor"],
								disabled = function(info) return not db.filter.coolline end,
								type = "range",
								min = 1, max = 100, step = 1,
							},						
						},
					},
					filter_group4 = {
						order = 4,
						type = "group",
						name = L["filter_group4"],
						disabled = function() return not db.filter.enable end,
						guiInline = true,
						args = {
							pbuffbar = {
								order = 2,
								name = L["filter_pbuffbar"],
								type = "toggle",
							},						
							piconsize = {
								order = 2,
								name = L["filter_piconsize"],
								type = "range",
								min = 1, max = 100, step = 1,
							},
							pbufficon = {
								order = 2,
								name = L["filter_pbufficon"],
								type = "toggle",
							},
							pcdicon = {
								order = 2,
								name = L["filter_pcdicon"],
								type = "toggle",
							},
							pdebufficon = {
								order = 2,
								name = L["filter_pdebufficon"],
								type = "toggle",
							},
						},
					},
					filter_group5 = {
						order = 5,
						type = "group",
						name = L["filter_group5"],
						disabled = function() return not db.filter.enable end,
						guiInline = true,
						args = {
							tdebuffbar = {
								order = 2,
								name = L["filter_tdebuffbar"],
								type = "toggle",
							},						
							ticonsize = {
								order = 2,
								name = L["filter_ticonsize"],
								type = "range",
								min = 1, max = 100, step = 1,
							},
							tbufficon = {
								order = 2,
								name = L["filter_tbufficon"],
								type = "toggle",
							},
							tdebufficon = {
								order = 2,
								name = L["filter_tdebufficon"],
								type = "toggle",
							},					
						},
					},
					filter_group6 = {
						order = 6,
						type = "group",
						name = L["filter_group6"],
						disabled = function() return not db.filter.enable end,
						guiInline = true,
						args = {
							fbufficon = {
								order = 1,
								name = L["filter_fbufficon"],
								type = "toggle",
							},
							fdebufficon = {
								order = 2,
								name = L["filter_fdebufficon"],
								type = "toggle",
							},
							ficonsize = {
								order = 3,
								name = L["filter_ficonsize"],
								disabled = function(info) return not db.filter.fbufficon end,
								type = "range",
								min = 1, max = 100, step = 1,
							},							
						},
					},					
				},
			},
			unitframe = {
				order = 6,
				type = "group",
				name = L["unitframe"],
				desc = L["unitframe"],
				get = function(info) return db.unitframe[ info[#info] ] end,
				set = function(info, value) db.unitframe[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					aaaaunit = {
						order = 1,
						name = L["unitframe_aaaaunit"],
						type = "range",
						min = 0, max = 3, step = 1,
					},
					unitframe_group1 = {
						order = 2,
						type = "group",
						name = L["unitframe_group1"],
						guiInline = true,
						disabled = function() return (db.unitframe.aaaaunit == 0) end,
						args = {
							castbar = {
								order = 1,
								type = "toggle",
								name = L["unitframe_castbar"],
							},
							swing = {
								order = 2,
								type = "toggle",
								name = L["unitframe_swing"],
							},

							colorClass = {
								order = 4,
								type = "toggle",
								name = L["unitframe_colorClass"],
							},
		

							portrait = {
								order = 10,
								type = "toggle",
								name = L["unitframe_portrait"],
							},
							showPvP = {
								order = 11,
								type = "toggle",
								name = L["unitframe_showPvP"],
							},
							onlyplayer = {
								order = 12,
								type = "toggle",
								name = L["unitframe_onlyplayer"],
							},
							powerspark = {
								order = 13,
								type = "toggle",
								name = L["unitframe_powerspark"],
							},
								
							colorClassName = {
								order = 22,
								type = "toggle",
								name = L["unitframe_colorClassName"],
							},
							totalhpmp = {
								order = 23,
								type = "toggle",
								name = L["unitframe_totalhpmp"],
							},
							cpoint = {
								order = 24,
								type = "toggle",
								name = L["unitframe_cpoint"],
							},
							bigcastbar = {
								order = 25,
								type = "toggle",
								name = L["unitframe_bigcastbar"],
							},
							bigcastbarscale = {
								order = 26,
								type = "range",
								name = L["unitframe_bigcastbarscale"],
								disabled = function() return not db.unitframe.bigcastbar end,
								min = 0.1, max = 10, step = 0.1,
							},
							showpprec = {
								order = 27,
								type = "toggle",
								name = L["unitframe_showpprec"],
							},
							boss = {
								order = 28,
								type = "toggle",
								name = L["unitframe_boss"],
							},							
						},
					},
					unitframe_group2 = {
						order = 3,
						type = "group",
						name = L["unitframe_group2"],
						guiInline = true,
						disabled = function() return (db.unitframe.aaaaunit == 0) end,
						args = {
							totdebuffs = {
								order = 3,
								type = "range",
								name = L["unitframe_totdebuffs"],
								min = 0, max = 42, step = 1,
							},						
							Fbuffs = {
								order = 5,
								type = "range",
								name = L["unitframe_Fbuffs"],
								min = 0, max = 40, step = 1,
							},
							Fdebuffs = {
								order = 6,
								type = "range",
								name = L["unitframe_Fdebuffs"],
								min = 0, max = 40, step = 1,
							},
							targetbuffs = {
								order = 7,
								type = "range",
								name = L["unitframe_targetbuffs"],
								min = 0, max = 40, step = 1,
							},
							targetdebuffs = {
								order = 8,
								type = "range",
								name = L["unitframe_targetdebuffs"],
								min = 0, max = 40, step = 1,
							},
							playerdebuffnum = {
								order = 9,
								type = "range",
								name = L["unitframe_playerdebuffnum"],
								min = 0, max = 40, step = 1,
							},							
						},
					},
					unitframe_group3 = {
						order = 4,
						type = "group",
						name = L["unitframe_group3"],
						guiInline = true,
						disabled = function() return (db.unitframe.aaaaunit == 0) end,
						args = {
							playerwidth = {
								order = 14,
								type = "range",
								name = L["unitframe_playerwidth"],
								min = 50, max = 500, step = 2,
							},
							playerheight = {
								order = 15,
								type = "range",
								name = L["unitframe_playerheight"],
								min = 10, max = 500, step = 2,
							},	
							petwidth = {
								order = 16,
								type = "range",
								name = L["unitframe_petwidth"],
								min = 50, max = 500, step = 2,
							},
							petheight = {
								order = 17,
								type = "range",
								name = L["unitframe_petheight"],
								min = 10, max = 500, step = 2,
							},	
							totwidth = {
								order = 18,
								type = "range",
								name = L["unitframe_totwidth"],
								min = 50, max = 500, step = 2,
							},
							totheight = {
								order = 19,
								type = "range",
								name = L["unitframe_totheight"],
								min = 10, max = 500, step = 2,
							},	
							focuswidth = {
								order = 20,
								type = "range",
								name = L["unitframe_focuswidth"],
								min = 50, max = 500, step = 2,
							},
							focusheight = {
								order = 21,
								type = "range",
								name = L["unitframe_focusheight"],
								min = 10, max = 500, step = 2,
							},
						},
					},
				},
			},
			raid = {
				order = 7,
				type = "group",
				name = L["raid"],
				desc = L["raid"],
				get = function(info) return db.raid[ info[#info] ] end,
				set = function(info, value) db.raid[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					raid = {
						order = 1,
						type = "toggle",
						name = L["raid"],
					},
					raid_group1 = {
						order = 2,
						type = "group",
						name = L["raid_group1"],
						guiInline = true,
						disabled = function() return not db.raid.raid end,
						args = {
							astyle = {
								order = 1,
								name = L["raid_astyle"],
								type = "range",
								min = 0, max = 2, step = 1,
							},
							raidthreat = {
								order = 2,
								name = L["raid_raidthreat"],
								type = "toggle",
							},
							raidaurawatch = {
								order = 3,
								name = L["raid_raidaurawatch"],
								type = "toggle",
							},
							gridhealthvettical = {
								order = 4,
								name = L["raid_gridhealthvettical"],
								type = "toggle",
							},
							raidDirection = {
								order = 5,
								name = L["raid_raidDirection"],
								type = "toggle",
							},
							raidColorClass = {
								order = 6,
								name = L["raid_raidColorClass"],
								type = "toggle",
							},
							grouphv = {
								order = 7,
								name = L["raid_grouphv"],
								type = "toggle",
							},
							raidgroups = {
								order = 8,
								name = L["raid_raidgroups"],
								type = "range",
								min = 1, max = 8, step = 1,
							},
							groupspace = {
								order = 9,
								name = L["raid_groupspace"],
								type = "range",
								min = 0, max = 100, step = 1,
							},
							gridheight = {
								order = 10,
								name = L["raid_gridheight"],
								type = "range",
								min = 10, max = 1000, step = 10,
							},
							nogridheight = {
								order = 11,
								name = L["raid_nogridheight"],
								type = "range",
								min = 10, max = 1000, step = 10,
							},
							gridh = {
								order = 12,
								name = L["raid_gridh"],
								type = "range",
								min = 10, max = 200, step = 1,
							},
							gridw = {
								order = 13,
								name = L["raid_gridw"],
								type = "range",
								min = 10, max = 200, step = 1,
							},
							nogridh = {
								order = 14,
								name = L["raid_nogridh"],
								type = "range",
								min = 10, max = 200, step = 1,
							},
							nogridw = {
								order = 15,
								name = L["raid_nogridw"],
								type = "range",
								min = 10, max = 200, step = 1,
							},							
							clickset = {
								order = 16,
								name = L["raid_clickset"],
								type = "toggle",
							},
							hottime = {
								order = 17,
								name = L["raid_hottime"],
								type = "toggle",
							},
							showParty = {
								order = 18,
								name = L["raid_showParty"],
								type = "toggle",
							},
							showPartyTarget = {
								order = 19,
								name = L["raid_showPartyTarget"],
								type = "toggle",
								disabled = function() return not db.raid.showParty end,
							},	
							mt = {
								order = 21,
								name = L["raid_mt"],
								type = "toggle",
							},
							portrait = {
								order = 22,
								name = L["raid_portrait"],
								type = "toggle",
							},
							hotsize = {
								order = 23,
								name = L["raid_hotsize"],
								type = "range",
								min = 5, max = 50, step = 1,
							},
						},
					},
					raid_group2 = {
						order = 3,
						type = "group",
						name = L["raid_group2"],
						guiInline = true,
						args = {
							raidtarget = {
								order = 1,
								name = L["raid_raidtarget"],
								type = "toggle",
							},							
							raidtool = {
								order = 2,
								name = L["raid_raidtool"],
								type = "toggle",
							},
						},
					},	
				},
			},
			actionbar = {
				order = 8,
				type = "group",
				name = L["actionbar"],
				desc = L["actionbar"],
				get = function(info) return db.actionbar[ info[#info] ] end,
				set = function(info, value) db.actionbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["actionbar_enable"],
					},
					actionbar_group = {
						order = 2,
						type = "group",
						name = L["actionbar"],
						guiInline = true,
						disabled = function() return not db.actionbar.enable end,
						args = {
							hotkey = {
								order = 1,
								name = L["actionbar_hotkey"],
								type = "toggle",
							},
							rightbarmouseover = {
								order = 1,
								name = L["actionbar_rightbarmouseover"],
								type = "toggle",
							},
							shapeshiftmouseover = {
								order = 1,
								name = L["actionbar_shapeshiftmouseover"],
								type = "toggle",
							},
							hideshapeshift = {
								order = 1,
								name = L["actionbar_hideshapeshift"],
								type = "toggle",
							},
							showgrid = {
								order = 1,
								name = L["actionbar_showgrid"],
								type = "toggle",
							},
							bottompetbar = {
								order = 1,
								name = L["actionbar_bottompetbar"],
								type = "toggle",
							},
							swaptopbottombar = {
								order = 1,
								name = L["actionbar_swaptopbottombar"],
								type = "toggle",
							},
							macrotext = {
								order = 1,
								name = L["actionbar_macrotext"],
								type = "toggle",
							},
							verticalstance = {
								order = 1,
								name = L["actionbar_verticalstance"],
								type = "toggle",
							},
							microbar = {
								order = 1,
								name = L["actionbar_microbar"],
								type = "toggle",
							},
							mousemicro = {
								order = 1,
								name = L["actionbar_mousemicro"],
								type = "toggle",
							},
							buttonsize = {
								order = 1,
								name = L["actionbar_buttonsize"],
								type = "range",
								min = 5, max = 50, step = 1,
							},
							buttonspacing = {
								order = 1,
								name = L["actionbar_buttonspacing"],
								type = "range",
								min = 1, max = 20, step = 1,
							},
							petbuttonsize = {
								order = 1,
								name = L["actionbar_petbuttonsize"],
								type = "range",
								min = 5, max = 50, step = 1,
							},
							petbuttonspacing = {
								order = 1,
								name = L["actionbar_petbuttonspacing"],
								type = "range",
								min = 1, max = 20, step = 1,
							},
						},
					},
							
				},
			},	
			tooltip = {
				order = 9,
				type = "group",
				name = L["tooltip"],
				desc = L["tooltip"],
				get = function(info) return db.tooltip[ info[#info] ] end,
				set = function(info, value) db.tooltip[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["tooltip_enable"],
					},
					tooltip_group = {
						order = 2,
						type = "group",
						name = L["tooltip"],
						guiInline = true,
						disabled = function() return not db.tooltip.enable end,
						args = {
							x = {
								order = 1,
								name = L["tooltip_x"],
								type = "range",
								min = -50, max = 50, step = 1,
							},
							y = {
								order = 2,
								name = L["tooltip_y"],
								type = "range",
								min = -50, max = 50, step = 1,
							},	
							cursor = {
								order = 3,
								type = "toggle",
								name = L["tooltip_cursor"],
							},	
							hideincombat = {
								order = 4,
								type = "toggle",
								name = L["tooltip_hideincombat"],
							},
							hidebuttonscombat = {
								order = 5,
								type = "toggle",
								name = L["tooltip_hidebuttonscombat"],
							},
							ShowTalent = {
								order = 6,
								type = "toggle",
								name = L["tooltip_ShowTalent"],
							},
							TargetedBy = {
								order = 7,
								type = "toggle",
								name = L["tooltip_TargetedBy"],
							},
							hovertip = {
								order = 8,
								type = "toggle",
								name = L["tooltip_hovertip"],
							},
						},
					},
					
				},
			},	
			threat = {
				order = 10,
				type = "group",
				name = L["threat"],
				desc = L["threat"],
				get = function(info) return db.threat[ info[#info] ] end,
				set = function(info, value) db.threat[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["threat_enable"],
					},
					threat_group = {
						type = "group",
						order = 2,
						name = L["threat"],
						guiInline = true,
						disabled = function() return not db.threat.enable end,
						args = {
							width = {
								order = 1,
								name = L["threat_width"],
								type = "range",
								min = 10, max = 500, step = 1,
							},	
							height = {
								order = 2,
								name = L["threat_height"],
								type = "range",
								min = 10, max = 500, step = 1,
							},	
							bars = {
								order = 1,
								name = L["threat_bars"],
								type = "range",
								min = 1, max = 25, step = 1,
							},	
							spacing = {
								order = 1,
								name = L["threat_spacing"],
								type = "range",
								min = 1, max = 20, step = 1,
							},	
							test = {
								order = 1,
								name = L["threat_test"],
								type = "toggle",
							},					
						},
					},		
				},
			},
			info = {
				order = 11,
				type = "group",
				name = L["info"],
				desc = L["info"],
				get = function(info) return db.info[ info[#info] ] end,
				set = function(info, value) db.info[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["info_enable"],
					},
					info_group = {
						type = "group",
						order = 2,
						name = L["info"],
						guiInline = true,
						disabled = function() return not db.info.enable end,
						args = {
							wowtime = {
								order = 1,
								name = L["info_wowtime"],
								type = "range",
								min = 0, max = 9, step = 1,
							},	
							latency = {
								order = 1,
								name = L["info_latency"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							bag = {
								order = 1,
								name = L["info_bag"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							durability = {
								order = 1,
								name = L["info_durability"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							memory = {
								order = 1,
								name = L["info_memory"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							xp = {
								order = 1,
								name = L["info_xp"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							setting = {
								order = 1,
								name = L["info_setting"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							guild = {
								order = 1,
								name = L["info_guild"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							friend = {
								order = 1,
								name = L["info_friend"],
								type = "range",
								min = 0, max = 9, step = 1,
							},
							wgtimenoti = {
								order = 1,
								name = L["info_wgtimenoti"],
								type = "toggle",
							},
							apsp = {
								order = 1,
								name = L["info_apsp"],
								type = "range",
								min = 0, max = 2, step = 1,
							},
							dps = {
								order = 1,
								name = L["info_dps"],
								type = "range",
								min = 0, max = 2, step = 1,
							},							
						},
					},		
				},
			},	
			skins = {
				order = 12,
				type = "group",
				name = L["skins"],
				desc = L["skins"],
				get = function(info) return db.skins[ info[#info] ] end,
				set = function(info, value) db.skins[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					askins = {
						order = 1,
						type = "toggle",
						name = L["skins_askins"],
					},
					skins_group = {
						type = "group",
						order = 2,
						name = L["skins"],
						guiInline = true,
						disabled = function() return not db.skins.askins end,
						args = {
							dbm = {
								order = 1,
								name = L["skins_dbm"],
								type = "toggle",
							},
							skada = {
								order = 2,
								name = L["skins_skada"],
								type = "toggle",
							},
							recount = {
								order = 3,
								name = L["skins_recount"],
								type = "toggle",
							},
							mbb = {
								order = 3,
								name = L["skins_mbb"],
								disabled = true,
								type = "toggle",
							},							
							enable = {
								order = 4,
								name = L["skins_enable"],
								type = "toggle",
							},
							texture = {
								order = 5,
							--	name = L["skins_texture"],
							--	type = "range",
							--	min = 0, max = 9, step = 1,
								type = "select", dialogControl = 'LSM30_Statusbar',
								order = 5,
								name = L["skins_texture"],
								values = AceGUIWidgetLSMlists.statusbar,								
							},
							font = {
								order = 6,
								type = "select", dialogControl = 'LSM30_Font',
								name = L["skins_font"],
								values = AceGUIWidgetLSMlists.font,
							},
							dmgfont = {
								order = 7,
								type = "select", dialogControl = 'LSM30_Font',
								name = L["skins_dmgfont"],
								values = AceGUIWidgetLSMlists.font,
							},
							cdfont = {
								order = 8,
								type = "select", dialogControl = 'LSM30_Font',
								name = L["skins_cdfont"],
								values = AceGUIWidgetLSMlists.font,
							},							
						},
					},		
				},
			},
			class = {
				order = 14,
				type = "group",
				name = L["class"],
				desc = L["class"],
				get = function(info) return db.class[ info[#info] ] end,
				set = function(info, value) db.class[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					dk = {
						order = 1,
						type = "toggle",
						name = L["class_dk"],
						disabled = function() return not db.unitframe.portrait end,
					},
				},
			},
			clickset = {
				order = 13,
				type = "group",
				name = L["Clickset"],
				desc = L["CS_DESC"],
				get = function(info) return db.clickset[ info[#info] ] end,
				set = function(info, value) db.clickset[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,		
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["CS_DESC"],
					},
					enable = {
						order = 2,
						type = "toggle",
						name = ENABLE,
					},
					dispel = {
						order = 3,
						type = "toggle",
						name = L["clickset_dispel"],
					},
					CSGroup1 = {
						order = 4,
						type = "group",
						name = L["CSGroup1"],
						guiInline = true,
						disabled = function() return not db.clickset.enable end,	
						args = {
							type1 = {
								order = 1,
								type = "select",
								name = L["type1"],
								desc = L["TYPE1_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							shiftztype1 = {
								order = 2,
								type = "select",
								name = L["shiftztype1"],
								desc = L["SHIFTZTYPE1_DESC"],
								values = {
									["NONE"] = L["None"],
								},							
							},
							ctrlztype1 = {
								order = 3,
								type = "select",
								name = L["ctrlztype1"],
								desc = L["CTRLZTYPE1_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altztype1 = {
								order = 4,
								type = "select",
								name = L["altztype1"],
								desc = L["ALTZTYPE1_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altzctrlztype1 = {
								order = 5,
								type = "select",
								name = L["altzctrlztype1"],
								desc = L["ALTZCTRLZTYPE1_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
						},
					},
					CSGroup2 = {
						order = 5,
						type = "group",
						name = L["CSGroup2"],
						guiInline = true,
						disabled = function() return not db.clickset.enable end,	
						args = {							
							type2 = {
								order = 1,
								type = "select",
								name = L["type2"],
								desc = L["TYPE2_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							shiftztype2 = {
								order = 2,
								type = "select",
								name = L["shiftztype2"],
								desc = L["SHIFTZTYPE2_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							ctrlztype2 = {
								order = 3,
								type = "select",
								name = L["ctrlztype2"],
								desc = L["CTRLZTYPE2_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altztype2 = {
								order = 4,
								type = "select",
								name = L["altztype2"],
								desc = L["ALTZTYPE2_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altzctrlztype2 = {
								order = 5,
								type = "select",
								name = L["altzctrlztype2"],
								desc = L["ALTZCTRLZTYPE2_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
						},
					},
					CSGroup3 = {
						order = 6,
						type = "group",
						name = L["CSGroup3"],
						guiInline = true,
						disabled = function() return not db.clickset.enable end,	
						args = {							
							type3 = {
								order = 1,
								type = "select",
								name = L["type3"],
								desc = L["TYPE3_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							shiftztype3 = {
								order = 2,
								type = "select",
								name = L["shiftztype3"],
								desc = L["SHIFTZTYPE3_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							ctrlztype3 = {
								order = 3,
								type = "select",
								name = L["ctrlztype3"],
								desc = L["CTRLZTYPE3_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altztype3 = {
								order = 4,
								type = "select",
								name = L["altztype3"],
								desc = L["ALTZTYPE3_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altzctrlztype3 = {
								order = 5,
								type = "select",
								name = L["altzctrlztype3"],
								desc = L["ALTZCTRLZTYPE3_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
						},
					},
					CSGroup4 = {
						order = 7,
						type = "group",
						name = L["CSGroup4"],
						guiInline = true,
						disabled = function() return not db.clickset.enable end,	
						args = {							
							shiftztype4 = {
								order = 1,
								type = "select",
								name = L["shiftztype4"],
								desc = L["SHIFTZTYPE4_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							ctrlztype4 = {
								order = 2,
								type = "select",
								name = L["ctrlztype4"],
								desc = L["CTRLZTYPE4_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altztype4 = {
								order = 3,
								type = "select",
								name = L["altztype4"],
								desc = L["ALTZTYPE4_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altzctrlztype4 = {
								order = 4,
								type = "select",
								name = L["altzctrlztype4"],
								desc = L["ALTZCTRLZTYPE4_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},							
							type4 = {
								order = 5,
								type = "select",
								name = L["type4"],
								desc = L["TYPE4_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
						},
					},
					CSGroup5 = {
						order = 8,
						type = "group",
						name = L["CSGroup5"],
						guiInline = true,
						disabled = function() return not db.clickset.enable end,	
						args = {							
							shiftztype5 = {
								order = 1,
								type = "select",
								name = L["shiftztype5"],
								desc = L["SHIFTZTYPE5_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							ctrlztype5 = {
								order = 2,
								type = "select",
								name = L["ctrlztype5"],
								desc = L["CTRLZTYPE5_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altztype5 = {
								order = 3,
								type = "select",
								name = L["altztype5"],
								desc = L["ALTZTYPE5_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							altzctrlztype5 = {
								order = 4,
								type = "select",
								name = L["altzctrlztype5"],
								desc = L["ALTZCTRLZTYPE5_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},
							type5 = {
								order = 5,
								type = "select",
								name = L["type5"],
								desc = L["TYPE5_DESC"],
								values = {
									["NONE"] = L["None"],
								},
							},							
						},
					},
				},
			},			
		},
	}
	
	if C["clickset"].enable == true then
		for k,v in pairs(E.ClickSets_Sets[E.MyClass]) do
			if GetSpellInfo(v) then
				EuiConfig.Options.args.clickset.args.CSGroup1.args.type1.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup1.args.shiftztype1.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup1.args.ctrlztype1.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup1.args.altztype1.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup1.args.altzctrlztype1.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup2.args.type2.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup2.args.shiftztype2.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup2.args.ctrlztype2.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup2.args.altztype2.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup2.args.altzctrlztype2.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup3.args.type3.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup3.args.shiftztype3.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup3.args.ctrlztype3.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup3.args.altztype3.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup3.args.altzctrlztype3.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup4.args.shiftztype4.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup4.args.ctrlztype4.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup4.args.altztype4.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup4.args.altzctrlztype4.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup4.args.type4.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup5.args.shiftztype5.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup5.args.ctrlztype5.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup5.args.altztype5.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup5.args.altzctrlztype5.values[GetSpellInfo(v)] = GetSpellInfo(v)
				EuiConfig.Options.args.clickset.args.CSGroup5.args.type5.values[GetSpellInfo(v)] = GetSpellInfo(v)
			end
		end
	end
	
	EuiConfig.Options.args.profiles = EuiConfig.profile
end


