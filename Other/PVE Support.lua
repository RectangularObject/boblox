--[[
    Made by doggo#0009
    Edited by Squares#9233
]]

--[[
Allows npcs to be returned by game.Players:GetPlayers()
This can be used for any script that usually only work against other players
Broken Games: RECOIL, Zombie Strike
]]

--[[
    Changelogs
    2/10/2022 -- Squares
        [!] Replaced hookmetamethod with Iris Protect Instance
            - Fixes more games where you couldn't damage npcs
            - I know I said I'd rather code things myself but I'm tired of working on this
    2/9/2022 -- Squares
        [!] Fixed npcs with renamed humanoids not working
    2/8/2022 -- Squares
        [!] Fixed not being able to damage npcs after running this script
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

loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))()
function makeinstanceplayer(name, character)
    local player = Instance.new('Player', game.Players)
    ProtectInstance(player)
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
            (settings.checks.humanoid_check and instance:FindFirstChildWhichIsA('Humanoid') or not settings.checks.humanoid_check)
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
            (settings.checks.humanoid_check and instance:FindFirstChildWhichIsA('Humanoid') or not settings.checks.humanoid_check)
            and
            (settings.checks.hrp_check and instance:FindFirstChild('HumanoidRootPart') or not settings.checks.hrp_check)
            then
                local pl = findplayerinstance(instance.Name, instance)
                if pl then
                    print(pl.Name, 'Removed')
                    UnProtectInstance(pl)
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

for a,b in ipairs(settings.npc_paths) do
    print("Path " .. a .. " to search from: " .. b:GetFullName())
    for c,d in ipairs(settings.npc_folder_names) do
        print("Folder " .. c .. " name: " .. d)
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
