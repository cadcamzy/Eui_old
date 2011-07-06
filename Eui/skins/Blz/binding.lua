Local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local buttons = {
		"KeyBindingFrameDefaultButton",
		"KeyBindingFrameUnbindButton",
		"KeyBindingFrameOkayButton",
		"KeyBindingFrameCancelButton",
	}
	
	for _, v in pairs(buttons) do
		E.StripTextures(_G[v])
		E.EuiSetTemplate(_G[v])
	end
	
	E.SkinCheckBox(KeyBindingFrameCharacterButton)
	KeyBindingFrameHeaderText:ClearAllPoints()
	KeyBindingFrameHeaderText:SetPoint("TOP", KeyBindingFrame, "TOP", 0, -4)
	E.StripTextures(KeyBindingFrame)
	E.EuiSetTemplate(KeyBindingFrame,.7)
	
	for i = 1, KEY_BINDINGS_DISPLAYED  do
		local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]
		E.StripTextures(button1,true)
		E.StyleButton(button1,false)
		E.EuiSetTemplate(button1)
		E.StripTextures(button2,true)
		E.StyleButton(button2,false)
		E.EuiSetTemplate(button2)
	end
	
	KeyBindingFrameUnbindButton:SetPoint("RIGHT", KeyBindingFrameOkayButton, "LEFT", -3, 0)
	KeyBindingFrameOkayButton:SetPoint("RIGHT", KeyBindingFrameCancelButton, "LEFT", -3, 0)
end

E.SkinFuncs["Blizzard_BindingUI"] = LoadSkin