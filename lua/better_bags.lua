_G.BetterBags = _G.BetterBags or {
    _path = ModPath,
    _data = {},
    settings = {
        enabled = true,
        offline_only = true,
        stealth_only = false,
        max_weight = 1
    },
    inventory = {},
    weight = 0
}


local function is_stealth()
    return managers.groupai:state():whisper_mode()
end

local function is_offline()
    return Global.game_settings.single_player
end

local function type_from_carry_id(carry_id)
    return tweak_data.carry[carry_id].type
end

local function tweak_from_carry_id(carry_id)
    local tw_type = type_from_carry_id(carry_id)
    return tweak_data.carry.types[tw_type]
end

local function find_heaviest(inventory)
    local heaviest = nil
    local modifier = 1

    for _, carry_data in pairs(inventory) do
        local tw = tweak_from_carry_id(carry_data.carry_id)
        if tw and (not heaviest or tw.move_speed_modifier < modifier) then
            modifier = tw.move_speed_modifier
            heaviest = carry_data
        end
    end
    return heaviest
end

local function get_weight(carry_id)
    local tw = tweak_from_carry_id(carry_id)
    if not tw then
        return 0
    end
    return 1 - tw.move_speed_modifier
end

function BetterBags:is_enabled()
    return self.settings.enabled
end

function BetterBags:get_tweak_type()
    local carry_data = find_heaviest(self.inventory)
    if not carry_data then
        log("Unexpected error: No tweak type")
        -- Fallback just in case
        return "light"
    end
    return type_from_carry_id(carry_data.carry_id)
end

function BetterBags:peek()
    return self.inventory[#self.inventory]
end

function BetterBags:can_carry(carry_id)
    local weight = get_weight(carry_id)

    if #self.inventory == 0 then
        return true
    elseif self.settings.stealth_only and not is_stealth() then
        return false
    elseif self.settings.offline_only and not is_offline() then
        return false
    elseif self.settings.max_weight > 0 and
        self.weight + weight > self.settings.max_weight then
        return false
    end
    return true
end

function BetterBags:can_drop()
    return #self.inventory > 0
end

function BetterBags:push(carry_data)
    table.insert(self.inventory, {
        carry_id = carry_data[1],
        multiplier = carry_data[2],
        dye_initiated = carry_data[3],
        has_dye_pack = carry_data[4],
        dye_value_multiplier = carry_data[5]
    })
    self.weight = self.weight + get_weight(carry_data[1])
end

function BetterBags:pop()
    local carry_data = table.remove(self.inventory, #self.inventory)

    self.weight = self.weight - get_weight(carry_data.carry_id)
    if #self.inventory == 0 then
        -- Avoid float point issues
        self.weight = 0
    end
    return carry_data
end
