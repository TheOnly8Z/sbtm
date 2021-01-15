-- Why bother?
if game.SinglePlayer() then return end

AddCSLuaFile()

SBTM = SBTM or {}
SBTM.Spawns = SBTM.Spawns or {}
SBTM.NPCTeams = SBTM.NPCTeams or {}

SBTM_RED = 101
SBTM_BLU = 102
SBTM_GRN = 103
SBTM_YEL = 104

for _, v in pairs(file.Find("sbtm/*", "LUA")) do
    if string.Left(v, 3) == "cl_" then
        AddCSLuaFile("sbtm/" .. v)
        if CLIENT then
            include("sbtm/" .. v)
        end
    elseif string.Left(v, 3) == "sv_" and (SERVER or game.SinglePlayer()) then
        include("sbtm/" .. v)
    elseif string.Left(v, 3) == "sh_" then
        include("sbtm/" .. v)
        AddCSLuaFile("sbtm/" .. v)
    end
end

if CLIENT then
    include("includes/modules/outline.lua")
end