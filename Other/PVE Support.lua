--[[
    Made by doggo#6713
    Edited by Squares#9233
]]

--[[
Allows npcs to be returned by game.Players:GetPlayers()
This can be used for any script that usually only work against other players
Side effect: npcs show up in the escape menu player list
]]

--[[
    Changelogs
    11/3/2021 -- Squares
        [*] Replaced all occurrences of "next, v" with "ipairs()"
        [*] Replaced depreciated function "Remove()" with "Destroy()"
        [!] Remade the folder checking method
            - npc_paths are now paths that the script checks descendants from.
            - npc_folder_names are the names of the folders to add npc support to
    10/24/2021 -- Doggo
        [!] Made a fix so npcs with the same name can be made
]]

local settings = {
    npc_paths = _G.npc_paths,
    npc_folder_names = _G.npc_folder_names,

    checks = {
        humanoid_check = _G.humanoid_check, -- checks if there's a humanoid in the model
        hrp_check = _G.hrp_check, -- checks if there's a humanoidrootpart in it
    },

    make_teams_for_npcs = {
        ['enabled'] = _G.make_teams_for_npcs, -- Create/Assign a team for the npcs?
        ['name'] = _G.npc_team_name, -- Can be named the same as an existing team
        ['color'] = _G.npc_team_color -- Can be colored the same as an existing team
    }
}
local spoof = {}

function makeinstanceplayer(name, character)
    local player = Instance.new('Player', game.Players)
    table.insert(spoof, player)
    player.Name = name
    player.Character = character
    player.Archivable = false

    if settings.make_teams_for_npcs.enabled then
        if not game:GetService('Teams'):FindFirstChild(settings.make_teams_for_npcs.name) then
            local team_instance = Instance.new('Team', game:GetService('Teams'))
            team_instance.Name = settings.make_teams_for_npcs.name
            team_instance.TeamColor = settings.make_teams_for_npcs.color

            player.Team = team_instance
        else
            player.Team = game:GetService('Teams'):FindFirstChild(settings.make_teams_for_npcs.name)
        end
    end

end

function findplayerinstance(name, character)
    for a,b in ipairs(game.Players:GetChildren()) do
        if b:IsA('Player') and b.Name == name and b.Character == character then
            return b
        end
    end
end

function startaddingnpcs(npcpath)
    local functions = {
        ['adding'] = function(instance)
            if instance:IsA('Model')
            and
            (settings.checks.humanoid_check and instance:FindFirstChild('Humanoid') or not settings.checks.humanoid_check)
            and
            (settings.checks.hrp_check and instance:FindFirstChild('HumanoidRootPart') or not settings.checks.hrp_check)
            then
                local pl = findplayerinstance(instance.Name, instance)
                if not pl then
                    print(instance.Name, 'Added')
                    makeinstanceplayer(instance.Name, instance)
                end
            end
        end,
        ['removing'] = function(instance)
            if instance:IsA('Model') and
            (settings.checks.humanoid_check and instance:FindFirstChild('Humanoid') or not settings.checks.humanoid_check)
            and
            (settings.checks.hrp_check and instance:FindFirstChild('HumanoidRootPart') or not settings.checks.hrp_check)
            then
                local pl = findplayerinstance(instance.Name, instance)
                if pl then
                    print(pl.Name, 'Removed')
                    pl:Destroy()
                end
            end
        end
    }

    for a, instance in ipairs(npcpath:GetChildren()) do
        functions['adding'](instance)
    end

    npcpath.ChildAdded:Connect(function(instance)
        wait(0.1) -- keep :thumb:
        functions['adding'](instance)
    end)

    npcpath.ChildRemoved:Connect(function(instance)
        functions['removing'](instance)
    end)
end

local oldindex
oldindex = hookmetamethod(game, "__index", newcclosure(function(self, ...)
    if table.find(spoof, self) then
        if not checkcaller() then
            return nil
        end
    end
    return oldindex(self, ...)
end))
local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local namecallMethod = getnamecallmethod()
    if not checkcaller() and self == game.Players and namecallMethod == "GetPlayers" or not checkcaller() and self == game.Players and namecallMethod == "GetChildren" then
        local players = game.Players:GetChildren()
        table.foreachi(players, function(index, player)
            if table.find(spoof, player) then
                table.remove(players, table.find(spoof, player))
            end
        end)
        return players
    end
    return oldnamecall(self, ...)
end))

game.Players.PlayerRemoving:Connect(function(instance)
    if table.find(spoof, instance) then
        table.remove(spoof, table.find(spoof, instance))
    end
end)

for a,b in ipairs(settings.npc_paths) do
    print("Path " .. a .. " to search from: " .. b:GetFullName())
    for c,d in ipairs(settings.npc_folder_names) do
        print("Folder " .. a .. " name: " .. d)
        b.DescendantAdded:Connect(function(child)
            wait(1)
            if tostring(child) == d then
                print("New " .. d .. " found: " .. child:GetFullName())
                startaddingnpcs(child)
            end
        end)
        for e,f in ipairs(b:GetDescendants()) do
            if tostring(f) == d then
                print(d .. " found: " .. f:GetFullName())
                startaddingnpcs(f)
            end
        end
    end
end
