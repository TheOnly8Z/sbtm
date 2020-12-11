local info = {}
local lists = {}

surface.CreateFont("Futura_13", {
    font = "Futura-Bold",
    size = 13,
})

surface.CreateFont("Futura_18", {
    font = "Futura-Bold",
    size = 18,
})

surface.CreateFont("Futura_24", {
    font = "Futura-Bold",
    size = 24,
})

local function populate(button, li, id)
    if button then
        button:SetText(language.GetPhrase("sbtm.join"))
        button:SetVisible(GetConVar("sbtm_selfset"):GetBool())
        button.DoClick = function(self)
            if GetConVar("sbtm_selfset"):GetBool() then
                net.Start("SBTM_Request")
                    net.WriteUInt(id, 12)
                net.SendToServer()
                timer.Simple(0.1, function()
                    for i, v in pairs(lists) do
                        populate(nil, v, i)
                    end
                end)
            end
        end
    end
    li:Clear()
    info[id] = {}
    for _, ply in pairs(team.GetPlayers(id)) do
        local line = li:AddLine(ply:GetName())
        info[id][line] = ply
    end
    for class, t in pairs(SBTM.NPCTeams) do
        if t == id then li:AddLine(class) end
    end
    if LocalPlayer():IsAdmin() then
        li.OnRowRightClick = function(self, lineID, line)
            local dmenu = DermaMenu()
            dmenu:SetPos(input.GetCursorPos())
            for t, p in SortedPairs(SBTM.IconTable) do
                if t == id then continue end
                local newOption = dmenu:AddOption(team.GetName(t), function()
                    local rows = self:GetSelected()
                    local targets = {}
                    for _, v in pairs(rows) do
                        table.insert(targets, info[id][v] or v:GetColumnText(1))
                    end
                    net.Start("SBTM_Admin")
                        net.WriteUInt(0, 2)
                        net.WriteUInt(t, 12)
                        net.WriteTable(targets)
                    net.SendToServer()
                    -- Invalidate existing lists so it's updated
                    timer.Simple(0.25, function()
                        for i, v in pairs(lists) do
                            populate(nil, v, i)
                        end
                    end)
                end)
                newOption:SetIcon(p)
            end
            dmenu:Open()
        end
    end
end

local function repopulate()
    timer.Simple(0.25, function()
        for i, v in pairs(lists) do
            populate(nil, v, i)
        end
    end)
end

list.Set( "DesktopWindows", "SBTM", {
    title = "SBTM",
    icon = "icon64/sbtm.png",
    width		= 640,
    height		= 480,
    onewindow	= true,
    init		= function( icon, window )
        window:SetTitle( "#sbtm.title" )
        window:SetSize( math.min( ScrW() - 16, window:GetWide() ), math.min( ScrH() - 16, window:GetTall() ) )
        window:SetMinWidth( window:GetWide() )
        window:SetMinHeight( window:GetTall() )
        window:Center()

        info = {}

        local left = vgui.Create("DPanel", window)
        left:SetSize(window:GetWide() * 0.3, window:GetTall())
        left:Dock(LEFT)
        left:DockMargin(2, 2, 2, 2)

        local label_unassigned = vgui.Create("DLabel", left)
        label_unassigned:SetSize(left:GetWide() * 0.5, window:GetTall() * 0.05)
        label_unassigned:SetText(team.GetName(TEAM_UNASSIGNED))
        label_unassigned:Dock(TOP)
        label_unassigned:SetFont("Futura_24")
        label_unassigned:SetTextColor(Color(0, 0, 0))
        label_unassigned:DockMargin(4, 4, 4, 4)

        local btn_unassigned = vgui.Create("DButton", left)
        btn_unassigned:SetSize(left:GetWide() * 0.3, window:GetTall() * 0.05)
        btn_unassigned:SetPos(left:GetWide() * 0.7 - 4, 4)
        btn_unassigned:SetFont("Futura_13")

        local bottom = vgui.Create("DPanel", left)
        bottom:SetSize(left:GetWide(), window:GetTall() * 0.08)
        bottom:Dock(BOTTOM)

        local btn_shuffle = vgui.Create("DButton", bottom)
        btn_shuffle:SetSize(left:GetWide() * 0.5 - 4, window:GetTall() * 0.08)
        btn_shuffle:Dock(LEFT)
        btn_shuffle:DockMargin(2, 2, 2, 2)
        btn_shuffle:SetText(language.GetPhrase("sbtm.shuffle"))
        btn_shuffle.DoClick = function(self)
            RunConsoleCommand("sbtm_shuffle")
            repopulate()
        end
        btn_shuffle:SetDisabled(not LocalPlayer():IsAdmin())
        btn_shuffle:SetFont("Futura_13")

        local btn_assign = vgui.Create("DButton", bottom)
        btn_assign:SetSize(left:GetWide() * 0.5 - 4, window:GetTall() * 0.08)
        btn_assign:Dock(RIGHT)
        btn_assign:DockMargin(2, 2, 2, 2)
        if team.NumPlayers(TEAM_UNASSIGNED) == 0 then
            btn_assign:SetText(language.GetPhrase("sbtm.unassignall"))
            btn_assign.DoClick = function(self)
                RunConsoleCommand("sbtm_unassignall")
                repopulate()
            end
        else
            btn_assign:SetText(language.GetPhrase("sbtm.autoassign"))
            btn_assign.DoClick = function(self)
                RunConsoleCommand("sbtm_autoassign")
                repopulate()
            end
        end
        btn_assign:SetDisabled(not LocalPlayer():IsAdmin())
        btn_assign:SetFont("Futura_13")

        local list_unassigned = vgui.Create("DListView", left)
        list_unassigned:Dock(FILL)
        list_unassigned:DockMargin(4, 4, 4, 4)
        list_unassigned:AddColumn(language.GetPhrase("sbtm.titlename"))
        lists[TEAM_UNASSIGNED] = list_unassigned
        populate(btn_unassigned, list_unassigned, TEAM_UNASSIGNED)

        local layout = vgui.Create("DIconLayout", window)
        layout:Dock(FILL)
        layout:DockMargin(4, 4, 4, 4)
        layout:SetSpaceX(4)
        layout:SetSpaceY(4)

        for id = SBTM_RED, SBTM_YEL do
            local panel = layout:Add("DPanel")
            panel:SetSize(window:GetWide() * 0.35 - 16, window:GetTall() * 0.5 - 20)
            local bgclr = team.GetColor(id)
            bgclr.a = 50
            panel.Paint = function(pnl, w, h)
                draw.RoundedBox(1, 0, 0, w, h, bgclr)
                draw.SimpleTextOutlined(team.GetName(id), "Futura_24", 4, 4, team.GetColor(id), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
            end

            local btn = vgui.Create("DButton", panel)
            btn:SetSize(panel:GetWide() * 0.3, panel:GetTall() * 0.1)
            btn:SetPos(panel:GetWide() * 0.7 - 4, 4)
            btn:DockMargin(2, 2, 2, 2)
            btn:SetFont("Futura_13")

            local li = vgui.Create("DListView", panel)
            li:Dock(FILL)
            li:DockMargin(4, 32, 4, 4)
            li:AddColumn(language.GetPhrase("sbtm.titlename"))
            lists[id] = li

            populate(btn, li, id)
        end
    end
})