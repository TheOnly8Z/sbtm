-- Just getting a tiny bit tired of making a net string for every addon that needs to hint the player
util.AddNetworkString("SBTM_Hint")
util.AddNetworkString("SBTM_Admin")
util.AddNetworkString("SBTM_NPC")
util.AddNetworkString("SBTM_Request")
util.AddNetworkString("SBTM_Color")

net.Receive("SBTM_Admin", function(len, ply)
    if not ply:IsAdmin() then return end
    local mode = net.ReadUInt(2)

    if mode == 0 then
        local id = net.ReadUInt(12)
        local tbl = net.ReadTable()

        for _, ent in pairs(tbl) do
            if isstring(ent) then
                SBTM:SetNPCTeam(ent, id)
                if id == TEAM_UNASSIGNED then
                    SBTM:Hint(ply, "#sbtm.hint.npc_unset", 0, {ent})
                else
                    SBTM:Hint(ply, "#sbtm.hint.npc_set", 0, {ent, team.GetName(id)})
                end
            else
                SBTM:SetTeam(ent, id, "#sbtm.hint.team_set_force")
            end
        end
    elseif mode == 1 then
        SBTM:Shuffle()
    elseif mode == 2 then
        SBTM:AutoAssign()
    elseif mode == 3 then
        SBTM:UnassignAll()
    end
end)

net.Receive("SBTM_Request", function(len, ply)
    if not GetConVar("sbtm_selfset"):GetBool() then return end
    local id = net.ReadUInt(12)
    if GetConVar("sbtm_selfset_balance"):GetBool() and id >= SBTM_RED and id <= SBTM_YEL then
        local target_count = #team.GetPlayers(id)
        for i = SBTM_RED, SBTM_RED + GetConVar("sbtm_shuffle_max"):GetInt() - 1 do
            if i ~= id and #team.GetPlayers(i) - (ply:Team() == i and 1 or 0) < target_count then
                SBTM:Hint(ply, "#sbtm.hint.unbalance", 1)
                return
            end
        end
    end
    SBTM:SetTeam(ply, id, "#sbtm.hint.team_set_self")
end)