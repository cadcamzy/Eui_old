local E, C, L, DB = unpack(EUI)

DB["main"] = {
	["autoinvite"] = true,
	["invitetext"] = "222",
	["noerrors"] = false,
	["noerrorsincombat"] = false,
	["moveuierrors"] = false,
	["ignoreduel"] = false,
	["autoroll"] = false,
	["disableconfirm"] = true,
	["autoloot"] = false,
	["autorepair"] = true,
	["autorepairguild"] = true,
	["sellgreycrap"] = true,
	["acceptinvites"] = true,
	["buystack"] = true,
	["alttotrade"] = true,
	["talentspam"] = true,
	["questauto"] = false,
	["questicons"] = true,
	["autorez"] = true,
	["combatnoti"] = true,
	["lockquest"] = true,
--	["minimapsize"] = 168,
	["alpha"] = false,
	["classcolortheme"] = false,
	["classcolorcustom"] = { r = .23,g = .23,b = .23 },
}

DB["ui"] = {
	["autoscale"] = true,
	["uiscale"] = 0.71,	
	["multisampleprotect"] = true,
}

DB["other"] = {
	["mail"] = true,--邮件增强
	["cooldown"] = true,--内置计时插件
	["tab"] = true, --专业标签
	["loot"] = true,
	["recipients"] = true,
	["sr"] = true,
	["focuser"] = true,
	["ratings"] = true,
	["hb"] = true,
	["spellid"] = true,
	["mbb"] = true,
	["minimap"] = true,
	["buff"] = true,
--	["xct"] = true,
	["raidcheck"] = true,
	["raidbuffreminder"] = true,
	["bossnotes"] = true,
}

DB["nameplate"] = {
	["enable"] = true,                     -- enable nice skinned nameplates that fit into Elvui
	["showlevel"] = true,
	["width"] = 105,
	["height"] = 12,
	["showhealth"] = true,					-- show health text on nameplate
	["enhancethreat"] = true,				-- threat features based on if your a tank or not
	["combat"] = false,					--only show enemy nameplates in-combat.
	["goodcolor"] = {r = 75/255,  g = 175/255, b = 76/255},			--good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {r = 0.78, g = 0.25, b = 0.25},			--bad threat color (opposite of above)
	["goodtransitioncolor"] = {r = 218/255, g = 197/255, b = 92/255},	--threat color when gaining threat
	["badtransitioncolor"] = {r = 240/255, g = 154/255, b = 17/255}, 
	["trackauras"] = false,		--track players debuffs only (debuff list derived from classtimer spell list)
	["trackccauras"] = true,			--track all CC debuffs
}

DB["chat"] = {
	["enable"] = true,
	["hidejunk"] = true,
	["chatw"] = 343,
	["chath"] = 122,
	["chatbar"] = true,
	["chatguard"] = true,
	["LFW"] = true,
	["bodylevel"] = 1,
}

DB["filter"] = {
	["enable"] = true,
--	["configmode"] = false,
	["classcolor"] = true,
	["pbuffbar"] = true,
	["tdebuffbar"] = true,
	["barheight"] = 16,
	["coolline"] = false,
	["coollinew"] = 412,
	["coollineh"] = 18,
	["piconsize"] = 30,
	["ticonsize"] = 36,
	["ficonsize"] = 24,
	["pbufficon"] = true,
	["tdebufficon"] = true,
	["float"] = false,
	["raid"] = true,
	["raidwidth"] = 144,
	["raidheight"] = 12,
	["raidnumber"] = 10,
	["pcdicon"] = true,
	["cdsize"] = 30,
	["pdebufficon"] = true,
	["tbufficon"] = true,
	["fbufficon"] = true,
	["fdebufficon"] = true,
}

DB["unitframe"] = {
	["aaaaunit"] = 1,
	["castbar"] = true,
	["swing"] = false,
	["totdebuffs"] = 5,
	["colorClass"] = false,--新增
	["Fbuffs"] = 2,
	["Fdebuffs"] = 2,
	["portrait"] = true,
	["showPvP"] = false,
	["onlyplayer"] = false,
	["powerspark"] = true,
	["playerwidth"] = 230,
	["playerheight"] = 36,
	["petwidth"] = 130,
	["petheight"] = 36,
	["totwidth"] = 130,
	["totheight"] = 22,
	["focuswidth"] = 112,
	["focusheight"] = 22,
	["colorClassName"] = true,
	["totalhpmp"] = false,
	["cpoint"] = true,
	["playerdebuffnum"] = 0,
	["bigcastbar"] = false,
	["bigcastbarscale"] = 1,
	["showpprec"] = false,
	["targetbuffs"] = 32,
	["targetdebuffs"] = 20,
	["petbuffs"] = 4,
	["petdebuffs"] = 3,
	["boss"] = true,
	["bigaurassize"] = 32,
	["smallaurassize"] = 21,
}

DB["raid"] = {
	["raid"] = true,
	["raidthreat"] = true,
	["raidaurawatch"] = true,
--	["grid"] = 0,--0为治疗模式中间,1DPS模式单列左,2,DPS模式双列聊天框上
	["astyle"] = 0,--0为治疗模式中间,1DPS模式单列左,2,DPS模式双列聊天框上
	["gridhealthvettical"] = false,
	["raidDirection"] = true,--真为顺序,否为逆序
	["raidColorClass"] = false,
	["raidgroups"] = 5,--团队里小队数
	["grouphv"] = true, --小队横排或竖排
	["groupspace"] = 20, --竖排时小队间隔
	["gridheight"] = 90, --Grid框架高度位置
	["nogridheight"] = 180, --单列时框架高度
	["gridh"] = 28, --Grid单元高度
	["gridw"] = 76,--Grid单元宽度
	["nogridh"] = 24,--非Grid样式单元高度
	["nogridw"] = 140,
	["clickset"] = true,
	["hottime"] = true,
	["showParty"] = true,
	["showPartyTarget"] = true,	
	["mt"] = true,	
	["raidtarget"] = false,
	["hotsize"] = 12,
	["portrait"] = false,
	["raidtool"] = true,
}

DB["actionbar"] = {
	["enable"] = true,                     -- enable elvui action bars
	["hotkey"] = true,                     -- enable hotkey display because it was a lot requested
	["rightbarmouseover"] = false,         -- enable right bars on mouse over
	["shapeshiftmouseover"] = false,       -- enable shapeshift or totembar on mouseover
	["hideshapeshift"] = false,            -- hide shapeshift or totembar because it was a lot requested.
	["showgrid"] = true,                   -- show grid on empty button
	["bottompetbar"] = false,				-- position petbar below the actionbars instead of the right side
	["buttonsize"] = 30,					--size of action buttons
	["buttonspacing"] = 4,					--spacing of action buttons
	["petbuttonsize"] = 30,					--size of pet/stance buttons
	["petbuttonspacing"] = 2, 
	["swaptopbottombar"] = false,			--swap the main actionbar position with the bottom actionbar
	["macrotext"] = false,					--show macro text on actionbuttons
	["verticalstance"] = false,				--make stance bar vertical
	["microbar"] = false,					--enable microbar display
	["mousemicro"] = false,					--only show microbar on mouseover
--	["rankwatch"] = true,
}

DB["tooltip"] = {
	["enable"] = true,
	["cursor"] = false,
	["hideincombat"] = false,
	["hidebuttonscombat"] = false,
	["ShowTalent"] = true,				--是否显示玩家天赋
	["TargetedBy"] = false,				--是否显示关注目标
	["hovertip"] = true,
	["x"] = -3,
	["y"] = 42,
}

--DB["bag"] = {
--	["enable"] = true,
--}

DB["threat"] = {
	["enable"] = true,
	["width"] = 200,
	["height"] = 16,
	["bars"] = 5,
	["spacing"] = 4,
--	["direction"] = "down",
	["test"] = false,
}

DB["info"] = {
	["enable"] = true,
	["wowtime"] = 9,
	["latency"] = 3,
	["bag"] = 4,
	["durability"] = 5,
	["memory"] = 2,
	["xp"] = 6,
	["setting"] = 1,
	["guild"] = 8,
	["friend"] = 7,
	["wgtimenoti"] = true,
	["apsp"] = 1,
	["dps"] = 1,
}

DB["clickset"] = {
	["type1"] = "NONE",
	["shiftztype1"]	= "NONE",
	["ctrlztype1"]	= "NONE",
	["altztype1"]	= "NONE",
	["altzctrlztype1"]	= "NONE",
	["type2"]		= "NONE",
	["shiftztype2"]	= "NONE",
	["ctrlztype2"]	= "NONE",
	["altztype2"]	= "NONE",
	["altzctrlztype2"]	= "NONE",
	["type3"]		= "NONE",
	["shiftztype3"]	= "NONE",
	["ctrlztype3"]	= "NONE",
	["altztype3"]	= "NONE",
	["altzctrlztype3"]	= "NONE",	
	["shiftztype4"]	= "NONE",
	["ctrlztype4"]	= "NONE",
	["altztype4"]	= "NONE",
	["altzctrlztype4"]	= "NONE",
	["type4"] = "NONE",
	["shiftztype5"]	= "NONE",
	["ctrlztype5"]	= "NONE",
	["altztype5"]	= "NONE",
	["altzctrlztype5"]	= "NONE",
	["type5"] = "NONE",
	["enable"] = true,
	["dispel"] = true,
}

DB["skins"] = {
	["askins"] = true,
	["dbm"] = true,
	["skada"] = true,
	["recount"] = true,
	["mbb"] = false,
	["texture"] = "EUI Statusbar-1",
	["enable"] = true,
	["font"] = "默认",
	["dmgfont"] = "默认",
	["cdfont"] = "默认",
}

DB["class"] = {
	["dk"] = true,
}

E.ClickSets_Sets = {
	PRIEST = { --牧师
			["shift-type1"]	= 139,--"恢復",
			["ctrl-type1"]	= 527,--"驅散魔法",
			["alt-type1"]	= 2061,--"快速治療",
			["alt-ctrl-type1"]	= 2006,--"復活術",
			["type2"]		= 17,--"真言術:盾",
			["shift-type2"]	= 33076,--"癒合禱言",
			["ctrl-type2"]	= 528,--"驅除疾病", 
			["alt-type2"]	= 2060,--"強效治療術",
			["alt-ctrl-type2"]	= 32546,--"束縛治療",
			["type3"]		= 34861,--"治療之環",
			["shift-type3"] = 2050, --治疗术
			["alt-type3"] = 1706, --漂浮术
			["ctrl-type3"] = 21562,--耐
			["type4"] = 596, --治疗祷言
			["shift-type4"] = 47758, -- 苦修
			["ctrl-type4"] = 73325, -- 信仰飞跃
			["type5"] = 48153, -- 守护之魂
	},
	
	DRUID = { --XD
			["shift-type1"]	= 774,--"回春術",
			["ctrl-type1"]	= 2782,--"净化腐蚀",
			["alt-type1"]	= 8936,--"癒合",
			["alt-ctrl-type1"]	= 50769,--"復活",
			["type2"]		= 48438,--"野性成长",
			["shift-type2"]	= 18562,--"迅捷治愈",
			["ctrl-type2"]	= 88423, -- 自然治愈
			["alt-type2"]	= 50464,--"滋補術",
			["alt-ctrl-type2"] = 1126, -- 野性印记
			["type3"]		= 33763,--"生命之花",
			["shift-type3"] = 5185,--治疗之触
	},
	SHAMAN = { --SM
			["alt-type1"]	= 8004,		--"治疗之拥",
			["shift-type1"]	= 974,		--"大地之盾",
			["ctrl-type1"]	= 1064,		--"治疗链",
			["alt-ctrl-type1"]	= 2008,	--"先祖之魂",
			["type2"]		= 61295,	--"激流",
			["alt-type2"]	= 331,		--"治疗波",
			["shift-type2"]	= 77472,	--"强效治疗波",
			["ctrl-type2"]	= 51886,	--"净化灵魂",
			["type3"]		= 1064,		--"治疗链",
			["shift-type3"] = 546, --水上漂
			["alt-type3"] = 131, --水下游
	},

	PALADIN = { --QS
			["shift-type1"]	= 639,--"聖光術",
			["alt-type1"]	= 19750,--"聖光閃現",
			["ctrl-type1"]	= 53563,--"圣光信标",
			["alt-ctrl-type1"]	= 7328,--"救贖",
		["type2"]		= 20473,--"神聖震擊",
			["shift-type2"]	= 82326,--"Divine Light",
			["ctrl-type2"]	= 4987,--"淨化術",
			["alt-type2"]	= 85673,--"Word of Glory",
			["alt-ctrl-type2"]	= 633,--"聖療術",
		["type3"]		= 31789,--正義防護
			["alt-type3"]	= 20217,--王者
			["shift-type3"]	= 20911,--庇護
			["ctrl-type3"]	= 19740,--力量
			["alt-ctrl-type3"] = 31789, -- 正义防御
	},

	WARRIOR = { --ZS
			["ctrl-type1"]	= 50720,--"戒備守護",
			["type2"]		= 3411,--"阻擾",
	},

	MAGE = { --FS
			["alt-type1"]	= 1459,--"秘法智力",
			["ctrl-type1"]	= 54646,--"专注",
			["type2"]		= 475,--"解除詛咒",
			["shift-type2"]	= 130,--"缓落",
	},

	WARLOCK = { --SS
			["alt-type1"]	= 80398,--"黑暗意图",
			["type2"]		= 5697,--"魔息",
	},

	HUNTER = { --LR
			["type2"]		= 34477,--"誤導",
			["shift-type2"] = 136, --治疗宠物
	},
	
	ROGUE = { --DZ
			["type2"]		= 57933,--"偷天換日",
	},
	
	DEATHKNIGHT = {
			["shift-type1"] = 61999, --战复
			["type2"] = 47541, --死缠
			["type3"] = 49016, -- 邪恶狂乱（邪恶天赋)
	},
}

local class = select(2, UnitClass("player"))

for k, v in pairs(E.ClickSets_Sets[class]) do
	if GetSpellInfo(v) then DB["clickset"][string.gsub(k,"-","z")] = GetSpellInfo(v) end
end