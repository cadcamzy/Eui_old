local E, C = unpack(EUI)
return
if C["chat"].chatguard ~= true then return end

local CG_VERSION = "0.98"

function LocalezhCN()
	CG_HELP = {
		"|cffffff00ChatGuard(v"..CG_VERSION..")使用说明：|r",
		"  /cg [命令] [参数]",
		"  /cg，查看当前设置",
		"  /cg |cffffff00help|r，显示本使用说明",
		"  /cg |cffffff00reset|r，恢复默认设置",
		"  /cg |cff00ff00on|r，启用",
		"  /cg |cffff0000off|r，禁止",
		"  /cg |cffffff00like|r |cff00ff00###|r，设置相似度判断(0-100)",
		"  比如：/cg like 100，设置相似度为100%，判断前后两条信息完全匹配才过滤。/cg like 0 与 /cg off 等效",
		"  /cg |cffffff00interval|r |cff00ff00###|r 设置不允许重复的时限(秒)",
		"  比如：/cg interval 5， 5秒内的重复信息将被过滤，超过5秒的不会被过滤",
		"|cffffff00下面所有开关参数中，|cff00ff00on|r为开启，|cffff0000off|r为关闭",
		"  /cg |cffffff00all|r |cff00ff00on|r/|cffff0000off|r，下面所有频道(debug除外)总开关",
		"  /cg |cffffff00normal|r |cff00ff00on|r/|cffff0000off|r，过滤普通频道开关",
		"  /cg |cffffff00whisper|r |cff00ff00on|r/|cffff0000off|r，过滤密语频道开关",
		"  /cg |cffffff00say|r |cff00ff00on|r/|cffff0000off|r，过滤说话、表情频道开关",
		"  /cg |cffffff00guild|r |cff00ff00on|r/|cffff0000off|r，过滤公会频道开关",
		"  /cg |cffffff00raid|r |cff00ff00on|r/|cffff0000off|r，过滤团队频道开关",
		"  /cg |cffffff00party|r |cff00ff00on|r/|cffff0000off|r，过滤小队频道开关",
		"  /cg |cffffff00trust|r |cff00ff00on|r/|cffff0000off|r，不检查好友的消息",
		"  /cg |cffffff00mlines|r |cff00ff00on|r/|cffff0000off|r，过滤多行消息",
		"  /cg |cffffff00debug|r |cff00ff00on|r/|cffff0000off|r，打印调试信息开关",
		"  /cg |cffffff00filter|r，查看过滤关键字列表",
		"  /cg |cffffff00filter list|r，查看过滤关键字列表",
		"  /cg |cffffff00filter add|r |cffff0000关键字|r，添加过滤关键字",
		"  /cg |cffffff00filter del|r |cffff0000关键字序号|r，删除过滤关键字",
		"  /cg |cffffff00filter rep|r |cffff0000关键字序号 新关键字|r，替换过滤关键字",
		"  /cg |cffffff00filter clear|r，清空过滤关键字列表",
		"  /cg |cffffff00filter reset|r，恢复默认过滤关键字列表",
		"  /cg |cffffff00sucker|r，查看被屏蔽玩家列表",
		"  /cg |cffffff00sucker clear|r，清空被屏蔽玩家列表"
	};
	CG_INFO_LOADED	= "|cffffff00ChatGuard(v"..CG_VERSION..")|r |cff00ff00[Souledge]|r已载入(/cg help，查看帮助信息)";
	CG_INFO_ENABLE	= "|cff00ff00启用|r";
	CG_INFO_DISABLE	= "|cffff0000禁止|r";
	CG_INFO_TITLE	= "|cffffff00ChatGuard(v"..CG_VERSION..")当前状态(/cg help查看帮助)：|r";
	CG_INFO_GENERAL	= "  %s，相似度设置为|cff00ff00%d|r，|cff00ff00%d|r秒内的重复信息将被过滤";
	CG_INFO_NORMAL	= "  过滤普通频道 %s";
	CG_INFO_WHISPER	= "  过滤密语频道 %s";
	CG_INFO_SAY	= "  过滤说话、表情频道 %s";
	CG_INFO_GUILD	= "  过滤公会频道 %s";
	CG_INFO_RAID	= "  过滤团队频道 %s";
	CG_INFO_PARTY	= "  过滤小队频道 %s";
	CG_INFO_DEBUG	= "  打印调试信息 %s";
	CG_INFO_CLEAR	= "已过滤 [|cffffff00%s|r] 的信息：%s";
	CG_INFO_TRUST	= "  不检查好友的消息 %s";
	CG_INFO_MLINES	= "  过滤多行消息 %s";

	CG_DEFAULT_FILTER = {"刷荣誉", "代练", "工作室"};
	CG_INFO_FTITLE = "|cffffff00过滤关键字列表|r";
	CG_INFO_OVERFLOW = "|cffffff00参数超出范围|r";
	CG_INFO_FNULL = "过滤关键字列表为空";

	CG_INFO_REGX = "  过滤关键字正则表达式支持 %s";

	CG_INFO_SUCKER = "|cffffff00被屏蔽玩家列表|r";
	CG_INFO_TOTAL = "总计："
end

local locale = GetLocale();
LocalezhCN(); -- 默认加载简体中文语言

if (locale == "zhTW") then
LocalezhCN();     -- 繁体中文
elseif (locale == "deDE") then -- 德文
elseif (locale == "frFR") then -- 法文
elseif (locale == "koKR") then -- 韩文
elseif (locale == "ruRU") then -- 苏联
else                           -- 英文
end
CG_MAXCHECK_PLAYERS	= 200;		-- 检查最近多少个玩家的消息
CG_EXCLUDE_SELFMSG	= true;		-- 不过滤自己的消息
CG_ONEMSG_INTERVAL	= 0.200;	-- CG_ONEMSG_INTERVAL秒间隔内出现的消息视为同一条消息的不同行，
					-- 小数点前面为秒，小数点后面3位为毫秒
CG_ONEMSG_MAXLINES	= 20;		-- 同一条消息允许的最大行数

local AlikeTable = {};

-- Hooks
CG_Pre_ChatFrame_OnEvent = ChatFrame_OnEvent;
function CG_New_ChatFrame_OnEvent(self, event, ...)
	if (not ChatGuardState.Disable and CareChannel(event)) then
		local msg = arg1;
		local player = arg2;
		local window, fontSize, r, g, b, a, shown, locked = GetChatWindowInfo(this:GetID());

		if not CheckMsg(player, msg, window) then
			if (ChatGuardState.Debug) then
				Print(format(CG_INFO_CLEAR, player, msg));
			end
			return;
		end
	end
	return CG_Pre_ChatFrame_OnEvent(self, event, ...);
end

-- 检测是否需要过滤该频道
-- 返回 true 表示需要过滤，false 不需要过滤
function CareChannel(channel)
	if (ChatGuardState.Debug) then
		Print("---【"..channel.."】---");
	end

	-- 普通频道
	if (channel == "CHAT_MSG_CHANNEL" or channel == "CHAT_MSG_YELL"
		or string.find(channel, "CHAT_MSG_BATTLEGROUND")) then
		return ChatGuardState.CareNormal;
	-- 密语
	elseif (channel == "CHAT_MSG_WHISPER") then
		return ChatGuardState.CareWhisper;
	-- 说
	elseif (channel == "CHAT_MSG_SAY" or channel == "CHAT_MSG_EMOTE" or channel == "CHAT_MSG_TEXT_EMOTE") then
		return ChatGuardState.CareSay;
	-- 公会频道
	elseif (channel == "CHAT_MSG_GUILD" or channel == "CHAT_MSG_OFFICER" or channel == "GUILD_MOTD") then
		return ChatGuardState.CareGuild;
	-- 团队频道
	elseif (string.find(channel, "CHAT_MSG_RAID")) then
		return ChatGuardState.CareRaid;
	-- 小队频道
	elseif (channel == "CHAT_MSG_PARTY") then
		return ChatGuardState.CareParty;
	end

	return false;
end

-- 检测字符串是否为空串
function IsNull(str)
	return (str==nil or str=="");
end

-- 检查玩家是否是自己的好友
function IsMyFriend(player)
	local i;

	for i = 1, GetNumFriends()  do
		if (player == GetFriendInfo(i)) then
			return true;
		end
	end

	return false;
end

-- 检测该条消息是否尚未重复
-- 在设定时间内的重复消息才视为重复
-- 返回 true 表示未重复，false 表示已经重复
function CheckMsg(player, pmsg, window)
	local index = 0;
	local found = false;
	local OldTime = 0;
	local like = 0;

	if (IsNull(player) or IsNull(pmsg) or 
		(CG_EXCLUDE_SELFMSG and player == UnitName("player"))) then
		return true;
	end

	if (ChatGuardState.TrustFriend and IsMyFriend(player)) then
		return true;
	end

	-- 给消息增加窗口名标志，避免自定义窗口消息无法显示
	-- **以前自动过滤重复消息没有这个标志，所有窗口的消息都被统一处理了
	-- **所以一条消息在默认窗口中显示一次，然后在自定义窗口中就会被后面的规则自动过滤掉
	if not IsNull(window) then
		player = window .. ":" .. player;
	end
	for i = 1, getn(AlikeTable) do
		value = AlikeTable[i];
		if (value.Name == player) then
			found = true;
			index = i;
			break;
		end
	end

	if (not found) then
		local Data = {Name=player, MsgBuf={}, Msg={pmsg}, MsgLines=1, Time=GetTime(), Sucker=false};
		table.insert(AlikeTable, Data);

		if (table.getn(AlikeTable) > CG_MAXCHECK_PLAYERS) then
			table.remove(AlikeTable, 1);
		end
		index = table.getn(AlikeTable);
	end

	OldTime = AlikeTable[index].Time;
	AlikeTable[index].Time = GetTime();

	if (found) then
		-- 时间差不多了，让你透口气吧
		-- 暂时注释掉下面几行，让SB说错话在本次游戏中就一直消失
--		if (GetTime() - OldTime > ChatGuardState.Interval) then
--			AlikeTable[index].Time = GetTime();
--			AlikeTable[index].Sucker = false;
--		end

		-- SB，给我闭嘴！
		if (AlikeTable[index].Sucker) then
			return false;
		end
	end

	local uplayer = string.upper(player);
	local umsg = string.upper(pmsg);
	for i = 1, getn(ChatGuardState.Filter) do
		value = string.upper(ChatGuardState.Filter[i]);
		if (string.find(umsg, value, 1, not ChatGuardState.RegEx) or
			string.find(uplayer, value, 1, not ChatGuardState.RegEx)) then

			-- 当该人发言包括被过滤关键字或者名字取得“违章”，直接禁言设定时间
			AlikeTable[index].Sucker = true;
			AlikeTable[index].SuckerMsg = value;
			return false;
		end
	end

	-- 第一条消息，并且没有包含过滤关键字，放行
	if (not found) then
		return true;
	end

	-- 时间超过预设时间直接放行
	if (GetTime() - OldTime > ChatGuardState.Interval) then
--		AlikeTable[index].Time = GetTime();
		AlikeTable[index].MsgBuf = {};
		AlikeTable[index].Msg = {pmsg};
		AlikeTable[index].MsgLines = 1;

		return true;
	end

	-- 与上一条消息比较，过滤重复消息
	like = ComputeStrAlike(AlikeTable[index].Msg[AlikeTable[index].MsgLines], pmsg) * 100;
	if (like >= ChatGuardState.Alike) then
		return false;
	end

	if ( (GetTime() - OldTime <= CG_ONEMSG_INTERVAL) and
		(AlikeTable[index].MsgLines <= CG_ONEMSG_MAXLINES) ) then
		table.insert(AlikeTable[index].Msg, pmsg);
		AlikeTable[index].MsgLines = AlikeTable[index].MsgLines + 1;

		if (ChatGuardState.DisbaleMultiLines) then
			return false;
		end
	else
		AlikeTable[index].MsgBuf = AlikeTable[index].Msg;
		AlikeTable[index].Msg = {pmsg};
		AlikeTable[index].MsgLines = 1;
	end

	-- 与缓存中相同偏移的消息比较（过滤多行广告）
	like = ComputeStrAlike(AlikeTable[index].MsgBuf[AlikeTable[index].MsgLines], pmsg) * 100;

	return (like < ChatGuardState.Alike);
end

-- 往聊天窗口里添加消息，只有本地能看到不会发送给其他人
function Print(Msg)	
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(Msg);
	end
end

-- 计算字符串相似度
function ComputeStrAlike(str1, str2)
	local bigs, smalls;
	local count = 0;
	local i;

	if (IsNull(str1) or IsNull(str2)) then
		return 0;
	end;

	if (ChatGuardState.Alike==100) then
		if (str1==str2) then
			return 1;			
		else
			return 0;
		end
	end

	if (string.len(str1) > string.len(str2)) then
		bigs = str1;
		smalls = str2;
	else
		bigs = str2;
		smalls = str1;
	end

	for i = 1, string.len(smalls) do
		if string.find(bigs, string.sub(smalls, i, i + 1), 1, true) then
			count = count + 1;
		end;
	end

	return (count / string.len(bigs));
end

-- 打印帮助信息
function ChatGuardHelp()
	for i = 1, getn(CG_HELP) do
		Print(CG_HELP[i]);
	end
end

function StateToStr(state)
	if state then
		return CG_INFO_ENABLE;
	else
		return CG_INFO_DISABLE;
	end
end

function PrintFilter()
	Print(CG_INFO_FTITLE);
	if (table.getn(ChatGuardState.Filter) > 0) then
		for i = 1, getn(ChatGuardState.Filter) do
			value = ChatGuardState.Filter[i];
			Print("  |cff00ff00"..i.."|r: "..value);
		end
	else
		Print(CG_INFO_FNULL);
	end
end

-- 察看当前状态
function ChatGuardStatus()
	Print(CG_INFO_TITLE);
	if (not ChatGuardState.Disable) then
		Print(format(CG_INFO_GENERAL, CG_INFO_ENABLE, ChatGuardState.Alike, ChatGuardState.Interval));
		Print(format(CG_INFO_NORMAL, StateToStr(ChatGuardState.CareNormal)));
		Print(format(CG_INFO_WHISPER, StateToStr(ChatGuardState.CareWhisper)));
		Print(format(CG_INFO_SAY, StateToStr(ChatGuardState.CareSay)));
		Print(format(CG_INFO_GUILD, StateToStr(ChatGuardState.CareGuild)));
		Print(format(CG_INFO_RAID, StateToStr(ChatGuardState.CareRaid)));
		Print(format(CG_INFO_PARTY, StateToStr(ChatGuardState.CareParty)));
		Print(format(CG_INFO_REGX, StateToStr(ChatGuardState.RegEx)));
		Print(format(CG_INFO_TRUST, StateToStr(ChatGuardState.TrustFriend)));
		Print(format(CG_INFO_MLINES, StateToStr(ChatGuardState.DisbaleMultiLines)));
		Print(format(CG_INFO_DEBUG, StateToStr(ChatGuardState.Debug)));
--		PrintFilter();
	else
		Print("  "..CG_INFO_DISABLE);
	end
end

-- 关键字过滤
function ProcFilter(cmd, data, moredata)
	if IsNull(cmd) then
		PrintFilter();
		return;
	end

	if (cmd == "add") then
		for i = 1,getn(ChatGuardState.Filter) do
			value = ChatGuardState.Filter[i];
			if (string.upper(value) == string.upper(data)) then
				return;
			end
		end
		table.insert(ChatGuardState.Filter, string.upper(data));
		PrintFilter();
	elseif (cmd == "del") then
		if (tonumber(data) > table.getn(ChatGuardState.Filter)) then
			Print(CG_INFO_OVERFLOW);
			return;
		end
		table.remove(ChatGuardState.Filter, tonumber(data));
		PrintFilter();
	elseif (cmd == "rep") then
		if IsNull(moredata) then
			ChatGuardHelp();
		else
			if (tonumber(data) > table.getn(ChatGuardState.Filter)) then
				Print(CG_INFO_OVERFLOW);
				return;
			end
			ChatGuardState.Filter[tonumber(data)] = string.upper(moredata);
			PrintFilter();
		end
	elseif (cmd == "clear") then
		ChatGuardState.Filter = {};
		PrintFilter();
	elseif (cmd == "reset") then
		ChatGuardState.Filter = CG_DEFAULT_FILTER;
		PrintFilter();
	elseif (cmd == "list") then
		PrintFilter();
	else
		ChatGuardHelp();
	end
end

-- 处理命令
function ChatGuardCmd(msg)
	local args = {};

	for value in string.gmatch(msg, "[^ ]+") do
		table.insert(args, string.lower(value));
	end

	if (IsNull(args[1]) or args[1] == "status") then
		ChatGuardStatus();
	elseif (args[1] == "help") then
		ChatGuardHelp();
	elseif (args[1] == "reset") then
		ChatGuardState.Alike = 100;
		ChatGuardState.Interval = 10;
		ChatGuardState.Disable = false;
		ChatGuardState.CareNormal = true;
		ChatGuardState.CareGuild = false;
		ChatGuardState.CareRaid = false;
		ChatGuardState.CareParty = false;
		ChatGuardState.Debug = false;
		ChatGuardStatus();
	elseif (args[1] == "on") then
		ChatGuardState.Disable = false;
		ChatGuardStatus();
	elseif (args[1] == "off") then
		ChatGuardState.Disable = true;
		ChatGuardStatus();
	elseif (args[1] == "like") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			ChatGuardState.Alike = tonumber(args[2]);
			if (ChatGuardState.Alike <= 0) then
				ChatGuardState.Disable = true;
			end
			ChatGuardStatus();
		end
	elseif (args[1] == "interval") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			ChatGuardState.Interval = tonumber(args[2]);
			if (ChatGuardState.Interval < 0) then
				ChatGuardState.Interval = 0;
			end
			ChatGuardStatus();
		end
	elseif (args[1] == "all") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareNormal = true;
				ChatGuardState.CareGuild = true;
				ChatGuardState.CareRaid = true;
				ChatGuardState.CareParty = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareNormal = false;
				ChatGuardState.CareGuild = false;
				ChatGuardState.CareRaid = false;
				ChatGuardState.CareParty = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "normal") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareNormal = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareNormal = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "whisper") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareWhisper = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareWhisper = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "say") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareSay = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareSay = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "guild") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareGuild = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareGuild = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "raid") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareRaid = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareRaid = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "party") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.CareParty = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.CareParty = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "filter") then
		local data = args[3];
		local moredata = args[4];
		if (args[2] == "add") then
			local _, dpos = string.find(msg, args[2].."[ ]*");
			data = string.sub(msg, dpos + 1);
		elseif (args[2] == "rep") then
			local _, dpos = string.find(msg, data.."[ ]*");
			moredata = string.sub(msg, dpos + 1);
		end
		ProcFilter(args[2], data, moredata);
	elseif (args[1] == "debug") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.Debug = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.Debug = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "regx") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.RegEx = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.RegEx = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "sucker") then
		if IsNull(args[2]) then
			Print(CG_INFO_SUCKER);
			Count = 0;
			for i = 1, getn(AlikeTable) do
				value = AlikeTable[i];
				if (value.Sucker) then
					Print("  |cff00ff00"..value.Name.."|r".."[|cffff0000"..value.SuckerMsg.."|r]");
					Count = Count + 1;
				end
			end
			Print(CG_INFO_TOTAL..Count);
		elseif (args[2] == "clear") then
			local i = 1;
			while (i <= getn(AlikeTable)) do
				if (AlikeTable[i].Sucker) then
					table.remove(AlikeTable, i);
				else
					i = i + 1;
				end
			end
--			AlikeTable = {};
			Print(CG_INFO_SUCKER);
			Print(CG_INFO_TOTAL.."0");
		else
			ChatGuardHelp();
		end
	elseif (args[1] == "trust") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.TrustFriend = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.TrustFriend = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	elseif (args[1] == "mlines") then
		if IsNull(args[2]) then
			ChatGuardHelp();
		else
			if (args[2] == "on") then
				ChatGuardState.DisbaleMultiLines = true;
				ChatGuardStatus();
			elseif (args[2] == "off") then
				ChatGuardState.DisbaleMultiLines = false;
				ChatGuardStatus();
			else
				ChatGuardHelp();
			end
		end
	end
end

-- 事件函数
-- 初始化数据之所以每个成员单独判断，是为了避免刚升级了新版本插件，
-- 而系统中已经保存了老版本的数据结构，此时结构不为NULL，只是新版本的成员为NULL
function ChatGuard_OnEvent()
	if (event == "VARIABLES_LOADED") then
--		Print(CG_INFO_LOADED);
		if (not ChatGuardState) then
			ChatGuardState = {};
		end
		if (ChatGuardState.Alike == nil) then
			ChatGuardState.Alike = 100;
		end
		if (ChatGuardState.Interval == nil) then
			ChatGuardState.Interval = 30;
		end
		if (ChatGuardState.Disable == nil) then
			ChatGuardState.Disable = false;
		end
		if (ChatGuardState.CareNormal == nil) then
			ChatGuardState.CareNormal = true;
		end
		if (ChatGuardState.CareGuild == nil) then
			ChatGuardState.CareGuild = false;
		end
		if (ChatGuardState.CareRaid == nil) then
			ChatGuardState.CareRaid = false;
		end
		if (ChatGuardState.CareParty == nil) then
			ChatGuardState.CareParty = false;
		end
		if (ChatGuardState.CareWhisper == nil) then
			ChatGuardState.CareWhisper = false;
		end
		if (ChatGuardState.CareSay == nil) then
			ChatGuardState.CareSay = false;
		end
		if (ChatGuardState.Debug == nil) then
			ChatGuardState.Debug = false;
		end

		if (ChatGuardState.Filter == nil) then
			ChatGuardState.Filter = CG_DEFAULT_FILTER;
		end
		if (ChatGuardState.RegEx == nil) then
			ChatGuardState.RegEx = true;
		end
		if (ChatGuardState.TrustFriend == nil) then
			ChatGuardState.TrustFriend = true;
		end

		if (ChatGuardState.DisbaleMultiLines == nil) then
		  ChatGuardState.DisbaleMultiLines = true;
		end
	end

	ChatFrame_OnEvent = CG_New_ChatFrame_OnEvent;
end

SlashCmdList["CHATGUARD"] = ChatGuardCmd;
SLASH_CHATGUARD1 = "/chatguard";
SLASH_CHATGUARD2 = "/cg";

local frame = CreateFrame("Frame", "ChatGuardFrame", UIParent);
frame:RegisterEvent("VARIABLES_LOADED");
frame:SetScript("OnEvent", ChatGuard_OnEvent);
