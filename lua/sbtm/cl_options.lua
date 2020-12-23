local function colormixer(pnl, t_name)
    local p = vgui.Create("DColorMixer", pnl)
    p:SetLabel("#sbtm.cvar.clr_" .. t_name)
    p:SetConVarR("sbtm_clr_" .. t_name .. "_r")
    p:SetConVarG("sbtm_clr_" .. t_name .. "_g")
    p:SetConVarB("sbtm_clr_" .. t_name .. "_b")
    p:SetAlphaBar(false)
    pnl:AddItem(p)
    --[[]
    local p = pnl:AddControl("color", {
        label = "#sbtm.cvar.clr_" .. t_name,
        red = "sbtm_clr_" .. t_name .. "_r",
        green = "sbtm_clr_" .. t_name .. "_g",
        blue = "sbtm_clr_" .. t_name .. "_b"
    })
    ]]
end

hook.Add("PopulateToolMenu", "SBTM", function()
    spawnmenu.AddToolMenuOption("Utilities", "Admin", "SBTM", "#sbtm.title", "", "", function(pnl)
        pnl:Help("#sbtm.menuhelp")
        pnl:CheckBox("#sbtm.cvar.selfset", "sbtm_selfset")
        pnl:CheckBox("#sbtm.cvar.selfset_balance", "sbtm_selfset_balance")
        pnl:ControlHelp("#sbtm.cvar.selfset_balance.desc")
        pnl:CheckBox("#sbtm.cvar.nofriendlyfire", "sbtm_nofriendlyfire")
        pnl:CheckBox("#sbtm.cvar.neutralunassigned", "sbtm_neutralunassigned")
        pnl:ControlHelp("#sbtm.cvar.neutralunassigned.desc")
        pnl:CheckBox("#sbtm.cvar.setplayercolor", "sbtm_setplayercolor")
        pnl:ControlHelp("#sbtm.cvar.setplayercolor.desc")
        pnl:NumSlider("#sbtm.cvar.shuffle_max", "sbtm_shuffle_max", 2, 4, 0)
        pnl:ControlHelp("#sbtm.cvar.shuffle_max.desc")
        pnl:CheckBox("#sbtm.cvar.deathunassign", "sbtm_deathunassign")
        pnl:CheckBox("#sbtm.cvar.teamnpcs", "sbtm_teamnpcs")
        pnl:ControlHelp("#sbtm.cvar.teamnpcs.desc")
        pnl:CheckBox("#sbtm.cvar.teamnpcs_color", "sbtm_teamnpcs_color")
        pnl:Help("")
        pnl:Help("#sbtm.nameclrhelp")
        pnl:TextEntry("#sbtm.cvar.name_red", "sbtm_name_red")
        colormixer(pnl, "red")
        pnl:TextEntry("#sbtm.cvar.name_blue", "sbtm_name_blue")
        colormixer(pnl, "blue")
        pnl:TextEntry("#sbtm.cvar.name_green", "sbtm_name_green")
        colormixer(pnl, "green")
        pnl:TextEntry("#sbtm.cvar.name_yellow", "sbtm_name_yellow")
        colormixer(pnl, "yellow")
        pnl:Help("")
        pnl:Help("#sbtm.authorhelp")
    end)
end)