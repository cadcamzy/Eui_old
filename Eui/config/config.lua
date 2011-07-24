local E, C, L = unpack(EUI)

C["main"] = {
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
	["bugstack"] = true,
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
	["classcolorcustom"] = "0",
}

C["ui"] = {
	["autoscale"] = true,
	["uiscale"] = 0.71,	
}

C["other"] = {
	["nameplate"] = true, --启用姓名版 
	["nameplateauto"] = true, --姓名版自动隐藏
	["nameplatevalue"] = true, --显示血量
	["nameplatetank"] = false, -- Tank模式.
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
	["xct"] = true,
	["raidcheck"] = true,
	["raidbuffreminder"] = true,
}

C["chat"] = {
	["enable"] = true,
	["hidejunk"] = true,
	["chatw"] = 343,
	["chath"] = 122,
	["chatbar"] = true,
	["chatguard"] = true,
	["LFW"] = true,
	["bodylevel"] = 1,
}

C["filter"] = {
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

C["unitframe"] = {
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
	["playerx"] = 250,
	["playery"] = 300,
	["playerwidth"] = 230,
	["playerheight"] = 36,
	["petwidth"] = 130,
	["petheight"] = 36,
	["totwidth"] = 130,
	["totheight"] = 22,
	["focuswidth"] = 100,
	["focusheight"] = 22,
	["colorClassName"] = true,
	["totalhpmp"] = false,
	["cpoint"] = true,
	["playerdebuffnum"] = 0,
	["bigcastbar"] = false,
	["bigcastbarscale"] = 1,
--	["bigcastbarpos"] = "0/500/0/168/0/120",
	["showpprec"] = false,
	["targetbuffs"] = 32,
	["targetdebuffs"] = 20,
}

C["raid"] = {
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
	["clickset"] = false,
	["hottime"] = true,
	["showParty"] = true,
	["showPartyTarget"] = true,	
	["boss"] = true,
	["mt"] = true,	
	["raidtarget"] = false,
	["hotsize"] = 12,
	["portrait"] = false,
	["raidtool"] = true,
}

C["actionbar"] = {
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

C["tooltip"] = {
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

--C["bag"] = {
--	["enable"] = true,
--}

C["threat"] = {
	["enable"] = true,
	["width"] = 200,
	["height"] = 16,
	["bars"] = 5,
	["spacing"] = 4,
--	["direction"] = "down",
	["test"] = false,
}

C["info"] = {
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

C["clickset"] = {
	["aadefault"] = true,
	["type1"] = 0,
	["shiftztype1"]	= 0,
	["ctrlztype1"]	= 0,
	["altztype1"]	= 0,
	["altzctrlztype1"]	= 0,
	["type2"]		= 0,
	["shiftztype2"]	= 0,
	["ctrlztype2"]	= 0,
	["altztype2"]	= 0,
	["altzctrlztype2"]	= 0,
	["type3"]		= 0,
	["shiftztype4"]	= 0,
	["ctrlztype4"]	= 0,
	["altztype4"]	= 0,
	["altzctrlztype4"]	= 0,
	["type4"] = 0,
	["shiftztype5"]	= 0,
	["ctrlztype5"]	= 0,
	["altztype5"]	= 0,
	["altzctrlztype5"]	= 0,
	["type5"] = 0,
	["aamouse"] = true,
}

C["skins"] = {
	["askins"] = true,
	["dbm"] = true,
	["skada"] = true,
	["recount"] = true,
--	["font"] = true,
	["texture"] = 1,
	["enable"] = true,
}

C["class"] = {
	["dk"] = true,
}