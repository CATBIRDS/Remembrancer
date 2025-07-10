return {
    run = function()
    fassert(rawget(_G, "new_mod"), "`Remembrancer` encountered an error loading the Darktide Mod Framework.")

        new_mod("Remembrancer", {
            mod_script       = "Remembrancer/scripts/mods/Remembrancer/Remembrancer",
            mod_data         = "Remembrancer/scripts/mods/Remembrancer/Remembrancer_data",
            mod_localization = "Remembrancer/scripts/mods/Remembrancer/Remembrancer_localization",
        })
    end,
    packages = {},
}
