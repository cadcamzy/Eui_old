----------------------------------------------------------
--								Thank Author: Slizen	--
--				     2011/04/29 zhTW Billy				--
--  http://home.gamer.com.tw/home.php?owner=billy6719	--
----------------------------------------------------------
local E, C, L, DB = unpack(EUI)
if C["other"].focuser == true then
	local modifier = "shift" -- "shift" , "alt" , "ctrl"
	local mouseButton = "1" -- "1" = ¥ªÁä, "2" = ¥kÁä, "3" = ¤¤Áä, "4" and "5" --§ó§ï·Æ¹«·f°t

	local function SetFocusHotkey(frame)
		frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
	end

	local function CreateFrame_Hook(type, name, parent, template)
		if template == "SecureUnitButtonTemplate" then
			SetFocusHotkey(_G[name])
		end
	end

	hooksecurefunc("CreateFrame", CreateFrame_Hook)

	-- Keybinding override so that models can be shift/alt/ctrl+clicked
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
	f:SetAttribute("type1","macro")
	f:SetAttribute("macrotext","/focus mouseover")
	SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

	-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them
	local duf = {
		Ljxx_playerFrame,
		Ljxx_targetFrame,	
		Ljxx_targettargetFrame,
		Ljxx_focusFrame,
		Ljxx_focustargetFrame,
		Ljxx_petFrame,
		oUF_EUI_raid2,
		oUF_EUI_raid1,
	}

	for i,frame in pairs(duf) do
		SetFocusHotkey(frame)
	end
end