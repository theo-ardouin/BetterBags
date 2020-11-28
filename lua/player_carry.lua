local _set_tweak_data = PlayerCarry.set_tweak_data


function PlayerCarry:set_tweak_data(name)
    if BetterBags:is_enabled() then
        self._tweak_data_name = BetterBags:get_tweak_type()
        self:_check_dye_pack()
        return
    end
    return _set_tweak_data(self, name)
end
