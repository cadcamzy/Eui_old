local E, C, L, DB = unpack(EUI)
if C["info"].bag == 0 or C["info"].enable == false then return end

local bag = CreateFrame ("Frame", nil,UIParent)
bag:SetWidth(70)
bag:SetHeight(16)
--E.EuiSetTemplate(bag,1)
--bag:SetStatusBarColor(0.31, 0.45, 0.63, .7)
bag:EnableMouse(true)

local name = bag:CreateFontString (nil,"OVERLAY")
name:SetFont(E.fontn,13)
name:SetJustifyH("RIGHT")
name:SetShadowOffset(2,-2)
--name:SetPoint("BOTTOMRIGHT",1.3,-4)
name:SetPoint("CENTER")
--name:SetTextColor(23/255,132/255,209/255)

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	if gold ~= 0 then
		return format("|cffffd700%s|r.|cffc7c7cf%s|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("|cffc7c7cf%s|r.|cffeda55f%s|r", silver, copper)
	else
		return format("|cffeda55f%s|r", copper)
	end
end

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d|cffffd700g|r %d|cffc7c7cfs|r %d|cffeda55fc|r", gold, silver, copper)
	return cash
end	

local free,total,used = 0, 0, 0
local profit,spent,oldmoney = 0, 0 ,0
			
local function OnEvent(self, event)
	free,total,used = 0, 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
--	self:SetMinMaxValues(0,total)
--	self:SetValue(used)
	
	local myPlayerRealm = GetCVar("realmName");
	local myPlayerName  = UnitName("player");				
	if (tgoldDB == nil) then tgoldDB = {}; end
	if (tgoldDB[myPlayerRealm]==nil) then tgoldDB[myPlayerRealm]={}; end
	tgoldDB[myPlayerRealm][myPlayerName] = GetMoney();				
	local totalGold = 0
	local thisRealmList = tgoldDB[myPlayerRealm];
	for k,v in pairs(thisRealmList) do
		totalGold=totalGold+v;
	end
	
	if event == "ADDON_LOADED" then
		oldmoney = tgoldDB[myPlayerRealm][myPlayerName]
	end
	
	local newmoney	= GetMoney()
	local change = newmoney-oldmoney -- Positive if we gain money
	
	if oldmoney>newmoney then		-- Lost Money
		spent = spent - change
	else							-- Gained Moeny
		profit = profit + change
	end	
	
	name:SetText(formatMoney(newmoney))
	
	self:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			self.hovered = true 
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(L.INFO_BAG_TIP1,free.."/"..total,1,1,1,1,1,1)
			GameTooltip:AddLine(L.INFO_BAG_TIP2)
			GameTooltip:AddDoubleLine(L.INFO_BAG_TIP3, FormatTooltipMoney(profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(L.INFO_BAG_TIP4, FormatTooltipMoney(spent), 1, 1, 1, 1, 1, 1)
			if profit < spent then
				GameTooltip:AddDoubleLine(L.INFO_BAG_TIP5, FormatTooltipMoney(profit-spent), 1, 0, 0, 1, 1, 1)
			elseif (profit-spent)>0 then
				GameTooltip:AddDoubleLine(L.INFO_BAG_TIP6, FormatTooltipMoney(profit-spent), 0, 1, 0, 1, 1, 1)
			end				
			GameTooltip:AddLine' '
			GameTooltip:AddLine(L.INFO_BAG_TIP7)				
			for k,v in pairs(thisRealmList) do
				GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
			end
			GameTooltip:AddLine' '
			GameTooltip:AddLine(L.INFO_BAG_TIP8)
			GameTooltip:AddDoubleLine(L.INFO_BAG_TIP9, FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)
						
			local numWatched = GetNumWatchedTokens()
			if numWatched > 0 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L.INFO_BAG_TIP10)
				
				for i = 1, numWatched do
					local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
					local r, g, b, hex = GetItemQualityColor(select(3, GetItemInfo(itemID)))

					GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1)
				end					
			end
			GameTooltip:Show()
		end
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	oldmoney = newmoney
end

bag:RegisterEvent("PLAYER_LOGIN")
bag:RegisterEvent("BAG_UPDATE")
bag:RegisterEvent("PLAYER_MONEY")
bag:RegisterEvent('ADDON_LOADED')
bag:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
bag:RegisterEvent("SEND_MAIL_COD_CHANGED")
bag:RegisterEvent("PLAYER_TRADE_MONEY")
bag:RegisterEvent("TRADE_MONEY_CHANGED")
bag:RegisterEvent("PLAYER_ENTERING_WORLD")
bag:SetScript("OnEvent", OnEvent)
bag:SetScript("OnMouseDown", function() OpenAllBags() end)

E.EuiInfo(C["info"].bag,bag)