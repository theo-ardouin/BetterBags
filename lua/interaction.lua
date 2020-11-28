local _interact_blocked = CarryInteractionExt._interact_blocked
local _can_select = CarryInteractionExt.can_select


function CarryInteractionExt:_interact_blocked(player)
    if BetterBags:is_enabled() then
        return not managers.player:can_carry(self._unit:carry_data():carry_id())
	end
    return _interact_blocked(self, player)
end

function CarryInteractionExt:can_select(player)
	if BetterBags:is_enabled() then
		return CarryInteractionExt.super.can_select(self, player)
	end
    return _can_select(self, player)
end
