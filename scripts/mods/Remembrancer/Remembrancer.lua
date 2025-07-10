local mod = get_mod("Remembrancer")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local ChatManagerConstants = require("scripts/foundation/managers/chat/chat_manager_constants")

local MOD = {
    ENABLED       = true,
    NOTIFICATIONS = true,
    POSITION      = "sender",
    CURRENT       = false,
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
    ["HH:MM:SS.MS"] = "%H:%M:%S"
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

local TIME = {
    LAST = "",
    REAL = "",
    DELTA = 0,
    MILLI = 0,
    SUFFIX = 0,
    UPDATE_SECONDS = false,
    UPDATE_MINUTES = false
}

local LOCALE_DEBUG = false -- Set to true to force CJK characters for testing purposes

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

-- Update millisecond information each frame for higher precision timestamps than are allowed by os.date
mod.update = function()
    if not MOD.ENABLED then
        return
    end
    -- Get current seconds
    TIME.REAL = os.date("%S")
    -- If moving to a new second, reset milliseconds to 0 and update LAST
    if TIME.REAL ~= TIME.LAST then
        TIME.LAST = TIME.REAL
        TIME.MILLI = 0
        TIME.UPDATE_SECONDS = true
        if TIME.REAL == "00" then
            TIME.UPDATE_MINUTES = true
        end
    end
    -- Increment suffix by the elapsed milliseconds since the last update
    TIME.MILLI = TIME.MILLI + TIME.DELTA
    TIME.SUFFIX = math.floor(TIME.MILLI * 100)
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
mod.timestamp = function(realtime)
    local format = MOD.FORMAT
    -- MS not allowed in realtime contexts due to padding issues as the game does not use monospaced fonts
    if realtime and format == "HH:MM:SS.MS" then
        format = "HH:MM:SS"
    end
    format = FORMATS[format] or FORMATS["HH:MM:SS"]
    -- 24h -> 12h
    if MOD.USE_PM then
        local t = os.date("*t")
        local hour = t.hour
        local hour12 = hour % 12
        if hour12 == 0 then hour12 = 12 end
        format = format:gsub("%%H", "%%I")
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
        if string.find(language, "zh") or LOCALE_DEBUG then
            -- Simplified
            if language == "zh-cn" then
                format = format:gsub("%%H:", "%%H点"):gsub("%%I:", "%%I点"):gsub("%%M:", "%%M分"):gsub("%%S", "%%S秒")
            -- Traditional
            elseif language == "zh-tw" then
                format = format:gsub("%%H:", "%%H點"):gsub("%%I:", "%%I點"):gsub("%%M:", "%%M分"):gsub("%%S", "%%S秒")
            -- Any other dialect: fallback to Simplified
            else
                format = format:gsub("%%H:", "%%H点"):gsub("%%I:", "%%I点"):gsub("%%M:", "%%M分"):gsub("%%S", "%%S秒")
            end
        -- Japanese
        elseif string.find(language, "ja") then
            format = format:gsub("%%H:", "%%H時"):gsub("%%I:", "%%I時"):gsub("%%M:", "%%M分"):gsub("%%S", "%%S秒")
        -- Korean
        elseif string.find(language, "ko") then
            format = format:gsub("%%H:", "%%H시"):gsub("%%I:", "%%I시"):gsub("%%M:", "%%M분"):gsub("%%S", "%%S초")
        end
    end
    -- Append milliseconds if using HH:MM:SS.MS format
    if MOD.FORMAT == "HH:MM:SS.MS" and not realtime then
        -- Append milliseconds after the last digit in the timestamp
        local ms = string.format(".%02d", TIME.SUFFIX)
        format = format:gsub("%%S", "%%S" .. ms)
    end
    local timestamp = os.date(format)
    return mod.frame(timestamp)
end

-- Add timestamps to mod/chat messages
mod:hook(CLASS.ConstantElementChat, "_add_message", function(func, self, message, sender, channel)
    if not MOD.ENABLED then
        return func(self, message, sender, channel)
    end
    local timestamp = mod.timestamp()
    local position = "sender" --MOD.POSITION or "sender"
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

-- Add timestamps to system messages
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

-- Reset update flags as needed for current time display
mod:hook_safe(CLASS.ConstantElementChat, "update", function(self, dt, t, ui_renderer, render_settings, input_service)
    -- Steal dt for TIME.DELTA
    TIME.DELTA = dt
    if MOD.ENABLED and MOD.CURRENT then
        -- HH:MM
        if MOD.FORMAT == "HH:MM" and TIME.UPDATE_MINUTES then
            self._refresh_to_channel_text = true
            TIME.UPDATE_MINUTES = false
        -- HH:MM:SS & HH:MM:SS.MS
        elseif (MOD.FORMAT == "HH:MM:SS" or MOD.FORMAT == "HH:MM:SS.MS") and TIME.UPDATE_SECONDS then
            self._refresh_to_channel_text = true
            TIME.UPDATE_SECONDS = false
        --[[
        -- HH:MM:SS.MS (disabled for now as it causes too much flickering)
        elseif MOD.FORMAT == "HH:MM:SS.MS" then
            local input_widget = self._input_field_widget
            self:_update_input_field(ui_renderer, input_widget)
        --]]
        end
    end
end)

-- Add real-time timestamp to input field
mod:hook(CLASS.ConstantElementChat, "_update_input_field", function (func, self, ui_renderer, widget)
    if not MOD.ENABLED or not MOD.CURRENT then
        return func(self, ui_renderer, widget)
    end
	local to_channel_text = ""
	local style = widget.style
	local to_channel_style = style.to_channel
	if self._selected_channel_handle then
		local channel = Managers.chat:sessions()[self._selected_channel_handle]

		if channel and channel.tag and (channel.session_text_state == ChatManagerConstants.ChannelConnectionState.CONNECTED or channel.session_media_state == ChatManagerConstants.ChannelConnectionState.CONNECTED) then
			local channel_name = self:_channel_name(channel.tag, false, channel.channel_name)

			to_channel_text = Managers.localization:localize("loc_chat_to_channel", true, {
				channel_name = channel_name,
			})
			to_channel_style.text_color = self:_channel_color(channel.tag)
		end
	end

    -- Build timestamp
    local timestamp = mod.timestamp("realtime")

    -- Get normal offset
    local offset = self:_text_size(ui_renderer, to_channel_text, to_channel_style)

    -- Get maximum timestamp offset and add to normal offset to avoid moving player's text
    local max_timestamp
    if MOD.USE_CJK then
        if MOD.FORMAT == "HH:MM:SS" or MOD.FORMAT == "HH:MM:SS.MS" then
            max_timestamp = mod.frame("00分00分00分") -- Using 分 as placeholder for padding determination as it is the largest CJK character this mod uses
        else
            max_timestamp = mod.frame("00分00分")
        end
    else
        max_timestamp = mod.frame((MOD.FORMAT ~= "HH:MM:SS.MS" and MOD.FORMAT or "XX:XX:XX"):gsub("[A-Za-z]", "0"))
    end
    if MOD.USE_PM then
        max_timestamp = max_timestamp .. " AM"
    end
    local max_offset = self:_text_size(ui_renderer, max_timestamp, to_channel_style)
    offset = offset + max_offset

    -- Prefix timestamp to channel text
    to_channel_text = timestamp .. to_channel_text
    
	widget.content.to_channel = to_channel_text

	local field_margin_left = ChatSettings.input_field_margins[1]
	local field_margin_right = ChatSettings.input_field_margins[4]
	

	offset = offset + to_channel_style.offset[1] + field_margin_left

	local text_style = style.display_text

	text_style.offset[1] = offset
	text_style.size = text_style.size or {}
	text_style.size_addition[1] = -(offset + field_margin_right)
	style.active_placeholder.offset[1] = offset

	self:_setup_input_labels()
end)