for _,player in pairs(game:GetService("Players"):GetPlayers()) do
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function playerEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if player == game:GetService("Players").LocalPlayer then esp:Remove(); RenderStepped:Disconnect() return end
            if tostring(player.Team) == "LOBBY" then esp.Visible = false return end
            if player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                esp.Color = player.TeamColor.Color
                esp.Text = tostring(player.Team) .. "\n" .. tostring(math.ceil(player.Character.Humanoid.Health))
                local playerPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(playerPos.X, playerPos.Y)
                    esp.Size = 1000 / playerPos.Z
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
    local esp = Drawing.new("Text"); esp.Visible = false; esp.Center = true; esp.Outline = true; esp.OutlineColor = Color3.new(0,0,0); esp.Font = 0
    function playerEsp()
        local RenderStepped
        RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
            if player == game:GetService("Players").LocalPlayer then esp:Remove(); RenderStepped:Disconnect() return end
            if tostring(player.Team) == "LOBBY" then esp.Visible = false return end
            if player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                esp.Color = player.TeamColor.Color
                esp.Text = tostring(player.Team) .. "\n" .. tostring(math.ceil(player.Character.Humanoid.Health))
                local playerPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    esp.Position = Vector2.new(playerPos.X, playerPos.Y)
                    esp.Size = 1000 / playerPos.Z
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
