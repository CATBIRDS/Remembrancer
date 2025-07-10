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
        ["zh-cn"] = "聊天消息时间戳",
    },
    -- Settings
    mod_settings = {
        en = "Mod Settings",
        ["zh-cn"] = "MOD设置",
    },
    ENABLED = {
        en = "Enable/Disable Mod",
        ["zh-cn"] = "模组启停",
    },
    -- Current Time
    CURRENT = {
        en = "Show Current Time in Chat Input"
    },
    -- Position
    POSITION = {
        en = "Timestamp Position",
        ["zh-cn"] = "时间戳位置"
    },
    sender = {
        en = "Before Message Sender",
        ["zh-cn"] = "发信人之前",
    },
    message = {
        en = "After Message Sender",
        ["zh-cn"] = "发信人之后",
    },
    -- Format
    FORMAT = {
        en = "Timestamp Format",
        ["zh-cn"] = "时间戳格式"
    },
    ["HH:MM"] = {
        en = "HH:MM",
        ["zh-cn"] = "时:分",
    },
    ["HH:MM:SS"] = {
        en = "HH:MM:SS",
        ["zh-cn"] = "时:分:秒",
    },
    ["HH:MM:SS.MS"] = {
        en = "HH:MM:SS.MS",
        ["zh-cn"] = "时:分:秒.毫秒",
    },
    -- Frame
    FRAME = {
        en = "Timestamp Frame",
        ["zh-cn"] = "时间戳框架"
    },
    none = {
        en = "None",
        ["zh-cn"] = "无",
    },
    dash = {
        en = "Dash -",
        ["zh-cn"] = "短横线 -",
    },
    colon = {
        en = "Colon:",
        ["zh-cn"] = "冒号:",
    },
    brace = {
        en = "[Square]",
        ["zh-cn"] = "[方框]",
    },
    curly = {
        en = "{Curly}",
        ["zh-cn"] = "{花括号}",
    },
    angle = {
        en = "<Angled>",
        ["zh-cn"] = "<尖括号>",
    },
    round = {
        en = "(Round)",
        ["zh-cn"] = "(圆括号)",
    },
    -- Color
    COLOR = {
        en = "Timestamp Color",
        ["zh-cn"] = "时间戳颜色"
    },
    use_sender = {
        en = "Use Sender Color",
        ["zh-cn"] = "使用发信人颜色",
    },
    reset = {
        en = color("None", "reset"),
        ["zh-cn"] = color("无", "reset"),
    },
    white = {
        en = color("White", "white"),
        ["zh-cn"] = color("白色", "white"),
    },
    black = {
        en = color("Black", "black"),
        ["zh-cn"] = color("黑色", "black"),
    },
    red = {
        en = color("Red", "red"),
        ["zh-cn"] = color("红色", "red"),
    },
    green = {
        en = color("Green", "green"),
        ["zh-cn"] = color("绿色", "green"),
    },
    blue = {
        en = color("Blue", "blue"),
        ["zh-cn"] = color("蓝色", "blue"),
    },
    yellow = {
        en = color("Yellow", "yellow"),
        ["zh-cn"] = color("黄色", "yellow"),
    },
    cyan = {
        en = color("Cyan", "cyan"),
        ["zh-cn"] = color("青色", "cyan"),
    },
    magenta = {
        en = color("Magenta", "magenta"),
        ["zh-cn"] = color("品红色", "magenta"),
    },
    -- Other Settings
    NOTIFICATIONS = {
        en = "Apply to System Messages",
        ["zh-cn"] = "应用于系统消息"
    },
    USE_PM = {
        en = "Use AM/PM Format",
        ["zh-cn"] = "使用上午/下午格式",
    },
    USE_CJK = {
        en = "Use CJK Characters",
        ["zh-cn"] = "使用中日韩字符",
    },
    USE_CJK_tooltip = {
        en = "Formats timestamp using locale-specific CJK Character Localization. Only applies when using CN/JP/KR system locale.",
        ["zh-cn"] = "使用区域特定的中日韩字符本地化时间戳格式。仅在使用中文/日文/韩文系统区域设置时生效。",
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
    en = descriptions[random_description],
    ["zh-cn"] = descriptions[random_description]  -- 使用游戏内置本地化
}

return localization