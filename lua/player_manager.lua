local _can_carry = PlayerManager.can_carry
local _drop_carry = PlayerManager.drop_carry
local _set_carry = PlayerManager.set_carry


local function update_hud(inventory)
    managers.hud:remove_special_equipment("_bags")
	if #inventory > 1 then
		managers.hud:add_special_equipment(
            {id = "_bags", icon = "pd2_loot", amount = #inventory}
        )
    end
end

function PlayerManager:can_carry(carry_id)
	if BetterBags:is_enabled() then
		return BetterBags:can_carry(carry_id)
	end
	return _can_carry(self, carry_id)
end

function PlayerManager:drop_carry(...)
    if BetterBags:is_enabled() then
        _drop_carry(self, ...)
        BetterBags:pop()
        local carry_data = BetterBags:peek()
        if carry_data then
            _set_carry(
                self,
                carry_data.carry_id,
                carry_data.multiplier,
                carry_data.dye_initiated,
                carry_data.has_dye_pack,
                carry_data.dye_value_multiplier
            )
        end
        update_hud(BetterBags.inventory)
        return
    end
    return _drop_carry(self, ...)
end

function PlayerManager:set_carry(...)
    if BetterBags:is_enabled() then
        BetterBags:push({...})
        _set_carry(self, ...)
        update_hud(BetterBags.inventory)
        return
    end
    return _set_carry(self, ...)
end
