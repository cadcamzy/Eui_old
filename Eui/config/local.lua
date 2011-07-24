local E, C ,L = unpack(EUI)
if(GetLocale()=="zhCN") then
	L.L_COST = "修理花费: "
	L.L_GOLD = "金"
	L.L_TALENT = "改变"
	L.L_TALENT_S = "天赋"
	L.L_INVITE = "接受组队邀请: "
	L.L_DUEL = "拒绝决斗: "
	L.L_UI = "使用 |cff00ffff/eset ui|r 载入EUI设置"
	L.L_BOOST = "使用 |cff00ffff/eset boost|r 优化系统"
	L.L_MSBT = "使用 |cff00ffff/eset msbt|r 载入MSBT设置"
	L.L_RECOUNT = "使用 |cff00ffff/eset recount|r 载入Recount设置"
	L.L_DBM = "使用 |cff00ffff/eset boss|r 载入DBM设置"
	L.L_ESET = "使用 |cff00ffff/eset all|r 载入所有设置"
	L.L_RAID = "|cff00ffffEUI:|r 使用 |cff00ffff/ad raid|r 加载RAID插件"
	L.L_SOLO = "|cff00ffffEUI:|r 使用 |cff00ffff/ad solo|r 加载任务插件"
	L.L_PVP = "|cff00ffffEUI:|r 使用 |cff00ffff/ad pvp|r 加载PVP插件"
	L.L_TRADE = "|cff00ffffEUI:|r 使用 |cff00ffff/ad trade|r 加载商业插件"
	L.L_DISLOOT = "自动拾取关闭"
	L.L_ENLOOT = "自动拾取开启"
	L.L_DXE = "使用 |cff00ffff/eset dxe|r 载入DXE设置"
	L.INSTALLUI_TEXT = "本角色首次使用此EUI，将进行初始化设置并重置界面!"
	
	L.CLICKSET_MOUSE_ERR = "你的宏已经满了，请留两个空位后才能启用鼠标滚轮解Debuff功能！"
	L.CLICKSET_TIP1 = "鼠标滚轮上下被绑定到鼠标指向解DEBUFF上"
	L.CLICKSET_TIP2 = "原视野放大缩小变更为Alt+鼠标滚轮"
	L.CLICKSET_TIP3 = "不需此功能请至点击施法设置中关闭"
	
	L.ADDFILTER_ERR = "参数格式不对!"
	L.ADDFILTER_ERR2 = "参数%s格式不对!"
	L.ADDFILTER_TIP1 = "/af 类型,样式,法术ID,施法者"
	L.ADDFILTER_TIP2 = "/af 类型,样式,法术ID,delete"
	L.ADDFILTER_TIP3 = "类型: 玩家BUFF: pb,目标DEBUFF: td,玩家DEBUFF: pd,目标BUFF: tb, 焦点BUFF: fb, 焦点DEBUFF: fd, 玩家技能冷却: cd"
	L.ADDFILTER_TIP4 = "样式: 图标: icon, 计时条: bar"
	L.ADDFILTER_TIP5 = "法术ID: 一组数字如:65532,由鼠标提示中获得"
	L.ADDFILTER_TIP6 = "施法者: 玩家: player, 目标: target, 任何人: all"
	L.ADDFILTER_TIP7 = "/af pb,icon,1243,player 示范代码添加坚韧的图标监视"
	L.ADDFILTER_TIP8 = "/af cd,icon,59752,player 示范代码添加自利的冷却监视"
	L.ADDFILTER_DEL = " 删除成功,重载后生效!"
	L.ADDFILTER_ADD = " 添加成功"
	L.ADDFILTER_PB_ICON = "玩家BUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_PB_BAR = "玩家BUFF计时条提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_TD_ICON = "目标DEBUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_TD_BAR = "目标DEBUFF计时条提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_CD_ICON = "玩家CD图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_PD_ICON = "玩家DEBUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_TB_ICON = "目标BUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_FB_ICON = "焦点BUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	L.ADDFILTER_FD_ICON = "焦点DEBUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关"
	
	L.JPACK_PACK = "整理"
	
	L.ACHIEVED = "成 就"
--	L.DEBUFF = "玩家DEBUFF"
--	L.TEMPENCHANT = "临时附魔"
	L.BUFF = "玩家BUFF/DEBUFF框体"
	L.FILTER_1 = "玩家BUFF图标"
	L.FILTER_2 = "玩家BUFF计时条"
	L.FILTER_3 = "目标DEBUFF图标"
	L.FILTER_4 = "目标DEBUFF计时条"
	L.FILTER_5 = "玩家CD图标"
	L.FILTER_6 = "玩家DEBUFF图标"
	L.FILTER_7 = "目标BUFF图标"
	L.FILTER_8 = "焦点BUFF图标"
	L.FILTER_9 = "焦点DEBUFF图标"
	
	L.TOOLTIP_TIP1 = "鼠标提示"
	L.TOOLTIP_TIP2 = "鬼魂"
	L.TOOLTIP_TIP3 = "死亡"
	L.TOOLTIP_TIP4 = "被以下玩家选为目标"
	L.TOOLTIP_TIP5 = "目标: "
	L.TOOLTIP_TIP6 = "数量: "
	L.THREAT_TIP1 = "仇 恨"
	L.THREAT_TIP2 = "仇恨框架"
	L.WATCHFRAME = "任务追踪"
	L.TEKSLOOT = "物品ROLL框"
	
	L.RaidCheckDRUID = "德鲁伊"
	L.RaidCheckHUNTER = "猎人"
	L.RaidCheckMAGE = "法师"
	L.RaidCheckPRIEST = "牧师"
	L.RaidCheckROGUE = "潜行者"
	L.RaidCheckWARLOCK = "术士"
	L.RaidCheckWARRIOR = "战士"
	L.RaidCheckSHAMAN = "萨满祭司"
	L.RaidCheckPALADIN = "圣骑士"
	L.RaidCheckDEATHKNIGHT = "死亡骑士"

	L.RaidCheckBuffBearForm = "巨熊形态"
	L.RaidCheckBuffCatForm = "猎豹形态"
	L.RaidCheckBuffGiftOfWild = "野性赐福"
	L.RaidCheckBuffMarkOfWild = "野性印记"

	L.RaidCheckBuffFortitude1 = "坚韧祷言"
	L.RaidCheckBuffFortitude2 = "真言术：韧"
	L.RaidCheckBuffSpirit1 = "精神祷言"
	L.RaidCheckBuffSpirit2 = "神圣之灵"

	L.RaidCheckBuffBrilliance1 = "奥术光辉"
	L.RaidCheckBuffBrilliance2 = "奥术智慧"
	L.RaidCheckBuffBrilliance3 = "达拉然光辉"

	L.RaidCheckBuffKings1 = "王者祝福"
	L.RaidCheckBuffKings2 = "强效王者祝福"
	L.RaidCheckBuffKings3 = "遗忘王者祝福"
	L.RaidCheckBuffMight1 = "力量祝福"
	L.RaidCheckBuffMight2 = "强效力量祝福"
	L.RaidCheckBuffMight3 = "战斗怒吼"
	L.RaidCheckBuff1Wisdom1 = "智慧祝福"
	L.RaidCheckBuff1Wisdom2 = "强效智慧祝福"
	L.RaidCheckBuff1Wisdom3 = "法力之泉"
	L.RaidCheckBuffRighteousFury = "正义之怒"

	L.RaidCheckMsgOUTRAID = "你不在一个团队中"
	L.RaidCheckMsgRighteousFury = "你可能需要启用“正义之怒”"
	L.RaidCheckMsgNoRighteousFury = "无正义之怒"
	L.RaidCheckMsgFullBuff = "Buff检查：常规Buff已齐全！"
	L.RaidCheckMsgNoBuff = "Buff检查：%s缺少！"
	L.RaidCheckMsgNoBuffAll = "*全无*"
	L.RaidCheckMsgFortitude = "耐力"
	L.RaidCheckMsgSpirit = "精神"
	L.RaidCheckMsgBrilliance = "智力"
	L.RaidCheckMsgWild = "野性印记"
	L.RaidCheckMsgKings = "王者祝福"
	L.RaidCheckMsgWisdom = "智慧祝福"
	L.RaidCheckMsgMight = "力量祝福"
	L.RaidCheckMsgGroup = "%s队(%s)"
		
	L.RaidCheckMsgPosition = "到位检查"
	L.RaidCheckMsgAllInPlace = "%s人全部到位"
	L.RaidCheckMsgInPlace = "已到位%s人"
	L.RaidCheckMsgDead = "%s人死亡"
	L.RaidCheckMsgOffline = "%s人离线"
	L.RaidCheckMsgUnVisible = "%s人过远"
	L.RaidCheckMsgETC = "等."

	L.RaidCheckFlaskData = {
			"合剂",
		}
	L.RaidCheckMsgFlask = "合剂检查"
	L.RaidCheckMsgAllNoFlask = "所有人均无合剂效果"
	L.RaidCheckMsgAllHasFlask = "所有人均已有合剂效果"
	L.RaidCheckMsgNoFlask = "%s人无合剂效果"
	L.RaidCheckMsgHasFlask = "%s人已有合剂效果"

	L.RaidCheckTipLeftButtonOnLeftInfo = "检查团队成员到位情况"
	L.RaidCheckTipRightButtonOnLeftInfo = "发起团队就位确认"
	L.RaidCheckTipLeftButtonOnRightInfo = "检查团队BUFF"
	L.RaidCheckTipRightButtonOnRightInfo = "检查合剂效果"
	L.RAIDCHECK_RAIDTOOL = "打开团队工具面板"

	L.MouseLeftButton = "鼠标左键"
	L.MouseRightButton = "鼠标右键"
	L.MouseClick = "鼠标点击"
	L.BottomPanelRaidCheck = "EUI团队检查工具"	
	
	
	L.INFO_APSP_L1 = "鼠标左键"
	L.INFO_APSP_R1 = "切换显示功强/法强"
	
	L.INFO_BAG_TIP1 = "包裹: "
	L.INFO_BAG_TIP2 = "会话: "
	L.INFO_BAG_TIP3 = "挣取:"
	L.INFO_BAG_TIP4 = "花费:"
	L.INFO_BAG_TIP5 = "赤字:"
	L.INFO_BAG_TIP6 = "利润:"
	L.INFO_BAG_TIP7 = "角色: "
	L.INFO_BAG_TIP8 = "服务器: "
	L.INFO_BAG_TIP9 = "合计: "
	L.INFO_BAG_TIP10 = "货币:"
	
	L.INFO_DURABILITY_STAT1 = "法伤"
	L.INFO_DURABILITY_STAT2 = "命中"
	L.INFO_DURABILITY_STAT3 = "爆击"
	L.INFO_DURABILITY_STAT4 = "急速"
	L.INFO_DURABILITY_STAT5 = "法力"
	L.INFO_DURABILITY_STAT6 = "治疗"
	L.INFO_DURABILITY_STAT7 = "5秒法力回复"
	L.INFO_DURABILITY_STAT8 = "强度"
	L.INFO_DURABILITY_STAT9 = "精准"
	L.INFO_DURABILITY_STAT10 = "生命"
	L.INFO_DURABILITY_STAT11 = "躲闪"
	L.INFO_DURABILITY_STAT12 = "招架"
	L.INFO_DURABILITY_STAT13 = "格挡"
	L.INFO_DURABILITY_STAT14 = "护甲"
	L.INFO_DURABILITY_NO = "无"
	L.INFO_DURABILITY_SLOTS1 = "头"
	L.INFO_DURABILITY_SLOTS2 = "肩"
	L.INFO_DURABILITY_SLOTS3 = "胸"
	L.INFO_DURABILITY_SLOTS4 = "腰"
	L.INFO_DURABILITY_SLOTS5 = "腕"
	L.INFO_DURABILITY_SLOTS6 = "手"
	L.INFO_DURABILITY_SLOTS7 = "腿"
	L.INFO_DURABILITY_SLOTS8 = "脚"
	L.INFO_DURABILITY_SLOTS9 = "主手"
	L.INFO_DURABILITY_SLOTS10 = "副手"
	L.INFO_DURABILITY_SLOTS11 = "远程武器"
	L.INFO_DURABILITY_TIP1 = "耐久度"
	L.INFO_DURABILITY_TIP2 = "--==右击发送角色数据到聊天框==--"
	L.INFO_DURABILITY_TIP3 = "角色数据报告: "
	L.INFO_DURABILITY_TIP4 = "天赋"
	L.INFO_DURABILITY_TIP5 = "装备等级"
	L.INFO_DURABILITY_TIP6 = "精通点数"
	L.INFO_DURABILITY_TIP7 = "韧性"
	
	L.INFO_FRIEND_TIP1 = "好友列表: "
	L.INFO_FRIEND_TIP2 = "在线: "
	
	L.INFO_GUILD_TIP1 = "公会"
	L.INFO_GUILD_TIP2 = "+ %d 更多..."
	
	L.INFO_SETTING_TIP1 = "设 置"
	L.INFO_SETTING_TIP2 = "重置UI - 将还原所有界面元素初始位置."
	L.INFO_SETTING_MENU1 = "切换天赋 "
	L.INFO_SETTING_TIP3 = "已启用副天赋!"
	L.INFO_SETTING_TIP4 = "已启用主天赋!"
	L.INFO_SETTING_MENU2 = "清除战斗记录"
	L.INFO_SETTING_MENU3 = "开关战斗日志LOG"
	L.INFO_SETTING_TIP5 = "战斗记录将关闭!"
	L.INFO_SETTING_TIP6 = "战斗记录将开启!"
	L.INFO_SETTING_MENU4 = "加入冬握湖"
	L.INFO_SETTING_MENU5 = "加入托尔巴拉德"
	L.INFO_SETTING_MENU6 = "重设UI界面"
	L.INFO_SETTING_MENU7 = "开/关LFW频道"
	L.INFO_SETTING_TIP7 = "关闭LFW频道"
	L.INFO_SETTING_TIP8 = "开启LFW频道"
	L.INFO_SETTING_MENU8 = "日历"
	L.INFO_SETTING_MENU9 = "游戏选项"
	L.INFO_SETTING_TIP_TITLE = "EUI控制台"
	L.INFO_SETTING_TIP_L1 = "鼠标左键"
	L.INFO_SETTING_TIP_R1 = "打开EUI控制台"
	L.INFO_SETTING_TIP_L2 = "鼠标右键"
	L.INFO_SETTING_TIP_R2 = "更多辅助功能选项..."
	
	L.INFO_WOWTIME_TIP1 = "托尔巴拉德即将在1分钟内开始"
	L.INFO_WOWTIME_TIP2 = "托尔巴拉德即将在15分钟内开始"
	L.INFO_WOWTIME_TIP3 = "托尔巴拉德提示关闭"
	L.INFO_WOWTIME_TIP4 = "托尔巴拉德提示开启"
	L.INFO_WOWTIME_TIP5 = "正在进行"
	L.INFO_WOWTIME_TIP6 = "可排"
	L.INFO_WOWTIME_TIP7 = "不可用"
	L.INFO_WOWTIME_TIP8 = "托尔巴拉德开始时间"
	L.INFO_WOWTIME_TIP9 = "游戏时间"
	L.INFO_WOWTIME_TIP10 = "点左键显示日历"
	L.INFO_WOWTIME_TIP11 = "点右键改变提醒设置"
	
	L.INFO_XP_FACTION1 = "仇恨"
	L.INFO_XP_FACTION2 = "敌对"
	L.INFO_XP_FACTION3 = "冷漠"
	L.INFO_XP_FACTION4 = "中立"
	L.INFO_XP_FACTION5 = "友善"
	L.INFO_XP_FACTION6 = "尊敬"
	L.INFO_XP_FACTION7 = "崇敬"
	L.INFO_XP_FACTION8 = "崇拜"
	L.INFO_XP_FACTION_TIP1 = "经验:"
	L.INFO_XP_FACTION_TIP2 = "当前: %s/%s (%d%%)"
	L.INFO_XP_FACTION_TIP3 = "剩余: %s"
	L.INFO_XP_FACTION_TIP4 = "|cffb3e1ff休息: %s (%d%%)"
	L.INFO_XP_FACTION_TIP5 = "声望: %s"
	L.INFO_XP_FACTION_TIP6 = "等级: |c"
	L.INFO_XP_FACTION_TIP7 = "数值: %s/%s (%d%%)"
	L.INFO_XP_FACTION_TIP8 = "剩余: %s"
	L.INFO_XP_FACTION_TIP9 = "我当前经验为: "
	
	L.INFO_PING_TIP_TITLE = "帧数: "
	L.INFO_PING_TIP_L1 = "本地:"
	L.INFO_PING_TIP_L2 = "世界:"
	
	L.LAYOUT_RAID = "团队框架"
	L.LAYOUT_PETBAR = "宠物动作条"
	L.LAYOUT_MAINBAR = "主动作条"
	
	L.RAIDCOOLDOWN = "团队技能冷却"
	L.SPELLID = "技能ID:"
	L.CASTBY = "\n施法者 "
	
	L.TOOLTIP_LV1 = "装备等级: "
	L.TOOLTIP_TALENT1 = "主天赋: "
	L.TOOLTIP_TALENT2 = "副天赋: "
	L.TOOLTIP_NOTALENT = "无天赋"
	
	L.CHAT_TIP1 = "EUI提醒: 你起码要达到 %d 级才能和我讲话"
	L.CHAT_TIP2 = "你的好友列表满了，此插件模块需要你腾出2个好友空位!"
	
	L.RAIDREMINDER = "团队BUFF提醒"
	
else
	L.L_COST = "修理花費: "
	L.L_GOLD = "金"
	L.L_TALENT = "改變"
	L.L_TALENT_S = "天賦"
	L.L_INVITE = "接受組隊邀請: "
	L.L_DUEL = "拒絕決鬥: "
	L.L_UI = "使用 |cff00ffff/eset ui|r 載入EUI設置"
	L.L_BOOST = "使用 |cff00ffff/eset boost|r 優化系統"
	L.L_MSBT = "使用 |cff00ffff/eset msbt|r 載入MSBT設置"
	L.L_RECOUNT = "使用 |cff00ffff/eset recount|r 載入Recount設置"
	L.L_DBM = "使用 |cff00ffff/eset boss|r 載入DBM設置"
	L.L_ESET = "使用 |cff00ffff/eset all|r 載入所有設置"
	L.L_RAID = "|cff00ffffEUI:|r 使用 |cff00ffff/ad raid|r 加載RAID插件"
	L.L_SOLO = "|cff00ffffEUI:|r 使用 |cff00ffff/ad solo|r 加載任務插件"
	L.L_PVP = "|cff00ffffEUI:|r 使用 |cff00ffff/ad pvp|r 加載PVP插件"
	L.L_TRADE = "|cff00ffffEUI:|r 使用 |cff00ffff/ad trade|r 加載商業插件"
	L.L_DISLOOT = "自動拾取關閉"
	L.L_ENLOOT = "自動拾取開啟"
	L.L_DXE = "使用 |cff00ffff/eset dxe|r 載入DXE設置"
	L.INSTALLUI_TEXT = "本角色首次使用此EUI，將進行初始化設置並重置界面!"
	
	L.CLICKSET_MOUSE_ERR = "你的宏已經滿了，請留兩個空位後才能啟用鼠標滾輪解Debuff功能！"
	L.CLICKSET_TIP1 = "鼠標滾輪上下被綁定到鼠標指向解DEBUFF上"
	L.CLICKSET_TIP2 = "原視野放大縮小變更為Alt+鼠標滾輪"
	L.CLICKSET_TIP3 = "不需此功能請至點擊施法設置中關閉"
	
	L.ADDFILTER_ERR = "參數格式不對!"
	L.ADDFILTER_ERR2 = "參數%s格式不對!"
	L.ADDFILTER_TIP1 = "/af 類型,樣式,法術ID,施法者"
	L.ADDFILTER_TIP2 = "/af 類型,樣式,法術ID,delete"
	L.ADDFILTER_TIP3 = "類型: 玩家BUFF: playerbuff(pb),目標DEBUFF: targetdebuff(td), 玩家技能冷卻: cd"
	L.ADDFILTER_TIP4 = "樣式: 圖標: icon, 計時條: bar"
	L.ADDFILTER_TIP5 = "法術ID: 一組數字如:65532,由鼠標提示中獲得"
	L.ADDFILTER_TIP6 = "施法者: 玩家: player, 目標: target, 任何人: all"
	L.ADDFILTER_TIP7 = "/af pb,icon,1243,player 示範代碼添加堅韌的圖標監視"
	L.ADDFILTER_TIP8 = "/af cd,icon,59752,player 示範代碼添加自利的冷卻監視"
	L.ADDFILTER_DEL = " 刪除成功,重載後生效!"
	L.ADDFILTER_ADD = " 添加成功"
	L.ADDFILTER_PB_ICON = "玩家BUFF圖標提示已被禁用,無法添加,請先到設置中打開對應開關"
	L.ADDFILTER_PB_BAR = "玩家BUFF計時條提示已被禁用,無法添加,請先到設置中打開對應開關"
	L.ADDFILTER_TD_ICON = "目標DEBUFF圖標提示已被禁用,無法添加,請先到設置中打開對應開關"
	L.ADDFILTER_TD_BAR = "目標DEBUFF計時條提示已被禁用,無法添加,請先到設置中打開對應開關"
	L.ADDFILTER_CD_ICON = "玩家CD圖標提示已被禁用,無法添加,請選到設置中打開對應開關"
	
	L.JPACK_PACK = "整理"
	
	L.ACHIEVED = "成 就"
--	L.DEBUFF = "玩家DEBUFF"
--	L.TEMPENCHANT = "臨時附魔"
	L.BUFF = "玩家BUFF/DEBUFF框體"
	L.FILTER_1 = "玩家BUFF圖標"
	L.FILTER_2 = "玩家BUFF計時條"
	L.FILTER_3 = "目標DEBUFF圖標"
	L.FILTER_4 = "目標DEBUFF計時條"
	L.FILTER_5 = "玩家CD圖標"
	L.TOOLTIP_TIP1 = "鼠標提示"
	L.TOOLTIP_TIP2 = "鬼魂"
	L.TOOLTIP_TIP3 = "死亡"
	L.TOOLTIP_TIP4 = "被以下玩家選為目標"
	L.TOOLTIP_TIP5 = "目標: "
	L.TOOLTIP_TIP6 = "數量: "
	L.THREAT_TIP1 = "仇 恨"
	L.THREAT_TIP2 = "仇恨框架"
	L.WATCHFRAME = "任務追蹤"
	L.TEKSLOOT = "物品ROLL框"
	
	L.RaidCheckDRUID = "德魯伊"
	L.RaidCheckHUNTER = "獵人"
	L.RaidCheckMAGE = "法師"
	L.RaidCheckPRIEST = "牧師"
	L.RaidCheckROGUE = "潛行者"
	L.RaidCheckWARLOCK = "術士"
	L.RaidCheckWARRIOR = "戰士"
	L.RaidCheckSHAMAN = "薩滿祭司"
	L.RaidCheckPALADIN = "聖騎士"
	L.RaidCheckDEATHKNIGHT = "死亡騎士"

	L.RaidCheckBuffBearForm = "巨熊形態"
	L.RaidCheckBuffCatForm = "獵豹形態"
	L.RaidCheckBuffGiftOfWild = "野性賜福"
	L.RaidCheckBuffMarkOfWild = "野性印記"

	L.RaidCheckBuffFortitude1 = "堅韌禱言"
	L.RaidCheckBuffFortitude2 = "真言術：韌"
	L.RaidCheckBuffSpirit1 = "精神禱言"
	L.RaidCheckBuffSpirit2 = "神聖之靈"

	L.RaidCheckBuffBrilliance1 = "奧術光輝"
	L.RaidCheckBuffBrilliance2 = "奧術智慧"
	L.RaidCheckBuffBrilliance3 = "達拉然光輝"

	L.RaidCheckBuffKings1 = "王者祝福"
	L.RaidCheckBuffKings2 = "強效王者祝福"
	L.RaidCheckBuffKings3 = "遺忘王者祝福"
	L.RaidCheckBuffMight1 = "力量祝福"
	L.RaidCheckBuffMight2 = "強效力量祝福"
	L.RaidCheckBuffMight3 = "戰鬥怒吼"
	L.RaidCheckBuff1Wisdom1 = "智慧祝福"
	L.RaidCheckBuff1Wisdom2 = "強效智慧祝福"
	L.RaidCheckBuff1Wisdom3 = "法力之泉"
	L.RaidCheckBuffRighteousFury = "正義之怒"

	L.RaidCheckMsgOUTRAID = "你不在一個團隊中"
	L.RaidCheckMsgRighteousFury = "你可能需要啟用“正義之怒”"
	L.RaidCheckMsgNoRighteousFury = "無正義之怒"
	L.RaidCheckMsgFullBuff = "Buff檢查：常規Buff已齊全！"
	L.RaidCheckMsgNoBuff = "Buff檢查：%s缺少！"
	L.RaidCheckMsgNoBuffAll = "*全無*"
	L.RaidCheckMsgFortitude = "耐力"
	L.RaidCheckMsgSpirit = "精神"
	L.RaidCheckMsgBrilliance = "智力"
	L.RaidCheckMsgWild = "野性印記"
	L.RaidCheckMsgKings = "王者祝福"
	L.RaidCheckMsgWisdom = "智慧祝福"
	L.RaidCheckMsgMight = "力量祝福"
	L.RaidCheckMsgGroup = "%s隊(%s)"
		
	L.RaidCheckMsgPosition = "到位檢查"
	L.RaidCheckMsgAllInPlace = "%s人全部到位"
	L.RaidCheckMsgInPlace = "已到位%s人"
	L.RaidCheckMsgDead = "%s人死亡"
	L.RaidCheckMsgOffline = "%s人離線"
	L.RaidCheckMsgUnVisible = "%s人過遠"
	L.RaidCheckMsgETC = "等."

	L.RaidCheckFlaskData = {
			"合劑",
		}
	L.RaidCheckMsgFlask = "合劑檢查"
	L.RaidCheckMsgAllNoFlask = "所有人均無合劑效果"
	L.RaidCheckMsgAllHasFlask = "所有人均已有合劑效果"
	L.RaidCheckMsgNoFlask = "%s人無合劑效果"
	L.RaidCheckMsgHasFlask = "%s人已有合劑效果"

	L.RaidCheckTipLeftButtonOnLeftInfo = "檢查團隊成員到位情況"
	L.RaidCheckTipRightButtonOnLeftInfo = "發起團隊就位確認"
	L.RaidCheckTipLeftButtonOnRightInfo = "檢查團隊BUFF"
	L.RaidCheckTipRightButtonOnRightInfo = "檢查合劑效果"
	L.RAIDCHECK_RAIDTOOL = "打開團隊工具面板"

	L.MouseLeftButton = "鼠標左鍵"
	L.MouseRightButton = "鼠標右鍵"
	L.MouseClick = "鼠標點擊"
	L.BottomPanelRaidCheck = "EUI團隊檢查工具"	
	
	
	L.INFO_APSP_L1 = "鼠標左鍵"
	L.INFO_APSP_R1 = "切換顯示功強/法強"
	
	L.INFO_BAG_TIP1 = "包裹: "
	L.INFO_BAG_TIP2 = "會話: "
	L.INFO_BAG_TIP3 = "掙取:"
	L.INFO_BAG_TIP4 = "花費:"
	L.INFO_BAG_TIP5 = "赤字:"
	L.INFO_BAG_TIP6 = "利潤:"
	L.INFO_BAG_TIP7 = "角色: "
	L.INFO_BAG_TIP8 = "服務器: "
	L.INFO_BAG_TIP9 = "合計: "
	L.INFO_BAG_TIP10 = "貨幣:"
	
	L.INFO_DURABILITY_STAT1 = "法傷"
	L.INFO_DURABILITY_STAT2 = "命中"
	L.INFO_DURABILITY_STAT3 = "爆擊"
	L.INFO_DURABILITY_STAT4 = "急速"
	L.INFO_DURABILITY_STAT5 = "法力"
	L.INFO_DURABILITY_STAT6 = "治療"
	L.INFO_DURABILITY_STAT7 = "5秒法力回復"
	L.INFO_DURABILITY_STAT8 = "強度"
	L.INFO_DURABILITY_STAT9 = "精準"
	L.INFO_DURABILITY_STAT10 = "生命"
	L.INFO_DURABILITY_STAT11 = "躲閃"
	L.INFO_DURABILITY_STAT12 = "招架"
	L.INFO_DURABILITY_STAT13 = "格擋"
	L.INFO_DURABILITY_STAT14 = "護甲"
	L.INFO_DURABILITY_NO = "無"
	L.INFO_DURABILITY_SLOTS1 = "頭"
	L.INFO_DURABILITY_SLOTS2 = "肩"
	L.INFO_DURABILITY_SLOTS3 = "胸"
	L.INFO_DURABILITY_SLOTS4 = "腰"
	L.INFO_DURABILITY_SLOTS5 = "腕"
	L.INFO_DURABILITY_SLOTS6 = "手"
	L.INFO_DURABILITY_SLOTS7 = "腿"
	L.INFO_DURABILITY_SLOTS8 = "腳"
	L.INFO_DURABILITY_SLOTS9 = "主手"
	L.INFO_DURABILITY_SLOTS10 = "副手"
	L.INFO_DURABILITY_SLOTS11 = "遠程武器"
	L.INFO_DURABILITY_TIP1 = "耐久度"
	L.INFO_DURABILITY_TIP2 = "--==右擊發送角色數據到聊天框==--"
	L.INFO_DURABILITY_TIP3 = "角色數據報告: "
	L.INFO_DURABILITY_TIP4 = "天賦"
	L.INFO_DURABILITY_TIP5 = "裝備等級"
	L.INFO_DURABILITY_TIP6 = "精通點數"
	L.INFO_DURABILITY_TIP7 = "韌性"
	
	L.INFO_FRIEND_TIP1 = "好友列表: "
	L.INFO_FRIEND_TIP2 = "在線: "
	
	L.INFO_GUILD_TIP1 = "公會"
	L.INFO_GUILD_TIP2 = "+ %d 更多..."
	
	L.INFO_SETTING_TIP1 = "設 置"
	L.INFO_SETTING_TIP2 = "重置UI - 將還原所有界面元素初始位置."
	L.INFO_SETTING_MENU1 = "切換天賦 "
	L.INFO_SETTING_TIP3 = "已啟用副天賦!"
	L.INFO_SETTING_TIP4 = "已啟用主天賦!"
	L.INFO_SETTING_MENU2 = "清除戰鬥記錄"
	L.INFO_SETTING_MENU3 = "開關戰鬥日誌LOG"
	L.INFO_SETTING_TIP5 = "戰鬥記錄將關閉!"
	L.INFO_SETTING_TIP6 = "戰鬥記錄將開啟!"
	L.INFO_SETTING_MENU4 = "加入冬握湖"
	L.INFO_SETTING_MENU5 = "加入托尔巴拉德"
	L.INFO_SETTING_MENU6 = "重設UI界面"
	L.INFO_SETTING_MENU7 = "開/關LFW頻道"
	L.INFO_SETTING_TIP7 = "關閉LFW頻道"
	L.INFO_SETTING_TIP8 = "開啟LFW頻道"
	L.INFO_SETTING_MENU8 = "日歷"
	L.INFO_SETTING_MENU9 = "遊戲選項"
	L.INFO_SETTING_TIP_TITLE = "EUI控制臺"
	L.INFO_SETTING_TIP_L1 = "鼠標左鍵"
	L.INFO_SETTING_TIP_R1 = "打開EUI控制臺"
	L.INFO_SETTING_TIP_L2 = "鼠標右鍵"
	L.INFO_SETTING_TIP_R2 = "更多輔助功能選項..."
	
	L.INFO_WOWTIME_TIP1 = "托尔巴拉德即將在1分鐘內開始"
	L.INFO_WOWTIME_TIP2 = "托尔巴拉德即將在15分鐘內開始"
	L.INFO_WOWTIME_TIP3 = "托尔巴拉德提示關閉"
	L.INFO_WOWTIME_TIP4 = "托尔巴拉德提示開啟"
	L.INFO_WOWTIME_TIP5 = "正在進行"
	L.INFO_WOWTIME_TIP6 = "可排"
	L.INFO_WOWTIME_TIP7 = "不可用"
	L.INFO_WOWTIME_TIP8 = "托尔巴拉德開始時間"
	L.INFO_WOWTIME_TIP9 = "遊戲時間"
	L.INFO_WOWTIME_TIP10 = "點左鍵顯示日歷"
	L.INFO_WOWTIME_TIP11 = "點右鍵改變提醒設置"
	
	L.INFO_XP_FACTION1 = "仇恨"
	L.INFO_XP_FACTION2 = "敵對"
	L.INFO_XP_FACTION3 = "冷漠"
	L.INFO_XP_FACTION4 = "中立"
	L.INFO_XP_FACTION5 = "友善"
	L.INFO_XP_FACTION6 = "尊敬"
	L.INFO_XP_FACTION7 = "崇敬"
	L.INFO_XP_FACTION8 = "崇拜"
	L.INFO_XP_FACTION_TIP1 = "經驗:"
	L.INFO_XP_FACTION_TIP2 = "當前: %s/%s (%d%%)"
	L.INFO_XP_FACTION_TIP3 = "剩余: %s"
	L.INFO_XP_FACTION_TIP4 = "|cffb3e1ff休息: %s (%d%%)"
	L.INFO_XP_FACTION_TIP5 = "聲望: %s"
	L.INFO_XP_FACTION_TIP6 = "等級: |c"
	L.INFO_XP_FACTION_TIP7 = "數值: %s/%s (%d%%)"
	L.INFO_XP_FACTION_TIP8 = "剩余: %s"
	L.INFO_XP_FACTION_TIP9 = "我當前經驗為: "
	
	L.INFO_PING_TIP_TITLE = "幀數: "
	L.INFO_PING_TIP_L1 = "本地:"
	L.INFO_PING_TIP_L2 = "世界:"
	
	L.LAYOUT_RAID = "團隊框架"
	L.LAYOUT_PETBAR = "寵物動作條"
	L.LAYOUT_MAINBAR = "主動作條"
	
	L.RAIDCOOLDOWN = "團隊技能冷卻"
	L.SPELLID = "技能ID:"
	L.CASTBY = "\n施法者 "
	
	L.TOOLTIP_LV1 = "裝備等級: "
	L.TOOLTIP_TALENT1 = "主天賦: "
	L.TOOLTIP_TALENT2 = "副天賦: "
	L.TOOLTIP_NOTALENT = "無天賦"
	
	L.CHAT_TIP1 = "Eui提醒: 你起碼要達到 %d 級才能密我。"
	L.CHAT_TIP2 = "你的好友列表滿了，此插件需要你騰出2個好友空位!"
	
	L.RAIDREMINDER = "團隊BUFF提醒"
end