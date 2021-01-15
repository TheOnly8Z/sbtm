AddCSLuaFile()

ENT.PrintName = "SBTM Spawn"
ENT.Type = "anim"
ENT.Category = "Fun + Games"
ENT.Spawnable = not game.SinglePlayer()
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.SBTM_TeamEntity = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Team")
end

if SERVER then

    function ENT:Initialize()
        self:SetModel("models/props_junk/sawblade001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        if self:GetTeam() == 0 then self:SetTeam(TEAM_UNASSIGNED) end
        table.insert(SBTM.Spawns, self)
    end

    function ENT:OnRemove()
        table.RemoveByValue(SBTM.Spawns, self)
    end

elseif CLIENT then
    local mat = Material("sprites/spawn.png")
    function ENT:Draw()
        local angle = self:GetAngles()
        cam.Start3D2D(self:GetPos(), angle, 0.04)
            local r, g, b = (self:GetTeam() == TEAM_UNASSIGNED and Color(255, 255, 255) or team.GetColor(self:GetTeam())):Unpack()
            surface.SetDrawColor(r, g, b)
            surface.SetMaterial(mat)
            local s = 1024
            surface.DrawTexturedRect(-s / 2, -s / 2, s, s)
        cam.End3D2D()
        --self:DrawModel()
    end
end