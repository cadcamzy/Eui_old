local E, C, L, DB = unpack(EUI) -- Import Functions/Constants, Config, Locales

--Convert default database
for group,options in pairs(DB) do
	if not C[group] then C[group] = {} end
	for option, value in pairs(options) do
		C[group][option] = value
	end
end

if IsAddOnLoaded("EuiSet") then
	local EuiConfig = LibStub("AceAddon-3.0"):GetAddon("EuiConfig")
	EuiConfig:Load()

	--Load settings from ElvuiConfig database
	for group, options in pairs(EuiConfig.db.profile) do
		if C[group] then
			for option, value in pairs(options) do
				C[group][option] = value
			end
		end
	end
	
end

local LSM = LibStub("LibSharedMedia-3.0")
if LSM ~= nil then
	LSM:Register("statusbar","EUI Statusbar-0", [[Interface\AddOns\Eui\media\statusbar\0.tga]])
	LSM:Register("statusbar","EUI Statusbar-1", [[Interface\AddOns\Eui\media\statusbar\1.tga]])
	LSM:Register("statusbar","EUI Statusbar-2", [[Interface\AddOns\Eui\media\statusbar\2.tga]])
	LSM:Register("statusbar","EUI Statusbar-3", [[Interface\AddOns\Eui\media\statusbar\3.tga]])
	LSM:Register("statusbar","EUI Statusbar-4", [[Interface\AddOns\Eui\media\statusbar\4.tga]])
	LSM:Register("statusbar","EUI Statusbar-5", [[Interface\AddOns\Eui\media\statusbar\5.tga]])
	LSM:Register("statusbar","EUI Statusbar-6", [[Interface\AddOns\Eui\media\statusbar\6.tga]])
	LSM:Register("statusbar","EUI Statusbar-7", [[Interface\AddOns\Eui\media\statusbar\7.tga]])
	LSM:Register("statusbar","EUI Statusbar-8", [[Interface\AddOns\Eui\media\statusbar\8.tga]])
	LSM:Register("statusbar","EUI Statusbar-9", [[Interface\AddOns\Eui\media\statusbar\9.tga]])
	
	LSM:Register("font","EUI cdfont", [[Interface\Addons\Eui\media\ROADWAY.ttf]],255)
	LSM:Register("font","EUI dmgfont", [[Fonts\ZYKai_C.TTF]],255)
	LSM:Register("font","EUI font", [[Fonts\ARIALN.ttf]],255)
end