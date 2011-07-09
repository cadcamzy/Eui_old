--[[
 Copyright (C) 2009 yleaf (yaroot@gmail.com)

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
]]
local E, C, L = unpack(EUI)
local cc = {}
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS or E.RAID_CLASS_COLORS
do
	for class, c in pairs(CUSTOM_CLASS_COLORS) do
		cc[class] = format('|cff%02x%02x%02x', c.r*255, c.g*255, c.b*255)
	end
end

local function SetCaster(self, unit, index, filter)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, filter)
	if unitCaster then
		local uname, urealm = UnitName(unitCaster)
		local _, uclass = UnitClass(unitCaster)
		if urealm then uname = uname..'-'..urealm end
		self:AddLine(L.CASTBY .. (cc[uclass] or '|cffffffff') .. uname .. '|r (' .. unitCaster .. ')')
		self:Show()
	end
end

hooksecurefunc(GameTooltip, 'SetUnitAura', SetCaster)
--[[hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self, unit, index, filter)
	filter = filter and ('HELPFUL '..filter) or 'HELPFUL'
	SetCaster(self, unit, index, filter)
end)
hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self, unit, index, filter)
	filter = filter and ('HARMFUL '..filter) or 'HARMFUL'
	SetCaster(self, unit, index, filter)
end)]]
