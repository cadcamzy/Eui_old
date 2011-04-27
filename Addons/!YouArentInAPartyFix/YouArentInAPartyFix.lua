local DEBUG = false
SlashCmdList["YAIAPFIX"] = function()
	DEBUG = not DEBUG
	print("|c00ff0000YAIAP|r: Debug = "..tostring(DEBUG))
end
SLASH_YAIAPFIX1 = "/yaiap"

local c = {["raid"] = true, ["party"] = true}

local old = SendAddonMessage
local function fix(pre, msg, ch, ...)
	local chl = strlower(ch)
	if c[chl] and GetRealNumRaidMembers() == 0 and GetRealNumPartyMembers() == 0 then
		if DEBUG == true then 
			print("|c00ff0000YAIAP|r: prefix = |c0000ff00"..pre.."|r: debugstack = "..debugstack(3, 4, 0))
			old(pre, msg, ch, ...)
		end
		return
	end
	old(pre, msg, ch, ...)
end

SendAddonMessage = fix