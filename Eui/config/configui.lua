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
