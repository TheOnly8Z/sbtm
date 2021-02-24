hook.Add("PreDrawOutlines", "SBTM", function()
    local cvar = GetConVar("cl_sbtm_teamoutline"):GetInt()
    local m = GetConVar("cl_sbtm_teamoutline_mode"):GetInt()
    if cvar > 0 and m > 0 and m ~= 2 and
            (not SBMG or not SBMG:GameHasTag(SBMG_TAG_FORCE_FRIENDLY_FIRE)) and
            (cvar == 1 or (SBMG and SBMG:GetActiveGame())) then
        --local plys = team.GetPlayers(LocalPlayer():Team())
        --outline.Add(plys, team.GetColor(LocalPlayer():Team()), OUTLINE_MODE_NOTVISIBLE)
        if SBTM:IsTeamed(LocalPlayer()) then
            outline.Add(team.GetPlayers(LocalPlayer():Team()), team.GetColor(LocalPlayer():Team()), OUTLINE_MODE_NOTVISIBLE)
        elseif LocalPlayer():Team() == TEAM_SPECTATOR then
            for i = SBTM_RED, SBTM_YEL do
                outline.Add(team.GetPlayers(i), team.GetColor(i), OUTLINE_MODE_NOTVISIBLE)
            end
            outline.Add(team.GetPlayers(TEAM_UNASSIGNED), Color(255, 255, 255), OUTLINE_MODE_NOTVISIBLE)
        end
    end
end)

hook.Add("PreDrawHalos", "SBTM", function()
    local cvar = GetConVar("cl_sbtm_teamoutline"):GetInt()
    local m = GetConVar("cl_sbtm_teamoutline_mode"):GetInt()
    if cvar > 0 and m > 0 and m ~= 1 and
            (not SBMG or not SBMG:GameHasTag(SBMG_TAG_FORCE_FRIENDLY_FIRE)) and
            (cvar == 1 or (SBMG and SBMG:GetActiveGame())) then
        if SBTM:IsTeamed(LocalPlayer()) then
            halo.Add(team.GetPlayers(LocalPlayer():Team()), team.GetColor(LocalPlayer():Team()), 4, 4, 1, true, true)
        elseif LocalPlayer():Team() == TEAM_SPECTATOR then
            for i = SBTM_RED, SBTM_YEL do
                halo.Add(team.GetPlayers(i), team.GetColor(i), 4, 4, 1, true, true)
            end
            halo.Add(team.GetPlayers(TEAM_UNASSIGNED), Color(255, 255, 255), 4, 4, 1, true, true)
        end
    end
end)