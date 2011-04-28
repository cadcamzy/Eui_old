--[[===========================================================================
			yleaf (yaroot@gmail.com)
===========================================================================
Copyright (c) 2009 Toni Su
Copyright (c) 2009 Trond A Ekseth

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
===========================================================================]]
setglobal('BINDING_NAME_CLICK NoruFrame:LeftButton', 'Mount')
setglobal('BINDING_NAME_CLICK NoruDismountFrame:LeftButton', 'Dismount')

local locale = GetLocale()
local badZones = locale == 'zhCN' and {
	['达拉然'] = true,
	['冬拥湖'] = true,
} or locale == 'zhTW' and {
	['達拉然'] = true,
	['冬握湖'] = true,
} or {
	['Dalaran'] = true,
	['Wintergrasp'] = true,
}

local subExceptions = locale == 'zhCN' and {
	['克拉苏斯平台'] = true,
	['紫色天台'] = true,
	['达拉然下水道'] = true,
} or locale == 'zhTW' and {
	['卡薩斯平臺'] = true,
	['紫羅蘭頂閣'] = true,
	['城底區'] = true,
} or {
	['Krasus\' Landing'] = true,
	['Purple Parlor'] = true,
	['Underbelly'] = true,
}

local IsFlyable = IsFlyableArea
function IsFlyableArea()
	if( badZones[GetRealZoneText()] and not subExceptions[GetSubZoneText()] ) then
		return false
	else
		return IsFlyable()
	end
end


local mounts = {
	ground = {
		-- 100
		{
			23214,34767,23161,43688,16056,60114,60116,51412,58983,22719,16055,59572,
			17461,60118,60119,48027,22718,59785,59788,22720,22721,22717,22723,22724,
			59573,39315,34896,39316,34790,36702,17460,23509,59810,59811,61465,48778,
			61467,60136,60140,59802,59804,61469,61470,35713,49379,23249,34407,23248,
			35712,35714,23247,18991,17465,48025,59797,59799,17459,17450,55531,
			60424,16084,29059,16082,23246,41252,22722,579,16080,17481,39317,26656,
			34898,23510,23241,43900,23238,23229,23250,23220,23221,23239,23252,35025,
			23225,23219,23242,23243,23227,33660,35027,24242,42777,23338,23251,47037,
			35028,46628,23223,23240,23228,23222,48954,49322,24252,39318,34899,18992,
			61425,61447,42781,15779,54753,39319,16083,34897,16081,17229,59791,59793,
		},
		-- 60
		{
			13819,34769,5784,35022,6896,470,578,35020,10969,33630,6897,17463,50869,
			43899,50870,49378,34406,458,18990,6899,17464,6654,6648,6653,8395,17458,
			16060,35710,18989,6777,459,15780,17453,10795,10798,471,472,16058,35711,
			35018,17455,17456,34795,10873,17462,18363,8980,42776,10789,15781,8394,
			10793,16059,580,10796,17454,10799,6898,468,581,58983,48025
		},
		-- 0
		{
			30174
		},
	},

	flying = {
		-- 310
		{
			40192,59976,58615,44317,44744,3363,32345,60021,37015,49193,60024
		},
		-- 280
		{
			60025,61230,61229,59567,41514,59650,59568,59996,39803,59569,43927,
			41515,43810,51960,61294,39798,61309,41513,41516,39801,59570,59961,
			39800,39802,32242,32290,32295,61442,32292,32297,32289,32246,61444,
			61446,32296,60002,44151,59571,41517,41518,54729,46199,48025,28828,
		},
		-- 60
		{
			32244,32239,61451,44153,32235,32245,32240,32243,46197,48025
		},
	},

	aq40 = {
		-- 100
		{
			25953,26056,26054,26055
		},
	},
}

local player = {}
local _, class = UnitClass'player'

local function BuildDatabase()
	local list = {}
	player = {}
	for i=1, GetNumCompanions'MOUNT' do
		local _, spellName, spellId = GetCompanionInfo('MOUNT', i)
		--list[spellId] = spellName
		--list[spellId] = select(1, GetSpellInfo(spellId))
		list[spellId] = i
	end

	for type, skill in pairs(mounts) do
		for _, data in ipairs(skill) do
			local done
			for _, mount in ipairs(data) do
				if(list[mount]) then
					if(not player[type]) then player[type] = {} end
					table.insert(player[type], list[mount])
					done = true
				end
			end

			if(done) then break end
		end
	end
end

SLASH_NORU_MOUNT1 = '/mount'
SLASH_NORU_MOUNT2 = '/noru'
SlashCmdList['NORU_MOUNT'] = function()
	if IsMounted() then Dismount()
	else
		if not InCombatLockdown() then
			local flying = player.flying
			local ground = player.ground
			if IsFlyableArea() and flying then
				CallCompanion('MOUNT', flying[random(#flying)])
			elseif ground then
				CallCompanion('MOUNT', ground[random(#ground)])
			end
		end
	end
end

local noruframe = CreateFrame('Button', 'NoruFrame', UIParent, 'SecureActionButtonTemplate')
noruframe:SetAttribute('type', 'macro')

local disframe = CreateFrame('Button', 'NoruDismountFrame', UIParent, 'SecureActionButtonTemplate')
disframe:SetAttribute('type', 'macro')
disframe:SetAttribute('macrotext', '/cancelform\n/dismount')

local function SetMacroText(self, event, ...)
	if InCombatLockdown() then
		return self:RegisterEvent'PLAYER_REGEN_ENABLED'
	end
	if event == 'PLAYER_REGEN_ENABLED' then self:UnregisterEvent'PLAYER_REGEN_ENABLED' end
	
	local macrotext
	if class == 'SHAMAN' then
		macrotext = ('/dismount [combat]' ..
					'/cast [mod:shift][combat]'.. GetSpellInfo(2645) ..
					'\n/stopmacro [combat][mod:shift]'..
					'\n/mount')
	elseif class == 'DRUID' then
		if IsFlyableArea() then
			macrotext = ('/stopmacro [combat,flying]' ..
						'\n/cast [swimming]!' .. GetSpellInfo(1066) ..
							';[combat]!' .. GetSpellInfo(783) ..
							';[flyable,nocombat]!' .. GetSpellInfo(40120) ..
						'\n/stopmacro [combat][mounted][flyable]' ..
						'\n/cancelform' ..
						'\n/mount'
			)
		else
			macrotext = ('/stopmacro [combat,flying]' ..
						'\n/cast [swimming]!' .. GetSpellInfo(1066) ..
							';[combat]!' .. GetSpellInfo(783) ..
						'\n/stopmacro [combat][mounted]' ..
						'\n/cancelform' ..
						'\n/mount'
			)
		end
	else
		macrotext = '/mount'
	end
	noruframe:SetAttribute('macrotext', macrotext)
end

local addon = CreateFrame'Frame'
addon:SetScript('OnEvent', function(self, event, ...)
	if event == 'PLAYER_LOGIN' or event == 'COMPANION_LEARNED' then
		BuildDatabase(self, event, ...)
	end
	SetMacroText(self, event, ...)
end)

addon:RegisterEvent'PLAYER_LOGIN'
addon:RegisterEvent'COMPANION_LEARNED'
if class == 'DRUID' then
	addon:RegisterEvent'ZONE_CHANGED'
	addon:RegisterEvent'ZONE_CHANGED_INDOORS'
	addon:RegisterEvent'ZONE_CHANGED_NEW_AREA'
	addon:RegisterEvent'WORLD_MAP_UPDATE'
end
