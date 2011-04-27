local E, C = unpack(select(2, ...))
if C["other"].ratings ~= true then return end

local string_find = string.find
local string_match = string.match
local string_len = string.len
local string_sub = string.sub
local string_replace = string.replace
local string_lower = string.lower
local string_format = string.format
local string_gsub = string.gsub
local pairs = pairs
local next = next
local tonumber = tonumber
local select = select

RatingsDB = {
	forceLevel = nil,
	format = " ($V@$L)",
}

local SEPARATORS, PATTERNS, STATS
if GetLocale() == "enUS" then
	SEPARATORS = {
		[","] = true,
		[" and "] = true,
		["/"] = true,
		[". "] = true,
	--	[" for "] = true,
		["&"] = true,
	--	[":"] = true,
	}
	PATTERNS = {
		[" by (%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = true,
		["add.-(%d+)"] = true,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"defense rating", CR_DEFENSE_SKILL},
		{"dodge rating", CR_DODGE},
		{"block rating", CR_BLOCK},
		{"parry rating", CR_PARRY},
		{"ranged critical strike rating", CR_CRIT_RANGED},
		{"ranged critical hit rating", CR_CRIT_RANGED},
		{"ranged critical rating", CR_CRIT_RANGED},
		{"ranged crit rating", CR_CRIT_RANGED},
		{"critical strike rating", CR_CRIT_MELEE},
		{"critical hit rating", CR_CRIT_MELEE},
		{"critical rating", CR_CRIT_MELEE},
		{"crit rating", CR_CRIT_MELEE},
		{"ranged hit rating", CR_HIT_RANGED},
		{"hit rating", CR_HIT_MELEE},
		{"resilience", CR_CRIT_TAKEN_MELEE},
		{"ranged haste rating", CR_HASTE_RANGED},
		{"haste rating", CR_HASTE_MELEE},
		{"skill rating", CR_WEAPON_SKILL},
		{"expertise rating", CR_EXPERTISE},
		{"hit avoidance rating", CR_HIT_TAKEN_MELEE},
		{"armor penetration rating", CR_ARMOR_PENETRATION},
	}
elseif GetLocale() == "frFR" then
	SEPARATORS = {
		["/"] = true,
		[" et "] = true,
		[","] = true,
		[". "] = true,
	}
	PATTERNS = {
		[" de (%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["(%d+) \195\160 "] = true,
		["(%d+) au"] = false,
	}
	STATS = {
		{"score de défense", CR_DEFENSE_SKILL},
		{"score d'esquive", CR_DODGE},
		{"score de blocage", CR_BLOCK},
		{"score de parade", CR_PARRY},
		{"score de coup critique à distance", CR_CRIT_RANGED},
		{"score de critique à distance", CR_CRIT_RANGED},
--~ 		{"ranged critical rating", CR_CRIT_RANGED},
--~ 		{"ranged crit rating", CR_CRIT_RANGED},
		{"score de coup critique", CR_CRIT_MELEE},
		{"score de critique", CR_CRIT_MELEE},
--~ 		{"critical rating", CR_CRIT_MELEE},
--~ 		{"crit rating", CR_CRIT_MELEE},
		{"score de toucher à distance", CR_HIT_RANGED},
		{"score de toucher", CR_HIT_MELEE},
		{"résilience", CR_CRIT_TAKEN_MELEE},
		{"score de hâte à distance", CR_HASTE_RANGED},
		{"score de hâte", CR_HASTE_MELEE},
		{"score de la compétence", CR_WEAPON_SKILL},
		{"score d'expertise", CR_EXPERTISE},
		{"expertise", CR_EXPERTISE},
		{"score d'évitement des coups", CR_HIT_TAKEN_MELEE},
		{"score de pénétration d'armure", CR_ARMOR_PENETRATION},
	}
elseif GetLocale() == "deDE" then
	SEPARATORS = {
		["/"] = true,
		[" und "] = true,
		[","] = true,
		[". "] = true,
		[" f\195\188r "] = true,
		["&"] = true,
		[":"] = true,
	}
	PATTERNS = {
		[" um (%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["verleiht.-(%d+)"] = true,
		["(%d+) erhöhen."] = true,
		["(%d+)([^%d%%|]+)"] = true,
	}
	STATS = {
		{"verteidigungswertung", CR_DEFENSE_SKILL},
		{"ausweichwertung", CR_DODGE},
		{"blockwertung", CR_BLOCK},
		{"parierwertung", CR_PARRY},
		{"kritische distanztrefferwertung", CR_CRIT_RANGED},
		{"kritische trefferwertung", CR_CRIT_MELEE},
		{"kritische zaubertrefferwertung", CR_CRIT_SPELL},
		{"trefferwertung", CR_HIT_RANGED},
		{"trefferwertung", CR_HIT_MELEE},
		{"zaubertrefferwertung", CR_HIT_SPELL},
		{"abh\195\164rtung", CR_CRIT_TAKEN_MELEE},
		{"zaubertempowertung", CR_HASTE_SPELL},
		{"distanztempowertung", CR_HASTE_RANGED},
		{"angriffstempowertung", CR_HASTE_MELEE},
		{"nahkampftempowertung", CR_HASTE_MELEE},
		{"tempowertung", CR_HASTE_MELEE},
		{"waffenkundewertung", CR_EXPERTISE},
		{"r\195\188stungsdurchschlagwert", CR_ARMOR_PENETRATION},
	}
elseif GetLocale() == "ruRU" then
	SEPARATORS = {
		[","] = true,
		[" и "] = true,
		["/"] = true,
		[". "] = true,
		[" для "] = true,
		["&"] = true,
	}
	PATTERNS = {
		[" на (%d+)"] = true,
		["([%+%-]%d+)"] = true,
		[" увеличена на (%d+)"] = true,
		["(%d+) к "] = true,
		["дополнительно (%d+)"] = true,
		["увеличение (%d+)"] =  true,
		["на (%d+)([^%d%%|]+)"] = true,
	}
	STATS = {
		{"рейтинг защиты",CR_DEFENSE_SKILL},
		{"рейтингу защиты",CR_DEFENSE_SKILL},
		{"рейтинга защиты",CR_DEFENSE_SKILL},
		{"рейтинг уклонения",CR_DODGE},
		{"рейтингу уклонения",CR_DODGE},
		{"рейтинга уклонения",CR_DODGE},
		{"рейтинг блокирования щитом",CR_BLOCK},
		{"рейтинга блокирования щитом",CR_BLOCK},
		{"рейтингу блокирования щитом",CR_BLOCK},
		{"увеличение рейтинга блокирования щита на",CR_BLOCK},
		{"рейтинга блока",CR_BLOCK},
		{"рейтинг парирования",CR_PARRY},
		{"рейтинга парирования",CR_PARRY},
		{"рейтингу парирования",CR_PARRY},

		{"рейтинг критического удара %(заклинания%)",CR_CRIT_SPELL},
		{"рейтингу критического удара %(заклинания%)",CR_CRIT_SPELL},
		{"рейтинга критического удара %(заклинания%)",CR_CRIT_SPELL},
		{"рейтинга критического удара заклинаниями",CR_CRIT_SPELL},
		{"рейтингу критического удара заклинаниями",CR_CRIT_SPELL},
		{"рейтинг критического удара заклинаниями",CR_CRIT_SPELL},
		{"рейтинг критического удара",CR_CRIT_MELEE},
		{"рейтинг критического эффекта",CR_CRIT_MELEE},
		{"рейтингу критического удара",CR_CRIT_MELEE},
		{"рейтинга критического удара",CR_CRIT_MELEE},
		{"рейтинг крит. удара оруж. ближнего боя",CR_CRIT_MELEE},

		{"рейтинг меткости %(заклинания%)",CR_HIT_SPELL},
		{"рейтингу меткости %(заклинания%)",CR_HIT_SPELL},
		{"рейтинга меткости %(заклинания%)",CR_HIT_SPELL},
		{"рейтингу меткости заклинаний",CR_HIT_SPELL},
		{"рейтинга нанесения удара ближнего боя",CR_HIT_MELEE},
		{"рейтинг меткости",CR_HIT_MELEE},
		{"рейтинга меткости",CR_HIT_MELEE},
		{"рейтингу меткости",CR_HIT_MELEE},

		{"рейтинг устойчивости",CR_CRIT_TAKEN_MELEE},
		{"рейтингу устойчивости",CR_CRIT_TAKEN_MELEE},
		{"рейтинга устойчивости",CR_CRIT_TAKEN_MELEE},

		{"рейтинг скорости %(заклинания%)",CR_HASTE_SPELL},
		{"рейтингу скорости %(заклинания%)",CR_HASTE_SPELL},
		{"рейтинга скорости %(заклинания%)",CR_HASTE_SPELL},
		{"скорости наложения заклинаний",CR_HASTE_SPELL},
		{"скорость наложения заклинаний",CR_HASTE_SPELL},
		{"рейтинг скорости",CR_HASTE_MELEE},
		{"рейтингу скорости",CR_HASTE_MELEE},
		{"рейтинга скорости",CR_HASTE_MELEE},

		{"рейтинг мастерства",CR_EXPERTISE},
		{"рейтингу мастерства",CR_EXPERTISE},
		{"рейтинга мастерства",CR_EXPERTISE},

		{"рейтинг пробивания брони",CR_ARMOR_PENETRATION},
	}
elseif GetLocale() == "zhTW" then
	-- Thanks vivianalive http://wow.curse.com/downloads/wow-addons/details/ratings.aspx#714023
	SEPARATORS = {
		["，"] = true,
		[" 和"] = true,
		["。"] = true,
		["："] = true,
	}
	PATTERNS = {
		["提高(%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = false,
		["add.-(%d+)"] = false,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"防禦等級", CR_DEFENSE_SKILL},
		{"閃躲等級", CR_DODGE},
		{"格擋等級", CR_BLOCK},
		{"招架等級", CR_PARRY},
		{"遠程攻擊致命一擊等級", CR_CRIT_RANGED},
		{"致命一擊等級", CR_CRIT_MELEE},
		{"遠程命中等級", CR_HIT_RANGED},
		{"命中等級", CR_HIT_MELEE},
		{"韌性", CR_CRIT_TAKEN_MELEE},
		{"遠程攻擊加速等級", CR_HASTE_RANGED},
		{"加速等級", CR_HASTE_MELEE},
		{"技能等級", CR_WEAPON_SKILL},
		{"熟練等級", CR_EXPERTISE},
		{"命中迴避概率", CR_HIT_TAKEN_MELEE},
		{"護甲穿透等級", CR_ARMOR_PENETRATION},
	}
elseif GetLocale() == "zhCN" then
	SEPARATORS = {
		["，"] = true,
		["和"] = true,
		["。"] = true,
		["："] = true,
	}
	PATTERNS = {
		["提高(%d+)"] = true,
		["([%+%-]%d+)"] = false,
		["grant.-(%d+)"] = false,
		["add.-(%d+)"] = false,
		["(%d+)([^%d%%|]+)"] = false,
	}
	STATS = {
		{"防御等级", CR_DEFENSE_SKILL},
		{"躲闪等级", CR_DODGE},
		{"格挡等级", CR_BLOCK},
		{"招架等级", CR_PARRY},
		{"远程爆击等级", CR_CRIT_RANGED},
		{"爆击等级", CR_CRIT_MELEE},
		{"远程命中等级", CR_HIT_RANGED},
		{"命中等级", CR_HIT_MELEE},
		{"韧性等级", CR_CRIT_TAKEN_MELEE},
		{"远程急速等级", CR_HASTE_RANGED},
		{"急速等级", CR_HASTE_MELEE},
		{"武器技能等级", CR_WEAPON_SKILL},
		{"精准等级", CR_EXPERTISE},
		{"回避等级", CR_HIT_TAKEN_MELEE},
		{"护甲穿透等级", CR_ARMOR_PENETRATION},
	}
else
	DisableAddOn("Ratings")
	return
end

PATTERNS["|cff00ff00%+(%d+)|r"] = true
PATTERNS["|cffff2020%-(%d+)|r"] = true

local Ratings = {}

do
	local hook_otsi = function (...) Ratings:OnTooltipSetItem(...) end
	local hook_otc = function (...) Ratings:OnTooltipCleared(...) end
	function Ratings:HookTooltip(tt)
		tt:HookScript("OnTooltipSetItem", hook_otsi)
		tt:HookScript("OnTooltipCleared", hook_otc)
	end
end

local regions_set = {}
local function clear_regions(...)
	for i = 1, select("#", ...) do
		local region = select(i, ...)
		regions_set[region] = nil
	end
end

function Ratings:OnTooltipSetItem(tt)
	self:HandleFontStrings(tt:GetRegions())
end

function Ratings:OnTooltipCleared(tt)
	clear_regions(tt:GetRegions())
end

function Ratings:HandleFontStrings(...)
	for i = 1, select("#", ...) do
		local region = select(i, ...)
		if region.GetText and region:IsShown() and not regions_set[region] then
			regions_set[region] = true
			region:SetText(self:ReplaceText(region:GetText()))
		end
	end
end

do
	local function get_next_chunk(text, p)
		local lstart, lend
		for sep in pairs(SEPARATORS) do
			local s, e = string_find(text, sep, p, true)
			if s then
				if not lstart or lstart > s then
					lstart, lend = s, e
				end
			end
		end
		if not lstart then
			return string_sub(text, p), -1
		else
			return string_sub(text, p, lstart - 1), lend + 1
		end
	end

	local replacements = {}
	function Ratings:ReplaceText(text)
		if not text or not text:find("%d") then return text end
		local pos = 1
		while pos > 0 do
			local sub
			sub, pos = get_next_chunk(text, pos)
			replacements[sub] = self:GetReplacementText(sub)
		end
		while true do
			local sub, rep = next(replacements)
			if not sub then return text end
			replacements[sub] = nil
			text = string_replace(text, sub, rep)
		end
	end

	function Ratings:GetReplacementText(text)
		local lower_text = string_lower(text)
		for pattern, after in pairs(PATTERNS) do
			local value, partial = string_match(lower_text, pattern)
			if value then
				if tonumber(partial) then
					partial, value = value, partial
				end
				local check = partial or lower_text
				for _, info in pairs(STATS) do
					local stat, id = info[1], info[2]
					if string_find(check, stat, 1, true) then
						local bonus = self:GetRatingBonus(id, tonumber(value))
						if not bonus then return end
						if after then
							return string_replace(text, value, value .. bonus)
						else
							local s, e = string_find(lower_text, stat, 1, true)
							stat = string_sub(text, s, e)
							return string_replace(text, stat, stat .. bonus)
						end
					end
				end
			end
		end
	end
end

do
	local CombatRatingMap = {
		[CR_WEAPON_SKILL] = 2.5,
		[CR_DEFENSE_SKILL] = 1.5,
		[CR_DODGE] = 13.8,
		[CR_PARRY] = 13.8,
		[CR_BLOCK] = 5,
		[CR_HIT_MELEE] = 10,
		[CR_CRIT_MELEE] = 14,
		[CR_HIT_RANGED] = 10,
		[CR_CRIT_RANGED] = 14,
		[CR_HASTE_MELEE] = 10,
		[CR_HASTE_RANGED] = 10,
		[CR_HIT_SPELL] = 8,
		[CR_CRIT_SPELL] = 14,
		[CR_HASTE_SPELL] = 10,
		[CR_CRIT_TAKEN_MELEE] = 28.75,
		[CR_HIT_TAKEN_MELEE] = 10,
		[CR_EXPERTISE] = 2.5,
		[CR_ARMOR_PENETRATION] = 4.2682925137607,
	}

	local lowerlimit34 = {
		[CR_DEFENSE_SKILL] = true,
		[CR_DODGE] = true,
		[CR_PARRY] = true,
		[CR_BLOCK] = true,
		[CR_HIT_TAKEN_MELEE] = true,
		[CR_HIT_TAKEN_SPELL] = true,
	}

	local ratingMultiplier = setmetatable({},{
		__index = function (self, level)
			--[[
			The following calculations are based on Whitetooth's calculations:
			http://www.wowinterface.com/downloads/info5819-Rating_Buster.html
			]]
			local value
			if level < 10 then
				value = 26
			elseif level <= 60 then
				value = 52 / (level - 8)
			elseif level <= 70 then
				value = (262-3*level) / 82
			elseif level <= 80 then
				value = 1 / ((82/52)*(131/63)^((level-70)/10))
			end
			self[level] = value
			return value
		end,
	})

	local hasteBonusClasses = {
		DEATHKNIGHT = true,
		DRUID = true,
		PALADIN = true,
		SHAMAN = true,
	}

	local spellBasedClasses = {
		PRIEST = "spell",
		MAGE = "spell",
		WARLOCK = "spell",
		HUNTER = "ranged",
	}

	local modifiedRatings = {
		spell = {
			[CR_HIT_MELEE] = CR_HIT_SPELL,
			[CR_CRIT_MELEE] = CR_CRIT_SPELL,
			[CR_HASTE_MELEE] = CR_HASTE_SPELL,
		},
		ranged = {
			[CR_HIT_MELEE] = CR_HIT_RANGED,
			[CR_CRIT_MELEE] = CR_CRIT_RANGED,
			[CR_HASTE_MELEE] = CR_HASTE_RANGED,
		},
	}

	function Ratings:GetModifier()
		local modifier = RatingsDB.modifier
		if not modifier then
			local class = select(2, UnitClass"player")
			modifier = spellBasedClasses[class] or "melee"
			RatingsDB.modifier = modifier
		end
		return modifier
	end

	function Ratings:GetClassRatingType(base_type)
		local modifiers = modifiedRatings[self:GetModifier()]
		return modifiers and modifiers[base_type] or base_type
	end

	function Ratings:GetRatingBonus(type, value)
		type = self:GetClassRatingType(type)
		local F = CombatRatingMap[type]
		if not F then return end

		local level = RatingsDB.forceLevel or UnitLevel"player"
		local _, class = UnitClass"player"


		if level < 34 and lowerlimit34[type] then level = 34 end

		if type == CR_HASTE_MELEE then
			if hasteBonusClasses[class] then
				value = value * 1.3 -- or F /= 1.3
			end
		end

		local bonus = value / F * ratingMultiplier[level]
		return self:Format(bonus, level, type > 2 and type ~= 24)
	end
end

do
	local format_table = {}
	function Ratings:Format(bonus, level, has_percent)
		if has_percent then
			format_table.V = string_format("%.2f%%", bonus)
		else
			format_table.V = string_format("%.2f", bonus)
		end
		format_table.L = tostring(level)
		return string_gsub(RatingsDB.format, "%$([A-Z])", format_table)
	end
end

Ratings:HookTooltip(GameTooltip)
Ratings:HookTooltip(ItemRefTooltip)
Ratings:HookTooltip(ShoppingTooltip1)
Ratings:HookTooltip(ShoppingTooltip2)

_G.Ratings = Ratings
