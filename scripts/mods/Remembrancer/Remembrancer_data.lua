local mod = get_mod("Remembrancer")
local widgets = {
    {
        setting_id  = "mod_settings",
        type        = "group",
        sub_widgets = {
            {
                setting_id    = "ENABLED",
                type          = "checkbox",
                default_value = true,
            },
            {
                setting_id    = "NOTIFICATIONS",
                type          = "checkbox",
                default_value = true,
            },
            {
                setting_id    = "CURRENT",
                type          = "checkbox",
                default_value = false,
            },
            --[[]
            {
                setting_id    = "POSITION",
                type          = "dropdown",
                default_value = "sender",
                options = {
                    { text = "sender",  value = "sender" },
                    { text = "message", value = "message" },
                }
            },
            --]]
            {
                setting_id    = "FORMAT",
                type          = "dropdown",
                default_value = "HH:MM",
                options = {
                    { text = "HH:MM",       value = "HH:MM"       },
                    { text = "HH:MM:SS",    value = "HH:MM:SS"    },
                    { text = "HH:MM:SS.MS", value = "HH:MM:SS.MS" },
                }
            },
            {
                setting_id    = "FRAME",
                type          = "dropdown",
                default_value = "brace",
                options = {
                    { text = "none",  value = "none"  },
                    { text = "dash",  value = "dash"  },
                    { text = "colon", value = "colon" },
                    { text = "brace", value = "brace" },
                    { text = "curly", value = "curly" },
                    { text = "angle", value = "angle" },
                    { text = "round", value = "round" },
                }
            },
            {
                setting_id    = "COLOR",
                type          = "dropdown",
                default_value = "use_sender",
                options = {
                    { text = "use_sender", value = "use_sender" },
                    { text = "reset",      value = "reset"      },
                    { text = "white",      value = "white"      },
                    { text = "black",      value = "black"      },
                    { text = "red",        value = "red"        },
                    { text = "green",      value = "green"      },
                    { text = "blue",       value = "blue"       },
                    { text = "yellow",     value = "yellow"     },
                    { text = "cyan",       value = "cyan"       },
                    { text = "magenta",    value = "magenta"    },
                }
            },
            {
                setting_id    = "USE_PM",
                type          = "checkbox",
                default_value = false,
            },
            {
                setting_id    = "USE_CJK",
                type          = "checkbox",
                tooltip       = "USE_CJK_tooltip",
                default_value = false,
            }
        }
    }
}

return {
    name         = mod:localize("mod_name"),
    description  = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = widgets
    }
}
