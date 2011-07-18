local E, C, L = unpack(EUI)
if not C["raid"].raidaurawatch == true then return end


E.buffids = {
	PRIEST = {
		{6788, "TOPRIGHT", {1, 0, 0}, true},			-- Weakened Soul
		{33076, "BOTTOMRIGHT", {0.2, 0.7, 0.2}},		-- Prayer of Mending
		{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, 			-- Renew
		{17, "TOPLEFT", {0.81, 0.85, 0.1}, true},		-- Power Word: Shield
		{10060, "RIGHT", {0.89, 0.1, 0.1}},				-- Power Infusion
		{33206, "LEFT", {0.89, 0.1, 0.1}, true},		-- Pain Suppress
		{47788, "LEFT", {0.86, 0.52, 0}, true},			-- Hand of Freedom
	},
	DRUID = {
		{774, "TOPRIGHT", {0.8, 0.4, 0.8}},				-- Rejuvenation
		{8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}},			-- Regrowth
		{33763, "TOPLEFT", {0.4, 0.8, 0.2}},			-- Lifebloom
		{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}},			-- Wild Growth
	},
	PALADIN = {
		{53563, "TOPRIGHT", {0.7, 0.3, 0.7}},			-- Beacon of Light
		{1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true},		-- Hand of Protection
		{1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true},	-- Hand of Freedom
		{1038, "BOTTOMRIGHT", {0.93, 0.75, 0}, true},	-- Hand of Salvation
	},
	SHAMAN = {
		{61295, "TOPRIGHT", {0.7, 0.3, 0.7}},			-- Riptide 
		{974, "BOTTOMLEFT", {0.2, 0.7, 0.2}, true},		-- Earth Shield
		{16236, "TOPLEFT", {0.4, 0.7, 0.2}},			-- Ancestral Fortitude
		{51945, "BOTTOMRIGHT", {0.7, 0.4, 0}},			-- Earthliving
	},
	ROGUE = {
		{57933, "TOPRIGHT", {0.89, 0.1, 0.1}},			-- Tricks of the Trade
	},
	DEATHKNIGHT = {
		{49016, "TOPRIGHT", {0.89, 0.89, 0.1}},			-- Unholy Frenzy
	},
	MAGE = {
		{54646, "TOPRIGHT", {0.2, 0.2, 1}},				-- Focus Magic
	},
	WARRIOR = {
		{59665, "TOPLEFT", {0.2, 0.2, 1}},				-- Vigilance
		{3411, "TOPRIGHT", {0.89, 0.1, 0.1}},			-- Intervene
	},
	HUNTER = {
		{34477, "TOPRIGHT", {0.2, 0.2, 1}},				-- Misdirection
	},
	WARLOCK = {
		{20707, "TOPRIGHT", {0.7, 0.32, 0.75}},			-- Soulstone Resurrection
	},
	ALL = {
		{23333, "LEFT", {1, 0, 0}, true}, 				-- Warsong flag, Horde
		{23335, 'LEFT', {0, 0, 1}, true},				-- Warsong flag, Alliance
		{34976, "LEFT", {1, 0, 0}, true}, 				-- Netherstorm Flag
		{64413, "RIGHT", {0.8, 0.2, 0}, true},			-- Protection of Ancient Kings
	},
}
	
-- Raid debuffs
E.debuffids = {
-- Baradin Hold
	-- Argaloth
	95173,	-- Consuming Darkness
-- Blackwing Descent
	-- Magmaw
	94679,	-- Parasitic Infection
	94617,	-- Mangle
	91911,	-- Constricting Chains
	-- Omintron Defense System
	91433,	-- Lightning Conductor
	91535,	-- Flamethrower
	80161,	-- Chemical Cloud
	92035,	-- Acquiring Target
	79835,	-- Poison Soaked Shell		
	91555,	-- Power Generator
	80094,	-- Fixate
	91521,	-- Incineration Security Measure
	92048,	-- Shadow Infusion
	92053,	-- Shadow Conductor
	-- Maloriak
	92754,	-- Engulfing Darkness
	77699,	-- Flash Freeze
	77760,	-- Biting Chill
	92971,	-- Consuming Flames
	92989,	-- Rend
	78617,	-- Fixate
	-- Atramedes
	92423,	-- Searing Flame
	92485,	-- Roaring Flame
	92407,	-- Sonic Breath
	78092,	-- Tracking
	-- Chimaeron
	82881,	-- Break
	89084,	-- Low Health
	-- Nefarian
	81114,	-- Magma
	94128,	-- Tail Lash
	79339,	-- Explosive Cinders
	79318,	-- Dominion
-- The Bastion of Twilight
	-- Halfus Wyrmbreaker
	83710,	-- Furious Roar
	39171,	-- Malevolent Strikes
	-- Valiona & Theralion
	86505,	-- Fabulous Flames
	86840,	-- Devouring Flames
	92878,	-- Blackout
	95639,	-- Engulfing Magic
	93051,	-- Twilight Shift
	92886,	-- Twilight Zone
	88518,	-- Twilight Meteorite
	-- Twilight Ascendant Council
	82660,	-- Burning Blood
	82665,	-- Heart of Ice
	82762,	-- Waterlogged
	83099,	-- Lightning Rod
	92488,	-- Gravity Crush
	83500,	-- Swirling Winds
	83581,	-- Grounded
	92505,	-- Frozen
	92511,	-- Hydro Lance
	92518,	-- Flame Torrent
	92075,	-- Gravity Core
	-- Cho'gall
	93187,	-- Corrupted Blood
	82125,	-- Corruption: Malformation
	82170,	-- Corruption: Absolute
	93200,	-- Corruption: Sickness
	82411,	-- Debilitating Beam
	91317,	-- Worshipping
	86028,	-- Cho's Blast
	86029,	-- Gall's Blast
	-- Sinestra
	92956,	-- Wrack
-- Throne of the Four Winds
	-- Conclave of Wind
		-- Nezir
		93131,	-- Ice Patch
		-- Anshal
		86206,	-- Soothing Breeze
		93122,	-- Toxic Spores
		-- Rohash
		93058,	-- Slicing Gale
		-- Al'Akir
		87873,	-- Static Shock
		93260,	-- Ice Storm
		87856,	-- Squall Line
		88427,	-- Electrocute
		93295,	-- Lightning Rod
	-- Other
	67479,	-- Impale
	5782,	-- Fear
	84853,	-- Dark Pool
	91325,	-- Shadow Vortex
}