local E, C = unpack(EUI)
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
		print("参数格式不对!")
		print("/af 类型,样式,法术ID,施法者")
		print("/af 类型,样式,法术ID,delete")
		print("类型: 玩家BUFF: playerbuff(pb),目标DEBUFF: targetdebuff(td), 玩家技能冷却: cd")
		print("样式: 图标: icon, 计时条: bar")
		print("法术ID: 一组数字如:65532,由鼠标提示中获得")
		print("施法者: 玩家: player, 目标: target, 任何人: all")
		print("/af pb,icon,1243,player 示范代码添加坚韧的图标监视")
		print("/af cd,icon,59752,player 示范代码添加自利的冷却监视")
		return
	end
	if unm[1] == "playerbuff" or unm[1] == "pb" then
		unm[1] = "playerbuff"
	elseif unm[1] == "targetdebuff" or unm[1] == "td" then
		unm[1] = "targetdebuff"
	elseif unm[1] == "playercdicon" or unm[1] == "cd" then
		unm[1] = "cd"
	else
		print("参数1错误!")
		return
	end
	if unm[2] ~= "icon" and unm[2] ~= "bar" then
		print(unm[2])
		print("参数2错误")
		return
	end

	if unm[1] == "cd" and unm[2] == "bar" then unm[2] = "icon" end	
	
	if not GetSpellInfo(unm[3]) then
		print("参数3错误")
		return
	end
	if unm[4] == "delete" or unm[4] == "d" or unm[4] == "del" then
		--删除程序
		local delok = 0
		if filter then
			for k,v in pairs(filter) do
				if filter[k].spellID == tonumber(unm[3]) and filter[k].mode == unm[2] then
					filter[k] = nil
					print(select(1, GetSpellInfo(unm[3])).." 删除成功,重载后生效!")
					delok =1
					break;					
				end
			end
			if delok == 1 then return end
		end
	elseif unm[4] ~= "player" and unm[4] ~= "target" and unm[4] ~= "all" then
		print("参数4错误")
		return
	end
	if unm[1]=='playerbuff' and unm[2] == "icon" and C["filter"].pbufficon ~= true then
		print("玩家BUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关")
		return
	end
	if unm[1]=='playerbuff' and unm[2] == "bar" and C["filter"].pbuffbar ~= true then
		print("玩家BUFF计时条提示已被禁用,无法添加,请先到设置中打开对应开关")
		return
	end
	if unm[1]=='targetdebuff' and unm[2] == "icon" and C["filter"].tdebufficon ~= true then
		print("目标DEBUFF图标提示已被禁用,无法添加,请先到设置中打开对应开关")
		return
	end
	if unm[1]=='targetdebuff' and unm[2] == "bar" and C["filter"].tdebuffbar ~= true then
		print("目标DEBUFF计时条提示已被禁用,无法添加,请先到设置中打开对应开关")
		return
	end
	if unm[1]=='cd' and C["filter"].pcdicon ~= true then
		print("玩家CD图标提示已被禁用,无法添加,请选到设置中打开对应开关")
		return
	end	
	for i = 1, #Filger_Spells[E.MyClass] do
		if unm[1] == "playerbuff" and unm[2] == "icon" then
			if Filger_Spells[E.MyClass][i].Name == "playerbufficon" and Filger_Spells[E.MyClass][i].Mode == string.upper(unm[2]) then
				table.insert(Filger_Spells[E.MyClass][i],{
					spellID = tonumber(unm[3]),
					size = C["filter"].iconsize,
					unitId = "player",
					caster = unm[4],
					filter = "BUFF"
				})
				print(select(1, GetSpellInfo(unm[3])).." 添加成功")
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].iconsize,
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
				print(select(1, GetSpellInfo(unm[3])).." 添加成功")
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
					size = C["filter"].iconsize,
					unitId = "target",
					caster = unm[4],
					filter = "DEBUFF"
				})
				print(select(1, GetSpellInfo(unm[3])).." 添加成功")
				if filter == nil then filter = {} end
				table.insert(filter,{
					spellID = tonumber(unm[3]),
					size = C["filter"].iconsize,
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
				print(select(1, GetSpellInfo(unm[3])).." 添加成功")
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
				print(select(1, GetSpellInfo(unm[3])).."添加成功")
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
		
	end
end