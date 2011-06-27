local ALLOWED_GROUPS = {
	["main"] = 1,
	["filter"] = 1,
	["chat"] = 1,
--	["bag"] = 1,
	["actionbar"] = 1,
	["unitframe"] = 1,
	["raid"] = 1,
	["tooltip"] = 1,
	["threat"] = 1,
	["info"] = 0,
	["clickset"] = 1,
	["skins"] = 1,
	["other"] = 1,
	["ui"] = 1,
}

local function Local(o)
	local E, C = unpack(EUI)
	-- 主菜单
	if o == "EuiSetGuimain" then o = e_main_label end
	if o == "EuiSetGuifilter" then o = e_filter_label end
	if o == "EuiSetGuichat" then o = e_chat_label end
	if o == "EuiSetGuibag" then o = e_bag_label end
	if o == "EuiSetGuiactionbar" then o = e_actionbar_label end
	if o == "EuiSetGuiunitframe" then o = e_unitframe_label end
	if o == "EuiSetGuitooltip" then o = e_tooltip_label end
	if o == "EuiSetGuithreat" then o = e_threat_label end
	if o == "EuiSetGuiinfo" then o = e_info_label end
	if o == "EuiSetGuiraid" then o = e_raid_label end
	if o == "EuiSetGuiclickset" then o = e_clickset_label end
	if o == "EuiSetGuiskins" then o = e_skins_label end
	if o == "EuiSetGuiother" then o = e_other_label end
	if o == "EuiSetGuiui" then o = e_ui_label end
	
	-- UI设置(EuiSetGuiui)
	if o == "EuiSetGuiuiautoscale" then o = e_ui_autoscale end
	if o == "EuiSetGuiuiuiscale" then o = e_ui_uiscale end	
	
	-- 一般设置(EuiSetGuimain)
	if o == "EuiSetGuimainautoscale" then o = e_main_autoscale end
	if o == "EuiSetGuimainuiscale" then o = e_main_uiscale end
	if o == "EuiSetGuimainautoinvite" then o = e_main_autoinvite end
	if o == "EuiSetGuimaininvitetext" then o = e_main_invitetext end
	if o == "EuiSetGuimainnoerrors" then o = e_main_noerrors end
	if o == "EuiSetGuimainnoerrorsincombat" then o = e_main_noerrorsincombat end
	if o == "EuiSetGuimainmoveuierrors" then o = e_main_moveuierrors end
	if o == "EuiSetGuimainignoreduel" then o = e_main_ignoreduel end
	if o == "EuiSetGuimainautoroll" then o = e_main_autoroll end
	if o == "EuiSetGuimaindisableconfirm" then o = e_main_disableconfirm end
	if o == "EuiSetGuimainautoloot" then o = e_main_autoloot end
	if o == "EuiSetGuimainautorepair" then o = e_main_autorepair end
	if o == "EuiSetGuimainautorepairguild" then o = e_main_autorepairguild end
	if o == "EuiSetGuimainsellgreycrap" then o = e_main_sellgreycrap end
	if o == "EuiSetGuimainacceptinvites" then o = e_main_acceptinvites end
	if o == "EuiSetGuimainbugstack" then o = e_main_buystack end
	if o == "EuiSetGuimainalttotrade" then o = e_main_alttotrade end
	if o == "EuiSetGuimaintalentspam" then o = e_main_talentspam end
	if o == "EuiSetGuimainquestauto" then o = e_main_questauto end
	if o == "EuiSetGuimainquesticons" then o = e_main_questicons end
	if o == "EuiSetGuimainautorez" then o = e_main_autorez end
	if o == "EuiSetGuimaincombatnoti" then o = e_main_combatnoti end
	if o == "EuiSetGuimainlockquest" then o = e_main_lockquest end
	if o == "EuiSetGuimainminimappos" then o = e_main_minimappos end
	if o == "EuiSetGuimainalpha" then o = e_main_alpha end
	if o == "EuiSetGuimainclasscolortheme" then o = e_main_classcolortheme end
	if o == "EuiSetGuimainclasscolorcustom" then o = e_main_classcolorcustom end
	
	--其它设置(EuiSetGuiother)
	if o == "EuiSetGuiothernameplate" then o = e_other_nameplate end
	if o == "EuiSetGuiothernameplateauto" then o = e_other_nameplateauto end
	if o == "EuiSetGuiothernameplatevalue" then o = e_other_nameplatevalue end
	if o == "EuiSetGuiothermail" then o = e_other_mail end
	if o == "EuiSetGuiothercooldown" then o = e_other_cooldown end
	if o == "EuiSetGuiothertab" then o = e_other_tab end
	if o == "EuiSetGuiotherloot" then o = e_other_loot end
	if o == "EuiSetGuiotherrecipients" then o = e_other_recipients end
	if o == "EuiSetGuiothersr" then o = e_other_sr end
	if o == "EuiSetGuiotherfocuser" then o = e_other_focuser end
	if o == "EuiSetGuiotherratings" then o = e_other_ratings end
	if o == "EuiSetGuiotherhb" then o = e_other_hb end
	if o == "EuiSetGuiotherspellid" then o = e_other_spellid end
	if o == "EuiSetGuiothermbb" then o = e_other_mbb end
	if o == "EuiSetGuiotherminimap" then o = e_other_minimap end
	if o == "EuiSetGuiotherbuff" then o = e_other_buff end
	if o == "EuiSetGuiothermap" then o = e_other_map end
	if o == "EuiSetGuiothermapscale" then o = e_other_mapscale end
	if o == "EuiSetGuiothermapalpha" then o = e_other_mapalpha end
	if o == "EuiSetGuiotherraidcheck" then o = e_other_raidcheck end
	
	-- 聊天(EuiSetGuichat)
	if o == "EuiSetGuichatenable" then o = e_chat_enable end
	if o == "EuiSetGuichathidejunk" then o = e_chat_hidejunk end
	if o == "EuiSetGuichatchatw" then o = e_chat_chatw end
	if o == "EuiSetGuichatchath" then o = e_chat_chath end
	if o == "EuiSetGuichatchatbar" then o = e_chat_chatbar end
	if o == "EuiSetGuichatchatguard" then o = e_chat_chatguard end
	if o == "EuiSetGuichatLFW" then o = e_chat_LFW end
	if o == "EuiSetGuichatbodylevel" then o =e_chat_bodylevel end
	
	-- 技能监视(EuiSetGuifilter)
	if o == "EuiSetGuifilterenable" then o = e_filter_enable end
	if o == "EuiSetGuifilterconfigmode" then o = e_filter_configmode end
	if o == "EuiSetGuifilterclasscolor" then o = e_filter_classcolor end
	if o == "EuiSetGuifilterpbuffbar" then o = e_filter_pbuffbar end
	if o == "EuiSetGuifiltertdebuffbar" then o = e_filter_tdebuffbar end
	if o == "EuiSetGuifilterbarheight" then o = e_filter_barheight end
	if o == "EuiSetGuifiltercoolline" then o = e_filter_coolline end
	if o == "EuiSetGuifiltericonsize" then o = e_filter_iconsize end
	if o == "EuiSetGuifilterpbufficon" then o = e_filter_pbufficon end
	if o == "EuiSetGuifiltertdebufficon" then o = e_filter_tdebufficon end
	if o == "EuiSetGuifilterfloat" then o = e_filter_float end
	if o == "EuiSetGuifilterraid" then o = e_filter_raid end
	if o == "EuiSetGuifilterraidwidth" then o = e_filter_raidwidth end
	if o == "EuiSetGuifilterraidheight" then o = e_filter_raidheight end
	if o == "EuiSetGuifilterraidnumber" then o = e_filter_raidnumber end
	if o == "EuiSetGuifilterpcdicon" then o = e_filter_pcdicon end
	if o == "EuiSetGuifiltercdsize" then o = e_filter_cdsize end
	if o == "EuiSetGuifiltercoollinew" then o = e_filter_coollinew end
	if o == "EuiSetGuifiltercoollineh" then o = e_filter_coollineh end
	
	-- 头像(EuiSetGuiunitframe)
	if o == "EuiSetGuiunitframeaaaaunit" then o = e_unitframe_aaaaunit end
	if o == "EuiSetGuiunitframetotalhpmp" then o = e_unitframe_totalhpmp end
	if o == "EuiSetGuiunitframecastbar" then o = e_unitframe_castbar end
	if o == "EuiSetGuiunitframeswing" then o = e_unitframe_swing end
	if o == "EuiSetGuiunitframetotdebuffs" then o = e_unitframe_totdebuffs end
	if o == "EuiSetGuiunitframecolorClass" then o = e_unitframe_colorClass end --新增
	if o == "EuiSetGuiunitframeFbuffs" then o = e_unitframe_Fbuffs end
	if o == "EuiSetGuiunitframeFdebuffs" then o = e_unitframe_Fdebuffs end
	if o == "EuiSetGuiunitframeportrait" then o = e_unitframe_portrait end
	if o == "EuiSetGuiunitframeshowPvP" then o = e_unitframe_showPvP end
	if o == "EuiSetGuiunitframeonlyplayer" then o = e_unitframe_onlyplayer end
	if o == "EuiSetGuiunitframepowerspark" then o = e_unitframe_powerspark end	
	if o == "EuiSetGuiunitframeplayerx" then o = e_unitframe_playerx end
	if o == "EuiSetGuiunitframeplayery" then o = e_unitframe_playery end
	if o == "EuiSetGuiunitframeplayerwidth" then o = e_unitframe_playerwidth end
	if o == "EuiSetGuiunitframeplayerheight" then o = e_unitframe_playerheight end
	if o == "EuiSetGuiunitframepetwidth" then o = e_unitframe_petwidth end
	if o == "EuiSetGuiunitframepetheight" then o = e_unitframe_petheight end
	if o == "EuiSetGuiunitframetotwidth" then o = e_unitframe_totwidth end
	if o == "EuiSetGuiunitframetotheight" then o = e_unitframe_totheight end
	if o == "EuiSetGuiunitframefocuswidth" then o = e_unitframe_focuswidth end
	if o == "EuiSetGuiunitframefocusheight" then o = e_unitframe_focusheight end
	if o == "EuiSetGuiunitframecolorClassName" then o = e_unitframe_colorClassName end
	if o == "EuiSetGuiunitframecpoint" then o = e_unitframe_cpoint end
	if o == "EuiSetGuiunitframecpointwidth" then o = e_unitframe_cpointwidth end
	if o == "EuiSetGuiunitframecpointheight" then o = e_unitframe_cpointheight end
	if o == "EuiSetGuiunitframeplayerdebuffnum" then o = e_unitframe_playerdebuffnum end
	if o == "EuiSetGuiunitframebigcastbar" then o = e_unitframe_bigcastbar end
	if o == "EuiSetGuiunitframebigcastbarscale" then o = e_unitframe_bigcastbarscale end
	if o == "EuiSetGuiunitframebigcastbarpos" then o = e_unitframe_bigcastbarpos end
	if o == "EuiSetGuiunitframeshowpprec" then o = e_unitframe_showpprec end
	if o == "EuiSetGuiunitframetargetbuffs" then o = e_unitframe_targetbuffs end
	if o == "EuiSetGuiunitframetargetdebuffs" then o = e_unitframe_targetdebuffs end
	
	--团队(EuiSetGuiraid)

	if o == "EuiSetGuiraidraidDirection" then o = e_raid_raidDirection end	
	if o == "EuiSetGuiraidraid" then o = e_raid_raid end
	if o == "EuiSetGuiraidraidthreat" then o = e_raid_raidthreat end
	if o == "EuiSetGuiraidraidaurawatch" then o = e_raid_raidaurawatch end
	if o == "EuiSetGuiraidastyle" then o = e_raid_astyle end
	if o == "EuiSetGuiraidgridhealthvettical" then o = e_raid_gridhealthvettical end
	if o == "EuiSetGuiraidraidColorClass" then o = e_raid_raidColorClass end
	if o == "EuiSetGuiraidraidgroups" then o = e_raid_raidgroups end
	if o == "EuiSetGuiraidgrouphv" then o = e_raid_grouphv end
	if o == "EuiSetGuiraidgroupspace" then o = e_raid_groupspace end
	if o == "EuiSetGuiraidgridheight" then o = e_raid_gridheight end
	if o == "EuiSetGuiraidnogridheight" then o = e_raid_nogridheight end
	if o == "EuiSetGuiraidgridh" then o = e_raid_gridh end
	if o == "EuiSetGuiraidgridw" then o = e_raid_gridw end
	if o == "EuiSetGuiraidnogridh" then o = e_raid_nogridh end
	if o == "EuiSetGuiraidnogridw" then o = e_raid_nogridw end
	if o == "EuiSetGuiraidclickset" then o = e_raid_clickset end
	if o == "EuiSetGuiraidhottime" then o = e_raid_hottime end
	if o == "EuiSetGuiraidhotsize" then o = e_raid_hotsize end
	if o == "EuiSetGuiraidmt" then o = e_raid_mt end
	if o == "EuiSetGuiraidboss" then o = e_raid_boss end
	if o == "EuiSetGuiraidshowParty" then o = e_raid_showParty end
	if o == "EuiSetGuiraidshowPartyTarget" then o = e_raid_showPartyTarget end
	if o == "EuiSetGuiraidraidtarget" then o = e_raid_raidtarget end
	if o == "EuiSetGuiraidtexture" then o = e_raid_texture end
	if o == "EuiSetGuiraidportrait" then o = e_raid_portrait end

	
	-- 动作条(EuiSetGuiactionbar)
	if o == "EuiSetGuiactionbarenable" then o = e_actionbar_enable end
	if o == "EuiSetGuiactionbarhotkey" then o = e_actionbar_hotkey end
	if o == "EuiSetGuiactionbarrightbarmouseover" then o = e_actionbar_rightbarmouseover end
	if o == "EuiSetGuiactionbarshapeshiftmouseover" then o = e_actionbar_shapeshiftmouseover end
	if o == "EuiSetGuiactionbarhideshapeshift" then o = e_actionbar_hideshapeshift end
	if o == "EuiSetGuiactionbarshowgrid" then o = e_actionbar_showgrid end
	if o == "EuiSetGuiactionbarbottompetbar" then o = e_actionbar_bottompetbar end
	if o == "EuiSetGuiactionbarbuttonsize" then o = e_actionbar_buttonsize end
	if o == "EuiSetGuiactionbarbuttonspacing" then o = e_actionbar_buttonspacing end
	if o == "EuiSetGuiactionbarpetbuttonsize" then o = e_actionbar_petbuttonsize end
	if o == "EuiSetGuiactionbarpetbuttonspacing" then o = e_actionbar_petbuttonspacing end
	if o == "EuiSetGuiactionbarswaptopbottombar" then o = e_actionbar_swaptopbottombar end
	if o == "EuiSetGuiactionbarmacrotext" then o = e_actionbar_macrotext end
	if o == "EuiSetGuiactionbarverticalstance" then o = e_actionbar_verticalstance end
	if o == "EuiSetGuiactionbarmicrobar" then o = e_actionbar_microbar end
	if o == "EuiSetGuiactionbarmousemicro" then o = e_actionbar_mousemicro end
	if o == "EuiSetGuiactionbarrankwatch" then o = e_actionbar_rankwatch end
	
	-- 鼠标提示(EuiSetGuitooltip)
	if o == "EuiSetGuitooltipenable" then o = e_tooltip_enable end
	if o == "EuiSetGuitooltipcursor" then o = e_tooltip_cursor end
	if o == "EuiSetGuitooltiphideincombat" then o = e_tooltip_hideincombat end
	if o == "EuiSetGuitooltiphidebuttonscombat" then o = e_tooltip_hidebuttonscombat end
	if o == "EuiSetGuitooltiphovertip" then o = e_tooltip_hovertip end
	if o == "EuiSetGuitooltipScale e" then o = e_tooltip_Scale end
	if o == "EuiSetGuitooltipDisplayPvPRank" then o = e_tooltip_DisplayPvPRank end
	if o == "EuiSetGuitooltipShowIsPlayer" then o = e_tooltip_ShowIsPlayer end
	if o == "EuiSetGuitooltipDisplayFaction" then o = e_tooltip_DisplayFaction end
	if o == "EuiSetGuitooltipPlayerServer" then o = e_tooltip_PlayerServer end
	if o == "EuiSetGuitooltipTargetOfMouse" then o = e_tooltip_TargetOfMouse end
	if o == "EuiSetGuitooltipClassIcon" then o = e_tooltip_ClassIcon end
	if o == "EuiSetGuitooltipShowTalent" then o = e_tooltip_ShowTalent end
	if o == "EuiSetGuitooltipTargetedBy" then o = e_tooltip_TargetedBy end
	if o == "EuiSetGuitooltipx" then o = e_tooltip_x end
	if o == "EuiSetGuitooltipy" then o = e_tooltip_y end
	
	-- 背包(EuiSetGuibag)
	if o == "EuiSetGuibagenable" then o = e_bag_enable end
	
	-- 仇恨显示(EuiSetGuithreat)
	if o == "EuiSetGuithreatenable" then o = e_threat_enable end
	if o == "EuiSetGuithreatwidth" then o = e_threat_width end
	if o == "EuiSetGuithreatheight" then o = e_threat_height end
	if o == "EuiSetGuithreatbars" then o = e_threat_bars end
	if o == "EuiSetGuithreatspacing" then o = e_threat_spacing end
	if o == "EuiSetGuithreatdirection" then o = e_threat_direction end
	if o == "EuiSetGuithreattest" then o = e_threat_test end
	
	-- 信息(EuiSetGuiinfo)
	if o == "EuiSetGuiinfoenable" then o = e_info_enable end
	if o == "EuiSetGuiinfobag" then o = e_info_bag end
	if o == "EuiSetGuiinfolatency" then o = e_info_latency end
	if o == "EuiSetGuiinfodurability" then o = e_info_durability end
	if o == "EuiSetGuiinfomemory" then o = e_info_memory end
	if o == "EuiSetGuiinfoxp" then o = e_info_xp end
	if o == "EuiSetGuiinfosetting" then o = e_info_setting end
	if o == "EuiSetGuiinfowowtime" then o = e_info_wowtime end
	if o == "EuiSetGuiinfowgtimenoti" then o = e_info_wgtimenoti end
	if o == "EuiSetGuiinfoguild" then o = e_info_guild end
	if o == "EuiSetGuiinfofriend" then o = e_info_friend end
	if o == "EuiSetGuiinfoapsp" then o = e_info_apsp end
	if o == "EuiSetGuiinfodps" then o = e_info_dps end
	
	-- 点击施法(EuiSetGuiclickset)
	if o == "EuiSetGuiclicksetaadefault" then o = e_clickset_aadefault end
	if o == "EuiSetGuiclicksetshiftztype1" then o = e_clickset_shiftztype1 end
	if o == "EuiSetGuiclicksetctrlztype1" then o = e_clickset_ctrlztype1 end
	if o == "EuiSetGuiclicksetaltztype1" then o = e_clickset_altztype1 end
	if o == "EuiSetGuiclicksetaltzctrlztype1" then o = e_clickset_altzctrlztype1 end
	if o == "EuiSetGuiclicksettype2" then o = e_clickset_type2 end
	if o == "EuiSetGuiclicksetshiftztype2" then o = e_clickset_shiftztype2 end
	if o == "EuiSetGuiclicksetctrlztype2" then o = e_clickset_ctrlztype2 end
	if o == "EuiSetGuiclicksetaltztype2" then o = e_clickset_altztype2 end
	if o == "EuiSetGuiclicksetaltzctrlztype2" then o = e_clickset_altzctrlztype2 end
	if o == "EuiSetGuiclicksettype3" then o = e_clickset_type3 end
	if o == "EuiSetGuiclicksettype1" then o = e_clickset_type1 end

	if o == "EuiSetGuiclicksettype4" then o = e_clickset_type4 end
	if o == "EuiSetGuiclicksetshiftztype4" then o = e_clickset_shiftztype4 end
	if o == "EuiSetGuiclicksetctrlztype4" then o = e_clickset_ctrlztype4 end
	if o == "EuiSetGuiclicksetaltztype4" then o = e_clickset_altztype4 end
	if o == "EuiSetGuiclicksetaltzctrlztype4" then o = e_clickset_altzctrlztype4 end

	if o == "EuiSetGuiclicksettype5" then o = e_clickset_type5 end
	if o == "EuiSetGuiclicksetshiftztype5" then o = e_clickset_shiftztype5 end
	if o == "EuiSetGuiclicksetctrlztype5" then o = e_clickset_ctrlztype5 end
	if o == "EuiSetGuiclicksetaltztype5" then o = e_clickset_altztype5 end
	if o == "EuiSetGuiclicksetaltzctrlztype5" then o = e_clickset_altzctrlztype5 end	
	if o == "EuiSetGuiclicksetaamouse" then o = e_clickset_aamouse end
	
	-- 皮肤
	if o == "EuiSetGuiskinsaskins" then o = e_skins_askins end
	if o == "EuiSetGuiskinsdbm" then o = e_skins_dbm end
	if o == "EuiSetGuiskinsskada" then o = e_skins_skada end
	if o == "EuiSetGuiskinstexture" then o = e_skins_texture end
	if o == "EuiSetGuiskinsenable" then o = e_skins_enable end

	E.option = o
end

local NewButton = function(text,parent)
	local E,C = unpack(EUI)
	local result = CreateFrame("Button", nil, parent)
	local label = result:CreateFontString(nil,"OVERLAY",nil)
	label:SetFont(E.font,12,"OUTLINE")
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)

	return result
end

local function SetValue(group, option, value)
	if not EuiSettings then
		EuiSettings = {}
	end
	if not EuiSettings[group] then
		EuiSettings[group] = {}
	end
	EuiSettings[group][option] = value
end

local VISIBLE_GROUP = nil
local lastbutton = nil
local function ShowGroup(group, button)
	local E, C = unpack(EUI)
	if (lastbutton) then
		lastbutton:SetText(lastbutton:GetText().sub(lastbutton:GetText(), 11, -3))
	end
	if (VISIBLE_GROUP) then
		_G["EuiSetGui"..VISIBLE_GROUP]:Hide()
	end
	if _G["EuiSetGui"..group] then
		local o = "EuiSetGui"..group
		Local(o)
		_G["EuiSetGuiTitle"]:SetText(E.option)
		local height = _G["EuiSetGui"..group]:GetHeight()
		_G["EuiSetGui"..group]:Show()
		local scrollamntmax = 305
		local scrollamntmin = scrollamntmax - 10
		local max = height > scrollamntmax and height-scrollamntmin or 1
		
		if max == 1 then
			_G["EuiSetGuiGroupSlider"]:SetValue(1)
			_G["EuiSetGuiGroupSlider"]:Hide()
		else
			_G["EuiSetGuiGroupSlider"]:SetMinMaxValues(0, max)
			_G["EuiSetGuiGroupSlider"]:Show()
			_G["EuiSetGuiGroupSlider"]:SetValue(1)
		end
		_G["EuiSetGuiGroup"]:SetScrollChild(_G["EuiSetGui"..group])
		
		local x
		if EuiSetGuiGroupSlider:IsShown() then 
			_G["EuiSetGuiGroup"]:EnableMouseWheel(true)
			_G["EuiSetGuiGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if EuiSetGuiGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["EuiSetGuiGroupSlider"]:GetValue()
						_G["EuiSetGuiGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["EuiSetGuiGroupSlider"]:GetValue()			
						_G["EuiSetGuiGroupSlider"]:SetValue(x - 30)	
					end
				end
			end)
		else
			_G["EuiSetGuiGroup"]:EnableMouseWheel(false)
		end
		
		VISIBLE_GROUP = group
		lastbutton = button
	end
end

function CreateEuiSetGui()
	local E,C = unpack(EUI)
	if EuiSetGui then
		ShowGroup("main")
		EuiSetGui:Show()
		return
	end
	
	-- MAIN FRAME
	local EuiSetGui = CreateFrame("Frame","EuiSetGui",UIParent)
	EuiSetGui:SetPoint("CENTER", UIParent, "CENTER", E.Scale(90), 0)
	EuiSetGui:SetWidth(E.Scale(400))
	EuiSetGui:SetHeight(E.Scale(300))
	EuiSetGui:SetFrameStrata("DIALOG")
	EuiSetGui:SetFrameLevel(20)
	tinsert(UISpecialFrames, "EuiSetGui")
	
	-- TITLE 2
	local EuiSetGuiTitleBox = CreateFrame("Frame","EuiSetGui",EuiSetGui)
	EuiSetGuiTitleBox:SetWidth(E.Scale(420))
	EuiSetGuiTitleBox:SetHeight(E.Scale(24))
	EuiSetGuiTitleBox:SetPoint("TOPLEFT", -E.Scale(10), E.Scale(42))
	E.EuiSetTemplate(EuiSetGuiTitleBox)
	
	local title = EuiSetGuiTitleBox:CreateFontString("EuiSetGuiTitle", "OVERLAY")
	title:SetFont(E.font, 12)
	title:SetPoint("CENTER")
		
	local EuiSetGuiBG = CreateFrame("Frame","EuiSetGui",EuiSetGui)
	EuiSetGuiBG:SetPoint("TOPLEFT", -E.Scale(10), E.Scale(10))
	EuiSetGuiBG:SetPoint("BOTTOMRIGHT", E.Scale(10), -E.Scale(10))
	E.EuiSetTemplate(EuiSetGuiBG)
	
	-- GROUP SELECTION ( LEFT SIDE )
	local groups = CreateFrame("ScrollFrame", "EuiSetGuiCategoryGroup", EuiSetGui)
	groups:SetPoint("TOPLEFT",-E.Scale(180),0)
	groups:SetWidth(E.Scale(150))
	groups:SetHeight(E.Scale(300))

	local groupsBG = CreateFrame("Frame","EuiSetGui",EuiSetGui)
	groupsBG:SetPoint("TOPLEFT", groups, -E.Scale(10), E.Scale(10))
	groupsBG:SetPoint("BOTTOMRIGHT", groups, E.Scale(10), -E.Scale(10))
	E.EuiSetTemplate(groupsBG)
	
	local TitleBoxVer = CreateFrame("Frame", "TitleBoxVer", EuiSetGui)
	TitleBoxVer:SetWidth(E.Scale(170))
	TitleBoxVer:SetHeight(E.Scale(24))
	TitleBoxVer:SetPoint("BOTTOMLEFT", groupsBG, "TOPLEFT", 0, E.Scale(8))
	E.EuiSetTemplate(TitleBoxVer)
	
	local version = GetAddOnMetadata("Eui", "Version")
	local verdata = GetAddOnMetadata("EuiSet", "Version")
	local TitleBoxVerText = TitleBoxVer:CreateFontString("EuiSetGuiTitleVer", "OVERLAY", "GameFontNormal")
	TitleBoxVerText:SetPoint("CENTER")
	TitleBoxVerText:SetText("EUI "..version.." "..verdata)
	
	local slider = CreateFrame("Slider", "EuiSetGuiCategorySlider", groups)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(E.Scale(20))
	slider:SetHeight(E.Scale(300))
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) groups:SetVerticalScroll(value) end)
	
	local child = CreateFrame("Frame",nil,groups)
	child:SetPoint("TOPLEFT")
	local offset=E.Scale(5)
	for group in pairs(ALLOWED_GROUPS) do
		local o = "EuiSetGui"..group
		Local(o)
		local button = NewButton(E.option, child)
		button:SetHeight(E.Scale(16))
		button:SetWidth(E.Scale(125))
		button:SetPoint("TOPLEFT", E.Scale(5),-(offset))
		--button:SetScript("OnClick", function(self) ShowGroup(group) end)
		button:SetScript("OnClick", function(self) ShowGroup(group, button) self:SetText("|cff00ff00"..E.option.."|r") end)		
		offset=offset+E.Scale(20)
	end
	child:SetWidth(E.Scale(125))
	child:SetHeight(offset)
	slider:SetMinMaxValues(0, 1)
	--slider:SetMinMaxValues(0, (offset == 0 and 1 or offset-13*25))
	slider:SetValue(1)
	groups:SetScrollChild(child)
	
	local x
	_G["EuiSetGuiCategoryGroup"]:EnableMouseWheel(true)
	_G["EuiSetGuiCategoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
		if _G["EuiSetGuiCategorySlider"]:IsShown() then
			if delta == -1 then
				x = _G["EuiSetGuiCategorySlider"]:GetValue()
				_G["EuiSetGuiCategorySlider"]:SetValue(x + 10)
			elseif delta == 1 then
				x = _G["EuiSetGuiCategorySlider"]:GetValue()			
				_G["EuiSetGuiCategorySlider"]:SetValue(x - 20)	
			end
		end
	end)
	
	-- GROUP SCROLLFRAME ( RIGHT SIDE)
	local group = CreateFrame("ScrollFrame", "EuiSetGuiGroup", EuiSetGui)
	group:SetPoint("TOPLEFT",0,E.Scale(5))
	group:SetWidth(E.Scale(400))
	group:SetHeight(E.Scale(300))
	local slider = CreateFrame("Slider", "EuiSetGuiGroupSlider", group)
	slider:SetPoint("TOPRIGHT",0,0)
	slider:SetWidth(E.Scale(20))
	slider:SetHeight(E.Scale(300))
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) group:SetVerticalScroll(value) end)
	
	function pairsByKeys (t, f)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0                 -- iterator variable
		local iter = function ()    -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end	
	
	--for group in pairs(ALLOWED_GROUPS) do
	for group in pairsByKeys(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame","EuiSetGui"..group,EuiSetGuiGroup)
		frame:SetPoint("TOPLEFT")
		frame:SetWidth(E.Scale(225))
	
		local offset=5
		for option,value in pairsByKeys(C[group]) do
		
			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "EuiSetGui"..group..option, frame, "InterfaceOptionsCheckButtonTemplate")
				local o = "EuiSetGui"..group..option
				Local(o)
				_G["EuiSetGui"..group..option.."Text"]:SetText(E.option)
				_G["EuiSetGui"..group..option.."Text"]:SetFont(E.font, 12, "OUTLINE")
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", E.Scale(5), -E.Scale((offset)))
				offset = offset+25
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(E.font,12,"OUTLINE")
				local o = "EuiSetGui"..group..option
				Local(o)
				label:SetText(E.option)
				label:SetWidth(E.Scale(360))
				label:SetHeight(E.Scale(20))
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", E.Scale(5), -E.Scale((offset)))
				
				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(E.Scale(220))
				editbox:SetHeight(E.Scale(20))
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3,0,0,0)
				editbox:SetBackdrop({
					bgFile = [=[Interface\Addons\Eui\media\normTex]=], 
					tiled = false,
				})
				editbox:SetBackdropColor(0,0,0,0.5)
				editbox:SetBackdropBorderColor(0,0,0,1)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("TOPLEFT", E.Scale(5), -E.Scale((offset+20)))
				editbox:SetText(value)
				
				E.EuiSetTemplate(editbox)
				
				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SetWidth(editbox:GetHeight())
				E.EuiSetTemplate(okbutton)
				okbutton:SetPoint("LEFT", editbox, "RIGHT", E.Scale(2), 0)
				
				local oktext = okbutton:CreateFontString(nil,"OVERLAY",nil)
				oktext:SetFont(E.font,12,"OUTLINE")
				oktext:SetText("OK")
				oktext:SetPoint("CENTER")
				oktext:SetJustifyH("CENTER")
				okbutton:Hide()
 
				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
				offset = offset+45
			end
		end
				
		frame:SetHeight(E.Scale(offset))
		frame:Hide()
	end

	local reset = NewButton(DEFAULT, EuiSetGui)
	reset:SetWidth(E.Scale(100))
	reset:SetHeight(E.Scale(20))
	reset:SetPoint("BOTTOMLEFT",-E.Scale(10), -E.Scale(38))
	reset:SetScript("OnClick", function(self) EuiSettings = {} ReloadUI() end)
	E.EuiSetTemplate(reset)
	
	local close = NewButton(CLOSE, EuiSetGui)
	close:SetWidth(E.Scale(100))
	close:SetHeight(E.Scale(20))
	close:SetPoint("BOTTOMRIGHT", E.Scale(10), -E.Scale(38))
	close:SetScript("OnClick", function(self) EuiSetGui:Hide() end)
	E.EuiSetTemplate(close)
	
	local load = NewButton(APPLY, EuiSetGui)
	load:SetHeight(E.Scale(20))
	load:SetPoint("LEFT", reset, "RIGHT", E.Scale(15), 0)
	load:SetPoint("RIGHT", close, "LEFT", -E.Scale(15), 0)
	load:SetScript("OnClick", function(self) ReloadUI() end)
	E.EuiSetTemplate(load)
	
	local totalreset = NewButton(e_gui_button_reset, groupsBG)
	totalreset:SetHeight(E.Scale(20))
	totalreset:SetWidth(E.Scale(170))
	totalreset:SetPoint("TOPLEFT", groupsBG, "BOTTOMLEFT", 0, -E.Scale(8))
	totalreset:SetScript("OnClick", function(self) ReloadUI() end)
	--totalreset:SetScript("OnClick", function(self) StaticPopup_Show("RESET_UI") EuiSetGui:Hide() end)
	E.EuiSetTemplate(totalreset)
	
	ShowGroup("main")
end

do
	SLASH_CONFIG1 = '/cfg'
	SLASH_CONFIG2 = '/config'
	function SlashCmdList.CONFIG(msg, editbox)
		if not EuiSetGui or not EuiSetGui:IsShown() then
			CreateEuiSetGui()
		else
			EuiSetGui:Hide()
		end
	end
end

do
	local euihelp = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	euihelp:Hide()

	euihelp.name = "EUI"
	euihelp:SetScript("OnShow", function(self)
		local E, C = unpack(EUI)
		local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", E.Scale(16), -E.Scale(16))
		title:SetText("EUI 相关命令")

		local subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		subtitle:SetHeight(400)
		subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -E.Scale(8))
		subtitle:SetPoint("RIGHT", self, -E.Scale(32), 0)
		subtitle:SetNonSpaceWrap(true)
		subtitle:SetWordWrap(true)
		subtitle:SetJustifyH("LEFT")
		subtitle:SetText(
			"常用设置："..
			"\n界面重设 /eset ui"..
			"\n额外动作条 /g15"..
			"\n插件设置界面 /cfg"..
			"\n重载插件 /rl"..
			"\n绑定动作快捷键 /hb"..
			"\n技能监视添加 /af /addfilter"..
			"\n聊天框重设 /setchat"..
			"\n整合包包设置 /baudbag"..
			"\n框体解锁/锁定, 点聊天框右下角UnLock键"..
			"\n系统菜单栏在小地图中按鼠标中键,或右击右上角设置"..
			"\n追踪菜单在小地图按鼠标右键"..
			"\n时间，背包，日历等可直接点击上面的信息条对应项打开"
		)
		local b = CreateFrame("Button", nil, this, "UIPanelButtonTemplate")
		b:SetWidth(120)
		b:SetHeight(20)
		b:SetText("设 置")
		b:SetScript("OnClick", function()
			InterfaceOptionsFrameCancel_OnClick()
			HideUIPanel(GameMenuFrame)	
			SlashCmdList.CONFIG()
		end)
		b:SetPoint("TOPLEFT", title, "TOPRIGHT", 10, 0)
	end)

	InterfaceOptions_AddCategory(euihelp)
end