AddCSLuaFile()

-- Show a message telling the player to gtfo singleplayer
if game.SinglePlayer() then

    if CLIENT then
        surface.CreateFont("Futura_Warn", {
            font = "Futura-Bold",
            size = 24,
        })

        list.Set( "DesktopWindows", "SBTM", {
            title = "SBTM",
            icon = "icon64/sbtm.png",
            width		= 600,
            height		= 200,
            onewindow	= true,
            init		= function( icon, window )
                local panel = vgui.Create("DPanel", window)
                panel:Dock(FILL)
                local message = vgui.Create("DLabel", panel)
                message:SetText(language.GetPhrase("sbtm.warnsp"))
                message:SetFont("Futura_Warn")
                message:SetTextColor(Color(0, 0, 0))
                message:SetContentAlignment(5)
                message:Dock(FILL)
            end
        })
    end

    return
end

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

-- Outline library
include("includes/modules/outline.lua")
AddCSLuaFile("includes/modules/outline.lua")