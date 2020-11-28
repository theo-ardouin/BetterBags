local function to_bool(value)
    return value == "on"
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_BetterBags", function(loc)
    loc:load_localization_file(BetterBags._path .. "loc/en.json")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_BetterBags", function(_)
    MenuCallbackHandler.bbags_offline_only_callback = function(_, item)
        BetterBags.settings.offline_only = to_bool(item:value())
    end
    MenuCallbackHandler.bbags_stealth_only_callback = function(_, item)
        BetterBags.settings.stealth_only = to_bool(item:value())
    end
    MenuCallbackHandler.bbags_max_weight_callback = function(_, item)
        BetterBags.settings.max_weight = item:value()
    end

    MenuHelper:LoadFromJsonFile(BetterBags._path .. "menu/options.json", BetterBags, BetterBags._data)
end)
