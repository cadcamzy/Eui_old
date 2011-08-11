local E, C, L, DB = unpack(EUI)

local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI then return end

local oldRegisterAsWidget = AceGUI.RegisterAsWidget

AceGUI.RegisterAsWidget = function(self, widget)
	local TYPE = widget.type
	if TYPE == "CheckBox" then
		E.Kill(widget.checkbg)
		E.Kill(widget.highlight)
		
		if not widget.skinnedCheckBG then
			widget.skinnedCheckBG = CreateFrame('Frame', nil, widget.frame)
			E.EuiSetTemplate(widget.skinnedCheckBG)
			widget.skinnedCheckBG:SetPoint('TOPLEFT', widget.checkbg, 'TOPLEFT', 4, -4)
			widget.skinnedCheckBG:SetPoint('BOTTOMRIGHT', widget.checkbg, 'BOTTOMRIGHT', -4, 4)
		end
		
		if widget.skinnedCheckBG.oborder then
			widget.check:SetParent(widget.skinnedCheckBG.oborder)
		else
			widget.check:SetParent(widget.skinnedCheckBG)
		end
	elseif TYPE == "Dropdown" then
		local frame = widget.dropdown
		local button = widget.button
		local text = widget.text
		E.StripTextures(frame)

		button:ClearAllPoints()
		button:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
		
		E.SkinNextPrevButton(button, true)
		
		if not frame.backdrop then
			E.EuiCreateBackdrop(frame)
			frame.backdrop:SetPoint("TOPLEFT", 20, -2)
			frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
		end
		button:SetParent(frame.backdrop)
		text:SetParent(frame.backdrop)
		button:HookScript('OnClick', function(this)
			local self = this.obj
			E.EuiSetTemplate(self.pullout.frame)
		end)	
	elseif TYPE == "LSM30_Font" or TYPE == "LSM30_Sound" or TYPE == "LSM30_Border" or TYPE == "LSM30_Background" or TYPE == "LSM30_Statusbar" then
		local frame = widget.frame
		local button = frame.dropButton
		local text = frame.text
		E.StripTextures(frame)

		E.SkinNextPrevButton(button, true)
		frame.text:ClearAllPoints()
		frame.text:SetPoint('RIGHT', button, 'LEFT', -2, 0)

		button:ClearAllPoints()
		button:SetPoint("RIGHT", frame, "RIGHT", -10, -6)
		
		if not frame.backdrop then
			E.EuiCreateBackdrop(frame)
			if TYPE == "LSM30_Font" then
				frame.backdrop:SetPoint("TOPLEFT", 20, -17)
			elseif TYPE == "LSM30_Sound" then
				frame.backdrop:SetPoint("TOPLEFT", 20, -17)
				widget.soundbutton:SetParent(frame.backdrop)
				widget.soundbutton:ClearAllPoints()
				widget.soundbutton:SetPoint('LEFT', frame.backdrop, 'LEFT', 2, 0)
			elseif TYPE == "LSM30_Statusbar" then
				frame.backdrop:SetPoint("TOPLEFT", 20, -17)
				widget.bar:ClearAllPoints()
				widget.bar:SetPoint('TOPLEFT', frame.backdrop, 'TOPLEFT', 2, -2)
				widget.bar:SetPoint('BOTTOMRIGHT', frame.backdrop, 'BOTTOMRIGHT', -2, 2)
				widget.bar:SetParent(frame.backdrop)
			elseif TYPE == "LSM30_Border" or TYPE == "LSM30_Background" then
				frame.backdrop:SetPoint("TOPLEFT", 42, -16)
			end
			
			frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
		end
		button:SetParent(frame.backdrop)
		text:SetParent(frame.backdrop)
		button:HookScript('OnClick', function(this, button)
			local self = this.obj
			if self.dropdown then
				E.EuiSetTemplate(self.dropdown)
			end
		end)		
	elseif TYPE == "EditBox" then
		local frame = widget.editbox
		local button = widget.button
		E.Kill(_G[frame:GetName()..'Left'])
		E.Kill(_G[frame:GetName()..'Middle'])
		E.Kill(_G[frame:GetName()..'Right'])
		frame:SetHeight(17)
		E.EuiCreateBackdrop(frame)
		frame.backdrop:SetPoint('TOPLEFT', -2, 0)
		frame.backdrop:SetPoint('BOTTOMRIGHT', 2, 0)		
		frame.backdrop:SetParent(widget.frame)
		frame:SetParent(frame.backdrop)
		E.SkinButton(button)
	elseif TYPE == "Button" then
		local frame = widget.frame
		E.SkinButton(frame)
		E.StripTextures(frame)
		E.EuiCreateBackdrop(frame)
		frame.backdrop:SetPoint("TOPLEFT", 2, -2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
		widget.text:SetParent(frame.backdrop)
	elseif TYPE == "Slider" then
		local frame = widget.slider
		local editbox = widget.editbox
		local lowtext = widget.lowtext
		local hightext = widget.hightext
		local HEIGHT = 12
		
		E.StripTextures(frame)
		E.EuiSetTemplate(frame)
		frame:SetHeight(HEIGHT)
		frame:SetThumbTexture(E.gray)
		frame:GetThumbTexture():SetVertexColor(0.31, 0.45, 0.63,1)
		frame:GetThumbTexture():SetSize(HEIGHT-2,HEIGHT+2)
		
		E.EuiSetTemplate(editbox)
		editbox:SetHeight(15)
		editbox:SetPoint("TOP", frame, "BOTTOM", 0, -1)
		
		lowtext:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 2, -2)
		hightext:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -2, -2)

	
	--[[elseif TYPE == "ColorPicker" then
		local frame = widget.frame
		local colorSwatch = widget.colorSwatch
	]]
	end
	return oldRegisterAsWidget(self, widget)
end

local oldRegisterAsContainer = AceGUI.RegisterAsContainer

AceGUI.RegisterAsContainer = function(self, widget)
	local TYPE = widget.type
	if TYPE == "ScrollFrame" then
		local frame = widget.scrollbar
		E.SkinScrollBar(frame)
	elseif TYPE == "InlineGroup" or TYPE == "TreeGroup" or TYPE == "TabGroup" or TYPE == "SimpleGroup" or TYPE == "Frame" or TYPE == "DropdownGroup" then
		local frame = widget.content:GetParent()
		if TYPE == "Frame" then
			E.StripTextures(frame)
			for i=1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child:GetObjectType() == "Button" and child:GetText() then
					E.SkinButton(child)
				else
					E.StripTextures(child)
				end
			end
		end	
		E.EuiSetTemplate(frame)
		
		if widget.treeframe then
			E.EuiSetTemplate(widget.treeframe)
			frame:SetPoint("TOPLEFT", widget.treeframe, "TOPRIGHT", 1, 0)
		end
		
		if TYPE == "TabGroup" then
			local oldCreateTab = widget.CreateTab
			widget.CreateTab = function(self, id)
				local tab = oldCreateTab(self, id)
				E.StripTextures(tab)	
				return tab
			end
		end
	end

	return oldRegisterAsContainer(self, widget)
end