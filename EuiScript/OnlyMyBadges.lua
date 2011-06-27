------------------------------------------------------------
-- OnlyMyBadges.lua
--
-- GhostRala
-- 2010-11-06
------------------------------------------------------------

local BADGES = { ["29434"] = 1, ["45624"] = 1, ["40752"] = 1, ["40753"] = 1, ["43228"] = 1, ["20560"] = 1, ["20559"] = 1, ["29024"] = 1, ["42425"] = 1, ["43589"] = 1, ["43228"] = 1, ["47395"] = 1, ["37836"] = 1, ["44990"] = 1, ["43016"] = 1, ["47241"] = 1, ["45624"] = 1, ["20558"] = 1, ["43589"] = 1 }
local LOOT_MSG = string.gsub(LOOT_ITEM, "%%s", "(.+)")
local LOOT_MSG_MULTIPLE = string.gsub(string.gsub(LOOT_ITEM_MULTIPLE, "%%s", "(.+)"), "%%d", "(%%d+)")

local Orig_ChatFrame_OnEvent = ChatFrame_OnEvent
ChatFrame_OnEvent = function(self, event, text, ...)
	if event == "CHAT_MSG_LOOT" and type(text) == "string" then
		local _, _, name, lnk = string.find(text, LOOT_MSG)
		if not name then
			_, _, name, lnk = string.find(text, LOOT_MSG_MULTIPLE)
		end

		if lnk and name ~= YOU then
			local _, _, id = string.find(lnk, "item:(%d+)")
			if id and BADGES[id] then
				return
			end
		end	
	end
	return Orig_ChatFrame_OnEvent(self, event, text, ...)
end