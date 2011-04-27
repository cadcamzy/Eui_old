hooksecurefunc("ActionButton_OnUpdate", function(self, elapsed)
	if ( self.rangeTimer == TOOLTIP_UPDATE_TIME ) then
		local range = false
		if ( IsActionInRange(self.action) == 0 ) then
			getglobal(self:GetName().."Icon"):SetVertexColor(0.2, 0.2, 0.2 )
			getglobal(self:GetName().."NormalTexture"):SetVertexColor(0.8, 0, 0)
			range = true
		end;
		if ( self.range ~= range and range == false ) then
			ActionButton_UpdateUsable(self)
		end;
		self.range = range
		end
end)