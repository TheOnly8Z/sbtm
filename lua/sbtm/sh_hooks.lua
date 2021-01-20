hook.Add("PlayerShouldTakeDamage", "SBTM", function(ply, atk)
    if IsValid(ply) and IsValid(atk) and atk:IsPlayer() then
        if GetConVar("sbtm_nofriendlyfire"):GetBool() and ply:Team() == atk:Team() and ply ~= atk
                and SBTM:IsTeamed(ply) and SBTM:IsTeamed(atk)
                and (not SBMG or not SBMG:GameHasTag(SBMG_TAG_FORCE_FRIENDLY_FIRE)) then
            return false
        elseif GetConVar("sbtm_neutralunassigned"):GetBool() and ply ~= atk and
                (ply:Team() == TEAM_UNASSIGNED and SBTM:IsTeamed(atk)
                or atk:Team() == TEAM_UNASSIGNED and SBTM:IsTeamed(ply)) then
            return false
        end
    end
end)

hook.Add("PostPlayerDeath", "SBTM", function(ply)
    if (GetConVar("sbtm_deathunassign"):GetBool() or (SBMG and SBMG:GameHasTag(SBMG_TAG_UNASSIGN_ON_DEATH))) and SBTM:IsTeamed(ply) then
        SBTM:SetTeam(ply, TEAM_UNASSIGNED, "#sbtm.hint.death_unassign")
    end
end)

hook.Add("OnEntityCreated", "SBTM", function(ent)
    timer.Simple(0, function()
        if IsValid(ent) and SBTM.NPCTeams[ent:GetClass()] then
            local id = SBTM.NPCTeams[ent:GetClass()]
            ent.SBTM_Team = id
           if GetConVar("sbtm_teamnpcs_color"):GetBool() then
                ent:SetColor(team.GetColor(id))
            end
            ent:SetKeyValue("squadname", "SBTM_" .. tostring(id))
            if SERVER then
                for c, t in pairs(SBTM.NPCTeams) do
                    if c ~= ent:GetClass() then
                        ent:AddRelationship(c .. " " .. (t == id and "D_LI" or "D_HT") .. " 9999")
                    end
                end
                for _, ply in pairs(player.GetAll()) do
                    if SBTM:IsTeamed(ply) then
                        ent:AddEntityRelationship(ply, ply:Team() == id and D_LI or D_HT, 9999)
                    end
                end
            end
        end
    end)
end)

hook.Add("PlayerSelectSpawn", "SBTM", function(ply)
    local spawns = {}
    for _, e in pairs(SBTM.Spawns) do
        if e:GetTeam() == ply:Team() then
            local tr = util.TraceHull({
                start = e:GetPos(),
                endpos = e:GetPos(),
                maxs = Vector(16, 16, 72),
                mins = Vector(-16, -16, 0),
                filter = e
            })
            if not tr.Hit then
                table.insert(spawns, e)
            end
        end
    end
    if #spawns > 0 then return spawns[math.random(1, #spawns)] end
end)

hook.Add("PlayerSpawn", "SBTM", function(ply)
    if GetConVar("sbtm_setplayercolor"):GetBool() then
        SBTM:SetPlayerColor(ply, ply:Team())
    end
end)

if SERVER then
    SBTM.AssociatedSpawns = {
        [SBTM_RED] = {
            "info_player_rebel",
            "info_player_terrorist",
            "info_player_allies"
        },
        [SBTM_BLU] = {
            "info_player_combine",
            "info_player_counterterrorist",
            "info_player_axis"
        },
        [0] = { -- uhhhhh this is awkward
            "info_player_teamspawn"
        }
    }

    function SBTM.LoadAssociatedSpawns()
        if GetConVar("sbtm_mapspawns"):GetBool() then
            for t, v in pairs(SBTM.AssociatedSpawns) do
                for _, class in pairs(v) do
                    local tbl = ents.FindByClass(class)
                    for _, ent in pairs(tbl) do
                        local spawn = ents.Create("sbtm_spawn")
                        spawn:SetPos(ent:GetPos() + Vector(0, 0, 1))
                        spawn:SetAngles(ent:GetAngles())
                        spawn:Spawn()
                        spawn:SetTeam(t == 0 and (ent:GetInternalVariable("TeamNum") + 99) or t)
                    end
                end
            end
        end
    end

    hook.Add("InitPostEntity", "SBTM", SBTM.LoadAssociatedSpawns)
    hook.Add("PostCleanupMap", "SBTM", SBTM.LoadAssociatedSpawns)

    -- Hack from wiki
    hook.Add( "PlayerInitialSpawn", "SBTM", function( p )
        if GetConVar("sbtm_assignonjoin"):GetBool() then
            hook.Add( "SetupMove", p, function( self, ply, _, cmd )
                if self == ply and not cmd:IsForced() then
                    SBTM:AutoAssign({ply})
                    hook.Remove( "SetupMove", self )
                end
            end )
        end
    end )
end