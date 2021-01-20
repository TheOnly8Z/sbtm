hook.Add("PreDrawOutlines", "SBTM", function()
    local cvar = GetConVar("cl_sbtm_teamoutline"):GetInt()
    local m = GetConVar("cl_sbtm_teamoutline_mode"):GetInt()
    if cvar > 0 and m > 0 and m ~= 2 and SBTM:IsTeamed(LocalPlayer()) and
            (not SBMG or not SBMG:GameHasTag(SBMG_TAG_FORCE_FRIENDLY_FIRE)) and
            (cvar == 1 or (SBMG and SBMG:GetActiveGame())) then
        local plys = team.GetPlayers(LocalPlayer():Team())
        outline.Add(plys, team.GetColor(LocalPlayer():Team()), OUTLINE_MODE_NOTVISIBLE)
    end
end)

hook.Add("PreDrawHalos", "SBTM", function()
    local cvar = GetConVar("cl_sbtm_teamoutline"):GetInt()
    local m = GetConVar("cl_sbtm_teamoutline_mode"):GetInt()
    if cvar > 0 and m > 0 and m ~= 1 and SBTM:IsTeamed(LocalPlayer()) and
            (not SBMG or not SBMG:GameHasTag(SBMG_TAG_FORCE_FRIENDLY_FIRE)) and
            (cvar == 1 or (SBMG and SBMG:GetActiveGame())) then
        local plys = team.GetPlayers(LocalPlayer():Team())
        halo.Add(plys, team.GetColor(LocalPlayer():Team()), 4, 4, 1, true, true)
    end
end)