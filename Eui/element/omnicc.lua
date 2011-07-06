Local E, C, L = unpack(EUI)
if C["other"].cooldown ~= true then return end
--[[
	OmniCC Basic
		A featureless, 'pure' version of OmniCC.
		This version should work on absolutely everything, but I've removed pretty much all of the options
--]]

local ICON_SIZE = 40 --the normal size for an icon (don't change this)
local FONT_SIZE = 20 --the base font size to use at a scale of 1
local MIN_SCALE = 0.2 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 3 --the minimum duration to show cooldown text for
local DAY, HOUR, MINUTE = 86400, 3600, 60
if C["filter"].float == true then
	E.fontc = [[Interface\AddOns\Eui\media\fontc.ttf]]
end
--omg speed
local format = string.format
local floor = math.floor
local min = math.min

local function GetFormattedTime(s)
	if s >= DAY then
		return format('%dd', floor(s/DAY + 0.5)), s % DAY
	elseif s >= HOUR then
		return format('%dh', floor(s/HOUR + 0.5)), s % HOUR
	elseif s >= MINUTE then
		return format('%dm', floor(s/MINUTE + 0.5)), s % MINUTE
	end
	if C["filter"].float ~= true then
		if s < MINUTE then
			return floor(s + 0.5), s - floor(s)
		end
	else
		if s >= 10 and s < MINUTE then
			return floor(s + 0.5), s - floor(s)
		elseif s < 10 then
			return format('%0.1f',s), 0.1
		end
	end
end

local function Timer_OnUpdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			if (self:GetEffectiveScale()/UIParent:GetEffectiveScale()) < MIN_SCALE then
				self.text:SetText('')
				self.nextUpdate = 1
			else
				local remain = self.duration - (GetTime() - self.start)
				if floor(remain + 0.5) > 0 then
					local time, nextUpdate = GetFormattedTime(remain)
				--	if remain > 599 then self.text:SetFont(fontc, FONT_SIZE *(min(self:GetParent():GetWidth() / ICON_SIZE, 1)) -1,'OUTLINE') end
					self.text:SetText(time)
					self.nextUpdate = nextUpdate
				else
					self.text:Hide()
				end
			end
		end
	end
end

local function Timer_Create(self)
	local scale = min(self:GetParent():GetWidth() / ICON_SIZE, 1)
	local remain = self.duration - (GetTime() - self.start)
	if (scale < MIN_SCALE) then
		self.noOCC = true
--	elseif remain > 60 and self:GetParent().noOCC == true then
--		self.noOCC = true
	elseif self:GetParent().noOCC then
		self.noOCC = true
	else
		local text = self:CreateFontString(nil, 'OVERLAY')
		
		text:SetPoint('CENTER', 0, 1)

		if FONT_SIZE * scale < 9 then 
			text:SetFont(E.fontp, 9, 'OUTLINE')
		else
			text:SetFont(E.fontp, FONT_SIZE * scale, 'OUTLINE')
		end
		
		text:SetTextColor(1,.9,0)

		self.text = text
		self:SetScript('OnUpdate', Timer_OnUpdate)
		return text
	end
end

local function Timer_Start(self, start, duration)
	self.start = start
	self.duration = duration
	self.nextUpdate = 0

	local text = self.text or (not self.noOCC and Timer_Create(self))
	if text then
		text:Show()
	end
end

--ActionButton1Cooldown here, is something we think will always exist
local methods = getmetatable(_G['ActionButton1Cooldown']).__index
hooksecurefunc(methods, 'SetCooldown', function(self, start, duration)
	if start > 0 and duration > MIN_DURATION then
		Timer_Start(self, start, duration)
	else
		local text = self.text
		if text then
			text:Hide()
		end
	end
end)