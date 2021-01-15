function SBTM:IsTeamed(ply)
    return ply:Team() >= SBTM_RED and ply:Team() <= SBTM_YEL
end

function SBTM:SetPlayerColor(ply, id)
    if GetConVar("sbtm_setplayercolor"):GetBool() and id >= SBTM_RED and id <= SBTM_YEL then
        local clr = team.GetColor(id)
        local v = Vector(clr.r / 255, clr.g / 255, clr.b / 255)
        ply:SetPlayerColor(v)
        if SERVER then
            net.Start("SBTM_Color")
                net.WriteEntity(ply)
                net.WriteVector(v)
            net.Broadcast()
        end
    end
end

function SBTM:Hint(ply, str, i, args)
    net.Start("SBTM_Hint")
        net.WriteString(str)
        net.WriteUInt(i or 0, 3)
        net.WriteUInt(args and #args or 0, 2)
        if args then
            for _, v in pairs(args) do
                net.WriteString(v)
            end
        end
    net.Send(ply)
end

function SBTM:SetTeam(ent, id, h)
    local oldTeam = ent:Team()
    ent:SetTeam(id)
    SBTM:SetPlayerColor(ent, id)
    SBTM:Hint(ent, h, 0, {team.GetName(id)})
    if SBMG and SBMG:GetActiveGame() then
        if not SBMG.ActivePlayers[ent] then
            SBMG:AddScore(ent, 0)
        end
        if SBMG:GetCurrentGameTable().PlayerLeave and SBMG.TeamScore[oldTeam] then
            SBMG:GetCurrentGameTable():PlayerLeave(ent, oldTeam)
        end
        if SBMG:GetCurrentGameTable().PlayerJoin and SBMG.TeamScore[id] then
            SBMG:GetCurrentGameTable():PlayerJoin(ent, oldTeam)
        end
    end
end

function SBTM:SetNPCTeam(class, id)
    if id == TEAM_UNASSIGNED then
        SBTM.NPCTeams[class] = nil
    else
        SBTM.NPCTeams[class] = id
        for _, ent in pairs(ents.FindByClass(class)) do
            if ent.SBTM_Team then continue end
            ent.SBTM_Team = id
            if GetConVar("sbtm_teamnpcs_color"):GetBool() then
                ent:SetColor(team.GetColor(id))
            end
            ent:SetKeyValue("squadname", "SBTM_" .. tostring(id))
            for c, t in pairs(SBTM.NPCTeams) do
                if c ~= class then
                    ent:AddRelationship(c .. " " .. (t == id and "D_LI" or "D_HT") .. " 9999")
                    for _, e in pairs(ents.FindByClass(c)) do
                        e:AddRelationship(class .. " " .. (t == id and "D_LI" or "D_HT") .. " 9999")
                    end
                end
            end
            for _, ply in pairs(player.GetAll()) do
                if SBTM:IsTeamed(ply) then
                    ent:AddEntityRelationship(ply, ply:Team() == id and D_LI or D_HT, 9999)
                end
            end
        end
    end
    net.Start("SBTM_NPC")
        net.WriteString(class)
        net.WriteUInt(id, 12)
    net.Broadcast()
end

function SBTM:Shuffle(plys)
    plys = plys or player.GetAll()
    local t = 1
    while #plys > 0 do
        local i = math.random(1, #plys)
        if SBTM_RED + t ~= plys[i]:Team() then
            SBTM:SetTeam(plys[i], SBTM_RED + t, "#sbtm.hint.team_set_force")
        end
        table.remove(plys, i)
        t = (t + 1) % GetConVar("sbtm_shuffle_max"):GetInt()
    end
end

function SBTM:AutoAssign(plys)
    plys = plys or team.GetPlayers(TEAM_UNASSIGNED)
    while #plys > 0 do
        local index = math.random(1, #plys)
        -- Find the team with the minimum amount of players
        local target_team, balanced = SBTM_RED, true
        for i = SBTM_BLU, SBTM_BLU + GetConVar("sbtm_shuffle_max"):GetInt() - 2 do
            if team.NumPlayers(i) < team.NumPlayers(target_team) then
                balanced = false
                target_team = i
            elseif team.NumPlayers(i) > team.NumPlayers(target_team) then
                balanced = false
            end
        end
        -- If teams are balanced just pick a random one
        if balanced then target_team = SBTM_RED + math.random(1, GetConVar("sbtm_shuffle_max"):GetInt()) - 1 end
        SBTM:SetTeam(plys[index], target_team, "#sbtm.hint.team_set_force")
        table.remove(plys, index)
    end
end

function SBTM:UnassignAll()
    for _, p in pairs(player.GetAll()) do
        SBTM:SetTeam(p, TEAM_UNASSIGNED, "#sbtm.hint.team_set_force")
    end
end

function SBTM:ConVarTeamColor(t)
    local cvar = "sbtm_clr_"
    if t == SBTM_RED then
        cvar = cvar .. "red"
    elseif t == SBTM_BLU then
        cvar = cvar .. "blue"
    elseif t == SBTM_GRN then
        cvar = cvar .. "green"
    elseif t == SBTM_YEL then
        cvar = cvar .. "yellow"
    end
    local clr = Color(255, 255, 255)
    clr.r = GetConVar(cvar .. "_r"):GetInt()
    clr.g = GetConVar(cvar .. "_g"):GetInt()
    clr.b = GetConVar(cvar .. "_b"):GetInt()
    return clr
end