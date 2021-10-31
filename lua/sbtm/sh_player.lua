hook.Add("PlayerSpawn", "SBTM", function(ply)
    local t = ply:Team()
    if GetConVar("sbtm_setplayercolor"):GetBool() then
        SBTM:SetPlayerColor(ply, t)
    end
    if t == TEAM_SPECTATOR then
        timer.Simple(0, function()
            ply:StripWeapons()
            ply:KillSilent()
            ply:Spectate(OBS_MODE_ROAMING)
        end)
    elseif GetConVar("sbtm_teamproperties"):GetBool() then
        timer.Simple(0, function()
            ply:SetMaxHealth(SBTM:GetTeamProperty(t, "health"))
            ply:SetHealth(ply:GetMaxHealth())
            ply:SetArmor(SBTM:GetTeamProperty(t, "armor"))
            ply:SetWalkSpeed(SBTM:GetTeamProperty(t, "walkspeed"))
            ply:SetRunSpeed(SBTM:GetTeamProperty(t, "runspeed"))
            ply:SetJumpPower(SBTM:GetTeamProperty(t, "jumppower"))
        end)
    end
end)

hook.Add("PlayerChangedTeam", "SBTM", function(ply, oldTeam, newTeam)
    if ply:Alive() and newTeam == TEAM_SPECTATOR then
        ply:StripWeapons()
        ply:KillSilent()
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SetNoTarget(true)
    elseif oldTeam == TEAM_SPECTATOR then
        ply:UnSpectate()
        ply:SetNoTarget(false)
        timer.Simple(0, function() ply:Spawn() end)
    end
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

hook.Add("PlayerDeathThink", "SBTM", function(ply)
    if ply:Team() == TEAM_SPECTATOR then return false end
end)

hook.Add("PlayerCanPickupWeapon", "SBTM", function(ply, wep)
    if ply:Team() == TEAM_SPECTATOR then return false end
end)

hook.Add("AllowFlashlight", "SBTM", function(ply, wep)
    if ply:Team() == TEAM_SPECTATOR then return false end
end)

hook.Add("PlayerNoClip", "SBTM", function(ply, state)
    if GetConVar("sbtm_teamproperties"):GetBool() and not state and not SBTM:GetTeamProperty(t, "noclip") then
        return false
    end
end)