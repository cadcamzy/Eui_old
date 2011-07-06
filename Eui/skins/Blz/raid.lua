Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local buttons = {
		"RaidFrameRaidBrowserButton",
		"RaidFrameRaidInfoButton",
		"RaidFrameReadyCheckButton",
	}

	for i = 1, #buttons do
		E.SkinButton(_G[buttons[i]])
	end

	local StripAllTextures = {
		"RaidGroup1",
		"RaidGroup2",
		"RaidGroup3",
		"RaidGroup4",
		"RaidGroup5",
		"RaidGroup6",
		"RaidGroup7",
		"RaidGroup8",
	}

	for _, object in pairs(StripAllTextures) do
		E.StripTextures(_G[object])
	end

	for i=1, MAX_RAID_GROUPS*5 do
		E.SkinButton(_G["RaidGroupButton"..i], true)
	end

	for i=1,8 do
		for j=1,5 do
			E.StripTextures(_G["RaidGroup"..i.."Slot"..j])
			E.EuiSetTemplate(_G["RaidGroup"..i.."Slot"..j],.7)
		end
	end
end

E.SkinFuncs["Blizzard_RaidUI"] = LoadSkin