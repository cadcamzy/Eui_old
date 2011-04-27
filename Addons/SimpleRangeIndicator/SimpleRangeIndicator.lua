--******************************************************************************************************
--[[
	SimpleRangeIndicator
	Author: Elsia, based on InCombatIndicator, to remove need for move addon.
	
	Based on SimpleRange by:
	Autor: Bo
	E-Mail: webmaster@myrtana.de
--]]

simplerangeindicator_version = 2.41;
simplerangeindicator_on = 1;

local lastUpdate = 0 -- time since last real update
local UpdateDelay = .33 -- update frequency == 1/UpdateDelay

local Default = {
	profile =
	{
		font = 
		{ textSize	= 18,
	      textfont = "Friz Quadrata TT",
		},
		pos	= {},
		friendly = true,
		locked = false
	}
}

SimpleRangeIndicator = LibStub("AceAddon-3.0"):NewAddon("SimpleRangeIndicator","AceEvent-3.0", --[["AceTimer-3.0",]] "AceConsole-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SimpleRangeIndicator")
local SML = LibStub:GetLibrary("LibSharedMedia-3.0")
local RangeCheck = LibStub:GetLibrary("LibRangeCheck-2.0")

-- This is a bandaid for bad default behavior of AceDBOptions-3.0/AceConfig-3.0. Rather aggressive and should be removed when AceDBOptions-3.0 is fixed.

--[[local function FixProfileOptions(v2)
	for k,v in pairs(v2) do
		if type(v)=="table" then
			FixProfileOptions(v)
			if k ~= "args" then
				v["width"]="full"
			end
		end
	end
end]]

if not deepcopy then
function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end
end



function SimpleRangeIndicator:OnInitialize()

	local Options = {
		name = "SimpleRangeIndicator",
		type = "group",
		args = {
	        lock = {
	            name = "锁定位置",
	            type = "toggle",
	            desc = "Lock/Unlock the button.",
	            get = function(info) return self.db.profile.locked end,
	            set = function(info,v ) self.db.profile.locked = v end,
				order = 10,
            },
			friendly = {
				name = "显示友方目标距离", type = "toggle",
				desc = "Enable/Disable showing friendly target ranges.",
	            get = function(info) return self.db.profile.friendly end,
	            set = function(info,v ) self.db.profile.friendly = v self:TargetChanged() end,
				order = 20,
			},
		}
	}
	
	local Options2= deepcopy(Options) -- This is needed because ace3 folks won't handle inserting into blizz ui nicely.
			
	Options2.args.font = {
				name = "字体", type = 'group', 
				desc = "Set the font size of different elements.",
				args = {
					text = {
						name = "字体大小", type = 'range', min = 6, max = 32, step = 1, --width = "full",
						desc = "Set the font size on the button.",
						get = function(info) return self.db.profile.font.textSize end,
						set = function(info,v )
							self.db.profile.font.textSize = v
							self:Layout()
						end
					},
				},
				order = 50,
	}
	
	if SML then
		Options2.args.font.args.textfont = {
			name = "选择字体", --width = "full",
			desc = "Typeface to use for the text.",
			type = "select", 
			values = SML:List("font"),
			get = function()
				for k, v in pairs(SML:List("font")) do
					if self.db.profile.font.textfont == v then
						return k
					end
				end
				return k
			end,
			set = function(_,v )
				self.db.profile.font.textfont = SML:List("font")[v]
				self:Layout()
			end,
			order = 210
		}
	end

	local acedb = LibStub:GetLibrary("AceDB-3.0")
	self.db = acedb:New("SimpleRangeIndicatorDB", Default)
	self.db.RegisterCallback( self, "OnNewProfile", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileReset", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileChanged", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileCopied", "HandleProfileChanges" )

	Options2.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
	--FixProfileOptions(Options.args.profile)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SimpleRangeIndicator", Options2, "sri")
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleRangeIndicator Font",Options2.args.font)
 	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleRangeIndicator Blizz", Options)

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleRangeIndicator Profile", Options2.args.profile)
	
	AceConfigDialog:AddToBlizOptions("SimpleRangeIndicator Blizz", "SimpleRangeIndicator") -- 3 adds instead of one to avoid bloat, and a table duplication :P
	AceConfigDialog:AddToBlizOptions("SimpleRangeIndicator Profile", "Profile", "SimpleRangeIndicator")
	AceConfigDialog:AddToBlizOptions("SimpleRangeIndicator Font", "Font", "SimpleRangeIndicator")

	--optFrame = AceConfigDialog:AddToBlizOptions("SimpleRangeIndicator", "SimpleRangeIndicator")
end

function SimpleRangeIndicator:HandleProfileChanges()
	SimpleRangeIndicator:Layout()
	SimpleRangeIndicator:TargetChanged()
end

function SimpleRangeIndicator:UpdateMedia()
	SimpleRangeIndicator:Layout()
end

function SimpleRangeIndicator:OnEnable()

	if SML then
		SML.RegisterCallback(SimpleRangeIndicator, "LibSharedMedia_Registered", "UpdateMedia")
		SML.RegisterCallback(SimpleRangeIndicator, "LibSharedMedia_SetGlobal", "UpdateMedia")
	end
		
	self:RegisterEvent("UNIT_FACTION", "TargetChanged")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "TargetChanged")
	self:CreateFrameWork()
end

function SimpleRangeIndicator:SavePosition()

	local x, y = self.master:GetLeft(), self.master:GetTop()
	local s = self.master:GetEffectiveScale()
	
	self.db.profile.pos.x = x * s
	self.db.profile.pos.y = y * s

end

function SimpleRangeIndicator:SetPosition()

	if self.db.profile.pos.x then
		local x = self.db.profile.pos.x
		local y = self.db.profile.pos.y

		local s = self.master:GetEffectiveScale()

		self.master:ClearAllPoints()
		self.master:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self.master:ClearAllPoints()
		self.master:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end

end

function SimpleRangeIndicator:CreateFrameWork()	

	self.master = CreateFrame("Frame", "SimpleRangeIndicatorFrame", UIParent)
	self.master:Hide()
	
	self.master:SetMovable(true)

	if not self.db.profile.locked then
		self.master:EnableMouse(true)
	else
		self.master:EnableMouse(false)
	end
		
	self.master:RegisterForDrag("LeftButton")
	self.master:SetScript("OnDragStart", function() if not self.db.profile.locked then self["master"]:StartMoving() end end)
	self.master:SetScript("OnDragStop", function() self["master"]:StopMovingOrSizing() self:SavePosition() end)
		
	self.master.Range = self.master:CreateFontString(nil, "ARTWORK")
	self.master.Range:SetFontObject(TextStatusBarText)
    
    self:Layout()
	
end

function SimpleRangeIndicator:Layout()

	if not self.master or not self.master.Range then return end

	local textfont = SML and SML:Fetch("font", self.db.profile.font.textfont) or "Fonts\\FRIZQT__.ttf"

	self.master:SetWidth( 135 )
	self.master:SetHeight( 35 )

	self.master.Range:SetJustifyH("CENTER")
	local gameFont, _, oflags = self.master.Range:GetFont()
	self.master.Range:SetFont( gameFont, self.db.profile.font.textSize, oflags )
	if SML then
	  gameFont = textfont
	end
	self.master.Range:SetFont( gameFont, self.db.profile.font.textSize, "OUTLINE") --[, oflags )--]

	self.master.Range:ClearAllPoints()
	self.master.Range:SetPoint("CENTER", self.master, "CENTER",0,0)
	self.master.Range:SetTextColor( TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b )
	
	self:SetPosition()
	self.master:SetScript("OnUpdate", function(frame, elapsed)
		lastUpdate = lastUpdate + elapsed
		if (lastUpdate < UpdateDelay) then return end
		lastUpdate = 0
		SimpleRangeIndicator:OnUpdate()
	end)
end


--******************************************************************************************************
-- Event handler 

function SimpleRangeIndicator:OnUpdate()
	
	local text
	
	if ( (simplerangeindicator_on == 0) or 
	     (nil == UnitName("target") ) ) then
		return;
	end

	if not self.db.profile.locked then
		self.master:EnableMouse(true)
	else
		self.master:EnableMouse(false)
	end

	
	if(UnitExists("target") == 1)then
	
		if(UnitIsUnit("target", "player")) then
			text = format("|c000ffb00 %s: |cffffffffSelf",L["Range"]);
		else
			if(RangeCheck) then
	
				local minrange, maxrange = RangeCheck:getRange("target", false);
				
				if(minrange == nil) then 
					text = format("|cFFF00023 %s: |cffffffffUnknown",L["Range"]);
				else
					if(maxrange == nil) then
						text = format("|cFFF00023 %s: |cffffffff>%d",L["Range"],minrange);
					else
						if(minrange <= 1) then
							text = format("|c000ffb00 %s: |cffffffff%d-%d",L["Range"],minrange,maxrange);
						else
							text = format("|cFFFFD000 %s: |cffffffff%d-%d",L["Range"],minrange,maxrange);
						end
					end
				end
			
			else
				local R1,R2,R3,R4,R5;
				if(CheckInteractDistance("target", 1)) then R1 = 1; else R1 = 0; end
				if(CheckInteractDistance("target", 2)) then R2 = 1; else R2 = 0; end
				if(CheckInteractDistance("target", 3)) then R3 = 1;	else R3 = 0; end
				if(CheckInteractDistance("target", 4)) then R4 = 1; else R4 = 0; end
				if(nil==CheckInteractDistance("target", 4)) then R5 = 1; else R5 = 0; end
				
				if(R4 == 1 and R3 == 0) then
				-- 28m=Y 10m=N
					text = format("|cFFFFD000 %s: |cffffffff10-28",L["Range"]);
				elseif(R3 == 1 and R1 == 0) then
				-- 10m=Y 5m=N
					text = format("|cFFFFD000 %s: |cffffffff5-10",L["Range"]);
				elseif(R1 == 1) then
				-- 5m=Y
					text = format("|c000ffb00 %s: |cffffffff0-5",L["Range"]);
				elseif(R5 == 1) then
				-- 28m=N
					text = format("|cFFF00023 %s: |cffffffff>28",L["Range"]);
				end
			end
		end
	else
		text = " ";
	end

	SimpleRangeIndicator.master:SetBackdropColor( 
		0,
		0,
		0,
		0
	)

	SimpleRangeIndicator.master:SetBackdropBorderColor( 
		0,
		0,
		0,
		0
	)
	
	if text == " " then
		SimpleRangeIndicator.master.Range:SetTextColor( 
			0,
			0,
			0,
			0
		)
	end

	SimpleRangeIndicator.master.Range:SetText( text )
end

function SimpleRangeIndicator:TargetChanged()
	if UnitExists("target") and not UnitIsDead("target") and (self.db.profile.friendly or UnitCanAttack("player", "target")) then
		index = nil
		--self:ScheduleRepeatingTimer("OnUpdate", 0.33)
		self.master:Show()
		lastUpdate = UpdateDelay
	else
		--self:CancelAllTimers("SimpleRangeIndicator")
		self.master:Hide()
	end
end

