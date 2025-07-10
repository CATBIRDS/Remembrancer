local COLORS = {
    reset   = "{#reset()}",
    red     = "{#color(255,0,0)}",
    green   = "{#color(0,255,0)}",
    blue    = "{#color(0,0,255)}",
    yellow  = "{#color(255,255,0)}",
    cyan    = "{#color(0,255,255)}",
    magenta = "{#color(255,0,255)}",
    white   = "{#color(255,255,255)}",
    black   = "{#color(0,0,0)}",
}

local color = function(text, color)
    local color = COLORS[color] or COLORS.reset
    return color .. text .. COLORS.reset
end

local localization = {
    -- Mod Info
    mod_name = {
        en = "Remembrancer",
    },
    -- Settings
    mod_settings = {
        en = "Mod Settings",
    },
    ENABLED = {
        en = "Enable/Disable Mod",
    },
    -- Position
    POSITION = {
        en = "Timestamp Position"
    },
    sender = {
        en = "Before Message Sender",
    },
    message = {
        en = "After Message Sender",
    },
    -- Format
    FORMAT = {
        en = "Timestamp Format"
    },
    ["HH:MM"] = {
        en = "HH:MM",
    },
    ["HH:MM:SS"] = {
        en = "HH:MM:SS",
    },
    ["HH:MM:SS.MS"] = {
        en = "HH:MM:SS.MS",
    },
    -- Frame
    FRAME = {
        en = "Timestamp Frame"
    },
    none = {
        en = "None",
    },
    dash = {
        en = "Dash -",
    },
    colon = {
        en = "Colon:",
    },
    brace = {
        en = "[Square]",
    },
    curly = {
        en = "{Curly}",
    },
    angle = {
        en = "<Angled>",
    },
    round = {
        en = "(Round)",
    },
    -- Color
    COLOR = {
        en = "Timestamp Color"
    },
    use_sender = {
        en = "Use Sender Color",
    },
    reset = {
        en = color("None", "reset"),
    },
    white = {
        en = color("White", "white"),
    },
    black = {
        en = color("Black", "black"),
    },
    red = {
        en = color("Red", "red"),
    },
    green = {
        en = color("Green", "green"),
    },
    blue = {
        en = color("Blue", "blue"),
    },
    yellow = {
        en = color("Yellow", "yellow"),
    },
    cyan = {
        en = color("Cyan", "cyan"),
    },
    magenta = {
        en = color("Magenta", "magenta"),
    },
    -- Other Settings
    NOTIFICATIONS = {
        en = "Apply to System Messages"
    },
    USE_PM = {
        en = "Use AM/PM Format",
    },
    USE_CJK = {
        en = "Use CJK Characters",
    },
    USE_CJK_tooltip = {
        en = "Formats timestamp using locale-specific CJK Character Localization. Only applies when using CN/JP/KR system locale.",
    }
}

-- Automatically localized strings

local descriptions = {
    Localize("loc_zealot_female_a__conversation_explicator_two_b_01"),     -- "And since when did the past matter more than the present?"
    Localize("loc_zealot_female_a__lore_morrow_two_b_01"),                 -- "Verily it seems impossible, but tis said time behaves differently in the Empyrean."
    Localize("loc_zealot_female_a__mission_scavenge_servitors_02"),        -- "Praise be the Master, whose works endureth the ravages of time and heresy!"
    Localize("loc_zealot_female_c__conversation_zealot_one_03_03"),        -- "The time of judgement is at hand. Do not be found wanting."
    Localize("loc_zealot_female_c__lore_era_indomitus_three_c_02"),        -- "A time of witches, a time of miracles. These are the days that try our souls."
    Localize("loc_zealot_female_c__lore_the_warp_three_b_02"),             -- "Time is an illusion in any case. Remember how slowly it passes when we are under fire."
    Localize("loc_zealot_female_c__lore_the_warp_three_b_01"),             -- "Time may ebb and flow, but the Beneficent Emperor keeps careful count of years and deeds."
    Localize("loc_enginseer_a__mission_train_first_interstitial_03_b_01"), -- "Time is relative. Success is inevitable."
    Localize("loc_enginseer_a__mission_train_second_objective_mid_a_01"),  -- "Time is our enemy. Forget this not."
    Localize("loc_explicator_a__mission_complex_old_shrine_street_03"),    -- "Atoma remembers its heroes ... even when no one's entirely certain why."
    Localize("loc_loading_hint_247"),                                      -- "When all is dark, remember the Emperor"
    Localize("loc_loading_hint_210"),                                      -- "Seek for yourself a death worthy of remembrance"
}
local random_description = math.random(1, #descriptions)
localization.mod_description = {
    en = descriptions[random_description]
}

return localization
