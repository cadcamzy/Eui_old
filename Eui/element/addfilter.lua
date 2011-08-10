local E, C, L, DB = unpack(EUI)
if not C["filter"].enable == true then return end
--[[
参数格式:
/af 类型,样式,法术ID,施法者
类型: playerbuff, playerdebuff, targetbuff, targetdebuff
样式: icon ,bar
法术ID: 65556
施法者: "player", "target", "all"
]]
--[[
删除自已添加的监视代码语法:
/af 类型,样式,法术ID,delete(d)
]]

SLASH_ADDFILTER1 = "/addfilter"
SLASH_ADDFILTER2 = "/af"
SlashCmdList["ADDFILTER"] = function(input)
	local input = string.lower(input) --转换为小写
	local unm = {strsplit(",", input)}
	if #unm ~= 4 then
		print(L.ADDFILTER_ERR)
		print(L.ADDFILTER_TIP1)
		print(L.ADDFILTER_TIP2)
		print(L.ADDFILTER_TIP3)
		print(L.ADDFILTER_TIP4)
		print(L.ADDFILTER_TIP5)
		print(L.ADDFILTER_TIP6)
		print(L.ADDFILTER_TIP7)
		print(L.ADDFILTER_TIP8)
		return
	end
	if unm[1] == "playerbuff" or unm[1] == "pb" then
		unm[1] = "playerbuff"
	elseif unm[1] == "targetdebuff" or unm[1] == "td" then
		unm[1] = "targetdebuff"
	elseif unm[1] == "playercd" or unm[1] == "cd" then
		unm[1] = "cd"
	elseif unm[1] == "playerdebuff" or unm[1] == "pd" then
		unm[1] = "playerdebuff"
	elseif unm[1] == "targetbuff" or unm[1] == "tb" then
		unm[1] = "targetbuff"
	elseif unm[1] == "focusbuff" or unm[1] == "fb" then
		unm[1] = "focusbuff"
	elseif unm[1] == "focusdebuff" or unm[1] == "fd" then
		unm[1] = "focusdebuff"
	else		
		print(format(L.ADDFILTER_ERR2, 1))
		return
	end
	if unm[2] ~= "icon" and unm[2] ~= "bar" then
		print(unm[2])
		print(format(L.ADDFILTER_ERR2, 2))
		return
	end

	if unm[1] == "cd" and unm[2] == "bar" then unm[2] = "icon" end	
	
	if not GetSpellInfo(unm[3]) then
		print(format(L.ADDFILTER_ERR2, 3))
		return
	end
	if unm[4] == "delete" or unm[4] == "d" or unm[4] == "del" then
		--删除程序
		local delok = 0
		if filter then
			for k,v in pairs(filter) do
				if filter[k].spellID == tonumber(unm[3]) and filter[k].mode == unm[2] then
					filter[k] = nil
					print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_DEL)
					delok =1
					break;					
				end
			end
			if delok == 1 then return end
		end
	elseif unm[4] ~= "player" and unm[4] ~= "target" and unm[4] ~= "all" then
		print(format(L.ADDFILTER_ERR2, 4))
		return
	end
	if unm[1]=='playerbuff' and unm[2] == "icon" and C["filter"].pbufficon ~= true then
		print(L.ADDFILTER_PB_ICON)
		return
	end
	if unm[1]=='playerbuff' and unm[2] == "bar" and C["filter"].pbuffbar ~= true then
		print(L.ADDFILTER_PB_BAR)
		return
	end
	if unm[1]=='targetdebuff' and unm[2] == "icon" and C["filter"].tdebufficon ~= true then
		print(L.ADDFILTER_TD_ICON)
		return
	end
	if unm[1]=='targetdebuff' and unm[2] == "bar" and C["filter"].tdebuffbar ~= true then
		print(L.ADDFILTER_TD_BAR)
		return
	end
	if unm[1]=='playerdebuff' and unm[2] == "icon" and C["filter"].pdebufficon ~= true then
		print(L.ADDFILTER_PD_ICON)
		return
	end
	if unm[1]=='targetbuff' and unm[2] == "icon" and C["filter"].tbufficon ~= true then
		print(L.ADDFILTER_TB_ICON)
		return
	end
	if unm[1]=='focusbuff' and unm[2] == "icon" and C["filter"].fbufficon ~= true then
		print(L.ADDFILTER_FB_ICON)
		return
	end
	if unm[1]=='focusdebuff' and unm[2] == "icon" and C["filter"].fdebufficon ~= true then
		print(L.ADDFILTER_FD_ICON)
		return
	end	
	
	if unm[1]=='cd' and C["filter"].pcdicon ~= true then
		print(L.ADDFILTER_CD_ICON)
		return
	end
	
	for i = 1, #Filger_Spells[E.MyClass] do
		if unm[1] == "playerbuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "playerbufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].piconsize,
					unitId = "player",
					caster = unm[4],
					filter = "BUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].piconsize,
					unitId = "player",
					caster = unm[4],
					filter = "BUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end
		if unm[1] == "playerbuff" and unm[2] == "bar" then
			if Filger_Spells[E.MyClass][i].Name == "playerbuffbar" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].barheight,
					barWidth = C["unitframe"].playerwidth,
					unitId = "player",
					caster = unm[4],
					filter = "BUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].barheight,
					barWidth = C["unitframe"].playerwidth,
					unitId = "player",
					caster = unm[4],
					filter = "BUFF",
					mode = unm[2],
					k = i
				})			
				break;
			end
		end		
		if unm[1] == "targetdebuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "targetdebufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF",
					mode = unm[2],
					k = i
				})			
				break;
			end
		end
		if unm[1] == "targetdebuff" and unm[2] == "bar" then
			if Filger_Spells[E.MyClass][i].Name == "targetdebuffbar" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].barheight,
					barWidth = C["unitframe"].playerwidth,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].barheight,
					barWidth = C["unitframe"].playerwidth,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end	
		if unm[1] == "cd" then
			if Filger_Spells[E.MyClass][i].Name == "playercdicon" then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].cdsize,
					filter = "CD"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].cdsize,
					filter = "CD",
					mode = unm[2],
					k = i
				})
				break;
			end
		end
		
		if unm[1] == "playerdebuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "playerdebufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].piconsize,
					unitId = "player",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].piconsize,
					unitId = "player",
					caster = unm[4],
					filter = "DEBUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end		

		if unm[1] == "targetbuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "targetbufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "BUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "BUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end			

		if unm[1] == "targetdebuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "targetdebufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].ticonsize,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end	
		
		if unm[1] == "focusbuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "focusbufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].ficonsize,
					unitId = "focus",
					caster = unm[4],
					filter = "BUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].ficonsize,
					unitId = "focus",
					caster = unm[4],
					filter = "BUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end			

		if unm[1] == "focusdebuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "focusdebufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].ficonsize,
					unitId = "focus",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3]))..L.ADDFILTER_ADD)
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].ficonsize,
					unitId = "focus",
					caster = unm[4],
					filter = "DEBUFF",
					mode = unm[2],
					k = i
				})		
				break;
			end
		end	
		
	end
end