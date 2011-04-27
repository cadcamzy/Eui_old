WorldM = CreateFrame("Frame")

-- Player Text Object
local Player = WorldMapButton:CreateFontString(nil, "ARTWORK")
Player:SetPoint("BOTTOM", WorldMapButton, -50, -21)
Player:SetFontObject("GameFontNormal")
Player:SetTextColor(1, 1, 1)

-- Divider
local Divider = WorldMapButton:CreateFontString(nil, "ARTWORK")
Divider:SetPoint("BOTTOM", WorldMapButton, 0, -21)
Divider:SetFontObject("GameFontNormal")
Divider:SetTextColor(1, 1, 1)
Divider:SetText("|")

-- Cursor Text Object
local Cursor = WorldMapButton:CreateFontString(nil, "ARTWORK")
Cursor:SetPoint("BOTTOM", WorldMapButton, 50, -21)
Cursor:SetFontObject("GameFontNormal")
Cursor:SetTextColor(1, 1, 1)

WorldMapButton:HookScript("OnUpdate", function(self, u)
	-- Player Position
	local PlayerX, PlayerY = GetPlayerMapPosition("player")
	local mult = 10^1
	PlayerX = math.floor(PlayerX*100*mult+0.5)/mult
	PlayerY = math.floor(PlayerY*100*mult+0.5)/mult
	Player:SetText(PlayerX.." - "..PlayerY)
	
	-- Cursor Position
	local cX, cY = WorldMapDetailFrame:GetCenter()
	local CursorX, CursorY = GetCursorPosition()
	CursorX = math.floor((((CursorX/WorldMapFrame:GetScale())-(cX-(WorldMapDetailFrame:GetWidth()/2)))/10)*mult+.05)/mult
	CursorY = math.floor(((((cY+(WorldMapDetailFrame:GetHeight()/2))-(CursorY/WorldMapFrame:GetScale()))/WorldMapDetailFrame:GetHeight())*100)*mult+.05)/mult
	
	if CursorX >= 100 or CursorY >= 100 or CursorX <= 0 or CursorY <= 0 then
		Cursor:SetText("0 . 0")
	else
		Cursor:SetText(CursorX.." - "..CursorY)
	end
end)


WorldMapFrame:EnableKeyboard(true)
WorldMapFrame:EnableMouse(true)
BlackoutWorld:Hide()
UIPanelWindows["WorldMapFrame"] = {area = "center"}
WorldMapFrame:HookScript("OnShow", function(self) self:SetScale(0.7) end)

WorldM:SetScript("OnEvent", UpdateParty)
