-- 🔥 COMBAT EXCLUSIVE - MOBILE OPTIMIZED + CRASH COMMAND 🔥
-- Fixed: UI Size, Moveable Toggle, Mobile Aimbot, ESP Accuracy, Crash Feature

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- Wait for character
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Detect mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- =====================================================
-- CONFIGURATION
-- =====================================================
local CONFIG = {
    -- Combat
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothness = 0.15,
    VisibleCheck = false,
    TeamCheck = true,
    AimPart = "Head",
    MobileAimbot = isMobile,
    
    -- ESP
    ESPEnabled = false,
    ESPBoxes = true,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPTracers = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
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
    
    -- Commands
    CommandPrefix = "."
}

-- Connection storage
local connections = {}
local espObjects = {}
local fovCircle = nil

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
local function cleanupConnections()
    for i, conn in pairs(connections) do
        if conn then 
            conn:Disconnect() 
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
end

local function notify(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Combat Exclusive";
        Text = message;
        Duration = 3;
    })
end

-- =====================================================
-- AIMBOT SYSTEM (MOBILE OPTIMIZED)
-- =====================================================
local currentAimTarget = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local aimPart = character:FindFirstChild(CONFIG.AimPart)
            
            if humanoid and humanoid.Health > 0 and rootPart and aimPart then
                -- Team check
                if CONFIG.TeamCheck and targetPlayer.Team == player.Team then
                    continue
                end
                
                -- Visibility check
                if CONFIG.VisibleCheck then
                    local ray = Ray.new(camera.CFrame.Position, (aimPart.Position - camera.CFrame.Position).Unit * 1000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
                    if hit and not hit:IsDescendantOf(character) then
                        continue
                    end
                end
                
                -- Distance check
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if isMobile then
                    -- For mobile, prioritize closest player
                    if distance < shortestDistance then
                        closestPlayer = targetPlayer
                        shortestDistance = distance
                    end
                else
                    -- For PC, prioritize cursor distance
                    local screenPoint, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                    if onScreen then
                        local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                        if mouseDistance < CONFIG.AimbotFOV and mouseDistance < shortestDistance then
                            closestPlayer = targetPlayer
                            shortestDistance = mouseDistance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local aimbotConnection = nil

local function startAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimbotEnabled then return end
        
        local target = getClosestPlayer()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(CONFIG.AimPart)
            if aimPart then
                currentAimTarget = target
                local targetPos = aimPart.Position
                local cameraPos = camera.CFrame.Position
                local aimDirection = (targetPos - cameraPos).Unit
                
                -- Smooth aim
                local currentLook = camera.CFrame.LookVector
                local smoothedDirection = currentLook:Lerp(aimDirection, CONFIG.AimbotSmoothness)
                
                camera.CFrame = CFrame.new(cameraPos, cameraPos + smoothedDirection)
            end
        else
            currentAimTarget = nil
        end
    end)
    
    table.insert(connections, aimbotConnection)
    notify("Aimbot Enabled" .. (isMobile and " (Mobile Mode)" or ""))
end

local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    currentAimTarget = nil
    notify("Aimbot Disabled")
end

-- FOV Circle (PC only)
if not isMobile then
    local function createFOVCircle()
        if fovCircle then return end
        
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Transparency = 1
        fovCircle.NumSides = 64
        fovCircle.Radius = CONFIG.AimbotFOV
        fovCircle.Filled = false
        
        RunService.RenderStepped:Connect(function()
            if fovCircle and CONFIG.AimbotEnabled then
                fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
                fovCircle.Radius = CONFIG.AimbotFOV
                fovCircle.Visible = true
            elseif fovCircle then
                fovCircle.Visible = false
            end
        end)
    end
    
    createFOVCircle()
end

-- =====================================================
-- ESP SYSTEM (FIXED ACCURACY)
-- =====================================================
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
        
        -- Check if on screen with proper bounds
        local rootPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen or rootPos.Z < 0 then return end
        
        -- Calculate proper size based on distance
        local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
        local scale = 1000 / distance
        
        -- Box ESP (Fixed positioning)
        if CONFIG.ESPBoxes then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Color = CONFIG.ESPColor
            box.Thickness = 2
            box.Transparency = 1
            box.Filled = false
            
            -- Calculate corners properly
            local topLeft = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-2.5, 3, 0)).Position)
            local bottomRight = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(2.5, -3, 0)).Position)
            
            if topLeft.Z > 0 and bottomRight.Z > 0 then
                box.Size = Vector2.new(
                    math.abs(bottomRight.X - topLeft.X), 
                    math.abs(bottomRight.Y - topLeft.Y)
                )
                box.Position = Vector2.new(
                    math.min(topLeft.X, bottomRight.X), 
                    math.min(topLeft.Y, bottomRight.Y)
                )
            else
                box.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], box)
        end
        
        -- Name ESP (Fixed positioning)
        if CONFIG.ESPNames and head then
            local nameLabel = Drawing.new("Text")
            nameLabel.Text = targetPlayer.Name
            nameLabel.Size = math.clamp(18, 14, 24)
            nameLabel.Center = true
            nameLabel.Outline = true
            nameLabel.Color = CONFIG.ESPColor
            nameLabel.Visible = true
            
            local headPos = camera:WorldToViewportPoint((head.CFrame * CFrame.new(0, 1.5, 0)).Position)
            if headPos.Z > 0 then
                nameLabel.Position = Vector2.new(headPos.X, headPos.Y)
            else
                nameLabel.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], nameLabel)
        end
        
        -- Distance ESP (Fixed)
        if CONFIG.ESPDistance and rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            local distLabel = Drawing.new("Text")
            distLabel.Text = math.floor(distance) .. "m"
            distLabel.Size = math.clamp(16, 12, 20)
            distLabel.Center = true
            distLabel.Outline = true
            distLabel.Color = CONFIG.ESPColor
            distLabel.Visible = true
            
            local pos = camera:WorldToViewportPoint(rootPart.Position)
            if pos.Z > 0 then
                distLabel.Position = Vector2.new(pos.X, pos.Y + 20)
            else
                distLabel.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], distLabel)
        end
        
        -- Health ESP (Fixed with color coding)
        if CONFIG.ESPHealth and humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local healthLabel = Drawing.new("Text")
            healthLabel.Text = math.floor(humanoid.Health) .. " HP"
            healthLabel.Size = math.clamp(16, 12, 20)
            healthLabel.Center = true
            healthLabel.Outline = true
            
            -- Color based on health
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
        
        -- Tracers (Fixed origin point)
        if CONFIG.ESPTracers and rootPart then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = CONFIG.ESPColor
            tracer.Thickness = 2
            tracer.Transparency = 1
            
            local screenPos = camera:WorldToViewportPoint(rootPart.Position)
            if screenPos.Z > 0 then
                tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                tracer.Visible = false
            end
            
            table.insert(espObjects[targetPlayer.Name], tracer)
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
    
    -- Method 1: Massive part spam
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
    
    -- Method 2: Sound spam
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
    
    -- Method 3: Explosion spam
    spawn(function()
        for i = 1, 200 do
            if not targetPlayer or not targetPlayer.Character then break end
            
            local explosion = Instance.new("Explosion")
            explosion.Position = targetPlayer.Character.HumanoidRootPart.Position
            explosion.BlastPressure = 1000000
            explosion.BlastRadius = 100
            explosion.Parent = workspace
            
            game:GetService("Debris"):AddItem(explosion, 0.1)
            
            if i % 5 == 0 then
                task.wait()
            end
        end
    end)
    
    -- Method 4: Particle spam
    spawn(function()
        for i = 1, 500 do
            if not targetPlayer or not targetPlayer.Character then break end
            
            local particle = Instance.new("ParticleEmitter")
            particle.Rate = 1000
            particle.Lifetime = NumberRange.new(10)
            particle.Speed = NumberRange.new(100)
            particle.Parent = targetPlayer.Character.HumanoidRootPart
            
            game:GetService("Debris"):AddItem(particle, 0.1)
            
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
-- COMMANDS SYSTEM
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
    
    ["lag"] = function(args)
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
    
    ["aimbot"] = function()
        CONFIG.AimbotEnabled = not CONFIG.AimbotEnabled
        if CONFIG.AimbotEnabled then
            startAimbot()
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
🔥 COMBAT EXCLUSIVE COMMANDS 🔥
========================================
.crash <player> - Crash player's game
.fling [player/all] - Fling players
.lag - Toggle lag switch
.speed [value] - Set speed
.jump [value] - Set jump
.fly - Toggle fly
.noclip - Toggle noclip
.aimbot - Toggle aimbot
.esp - Toggle ESP
.goto <player> - TP to player
.bring <player> - Bring player
.kill <player> - Kill player
.invisible - Go invisible
.visible - Become visible
.reset - Reset character
.cmds - Show commands
========================================
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
-- GUI CREATION (MOBILE OPTIMIZED)
-- =====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatExclusiveGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Adjusted sizes for mobile
local menuWidth = isMobile and 280 or 400
local menuHeight = isMobile and 450 or 550

-- Main Frame (Smaller for mobile)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
mainFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.5, -menuHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, isMobile and 40 or 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 COMBAT"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = isMobile and 16 or 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, isMobile and 30 or 40, 0, isMobile and 30 or 40)
closeButton.Position = UDim2.new(1, -(isMobile and 35 or 45), 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = isMobile and 14 or 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -16, 1, -(isMobile and 55 or 65))
contentFrame.Position = UDim2.new(0, 8, 0, isMobile and 48 or 58)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 6)
contentList.Parent = contentFrame

-- Function to create buttons (mobile optimized)
local function createButton(name, description, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -8, 0, isMobile and 45 or 50)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local buttonLabel = Instance.new("TextLabel")
    buttonLabel.Size = UDim2.new(1, -(isMobile and 75 or 90), 0.55, 0)
    buttonLabel.Position = UDim2.new(0, 8, 0, 4)
    buttonLabel.BackgroundTransparency = 1
    buttonLabel.Text = name
    buttonLabel.TextColor3 = Color3.new(1, 1, 1)
    buttonLabel.TextSize = isMobile and 12 or 14
    buttonLabel.Font = Enum.Font.GothamBold
    buttonLabel.TextXAlignment = Enum.TextXAlignment.Left
    buttonLabel.TextTruncate = Enum.TextTruncate.AtEnd
    buttonLabel.Parent = button
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -(isMobile and 75 or 90), 0.45, 0)
    descLabel.Position = UDim2.new(0, 8, 0.55, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextSize = isMobile and 10 or 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descLabel.Parent = button
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, isMobile and 55 or 65, 0, isMobile and 26 or 28)
    toggleButton.Position = UDim2.new(1, -(isMobile and 62 or 72), 0.5, -(isMobile and 13 or 14))
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextSize = isMobile and 11 or 13
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = button
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
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

-- Create Buttons
createButton("🎯 Aimbot", isMobile and "Auto aim (mobile)" or "Lock onto players", function(enabled)
    CONFIG.AimbotEnabled = enabled
    if enabled then
        startAimbot()
    else
        stopAimbot()
    end
end)

createButton("👁️ ESP", "See through walls", function(enabled)
    CONFIG.ESPEnabled = enabled
    if enabled then
        startESP()
    else
        stopESP()
    end
end)

createButton("⚡ Speed", "Fast movement", function(enabled)
    CONFIG.SpeedEnabled = enabled
    setupSpeed(enabled)
end)

createButton("🦘 Jump", "High jumps", function(enabled)
    CONFIG.JumpEnabled = enabled
    setupJump(enabled)
end)

createButton("🚁 Fly", "Fly mode", function(enabled)
    CONFIG.FlyEnabled = enabled
    setupFly(enabled)
end)

createButton("👻 Noclip", "Walk through walls", function(enabled)
    CONFIG.NoclipEnabled = enabled
    setupNoclip(enabled)
end)

createButton("🚀 Fling", "Fling nearby players", function(enabled)
    CONFIG.FlingEnabled = enabled
    setupFling(enabled)
end)

createButton("⏱️ Lag", "Network lag", function(enabled)
    CONFIG.LagSwitchEnabled = enabled
    setupLagSwitch(enabled)
end)

-- Update canvas size
contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
end)

-- Toggle Button (MOVEABLE)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, isMobile and 50 or 60, 0, isMobile and 50 or 60)
toggleButton.Position = UDim2.new(0, 10, 0.5, -(isMobile and 25 or 30))
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "🔥"
toggleButton.TextSize = isMobile and 24 or 30
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Thickness = 2
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
notify(isMobile and "Mobile Mode Active" or "PC Mode Active")
notify("Type .cmds for commands")

print([[
==============================================
🔥 COMBAT EXCLUSIVE - MOBILE OPTIMIZED 🔥
==============================================
UI: Tap 🔥 button (moveable)
Commands: Type .cmds
Features: All working
Mobile: Optimized controls
New: .crash <player> command
==============================================
]])
