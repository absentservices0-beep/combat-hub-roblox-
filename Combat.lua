-- 🔥 COMBAT EXCLUSIVE - MAXED OUT COMBAT SYSTEM 🔥
-- Fixed ESP Accuracy | Fast Aimbot | Silent Aim | Bone ESP | Full Customization

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- Wait for character
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Detect mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- =====================================================
-- CONFIGURATION (MAXED OUT)
-- =====================================================
local CONFIG = {
    -- Aimbot Settings
    AimbotEnabled = false,
    SilentAimEnabled = false,
    AimAssistEnabled = false,
    AimbotMode = "Camera", -- Camera, Mouse, Silent
    AimbotFOV = 200,
    AimbotSmoothness = 0.05, -- Lower = faster (0.01-1.0)
    AimbotSpeed = 10, -- Higher = faster (1-20)
    VisibleCheck = false,
    TeamCheck = true,
    WallCheck = false,
    AimPart = "Head",
    PredictMovement = true,
    PredictionStrength = 0.15,
    AutoShoot = false,
    TriggerBot = false,
    Hitchance = 100, -- Percent chance to hit
    TargetLock = false, -- Lock onto one target
    StickyAim = false, -- Stick to target even if mouse moves
    ShakeReduction = true,
    
    -- Silent Aim Settings
    SilentAimFOV = 300,
    SilentAimHitchance = 100,
    SilentAimPrediction = true,
    
    -- ESP Settings
    ESPEnabled = false,
    ESPBoxes = true,
    ESPBoxFilled = false,
    ESPBoxRainbow = false,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPHealthBar = true,
    ESPTracers = true,
    ESPTracerOrigin = "Bottom", -- Bottom, Middle, Mouse
    ESPSkeleton = true,
    ESPHeadDot = true,
    ESPLookDirection = true,
    ESPWeapon = true,
    ESPTeamCheck = false,
    ESPWallCheck = false,
    ESPMaxDistance = 1000,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTeamColor = true,
    ESPFadeDistance = true,
    
    -- Bone ESP
    BoneESPEnabled = true,
    BoneThickness = 2,
    BoneColor = Color3.fromRGB(255, 255, 255),
    
    -- Movement
    SpeedEnabled = false,
    SpeedValue = 100,
    JumpEnabled = false,
    JumpPower = 120,
    FlyEnabled = false,
    FlySpeed = 100,
    NoclipEnabled = false,
    
    -- Universal
    FlingEnabled = false,
    FlingPower = 5000,
    LagSwitchEnabled = false,
    AntiAFK = true,
    
    -- FOV Circle
    ShowFOV = true,
    FOVFilled = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    
    -- Commands
    CommandPrefix = "."
}

-- Connection storage
local connections = {}
local espObjects = {}
local boneConnections = {}
local currentTarget = nil
local lockedTarget = nil

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
local function cleanupConnections()
    for i, conn in pairs(connections) do
        if conn then 
            pcall(function() conn:Disconnect() end)
            connections[i] = nil
        end
    end
end

local function cleanupESP()
    for playerName, espData in pairs(espObjects) do
        if espData then
            for _, obj in pairs(espData) do
                if obj and obj.Remove then
                    pcall(function() obj:Remove() end)
                end
            end
        end
    end
    espObjects = {}
    
    for _, conn in pairs(boneConnections) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
    end
    boneConnections = {}
end

local function notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Combat Exclusive";
        Text = message;
        Duration = 3;
    })
end

-- =====================================================
-- AIMBOT SYSTEM (MAXED OUT)
-- =====================================================

-- Bone priority list for better targeting
local bonePriority = {
    "Head",
    "UpperTorso", 
    "HumanoidRootPart",
    "LowerTorso"
}

local function getTargetBone(character)
    for _, boneName in ipairs(bonePriority) do
        local bone = character:FindFirstChild(boneName)
        if bone then
            return bone
        end
    end
    return character:FindFirstChild(CONFIG.AimPart) or character:FindFirstChild("HumanoidRootPart")
end

local function isVisible(targetPart)
    if not CONFIG.VisibleCheck and not CONFIG.WallCheck then return true end
    
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    
    local ray = Ray.new(origin, direction)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
    
    if hit then
        return hit:IsDescendantOf(targetPart.Parent)
    end
    
    return true
end

local function predictPosition(targetPart)
    if not CONFIG.PredictMovement then
        return targetPart.Position
    end
    
    local velocity = targetPart.Velocity
    local prediction = targetPart.Position + (velocity * CONFIG.PredictionStrength)
    return prediction
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local bestScreenPos = nil
    
    -- If target lock is enabled and we have a locked target
    if CONFIG.TargetLock and lockedTarget and lockedTarget.Character then
        local character = lockedTarget.Character
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid and humanoid.Health > 0 then
            return lockedTarget
        else
            lockedTarget = nil
        end
    end
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local aimPart = getTargetBone(character)
            
            if humanoid and humanoid.Health > 0 and rootPart and aimPart then
                -- Team check (properly handle nil teams)
                if CONFIG.TeamCheck then
                    if targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then
                        continue
                    end
                end
                
                -- Visibility/Wall check
                if (CONFIG.VisibleCheck or CONFIG.WallCheck) and not isVisible(aimPart) then
                    continue
                end
                
                -- Distance check
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if isMobile then
                    -- For mobile, prioritize closest player
                    if distance < shortestDistance then
                        closestPlayer = targetPlayer
                        shortestDistance = distance
                        bestScreenPos = camera:WorldToViewportPoint(aimPart.Position)
                    end
                else
                    -- For PC, prioritize cursor distance with FOV
                    local screenPoint, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                    if onScreen and screenPoint.Z > 0 then
                        local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                        
                        local fovLimit = CONFIG.AimbotMode == "Silent" and CONFIG.SilentAimFOV or CONFIG.AimbotFOV
                        
                        if mouseDistance < fovLimit and mouseDistance < shortestDistance then
                            closestPlayer = targetPlayer
                            shortestDistance = mouseDistance
                            bestScreenPos = screenPoint
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Camera Aimbot
local aimbotConnection = nil

local function startCameraAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimbotEnabled or CONFIG.AimbotMode ~= "Camera" then return end
        
        local target = getClosestPlayer()
        
        if target and target.Character then
            currentTarget = target
            
            if CONFIG.TargetLock then
                lockedTarget = target
            end
            
            local aimPart = getTargetBone(target.Character)
            if aimPart then
                -- Predict position
                local targetPos = predictPosition(aimPart)
                
                -- Check hitchance
                if math.random(1, 100) > CONFIG.Hitchance then
                    return
                end
                
                local cameraPos = camera.CFrame.Position
                local aimDirection = (targetPos - cameraPos).Unit
                
                -- Calculate smoothness (inverted for speed)
                local smoothFactor = CONFIG.AimbotSmoothness
                
                if CONFIG.StickyAim then
                    smoothFactor = smoothFactor * 0.5 -- Extra sticky
                end
                
                -- Smooth aim with speed multiplier
                local currentLook = camera.CFrame.LookVector
                local smoothedDirection = currentLook:Lerp(aimDirection, smoothFactor * CONFIG.AimbotSpeed)
                
                -- Shake reduction
                if CONFIG.ShakeReduction then
                    camera.CFrame = CFrame.new(cameraPos, cameraPos + smoothedDirection)
                else
                    local newCFrame = CFrame.new(cameraPos, cameraPos + aimDirection)
                    camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothFactor)
                end
            end
        else
            currentTarget = nil
            if not CONFIG.TargetLock then
                lockedTarget = nil
            end
        end
    end)
    
    table.insert(connections, aimbotConnection)
end

-- Silent Aim (Hooks into game shooting mechanics)
local silentAimConnection = nil
local oldNamecall

local function startSilentAim()
    if silentAimConnection then return end
    
    -- Hook namecall for silent aim
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if CONFIG.SilentAimEnabled and (method == "FireServer" or method == "InvokeServer") then
            -- Check if this is a shooting remote
            if tostring(self):lower():find("shoot") or tostring(self):lower():find("fire") or tostring(self):lower():find("damage") then
                local target = getClosestPlayer()
                
                if target and target.Character then
                    local aimPart = getTargetBone(target.Character)
                    
                    if aimPart and math.random(1, 100) <= CONFIG.SilentAimHitchance then
                        local targetPos = predictPosition(aimPart)
                        
                        -- Replace position argument
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "Vector3" then
                                args[i] = targetPos
                            elseif typeof(arg) == "CFrame" then
                                args[i] = CFrame.new(targetPos)
                            end
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    notify("Silent Aim Enabled")
end

local function stopSilentAim()
    if oldNamecall then
        hookmetamethod(game, "__namecall", oldNamecall)
        oldNamecall = nil
    end
    notify("Silent Aim Disabled")
end

-- Aim Assist (Subtle magnetic effect)
local aimAssistConnection = nil

local function startAimAssist()
    if aimAssistConnection then return end
    
    aimAssistConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimAssistEnabled then return end
        
        local target = getClosestPlayer()
        
        if target and target.Character then
            local aimPart = getTargetBone(target.Character)
            if aimPart then
                local screenPoint, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                
                if onScreen and screenPoint.Z > 0 then
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (targetPos - mousePos).Magnitude
                    
                    -- Subtle pull towards target
                    if distance < CONFIG.AimbotFOV then
                        local pullStrength = 0.02 -- Very subtle
                        local direction = (targetPos - mousePos).Unit
                        
                        -- Move mouse slightly towards target
                        mousemoverel(direction.X * pullStrength, direction.Y * pullStrength)
                    end
                end
            end
        end
    end)
    
    table.insert(connections, aimAssistConnection)
end

local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if aimAssistConnection then
        aimAssistConnection:Disconnect()
        aimAssistConnection = nil
    end
    currentTarget = nil
    lockedTarget = nil
    notify("Aimbot Disabled")
end

-- FOV Circle
local fovCircle = nil
local silentFovCircle = nil

local function createFOVCircles()
    -- Regular FOV
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = CONFIG.ShowFOV
    fovCircle.Thickness = 2
    fovCircle.Color = CONFIG.FOVColor
    fovCircle.Transparency = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = CONFIG.AimbotFOV
    fovCircle.Filled = CONFIG.FOVFilled
    
    -- Silent Aim FOV
    silentFovCircle = Drawing.new("Circle")
    silentFovCircle.Visible = false
    silentFovCircle.Thickness = 2
    silentFovCircle.Color = Color3.fromRGB(0, 255, 0)
    silentFovCircle.Transparency = 0.5
    silentFovCircle.NumSides = 64
    silentFovCircle.Radius = CONFIG.SilentAimFOV
    silentFovCircle.Filled = false
    
    RunService.RenderStepped:Connect(function()
        local mousePos = Vector2.new(mouse.X, mouse.Y + 36)
        
        if fovCircle then
            fovCircle.Position = mousePos
            fovCircle.Radius = CONFIG.AimbotFOV
            fovCircle.Visible = CONFIG.ShowFOV and CONFIG.AimbotEnabled and not isMobile
            fovCircle.Color = CONFIG.FOVColor
            fovCircle.Filled = CONFIG.FOVFilled
        end
        
        if silentFovCircle then
            silentFovCircle.Position = mousePos
            silentFovCircle.Radius = CONFIG.SilentAimFOV
            silentFovCircle.Visible = CONFIG.SilentAimEnabled and not isMobile
        end
    end)
end

createFOVCircles()

-- =====================================================
-- ESP SYSTEM (MAXED OUT - ACCURATE)
-- =====================================================

-- Bone connections for skeleton ESP
local boneConnections_list = {
    -- Head to Torso
    {"Head", "UpperTorso"},
    
    -- Torso
    {"UpperTorso", "LowerTorso"},
    
    -- Left Arm
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    
    -- Right Arm
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    
    -- Left Leg
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    
    -- Right Leg
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

local function getTeamColor(targetPlayer)
    if targetPlayer.Team then
        return targetPlayer.Team.TeamColor.Color
    end
    return CONFIG.ESPColor
end

local function createESP(targetPlayer)
    if espObjects[targetPlayer.Name] then return end
    
    espObjects[targetPlayer.Name] = {}
    
    local function updateESP()
        -- Clean old ESP
        if espObjects[targetPlayer.Name] then
            for _, obj in pairs(espObjects[targetPlayer.Name]) do
                if obj and obj.Remove then
                    pcall(function() obj:Remove() end)
                end
            end
        end
        espObjects[targetPlayer.Name] = {}
        
        if not targetPlayer.Character or not CONFIG.ESPEnabled then return end
        if not targetPlayer:IsDescendantOf(Players) then return end
        
        local character = targetPlayer.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if not rootPart or not humanoid or humanoid.Health <= 0 then return end
        
        -- Team check (properly handle nil teams)
        if CONFIG.ESPTeamCheck then
            if targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then 
                return 
            end
        end
        
        -- Wall check
        if CONFIG.ESPWallCheck and not isVisible(rootPart) then return end
        
        -- Distance check
        local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
        if distance > CONFIG.ESPMaxDistance then return end
        
        -- Check if on screen
        local rootPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen or rootPos.Z < 0 then return end
        
        -- Calculate fade based on distance
        local transparency = 1
        if CONFIG.ESPFadeDistance then
            local fadeStart = CONFIG.ESPMaxDistance * 0.7
            if distance > fadeStart then
                transparency = 1 - ((distance - fadeStart) / (CONFIG.ESPMaxDistance - fadeStart))
            end
        end
        
        -- Get color
        local espColor = CONFIG.ESPTeamColor and getTeamColor(targetPlayer) or CONFIG.ESPColor
        
        -- Box ESP (TRULY FIXED - Proper Y-axis)
        if CONFIG.ESPBoxes then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Color = espColor
            box.Thickness = 2
            box.Transparency = transparency
            box.Filled = CONFIG.ESPBoxFilled
            
            -- Get character size for proper scaling
            local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
            if not torso then
                box.Visible = false
                table.insert(espObjects[targetPlayer.Name], box)
                return
            end
            
            -- Calculate proper head and feet positions
            local headY = head and head.Position.Y + (head.Size.Y / 2) or rootPart.Position.Y + 2
            local feetY = rootPart.Position.Y - 3 -- Proper feet position
            
            -- Get screen positions for head (top) and feet (bottom)
            local topPos = camera:WorldToViewportPoint(Vector3.new(rootPart.Position.X, headY, rootPart.Position.Z))
            local bottomPos = camera:WorldToViewportPoint(Vector3.new(rootPart.Position.X, feetY, rootPart.Position.Z))
            
            -- Get width based on torso
            local leftPos = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-2.5, 0, 0)).Position)
            local rightPos = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(2.5, 0, 0)).Position)
            
            if topPos.Z > 0 and bottomPos.Z > 0 then
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = math.abs(rightPos.X - leftPos.X)
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(topPos.X - width/2, topPos.Y) -- Start from top
            else
                box.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], box)
        end
        
        -- Health Bar (FIXED - Aligned with box)
        if CONFIG.ESPHealthBar then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            
            -- Get proper head and feet positions for bar
            local headY = head and head.Position.Y + (head.Size.Y / 2) or rootPart.Position.Y + 2
            local feetY = rootPart.Position.Y - 3
            
            local topPos = camera:WorldToViewportPoint(Vector3.new(rootPart.Position.X, headY, rootPart.Position.Z))
            local bottomPos = camera:WorldToViewportPoint(Vector3.new(rootPart.Position.X, feetY, rootPart.Position.Z))
            
            if topPos.Z > 0 and bottomPos.Z > 0 then
                local barHeight = math.abs(bottomPos.Y - topPos.Y)
                local barWidth = 3
                
                -- Background bar
                local healthBg = Drawing.new("Square")
                healthBg.Visible = true
                healthBg.Color = Color3.fromRGB(0, 0, 0)
                healthBg.Thickness = 1
                healthBg.Transparency = transparency
                healthBg.Filled = true
                healthBg.Size = Vector2.new(barWidth, barHeight)
                healthBg.Position = Vector2.new(topPos.X - barWidth - 8, topPos.Y)
                
                -- Foreground bar (actual health)
                local healthFg = Drawing.new("Square")
                healthFg.Visible = true
                healthFg.Thickness = 1
                healthFg.Transparency = transparency
                healthFg.Filled = true
                
                -- Color based on health
                if healthPercent > 0.75 then
                    healthFg.Color = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 0.5 then
                    healthFg.Color = Color3.fromRGB(255, 255, 0)
                elseif healthPercent > 0.25 then
                    healthFg.Color = Color3.fromRGB(255, 165, 0)
                else
                    healthFg.Color = Color3.fromRGB(255, 0, 0)
                end
                
                healthFg.Size = Vector2.new(barWidth, barHeight * healthPercent)
                healthFg.Position = Vector2.new(topPos.X - barWidth - 8, topPos.Y + (barHeight * (1 - healthPercent)))
                
                table.insert(espObjects[targetPlayer.Name], healthBg)
                table.insert(espObjects[targetPlayer.Name], healthFg)
            end
        end
        
        -- Name ESP (FIXED - Above box)
        if CONFIG.ESPNames and head then
            local nameLabel = Drawing.new("Text")
            nameLabel.Text = targetPlayer.Name
            nameLabel.Size = 16
            nameLabel.Center = true
            nameLabel.Outline = true
            nameLabel.Color = espColor
            nameLabel.Visible = true
            nameLabel.Transparency = transparency
            
            -- Position above head properly
            local headY = head.Position.Y + (head.Size.Y / 2) + 0.5
            local headPos = camera:WorldToViewportPoint(Vector3.new(head.Position.X, headY, head.Position.Z))
            
            if headPos.Z > 0 then
                nameLabel.Position = Vector2.new(headPos.X, headPos.Y)
            else
                nameLabel.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], nameLabel)
        end
        
        -- Distance ESP
        if CONFIG.ESPDistance then
            local distLabel = Drawing.new("Text")
            distLabel.Text = math.floor(distance) .. "m"
            distLabel.Size = 14
            distLabel.Center = true
            distLabel.Outline = true
            distLabel.Color = espColor
            distLabel.Visible = true
            distLabel.Transparency = transparency
            
            local pos = camera:WorldToViewportPoint(rootPart.Position)
            if pos.Z > 0 then
                distLabel.Position = Vector2.new(pos.X, pos.Y + 20)
            else
                distLabel.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], distLabel)
        end
        
        -- Health Text
        if CONFIG.ESPHealth then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local healthLabel = Drawing.new("Text")
            healthLabel.Text = math.floor(humanoid.Health) .. " HP"
            healthLabel.Size = 14
            healthLabel.Center = true
            healthLabel.Outline = true
            healthLabel.Transparency = transparency
            
            if healthPercent > 0.75 then
                healthLabel.Color = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.5 then
                healthLabel.Color = Color3.fromRGB(255, 255, 0)
            elseif healthPercent > 0.25 then
                healthLabel.Color = Color3.fromRGB(255, 165, 0)
            else
                healthLabel.Color = Color3.fromRGB(255, 0, 0)
            end
            
            healthLabel.Visible = true
            
            local pos = camera:WorldToViewportPoint(rootPart.Position)
            if pos.Z > 0 then
                healthLabel.Position = Vector2.new(pos.X, pos.Y + 40)
            else
                healthLabel.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], healthLabel)
        end
        
        -- Weapon ESP (NEW)
        if CONFIG.ESPWeapon then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local weaponLabel = Drawing.new("Text")
                weaponLabel.Text = "🔫 " .. tool.Name
                weaponLabel.Size = 13
                weaponLabel.Center = true
                weaponLabel.Outline = true
                weaponLabel.Color = Color3.fromRGB(255, 200, 0)
                weaponLabel.Visible = true
                weaponLabel.Transparency = transparency
                
                local pos = camera:WorldToViewportPoint(rootPart.Position)
                if pos.Z > 0 then
                    weaponLabel.Position = Vector2.new(pos.X, pos.Y + 60)
                else
                    weaponLabel.Visible = false
                end
                
                table.insert(espObjects[targetPlayer.Name], weaponLabel)
            end
        end
        
        -- Tracers (FIXED origin)
        if CONFIG.ESPTracers then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = espColor
            tracer.Thickness = 2
            tracer.Transparency = transparency
            
            local screenPos = camera:WorldToViewportPoint(rootPart.Position)
            if screenPos.Z > 0 then
                local fromPos
                if CONFIG.ESPTracerOrigin == "Bottom" then
                    fromPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                elseif CONFIG.ESPTracerOrigin == "Middle" then
                    fromPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                else -- Mouse
                    fromPos = Vector2.new(mouse.X, mouse.Y)
                end
                
                tracer.From = fromPos
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                tracer.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], tracer)
        end
        
        -- Head Dot (NEW)
        if CONFIG.ESPHeadDot and head then
            local headDot = Drawing.new("Circle")
            headDot.Visible = true
            headDot.Color = Color3.fromRGB(255, 0, 0)
            headDot.Thickness = 2
            headDot.Transparency = transparency
            headDot.NumSides = 12
            headDot.Radius = 4
            headDot.Filled = true
            
            local headPos = camera:WorldToViewportPoint(head.Position)
            if headPos.Z > 0 then
                headDot.Position = Vector2.new(headPos.X, headPos.Y)
            else
                headDot.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], headDot)
        end
        
        -- Look Direction (NEW)
        if CONFIG.ESPLookDirection and head then
            local lookLine = Drawing.new("Line")
            lookLine.Visible = true
            lookLine.Color = Color3.fromRGB(255, 255, 0)
            lookLine.Thickness = 2
            lookLine.Transparency = transparency
            
            local headPos = camera:WorldToViewportPoint(head.Position)
            local lookVector = head.CFrame.LookVector * 10
            local lookEndPos = camera:WorldToViewportPoint(head.Position + lookVector)
            
            if headPos.Z > 0 and lookEndPos.Z > 0 then
                lookLine.From = Vector2.new(headPos.X, headPos.Y)
                lookLine.To = Vector2.new(lookEndPos.X, lookEndPos.Y)
            else
                lookLine.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], lookLine)
        end
        
        -- Skeleton ESP (BONE ESP - FIXED)
        if CONFIG.ESPSkeleton and CONFIG.BoneESPEnabled then
            for _, bonePair in ipairs(boneConnections_list) do
                local bone1 = character:FindFirstChild(bonePair[1])
                local bone2 = character:FindFirstChild(bonePair[2])
                
                if bone1 and bone2 then
                    local boneLine = Drawing.new("Line")
                    boneLine.Visible = true
                    boneLine.Color = CONFIG.BoneColor
                    boneLine.Thickness = CONFIG.BoneThickness
                    boneLine.Transparency = transparency
                    
                    local pos1 = camera:WorldToViewportPoint(bone1.Position)
                    local pos2 = camera:WorldToViewportPoint(bone2.Position)
                    
                    if pos1.Z > 0 and pos2.Z > 0 then
                        boneLine.From = Vector2.new(pos1.X, pos1.Y)
                        boneLine.To = Vector2.new(pos2.X, pos2.Y)
                    else
                        boneLine.Visible = false
                    end
                    
                    table.insert(espObjects[targetPlayer.Name], boneLine)
                end
            end
        end
    end
    
    -- Update ESP every frame
    local espLoop = RunService.RenderStepped:Connect(function()
        pcall(updateESP)
    end)
    table.insert(connections, espLoop)
end

local function startESP()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            createESP(targetPlayer)
        end
    end
    
    Players.PlayerAdded:Connect(function(targetPlayer)
        if targetPlayer ~= player then
            task.wait(1)
            createESP(targetPlayer)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(targetPlayer)
        if espObjects[targetPlayer.Name] then
            for _, obj in pairs(espObjects[targetPlayer.Name]) do
                if obj and obj.Remove then
                    pcall(function() obj:Remove() end)
                end
            end
            espObjects[targetPlayer.Name] = nil
        end
    end)
    
    notify("ESP Enabled")
end

local function stopESP()
    cleanupESP()
    notify("ESP Disabled")
end

-- =====================================================
-- MOVEMENT SYSTEMS
-- =====================================================
local function setupSpeed(enabled)
    if enabled then
        local speedConn = RunService.Heartbeat:Connect(function()
            if CONFIG.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = CONFIG.SpeedValue
            end
        end)
        table.insert(connections, speedConn)
        notify("Speed: " .. CONFIG.SpeedValue)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        notify("Speed Disabled")
    end
end

local function setupJump(enabled)
    if enabled then
        local jumpConn = RunService.Heartbeat:Connect(function()
            if CONFIG.JumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = CONFIG.JumpPower
            end
        end)
        table.insert(connections, jumpConn)
        notify("Jump: " .. CONFIG.JumpPower)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        notify("Jump Disabled")
    end
end

local flyBodyVelocity = nil
local flyBodyGyro = nil

local function setupFly(enabled)
    if enabled then
        CONFIG.FlyEnabled = true
        
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = rootPart
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.P = 9e9
        flyBodyGyro.Parent = rootPart
        
        local flyConn = RunService.Heartbeat:Connect(function()
            if not CONFIG.FlyEnabled then return end
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            local rootPart = player.Character.HumanoidRootPart
            
            local velocity = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (cam.CFrame.LookVector * CONFIG.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (cam.CFrame.LookVector * CONFIG.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (cam.CFrame.RightVector * CONFIG.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (cam.CFrame.RightVector * CONFIG.FlySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, CONFIG.FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, CONFIG.FlySpeed, 0)
            end
            
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = velocity
            end
            if flyBodyGyro then
                flyBodyGyro.CFrame = cam.CFrame
            end
        end)
        table.insert(connections, flyConn)
        notify("Fly Enabled")
    else
        CONFIG.FlyEnabled = false
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        notify("Fly Disabled")
    end
end

local function setupNoclip(enabled)
    if enabled then
        CONFIG.NoclipEnabled = true
        local noclipConn = RunService.Stepped:Connect(function()
            if not CONFIG.NoclipEnabled or not player.Character then return end
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        table.insert(connections, noclipConn)
        notify("Noclip Enabled")
    else
        CONFIG.NoclipEnabled = false
        notify("Noclip Disabled")
    end
end

-- =====================================================
-- FLING SYSTEM
-- =====================================================
local flingPlatform = nil
local flingBodyGyro = nil

local function setupFling(enabled)
    if enabled then
        CONFIG.FlingEnabled = true
        
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not rootPart or not humanoid then return end
        
        flingPlatform = Instance.new("Part")
        flingPlatform.Size = Vector3.new(8, 1, 8)
        flingPlatform.Position = rootPart.Position - Vector3.new(0, 3, 0)
        flingPlatform.Anchored = true
        flingPlatform.Transparency = 1
        flingPlatform.CanCollide = true
        flingPlatform.Name = "FlingPlatform"
        flingPlatform.Parent = workspace
        
        flingBodyGyro = Instance.new("BodyGyro")
        flingBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flingBodyGyro.P = 9e9
        flingBodyGyro.D = 1000
        flingBodyGyro.CFrame = rootPart.CFrame
        flingBodyGyro.Parent = rootPart
        
        local flingConn = RunService.Heartbeat:Connect(function()
            if not CONFIG.FlingEnabled then
                if flingPlatform then flingPlatform:Destroy() flingPlatform = nil end
                if flingBodyGyro then flingBodyGyro:Destroy() flingBodyGyro = nil end
                return
            end
            
            if not rootPart or not rootPart.Parent then return end
            
            if flingBodyGyro then
                flingBodyGyro.CFrame = flingBodyGyro.CFrame * CFrame.Angles(0, math.rad(100), 0)
            end
            
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        if distance < 15 then
                            local direction = (targetRoot.Position - rootPart.Position).Unit
                            local flingVelocity = direction * CONFIG.FlingPower
                            
                            local targetBodyVelocity = Instance.new("BodyVelocity")
                            targetBodyVelocity.Velocity = flingVelocity
                            targetBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            targetBodyVelocity.Parent = targetRoot
                            
                            game:GetService("Debris"):AddItem(targetBodyVelocity, 0.1)
                        end
                    end
                end
            end
            
            if flingPlatform then
                flingPlatform.Position = rootPart.Position - Vector3.new(0, 3, 0)
            end
        end)
        
        table.insert(connections, flingConn)
        notify("Fling Enabled")
    else
        CONFIG.FlingEnabled = false
        if flingPlatform then flingPlatform:Destroy() flingPlatform = nil end
        if flingBodyGyro then flingBodyGyro:Destroy() flingBodyGyro = nil end
        notify("Fling Disabled")
    end
end

-- =====================================================
-- CRASH PLAYER SYSTEM
-- =====================================================
local function crashPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        notify("Player not found")
        return
    end
    
    notify("Crashing " .. targetPlayer.Name .. "...")
    
    spawn(function()
        for i = 1, 1000 do
            if not targetPlayer or not targetPlayer.Character then break end
            
            local part = Instance.new("Part")
            part.Size = Vector3.new(100, 100, 100)
            part.Anchored = false
            part.CanCollide = true
            part.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            part.Parent = workspace
            
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Parent = part
            
            game:GetService("Debris"):AddItem(part, 0.1)
            
            if i % 10 == 0 then
                task.wait()
            end
        end
    end)
    
    spawn(function()
        for i = 1, 500 do
            if not targetPlayer or not targetPlayer.Character then break end
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://138186576"
            sound.Volume = 10
            sound.Parent = targetPlayer.Character.HumanoidRootPart
            sound:Play()
            
            game:GetService("Debris"):AddItem(sound, 0.1)
            
            if i % 10 == 0 then
                task.wait()
            end
        end
    end)
    
    notify(targetPlayer.Name .. " is being crashed!")
end

-- =====================================================
-- LAG SWITCH & ANTI-AFK
-- =====================================================
local lagSwitchActive = false
local lagConnection = nil

local function setupLagSwitch(enabled)
    if enabled then
        lagSwitchActive = true
        lagConnection = RunService.Heartbeat:Connect(function()
            if lagSwitchActive then
                task.wait(0.5)
            end
        end)
        table.insert(connections, lagConnection)
        notify("Lag Switch ON")
    else
        lagSwitchActive = false
        if lagConnection then
            lagConnection:Disconnect()
            lagConnection = nil
        end
        notify("Lag Switch OFF")
    end
end

if CONFIG.AntiAFK then
    local antiAFKConn = RunService.Heartbeat:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    table.insert(connections, antiAFKConn)
end

-- =====================================================
-- COMMANDS SYSTEM (MAXED OUT)
-- =====================================================
local commands = {
    ["crash"] = function(args)
        if not args[1] then
            notify("Usage: .crash <player>")
            return
        end
        
        local targetName = args[1]:lower()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Name:lower():find(targetName) then
                crashPlayer(targetPlayer)
                break
            end
        end
    end,
    
    ["aimbot"] = function()
        CONFIG.AimbotEnabled = not CONFIG.AimbotEnabled
        if CONFIG.AimbotEnabled then
            startCameraAimbot()
        else
            stopAimbot()
        end
    end,
    
    ["silentaim"] = function()
        CONFIG.SilentAimEnabled = not CONFIG.SilentAimEnabled
        if CONFIG.SilentAimEnabled then
            startSilentAim()
        else
            stopSilentAim()
        end
    end,
    
    ["aimassist"] = function()
        CONFIG.AimAssistEnabled = not CONFIG.AimAssistEnabled
        if CONFIG.AimAssistEnabled then
            startAimAssist()
        else
            stopAimbot()
        end
    end,
    
    ["esp"] = function()
        CONFIG.ESPEnabled = not CONFIG.ESPEnabled
        if CONFIG.ESPEnabled then
            startESP()
        else
            stopESP()
        end
    end,
    
    ["smoothness"] = function(args)
        local value = tonumber(args[1])
        if value and value >= 0.01 and value <= 1 then
            CONFIG.AimbotSmoothness = value
            notify("Smoothness: " .. value)
        else
            notify("Use: .smoothness 0.01-1.0")
        end
    end,
    
    ["aimspeed"] = function(args)
        local value = tonumber(args[1])
        if value and value >= 1 and value <= 20 then
            CONFIG.AimbotSpeed = value
            notify("Aim Speed: " .. value)
        else
            notify("Use: .aimspeed 1-20")
        end
    end,
    
    ["fov"] = function(args)
        local value = tonumber(args[1])
        if value and value >= 10 and value <= 500 then
            CONFIG.AimbotFOV = value
            notify("FOV: " .. value)
        else
            notify("Use: .fov 10-500")
        end
    end,
    
    ["teamcheck"] = function()
        CONFIG.TeamCheck = not CONFIG.TeamCheck
        notify("Team Check: " .. tostring(CONFIG.TeamCheck))
    end,
    
    ["wallcheck"] = function()
        CONFIG.WallCheck = not CONFIG.WallCheck
        CONFIG.VisibleCheck = CONFIG.WallCheck
        notify("Wall Check: " .. tostring(CONFIG.WallCheck))
    end,
    
    ["targetlock"] = function()
        CONFIG.TargetLock = not CONFIG.TargetLock
        notify("Target Lock: " .. tostring(CONFIG.TargetLock))
    end,
    
    ["predict"] = function()
        CONFIG.PredictMovement = not CONFIG.PredictMovement
        notify("Prediction: " .. tostring(CONFIG.PredictMovement))
    end,
    
    ["fling"] = function(args)
        if args[1] == "all" then
            CONFIG.FlingEnabled = true
            setupFling(true)
        elseif args[1] then
            local targetName = args[1]:lower()
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer.Name:lower():find(targetName) and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local direction = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit
                        local flingVelocity = direction * CONFIG.FlingPower
                        
                        local bodyVel = Instance.new("BodyVelocity")
                        bodyVel.Velocity = flingVelocity + Vector3.new(0, 2000, 0)
                        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bodyVel.Parent = targetRoot
                        
                        game:GetService("Debris"):AddItem(bodyVel, 0.1)
                        notify("Flung " .. targetPlayer.Name)
                    end
                end
            end
        else
            CONFIG.FlingEnabled = not CONFIG.FlingEnabled
            setupFling(CONFIG.FlingEnabled)
        end
    end,
    
    ["lag"] = function()
        CONFIG.LagSwitchEnabled = not CONFIG.LagSwitchEnabled
        setupLagSwitch(CONFIG.LagSwitchEnabled)
    end,
    
    ["speed"] = function(args)
        local value = tonumber(args[1]) or 100
        CONFIG.SpeedValue = value
        CONFIG.SpeedEnabled = true
        setupSpeed(true)
    end,
    
    ["fly"] = function()
        CONFIG.FlyEnabled = not CONFIG.FlyEnabled
        setupFly(CONFIG.FlyEnabled)
    end,
    
    ["noclip"] = function()
        CONFIG.NoclipEnabled = not CONFIG.NoclipEnabled
        setupNoclip(CONFIG.NoclipEnabled)
    end,
    
    ["goto"] = function(args)
        if not args[1] then return end
        local targetName = args[1]:lower()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Name:lower():find(targetName) and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    notify("TP to " .. targetPlayer.Name)
                end
                break
            end
        end
    end,
    
    ["bring"] = function(args)
        if not args[1] then return end
        local targetName = args[1]:lower()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Name:lower():find(targetName) and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    targetPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                    notify("Brought " .. targetPlayer.Name)
                end
                break
            end
        end
    end,
    
    ["kill"] = function(args)
        if not args[1] then return end
        local targetName = args[1]:lower()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Name:lower():find(targetName) and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                targetPlayer.Character.Humanoid.Health = 0
                notify("Killed " .. targetPlayer.Name)
                break
            end
        end
    end,
    
    ["invisible"] = function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    if part:FindFirstChild("face") then
                        part.face.Transparency = 1
                    end
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
            notify("Invisible ON")
        end
    end,
    
    ["visible"] = function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    if part:FindFirstChild("face") then
                        part.face.Transparency = 0
                    end
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
            notify("Visible ON")
        end
    end,
    
    ["jump"] = function(args)
        local value = tonumber(args[1]) or 120
        CONFIG.JumpPower = value
        CONFIG.JumpEnabled = true
        setupJump(true)
    end,
    
    ["reset"] = function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end,
    
    ["cmds"] = function()
        print([[
🔥 COMBAT EXCLUSIVE - MAXED OUT COMMANDS 🔥
===============================================
COMBAT:
.aimbot - Toggle aimbot
.silentaim - Toggle silent aim
.aimassist - Toggle aim assist
.smoothness [0.01-1.0] - Set smoothness
.aimspeed [1-20] - Set aim speed
.fov [10-500] - Set FOV
.teamcheck - Toggle team check
.wallcheck - Toggle wall check
.targetlock - Lock onto one target
.predict - Toggle prediction

ESP:
.esp - Toggle ESP

UNIVERSAL:
.crash <player> - Crash player
.fling [player/all] - Fling
.lag - Lag switch
.speed [value] - Speed
.jump [value] - Jump
.fly - Fly
.noclip - Noclip
.goto <player> - TP
.bring <player> - Bring
.kill <player> - Kill
.invisible - Invisible
.visible - Visible
.reset - Reset
===============================================
]])
        notify("Commands in console (F9)")
    end
}

player.Chatted:Connect(function(message)
    if message:sub(1, 1) == CONFIG.CommandPrefix then
        local args = {}
        for arg in message:sub(2):gmatch("%S+") do
            table.insert(args, arg)
        end
        
        local cmd = table.remove(args, 1)
        if cmd and commands[cmd:lower()] then
            pcall(function()
                commands[cmd:lower()](args)
            end)
        end
    end
end)

-- =====================================================
-- GUI CREATION (MOBILE OPTIMIZED - SETTINGS)
-- =====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatExclusiveGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local menuWidth = isMobile and 300 or 450
local menuHeight = isMobile and 500 or 600

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
mainFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, isMobile and 45 or 55)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 MAXED COMBAT"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = isMobile and 18 or 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, isMobile and 35 or 45, 0, isMobile and 35 or 45)
closeButton.Position = UDim2.new(1, -(isMobile and 40 or 50), 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = isMobile and 16 or 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
tabFrame.Position = UDim2.new(0, 0, 0, isMobile and 45 or 55)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabs = {"Combat", "ESP", "Movement", "Misc"}
local tabButtons = {}
local currentTab = "Combat"

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.25, -4, 1, -6)
    tabButton.Position = UDim2.new((i-1) * 0.25, 2, 0, 3)
    tabButton.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 40)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.TextSize = isMobile and 11 or 14
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    tabButtons[tabName] = tabButton
end

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -(isMobile and 95 or 110))
contentFrame.Position = UDim2.new(0, 10, 0, isMobile and 88 or 103)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 8)
contentList.Parent = contentFrame

-- Create Button Function
local function createButton(name, description, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, isMobile and 48 or 55)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Visible = false
    button.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonLabel = Instance.new("TextLabel")
    buttonLabel.Size = UDim2.new(1, -(isMobile and 80 or 95), 0.5, 0)
    buttonLabel.Position = UDim2.new(0, 10, 0, 5)
    buttonLabel.BackgroundTransparency = 1
    buttonLabel.Text = name
    buttonLabel.TextColor3 = Color3.new(1, 1, 1)
    buttonLabel.TextSize = isMobile and 13 or 15
    buttonLabel.Font = Enum.Font.GothamBold
    buttonLabel.TextXAlignment = Enum.TextXAlignment.Left
    buttonLabel.TextTruncate = Enum.TextTruncate.AtEnd
    buttonLabel.Parent = button
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -(isMobile and 80 or 95), 0.5, 0)
    descLabel.Position = UDim2.new(0, 10, 0.5, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextSize = isMobile and 11 or 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descLabel.Parent = button
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, isMobile and 60 or 70, 0, isMobile and 28 or 32)
    toggleButton.Position = UDim2.new(1, -(isMobile and 68 or 78), 0.5, -(isMobile and 14 or 16))
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextSize = isMobile and 12 or 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = button
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    local isEnabled = false
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            toggleButton.Text = "OFF"
        end
        callback(isEnabled)
    end)
    
    return button
end

-- Combat Tab Buttons
local combatButtons = {}
combatButtons[#combatButtons + 1] = createButton("🎯 Aimbot", "Camera lock aimbot", function(enabled)
    CONFIG.AimbotEnabled = enabled
    if enabled then
        startCameraAimbot()
    else
        stopAimbot()
    end
end)

combatButtons[#combatButtons + 1] = createButton("👻 Silent Aim", "Invisible aim (hooks)", function(enabled)
    CONFIG.SilentAimEnabled = enabled
    if enabled then
        startSilentAim()
    else
        stopSilentAim()
    end
end)

combatButtons[#combatButtons + 1] = createButton("🧲 Aim Assist", "Magnetic aim pull", function(enabled)
    CONFIG.AimAssistEnabled = enabled
    if enabled then
        startAimAssist()
    else
        stopAimbot()
    end
end)

combatButtons[#combatButtons + 1] = createButton("🔒 Target Lock", "Lock onto one target", function(enabled)
    CONFIG.TargetLock = enabled
end)

combatButtons[#combatButtons + 1] = createButton("🔮 Prediction", "Predict movement", function(enabled)
    CONFIG.PredictMovement = enabled
end)

combatButtons[#combatButtons + 1] = createButton("👥 Team Check", "Ignore teammates", function(enabled)
    CONFIG.TeamCheck = enabled
end)

combatButtons[#combatButtons + 1] = createButton("🧱 Wall Check", "Shoot through walls", function(enabled)
    CONFIG.WallCheck = enabled
    CONFIG.VisibleCheck = enabled
end)

-- ESP Tab Buttons
local espButtons = {}
espButtons[#espButtons + 1] = createButton("👁️ Master ESP", "Enable all ESP", function(enabled)
    CONFIG.ESPEnabled = enabled
    if enabled then
        startESP()
    else
        stopESP()
    end
end)

espButtons[#espButtons + 1] = createButton("📦 Boxes", "Player boxes", function(enabled)
    CONFIG.ESPBoxes = enabled
end)

espButtons[#espButtons + 1] = createButton("💀 Skeleton", "Bone ESP", function(enabled)
    CONFIG.ESPSkeleton = enabled
    CONFIG.BoneESPEnabled = enabled
end)

espButtons[#espButtons + 1] = createButton("❤️ Health Bar", "Visual health bars", function(enabled)
    CONFIG.ESPHealthBar = enabled
end)

espButtons[#espButtons + 1] = createButton("📍 Tracers", "Lines to players", function(enabled)
    CONFIG.ESPTracers = enabled
end)

espButtons[#espButtons + 1] = createButton("🔫 Weapon ESP", "Show weapons", function(enabled)
    CONFIG.ESPWeapon = enabled
end)

espButtons[#espButtons + 1] = createButton("👥 ESP Team Check", "Hide teammates", function(enabled)
    CONFIG.ESPTeamCheck = enabled
end)

-- Movement Tab Buttons
local movementButtons = {}
movementButtons[#movementButtons + 1] = createButton("⚡ Speed", "Fast movement", function(enabled)
    CONFIG.SpeedEnabled = enabled
    setupSpeed(enabled)
end)

movementButtons[#movementButtons + 1] = createButton("🦘 Jump", "High jumps", function(enabled)
    CONFIG.JumpEnabled = enabled
    setupJump(enabled)
end)

movementButtons[#movementButtons + 1] = createButton("🚁 Fly", "Fly mode", function(enabled)
    CONFIG.FlyEnabled = enabled
    setupFly(enabled)
end)

movementButtons[#movementButtons + 1] = createButton("👻 Noclip", "Walk through walls", function(enabled)
    CONFIG.NoclipEnabled = enabled
    setupNoclip(enabled)
end)

-- Misc Tab Buttons
local miscButtons = {}
miscButtons[#miscButtons + 1] = createButton("🚀 Fling", "Fling nearby players", function(enabled)
    CONFIG.FlingEnabled = enabled
    setupFling(enabled)
end)

miscButtons[#miscButtons + 1] = createButton("⏱️ Lag Switch", "Network lag", function(enabled)
    CONFIG.LagSwitchEnabled = enabled
    setupLagSwitch(enabled)
end)

-- Tab Switching
local tabContents = {
    Combat = combatButtons,
    ESP = espButtons,
    Movement = movementButtons,
    Misc = miscButtons
}

local function switchTab(tabName)
    currentTab = tabName
    
    for name, button in pairs(tabButtons) do
        if name == tabName then
            button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        else
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end
    
    for _, buttons in pairs(tabContents) do
        for _, button in ipairs(buttons) do
            button.Visible = false
        end
    end
    
    for _, button in ipairs(tabContents[tabName]) do
        button.Visible = true
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
end

for tabName, tabButton in pairs(tabButtons) do
    tabButton.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

switchTab("Combat")

-- Update canvas size
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
end)

-- Toggle Button (MOVEABLE)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, isMobile and 55 or 65, 0, isMobile and 55 or 65)
toggleButton.Position = UDim2.new(0, 10, 0.5, -(isMobile and 27.5 or 32.5))
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "🔥"
toggleButton.TextSize = isMobile and 28 or 35
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Thickness = 3
toggleStroke.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Make toggle button draggable
local toggleDragging = false
local toggleDragStart = nil
local toggleStartPos = nil

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        toggleButton.Position = UDim2.new(
            toggleStartPos.X.Scale,
            toggleStartPos.X.Offset + delta.X,
            toggleStartPos.Y.Scale,
            toggleStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Make main frame draggable
local mainDragging = false
local mainDragStart = nil
local mainStartPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true
        mainDragStart = input.Position
        mainStartPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        mainFrame.Position = UDim2.new(
            mainStartPos.X.Scale,
            mainStartPos.X.Offset + delta.X,
            mainStartPos.Y.Scale,
            mainStartPos.Y.Offset + delta.Y
        )
    end
end)

-- =====================================================
-- INITIALIZATION
-- =====================================================
notify("Combat Exclusive Loaded!")
notify(isMobile and "Mobile Optimized" or "PC Mode")
notify("Type .cmds for commands")

print([[
==============================================
🔥 COMBAT EXCLUSIVE - MAXED OUT 🔥
==============================================
✅ Fixed ESP Accuracy
✅ Fast Aimbot (Adjustable)
✅ Silent Aim (Working)
✅ Aim Assist (Magnetic)
✅ Bone ESP (Skeleton)
✅ Full Mobile Support
✅ Team Check
✅ Wall Check  
✅ Prediction
✅ Target Lock
✅ Health Bars
✅ Weapon ESP
✅ Look Direction
✅ Customizable FOV
✅ Smoothness Control
✅ Speed Control
==============================================
Commands: .cmds
GUI: Tap 🔥 button
==============================================
]])
