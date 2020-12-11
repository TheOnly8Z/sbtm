net.Receive("SBTM_Hint", function()
    local str = net.ReadString()
    local i = net.ReadUInt(3)
    local argCount = net.ReadUInt(2)
    str = language.GetPhrase(str)
    if argCount > 0 then
        local args = {}
        for j = 1, argCount do args[j] = net.ReadString() end
        str = string.format(str, unpack(args))
    end
    notification.AddLegacy(str, i, 5)
    MsgC(Color(255, 255, 255), "[SBTM] ", str, "\n")
    surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
end)

net.Receive("SBTM_Color", function()
    local ply = net.ReadEntity()
    local v = net.ReadVector()
    ply:SetPlayerColor(v)
end)

net.Receive("SBTM_NPC", function()
    local class = net.ReadString()
    local id = net.ReadUInt(12)
    if id == TEAM_UNASSIGNED then
        SBTM.NPCTeams[class] = nil
    else
        SBTM.NPCTeams[class] = id
    end
end)