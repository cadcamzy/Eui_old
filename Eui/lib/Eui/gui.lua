----------------------------------------------------------------------------------------
--	This Module loads new user settings if !aSettings_GUI is loaded
----------------------------------------------------------------------------------------
if not IsAddOnLoaded("EuiSet") or EuiSettings == nil then return end
local E, C, L, DB = unpack(EUI)

for group, options in pairs(EuiSettings) do
	if C[group] then
		local count = 0
		for option, value in pairs(options) do
			if C[group][option] ~= nil then
				if C[group][option] == value then
					EuiSettings[group][option] = nil	
				else
					count = count + 1
					C[group][option] = value
				end
			end
		end
		if count == 0 then EuiSettings[group] = nil end
	else
		EuiSettings[group] = nil
	end
end
