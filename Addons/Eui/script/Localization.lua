--[[
        Chinese Local : CWDG Translation Team CondyWl
        CWDG site: http://cwowaddon.com
        $Rev$
        $Date$
]]
--2009.10.04
if (GetLocale() == "zhCN") then
------------------------------------------------------------------------------
-- Simplified Chinese localization
------------------------------------------------------------------------------
	--TipTacTalents.lua
	TTT_NoTalents_Main = '主天赋:|cffffffff ';
	TTT_NoTalents_Sec = '副天赋:|cff808069 ';
	TTT_NoTalents = "无天赋";
	TTT_Talents_Loading = "读取中……";	
elseif (GetLocale() == "zhTW") then
------------------------------------------------------------------------------
-- Traditional Chinese localization 
------------------------------------------------------------------------------
	--TipTacTalents.lua
	TTT_NoTalents_Main = '主天賦:|cffffffff ';
	TTT_NoTalents_Sec = '副天賦:|cff808069 ';
	TTT_NoTalents = "無天賦";
	TTT_Talents_Loading = "讀取中……";
else
------------------------------------------------------------------------------
-- English localization (default)
------------------------------------------------------------------------------
	--TipTacTalents.lua
	TTT_NoTalents_Main = 'Talents:|cffffffff ';
	TTT_NoTalents_Sec = 'Sec spec:|cffffffff ';
	TTT_NoTalents = "No Talents";
	TTT_Talents_Loading = " Loading...";
end