local E, C, L = unpack(EUI)
if not C["other"].bossnotes == true then return end

local BossData = {
    ["黑石岩窟"]	= {
        {name = "摧骨者罗姆欧格", text = "优先打锁链，躲开Boss蓄力旋风斩。Boss召唤出的小怪由T拉住让boss自己旋风斩劈死即可。"},
        {name = "暮光信使柯尔拉", text = "三个人挡三条线，Debuff到80层离开，Debuff消掉后继续挡，如此往复。T自己打断好boss恐惧。"},
        {name = "卡尔什·断钢", text = "T控制好时间让Boss一直处于被火烧的状态，不能太猛，也尽量不要断掉buff。断掉Buff场地周围会刷出小怪。"},
        {name = "如花", text = "控制好两条小狗，然后将如花击杀即可，无需注意技能。"},
        {name = "升腾者领主奥西迪斯", text = "由一名远程DPS风筝三只小怪，其他人打boss。Boss会在三个分身中切换，所以要保证一致攻击本体。"},
    },
    ["旋云之颠"]	= {
        {name = "首相伊尔丹", text = "旋风在外圈的时候要站在内圈，当旋风合拢时，所有人要站出来。碰到旋风攻击速度会减少很多"},
        {name = "艾塔伊洛斯", text = "别碰到旋风，保持全程站在顺风位置即可。逆风的话读条会很久"},
        {name = "亚沙德", text = "分散站位，减少闪电链伤害。boss召唤法阵后全都站在法阵内，不然会被A死。"},
    },
    ["潮汐王座"]	= {
        {name = "纳兹夏女士", text = "第一阶段的震爆一定要打断，喷泉要拉着boss离开，第二阶段注意别被风吹起来，小怪控制左右先杀中间。"},
        {name = "指挥官乌尔索克", text = "Boss重击T要躲好，沿着场地最外侧拉boss直到将其击倒。"},
        {name = "屈心者哥尔萨", text = "第一阶段地上的刺要躲好，熔岩爆裂要打断。第二阶段法系看见Boss给自己上盾要马上停手，不然它会回血。"},
        {name = "厄祖玛特", text = "第一阶段鱼人和无面者清理好，第二阶段杀掉三个小怪躲好黑水，T拉着血肉兽风筝。第三阶段找到大章鱼杀之。"},
    },
    ["巨石之核"]	= {
        {name = "克伯鲁斯", text = "A好Boss喷出的小水晶，第二阶段Boss在底下，不要被他钻出来的时候撞到，会秒杀的。之后回到第一阶段。"},
        {name = "岩皮", text = "躲好地上的岩浆圈，Boss在地面全屏Aoe躲在柱子后面卡视角。空中阶段不要被落下来的石柱砸到。"},
        {name = "欧泽鲁克", text = "Boss给自己套盾的时候远程给Boss上dot反弹给自己，近战躲好粉碎，T拉好大地冲击"},
        {name = "高阶女祭司艾苏尔", text = "打断好boss的原力之握，将跑过来得信徒都引入重力之井会直接秒杀。第二阶段注意不要被石头砸到。"},
    },
    ["格瑞姆巴托"]	= {
        {name = "昂布里斯将军", text = "躲好Boss的点名冲锋和范围震荡波，全程控制好紫色小怪。"},
        {name = "锻造大师瑟隆葛斯", text = "Boss选择双持武器的时候可以缴械他，选择双手武器的时候则风筝他，选择盾牌的时候则要在背后揍他。"},
        {name = "达加·燃影者", text = "全程优先击杀火元素，龙阶段注意躲好喷火。"},
        {name = "伊鲁达克斯", text = "Boss全屏Aoe的时候躲进风眼，Aoe过后马上到门口击杀小怪。如此往复即可。"},
    },
    ["托维尔的失落之城"]	= {
        {name = "胡辛姆将军", text = "躲好地上黄色光泽的炸弹，以及boss踩地板时候冒出的地刺"},
        {name = "锁喉", text = "A好小鳄鱼，别站鳄鱼屁股后面，鳄鱼狂暴后T记得开个技能。矮子战斗中旋风斩要远离"},
        {name = "高阶预言者巴林姆", text = "第一阶段打好红凤凰，蛋不用打哦。第二阶段打黑凤凰，尽量不要让凤凰吃到灵魂。黑凤凰死后返回现实世界击杀boss。"},
        {name = "希亚玛特", text = "第一阶段击杀全部由boss召唤出的小怪，先杀会闪电链的。第二阶段直接rush Boss即可。"},
    },
    ["死亡矿井"]	= {
        {name = "格拉布托克", text = "第一阶段rush Boss，第二阶段躲好火墙继续Rush Boss"},
        {name = "笨重的欧弗", text = "躲好Boss随机扔的地雷，胖子死后击杀小地精即可。注意被小地精绑了炸弹的人要远离人群。"},
        {name = "死神5000", text = "一个玩家控制机器人在下面杀好火元素，其他人在斜坡杀好Boss，急速旋转近战记得远离"},
        {name = "利普斯纳尔上将", text = "全程出气体怪全队优先击杀，然后再打boss，最后一次出三个气体怪的时候可直接rush boss"},
        {name = "\"船长\"曲奇", text = "再出好吃的抵消坏吃的的debuff并且获得施法加速的buff，轮着吃，边吃边打Boss，施法特别快，打的特别爽！"},
        {name = "梵妮莎·范克里夫", text = "全程优先打小怪，要爆炸的时候跳船边的绳子荡走。"},
    },
    ["影牙城堡"]	= {
        {name = "埃什博瑞男爵", text = "Boss读什么打断什么，加血的那个让他读两下再打断。如果你够猛也可以直接打断"},
        {name = "席瓦莱恩男爵", text = "出狼先打狼，打完狼再打Boss。"},
        {name = "指挥官斯普林瓦尔", text = "优先击杀小怪，躲好Boss喷火，不要站在绿圈里，小怪的邪恶活化尽量打断"},
        {name = "沃登勋爵", text = "绿瓶移动，红瓶不动，蓝瓶看情况动。"},
        {name = "高弗雷勋爵", text = "诅咒子弹一定要解，不能解就一定要打断。Boss的满天弹幕要躲开"},
    },
    ["起源大厅"]	= {
        {name = "神殿守护者安努尔", text = "第二阶段2人一组开机关，一个引怪一个开，聚到上面一起干，打完小蛇打boss。"},
        {name = "地怒者塔赫", text = "没有难度，boss会散化一次出现很多小怪，杀了之后boss会再次合体，打死即可。"},
        {name = "安拉斐特", text = "躲好他放的黑圈，Aoe的时候注意全队血量。"},
        {name = "伊希斯特", text = "放Aoe的时候背对Boss，第一次分身杀雨，第二次分身杀纱，第三次过了。"},
        {name = "阿穆纳伊", text = "全程会不断的出小花，一定要用最快的速度打掉，没有难度。"},
        {name = "塞特斯", text = "优先打Boss开启的传送门，然后Rush boss，不用理会小怪。"},
        {name = "拉夏", text = "离Boss远的人躲好Boss的跳跃，打断好太阳之球，全团使劲打即可，木桩战"},
    },
}

SLASH_BOSS1 = "/boss"
SLASH_BOSS2 = "/BOSS"
SlashCmdList["BOSS"] = function(input)
	local bossname = UnitName("target")
	if bossname == nil then
		DEFAULT_CHAT_FRAME:AddMessage("请选中BOSS为你的目标",1,0,0)
		return
	end
	for k, v in pairs(BossData) do
		for i, info in ipairs(v) do
			if(type(info.text)=="string") then
				if bossname == info.name then
					SendChatMessage(info.text, "PARTY");
					return;
				end
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage("无此BOSS数据",1,0,0);
end
	
