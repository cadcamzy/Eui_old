
local _, YssBossLoot = ...

local L = LibStub("AceLocale-3.0"):GetLocale("YssBossLoot", true)
local BZ = LibStub("LibBabble-Zone-3.0", true):GetLookupTable()


------------------------------------------------------------
-------------------------Map Types--------------------------
------------------------------------------------------------
YssBossLoot.MapTypes = {
	['Dungeon'] = L['Dungeon'],
	['Raid'] = L['Raid'],
	['Battlegrounds'] = BATTLEGROUNDS,
}

YssBossLoot.Ext = {
	"Classic",
	"The Burning Crusade",
	"Wrath of the Lich King",
	"Cataclysm",
}

------------------------------------------------------------
-------------------------Map Levels--------------------------
------------------------------------------------------------
YssBossLoot.MapLevels = {
	["Dungeon"] = {
		["Cataclysm"] = {
			["The Deadmines"] = "17|20";
			["Shadowfang Keep"] = "18|21";
			["Throne of the Tides"] = "80|83";
			["Blackrock Caverns"] = "80|83";
			["Grim Batol"] = "84|85";
			["Halls of Origination"] = "84|85";
			["Lost City of the Tol'vir"] = "84|85";
			["The Stonecore"] = "81|85";
			["The Vortex Pinnacle"] = "81|85";
			["Zul'Aman"] = "85|85";
			["Zul'Gurub"] = "85|85";
		};
		["Wrath of the Lich King"] = {
			["The Culling of Stratholme"] = "79|80";
			["Azjol-Nerub"] = "73|73";
			["Halls of Reflection"] = "79|80";
			["Drak'Tharon Keep"] = "74|76";
			["Trial of the Champion"] = "79|80";
			["Utgarde Keep"] = "69|72";
			["Halls of Stone"] = "77|79";
			["Pit of Saron"] = "79|80";
			["The Forge of Souls"] = "79|80";
			["Utgarde Pinnacle"] = "79|80";
			["The Oculus"] = "79|80";
			["Ahn'kahet: The Old Kingdom"] = "73|75";
			["The Nexus"] = "71|73";
			["The Violet Hold"] = "75|77";
			["Halls of Lightning"] = "79|80";
			["Gundrak"] = "76|78";
		};
		["The Burning Crusade"] = {
			["The Steamvault"] = "67|75";
			["Shadow Labyrinth"] = "67|75";
			["Auchenai Crypts"] = "65|67";
			["The Blood Furnace"] = "61|63";
			["Hellfire Ramparts"] = "59|62";
			["The Shattered Halls"] = "67|75";
			["Old Hillsbrad Foothills"] = "66|68";
			["Mana-Tombs"] = "64|66";
			["Sethekk Halls"] = "67|68";
			["The Botanica"] = "67|75";
			["The Underbog"] = "63|65";
			["The Mechanar"] = "67|75";
			["The Slave Pens"] = "62|64";
			["The Black Morass"] = "68|75";
			["The Arcatraz"] = "68|75";
			["Magisters' Terrace"] = "70|70";
		};
		["Classic"] = {
			["Dire Maul"] = "55|65";
			["The Stockade"] = "22|25";
			["Blackrock Spire"] = "57|63";
			["Razorfen Downs"] = "34|37";
			["Scarlet Monastery"] = "32|35";
			["Scholomance"] = "55|65";
			["Ragefire Chasm"] = "15|16";
			["Blackfathom Deeps"] = "21|24";
			["Razorfen Kraul"] = "24|27";
			["Gnomeregan"] = "25|28";
			["Wailing Caverns"] = "17|20";
			["Uldaman"] = "37|40";
			["Sunken Temple"] = "47|50";
			["Blackrock Depths"] = "53|56";
			["Stratholme"] = "55|65";
			["Maraudon"] = "45|48";
			["Zul'Farrak"] = "43|47";
		};
	};
	["Raid"] = {
		["Cataclysm"] = {
			["Baradin Hold"] = "85|88";
			["Blackwing Descent"] = "85|88";
			["The Bastion of Twilight"] = "85|88";
			["Throne of the Four Winds"] = "85|88";
		};
		["Wrath of the Lich King"] = {
			["Ulduar"] = "80|83";
			["Icecrown Citadel"] = "80|83";
			["The Obsidian Sanctum"] = "80|83";
			["Vault of Archavon"] = "80|83";
			["The Ruby Sanctum"] = "80|83";
			["Onyxia's Lair"] = "80|83";
			["Naxxramas"] = "80|83";
			["Trial of the Crusader"] = "80|83";
			["The Eye of Eternity"] = "80|83";
		};
		["The Burning Crusade"] = {
			["The Eye"] = "70|73";
			["Serpentshrine Cavern"] = "70|73";
			["Gruul's Lair"] = "70|73";
			["Karazhan"] = "70|73";
			["Magtheridon's Lair"] = "70|73";
			["Black Temple"] = "70|73";
			["Hyjal Summit"] = "70|73";
			["Sunwell Plateau"] = "70|73";
		};
		["Classic"] = {
			["Blackwing Lair"] = "60|63";
			["Ruins of Ahn'Qiraj"] = "60|63";
			["Temple of Ahn'Qiraj"] = "60|63";
			["Molten Core"] = "60|63";
		};
	};
	["Battlegrounds"] = {
		["Strand of the Ancients"] = "71|80";
		["Arathi Basin"] = "20|80";
		["Warsong Gulch"] = "10|80";
		["Isle of Conquest"] = "71|80";
		["Eye of the Storm"] = "61|80";
		["Alterac Valley"] = "51|80";
	};
}

------------------------------------------------------------
----------------------Map Zone ID's--------------------------
------------------------------------------------------------
YssBossLoot.IDs = {}
YssBossLoot.IDs.Dungeon = {
	["Throne of the Tides"] = 767,
	["Blackrock Caverns"] = 753,
	["Grim Batol"] = 757,
	["Halls of Origination"] = 759,
	["Lost City of the Tol'vir"] = 747,
	["The Stonecore"] = 768,
	["The Vortex Pinnacle"] = 769,
	["The Culling of Stratholme"] = 521,
	["Azjol-Nerub"] = 533,
	["Halls of Reflection"] = 603,
	["Drak'Tharon Keep"] = 534,
	["Trial of the Champion"] = 542,
	["Utgarde Keep"] = 523,
	["Halls of Stone"] = 526,
	["Pit of Saron"] = 602,
	["The Forge of Souls"] = 601,
	["Utgarde Pinnacle"] = 524,
	["The Oculus"] = 528,
	["Ahn'kahet: The Old Kingdom"] = 522,
	["The Nexus"] = 520,
	["The Violet Hold"] = 536,
	["Halls of Lightning"] = 525,
	["Gundrak"] = 530,
	["The Steamvault"] = 727,
	["Shadow Labyrinth"] = 724,
	["Auchenai Crypts"] = 722,
	["The Blood Furnace"] = 725,
	["Hellfire Ramparts"] = 797,
	["The Shattered Halls"] = 710,
	["Old Hillsbrad Foothills"] = 734,
	["Mana-Tombs"] = 732,
	["Sethekk Halls"] = 723,
	["The Botanica"] = 729,
	["The Underbog"] = 726,
	["The Mechanar"] = 730,
	["The Slave Pens"] = 728,
	["The Black Morass"] = 733,
	["The Arcatraz"] = 731,
	["Magisters' Terrace"] = 798,
	["Dire Maul"] = 699,
	["The Stockade"] = 690,
	["Blackrock Spire"] = 721,
	["Razorfen Downs"] = 760,
	["The Deadmines"] = 756,
	["Scarlet Monastery"] = 762,
	["Scholomance"] = 763,
	["Ragefire Chasm"] = 680,
	["Blackfathom Deeps"] = 688,
	["Shadowfang Keep"] = 764,
	["Razorfen Kraul"] = 761,
	["Gnomeregan"] = 691,
	["Wailing Caverns"] = 749,
	["Uldaman"] = 692,
	["Sunken Temple"] = 687,
	["Blackrock Depths"] = 704,
	["Stratholme"] = 765,
	["Maraudon"] = 750,
	["Zul'Farrak"] = 686,
	["Zul'Aman"] = 781,
	["Zul'Gurub"] = 793,
}

YssBossLoot.IDs.Raid = {
	["Baradin Hold"] = 752;
	["Blackwing Descent"] = 754;
	["The Bastion of Twilight"] = 758;
	["Throne of the Four Winds"] = 773;
	["Ulduar"] = 529,
	["Icecrown Citadel"] = 604,
	["The Obsidian Sanctum"] = 531,
	["Vault of Archavon"] = 532,
	["The Ruby Sanctum"] = 609,
	["Onyxia's Lair"] = 718,
	["Naxxramas"] = 535,
	["Trial of the Crusader"] = 543,
	["The Eye of Eternity"] = 527,
	--["The Eye"] = "70|73",
	--["Serpentshrine Cavern"] = "70|73",
	["Gruul's Lair"] = 776,
	["Karazhan"] = 799,
	["Magtheridon's Lair"] = 779,
	--["Black Temple"] = "70|73",
	["Hyjal Summit"] = 775,
	["Sunwell Plateau"] = 789,
	["Blackwing Lair"] = 755,
	["Ruins of Ahn'Qiraj"] = 717,
	["Temple of Ahn'Qiraj"] = 766,
	["Molten Core"] = 696,
}

YssBossLoot.IDs.Battlegrounds = {
	["Alterac Valley"] = 401,
	["Arathi Basin"] = 461,
	["Eye of the Storm"] = 482,
	["Strand of the Ancients"] = 512,
	["Warsong Gulch"] = 443,
	["Isle of Conquest"] = 540,
}

YssBossLoot.IDs.type = {}
YssBossLoot.IDs.rDungeon = {}
for k, v in pairs(YssBossLoot.IDs.Dungeon) do
	YssBossLoot.IDs.rDungeon[v] = k
	YssBossLoot.IDs.type[v] = 'Dungeon'
end
YssBossLoot.IDs.rRaid = {}
for k, v in pairs(YssBossLoot.IDs.Raid) do
	YssBossLoot.IDs.rRaid[v] = k
	YssBossLoot.IDs.type[v] = 'Raid'
end
YssBossLoot.IDs.rBattlegrounds = {}
for k, v in pairs(YssBossLoot.IDs.Battlegrounds) do
	YssBossLoot.IDs.rBattlegrounds[v] = k
	YssBossLoot.IDs.type[v] = 'Battlegrounds'
end

------------------------------------------------------------
-------------------------Map Bosses-------------------------
------------------------------------------------------------
YssBossLoot.Bosses = {}
YssBossLoot.Bosses.Dungeon = { -- format is maplevel1:map1X:map1Y|maplevel2:map2X:map2Y...
	["Ahn'kahet: The Old Kingdom"] = {
		["Amanitar"]="1:6685:7842",
		["Elder Nadox"]="1:6928:2744",
		["Herald Volazj"]="1:2362:5056|2:3992:5117",
		["Jedoga Shadowseeker"]="1:4827:7343|2:6749:7586",
		["Prince Taldaram"]="1:6279:4959",
	},
	["Drak'Tharon Keep"] = {
		["King Dred"]="1:6093:8657",
		["Novos the Summoner"]="1:6960:4740",
		["The Prophet Tharon'ja"]="2:4754:1345",
		["Trollgore"]="1:5663:1795",
	},
	["Azjol-Nerub"] = {
		["Krik'thir the Gatewatcher"]="3:5027:4470",
		["Hadronox"]="2:4335:5919",
		["Anub'arak"]="1:6203:4839",
	},
	["Gundrak"] = {
		["Drakkari Elemental"]="1:4649:6540",
		["Eck the Ferocious"]="1:2532:7015",
		["Gal'darah"]="1:4657:2781",
		["Moorabi"]="1:3959:4934",
		["Slad'ran"]="1:5372:4886",
	},
	["Halls of Lightning"] = {
		["General Bjarngrim"]="1:4357:3705",
		["Ionar"]="2:6101:7757",
		["Loken"]="2:1924:5202",
		["Volkhan"]="2:3765:2124",
	},
	["Halls of Stone"] = {
		["Krystallus"]="1:4000:6066",
		["Maiden of Grief"]="1:5014:8621",
		["Sjonnir The Ironshaper"]="1:4989:1333",
		["The Tribunal of Ages"]="1:8477:7623",
	},
	["The Culling of Stratholme"] = {
		["Chrono-Lord Epoch"]="2:6571:2550",
		["Infinite Corruptor"]="2:5176:4156",
		["Mal'Ganis"]="2:3229:4606",
		["Meathook"]="2:6166:4898",
		["Salramm the Fleshcrafter"]="2:4681:6017",
	},
	["The Nexus"] = {
		["Anomalus"]="1:6149:2185",
		["Commanders"]="1:1899:5080",
		["Grand Magus Telestra"]="1:2751:4022",
		["Keristrasza"]="1:3611:6771",
		["Ormorok the Tree-Shaper"]="1:5622:7282",
	},
	["The Oculus"] = {
		["Drakos the Interrogator"]="1:4892:7586",
		["Ley-Guardian Eregos"]="4:4714:2087",
		["Mage-Lord Urom"]="3:7066:2756",
		["Varos Cloudstrider"]="2:4608:1917",
	},
	["The Violet Hold"] = {
		["Cyanigosa"]="1:4576:5579",
		["Erekem"]="1:2459:6297",
		["Ichoron"]="1:5598:3961",
		["Lavanthor"]="1:6271:7635",
		["Moragg"]="1:7033:5190",
		["Xevozz"]="1:3343:4691",
		["Zuramat the Obliterator"]="1:2840:3486",
	},
	["Utgarde Keep"] = {
		["Skarvald the Constructor"]="2:5825:6139",
		["Ingvar the Plunderer"]="3:7228:3803",
		["Prince Keleseth"]="1:2881:6272",
	},
	["Utgarde Pinnacle"] = {
		["Gortok Palehoof"]="2:6060:6893",
		["King Ymiron"]="2:4097:5348",
		["Skadi the Ruthless"]="2:6863:3645",
		["Svala Sorrowgrave"]="1:3619:6990",
	},
	["Trial of the Champion"] = {
		["Grand Champions"] = "1:5103:6424",
		["Eadric the Pure"] = "1:6003:5274",
		["Argent Confessor Paletress"] = "1:4203:5274",
		["The Black Knight"] = "1:5103:4124",
	},
	["The Forge of Souls"] = {
		["Bronjahm"] = "1:4349:4995",
		["Devourer of Souls"] = "1:4365:1260",
	},
	["Pit of Saron"] = {
		["Forgemaster Garfrost"] = "0:6766:5518",
		["Krick and Ick"] = "0:4738:4034",
		["Scourgelord Tyrannus"] = "0:4414:2623",
	},
	["Halls of Reflection"] = {
		["The Lich King"] = "1:1007:2756",
		["Marwyn"] = "1:4284:6285",
		["Falric"] = "1:3497:7501",
	},
	["Blackrock Spire"] = {
		["War Master Voone"] = "1:5232:5486",
		["Shadow Hunter Vosh'gajin"] = "2:5545:6967",
		["Mother Smolderweb"] = "2:6184:7425",
		["Highlord Omokk"] = "3:3862:5891",
		["Urok Doomhowl"] = "4:4536:5539",
		["Halycon"] = "5:3805:8373",
		["Quartermaster Zigris"] = "5:5403:8469",
		["Pyroguard Emberseer"] = "6:3023:2705",
		["Overlord Wyrmthalak"] = "6:5758:6072",
		["General Drakkisath"] = "7:3492:5006",
		["Warchief Rend Blackhand"] = "7:4863:2556", -- Gyth
		["The Beast"] = "7:6432:3142",
	},
	["Dire Maul"] = {
		["Guard Slip'kik"] = "1:2640:5731",
		["King Gordok"] = "1:3180:2663",
		["Captain Kromcrush"] = "1:3187:4996",
		["Guard Fengus"] = "1:4955:7808",
		["Stomper Kreeg"] = "1:6092:6839",
		["Guard Mol'dar"] = "1:6944:7574",
		["Illyanna Ravenoak"] = "2:2079:7829",
		["Tendris Warpwood"] = "2:3329:5347",
		["Magister Kalendris"] = "3:3379:4463",
		["Immol'thar"] = "4:3492:5752",
		["Prince Tortheldrin"] = "4:6212:2332",
		["Zevrim Thornhoof"] = "5:4387:4772",
		["Hydrospawn"] = "6:5360:7137",
		["Alzzin the Wildshaper"] = "6:5644:2865",
		["Lethtendris"] = "6:5765:7403",
	},
	["Scholomance"] = {
		["Kirtonos the Herald"] = "2:4955:1043",
		["Rattlegore"] = "3:3158:6466",
		["Jandice Barov"] = "3:5417:1470",
		["Lorekeeper Polkelt"] = "3:7228:2226",
		["Instructor Malicia"] = "3:7263:7052",
		["Doctor Theolen Krastinov"] = "3:8876:4602",
		["Ras Frostwhisper"] = "4:4039:8117",
		["Lady Illucia Barov"] = "4:6724:1523",
		["The Ravenian"] = "4:6745:4847",
		["Lord Alexei Barov"] = "4:7924:2993",
	},
	["Stratholme"] = {
		["Willey Hopebreaker"] = "1:0417:5092",
		["Balnazzar"] = "1:2036:8192",
		["Instructor Galford"] = "1:2718:7489",
		["Commander Malor"] = "1:2981:4080",
		["Timmy the Cruel"] = "1:3471:2492",
		["Lord Aurius Rivendare"] = "2:3911:2045",
		["Ramstein the Gorger"] = "2:4522:2002",
		["Magistrate Barthilas"] = "2:5673:1565",
		["Nerub'enkan"] = "2:5715:4623",
		["Maleki the Pallid"] = "2:6766:2173",
		["Baroness Anastari"] = "2:7413:4538",
	},
	["Blackrock Depths"] = {
		["Bael'Gar"] = "1:2562:5294",
		["High Interrogator Gerstahn"] = "1:4756:9236",
		["Ring of Law"] = "1:5062:6317|2:5048:9012",
		["Pyromancer Loregrain"] = "1:5602:6700",
		["Lord Incendius"] = "1:5658:3110",
		["Fineous Darkvire"] = "1:6340:2087",
		["Golem Lord Argelmach"] = "2:3641:6487",
		["General Angerforge"] = "2:3663:8288",
		["Phalanx"] = "2:4977:6359",
		["The Seven"] = "2:5353:2471",
		["Ambassador Flamelash"] = "2:5396:4857",
		["The Vault"] = "2:5957:6583",
		["Magmus"] = "2:8023:1161",
		["Emperor Thaurissan"] = "2:9160:1171",
	},
	["Sunken Temple"] = {
		["Avatar of Hakkar"] = "1:2413:4559",
		["Morphaz & Hazzas"] = "1:4991:8692",
		["Shade of Eranikus"] = "1:6653:8778",
		["Jammal'an the Prophet|nOgom the Wretched"] = "1:7604:4570",
	},
	["Maraudon"] = {
		["Razorlash"] = "1:1631:3408",
		["Noxxion"] = "1:3592:1011",
		["Lord Vyletongue"] = "1:3783:7105",
		["Tinkerer Gizlock"] = "1:5048:5241",
		["Celebras the Cursed"] = "2:2448:1395",
		["Princess Theradras"] = "2:2590:7872",
		["Landslide"] = "2:4117:4911",
		["Rotgrip"] = "2:4124:8170",
	},
	["Zul'Farrak"] = {
		["Nekrum Gutchewer"] = "0:2938:1704",
		["Hydromancer Velrath"] = "0:3130:4112",
		["Chief Ukorz Sandscalp"] = "0:4224:3366",
		["Witch Doctor Zum'rah"] = "0:4415:1768",
		["Antu'sul"] = "0:6432:2769",
	},
	["Uldaman"] = {
		["Revelosh"] = "1:5325:7254",
		["The Lost Dwarves"] = "1:5857:9214",
		["Ironaya"] = "1:3698:7393",
		["Obsidian Sentinel"] = "1:2889:6018",
		["Ancient Stone Keeper"] = "1:4749:4420",
		["Galgann Firehammer"] = "1:2661:3249",
		["Grimlok"] = "1:2200:2599",
		["Archaedas"] = "2:5523:5070",
	},
	["Razorfen Downs"] = {
		["Tuten'kash"] = "1:5914:3408",
		["Mordresh Fire Eye"] = "1:8577:4687",
		["Glutton"] = "1:3464:6668",
		["Amnennar the Coldbringer"] = "1:4437:6040",
	},
	["Scarlet Monastery"] = {
		["Interrogator Vishas"] = "1:7214:5965",
		["Bloodmage Thalnos"] = "1:2434:5624",
		["Houndmaster Loksey"] = "2:2945:8437",
		["Arcanist Doan"] = "2:8343:7446",
		["Herod"] = "3:7860:1086",
		["High Inquisitor Fairbanks"] = "4:5545:2514",
		["High Inquisitor Whitemane"] = "4:4920:1672",
		["Scarlet Commander Mograine"] = "4:4898:2780",
	},
	["Gnomeregan"] = {
		--["Techbot"] = "1:0000:0000",
		["Viscous Fallout"] = "2:7583:4655",
		["Grubbis"] = "1:7746:6668",
		["Electrocutioner 6000"] = "2:2420:6807",
		["Crowd Pummeler 9-60"] = "3:4316:8799",
		["Mekgineer Thermaplugg"] = "4:3130:2961",
	},
	["Razorfen Kraul"] = {
		--["Roogug"] = "1:0000:0000",
		["Aggem Thorncurse"] = "1:8059:5177",
		["Death Speaker Jargba"] = "1:8677:4016",
		["Overlord Ramtusk"] = "1:5736:3099",
		["Agathelos the Raging"] = "1:0793:6817",
		["Charlga Razorflank"] = "1:2185:3089",
	},
	["The Stockade"] = {
		["Hogger"] = "1:2172:2641",
		["Randolph Moloch"] = "1:5005:2130",
		["Lord Overheat"] = "1:7832:4559",
	},
	["Blackfathom Deeps"] = {
		["Aku'mai"] = "2:8574:8651",
		["Ghamoo-ra"] = "1:3286:6042",
		--["Baron Aquanis"] = "1:0000:0000",
		--["Old Serra'kis"] = "1:0000:0000",
		["Lady Sarevess"] = "1:1132:3983",
		["Gelihast"] = "1:5434:5704",
		["Twilight Lord Kelris"] = "2:5274:8207",
	},
	["Shadowfang Keep"] = {
		["Baron Ashbury"] = "1:6666:7236",
		["Lord Walden"] = "4:5434:5366",
		["Commander Springvale"] = "1:2794:6011",
		["Lord Godfrey"] = "6:6821:3339",
		["Baron Silverlaine"] = "2:3026:7679",
	},
	["The Deadmines"] = {
		["Admiral Ripsnarl"] = "2:6353:3751",
		["Vanessa VanCleef"] = "2:5753:3751",
		['"Captain" Cookie'] = "2:6053:4501",
		["Foe Reaper 5000"] = "2:1238:7584",
		["Helix Gearbreaker"] = "1:5032:8661",
		["Glubtok"] = "1:3638:6148",
	},
	["Wailing Caverns"] = {
		["Lord Serpentis"] = "1:6150:5367",
		["Verdan the Everliving"] = "1:5512:4653",
		["Mutanus the Devourer"] = "1:3438:1384",
		["Skum"] = "1:9282:7900",
		["Lady Anacondra"] = "1:3067:4327",
		["Lord Cobrahn"] = "1:1589:5672",
		["Lord Pythas"] = "1:8567:2898",
	},
	["Ragefire Chasm"] = {
		["Jergosh the Invoker"] = "1:3427:8175",
		["Taragaman the Hungerer"] = "1:4075:5778",
		["Oggleflint"] = "1:6954:6475",
		["Bazzalan"] = "1:4195:8651",
	},
	["Grim Batol"] = {
		["General Umbriss"] = "1:4039:6889",
		["Forgemaster Throngus"] = "1:5147:3034",
		["Drahga Shadowburner"] = "1:6934:1902",
		["Erudax"] = "1:8568:7439",
	},
	["Halls of Origination"] = {
		["Temple Guardian Anhuur"] = "1:5826:6296",--
		["Anraphet"] = "1:5618:1383",--
		["Earthrager Ptah"] = "2:4981:4884",--
		["Isiset"] = "3:3069:4967",
		["Rajh"] = "3:4731:2494",
		["Ammunae"] = "3:4731:7439",
		["Setesh"] = "3:6387:4967",
	},
	["Lost City of the Tol'vir"] = {
		["General Husam"] = "0:3741:4250",
		["Siamat"] = "0:4101:5517",
		["High Prophet Barim"] = "0:2685:6525",
		["Lockmaw"] = "0:6747:7252",
	},
	["The Stonecore"] = {
		["Corborus"] = "1:6262:5912",
		["Slabhide"] = "1:3692:4437",
		["Ozruk"] = "1:4877:2255",
		["High Priestess Azil"] = "1:5736:3824",
	},
	["The Vortex Pinnacle"] = {
		["Grand Vizier Ertan"] = "1:5465:4530",
		["Altairus"] = "1:5175:8187",
		["Asaad"] = "1:2979:3793",
	},
	["Blackrock Caverns"] = {
		["Rom'ogg Bonecrusher"] = "1:4994:7034",
		["Corla, Herald of Twilight"] = "2:2716:1642",
		["Karsh Steelbender"] = "2:4669:6619",
		["Beauty"] = "2:6650:8437",
		["Ascendant Lord Obsidius"] = "2:6871:5091",
	},
	["Throne of the Tides"] = {
		["Ozumat"] = "1:3242:1985",
		["Erunak Stonespeaker|nMindbender Ghur'sha"] = "1:6747:1954",
		["Commander Ulthok"] = "2:5057:4271",
		["Lady Naz'jar"] = "2:5057:2183",
	},
	["Zul'Gurub"] = {
		["High Priest Venoxis"] = "0:5085:5441",
		["Bloodlord Mandokir"] = "0:6019:8003",
		["Edge of Madness"] = "0:5973:4644",
		["High Priestess Kilnara"] = "0:4759:2481",
		["Zanzil"] = "0:3157:2481",
		["Jin'do the Godbreaker"] = "0:4986:3984",
	},
	["Zul'Aman"] = {
		["Akil'zon"] = "0:3501:2284",
		["Nalorakk"] = "0:4097:7684",
		["Jan'alai"] = "0:5544:7103",
		["Halazzi"] = "0:5804:2362",
		["Hex Lord Malacrass"] = "0:7131:5336",
		["Daakara"] = "0:9069:5314",
	},
}

YssBossLoot.Bosses.Raid = {
	["Icecrown Citadel"] = {
		["Lord Marrowgar"] = "1:3896:6002",
		["Lady Deathwhisper"] = "1:3896:8671",
		["Deathbringer Saurfang"] = "3:5134:2192",
		["Icecrown Gunship Battle"] ="2:4530:5471",--
		["Blood Prince Council"] = "5:5184:1444",--??
		["Blood-Queen Lana'thel"] = "6:5114:4396",--
		["Valithria Dreamwalker"] = "5:7668:7386",--
		["Sindragosa"] = "4:3656:2338",
		["Rotface"] = "5:1980:4196",
		["Festergut"] = "5:1980:6550",
		["Professor Putricide"] = "5:1324:5366",
		["The Lich King"] = "7:4984:5292",
	},
	["The Eye of Eternity"] = {
		["Malygos"] = "1:3853:5000",
	},
	["Onyxia's Lair"] = {
		["Onyxia"] = "1:6737:3086",
	},
	["The Obsidian Sanctum"] = {
		["Sartharion"] = "0:5051:4779",
		["Tenebron"] = "0:4157:4818",
		["Shadron"] = "0:5198:3321",
		["Vesperon"] = "0:5303:6198",
	},
	["The Ruby Sanctum"] = {
		["Halion"] = "0:4925:5388",
		["Saviana Ragefire"] = "0:3647:5367",
		["General Zarithrian"] = "0:4953:8021",
		["Baltharus the Warborn"] = "0:6573:5388",
	},
	["Vault of Archavon"] = {
		["Archavon the Stone Watcher"] = "1:4912:1716",
		["Emalon the Storm Watcher"] = "1:6255:5528",
		["Koralon the Flame Watcher"] = "1:3596:5541",
		["Toravon the Ice Watcher"] = "1:6255:3676",
	},
	["Naxxramas"] = {
		["Patchwerk"] = "1:5395:4216|5:4311:2656",
		["Grobbulus"] = "1:6166:5275|5:4737:3241",
		["Gluth"] = "1:4584:4423|5:3863:2771",
		["Thaddius"] = "1:2645:1503|5:2792:1158",

		["Anub'Rekhan"] = "2:3059:4703|5:5517:2933",
		["Grand Widow Faerlina"] = "2:4397:3620|5:6257:2335",
		["Maexxna"] = "2:6847:1552|5:7610:1193",

		["Instructor Razuvious"] = "3:4268:4581|5:3647:6783",
		["Gothik the Harvester"] = "3:6741:5980|5:5135:7625",
		["The Four Horsemen"] = "3:3019:7696|5:2895:8658",

		["Noth the Plaguebringer"] = "4:3465:5664|5:5692:7394",
		["Heigan the Unclean"] = "4:4973:4581|5:6599:6742",
		["Loatheb"] = "4:7569:2866|5:8162:5710",

		["Sapphiron"] = "6:5663:6759",
		["Kel'Thuzad"] = "6:3659:2270",
	},
	["Ulduar"] = {
		["Flame Leviathan"] = "1:4925:3888",
		["Razorscale"] = "1:5436:2683",
		["Ignis the Furnace Master"] = "1:3830:2671",
		["XT-002 Deconstructor"] = "1:4852:1455",

		["Assembly of Iron"] = "2:1550:5701",
		["Kologarn"] = "2:3724:1248",
		["Algalon the Observer"] = "2:7917:4630",

		["Auriaya"] = "3:5119:5701",
		["Hodir"] = "3:6693:6406",
		["Thorim"] = "3:7187:4873",
		["Freya"] = "3:5322:2306",

		["Mimiron"] = "5:4357:4143",

		["General Vezax"] = "4:5687:6066",
		["Yogg-Saron"] = "4:6806:4070|6:5395:6467",
	},
	["Trial of the Crusader"] = {
		["The Northrend Beasts"] = "1:5103:6424",
		["Lord Jaraxxus"] = "1:4203:5274",
		["Faction Champions"] = "1:6003:5274",
		["The Twin Val'kyr"] = "1:5103:4124",
		["Anub'arak"] = "2:5306:3535",
	},
	["Temple of Ahn'Qiraj"] = {
		["The Bug Family"] = "1:2843:4966",
		["Ouro"] = "1:3032:8157",
		["Princess Huhuran"] = "1:4341:5018",
		["Battleguard Sartura"] = "1:4453:3371",
		["Fankriss the Unyielding"] = "1:6216:2268",
		["Twin Emperors"] = "1:6055:6992",
		["Viscidus"] = "1:7217:1807",
		["The Prophet Skeram"] = "2:4592:5165",
		["C'Thun"] = "3:5698:6289",
	},
	["Ruins of Ahn'Qiraj"] = {
		["Moam"] = "0:3291:3664",
		["Ossirian the Unscarred"] = "0:4320:6950",
		["Kurinnaxx"] = "0:5593:3591",
		["General Rajaxx"] = "0:5845:4945",
		["Ayamiss the Hunter"] = "0:6167:9028",
		["Buru the Gorger"] = "0:6993:6226",
	},
	["Molten Core"] = {
		["Garr"] = "1:3095:7002",
		["Gehennas"] = "1:3333:4893",
		["Shazzrah"] = "1:5243:7779",
		["Baron Geddon"] = "1:5516:8482",
		["Ragnaros"] = "1:5586:5471",
		["Lucifron"] = "1:6587:3801",
		["Magmadar"] = "1:6895:2384",
		["Golemagg the Incinerator"] = "1:6853:5858",
		["Majordomo Executus"] = "1:8392:6593",
		["Sulfuron Harbinger"] = "1:8273:8304",
	},
	["Blackwing Lair"] = {
		["Vaelastrasz the Corrupt"] = "1:3312:2783",
		["Razorgore the Untamed"] = "1:4173:6047",
		["Ebonroc"] = "3:3480:2121",
		["Firemaw"] = "3:4620:4305",
		["Broodlord Lashlayer"] = "3:5019:6184",
		["Flamegor"] = "4:3543:3759",
		["Chromaggus"] = "4:3942:7233",
		["Nefarian"] = "4:7028:7275",
	},
	["Baradin Hold"] = {
		["Argaloth"] = "1:8056:6296",
	},
	["Blackwing Descent"] = {
		["Magmaw"] = "1:2785:5715",
		["Omnotron Defense System"] = "1:6574:5725",
		["Nefarian"] = "2:4759:6982",
		["Chimaeron"] = "2:2432:6992",
		["Maloriak"] = "2:7155:6982",
		["Atramedes"] = "2:4752:3305",
	},
	["The Bastion of Twilight"] = {
		["Halfus Wyrmbreaker"] = "1:5355:1954",
		["Valiona & Theralion"] = "1:5368:7792",
		["Twilight Ascendant Council"] = "2:4219:4572",
		["Cho'gall"] = "2:7322:7512",
		["Sinestra"] = "3:4891:3429",
	},
	["Throne of the Four Winds"] = {
		["Al'Akir"] = "1:4738:4977",
		["Conclave of Wind"] = "1:4745:2546",
	},
}