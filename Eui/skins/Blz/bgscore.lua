local E, C = unpack(EUI)
if C["skins"].enable ~= true then return end

local function LoadSkin()
	E.StripTextures(WorldStateScoreScrollFrame)
	E.StripTextures(WorldStateScoreFrame)
	E.EuiSetTemplate(WorldStateScoreFrame,.7)
	E.SkinCloseButton(WorldStateScoreFrameCloseButton)
	E.Kill(WorldStateScoreFrameInset)
	E.SkinButton(WorldStateScoreFrameLeaveButton)
	
	for i = 1, WorldStateScoreScrollFrameScrollChildFrame:GetNumChildren() do
		local b = _G["WorldStateScoreButton"..i]
		E.StripTextures(b)
		E.StyleButton(b,false)
		E.EuiSetTemplate(b)
	end
	
	for i = 1, 3 do 
		E.SkinTab(_G["WorldStateScoreFrameTab"..i])
	end
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)