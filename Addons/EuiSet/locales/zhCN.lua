﻿if GetLocale() == "zhCN" then
	e_gui_button_reset = "重载插件"
	
	-- 主菜单
	e_main_label = "一般设置"
	e_filter_label = "技能监视"
	e_chat_label = "聊天"
	e_bag_label = "背包"
	e_unitframe_label = "头像"
	e_actionbar_label = "动作条"
	e_tooltip_label = "鼠标提示"
	e_threat_label = "仇恨显示"
	e_info_label = "信息条"
	e_raid_label = "团队/小队"
	e_clickset_label = "点击施法"
	e_skins_label = "界面美化"
	e_other_label = "其它"
	
	-- 一般设置
	e_main_autoscale = "自动缩放"
	e_main_uiscale = "手动缩放比例(范围0.64 - 1)"
	e_main_movechat = "锁定聊天位置"
	e_main_autoinvite = "自动密语邀请"
	e_main_invitetext = "密语邀请暗号"
	e_main_noerrors = "屏蔽红字提示"
	e_main_noerrorsincombat = "战斗中屏蔽红字提示"
	e_main_chatfilter = "过滤聊天框废话"
	e_main_moveuierrors = "移动红字错误到顶部"
	e_main_ignoreduel = "自动拒绝决斗"
	e_main_autoroll = "自动贪婪绿色物品"
	e_main_disableconfirm = "自动贪婪禁止弹出确认"
	e_main_autoloot = "自动拾取切换"
	e_main_autorepair = "自动修理"
	e_main_autorepairguild = "优先公会修理"
	e_main_sellgreycrap = "自动售卖灰色物品"
	e_main_acceptinvites = "自动接受好友/同公会邀请"
	e_main_buystack = "alt+点击购买堆叠物品"
	e_main_alttotrade = "alt+点击自动与目标交易该物品"
	e_main_talentspam = "天赋切换报告"
	e_main_questauto = "自动完成任务"
	e_main_questicons = "高亮已完成任务图标(问号)"
	e_main_autorez = "战场自动释放"
	e_main_combatnoti = "进入/脱离战斗提示"
	e_main_lockquest = "移动任务监视/载具显示"
	e_main_alpha = "启用透明背景"
	e_main_classcolortheme = "启用职业色主题"

	--其它
	e_other_nameplate = "启用内置姓名板"
	e_other_nameplateauto = "战斗自动打开姓名板"
	e_other_nameplatevalue = "姓名板显示血量"
	e_other_mail = "启用内置邮件增强"
	e_other_cooldown = "启用冷却内置计时功能"
	e_other_tab = "启用专业标签"
	e_other_loot = "启用ROLL框增强"
	e_other_recipients = "启用收(发)件人列表"
	e_other_sr = "启用增强声望显示方式"
	e_other_focuser = "启用shift+左键设置焦点"
	e_other_ratings = "启用等级百分比转换"
	e_other_hb = "启用/hb 绑定快捷键功能"
	e_other_spellid = "启用鼠标提示显示技能ID"
	e_other_mbb = "启用小地图图标合集"
	
	-- 聊天
	e_chat_enable = "启用聊天增强"
	e_chat_hidejunk = "屏蔽废话"
	e_chat_chatw = "聊天框宽度"
	e_chat_chath = "聊天框高度"
	e_chat_chatbar = "启用频道按钮条"
	e_chat_chatguard = "启用防刷屏功能"
	e_chat_LFW = "启用组队频道转发LFW功能"
	
	-- 技能监视
	e_filter_enable = "启用技能监视"
	e_filter_configmode = "调试模式"
	e_filter_classcolor = "计时条职业染色"
	e_filter_pbuffbar = "玩家BUFF计时条"
	e_filter_tdebuffbar = "目标DEBUFF计时条"
	e_filter_barheight = "计时条高度（宽度同玩家和目标血条)"
	e_filter_coolline = "启用流线行冷却计时条"
	e_filter_iconsize = "提示图标大小"
	e_filter_pbufficon = "启用玩家BUFF图标提示"
	e_filter_tdebufficon = "启用目标DEBUFF图标提示"
	e_filter_float = "冷却时间显示小数"
	e_filter_raid = "启用团队技能冷却计时"
	e_filter_raidwidth = "团队技能冷却条宽度"
	e_filter_raidheight = "团队技能冷却条高度"
	e_filter_raidnumber = "团队技能冷却条最大条数"
	
	-- 头像
	e_unitframe_totalhpmp = "玩家血条显示详细值"
	e_unitframe_castbar = "启用施法条"
	e_unitframe_swing = "启用平砍计时条"
	e_unitframe_totdebuffs = "显示目标的目标的Debuff数"
	e_unitframe_colorClass = "启用血条职业色彩"
	e_unitframe_Fbuffs = "焦点BUFF数量"
	e_unitframe_Fdebuffs = "焦点DEBUFF数量"
	e_unitframe_portrait = "启用3D头像"
	e_unitframe_showPvP = "显示PvP图标"
	e_unitframe_onlyplayer = "只显示玩家施放的DEBUFF"
	e_unitframe_powerspark = "显示五秒回蓝"
	e_unitframe_playerx = "玩家与目标头像间的间隔"
	e_unitframe_playery = "头像距屏幕底距离"
	e_unitframe_playerwidth = "玩家和目标头像宽度"
	e_unitframe_playerheight = "玩家和目标头像高度"
	e_unitframe_petwidth = "宠物头像宽度"
	e_unitframe_petheight = "宠物头像高度"
	e_unitframe_totwidth = "目标的目标的宽度"
	e_unitframe_totheight = "目标的目标的高度"
	e_unitframe_focuswidth = "焦点和焦点目标宽度"
	e_unitframe_focusheight = "焦点和焦点目标高度"
	e_unitframe_colorClassName = "名字职业色彩"
	e_unitframe_cpoint = "启用连击点符文和图腾条"
	e_unitframe_cpointwidth = "连击点符文条宽度"
	e_unitframe_cpointheight = "连击点符文条高度"
	e_unitframe_aaaaunit = "头像样式选式1 , 2 ,3 or 4; 0则禁用"
	e_unitframe_playerdebuffnum = "玩家头像显示DEBUFF数量"
	e_unitframe_bigcastbar = "启用大型施法条"
	e_unitframe_bigcastbarscale = "大型施法条缩放比率"

	--团队
	e_raid_raidDirection = "治疗模式团队逆序排列"
	e_raid_raid = "启用团队小队框架"
	e_raid_raidthreat = "显示团队仇恨及Debuff高亮"
	e_raid_raidaurawatch = "显示团队副本Debuff"
	e_raid_grid = "治疗模式(开)/DPS模式(关)排列团队"
	e_raid_gridhealthvettical = "治疗模式排列时纵向血条"
	e_raid_raidColorClass = "启用职业色彩"
	e_raid_raidgroups = "显示小队数量"
	e_raid_grouphv = "治疗模式队伍横排/竖排"
	e_raid_groupspace = "DPS模式小队间隔"
	e_raid_gridheight = "治疗模式框架距屏幕底端的距离"
	e_raid_nogridheight = "DPS模式框架距屏幕顶端的距离"
	e_raid_gridh = "治疗模式单元高度"
	e_raid_gridw = "治疗模式单元宽度"
	e_raid_nogridh = "DPS模式单元高度"
	e_raid_nogridw = "DPS模式单元宽度"
	e_raid_clickset = "启用点击施法,预设技能详见Eui/unitframe/ClickSets.lua"
	e_raid_hottime = "启用四角HOT计时数字"
	e_raid_hotsize = "四角HOT尺寸"
	e_raid_showPartyTarget = "显示队伍目标和宠物"
	e_raid_showParty = "显示小队框体"
	e_raid_boss = "显示BOSS"
	e_raid_mt = "显示MT"
	e_raid_raidtarget = "启用团队目标监视模块"
	e_raid_texture = "团队材质样式(0,1,2)"
	
	-- 动作条
	e_actionbar_hideshapeshift = "隐藏姿态栏或图腾栏"
	e_actionbar_showgrid = "总是显示动作条空格"
	e_actionbar_enable = "启用EUI动作条"
	e_actionbar_rightbarmouseover = "右侧动作条鼠标滑过显示"
	e_actionbar_hotkey = "在按钮上显示快捷键"
	e_actionbar_shapeshiftmouseover = "姿态栏或图腾栏鼠标滑过显示"
	e_actionbar_bottompetbar = "将宠物动作条放在主动作条下边，会将主动作条上移"
	e_actionbar_buttonsize = "动作条按键大小"
	e_actionbar_buttonspacing = "主动作条按键间距"
	e_actionbar_petbuttonsize = "宠物/姿态条按键大小"
	e_actionbar_petbuttonspacing = "姿态条按键间距"
	e_actionbar_swaptopbottombar = "互换顶部和底部动作条位置"
	e_actionbar_macrotext = "在动作条按钮上显示宏名称"
	e_actionbar_verticalstance = "垂直显示姿态栏"
	e_actionbar_microbar = "显示微型系统栏"
	e_actionbar_mousemicro = "鼠标滑过时显示微型系统栏"
	e_actionbar_rankwatch = "启用低级法术警报"
	
	-- 鼠标提示
	e_tooltip_enable = "启用鼠标提示"
	e_tooltip_cursor = "跟随鼠标"
	e_tooltip_hideincombat = "战斗中隐藏"
	e_tooltip_hidebuttonscombat = "隐藏动作条快捷键提示"
	e_tooltip_hovertip = "聊天框提示"
	e_tooltip_Scale = "提示框缩放比率"
	e_tooltip_DisplayPvPRank = "显示军衔"
	e_tooltip_ShowIsPlayer = "是否在等级行显示“（玩家）”字样"
	e_tooltip_DisplayFaction = "是否显示NPC声望等级"
	e_tooltip_PlayerServer = "是否显示玩家所属服务器"
	e_tooltip_TargetOfMouse = "显示对象的目标" 
	e_tooltip_ClassIcon = "显示对象玩家的职业图标"
	e_tooltip_ShowTalent = "是否显示玩家天赋"
	e_tooltip_TargetedBy = "是否显示关注目标"
	e_tooltip_x = "水平方向偏移值"
	e_tooltip_y = "垂直方向偏移值"
	
	-- 背包
	e_bag_enable = "启用背包整合"
	
	-- 仇恨
	e_threat_enable = "启用仇恨条"
	e_threat_width = "宽度"
	e_threat_height = "高度"
	e_threat_bars = "仇恨条数量"
	e_threat_spacing = "仇恨条间隔"
	e_threat_direction = "排列方向:down、left、right、up"
	e_threat_test = "打开调试模式"
	
	--信息条
	e_info_enable = "启用信息条(下列各位置设为0则禁用)"
	e_info_bag = "背包信息位置"
	e_info_latency = "延时显示位置"
	e_info_durability = "耐久显示位置"
	e_info_memory = "插件内存显示位置"
	e_info_xp = "经验(声望)显示位置"
	e_info_setting = "设置显示位置"
	e_info_wowtime = "时间显示位置"
	e_info_wgtimenoti = "启用冬握湖时间提醒"
	e_info_friend = "好友信息位置"
	e_info_guild = "公会信息位置"
	e_info_apsp = "1显示攻强,2显示法强"
	e_info_dps = "1显示秒伤害,2显示秒治疗"
	
	--点击施法
	e_clickset_aadefault = "启用预设方案,关闭可自义技能ID,禁用填入数字0"
	e_clickset_shiftztype1 = "shift+左键"
	e_clickset_ctrlztype1 = "ctrl+左键"
	e_clickset_altztype1 = "alt+左键"
	e_clickset_altzctrlztype1 = "alt+ctrl+左键"
	e_clickset_type2 = "右键"
	e_clickset_shiftztype2 = "shift+右键"
	e_clickset_ctrlztype2 = "ctrl+右键"
	e_clickset_altztype2 = "alt+右键"
	e_clickset_altzctrlztype2 = "alt+ctrl+右键"
	e_clickset_type3 = "中键"
	e_clickset_type1 = "左键"
	e_clickset_type4 = "第4键"
	e_clickset_shiftztype4 = "shift+4键"
	e_clickset_ctrlztype4 = "ctrl+4键"
	e_clickset_altztype4 = "alt+4键"
	e_clickset_altzctrlztype4 = "alt+ctrl+4键"
	e_clickset_type5 = "5键"
	e_clickset_shiftztype5 = "shift+5键"
	e_clickset_ctrlztype5 = "ctrl+5键"
	e_clickset_altztype5 = "alt+5键"
	e_clickset_altzctrlztype5 = "alt+ctrl+5键"	
	e_clickset_aamouse = "启用鼠标滚轮解DEBUFF"
	
	--皮肤
	e_skins_askins = "启用系统框美化"
	e_skins_dbm = "启用DBM皮肤"
	e_skins_skada = "启用Skada皮肤"
	
end