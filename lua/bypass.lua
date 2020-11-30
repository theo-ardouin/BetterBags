local _verify_carry = PlayerManager.verify_carry
local _verify_equipment = PlayerManager.verify_equipment
local _register_carry = PlayerManager.register_carry


function PlayerManager:verify_carry(...)
    if BetterBags:is_enabled() then
        return true
    end
    return _verify_carry(self, ...)
end

function PlayerManager:verify_equipment(...)
    if BetterBags:is_enabled() then
        return true
    end
    return _verify_equipment(self, ...)
end

function PlayerManager:register_carry(...)
    if BetterBags:is_enabled() then
        return true
    end
    return _register_carry(self, ...)
end
