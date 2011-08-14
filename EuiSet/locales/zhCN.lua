﻿local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("EuiConfig", "zhCN")
if not L then return end

	L["CFG_RELOAD"] = "重载插件"
	
	-- 主菜单
	L["main"] = "一般设置"
	L["filter"] = "技能监视"
	L["chat"] = "聊天"
	L["bag"] = "背包"
	L["unitframe"] = "头像"
	L["actionbar"] = "动作条"
	L["tooltip"] = "鼠标提示"
	L["threat"] = "仇恨显示"
	L["info"] = "信息条"
	L["raid"] = "团队/小队"
	L["clickset"] = "点击施法"
	L["skins"] = "界面美化"
	L["other"] = "其它"
	L["ui"] = "UI显示设置"
	L["class"] = "职业模块"
	L["nameplate"] = "姓名版"
	
	--Class设置
	L["class_dk"] = "DK鲜血护盾模块(需开启3D头像)"
	
	--UI设置
	L["ui_autoscale"] = "UI自动缩放"
	L["ui_uiscale"] = "手动调整UI缩放"
	
	-- 一般设置
	L["main_movechat"] = "锁定聊天位置"
	L["main_autoinvite"] = "自动密语邀请"
	L["main_invitetext"] = "密语邀请暗号"
	L["main_noerrors"] = "屏蔽红字提示"
	L["main_noerrorsincombat"] = "战斗中屏蔽红字提示"
	L["main_chatfilter"] = "过滤聊天框废话"
	L["main_moveuierrors"] = "移动红字错误到顶部"
	L["main_ignoreduel"] = "自动拒绝决斗"
	L["main_autoroll"] = "自动贪婪/分解绿色物品"
	L["main_disableconfirm"] = "自动贪婪禁止弹出确认"
	L["main_autoloot"] = "自动拾取切换"
	L["main_autorepair"] = "自动修理"
	L["main_autorepairguild"] = "优先公会修理"
	L["main_sellgreycrap"] = "自动售卖灰色物品"
	L["main_acceptinvites"] = "自动接受好友/同公会邀请"
	L["main_buystack"] = "alt+点击购买堆叠物品"
	L["main_alttotrade"] = "alt+点击自动与目标交易该物品"
	L["main_talentspam"] = "天赋切换报告"
	L["main_questauto"] = "自动完成任务"
	L["main_questicons"] = "高亮已完成任务图标(问号)"
	L["main_autorez"] = "战场自动释放"
	L["main_combatnoti"] = "进入/脱离战斗提示"
	L["main_lockquest"] = "移动任务监视/载具显示"
	L["main_alpha"] = "透明背景"
	L["main_classcolortheme"] = "自定义主题边框色"
	L["main_classcolorcustom"] = "主题边框色"

	--其它
	L["other_mail"] = "内置邮件增强"
	L["other_cooldown"] = "冷却内置计时功能"
	L["other_tab"] = "专业标签"
	L["other_loot"] = "ROLL框增强"
	L["other_recipients"] = "收(发)件人列表"
	L["other_sr"] = "增强声望显示方式"
	L["other_focuser"] = "shift+左键设置焦点"
	L["other_ratings"] = "等级百分比转换"
	L["other_hb"] = "/hb 绑定快捷键功能"
	L["other_spellid"] = "鼠标提示显示技能ID"
	L["other_mbb"] = "小地图图标合集"
	L["other_minimap"] = "小地图"
	L["other_buff"] = "BUFF/DEBUFF美化"
	L["other_map"] = "大地图增强"
	L["other_mapscale"] = "大地图缩放比率"
	L["other_mapalpha"] = "大地图透明度(0~1)"
	L["other_raidcheck"] = "团队检查工具"
	L["other_xct"] = "内置xCT战斗信息显示"
	L["other_raidbuffreminder"] = "团队BUFF提醒"
	L["other_bossnotes"] = "BOSS一句话攻略"

	-- 姓名版
	L["nameplate_enable"] = "内置姓名板"
	L["nameplate_nameplateauto"] = "战斗自动打开姓名板"
	L["nameplate_nameplatevalue"] = "姓名板显示血量"
	L["nameplate_nameplatetank"] = "姓名版坦克模式"	
	
	-- 聊天
	L["chat_enable"] = "聊天增强"
	L["chat_hidejunk"] = "屏蔽废话"
	L["chat_chatw"] = "聊天框宽度"
	L["chat_chath"] = "聊天框高度"
	L["chat_chatbar"] = "频道按钮条"
	L["chat_chatguard"] = "防刷屏功能"
	L["chat_LFW"] = "组队频道转发LFW功能"
	L["chat_bodylevel"] = "过滤不高于某个等级的玩家密语，0关闭此功能"
	L["chat_group1"] = "基本设置"
	L["chat_group2"] = "增强功能"
	
	-- 技能监视
	L["filter_enable"] = "技能监视"
	L["filter_classcolor"] = "计时条职业染色"
	L["filter_pbuffbar"] = "玩家BUFF计时条"
	L["filter_tdebuffbar"] = "目标DEBUFF计时条"
	L["filter_barheight"] = "计时条高度（宽度同玩家和目标血条)"
	L["filter_coolline"] = "流线型冷却计时条"
	L["filter_piconsize"] = "玩家提示图标大小"
	L["filter_ticonsize"] = "目标提示图标大小"
	L["filter_ficonsize"] = "焦点提示图标大小"
	L["filter_pbufficon"] = "玩家BUFF图标提示"
	L["filter_tdebufficon"] = "目标DEBUFF图标提示"
	L["filter_float"] = "冷却时间显示小数"
	L["filter_raid"] = "团队技能冷却计时"
	L["filter_raidwidth"] = "团队技能冷却条宽度"
	L["filter_raidheight"] = "团队技能冷却条高度"
	L["filter_raidnumber"] = "团队技能冷却条最大条数"
	L["filter_pcdicon"] = "玩家CD图标提示"
	L["filter_cdsize"] = "CD图标大小"
	L["filter_coollinew"] = "流线型冷却条宽度"
	L["filter_coollineh"] = "流线型冷却条高度"
	L["filter_pdebufficon"] = "玩家DEBUFF图标提示"
	L["filter_tbufficon"] = "目标BUFF图标提示"
	L["filter_fbufficon"] = "焦点BUFF图标提示"
	L["filter_fdebufficon"] = "焦点DEBUFF图标提示"
	L["filter_group1"] = "基本设置"
	L["filter_group2"] = "团队冷却设置"
	L["filter_group3"] = "流线型冷却计时条设置"
	L["filter_group4"] = "玩家相关"
	L["filter_group5"] = "目标相关"
	L["filter_group6"] = "焦点相关"
	
	-- 头像
	L["unitframe_totalhpmp"] = "头像显示详细值"
	L["unitframe_castbar"] = "施法条"
	L["unitframe_swing"] = "平砍计时条"
	L["unitframe_totdebuffs"] = "显示目标的目标的Debuff数"
	L["unitframe_colorClass"] = "血条职业色彩"
	L["unitframe_Fbuffs"] = "焦点BUFF数量"
	L["unitframe_Fdebuffs"] = "焦点DEBUFF数量"
	L["unitframe_portrait"] = "3D头像"
	L["unitframe_showPvP"] = "显示PvP图标"
	L["unitframe_onlyplayer"] = "只显示玩家施放的DEBUFF和BUFF"
	L["unitframe_powerspark"] = "显示五秒回蓝"
	L["unitframe_playerx"] = "玩家与目标头像间的间隔"
	L["unitframe_playery"] = "头像距屏幕底距离"
	L["unitframe_playerwidth"] = "玩家和目标头像宽度"
	L["unitframe_playerheight"] = "玩家和目标头像高度"
	L["unitframe_petwidth"] = "宠物头像宽度"
	L["unitframe_petheight"] = "宠物头像高度"
	L["unitframe_totwidth"] = "目标的目标的宽度"
	L["unitframe_totheight"] = "目标的目标的高度"
	L["unitframe_focuswidth"] = "焦点和焦点目标宽度"
	L["unitframe_focusheight"] = "焦点和焦点目标高度"
	L["unitframe_colorClassName"] = "名字职业色彩"
	L["unitframe_cpoint"] = "连击点符文和图腾条"
	L["unitframe_cpointwidth"] = "连击点符文条宽度"
	L["unitframe_cpointheight"] = "连击点符文条高度"
	L["unitframe_aaaaunit"] = "头像样式选式0禁用"
	L["unitframe_playerdebuffnum"] = "玩家头像显示DEBUFF数量"
	L["unitframe_bigcastbar"] = "大型施法条"
	L["unitframe_bigcastbarscale"] = "大型施法条缩放比率"
	L["unitframe_bigcastbarpos"] = "大型施法条焦点/玩家/目标距底端的位置"
	L["unitframe_showpprec"] = "显示蓝条百分比"
	L["unitframe_targetbuffs"] = "目标BUFF数量"
	L["unitframe_targetdebuffs"] = "目标DEBUFF数量"
	L["unitframe_boss"] = "显示BOSS框体"
	L["unitframe_group1"] = "头像组件"
	L["unitframe_group2"] = "光环相关"
	L["unitframe_group3"] = "尺寸调整"
	

	--团队
	L["raid_raidDirection"] = "治疗模式团队逆序排列"
	L["raid_raid"] = "团队小队框架"
	L["raid_raidthreat"] = "显示团队仇恨及Debuff高亮"
	L["raid_raidaurawatch"] = "显示团队副本Debuff"
	L["raid_astyle"] = "0:治疗模式 1:DPS单列 2:DPS双列"
	L["raid_gridhealthvettical"] = "治疗模式排列时纵向血条"
	L["raid_raidColorClass"] = "职业色彩"
	L["raid_raidgroups"] = "显示小队数量"
	L["raid_grouphv"] = "治疗模式队伍横排/竖排"
	L["raid_groupspace"] = "DPS模式小队间隔"
	L["raid_gridheight"] = "治疗模式框架距屏幕底端的距离"
	L["raid_nogridheight"] = "DPS模式框架距屏幕顶端的距离"
	L["raid_gridh"] = "治疗模式单元高度"
	L["raid_gridw"] = "治疗模式单元宽度"
	L["raid_nogridh"] = "DPS模式单元高度"
	L["raid_nogridw"] = "DPS模式单元宽度"
	L["raid_clickset"] = "点击施法"
	L["raid_hottime"] = "四角HOT计时数字"
	L["raid_hotsize"] = "四角HOT尺寸"
	L["raid_showPartyTarget"] = "显示队伍目标和宠物"
	L["raid_showParty"] = "显示小队框体"
	L["raid_mt"] = "显示MT"
	L["raid_raidtarget"] = "团队目标监视模块"
	L["raid_portrait"] = "小队/团队3D头像"
	L["raid_raidtool"] = "团队工具"
	L["raid_group1"] = "团队基本设置"
	L["raid_group2"] = "团队辅助工具"
	
	-- 动作条
	L["actionbar_hideshapeshift"] = "隐藏姿态栏或图腾栏"
	L["actionbar_showgrid"] = "总是显示动作条空格"
	L["actionbar_enable"] = "EUI动作条"
	L["actionbar_rightbarmouseover"] = "右侧动作条鼠标滑过显示"
	L["actionbar_hotkey"] = "在按钮上显示快捷键"
	L["actionbar_shapeshiftmouseover"] = "姿态栏或图腾栏鼠标滑过显示"
	L["actionbar_bottompetbar"] = "将宠物动作条放在主动作条下边，会将主动作条上移"
	L["actionbar_buttonsize"] = "动作条按键大小"
	L["actionbar_buttonspacing"] = "主动作条按键间距"
	L["actionbar_petbuttonsize"] = "宠物/姿态条按键大小"
	L["actionbar_petbuttonspacing"] = "姿态条按键间距"
	L["actionbar_swaptopbottombar"] = "互换顶部和底部动作条位置"
	L["actionbar_macrotext"] = "在动作条按钮上显示宏名称"
	L["actionbar_verticalstance"] = "垂直显示姿态栏"
	L["actionbar_microbar"] = "显示微型系统栏"
	L["actionbar_mousemicro"] = "鼠标滑过时显示微型系统栏"
	L["actionbar_rankwatch"] = "低级法术警报"
	
	-- 鼠标提示
	L["tooltip_enable"] = "鼠标提示"
	L["tooltip_cursor"] = "跟随鼠标"
	L["tooltip_hideincombat"] = "战斗中隐藏"
	L["tooltip_hidebuttonscombat"] = "隐藏动作条快捷键提示"
	L["tooltip_hovertip"] = "聊天框提示"
	L["tooltip_Scale"] = "提示框缩放比率"
	L["tooltip_DisplayPvPRank"] = "显示军衔"
	L["tooltip_ShowIsPlayer"] = "是否在等级行显示玩家字样"
	L["tooltip_DisplayFaction"] = "是否显示NPC声望等级"
	L["tooltip_PlayerServer"] = "是否显示玩家所属服务器"
	L["tooltip_TargetOfMouse"] = "显示对象的目标" 
	L["tooltip_ClassIcon"] = "显示对象玩家的职业图标"
	L["tooltip_ShowTalent"] = "是否显示玩家天赋"
	L["tooltip_TargetedBy"] = "是否显示关注目标"
	L["tooltip_x"] = "水平方向偏移值"
	L["tooltip_y"] = "垂直方向偏移值"
	
	-- 背包
	L["bag_enable"] = "背包整合"
	
	-- 仇恨
	L["threat_enable"] = "仇恨条"
	L["threat_width"] = "宽度"
	L["threat_height"] = "高度"
	L["threat_bars"] = "仇恨条数量"
	L["threat_spacing"] = "仇恨条间隔"
	L["threat_test"] = "打开调试模式"
	
	--信息条
	L["info_enable"] = "信息条(各位置设为0则禁用)"
	L["info_bag"] = "背包信息位置"
	L["info_latency"] = "延时显示位置"
	L["info_durability"] = "耐久显示位置"
	L["info_memory"] = "插件内存显示位置"
	L["info_xp"] = "经验(声望)显示位置"
	L["info_setting"] = "设置显示位置"
	L["info_wowtime"] = "时间显示位置"
	L["info_wgtimenoti"] = "巴拉丁时间提醒"
	L["info_friend"] = "好友信息位置"
	L["info_guild"] = "公会信息位置"
	L["info_apsp"] = "1显示攻强,2显示法强"
	L["info_dps"] = "1显示秒伤害,2显示秒治疗"
	
	--点击施法
L["Clickset"] = "点击施法"
	L["CS_DESC"] = "可以使用鼠标直接点击团队/小队框体进行施法"
	L["None"] = "无"
	L["clickset_dispel"] = "鼠标滚轮驱散"
	L["CSGroup1"] = "鼠标左键"
	L["CSGroup2"] = "鼠标右键"
	L["CSGroup3"] = "鼠标中键"
	L["CSGroup4"] = "鼠标第四键"
	L["CSGroup5"] = "鼠标第五键"
		L["DEFAULT_DESC"] = "预设点击方案, 关闭此项可使用自定义法术"
		L["type1"] = "鼠标左键"
			L["TYPE1_DESC"] = "使用鼠标左键直接点击框体进行施法"
		L["shiftztype1"] = "Shift+鼠标左键"
			L["SHIFTZTYPE1_DESC"] = "使用Shift+鼠标左键点击框体进行施法"
		L["ctrlztype1"] = "Ctrl+鼠标左键"
			L["CTRLZTYPE1_DESC"] = "使用Ctrl+鼠标左键直接点击框体进行施法"
		L["altztype1"] = "Alt+鼠标左键"
			L["ALTZTYPE1_DESC"] = "使用Alt+鼠标左键直接点击框体进行施法"
		L["altzctrlztype1"] = "Alt+Ctrl+鼠标左键"
			L["ALTZCTRLZTYPE1_DESC"] = "使用Alt+Ctrl+鼠标左键直接点击框体进行施法"
		L["type2"] = "鼠标右键"
			L["TYPE2_DESC"] = "使用鼠标右键直接点击框体进行施法"
		L["shiftztype2"] = "Shift+鼠标右键"
			L["SHIFTZTYPE2_DESC"] = "使用Shift+鼠标右键直接点击框体进行施法"
		L["ctrlztype2"] = "Ctrl+鼠标右键"
			L["CTRLZTYPE2_DESC"] = "使用Ctrl+鼠标右键直接点击框体进行施法"
		L["altztype2"] = "Alt+鼠标右键"
			L["ALTZTYPE2_DESC"] = "使用Alt+鼠标右键直接点击框体进行施法"
		L["altzctrlztype2"] = "Alt+Ctrl+鼠标右键"
			L["ALTZCTRLZTYPE2_DESC"] = "使用Alt+Ctrl+鼠标右键直接点击框体进行施法"
		L["type3"] = "鼠标中键"
			L["TYPE3_DESC"] = "使用鼠标中键直接点击框体进行施法"
		L["shiftztype3"] = "Shift+鼠标中键"
			L["SHIFTZTYPE3_DESC"] = "使用Shift+鼠标中键直接点击框体进行施法"
		L["ctrlztype3"] = "Ctrl+鼠标中键"
			L["CTRLZTYPE3_DESC"] = "使用Ctrl+鼠标中键直接点击框体进行施法"
		L["altztype3"] = "Alt+鼠标中键"
			L["ALTZTYPE3_DESC"] = "使用Alt+鼠标中键直接点击框体进行施法"
		L["altzctrlztype3"] = "Alt+Ctrl+鼠标中键"
			L["ALTZCTRLZTYPE3_DESC"] = "使用Alt+Ctrl+鼠标中键直接点击框体进行施法"
		L["shiftztype4"] = "Shift+鼠标第四键"
			L["SHIFTZTYPE4_DESC"] = "使用Shift+鼠标第四键直接点击框体进行施法"
		L["ctrlztype4"] = "Ctrl+鼠标第四键"
			L["CTRLZTYPE4_DESC"] = "使用Ctrl+鼠标第四键直接点击框体进行施法"
		L["altztype4"] = "Alt+鼠标第四键"
			L["ALTZTYPE4_DESC"] = "使用Alt+鼠标第四键直接点击框体进行施法"
		L["altzctrlztype4"] = "Alt+Ctrl+鼠标第四键"
			L["ALTZCTRLZTYPE4_DESC"] = "使用Alt+Ctrl+鼠第四键键直接点击框体进行施法"
		L["type4"] = "鼠标第四键"
			L["TYPE4_DESC"] = "使用鼠标第四键直接点击框体进行施法"
		L["shiftztype5"] = "Shift+鼠标第五键"
			L["SHIFTZTYPE5_DESC"] = "使用Shift+鼠标第五键直接点击框体进行施法"
		L["ctrlztype5"] = "Ctrl+鼠标第五键"
			L["CTRLZTYPE5_DESC"] = "使用Ctrl+鼠标第五键直接点击框体进行施法"
		L["altztype5"] = "Alt+鼠标第五键"
			L["ALTZTYPE5_DESC"] = "使用Alt+鼠标第五键直接点击框体进行施法"
		L["altzctrlztype5"] = "Alt+Ctrl+鼠标第五键"
			L["ALTZCTRLZTYPE5_DESC"] = "使用Alt+Ctrl+鼠标第五键直接点击框体进行施法"
		L["type5"] = "鼠标第五键"
			L["TYPE5_DESC"] = "使用鼠标第五键直接点击框体进行施法"	
	
	--皮肤
	L["skins_askins"] = "系统对话框美化"
	L["skins_dbm"] = "DBM皮肤"
	L["skins_skada"] = "Skada皮肤"
	L["skins_recount"] = "recount皮肤"
	L["skins_texture"] = "头像小队团队材质"
	L["skins_enable"] = "系统框体美化"
	L["skins_font"] = "基本字体"
	L["skins_dmgfont"] = "伤害字体"
	L["skins_cdfont"] = "计时字体"
