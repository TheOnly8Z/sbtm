
hook.Add("CreateTeams", "SBTM", function()
    team.SetUp(SBTM_RED, "Red Team", Color(255, 0, 0), false)
    team.SetUp(SBTM_BLU, "Blue Team", Color(0, 0, 255), false)
    team.SetUp(SBTM_GRN, "Green Team", Color(0, 255, 0), false)
    team.SetUp(SBTM_YEL, "Yellow Team", Color(255, 255, 0), false)
end)