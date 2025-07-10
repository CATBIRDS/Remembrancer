local mod = get_mod("Remembrancer")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")

local MOD = {
    ENABLED       = true,
    NOTIFICATIONS = true,
    POSITION      = "sender",
    FORMAT        = "HH:MM",
    FRAME         = "brace",
    COLOR         = "use_sender",
    USE_PM        = false,
    USE_CJK       = false,
}

local FRAMES = {
    none  = { "",  " "   },
    dash  = { "",  " - " },
    colon = { "",  ": "  },
    brace = { "[", "] "  },
    curly = { "{", "} "  },
    angle = { "<", "> "  },
    round = { "(", ") "  }
}

local FORMATS = {
    ["HH:MM"]    = "%H:%M",
    ["HH:MM:SS"] = "%H:%M:%S",
}

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

mod.on_enabled = function()
    MOD.ENABLED = true
end

mod.on_disabled = function()
    MOD.ENABLED = false
end

mod.on_all_mods_loaded = function()
    MOD.ENABLED = mod:get("ENABLED")
    for setting_id, _ in pairs(MOD) do
        local setting = mod:get(setting_id)
        if setting ~= nil then
            MOD[setting_id] = setting
        end
    end
end

mod.on_setting_changed = function(setting_id)
    if MOD[setting_id] ~= nil then
        MOD[setting_id] = mod:get(setting_id)
    end
end

-- Encapsulates timestamp between frame characters
mod.frame = function(timestamp)
    local frame = MOD.FRAME
    frame = FRAMES[frame] or FRAMES.brace
    return string.format("%s%s%s", frame[1], timestamp, frame[2])
end

-- Colors text
mod.color = function(text, color)
    if not text then return "" end
    if type(color) == "table" then
        color = string.format("{#color(%d,%d,%d)}", color[2] or 255, color[3] or 255, color[4] or 255)
    elseif type(color) == "string" then
        color = COLORS[color] or COLORS.reset
    else
        color = COLORS.reset
    end
    return string.format("%s%s%s", color, text, COLORS.reset)
end

-- Returns a formatted timestamp with frame
mod.timestamp = function()
    local format = MOD.FORMAT
    format = FORMATS[format] or FORMATS["HH:MM:SS"]
    -- 24h -> 12h
    if MOD.USE_PM then
        local t = os.date("*t")
        local hour = t.hour
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        format = format:gsub("%%H", string.format("%02d", hour12))
        if hour >= 12 then
            format = format .. " PM"
        else
            format = format .. " AM"
        end
    end
    -- CJK Characters
    if MOD.USE_CJK then
        local language = Managers.localization:language()
        -- Chinese
        if string.find(language, "zh") then
            -- Simplified
            if language == "zh-cn" then
                format = format:gsub("%%H", "点"):gsub("%%M", "分"):gsub("%%S", "秒")
            -- Traditional
            elseif language == "zh-tw" then
                format = format:gsub("%%H", "點"):gsub("%%M", "分"):gsub("%%S", "秒")
            -- Any other dialect: fallback to Simplified
            else
                format = format:gsub("%%H", "点"):gsub("%%M", "分"):gsub("%%S", "秒")
            end
        -- Japanese
        elseif string.find(language, "ja") then
            format = format:gsub("%%H", "時"):gsub("%%M", "分"):gsub("%%S", "秒")
        -- Korean
        elseif string.find(language, "ko") then
            format = format:gsub("%%H", "시"):gsub("%%M", "분"):gsub("%%S", "초")
        end
    end
    local timestamp = os.date(format)
    return mod.frame(timestamp)
end

-- Prefixes chat messages with a timestamp when enabled
mod:hook(CLASS.ConstantElementChat, "_add_message", function(func, self, message, sender, channel)
    if not MOD.ENABLED then
        return func(self, message, sender, channel)
    end
    local timestamp = mod.timestamp()
    local position = MOD.POSITION or "sender"
    local channel_tag = channel.tag
    local channel_color = self:_channel_color(channel_tag)
    local color = MOD.COLOR ~= "use_sender" and MOD.COLOR or channel_color

    -- Apply user-defined colors, or use sender color
    timestamp = mod.color(timestamp, color)

    -- Before sender
    if position == "sender" then
        -- Ensure mod does not override channel colors if placing before sender
        if channel_color then
            sender = string.format("{#color(%d,%d,%d)}%s", channel_color[2], channel_color[3], channel_color[4], sender)
        end
        sender = timestamp .. sender

    -- After sender
    elseif position == "message" then
        message = timestamp .. message
    end

    return func(self, message, sender, channel)
end)

mod:hook(CLASS.ConstantElementChat, "_add_notification", function(func, self, message, channel_tag)
    if not MOD.ENABLED or not MOD.NOTIFICATIONS then
        return func(self, message, channel_tag)
    end
    local timestamp = mod.timestamp()
    local channel_meta_data = ChatSettings.channel_metadata[channel_tag]
	local channel_color = channel_meta_data and channel_meta_data.color
    local color = MOD.COLOR ~= "use_sender" and MOD.COLOR or channel_color
    
    -- Apply user-defined colors, or use sender color
    timestamp = mod.color(timestamp, color)

    -- Cannot reliably adjust position for system notifications due to a lack of sender, just prefix the message
    message = timestamp .. message

    return func(self, message, channel_tag)
end)