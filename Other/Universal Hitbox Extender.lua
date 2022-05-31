if not game:IsLoaded() then game.Loaded:Wait() end

-- thanks 3ds and kiko metatables r hard (https://v3rmillion.net/showthread.php?tid=1089069)
-- my version uses hookmetamethod :D
if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://raw.githubusercontent.com/RectangularObject/MT-Api-vhookmetamethod/main/__source/mt-api%20v2.lua", true))() end
-- thanks lego hacker I love you for making this (https://v3rmillion.net/showthread.php?tid=1140873)
loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacker1337/legohacks/main/PhysicsServiceOnClient.lua"))()
-- thanks Iris (https://v3rmillion.net/showthread.php?pid=8154179)
--loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))()

local lPlayer = game.Players.LocalPlayer
local physService = game:GetService("PhysicsService")

physService:CreateCollisionGroup("squarehookhackcheatexploit")
physService:CollisionGroupSetCollidable("squarehookhackcheatexploit", "squarehookhackcheatexploit", false)

if game.PlaceId == 8203181639 then -- Syrian Shenanigans
    physService:CollisionGroupSetCollidable("squarehookhackcheatexploit", "Plugin_Unselectable_Group", false)
end

if game.PlaceId == 2158109152 then -- Weapon Kit
    physService:CollisionGroupSetCollidable("squarehookhackcheatexploit", "NONE", false)
end

if game.PlaceId == 4716045691 then -- Polybattle
    physService:CollisionGroupSetCollidable("squarehookhackcheatexploit", "viewModel", false)
end

if game.PlaceId == 2732246600 then -- Bloody Battle
    physService:CollisionGroupSetCollidable("squarehookhackcheatexploit", "root", false)
end

if game.PlaceId == 111311599 then -- Critical Strike
    local anticheat = game:GetService("ReplicatedFirst")["Serverbased AntiCheat"] -- then why put it in a localscript?
    -- I literally copied the rest of this from the "Serverbased Anticheat"
    local sValue = game:GetService("Players").LocalPlayer:WaitForChild("SValue")
    local function constructAnticheatString()
    	return "CS-" .. math.random(11111, 99999) .. "-" .. math.random(1111, 9999) .. "-" .. math.random(111111, 999999) .. math.random(1111111, 9999999) .. (sValue.Value * 6) ^ 2 + 18;
    end
    -- to be fair the game hasn't been updated in over a year
    task.spawn(function()
	    while true do task.wait(2)
	    	game:GetService("ReplicatedStorage").ACDetect:FireServer(sValue.Value, constructAnticheatString());
	    end
    end)
    anticheat.Disabled = true
end

-- thanks inori and wally
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua'))()
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("HitboxExtender")

local mainWindow = Library:CreateWindow("cheaters get banned.")
local mainTab = mainWindow:AddTab("Main")
local mainGroupbox = mainTab:AddLeftGroupbox("Hitbox Extender")
local ignoresGroupbox = mainTab:AddRightGroupbox("Ignores")
local espGroupbox = mainTab:AddLeftGroupbox("ESP")
local miscGroupbox = mainTab:AddLeftGroupbox("Misc")

local extenderToggled = mainGroupbox:AddToggle("extenderToggled", {Text = "Toggle"})
local extenderSize = mainGroupbox:AddSlider("extenderSize", {Text = "Size", Min = 2, Max = 50, Default = 10, Rounding = 1})
local extenderTransparency = mainGroupbox:AddSlider("extenderTransparency", {Text = "Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2})
local customPartNameInput = mainGroupbox:AddInput("customPartList", {Text = "Custom Part Name", Default = "HeadHB"})
local extenderPartList = mainGroupbox:AddDropdown("extenderPartList", {Text = "Body Parts", AllowNull = true, Multi = true, Values = {"Custom Part", "Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, Default = "Head"})
local extenderUpdateRate = miscGroupbox:AddSlider("extenderUpdateRate", {Text = "Update Rate", Min = 0, Max = 1000, Default = 0, Rounding = 0, Suffix = "ms"})

local espNameToggled = espGroupbox:AddToggle("espNameToggled", {Text = "Name"})
:AddColorPicker("espNameColor1", {Title = "Fill Color", Default = Color3.fromRGB(255, 255, 255)})
:AddColorPicker("espNameColor2", {Title = "Outline Color", Default = Color3.fromRGB(0, 0, 0)})
local espNameUseTeamColor = espGroupbox:AddToggle("espNameUseTeamColor", {Text = "Use Team Color For Name"})
local espNameType = espGroupbox:AddDropdown("espNameType", {Text = "Name Type", AllowNull = false, Multi = false, Values = {"Display Name", "Account Name"}, Default = "Display Name"})
local espHighlightToggled = espGroupbox:AddToggle("espHighlightToggled", {Text = "Chams"})
:AddColorPicker("espHighlightColor1", {Title = "Fill Color", Default = Color3.fromRGB(0,0,0)})
:AddColorPicker("espHighlightColor2", {Title = "Outline Color", Default = Color3.fromRGB(0, 0, 0)})
local espHighlightUseTeamColor = espGroupbox:AddToggle("espHighlightUseTeamColor", {Text = "Use Team Color For Chams"})
local espHighlightDepthMode = espGroupbox:AddDropdown("espHighlightDepthMode", {Text = "Chams Depth Mode", AllowNull = false, Multi = false, Values = {"Occluded", "AlwaysOnTop"}, Default = "Occluded"})
local espHighlightFillTransparency = espGroupbox:AddSlider("espHighlightFillTransparency", {Text = "Chams Fill Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2})
local espHighlightOutlineTransparency = espGroupbox:AddSlider("espHighlightOutlineTransparency", {Text = "Chams Outline Transparency", Min = 0, Max = 1, Default = 0, Rounding = 2})


local playerNames = {}
--local npcNames = {} -- I was planning on adding npc support
local teamNames = {}

local extenderSitCheck = ignoresGroupbox:AddToggle("extenderSitCheck", {Text = "Ignore Sitting Players"})
local extenderFFCheck = ignoresGroupbox:AddToggle("extenderFFCheck", {Text = "Ignore Forcefielded Players"})
local ignoreSelectedPlayersToggled = ignoresGroupbox:AddToggle("ignoreSelectedPlayersToggled", {Text = "Ignore Selected Players"})
local ignorePlayerList = ignoresGroupbox:AddDropdown("ignorePlayerList", {Text = "Players", AllowNull = true, Multi = true, Values = playerNames})
--local ignoreSelectedNpcsToggled = ignoresGroupbox:AddToggle("ignoreSelectedNpcsToggled", {Text = "Ignore Selected Npcs"})
--local ignoreNpcList = ignoresGroupbox:AddDropdown("ignoreNpcList", {Text = "Npcs", AllowNull = true, Multi = true, Values = npcNames})
local ignoreSelfTeamToggled = ignoresGroupbox:AddToggle("ignoreSelfTeamToggled", {Text = "Ignore Own Team"})
local ignoreSelectedTeamsToggled = ignoresGroupbox:AddToggle("ignoreSelectedTeamsToggled", {Text = "Ignore Selected Teams"})
local ignoreTeamList = ignoresGroupbox:AddDropdown("ignoreTeamList", {Text = "Teams", AllowNull = true, Multi = true, Values = teamNames})

-- thanks roblox dev forum
local function CheckTableEquality(t1,t2)
    for i,v in next, t1 do if t2[i]~=v then return false end end
    for i,v in next, t2 do if t1[i]~=v then return false end end
    return true
end

-- updates the player list
task.spawn(function()
    while true do task.wait() -- if you cry about while true do loops then kys
        local temp = {}
        for i,v in ipairs(game.Players:GetPlayers()) do
            if v ~= lPlayer then
                temp[i] = v.Name
            end
        end
        if not CheckTableEquality(playerNames, temp) then
            playerNames = temp
            ignorePlayerList.Values = temp
            ignorePlayerList:SetValues()
            ignorePlayerList:Display()
        end
    end
end)

-- updates the team list
task.spawn(function()
    while true do task.wait()
        local temp = {}
        for i,v in pairs(game.Teams:GetTeams()) do
            temp[i] = v.Name
        end
        if not CheckTableEquality(teamNames, temp) then
            teamNames = temp
            ignoreTeamList.Values = temp
            ignoreTeamList:SetValues()
            ignoreTeamList:Display()
        end
    end
end)

--task.spawn(function()
--    while true do task.wait()
--        local temp = {}
--        for i,v in ipairs(npcs) do
--            temp[i] = v.Name
--        end
--        if not CheckTableEquality(npcNames, temp) then
--            ignoreNpcList.Values = temp
--            ignoreNpcList:SetValues()
--            ignoreNpcList:Display()
--        end
--    end
--end)

SaveManager:BuildConfigSection(mainTab)
SaveManager:LoadAutoloadConfig()
Library:Notify("hai :3")
Library:Notify("Press right ctrl to open the menu")

-- Returns a table of every possible bodypart in a character, or nil if the character does not exist.
local function getBodyParts(character)
    local parts = {
        Head = character:WaitForChild("Head"),
        HumanoidRootPart = character:WaitForChild("HumanoidRootPart"),
        Humanoid = character:WaitForChild("Humanoid"),
        Torso = {},
        ["Left Arm"] = {},
        ["Right Arm"] = {},
        ["Left Leg"] = {},
        ["Right Leg"] = {}
    }
    for _,v in pairs(character:GetChildren()) do
        if v:IsA("BasePart") and parts.Humanoid:GetLimb(v) ~= Enum.Limb.Unknown then
            if string.match(v.Name, "Torso") then
                parts.Torso[v.Name] = v
                continue
            end
            if string.match(v.Name, "Left") then
                if string.match(v.Name, "Arm") or string.match(v.Name, "Hand") then
                    parts["Left Arm"][v.Name] = v
                    continue
                end
                if string.match(v.Name, "Leg") or string.match(v.Name, "Foot") then
                    parts["Left Leg"][v.Name] = v
                    continue
                end
            end
            if string.match(v.Name, "Right") then
                if string.match(v.Name, "Arm") or string.match(v.Name, "Hand") then
                    parts["Right Arm"][v.Name] = v
                    continue
                end
                if string.match(v.Name, "Leg") or string.match(v.Name, "Foot") then
                    parts["Right Leg"][v.Name] = v
                    continue
                end
            end
        end
    end
    return parts
end

-- Main function
local function addCharacter(character)
    local nameEsp = Drawing.new("Text"); nameEsp.Center = true; nameEsp.Outline = true
    local chams = Instance.new("Highlight", character)
    chams.Enabled = false
    --ProtectInstance(chams)
    local player = game.Players:GetPlayerFromCharacter(character)
    local timer = 0
    local originals = {}
    local bodyParts = getBodyParts(character)
    -- Sets up original sizes and creates hooks to bypass localscript anticheats
    local function setup(i, v)
        if not originals[i] then
            originals[i] = {}
            originals[i].Size = v.Size
            originals[i].Transparency = v.Transparency
            originals[i].Massless = v.Massless
            originals[i].CollisionGroup = physService:GetCollisionGroupName(v.CollisionGroupId)
            local sizeHook = v:AddGetHook("Size", originals[i].Size)
            local transparencyHook = v:AddGetHook("Transparency", originals[i].Transparency)
            local masslessHook = v:AddGetHook("Massless", originals[i].Massless)
            local collisionHook = v:AddGetHook("CollisionGroupId", physService:GetCollisionGroupId(originals[i].CollisionGroup))
            v:AddSetHook("Size", function(self, value)
                originals[i].Size = value
                sizeHook:Modify("Size", value)
                return value
            end)
            v:AddSetHook("Transparency", function(self, value)
                originals[i].Transparency = value
                transparencyHook:Modify("Transparency", value)
                return value
            end)
            v:AddSetHook("Massless", function(self, value)
                originals[i].Massless = value
                masslessHook:Modify("Massless", value)
                return value
            end)
            v:AddSetHook("CollisionGroupId", function(self, value)
                originals[i].CollisionGroup = physService:GetCollisionGroupName(value)
                collisionHook:Modify("CollisionGroupId", value)
                return value
            end)
        end
    end
    do
        local customPart = character:FindFirstChild(customPartNameInput.Value)
        if customPart and customPart:IsA("BasePart") then
            if not originals[customPart.Name] then
                setup(customPart.Name, customPart)
            end
        end
        for i,v in pairs(bodyParts) do
            if i ~= "Humanoid" and type(v) ~= "table" then
                if not originals[i] then
                    setup(i,v)
                end
            elseif type(v) == "table" then
                for o,b in pairs(v) do
                    if not originals[o] then
                        setup(o,b)
                    end
                end
            end
        end
    end
    -- resets the properties of the selected part.
    -- if "all" is passed, will reset every part
    local function reset(part)
        if part == "custompart" or part == "all" then
            local customPart = character:FindFirstChild(customPartNameInput.Value)
            if customPart and customPart:IsA("BasePart") then
                customPart.Size = originals[customPart.Name].Size
                customPart.Transparency = originals[customPart.Name].Transparency
                customPart.Massless = originals[customPart.Name].Massless
                physService:SetPartCollisionGroup(customPart, originals[customPart.Name].CollisionGroup)
            end
        end
        for i,v in pairs(bodyParts) do
            if string.lower(part) == string.lower(i) or part == "all" then
                if i ~= "Humanoid" and type(v) ~= "table" then
                    v.Size = originals[i].Size
                    v.Transparency = originals[i].Transparency
                    v.Massless = originals[i].Massless
                    physService:SetPartCollisionGroup(v, originals[i].CollisionGroup)
                elseif type(v) == "table" then
                    for o,b in pairs(v) do
                        b.Size = originals[o].Size
                        b.Transparency = originals[o].Transparency
                        b.Massless = originals[o].Massless
                        physService:SetPartCollisionGroup(b, originals[o].CollisionGroup)
                    end
                end
            end
        end
    end
    local function getChecks()
        if bodyParts.Humanoid:GetState() == Enum.HumanoidStateType.Dead or bodyParts.Humanoid.Health <= 0 then
            return 2
        end
        if extenderSitCheck.Value then
            if bodyParts.Humanoid.Sit then
                return 1
            end
        end
        if extenderFFCheck.Value then
            local ff = character:FindFirstChildWhichIsA("ForceField", true)
            if ff and ff.Visible then
                return 1
            end
        end
        if ignoreSelfTeamToggled.Value then
            if game.PlaceId == 2039118386 then -- Neighborhood War
                local selfTeam
                local playerTeam
                pcall(function()
                    selfTeam = lPlayer.Character.HumanoidRootPart.BrickColor
                    playerTeam = bodyParts.HumanoidRootPart.BrickColor
                end)
                if selfTeam == playerTeam then
                    return 1
                end
            elseif game.PlaceId == 2158109152 then
                local friendly = character:FindFirstChild("Friendly", true)
                if friendly then
                    return 1
                end
            else
                if lPlayer.Team == player.Team then
                    return 1
                end
            end
        end
        if ignoreSelectedTeamsToggled.Value then
            local teamList = ignoreTeamList:GetActiveValues()
            if table.find(teamList, tostring(player.Team)) then
                return 1
            end
        end
        if ignoreSelectedPlayersToggled.Value then
            local playerList = ignorePlayerList:GetActiveValues()
            if table.find(playerList, tostring(player.Name)) then
                return 1
            end
        end
        return 0
    end
    -- loop that handles everything
    local Heartbeat
    Heartbeat = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        timer += deltaTime
        local checks = getChecks()
        if espNameToggled.Value then
            if character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                if onScreen and checks == 0 then
                    if espNameType.Value == "Display Name" then
                        nameEsp.Text = player.DisplayName
                    else
                        nameEsp.Text = player.Name
                    end
                    if espNameUseTeamColor.Value then
                        nameEsp.Color = player.TeamColor.Color
                    else
                        nameEsp.Color = Options.espNameColor1.Value
                    end
                    nameEsp.OutlineColor = Options.espNameColor2.Value
                    nameEsp.Position = Vector2.new(pos.X, pos.Y)
                    nameEsp.Size = 1000 / pos.Z + 10
                    nameEsp.Visible = true
                else
                    nameEsp.Visible = false
                end
            else
                nameEsp.Visible = false
            end
        else
            nameEsp.Visible = false
        end
        if espHighlightToggled.Value and checks == 0 then
            if espHighlightUseTeamColor.Value then
                chams.FillColor = player.TeamColor.Color
                chams.OutlineColor = player.TeamColor.Color
            else
                chams.FillColor = Options.espHighlightColor1.Value
                chams.OutlineColor = Options.espHighlightColor2.Value
            end
            chams.DepthMode = Enum.HighlightDepthMode[espHighlightDepthMode.Value]
            chams.FillTransparency = espHighlightFillTransparency.Value
            chams.OutlineTransparency = espHighlightOutlineTransparency.Value
            chams.Enabled = true
        else
            chams.Enabled = false
        end
        if timer >= (extenderUpdateRate.Value / 1000) then -- divided by 1000 because milliseconds
            timer = 0
            local bodyPartList = extenderPartList:GetActiveValues()
            if checks == 2 then
                reset("all")
                nameEsp:Remove()
                nameEsp = nil
                chams:Destroy()
                Heartbeat:Disconnect()
                return
            elseif checks == 1 then
                reset("all")
                return
            end
            if extenderToggled.Value then
                if table.find(bodyPartList, "Custom Part") then
                    local customPart = character:FindFirstChild(customPartNameInput.Value)
                    if customPart then
                        customPart.Massless = true
                        physService:SetPartCollisionGroup(customPart, "squarehookhackcheatexploit")
                        customPart.Size = Vector3.new(extenderSize.Value, extenderSize.Value, extenderSize.Value)
                        customPart.Transparency = extenderTransparency.Value
                    end
                else
                    reset("custompart")
                end
                for i,v in pairs(bodyParts) do
                    if table.find(bodyPartList, i) then
                        if type(v) ~= "table" then
                            if i ~= "HumanoidRootPart" then
                                v.Massless = true
                            end
                            physService:SetPartCollisionGroup(v, "squarehookhackcheatexploit")
                            v.Size = Vector3.new(extenderSize.Value, extenderSize.Value, extenderSize.Value)
                            v.Transparency = extenderTransparency.Value
                        else
                            for o,b in pairs(v) do
                                b.Massless = true
                                physService:SetPartCollisionGroup(b, "squarehookhackcheatexploit")
                                b.Size = Vector3.new(extenderSize.Value, extenderSize.Value, extenderSize.Value)
                                b.Transparency = extenderTransparency.Value
                            end
                        end
                    else
                        reset(i)
                    end
                end
            else
                reset("all")
            end
        end
    end)
    local PlayerRemoving
    PlayerRemoving = game.Players.PlayerRemoving:Connect(function(v)
        if v == player then
            if nameEsp then
                nameEsp:Remove()
            end
            chams:Destroy()
            Heartbeat:Disconnect()
            PlayerRemoving:Disconnect()
        end
    end)
end
for _,player in ipairs(game.Players:GetPlayers()) do
    if player ~= lPlayer then
        task.spawn(function()
            player.CharacterAdded:Connect(function(v)
                addCharacter(v)
            end)
            if player.Character then
                addCharacter(player.Character)
            end
        end)
    else
        local function onDescendantAdded(descendant)
            if descendant:IsA("BasePart") then
                physService:SetPartCollisionGroup(descendant, "squarehookhackcheatexploit")
            end
        end
        local function onCharacterAdded(character)
            for _,v in pairs(character:GetDescendants()) do
                onDescendantAdded(v)
            end
            character.DescendantAdded:Connect(onDescendantAdded)
        end
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(v)
        addCharacter(v)
    end)
end)
-- I'm sorry for your eyes
