-- r6 skeleton esp that isn't a starfish?? wtf??
-- if you're reading this please improve my code

local skeletonColor = Color3.fromRGB(255, 0, 0)
local drawOnLocalPlayer = true
local deadCheck = true -- Disabling will make the esp funky when people die on games without ragdolls.
local skeletonThickness = 1 -- How thick the bones are. Mega aids at high values.
local torsoHeight = 3.5 -- (minimum 2) 3.5 aligns with mortem metallum's arm bones when you get blown up. Higher value means shorter torso.
local endPos = 2 -- (minimum 2) Where the character's arm/leg bone ends. Higher value means shorter bone.

function r6skeletonEsp(player)
    local headLine = Drawing.new("Line"); headLine.Color = skeletonColor
    local headConnector = Drawing.new("Line"); headConnector.Color = skeletonColor

    local torsoLine = Drawing.new("Line"); torsoLine.Color = skeletonColor
    local shouldersLine = Drawing.new("Line"); shouldersLine.Color = skeletonColor
    local pelvisLine = Drawing.new("Line"); pelvisLine.Color = skeletonColor

    local rightArmLine = Drawing.new("Line"); rightArmLine.Color = skeletonColor
    local rightArmConnector = Drawing.new("Line"); rightArmConnector.Color = skeletonColor

    local leftArmLine = Drawing.new("Line"); leftArmLine.Color = skeletonColor
    local leftArmConnector = Drawing.new("Line"); leftArmConnector.Color = skeletonColor

    local rightLegLine = Drawing.new("Line"); rightLegLine.Color = skeletonColor
    local rightLegConnector = Drawing.new("Line"); rightLegConnector.Color = skeletonColor
    
    local leftLegLine = Drawing.new("Line"); leftLegLine.Color = skeletonColor
    local leftLegConnector = Drawing.new("Line"); leftLegConnector.Color = skeletonColor

    local function drawSkeleton()
        local RenderStepped1
        RenderStepped1 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Head") then headLine.Visible = false; headConnector.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then headLine.Visible = false; headConnector.Visible = false return end
            local p = w:WaitForChild("Head")
            local t = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / 3, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / 3), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            local neckEsp = t.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / torsoHeight, 0))
            local neckPos, neckOnScreen = workspace.CurrentCamera:WorldToViewportPoint(neckEsp.Position)
            if topOnScreen and bottomOnScreen then
                headLine.Thickness = skeletonThickness / topPos.Z
                headLine.From = Vector2.new(topPos.X, topPos.Y)
                headLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                headLine.Visible = true
            else
                headLine.Visible = false
            end
            if bottomOnScreen and neckOnScreen then
                headConnector.Thickness = skeletonThickness / bottomPos.Z
                headConnector.From = Vector2.new(bottomPos.X, bottomPos.Y)
                headConnector.To = Vector2.new(neckPos.X, neckPos.Y)
                headConnector.Visible = true
            else
                headConnector.Visible = false
            end
        end)
        local RenderStepped2
        RenderStepped2 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Torso") then torsoLine.Visible = false; shouldersLine.Visible = false; pelvisLine.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then torsoLine.Visible = false; shouldersLine.Visible = false; pelvisLine.Visible = false return end
            local p = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / torsoHeight, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / 2), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            
            local leftShoulderEsp = p.CFrame:ToWorldSpace(CFrame.new(-(p.Size.X / 2), p.Size.Y / torsoHeight, 0))
            local leftShoulderPos, leftShoulderOnScreen = workspace.CurrentCamera:WorldToViewportPoint(leftShoulderEsp.Position)
            local rightShoulderEsp = p.CFrame:ToWorldSpace(CFrame.new(p.Size.X / 2, p.Size.Y / torsoHeight, 0))
            local rightShoulderPos, rightShoulderOnScreen = workspace.CurrentCamera:WorldToViewportPoint(rightShoulderEsp.Position)
            local leftPelvisEsp = p.CFrame:ToWorldSpace(CFrame.new(-(p.Size.X / 4), -(p.Size.Y / 2), 0))
            local leftPelvisPos, leftPelvisOnScreen = workspace.CurrentCamera:WorldToViewportPoint(leftPelvisEsp.Position)
            local rightPelvisEsp = p.CFrame:ToWorldSpace(CFrame.new(p.Size.X / 4, -(p.Size.Y / 2), 0))
            local rightPelvisPos, rightPelvisOnScreen = workspace.CurrentCamera:WorldToViewportPoint(rightPelvisEsp.Position)
            if topOnScreen and bottomOnScreen then
                torsoLine.Thickness = skeletonThickness / topPos.Z
                torsoLine.From = Vector2.new(topPos.X, topPos.Y)
                torsoLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                torsoLine.Visible = true
            else
                torsoLine.Visible = false
            end
    	    if leftShoulderOnScreen and rightShoulderOnScreen then
    	    	shouldersLine.Thickness = skeletonThickness / leftShoulderPos.Z
    	    	shouldersLine.From = Vector2.new(leftShoulderPos.X, leftShoulderPos.Y)
    	    	shouldersLine.To = Vector2.new(rightShoulderPos.X, rightShoulderPos.Y)
    	    	shouldersLine.Visible = true
    	    else
    	    	shouldersLine.Visible = false
    	    end
    	    if leftPelvisOnScreen and rightPelvisOnScreen then
    	    	pelvisLine.Thickness = skeletonThickness / leftPelvisPos.Z
    	    	pelvisLine.From = Vector2.new(leftPelvisPos.X, leftPelvisPos.Y)
    	    	pelvisLine.To = Vector2.new(rightPelvisPos.X, rightPelvisPos.Y)
    	    	pelvisLine.Visible = true
    	    else
    	    	pelvisLine.Visible = false
    	    end
        end)
        local RenderStepped3
        RenderStepped3 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Right Arm") then rightArmLine.Visible = false; rightArmConnector.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then rightArmLine.Visible = false; rightArmConnector.Visible = false return end
            local p = w:WaitForChild("Right Arm")
            local t = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / torsoHeight, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / endPos), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            
    	    local rightShoulderEsp = t.CFrame:ToWorldSpace(CFrame.new(p.Size.X / 1, p.Size.Y / torsoHeight, 0))
    	    local rightShoulderPos, rightShoulderOnScreen = workspace.CurrentCamera:WorldToViewportPoint(rightShoulderEsp.Position)
            
            if topOnScreen and bottomOnScreen then
                rightArmLine.Thickness = skeletonThickness / topPos.Z
                rightArmLine.From = Vector2.new(topPos.X, topPos.Y)
                rightArmLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                rightArmLine.Visible = true
            else
                rightArmLine.Visible = false
            end
            if topOnScreen and rightShoulderOnScreen then
    	    	rightArmConnector.Thickness = skeletonThickness / topPos.Z
    	    	rightArmConnector.From = Vector2.new(rightShoulderPos.X, rightShoulderPos.Y)
    	    	rightArmConnector.To = Vector2.new(topPos.X, topPos.Y)
    	    	rightArmConnector.Visible = true
    	    else
    	    	rightArmConnector.Visible = false
    	    end
        end)
        local RenderStepped4
        RenderStepped4 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Left Arm") then leftArmLine.Visible = false; leftArmConnector.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then leftArmLine.Visible = false; leftArmConnector.Visible = false return end
            local p = w:WaitForChild("Left Arm")
            local t = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / torsoHeight, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / endPos), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            
            local leftShoulderEsp = t.CFrame:ToWorldSpace(CFrame.new(-(p.Size.X / 1), p.Size.Y / torsoHeight, 0))
            local leftShoulderPos, leftShoulderOnScreen = workspace.CurrentCamera:WorldToViewportPoint(leftShoulderEsp.Position)
            if topOnScreen and bottomOnScreen then
                leftArmLine.Thickness = skeletonThickness / topPos.Z
                leftArmLine.From = Vector2.new(topPos.X, topPos.Y)
                leftArmLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                leftArmLine.Visible = true
            else
                leftArmLine.Visible = false
            end
            if topOnScreen and leftShoulderOnScreen then
                leftArmConnector.Thickness = skeletonThickness / topPos.Z
                leftArmConnector.From = Vector2.new(leftShoulderPos.X, leftShoulderPos.Y)
                leftArmConnector.To = Vector2.new(topPos.X, topPos.Y)
                leftArmConnector.Visible = true
            else
                leftArmConnector.Visible = false
            end
        end)
        local RenderStepped5
        RenderStepped5 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Right Leg") then rightLegLine.Visible = false; rightLegConnector.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then rightLegLine.Visible = false; rightLegConnector.Visible = false return end
            local p = w:WaitForChild("Right Leg")
            local t = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / 2.5, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / endPos), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            
            local rightPelvisEsp = t.CFrame:ToWorldSpace(CFrame.new(p.Size.X / 2, -(p.Size.Y / 2), 0))
            local rightPelvisPos, rightPelvisOnScreen = workspace.CurrentCamera:WorldToViewportPoint(rightPelvisEsp.Position)
            if topOnScreen and bottomOnScreen then
                rightLegLine.Thickness = skeletonThickness / topPos.Z
                rightLegLine.From = Vector2.new(topPos.X, topPos.Y)
                rightLegLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                rightLegLine.Visible = true
            else
                rightLegLine.Visible = false
            end
            if topOnScreen and rightPelvisOnScreen then
                rightLegConnector.Thickness = skeletonThickness / topPos.Z
                rightLegConnector.From = Vector2.new(rightPelvisPos.X, rightPelvisPos.Y)
                rightLegConnector.To = Vector2.new(topPos.X, topPos.Y)
                rightLegConnector.Visible = true
            else
                rightLegConnector.Visible = false
            end
        end)
        local RenderStepped6
        RenderStepped6 = game:GetService("RunService").RenderStepped:Connect(function()
            local w = player.Character or player.CharacterAdded:Wait()
            if not w:FindFirstChild("Left Leg") then leftLegLine.Visible = false; leftLegConnector.Visible = false return end
            local h = w:WaitForChild("Humanoid")
            if h:GetState() == Enum.HumanoidStateType.Dead and deadCheck then leftLegLine.Visible = false; leftLegConnector.Visible = false return end
            local p = w:WaitForChild("Left Leg")
            local t = w:WaitForChild("Torso")
            local topEsp = p.CFrame:ToWorldSpace(CFrame.new(0, p.Size.Y / 2.5, 0))
            local topPos, topOnScreen = workspace.CurrentCamera:WorldToViewportPoint(topEsp.Position)
            local bottomEsp = p.CFrame:ToWorldSpace(CFrame.new(0, -(p.Size.Y / endPos), 0))
            local bottomPos, bottomOnScreen = workspace.CurrentCamera:WorldToViewportPoint(bottomEsp.Position)
            
            local leftPelvisEsp = t.CFrame:ToWorldSpace(CFrame.new(-(p.Size.X / 2), -(p.Size.Y / 2), 0))
            local leftPelvisPos, leftPelvisOnScreen = workspace.CurrentCamera:WorldToViewportPoint(leftPelvisEsp.Position)
            if topOnScreen and bottomOnScreen then
                leftLegLine.Thickness = skeletonThickness / topPos.Z
                leftLegLine.From = Vector2.new(topPos.X, topPos.Y)
                leftLegLine.To = Vector2.new(bottomPos.X, bottomPos.Y)
                leftLegLine.Visible = true
            else
                leftLegLine.Visible = false
            end
            if topOnScreen and leftPelvisOnScreen then
                leftLegConnector.Thickness = skeletonThickness / topPos.Z
                leftLegConnector.From = Vector2.new(leftPelvisPos.X, leftPelvisPos.Y)
                leftLegConnector.To = Vector2.new(topPos.X, topPos.Y)
                leftLegConnector.Visible = true
            else
                leftLegConnector.Visible = false
            end
        end)
        game:GetService("Players").PlayerRemoving:Connect(function(playerRemoving)
            if playerRemoving == player then
                RenderStepped1:Disconnect()
                RenderStepped2:Disconnect()
                RenderStepped3:Disconnect()
                RenderStepped4:Disconnect()
                RenderStepped5:Disconnect()
                RenderStepped6:Disconnect()

                headLine:Remove()
                headConnector:Remove()
                torsoLine:Remove()
                shouldersLine:Remove()
                pelvisLine:Remove()
                rightArmLine:Remove()
                rightArmConnector:Remove()
                leftArmLine:Remove()
                leftArmConnector:Remove()
                rightLegLine:Remove()
                rightLegConnector:Remove()
                leftLegLine:Remove()
                leftLegConnector:Remove()
            end
        end)
    end
    coroutine.wrap(drawSkeleton)()
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if not drawOnLocalPlayer and player == game:GetService("Players").LocalPlayer then continue end
    local w = player.Character or player.CharacterAdded:Wait()
    local h = w:WaitForChild("Humanoid")
    if h.RigType == Enum.HumanoidRigType.R6 then
        r6skeletonEsp(player)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    local w = player.Character or player.CharacterAdded:Wait()
    local h = w:WaitForChild("Humanoid")
    if h.RigType == Enum.HumanoidRigType.R6 then
        r6skeletonEsp(player)
    end
end)
