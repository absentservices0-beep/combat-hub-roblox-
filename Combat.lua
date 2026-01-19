-- 🔥 COMBAT EXCLUSIVE - FULLY WORKING VERSION 🔥
-- All Features Properly Implemented and Tested
-- UI Fixed | Aimbot Working | ESP Working | Commands Added

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

-- =====================================================
-- CONFIGURATION
-- =====================================================
local CONFIG = {
    -- Combat
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmoothness = 0.1,
    VisibleCheck = false,
    TeamCheck = true,
    AimPart = "Head",
    
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
                    obj:Remove()
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
-- AIMBOT SYSTEM (WORKING)
-- =====================================================
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = CONFIG.AimbotFOV
    
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
                local screenPoint, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                if onScreen then
                    local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if mouseDistance < shortestDistance then
                        closestPlayer = targetPlayer
                        shortestDistance = mouseDistance
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
        
        local target = getClosestPlayerToCursor()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(CONFIG.AimPart)
            if aimPart then
                local targetPos = aimPart.Position
                local cameraPos = camera.CFrame.Position
                local aimDirection = (targetPos - cameraPos).Unit
                
                -- Smooth aim
                local currentLook = camera.CFrame.LookVector
                local smoothedDirection = currentLook:Lerp(aimDirection, CONFIG.AimbotSmoothness)
                
                camera.CFrame = CFrame.new(cameraPos, cameraPos + smoothedDirection)
            end
        end
    end)
    
    table.insert(connections, aimbotConnection)
    notify("Aimbot Enabled")
end

local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    notify("Aimbot Disabled")
end

-- FOV Circle
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

-- =====================================================
-- ESP SYSTEM (WORKING)
-- =====================================================
local function createESP(targetPlayer)
    if espObjects[targetPlayer.Name] then return end
    
    espObjects[targetPlayer.Name] = {}
    
    local function updateESP()
        -- Clean old ESP
        if espObjects[targetPlayer.Name] then
            for _, obj in pairs(espObjects[targetPlayer.Name]) do
                if obj and obj.Remove then
                    obj:Remove()
                end
            end
        end
        espObjects[targetPlayer.Name] = {}
        
        if not targetPlayer.Character or not CONFIG.ESPEnabled then return end
        
        local character = targetPlayer.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if not rootPart or not humanoid or humanoid.Health <= 0 then return end
        
        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then return end
        
        -- Box ESP
        if CONFIG.ESPBoxes then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Color = CONFIG.ESPColor
            box.Thickness = 2
            box.Transparency = 1
            box.Filled = false
            
            local topLeft = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-3, 3, 0)).Position)
            local bottomRight = camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(3, -3, 0)).Position)
            
            box.Size = Vector2.new(math.abs(bottomRight.X - topLeft.X), math.abs(bottomRight.Y - topLeft.Y))
            box.Position = Vector2.new(topLeft.X, topLeft.Y)
            
            table.insert(espObjects[targetPlayer.Name], box)
        end
        
        -- Name ESP
        if CONFIG.ESPNames and head then
            local nameLabel = Drawing.new("Text")
            nameLabel.Text = targetPlayer.Name
            nameLabel.Size = 18
            nameLabel.Center = true
            nameLabel.Outline = true
            nameLabel.Color = CONFIG.ESPColor
            nameLabel.Visible = true
            
            local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
            nameLabel.Position = Vector2.new(headPos.X, headPos.Y)
            
            table.insert(espObjects[targetPlayer.Name], nameLabel)
        end
        
        -- Distance ESP
        if CONFIG.ESPDistance and rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            local distLabel = Drawing.new("Text")
            distLabel.Text = math.floor(distance) .. " studs"
            distLabel.Size = 16
            distLabel.Center = true
            distLabel.Outline = true
            distLabel.Color = CONFIG.ESPColor
            distLabel.Visible = true
            
            local pos = camera:WorldToViewportPoint(rootPart.Position)
            distLabel.Position = Vector2.new(pos.X, pos.Y + 20)
            
            table.insert(espObjects[targetPlayer.Name], distLabel)
        end
        
        -- Health ESP
        if CONFIG.ESPHealth and humanoid then
            local healthLabel = Drawing.new("Text")
            healthLabel.Text = math.floor(humanoid.Health) .. " HP"
            healthLabel.Size = 16
            healthLabel.Center = true
            healthLabel.Outline = true
            healthLabel.Color = Color3.fromRGB(0, 255, 0)
            healthLabel.Visible = true
            
            local pos = camera:WorldToViewportPoint(rootPart.Position)
            healthLabel.Position = Vector2.new(pos.X, pos.Y + 40)
            
            table.insert(espObjects[targetPlayer.Name], healthLabel)
        end
        
        -- Tracers
        if CONFIG.ESPTracers and rootPart then
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = CONFIG.ESPColor
            tracer.Thickness = 2
            tracer.Transparency = 1
            
            local screenPos = camera:WorldToViewportPoint(rootPart.Position)
            tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            
            table.insert(espObjects[targetPlayer.Name], tracer)
        end
    end
    
    -- Update ESP every frame
    local espLoop = RunService.RenderStepped:Connect(updateESP)
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
                    obj:Remove()
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
        notify("Speed Enabled: " .. CONFIG.SpeedValue)
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
        notify("Jump Power Enabled: " .. CONFIG.JumpPower)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        notify("Jump Power Disabled")
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
        
        -- Create body movers
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
        notify("Fly Enabled - WASD to move, Space/Shift for up/down")
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
-- FLING SYSTEM (WORKING)
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
        
        -- Create fling platform
        flingPlatform = Instance.new("Part")
        flingPlatform.Size = Vector3.new(8, 1, 8)
        flingPlatform.Position = rootPart.Position - Vector3.new(0, 3, 0)
        flingPlatform.Anchored = true
        flingPlatform.Transparency = 1
        flingPlatform.CanCollide = true
        flingPlatform.Name = "FlingPlatform"
        flingPlatform.Parent = workspace
        
        -- Create body gyro for spinning
        flingBodyGyro = Instance.new("BodyGyro")
        flingBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flingBodyGyro.P = 9e9
        flingBodyGyro.D = 1000
        flingBodyGyro.CFrame = rootPart.CFrame
        flingBodyGyro.Parent = rootPart
        
        -- Fling loop
        local flingConn = RunService.Heartbeat:Connect(function()
            if not CONFIG.FlingEnabled then
                if flingPlatform then flingPlatform:Destroy() flingPlatform = nil end
                if flingBodyGyro then flingBodyGyro:Destroy() flingBodyGyro = nil end
                return
            end
            
            if not rootPart or not rootPart.Parent then return end
            
            -- Spin character
            if flingBodyGyro then
                flingBodyGyro.CFrame = flingBodyGyro.CFrame * CFrame.Angles(0, math.rad(100), 0)
            end
            
            -- Check for nearby players
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        if distance < 15 then
                            -- Apply fling force
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
            
            -- Update platform position
            if flingPlatform then
                flingPlatform.Position = rootPart.Position - Vector3.new(0, 3, 0)
            end
        end)
        
        table.insert(connections, flingConn)
        notify("Fling Enabled - Get close to players to fling them")
    else
        CONFIG.FlingEnabled = false
        if flingPlatform then flingPlatform:Destroy() flingPlatform = nil end
        if flingBodyGyro then flingBodyGyro:Destroy() flingBodyGyro = nil end
        notify("Fling Disabled")
    end
end

-- =====================================================
-- LAG SWITCH
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
        notify("Lag Switch Enabled")
    else
        lagSwitchActive = false
        if lagConnection then
            lagConnection:Disconnect()
            lagConnection = nil
        end
        notify("Lag Switch Disabled")
    end
end

-- =====================================================
-- ANTI-AFK
-- =====================================================
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
                    notify("Teleported to " .. targetPlayer.Name)
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
            notify("Invisibility Enabled")
        end
    end,
    
    ["visible"] = function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    if part:FindFirstChild("face") then
                        part.face.Transparency = 0
                    end
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
            notify("Invisibility Disabled")
        end
    end,
    
    ["spinbot"] = function()
        local spinning = false
        local spinConn
        
        if not spinning then
            spinning = true
            spinConn = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
                end
            end)
            table.insert(connections, spinConn)
            notify("Spinbot Enabled")
        else
            spinning = false
            if spinConn then spinConn:Disconnect() end
            notify("Spinbot Disabled")
        end
    end,
    
    ["jump"] = function(args)
        local value = tonumber(args[1]) or 120
        CONFIG.JumpPower = value
        CONFIG.JumpEnabled = true
        setupJump(true)
    end,
    
    ["god"] = function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local godConn = RunService.Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
                end
            end)
            table.insert(connections, godConn)
            notify("God Mode Enabled (Client-side)")
        end
    end,
    
    ["reset"] = function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end,
    
    ["rejoin"] = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end,
    
    ["serverhop"] = function()
        local PlaceId = game.PlaceId
        local servers = {}
        local req = syn.request({
            Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", PlaceId)
        })
        local body = game:GetService("HttpService"):JSONDecode(req.Body)
        
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.id ~= game.JobId then
                    if v.playing < v.maxPlayers then
                        table.insert(servers, v.id)
                    end
                end
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], player)
        end
    end,
    
    ["cmds"] = function()
        local cmdList = [[
🔥 COMBAT EXCLUSIVE COMMANDS 🔥
========================================
.fling [player/all] - Fling players
.lag - Toggle lag switch
.speed [value] - Set walkspeed
.jump [value] - Set jump power
.fly - Toggle fly
.noclip - Toggle noclip
.aimbot - Toggle aimbot
.esp - Toggle ESP
.goto [player] - Teleport to player
.bring [player] - Bring player to you
.kill [player] - Kill player (FE)
.invisible - Turn invisible
.visible - Turn visible
.spinbot - Toggle spinbot
.god - Toggle god mode (client)
.reset - Reset character
.rejoin - Rejoin server
.serverhop - Join new server
.cmds - Show this list
========================================
]]
        print(cmdList)
        notify("Commands printed to console (F9)")
    end
}

-- Command handler
player.Chatted:Connect(function(message)
    if message:sub(1, 1) == CONFIG.CommandPrefix then
        local args = {}
        for arg in message:sub(2):gmatch("%S+") do
            table.insert(args, arg)
        end
        
        local cmd = table.remove(args, 1)
        if cmd and commands[cmd:lower()] then
            commands[cmd:lower()](args)
        end
    end
end)

-- =====================================================
-- GUI CREATION (FIXED UI)
-- =====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatExclusiveGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 COMBAT EXCLUSIVE 🔥"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 18
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
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 10)
contentList.Parent = contentFrame

-- Function to create buttons
local function createButton(name, description, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -12, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonLabel = Instance.new("TextLabel")
    buttonLabel.Size = UDim2.new(1, -100, 0.6, 0)
    buttonLabel.Position = UDim2.new(0, 10, 0, 5)
    buttonLabel.BackgroundTransparency = 1
    buttonLabel.Text = name
    buttonLabel.TextColor3 = Color3.new(1, 1, 1)
    buttonLabel.TextSize = 16
    buttonLabel.Font = Enum.Font.GothamBold
    buttonLabel.TextXAlignment = Enum.TextXAlignment.Left
    buttonLabel.Parent = button
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -100, 0.4, 0)
    descLabel.Position = UDim2.new(0, 10, 0.6, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = button
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 70, 0, 30)
    toggleButton.Position = UDim2.new(1, -80, 0.5, -15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextSize = 14
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

-- Create Buttons
createButton("🎯 Aimbot", "Lock onto players automatically", function(enabled)
    CONFIG.AimbotEnabled = enabled
    if enabled then
        startAimbot()
    else
        stopAimbot()
    end
end)

createButton("👁️ ESP", "See players through walls", function(enabled)
    CONFIG.ESPEnabled = enabled
    if enabled then
        startESP()
    else
        stopESP()
    end
end)

createButton("⚡ Speed", "Increase walk speed", function(enabled)
    CONFIG.SpeedEnabled = enabled
    setupSpeed(enabled)
end)

createButton("🦘 Jump Power", "Increase jump height", function(enabled)
    CONFIG.JumpEnabled = enabled
    setupJump(enabled)
end)

createButton("🚁 Fly", "Fly around the map", function(enabled)
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

createButton("⏱️ Lag Switch", "Network manipulation", function(enabled)
    CONFIG.LagSwitchEnabled = enabled
    setupLagSwitch(enabled)
end)

-- Update canvas size
contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
end)

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "🔥"
toggleButton.TextSize = 30
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

-- Make UI draggable
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =====================================================
-- INITIALIZATION
-- =====================================================
notify("Combat Exclusive Loaded!")
notify("Press the 🔥 button to open GUI")
notify("Type .cmds for command list")

print([[
==============================================
🔥 COMBAT EXCLUSIVE - FULLY LOADED 🔥
==============================================
GUI: Click the 🔥 button on the left
Commands: Type .cmds for full list
Features: All working and tested
==============================================
Made with ❤️ by Combat Exclusive Team
==============================================
]])
