local E, C, L, DB = unpack(EUI)
local Eui_Frames = {
	"EuiActionBarBackground",
	"EuiActionBarBackground",
	"EuiLeftActionBarBackground",
	"EuiRightActionBarBackground",
	"EuiActionBarBackgroundRight",
	"EuiActionBarBackgroundRight",
	"EuiPetActionBarBackground",
}  
E.ABlock = true

E.applyDragFunctionality = function(f,userplaced,locked)
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
	f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
	local t = f:CreateTexture(nil,"OVERLAY",nil,6)
	t:SetAllPoints(f)
	t:SetTexture(0,1,0)
	t:SetAlpha(0)
	f.dragtexture = t	
	f:SetHitRectInsets(-15,-15,-15,-15)
	f:SetClampedToScreen(true)
	
	if not userplaced then
		f:SetMovable(false)
	else
		f:SetMovable(true)
		f:SetUserPlaced(true)
		if not locked then
			f.dragtexture:SetAlpha(0.2)
			f:EnableMouse(true)
			f:RegisterForDrag("LeftButton")
			f:SetScript("OnEnter", function(s) 
				GameTooltip:SetOwner(s, "ANCHOR_TOP")
				GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
				GameTooltip:AddLine("左键拖动!", 1, 1, 1, 1, 1, 1)
				GameTooltip:Show()
			end)
			f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
		else
			f.dragtexture:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
			f:SetScript("OnEnter", nil)
			f:SetScript("OnLeave", nil)
		end
	end 
 end

for _, v in pairs(Eui_Frames) do
	f = _G[v]
	E.applyDragFunctionality(f,true,true)
end
  
function E.Eui_unlockFrames()
	if E.ABLock == true then
		print("Eui: 框体解锁")
		for _, v in pairs(Eui_Frames) do
			f = _G[v]
			if f and f:IsUserPlaced() then
			--print(f:GetName())
				f.dragtexture:SetAlpha(0.2)
				f:EnableMouse(true)
				f:RegisterForDrag("LeftButton")
				f:SetScript("OnEnter", function(s) 
					GameTooltip:SetOwner(s, "ANCHOR_TOP")
					GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
					GameTooltip:AddLine("按下 ALT+SHIFT 来拖动!", 1, 1, 1, 1, 1, 1)
					GameTooltip:Show()
				end)
				f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
			end
		end
		E.ABLock = false
	else
		print("Eui: 框体锁定")
		for _, v in pairs(Eui_Frames) do
			f = _G[v]
			if f and f:IsUserPlaced() then
				f.dragtexture:SetAlpha(0)
				f:EnableMouse(nil)
				f:RegisterForDrag(nil)
				f:SetScript("OnEnter", nil)
				f:SetScript("OnLeave", nil)
			end
		end
		E.ABLock = true
	end
end
  
--[[ function E.Eui_lockFrames()
	print("Eui: 框体锁定")
	for _, v in pairs(Eui_Frames) do
		f = _G[v]
		if f and f:IsUserPlaced() then
			f.dragtexture:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
			f:SetScript("OnEnter", nil)
			f:SetScript("OnLeave", nil)
		end
	end
end
  
local function SlashCmd(cmd)	
	if (cmd:match"unlock") then
		E.Eui_unlockFrames()
	elseif (cmd:match"lock") then
		E.Eui_lockFrames()
	else
		print("|c0000FF00\框体移动命令:")
		print("|c0000FF00\/barmss lock|r, 锁定框体")
		print("|c0000FF00\/barmss unlock|r, 解锁框体")
	end
end
SlashCmdList["euibar"] = SlashCmd;
SLASH_euibar1 = "/barmss"; ]]