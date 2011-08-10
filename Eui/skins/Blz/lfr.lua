local E, C, L, DB = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local buttons = {
	  "LFRQueueFrameFindGroupButton",
	  "LFRQueueFrameAcceptCommentButton",
	  "LFRBrowseFrameSendMessageButton",
	  "LFRBrowseFrameInviteButton",
	  "LFRBrowseFrameRefreshButton",
	}

	E.StripTextures(LFRParentFrame)
	E.EuiSetTemplate(LFRParentFrame,.7)
	E.StripTextures(LFRQueueFrame)
	E.StripTextures(LFRBrowseFrame)


	for i=1, #buttons do
	  E.SkinButton(_G[buttons[i]])
	end

	--Close button doesn't have a fucking name, extreme hackage
	for i=1, LFRParentFrame:GetNumChildren() do
	  local child = select(i, LFRParentFrame:GetChildren())
	  if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
		E.SkinCloseButton(child)
	  end
	end

	E.SkinTab(LFRParentFrameTab1)
	E.SkinTab(LFRParentFrameTab2)

	E.SkinDropDownBox(LFRBrowseFrameRaidDropDown)

	for i=1, 20 do
	  local button = _G["LFRQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"]

	  if button then
		button:HookScript("OnClick", function()
		  E.SkinCloseButton(button)
		end)
		E.SkinCloseButton(button)
	  end
	end

	E.EuiCreateBackdrop(LFRQueueFrameCommentTextButton)
	LFRQueueFrameCommentTextButton:SetHeight(35)

	for i=1, 7 do
		local button = "LFRBrowseFrameColumnHeader"..i
		E.Kill(_G[button.."Left"])
		E.Kill(_G[button.."Middle"])
		E.Kill(_G[button.."Right"])
	end		
	
	for i=1, NUM_LFR_CHOICE_BUTTONS do
		local button = _G["LFRQueueFrameSpecificListButton"..i]
		E.SkinCheckBox(button.enableButton)
	end
	
	--DPS, Healer, Tank check button's don't have a name, use it's parent as a referance.
	E.SkinCheckBox(LFRQueueFrameRoleButtonTank:GetChildren())
	E.SkinCheckBox(LFRQueueFrameRoleButtonHealer:GetChildren())
	E.SkinCheckBox(LFRQueueFrameRoleButtonDPS:GetChildren())
	LFRQueueFrameRoleButtonTank:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonTank:GetChildren():GetFrameLevel() + 2)
	LFRQueueFrameRoleButtonHealer:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonHealer:GetChildren():GetFrameLevel() + 2)
	LFRQueueFrameRoleButtonDPS:GetChildren():SetFrameLevel(LFRQueueFrameRoleButtonDPS:GetChildren():GetFrameLevel() + 2)
	
	E.StripTextures(LFRQueueFrameSpecificListScrollFrame)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)