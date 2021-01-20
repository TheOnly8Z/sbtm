CreateConVar("sbtm_selfset", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED, "If enabled, players can set their own team.", 0, 1)
CreateConVar("sbtm_selfset_balance", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "If enabled, players cannot unbalance teams.", 0, 1)
CreateConVar("sbtm_teamnpcs", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "If enabled, admins can put NPCs into teams.", 0, 1)
CreateConVar("sbtm_teamnpcs_color", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "If enabled, NPCs with teams will be colored.", 0, 1)
CreateConVar("sbtm_nofriendlyfire", "1", FCVAR_ARCHIVE, "If enabled, players on the same team cannot hurt each other.", 0, 1)
CreateConVar("sbtm_neutralunassigned", "0", FCVAR_ARCHIVE, "If enabled, unassigned players and teamed players cannot hurt each other.", 0, 1)
CreateConVar("sbtm_setplayercolor", "1", FCVAR_ARCHIVE, "If enabled, setting team also sets player color (not enforced).", 0, 1)
CreateConVar("sbtm_shuffle_max", "2", FCVAR_ARCHIVE, "The number of teams used when shuffling players. Also used to consider team balance.", 2, 4)
CreateConVar("sbtm_deathunassign", "0", FCVAR_ARCHIVE, "If enabled, teamed players who die becomes unassigned.", 0, 1)
CreateConVar("sbtm_mapspawns", "1", FCVAR_ARCHIVE, "If enabled, automatically create team spawns if a map supports it.", 0, 1)
CreateConVar("sbtm_assignonjoin", "0", FCVAR_ARCHIVE, "If enabled, players are auto-assigned a team on connection.", 0, 1)
CreateConVar("sbtm_teamoutline", "1", FCVAR_ARCHIVE, "If enabled, players can see teammates through walls.", 0, 1)

if CLIENT then
    CreateConVar("cl_sbtm_teamoutline", "1", FCVAR_ARCHIVE, "Whether to show teammate outlines.", 0, 2)
    CreateConVar("cl_sbtm_teamoutline_mode", "1", FCVAR_ARCHIVE, "Which type of highlighting to use.", 0, 3)
    CreateConVar("cl_sbtm_teamoutline_chevron", "1", FCVAR_ARCHIVE, "Draw a chevron over teammates' heads.", 0, 1)
end

concommand.Add("sbtm_shuffle", function(ply, cmd, args)
    if SERVER and (not IsValid(ply) or ply:IsAdmin()) then
        SBTM:Shuffle()
    elseif CLIENT and ply:IsAdmin() then
        net.Start("SBTM_Admin")
            net.WriteUInt(1, 2)
        net.SendToServer()
    end
end)

concommand.Add("sbtm_autoassign", function(ply, cmd, args)
    if SERVER and (not IsValid(ply) or ply:IsAdmin()) then
        SBTM:AutoAssign()
    elseif CLIENT and ply:IsAdmin() then
        net.Start("SBTM_Admin")
            net.WriteUInt(2, 2)
        net.SendToServer()
    end
end)

concommand.Add("sbtm_unassignall", function(ply, cmd, args)
    if SERVER and (not IsValid(ply) or ply:IsAdmin()) then
        SBTM:UnassignAll()
    elseif CLIENT and ply:IsAdmin() then
        net.Start("SBTM_Admin")
            net.WriteUInt(3, 2)
        net.SendToServer()
    end
end)