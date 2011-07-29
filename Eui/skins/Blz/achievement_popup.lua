local E, C, L = unpack(EUI)
if C["skins"].enable ~= true then return end
-- Base code by Elv22, rewritten by ljxx.net
local function LoadSkin()
	local function SkinAchievePopUp()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = E.dummy
				if not frame.backdrop then
					E.EuiCreateBackdrop(frame)
					frame.backdrop:SetPoint("TOPLEFT", _G[frame:GetName().."Background"], "TOPLEFT", -2, -6)
					frame.backdrop:SetPoint("BOTTOMRIGHT", _G[frame:GetName().."Background"], "BOTTOMRIGHT", -2, 6)		
				end
				
				-- Background
				_G["AchievementAlertFrame"..i.."Background"]:SetTexture(nil)

				E.Kill(_G["AchievementAlertFrame"..i.."Glow"])
				E.Kill(_G["AchievementAlertFrame"..i.."Shine"])
				
				-- Text
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetFont(E.font, 12)
				_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
				_G["AchievementAlertFrame"..i.."Name"]:SetFont(E.font, 14)

				-- Icon
				_G["AchievementAlertFrame"..i.."IconTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				E.Kill(_G["AchievementAlertFrame"..i.."IconOverlay"])
				
				_G["AchievementAlertFrame"..i.."IconTexture"]:ClearAllPoints()
				_G["AchievementAlertFrame"..i.."IconTexture"]:SetPoint("LEFT", frame, 7, 0)
				
				if not _G["AchievementAlertFrame"..i.."IconTexture"].b then
					_G["AchievementAlertFrame"..i.."IconTexture"].b = CreateFrame("Frame", nil, _G["AchievementAlertFrame"..i])
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetFrameLevel(0)
					E.EuiSetTemplate(_G["AchievementAlertFrame"..i.."IconTexture"].b)
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetPoint("TOPLEFT", _G["AchievementAlertFrame"..i.."IconTexture"], "TOPLEFT", -2, 2)
					_G["AchievementAlertFrame"..i.."IconTexture"].b:SetPoint("BOTTOMRIGHT", _G["AchievementAlertFrame"..i.."IconTexture"], "BOTTOMRIGHT", 2, -2)
				end
			end
		end
	end
	hooksecurefunc("AchievementAlertFrame_FixAnchors", SkinAchievePopUp)
	
	function SkinDungeonPopUP()
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = E.dummy
				if not frame.backdrop then
					E.EuiCreateBackdrop(frame)
					frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, -6)
					frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 6)		
				end
				
				-- Background
				for i=1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region:GetObjectType() == "Texture" then
						if region:GetTexture() == "Interface\\LFGFrame\\UI-LFG-DUNGEONTOAST" then
							E.Kill(region)
						end
					end
				end
				
				E.Kill(_G["DungeonCompletionAlertFrame"..i.."Shine"])
				E.Kill(_G["DungeonCompletionAlertFrame"..i.."GlowFrame"])
				E.Kill(_G["DungeonCompletionAlertFrame"..i.."GlowFrame"].glow)
				
				-- Icon
				_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				
				_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"]:ClearAllPoints()
				_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"]:SetPoint("LEFT", frame, 7, 0)
				
				if not _G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b then
					_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b = CreateFrame("Frame", nil, _G["DungeonCompletionAlertFrame"..i])
					_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b:SetFrameLevel(0)
					E.EuiSetTemplate(_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b)
					_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b:SetPoint("TOPLEFT", _G["DungeonCompletionAlertFrame"..i.."DungeonTexture"], "TOPLEFT", -2, 2)
					_G["DungeonCompletionAlertFrame"..i.."DungeonTexture"].b:SetPoint("BOTTOMRIGHT", _G["DungeonCompletionAlertFrame"..i.."DungeonTexture"], "BOTTOMRIGHT", 2, -2)
				end
			end
		end				
	end
	
	hooksecurefunc("DungeonCompletionAlertFrame_FixAnchors", SkinDungeonPopUP)
end

tinsert(E.SkinFuncs["Eui"], LoadSkin)