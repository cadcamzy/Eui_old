
--[[ function RecountSkin(self)
	print("RecountSkin")
		print("Recount loaded")
 		self.SecureHook(Recount, "AddWindow", function(this, window)
			EuiSetTemplate(windows)
			print("Recount AddWindows")
		end)

end
local RecountSki = CreateFrame("Frame")
RecountSki:RegisterEvent("PLAYER_LOGIN")
RecountSki:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Recount") then
		RecountSkin(self)
	end
end) ]]