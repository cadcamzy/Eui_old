Local E, C, L = unpack(EUI)
if not C["raid"].clickset == true then return end

--[[

语法讲解：
type 鼠标
后面的1,2,3 分别是左键，右键 ，中键
前面前缀的shift,ctrl,alt对应键盘上的按钮。
若无前缀，如type2,就表示直接按鼠标右键。
像shift-type1,表示shift+左键
后面的数字为技能ID。
--后面的是注释,没有意义的.
--]]

E.ClickSets_Sets = {
	PRIEST = { --牧师
			["shift-type1"]	= 139,--"恢復",
			["ctrl-type1"]	= 527,--"驅散魔法",
			["alt-type1"]	= 2061,--"快速治療",
			["alt-ctrl-type1"]	= 2010,--"復活術",
			["type2"]		= 17,--"真言術:盾",
			["shift-type2"]	= 33076,--"癒合禱言",
			["ctrl-type2"]	= 528,--"驅除疾病", 
			["alt-type2"]	= 2060,--"強效治療術",
			["alt-ctrl-type2"]	= 32546,--"束縛治療",
			["type3"]		= 34863,--"治療之環",
	},
	
	DRUID = { --XD
			["shift-type1"]	= 774,--"回春術",
			["ctrl-type1"]	= 2893,--"驅毒術",
			["alt-type1"]	= 8936,--"癒合",
			["alt-ctrl-type1"]	= 50769,--"復活",
			["type2"]		= 53251,--"野性痊癒",
			["shift-type2"]	= 18562,--"迅捷治愈",
			["ctrl-type2"]	= 2782,--"解除詛咒",
			["alt-type2"]	= 50464,--"滋補術",
			["type3"]		= 33763,--"生命之花",
	},
	SHAMAN = { --SM
			["alt-type1"]	= 55459,--"治疗链",
			["shift-type1"]	= 49273,--"治疗波",
			["ctrl-type1"]	= 49284,--"大地之盾",
			["alt-ctrl-type1"]	= 49277,--"先祖之魂",
			["type2"]		= 61301,--"激流61301",
			["alt-type2"]	= 49276,--"次级治疗波",
			["shift-type2"]	= 49276,--"次级治疗波",
			["ctrl-type2"]	= 51886,--"净化灵魂",
			["type3"]		= 55459,--"治疗链",
	},

	PALADIN = { --QS
			["shift-type1"]	= 639,--"聖光術",
			["alt-type1"]	= 19750,--"聖光閃現",
			["ctrl-type1"]	= 53601,--"崇聖護盾",
			["alt-ctrl-type1"]	= 7328,--"救贖",
			["type2"]		= 20473,--"神聖震擊",
			["shift-type2"]	= 53653,--"聖光信標",
			["ctrl-type2"]	= 4987,--"淨化術",
			["alt-type2"]	= 19750,--"聖光閃現",
			["alt-ctrl-type2"]	= 633,--"聖療術",
	},

	WARRIOR = { --ZS
			["ctrl-type1"]	= 50720,--"戒備守護",
			["type2"]		= 3411,--"阻擾",
	},

	MAGE = { --FS
			["shift-type1"]	= 1008,--"魔法增效",
			["alt-type1"]	= 1461,--"秘法智力",
			["ctrl-type1"]	= 23028,--"秘法光輝",
			["type2"]		= 475,--"解除詛咒",
			["ctrl-type2"]	= 475,--"解除詛咒",
			["shift-type2"]	= 604,--"魔法抑制",
	},

	WARLOCK = { --SS
			["alt-type1"]	= 132,--"偵測隱形",
			["ctrl-type1"]	= 5697,--"魔息術",
			["type2"]		= 698,--"召喚儀式",
	},

	HUNTER = { --LR
			["type2"]		= 34477,--"誤導",
	},
	
	ROGUE = { --DZ
			["type2"]		= 57933,--"偷天換日",
	},
}