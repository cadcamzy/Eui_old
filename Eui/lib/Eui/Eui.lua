local E, C, L = unpack(EUI)

E.MyClass = select(2, UnitClass("player"))
E.MyName = UnitName("player")
E.MyLevel = UnitLevel("player")
E.myrealm = GetRealmName()
E.dummy = function() return end
--_, class = UnitClass("player")
local kill = function() end
function E.Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = kill
	object:Hide()
end
E.RAID_CLASS_COLORS = {
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 }, 
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 }, 
    ["PRIEST"] = { r = 0.83, g = 0.83, b = 0.83 }, 
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 }, 
    ["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 }, 
    ["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 }, 
    ["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 }, 
    ["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 }, 
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 }, 
    ["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}


---------------------------------------------------- Textures

E.normTex = [[Interface\AddOns\Eui\media\normTex]]
E.glowTex = [[Interface\AddOns\Eui\media\glowTex]]
E.blackTex = [[Interface\AddOns\Eui\media\blackTex]]
E.highlightTex = [[Interface\AddOns\Eui\media\highlightTex]]
E.borderTex = [[Interface\AddOns\Eui\media\border]]
E.blank = [[Interface\AddOns\Eui\media\blank]]
E.gray = [[Interface\AddOns\Eui\media\gray]]
E.statusbar = string.format("Interface\\AddOns\\Eui\\media\\statusbar\\%d", C["skins"].texture)
E.backdrop = {
	bgFile = E.normTex,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

E.utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

---------------------------------------------------- Colors

E.EuiGradient = {.26,.26,.26,.14,.21,.21,.21,.5}

---------------------------------------------------- Fonts

E.font = STANDARD_TEXT_FONT
--fontc = [[Interface\AddOns\Eui\media\fontc.ttf]]
--fontn = [[Interface\AddOns\Eui\media\fontn.ttf]]
E.fontc = STANDARD_TEXT_FONT
E.fontn = STANDARD_TEXT_FONT
E.fontp = "Interface\\Addons\\Eui\\media\\ROADWAY.ttf"
---------------------------------------------------- EuiSetFontn

E.EuiSetFontn = function(parent, fontName, fontHeight, fontStyle)		-- 信息及Coolline数字字体
	fontName = fontName or E.fontn
	fontHeight = fontHeight or 10
	fontStyle = fontStyle or "OUTLINE"
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)								-- 括号内为(字体,大小,样式),可自行修改
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(0, 0)
	fs:SetParent(parent)
	return fs
	
end

---------------------------------------------------- EuiCreateShadow

E.EuiCreateShadow = function(f)
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -3, 3)
	shadow:SetPoint("BOTTOMLEFT", -3, -3)
	shadow:SetPoint("TOPRIGHT", 3, 3)
	shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop( { 
		edgeFile = E.glowTex, edgeSize = 3,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
	})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.7)
	--shadow:SetBackdropBorderColor(1, 1, 1, 1)
	f.shadow = shadow
end

E.EuiStyleInnerBorder = function(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", E.mult, -E.mult)
	f.iborder:SetPoint("BOTTOMRIGHT", -E.mult, E.mult)
	f.iborder:SetBackdrop({
		edgeFile = E.glowTex, 
		edgeSize = E.mult, 
		insets = { left = E.mult, right = E.mult, top = E.mult, bottom = E.mult }
	})
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end		
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f.iborder:SetBackdropBorderColor(r, g, b,1)
	else	
		f.iborder:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
	return f.iborder
end

E.EuiFadeIn = function(f)
	UIFrameFadeIn(f, 0.3, f:GetAlpha(), 1)
end
	
E.EuiFadeOut = function(f)
	UIFrameFadeOut(f, 0.3, f:GetAlpha(), 0)
end

E.EuiStyleOuterBorder = function(f)
	if f.oborder then return end
	f.oborder = CreateFrame("Frame", nil, f)
	f.oborder:SetPoint("TOPLEFT", -E.mult, E.mult)
	f.oborder:SetPoint("BOTTOMRIGHT", E.mult, -E.mult)
	f.oborder:SetBackdrop({
		edgeFile = E.glowTex, 
		edgeSize = E.mult, 
		insets = { left = E.mult, right = E.mult, top = E.mult, bottom = E.mult }
	})
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end		
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f.oborder:SetBackdropBorderColor(r, g, b,1)
	else	
		f.oborder:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
	return f.oborder
end

E.EuiSkinFadedPanel = function(f,alpha)
	alpha = alpha or .7
	f:SetBackdrop(E.backdrop)
	f:SetBackdropColor(0.1,0.1,0.1,alpha)
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end		
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f:SetBackdropBorderColor(r, g, b,alpha)
	else	
		f:SetBackdropBorderColor(0.31, 0.45, 0.63,alpha)
	end
	E.EuiStyleInnerBorder(f)
	E.EuiStyleOuterBorder(f)
end

E.EuiCreateFadedPanel = function(f, w, h, a1, p, a2, x, y)
	f:SetFrameLevel(1)
	f:SetHeight(h)
	f:SetWidth(w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	E.EuiSkinFadedPanel(f)
end

-- Create overlay frame
E.EuiSetOverlay = function(f)
	if f.bg then return end
	f.bg = f:CreateTexture(f:GetName() and f:GetName().."_overlay" or nil, "BORDER", f)
	f.bg:ClearAllPoints()
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", E.mult, -E.mult)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -E.mult, E.mult)
	f.bg:SetTexture(gray)
	f.bg:SetVertexColor(0.1, 0.1, 0.1, 1)
	return f.bg
end

-- Skin panels
E.EuiSkinPanel = function(f)
	f:SetBackdrop(E.backdrop)
	f:SetBackdropColor(0.1,0.1,0.1,0.7)
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end		
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f:SetBackdropBorderColor(r, g, b,1)
	else	
		f:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
	E.EuiSetOverlay(f)
end
---------------------------------------------------- EuiCreatePanel

E.EuiCreatePanel = function(f, w, h, a1, p, a2, x, y)
	f:SetFrameLevel(0)
	f:SetHeight(h)
	f:SetWidth(w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile = E.normTex, 
	  edgeFile = E.normTex, 
	  tile = false, tileSize = 0, edgeSize = 1, 
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor( 0, 0, 0,0)
	f:SetBackdropBorderColor(0, 0, 0,0)
end

E.EuiSetTransparentTemplate = function(f)
    f:SetFrameLevel(1)
    f:SetFrameStrata("BACKGROUND")
    f:SetBackdrop({
      bgFile = E.blank,
      edgeFile = E.blank,
      tile = false, tileSize = 0, edgeSize = E.mult,
      insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult}
    })
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end		
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f:SetBackdropColor(0.1,0.1,0.1,1)
		f:SetBackdropBorderColor(r, g, b,1)
	else
		f:SetBackdropColor(0.1,0.1,0.1,1)
		f:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
end

---------------------------------------------------- EuiSetTemplate
E.EuiSetTemplate = function(f,a)
	local alpha = a or .7
	f:SetBackdrop({
	  bgFile = E.normTex, 
	  edgeFile = E.normTex, 
	  tile = false, tileSize = 0, edgeSize = E.mult, 
	  insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult}
	})
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end	
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		f:SetBackdropColor(0.1,0.1,0.1,alpha)
		f:SetBackdropBorderColor(r, g, b,1)
	else
		f:SetBackdropColor(0.1,0.1,0.1,alpha)		
		f:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
end

E.EuiCreateBackdrop = function(f,t)
	local b = CreateFrame("Frame", nil, f)
	b:SetPoint("TOPLEFT", -2, 2)
	b:SetPoint("BOTTOMRIGHT", 2, -2)
	E.EuiSetTemplate(b,t)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end

E.EuiSetTemplateB = function(f,x1,y1,x2,y2)
	if f.GetBackdrop and f:GetBackdrop() then f:SetBackdrop(nil) end
	local skinFrame = CreateFrame("Frame", nil, f)
	skinFrame:ClearAllPoints()
	skinFrame:SetFrameStrata("BACKGROUND")
	if x1 == 0 and y1 == 0 and x2 == 0 and y2 == 0 then
	 	skinFrame:SetAllPoints(f)
	else
		skinFrame:SetPoint("TOPLEFT", f, "TOPLEFT", x1, y1)
		skinFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", x2, y2)
	end
	skinFrame:SetBackdrop({
	  bgFile = E.normTex, 
	  edgeFile = E.normTex, 
	  tile = false, tileSize = 0, edgeSize = E.mult, 
	  insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult}
	})
	if C["main"].classcolorcustom ~= "0" and C["main"].classcolorcustom:find(",") > 1 then
		local color = { strsplit(",", C["main"].classcolorcustom) }
		if #color == 3 then
			if tonumber(color[1]) >= 0 and tonumber(color[1]) <= 255 and tonumber(color[2]) >=0 and tonumber(color[2]) <= 255 and tonumber(color[3]) >=0 and tonumber(color[3]) <= 255 then
				E.RAID_CLASS_COLORS[E.MyClass].r = tonumber(color[1])/255
				E.RAID_CLASS_COLORS[E.MyClass].g = tonumber(color[2])/255
				E.RAID_CLASS_COLORS[E.MyClass].b = tonumber(color[3])/255
			else
				C["main"].classcolorcustom = "0"
			end
		else
			C["main"].classcolorcustom = "0"
		end
	end	
	if C["main"].classcolortheme == true then
		local r, g, b = E.RAID_CLASS_COLORS[E.MyClass].r, E.RAID_CLASS_COLORS[E.MyClass].g, E.RAID_CLASS_COLORS[E.MyClass].b	
		skinFrame:SetBackdropColor(0.1,0.1,0.1,.7)
		skinFrame:SetBackdropBorderColor(r, g, b,1)
	else
		skinFrame:SetBackdropColor(0.1,0.1,0.1,.7)
		skinFrame:SetBackdropBorderColor(0.31, 0.45, 0.63,1)
	end
end


---------------------------------------------------- EuiCreateFrame

local function TempStyle(myframe,nobg,off)	
	local off = off or 2
	if nobg ~= true then
		myframe.bg = myframe:CreateTexture(nil,"BORDER")
		myframe.bg:SetPoint("TOPLEFT",off+1,-off-1)
		myframe.bg:SetPoint("BOTTOMRIGHT",-off-1,off+1)
		myframe.bg:SetTexture(1,1,1,1)
		myframe.bg:SetGradientAlpha("VERTICAL",unpack(E.EuiGradient))
		myframe.bg:SetBlendMode("ADD")
	end
	
	myframe.left = myframe:CreateTexture(nil,"OVERLAY")
	myframe.left:SetTexture(0,0,0)
	myframe.left:SetPoint("TOPLEFT",off,-off)
	myframe.left:SetPoint("BOTTOMLEFT",off,off)
	myframe.left:SetWidth(1)

	myframe.right = myframe:CreateTexture(nil,"OVERLAY")
	myframe.right:SetTexture(0,0,0)
	myframe.right:SetPoint("TOPRIGHT",-off,-off)
	myframe.right:SetPoint("BOTTOMRIGHT",-off,off)
	myframe.right:SetWidth(1)

	myframe.bottom = myframe:CreateTexture(nil,"OVERLAY")
	myframe.bottom:SetTexture(0,0,0)
	myframe.bottom:SetPoint("BOTTOMLEFT",off,off)
	myframe.bottom:SetPoint("BOTTOMRIGHT",-off,off)
	myframe.bottom:SetHeight(1)

	myframe.top = myframe:CreateTexture(nil,"OVERLAY")
	myframe.top:SetTexture(0,0,0)
	myframe.top:SetPoint("TOPLEFT",off,-off)
	myframe.top:SetPoint("TOPRIGHT",-off,off)
	myframe.top:SetHeight(1)

	return myframe
end

local bg_ = {
	bgFile = E.normTex, 
	edgeFile = E.glowTex, 
	edgeSize = 3, insets = { left = 2, right = 2, top = 2, bottom = 2}}

local TempSetBackdrop = function (self)
	self:SetBackdrop(bg_)
	self:SetBackdropBorderColor(0,0,0,0.7)
	self:SetBackdropColor(0,0,0,1)
	return self
end

E.EuiCreateFrame = function (parent,level,strata,nobg,nols,off)
	local myframe = CreateFrame ("Frame",nil,parent)
	if nols ~= true then
		myframe:SetFrameLevel(level or 2)
		myframe:SetFrameStrata(strata or "BACKGROUND")
	end
	TempSetBackdrop(myframe)
	TempStyle(myframe,nobg,off)
	return myframe
end

---------------------------------------------------- Animation

E.EuiSetAnim = function(f,k,x,y)
	f.anim = f:CreateAnimationGroup("Move_In")
	f.anim.in_a = f.anim:CreateAnimation("Translation")
	f.anim.in_a:SetDuration(0)
	f.anim.in_a:SetOrder(1)
	f.anim.in_b = f.anim:CreateAnimation("Translation")
	f.anim.in_b:SetDuration(.3)
	f.anim.in_b:SetOrder(2)
	f.anim.in_b:SetSmoothing("OUT")
	f.anim_o = f:CreateAnimationGroup("Move_Out")
	f.anim_o.b = f.anim_o:CreateAnimation("Translation")
	f.anim_o.b:SetDuration(.3)
	f.anim_o.b:SetOrder(1)
	f.anim_o.b:SetSmoothing("IN")
	f.anim.in_a:SetOffset(x,y)
	f.anim.in_b:SetOffset(-x,-y)
	f.anim_o.b:SetOffset(x,y)	
	if k then f.anim_o:SetScript("OnFinished",function() f:Hide() end) end
end

---------------------------------------------------- Alert Run

local GetNextChar = function(word,num)
	local c = word:byte(num)
	local shift
	if not c then return "",num end
		if (c > 0 and c <= 127) then
			shift = 1
		elseif (c >= 192 and c <= 223) then
			shift = 2
		elseif (c >= 224 and c <= 239) then
			shift = 3
		elseif (c >= 240 and c <= 247) then
			shift = 4
		end
	return word:sub(num,num+shift-1),(num+shift)
end

local updaterun = CreateFrame("Frame")

local flowingframe = CreateFrame("Frame",nil,UIParent)
	flowingframe:SetFrameStrata("HIGH")
	flowingframe:SetPoint("CENTER",UIParent,0,136)
	flowingframe:SetHeight(64)
	flowingframe:SetScript("OnUpdate", FadingFrame_OnUpdate)
	flowingframe:Hide()
	flowingframe.fadeInTime = 0
	flowingframe.holdTime = 1
	flowingframe.fadeOutTime = .3
	
local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
	flowingtext:SetPoint("Left")
	flowingtext:SetFont(E.font,20,"OUTLINE")
	flowingtext:SetShadowOffset(0,0)
	flowingtext:SetJustifyH("LEFT")
	
local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetFont(E.font,50,"OUTLINE")
	rightchar:SetShadowOffset(0,0)
	rightchar:SetJustifyH("LEFT")

local count,len,step,word,stringE,a

local speed = .03333

local nextstep = function()
	a,step = GetNextChar (word,step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = string.upper(a)
	rightchar:SetText(a)
end

local updatestring = function(self,t)
	count = count - t
		if count < 0 then
			if step > len then 
				self:Hide()
				flowingtext:SetText(stringE)
				FadingFrame_Show(flowingframe)
				rightchar:SetText("")
				word = ""
			else 
				nextstep()
				FadingFrame_Show(flowingframe)
				count = speed
			end
		end
end

updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()

E.EuiAlertRun = function(f,r,g,b)
	flowingframe:Hide()
	updaterun:Hide()
	
		flowingtext:SetText(f)
		local l = flowingtext:GetWidth()
		
	local color1 = r or 1
	local color2 = g or 1
	local color3 = b or 1
	
	flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95)
	rightchar:SetTextColor(color1,color2,color3)
	
	word = f
	len = f:len()
	step = 1
	count = speed
	stringE = ""
	a = ""
	
		flowingtext:SetText("")
		flowingframe:SetWidth(l)
		
	rightchar:SetText("")
	FadingFrame_Show(flowingframe)
	updaterun:Show()
end

E.CreateBG = function(parent, alpha)
	local a = alpha or .65
	local bg = CreateFrame('Frame', nil, parent or UIParent)
	bg:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
	bg:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', 2, -2)
	bg:SetFrameLevel(parent:GetFrameLevel()-1 > 0 and parent:GetFrameLevel()-1 or 0)
	bg:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg:SetBackdropColor(0, 0, 0, a) 
    bg:SetBackdropBorderColor(.35, .3, .3, 1)
	bg.border = CreateFrame("Frame", nil, bg)
	bg.border:SetPoint("TOPLEFT", 1, -1)
	bg.border:SetPoint("BOTTOMRIGHT", -1, 1)
	bg.border:SetFrameLevel(bg:GetFrameLevel())
	bg.border:SetBackdrop({
	  edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	  edgeSize = 1,
	  insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border:SetBackdropBorderColor(0, 0, 0, 1)
	bg.border2 = CreateFrame("Frame", nil, bg)
	bg.border2:SetPoint("TOPLEFT", -1, 1)
	bg.border2:SetPoint("BOTTOMRIGHT", 1, -1)
	bg.border2:SetFrameLevel(bg:GetFrameLevel())
	bg.border2:SetBackdrop({
	  edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	  edgeSize = 1,
	  insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	bg.border2:SetBackdropBorderColor(0, 0, 0, 0.9)
	return bg
end



function E.StyleButton(b, c) 
    local name = b:GetName()
 
    local button          = _G[name]
    local icon            = _G[name.."Icon"]
    local count           = _G[name.."Count"]
    local border          = _G[name.."Border"]
    local hotkey          = _G[name.."HotKey"]
    local cooldown        = _G[name.."Cooldown"]
    local nametext        = _G[name.."Name"]
    local flash           = _G[name.."Flash"]
    local normaltexture   = _G[name.."NormalTexture"]
	local icontexture     = _G[name.."IconTexture"]
	
	local hover = b:CreateTexture("frame", nil, self) -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:SetHeight(button:GetHeight())
	hover:SetWidth(button:GetWidth())
	hover:SetPoint("TOPLEFT",button,E.Scale(2),-E.Scale(2))
	hover:SetPoint("BOTTOMRIGHT",button,-E.Scale(2),E.Scale(2))
	button:SetHighlightTexture(hover)

	local pushed = b:CreateTexture("frame", nil, self) -- pushed
	pushed:SetTexture(0.9,0.8,0.1,0.3)
	pushed:SetHeight(button:GetHeight())
	pushed:SetWidth(button:GetWidth())
	pushed:SetPoint("TOPLEFT",button,E.Scale(2),-E.Scale(2))
	pushed:SetPoint("BOTTOMRIGHT",button,-E.Scale(2),E.Scale(2))
	button:SetPushedTexture(pushed)
	
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT",button,E.Scale(2),-E.Scale(2))
		cooldown:SetPoint("BOTTOMRIGHT",button,-E.Scale(2),E.Scale(2))
	end
 
	if c then
		local checked = b:CreateTexture("frame", nil, self) -- checked
		checked:SetTexture(23/255,132/255,209/255)
		checked:SetHeight(button:GetHeight())
		checked:SetWidth(button:GetWidth())
		checked:SetPoint("TOPLEFT",button,E.Scale(2),-E.Scale(2))
		checked:SetPoint("BOTTOMRIGHT",button,-E.Scale(2),E.Scale(2))
		checked:SetAlpha(0.3)
		button:SetCheckedTexture(checked)
	end
end

local UpdaterOnUpdate = function(Updater)
	Updater:Hide()
	local b = Updater:GetParent()
	local tex = b:GetStatusBarTexture()
	tex:ClearAllPoints()
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetPoint("TOPLEFT", b, "TOPRIGHT", (b:GetValue()/select(2,b:GetMinMaxValues())-1)*b:GetWidth(), 0)
end
local OnChanged = function(bar)
	bar.Updater:Show()
	bar:SetStatusBarColor(unpack(bar:GetParent().Health.StatusBarColor))
end
E.ReverseBar = function(f)
	local bar = CreateFrame("StatusBar", nil, f)
	bar.Updater = CreateFrame("Frame", nil, bar)
	bar.Updater:Hide()
	bar.Updater:SetScript("OnUpdate", UpdaterOnUpdate)
	bar:SetScript("OnSizeChanged", OnChanged)
	bar:SetScript("OnValueChanged", OnChanged)
	bar:SetScript("OnMinMaxChanged", OnChanged)
	return bar;
end


function E.UpdateHotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
		
	text = string.gsub(text, '(s%-)', 'S')
	text = string.gsub(text, '(a%-)', 'A')
	text = string.gsub(text, '(c%-)', 'C')
	text = string.gsub(text, '(Mouse Button )', 'M')
	text = string.gsub(text, KEY_BUTTON3, 'M3')
	text = string.gsub(text, '(Num Pad )', 'N')
	text = string.gsub(text, KEY_PAGEUP, 'PU')
	text = string.gsub(text, KEY_PAGEDOWN, 'PD')
	text = string.gsub(text, KEY_SPACE, 'SpB')
	text = string.gsub(text, KEY_INSERT, 'Ins')
	text = string.gsub(text, KEY_HOME, 'Hm')
	text = string.gsub(text, KEY_DELETE, 'Del')
	text = string.gsub(text, KEY_MOUSEWHEELUP, 'MwU')
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, 'MwD')
		
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

E.ColorBorder = function(self, R, G, B)
    if (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(R, G, B)
        end
    else
        local name
        if (self:GetName()) then
            name = self:GetName()
        else
            name = 'Unnamed'
        end
        print('|cff00FF00Beautycase:|r '..name..'|cffFF0000 has no border!|r')        
    end
end

E.EuiInfo = function(p, f)
	local p2y = {
		1,
		-2,
		2,
		-3,
		3,
		-4,
		4,
		-5,
		5,
		-6,
		6,
		-7,
		7,
		-8,
		8,
		-9,
		9,
	}
	y = p2y[p]
	if p == 1 then
		f:SetPoint("LEFT", EuiTopInfobg,"LEFT", 4, 0)
	else
		f:SetPoint("LEFT", EuiTopInfobg, "LEFT", 70*(p-1)+ 4*p, 0)
	end
	f:SetParent(EuiTopInfobg)
	f:SetAlpha(0)
	local r = abs(y)*.5 + 3
	CreateFrame("Frame"):SetScript("OnUpdate",function(self,t) 
		r = r - t 
		if r < 0 then 
			self:Hide()
			self = nil
			UIFrameFadeIn(f,.5,0,1)
		end
	end)
end

E.EuiSetTooltip = function(f,title,L1,R1,L2,R2,L3,R3,L4,R4)
	f:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			GameTooltip:SetOwner(f, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:ClearLines()
			GameTooltip:SetText(title or " ")
			if title then GameTooltip:AddLine(" ") end
			if L1 and R1 then GameTooltip:AddDoubleLine(L1,R1,16/255,226/255,5/255,1,1,1) end
			if L2 and R2 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L2,R2,16/255,226/255,5/255,1,1,1) end
			if L3 and R3 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L3,R3,16/255,226/255,5/255,1,1,1) end
			if L4 and R4 then GameTooltip:AddLine(" "); GameTooltip:AddDoubleLine(L4,R4,16/255,226/255,5/255,1,1,1) end
			GameTooltip:Show()
		end
	end)

	f:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

end

E.CheckForKnownTalent = function(spellid)
	local wanted_name = GetSpellInfo(spellid)
	if not wanted_name then return nil end
	local num_tabs = GetNumTalentTabs()
	for t=1, num_tabs do
		local num_talents = GetNumTalents(t)
		for i=1, num_talents do
			local name_talent, _, _, _, current_rank = GetTalentInfo(t,i)
			if name_talent and (name_talent == wanted_name) then
				if current_rank and (current_rank > 0) then
					return true
				else
					return false
				end
			end
		end
	end
	return false
end

E.UpdateShards = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.2)
		end
	end
end

E.UpdateHoly = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.2)
		end
	end
end	

function E.SpawnMenu(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if self.unit == "targettarget" then return end
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

E.PortraitUpdate = function(self, unit) 
	if C["unitframe"].aaaaunit == 2 then
		self:SetAlpha(0) self:SetAlpha(0.35) 
	end
		
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end	
end	

local waitTable = {}
local waitFrame
function E.Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
				  tinsert(waitTable,i,{d-elapse,f,p})
				  i = i + 1
				else
				  count = count - 1
				  f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

E.CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Magic = false, Curse = true, },
	PALADIN = { Magic = false, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Magic = false, Curse = true, Poison = true, },
	ROGUE = {},
	HUNTER = {},
	WARRIOR = {},
	WARLOCK = {},
	DEATHKNIGHT = {},	
}

function E.ChangeCanDispel()
	if E.MyClass == "PALADIN" then
	--Check to see if we have the 'Sacred Cleansing' talent.
		if E.CheckForKnownTalent(53551) then
			E.CanDispel[E.MyClass].Magic = true
		else
			E.CanDispel[E.MyClass].Magic = false	
		end
	elseif E.MyClass == "SHAMAN" then
		--Check to see if we have the 'Improved Cleanse Spirit' talent.
		if E.CheckForKnownTalent(77130) then
			E.CanDispel[E.MyClass].Magic = true
		else
			E.CanDispel[E.MyClass].Magic = false	
		end
	elseif E.MyClass == "DRUID" then
		--Check to see if we have the 'Nature's Cure' talent.
		if E.CheckForKnownTalent(88423) then
			E.CanDispel[E.MyClass].Magic = true
		else
			E.CanDispel[E.MyClass].Magic = false	
		end
	end
end	