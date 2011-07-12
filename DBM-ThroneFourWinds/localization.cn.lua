if GetLocale() ~= "zhCN" then return end

local L

------------------------
--  Conclave of Wind  --
------------------------
L = DBM:GetModLocalization("Conclave")

L:SetGeneralLocalization({
	name 				= "风之议会"
})

L:SetWarningLocalization({
	warnSpecial			= "飓风/微风/暴雨启动",--Special abilities hurricane, sleet storm, zephyr(which are on shared cast/CD)
	specWarnSpecial			= "特别技能启动!",
	warnSpecialSoon			= "10秒后 特别技能启动!"
})

L:SetTimerLocalization({
	timerSpecial			= "特别技能冷却",
	timerSpecialActive		= "特别技能启动"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	SoundWest = "为西风首领播放额外的警告语音",
	SoundEast = "为东风首领播放额外的警告语音",
	warnSpecial			= "当飓风/微风/暴雨施放时显示警告",--Special abilities hurricane, sleet storm, zephyr(which are on shared cast/CD)
	specWarnSpecial			= "当特别技能施放时显示特别警告",
	timerSpecial			= "为特别技能冷却显示计时条",
	timerSpecialActive		= "为特别技能持续时间显示计时条",
	warnSpecialSoon			= "特别技能施放前10秒显示预先警告",
	OnlyWarnforMyTarget		= "只显示当前或焦点目标相关的警告\n(隐藏所有其它，这包括进入战斗)"
})

L:SetMiscLocalization({
	gatherstrength			= "开始从剩下的风领主那里取得力量!",
	Anshal				= "西风领主安萧尔",
	Nezir				= "北风领主涅兹尔",
	Rohash				= "东风领主洛哈许"
})

---------------
--  Al'Akir  --
---------------
L = DBM:GetModLocalization("AlAkir")

L:SetGeneralLocalization({
	name 				= "奥拉基尔"
})

L:SetWarningLocalization({
	WarnAdd				= "小风暴 即将到来"
})

L:SetTimerLocalization({
	TimerFeedback 			= "回馈 (%d)",
	TimerAddCD		= "下一个小风暴"
})

L:SetOptionLocalization({
	SoundWOP = "为重要技能播放额外的警告语音",
	LightningRodIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(89668),
	TimerFeedback			= "为$spell:87904的持续时间显示计时条",
	WarnAdd			= "当小风暴出现时显示警告",
	TimerAddCD		= "为下一个小风暴出现显示计时条",
	RangeFrame		= "当中了$spell:89668时显示距离框(20码)"
})

L:SetMiscLocalization({
	summonAdd		=	"风暴啊!我召唤你们来我身边!",
	phase3			=	"够了!我不要再被束缚住了!"
})
