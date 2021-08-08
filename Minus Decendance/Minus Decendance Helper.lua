-- rConsole Chat Logger (credits to e621 on v3rm, I just edited it).
loadstring(game:HttpGet("https://raw.githubusercontent.com/RectangularObject/boblox/main/Other/rConsole%20Chat%20Logger.lua", true))()

-- Prevents the map table from turning off when power runs out.
function mapEnable()
    game:GetService("RunService").Heartbeat:Connect(function()
        game:GetService("Workspace").MapTable.MapScreen.SurfaceGui.Enabled = true
    end)
end
coroutine.wrap(mapEnable)()

-- Turn off the screen saturation you get from being near Wrath.
game:GetService("Players").LocalPlayer.Character.Wrath:Destroy()

-- Automatically collects the clipboards found around the map.
function collectInfo()
    game:GetService("RunService").Heartbeat:Connect(function()
        for _,v in pairs(game:GetService("Workspace").Info:GetChildren()) do
            pcall(function() fireclickdetector(v.Hitbox.ClickDetector, 1) end)
        end
    end)
end
coroutine.wrap(collectInfo)()

-- Makes the flashlight super bright.
function brightFlash()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            local light = game:GetService("Players").LocalPlayer.Backpack.Flashlight.Glow
            light.SpotLight.Angle = 180
            light.SpotLight.Brightness = 25
            light.SpotLight.Range = 60
            light.Beam.Width0 = 0
            light.Beam.Width1 = 0
        end)
    end)
end
coroutine.wrap(brightFlash)()

-- Displays the current floor, oxygen, and power.
function displayInfo()
    local powerEsp = Drawing.new("Text"); powerEsp.Text = "Power: Loading..."; powerEsp.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X - workspace.CurrentCamera.ViewportSize.X + 10, workspace.CurrentCamera.ViewportSize.Y - 30); powerEsp.Size = 25; powerEsp.Visible = true; powerEsp.Color = Color3.new(0.913725, 0.882352, 0.431372); powerEsp.Center = false; powerEsp.Outline = true; powerEsp.OutlineColor = Color3.new(0,0,0); powerEsp.Font = 0
    local oxygenEsp = Drawing.new("Text"); oxygenEsp.Text = "Oxygen: Loading..."; oxygenEsp.Position = powerEsp.Position - Vector2.new(0, 25); oxygenEsp.Size = 25; oxygenEsp.Visible = true; oxygenEsp.Color = Color3.new(0.431372, 0.882352, 0.913725); oxygenEsp.Center = false; oxygenEsp.Outline = true; oxygenEsp.OutlineColor = Color3.new(0,0,0); oxygenEsp.Font = 0
    local floorEsp = Drawing.new("Text"); floorEsp.Text = "Floor: Loading..."; floorEsp.Position = oxygenEsp.Position - Vector2.new(0, 25); floorEsp.Size = 25; floorEsp.Visible = true; floorEsp.Color = Color3.new(1, 1, 1); floorEsp.Center = false; floorEsp.Outline = true; floorEsp.OutlineColor = Color3.new(0,0,0); floorEsp.Font = 0
    game:GetService("RunService").Heartbeat:Connect(function()
        powerEsp.Text = "Power: " .. tostring(math.floor(game:GetService("ReplicatedStorage").Settings.CurrentPower.Value / game:GetService("ReplicatedStorage").Settings.MaxPower.Value * 100)) .. "% (" .. tostring(game:GetService("ReplicatedStorage").Settings.CurrentPower.Value) .. "/" .. tostring(game:GetService("ReplicatedStorage").Settings.MaxPower.Value) .. ")"
        oxygenEsp.Text = "Oxygen: " .. tostring(math.floor(game:GetService("ReplicatedStorage").Settings.CurrentOxygen.Value / game:GetService("ReplicatedStorage").Settings.MaxOxygen.Value * 100)) .. "% (" .. tostring(game:GetService("ReplicatedStorage").Settings.CurrentOxygen.Value) .. "/" .. tostring(game:GetService("ReplicatedStorage").Settings.MaxOxygen.Value) .. ")"
        floorEsp.Text = "Floor: " .. tostring(game:GetService("ReplicatedStorage").Settings.CurrentFloor.Value)
    end)
end
coroutine.wrap(displayInfo)()

-- Draw lines from the elevator to all buttons.
-- Note: Sometimes it won't draw a line to all buttons! Blame roblox pathfinding.
for _, button in pairs(game:GetService("Workspace").Tasks:GetChildren()) do
	if button.Button.Color == game:GetService("ReplicatedStorage").Settings.ButtonOffColor.Value then continue end
    local PathfindingService = game:GetService("PathfindingService")
	local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 1})
	path:ComputeAsync(game:GetService("Workspace").MapTable.PrimaryPart.Position + Vector3.new(0, 0, -15), button.Button.Position)
    local waypoints = path:GetWaypoints()
    local lastPart = nil
	for _, waypoint in ipairs(waypoints) do
		local currentPart = Instance.new("Part"); currentPart.Shape = "Ball"; currentPart.Material = "Neon"; currentPart.Size = Vector3.new(0.5, 0.5, 0.5); currentPart.Position = waypoint.Position + Vector3.new(0, 1, 0); currentPart.Anchored = true; currentPart.CanCollide = false; currentPart.Parent = game.Workspace
        if lastPart ~= nil then
            local attachment0 = Instance.new("Attachment"); attachment0.Parent = lastPart
            local attachment1 = Instance.new("Attachment"); attachment1.Parent = currentPart
            local beam = Instance.new("Beam"); beam.Parent = attachment0; beam.Attachment0 = attachment0; beam.Attachment1 = attachment1; beam.Width0 = 0.5; beam.Width1 = 0.5; beam.FaceCamera = true; beam.Enabled = true
        end
        lastPart = currentPart
		local ColorChanged
        local ChildRemoved
		ColorChanged = button.Button:GetPropertyChangedSignal("Color"):Connect(function()
			if button.Button.Color == game:GetService("ReplicatedStorage").Settings.ButtonOffColor.Value then
				currentPart:Destroy()
				ColorChanged:Disconnect()
			end
		end)
        ChildRemoved = game:GetService("Workspace").Tasks.ChildRemoved:Connect(function(child)
            if child == button then
                currentPart:Destroy()
                ChildRemoved:Disconnect()
                ColorChanged:Disconnect()
            end
        end)
	end
end
game:GetService("Workspace").Tasks.ChildAdded:Connect(function(button)
    wait(15)
    local PathfindingService = game:GetService("PathfindingService")
	local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 1})
	path:ComputeAsync(game:GetService("Workspace").MapTable.PrimaryPart.Position + Vector3.new(0, 0, -15), button.Button.Position)
    local waypoints = path:GetWaypoints()
    local lastPart = nil
	for _, waypoint in ipairs(waypoints) do
		local currentPart = Instance.new("Part"); currentPart.Shape = "Ball"; currentPart.Material = "Neon"; currentPart.Size = Vector3.new(0.5, 0.5, 0.5); currentPart.Position = waypoint.Position + Vector3.new(0, 1, 0); currentPart.Anchored = true; currentPart.CanCollide = false; currentPart.Parent = game.Workspace
        if lastPart ~= nil then
            local attachment0 = Instance.new("Attachment"); attachment0.Parent = lastPart
            local attachment1 = Instance.new("Attachment"); attachment1.Parent = currentPart
            local beam = Instance.new("Beam"); beam.Parent = attachment0; beam.Attachment0 = attachment0; beam.Attachment1 = attachment1; beam.Width0 = 0.5; beam.Width1 = 0.5; beam.FaceCamera = true; beam.Enabled = true
        end
        lastPart = currentPart
		local ColorChanged
        local ChildRemoved
		ColorChanged = button.Button:GetPropertyChangedSignal("Color"):Connect(function()
			if button.Button.Color == game:GetService("ReplicatedStorage").Settings.ButtonOffColor.Value then
				currentPart:Destroy()
				ColorChanged:Disconnect()
			end
		end)
        ChildRemoved = game:GetService("Workspace").Tasks.ChildRemoved:Connect(function(child)
            if child == button then
                currentPart:Destroy()
                ChildRemoved:Disconnect()
                ColorChanged:Disconnect()
            end
        end)
	end
end)

-- Button esp for when the pathfinder doesn't work lol.
for _,button in pairs(game:GetService("Workspace").Tasks:GetChildren()) do
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Text = "[]"; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function buttonEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if button.Button.Color == game:GetService("ReplicatedStorage").Settings.ButtonOffColor.Value then esp.Visible = false return end
            if button:WaitForChild("Button") ~= nil then
                local buttonPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(button.Button.Position)
                if onScreen then
                    esp.Position = Vector2.new(buttonPos.X, buttonPos.Y)
                    esp.Size = 1000 / buttonPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
            esp.Color = button.Button.Color
        end)
        local ChildRemoved
        ChildRemoved = game:GetService("Workspace").Tasks.ChildRemoved:Connect(function(child)
            if child == button then
                esp:Remove()
                RenderStepped:Disconnect()
                ChildRemoved:Disconnect()
            end
        end)
    end
    coroutine.wrap(buttonEsp)()
end
game:GetService("Workspace").Tasks.ChildAdded:Connect(function(button)
    wait(1)
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Text = "[]"; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function buttonEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if button.Button.Color == game:GetService("ReplicatedStorage").Settings.ButtonOffColor.Value then esp.Visible = false return end
            if button:WaitForChild("Button") ~= nil then
                local buttonPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(button.Button.Position)
                if onScreen then
                    esp.Position = Vector2.new(buttonPos.X, buttonPos.Y)
                    esp.Size = 1000 / buttonPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
            esp.Color = button.Button.Color
        end)
        local ChildRemoved
        ChildRemoved = game:GetService("Workspace").Tasks.ChildRemoved:Connect(function(child)
            if child == button then
                esp:Remove()
                RenderStepped:Disconnect()
                ChildRemoved:Disconnect()
            end
        end)
    end
    coroutine.wrap(buttonEsp)()
end)

-- Elevator esp so you can find your way back when all buttons are pressed.
function tableEsp()
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Color = Color3.new(1, 1, 1); esp.Text = "Elevator"; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        local tablePos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(game:GetService("Workspace").MapTable.PrimaryPart.Position + Vector3.new(0, 15, 0))
        if onScreen then
            esp.Position = Vector2.new(tablePos.X, tablePos.Y)
            esp.Size = 1000 / tablePos.Z + 10
            esp.Visible = true
        else
            esp.Visible = false
        end
    end)
end
coroutine.wrap(tableEsp)()

-- Entity Esp (pretty self explanatory).
for _,enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Color = Color3.new(1,0,0); esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    if enemy.Name ~= "DeathOrb" then
        esp.Text = tostring(enemy.MonsterName.Value)
    else
        esp.Text = tostring(enemy.Name)
    end
    function monsterEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if enemy:FindFirstChild("HumanoidRootPart") ~= nil then
                local monsterPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(enemy.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(monsterPos.X, monsterPos.Y)
                    esp.Size = 1000 / monsterPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
        end)
        local ChildRemoved
        ChildRemoved = game:GetService("Workspace").Enemies.ChildRemoved:Connect(function(child)
            if child == enemy then
                esp:Remove()
                RenderStepped:Disconnect()
                ChildRemoved:Disconnect()
            end
        end)
    end
    coroutine.wrap(monsterEsp)()
end
game:GetService("Workspace").Enemies.ChildAdded:Connect(function(enemy)
    wait(1)
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Color = Color3.new(1,0,0); esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    if enemy.Name ~= "DeathOrb" then
        esp.Text = tostring(enemy.MonsterName.Value)
    else
        esp.Text = tostring(enemy.Name)
    end
    function monsterEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if enemy:FindFirstChild("HumanoidRootPart") ~= nil then
                local monsterPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(enemy.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(monsterPos.X, monsterPos.Y)
                    esp.Size = 1000 / monsterPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
        end)
        local ChildRemoved
        ChildRemoved = game:GetService("Workspace").Enemies.ChildRemoved:Connect(function(child)
            if child == enemy then
                esp:Remove()
                RenderStepped:Disconnect()
                ChildRemoved:Disconnect()
            end
        end)
    end
    coroutine.wrap(monsterEsp)()
end)

-- Player Esp (pretty self explanatory).
for _,player in pairs(game:GetService("Players"):GetPlayers()) do
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Color = Color3.new(0,1,0); esp.Text = "+"--[[tostring(player.Name)]]; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function playerEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if player == game:GetService("Players").LocalPlayer then esp:Remove(); RenderStepped:Disconnect() return end
            if player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                local playerPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(playerPos.X, playerPos.Y)
                    esp.Size = 1000 / playerPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
        end)
    end
    coroutine.wrap(playerEsp)()
end
game:GetService("Players").PlayerAdded:Connect(function(player)
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Color = Color3.new(0,1,0); esp.Text = "+"--[[tostring(player.Name)]]; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function playerEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if player == game:GetService("Players").LocalPlayer then esp:Remove(); RenderStepped:Disconnect() return end
            if player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                local playerPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(playerPos.X, playerPos.Y)
                    esp.Size = 1000 / playerPos.Z + 10
                    esp.Visible = true
                else
                    esp.Visible = false
                end
            else
                esp.Visible = false
            end
        end)
    end
    coroutine.wrap(playerEsp)()
end)
