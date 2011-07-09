local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	local noscalemult = E.mult * C["ui"].uiscale
	local bg = {
	  bgFile = E.normTex, 
	  edgeFile = E.normTex, 
	  tile = false, tileSize = 0, edgeSize = noscalemult, 
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	ScriptErrorsFrame:SetBackdrop(bg)
	ScriptErrorsFrame:SetBackdropColor(.1,.1,.1)
	ScriptErrorsFrame:SetBackdropBorderColor(0.31, 0.45, 0.63)	

	E.EuiSetTemplate(EventTraceFrame,.7)
	
	local texs = {
		"TopLeft",
		"TopRight",
		"Top",
		"BottomLeft",
		"BottomRight",
		"Bottom",
		"Left",
		"Right",
		"TitleBG",
		"DialogBG",
	}
	
	for i=1, #texs do
		_G["ScriptErrorsFrame"..texs[i]]:SetTexture(nil)
		_G["EventTraceFrame"..texs[i]]:SetTexture(nil)
	end
	E.SkinCloseButton(ScriptErrorsFrameClose)
	E.SkinScrollBar(ScriptErrorsFrameScrollFrameScrollBar)
	local bg = {
	  bgFile = E.normTex, 
	  edgeFile = E.normTex, 
	  tile = false, tileSize = 0, edgeSize = noscalemult, 
	  insets = { left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
	}
	
	for i=1, ScriptErrorsFrame:GetNumChildren() do
		local child = select(i, ScriptErrorsFrame:GetChildren())
		if child:GetObjectType() == "Button" and not child:GetName() then
			
			E.SkinButton(child)
			child:SetBackdrop(bg)
			child:SetBackdropColor(.1,.1,.1)
			child:SetBackdropBorderColor(0.31, 0.45, 0.63)	
		end
	end	
end

E.SkinFuncs["Blizzard_DebugTools"] = LoadSkin