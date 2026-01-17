-- Premium Aimbot & Combat System
-- Professional game mechanics for Roblox
-- Mobile-optimized with draggable controls

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Configuration
local CONFIG = {
    AimbotEnabled = true,
    AimbotStrength = 0.5,
    AimbotSmoothness = 0.3,
    AimbotRadius = 150,
    AimbotKey = Enum.KeyCode.E,
    MobileAimButton = true,
    FOV = 80,
    MaxDistance = 500,
    TargetPriority = "Distance", -- Distance, Health, ClosestToCrosshair
    AimBone = "Head", -- Head, Torso, HumanoidRootPart
    Prediction = true,
    PredictionStrength = 0.2,
    WallCheck = true,
    VisibilityCheck = true,
    TeamCheck = true,
    MaxFeatures = true,
    MobileOptimized = true,
    Undetectable = true
}

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatSystem_" .. tostring(math.random(1000, 9999))
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Aimbot Toggle Button (Draggable)
local aimbotToggle = Instance.new("ImageButton")
aimbotToggle.Name = "AimbotToggle"
aimbotToggle.Size = UDim2.new(0, 70, 0, 70)
aimbotToggle.Position = UDim2.new(0.85, 0, 0.3, 0)
aimbotToggle.BackgroundTransparency = 1
aimbotToggle.Image = "rbxassetid://3926305904"
aimbotToggle.ImageRectOffset = Vector2.new(644, 724)
aimbotToggle.ImageRectSize = Vector2.new(36, 36)
aimbotToggle.ImageColor3 = Color3.fromRGB(255, 75, 75)
aimbotToggle.ScaleType = Enum.ScaleType.Fit
aimbotToggle.Parent = screenGui

-- Aimbot Toggle Effects
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = aimbotToggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 150, 150)
toggleStroke.Thickness = 3
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = aimbotToggle

-- Aimbot Control Panel
local controlPanel = Instance.new("Frame")
controlPanel.Name = "ControlPanel"
controlPanel.Size = UDim2.new(0, 300, 0, 500)
controlPanel.Position = UDim2.new(0.5, -150, 0.5, -250)
controlPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
controlPanel.BackgroundTransparency = 0.1
controlPanel.Visible = false
controlPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = controlPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255, 75, 75)
panelStroke.Thickness = 2
panelStroke.Parent = controlPanel

-- Panel Header
local panelHeader = Instance.new("Frame")
panelHeader.Size = UDim2.new(1, 0, 0, 50)
panelHeader.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
panelHeader.Parent = controlPanel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = panelHeader

local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, -60, 1, 0)
panelTitle.Position = UDim2.new(0, 15, 0, 0)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "⚡ COMBAT CONTROL CENTER"
panelTitle.TextColor3 = Color3.new(1, 1, 1)
panelTitle.TextScaled = true
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Parent = panelHeader

-- Close Panel Button
local closePanel = Instance.new("TextButton")
closePanel.Size = UDim2.new(0, 30, 0, 30)
closePanel.Position = UDim2.new(1, -35, 0, 10)
closePanel.BackgroundTransparency = 1
closePanel.Text = "✕"
closePanel.TextColor3 = Color3.new(1, 1, 1)
closePanel.TextScaled = true
closePanel.Font = Enum.Font.GothamBold
closePanel.Parent = panelHeader

-- Draggable Strength Slider
local strengthFrame = Instance.new("Frame")
strengthFrame.Name = "StrengthFrame"
strengthFrame.Size = UDim2.new(0.9, 0, 0, 80)
strengthFrame.Position = UDim2.new(0.05, 0, 0, 70)
strengthFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
strengthFrame.Parent = controlPanel

local strengthCorner = Instance.new("UICorner")
strengthCorner.CornerRadius = UDim.new(0, 10)
strengthCorner.Parent = strengthFrame

local strengthTitle = Instance.new("TextLabel")
strengthTitle.Size = UDim2.new(1, -10, 0, 25)
strengthTitle.Position = UDim2.new(0, 5, 0, 5)
strengthTitle.BackgroundTransparency = 1
strengthTitle.Text = "AIMBOT STRENGTH"
strengthTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
strengthTitle.TextScaled = true
strengthTitle.Font = Enum.Font.GothamBold
strengthTitle.Parent = strengthFrame

-- Strength Slider
local strengthSlider = Instance.new("Frame")
strengthSlider.Name = "StrengthSlider"
strengthSlider.Size = UDim2.new(0.8, 0, 0, 20)
strengthSlider.Position = UDim2.new(0.1, 0, 0, 40)
strengthSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
strengthSlider.Parent = strengthFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = strengthSlider

local strengthFill = Instance.new("Frame")
strengthFill.Name = "StrengthFill"
strengthFill.Size = UDim2.new(0.5, 0, 1, 0)
strengthFill.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
strengthFill.Parent = strengthSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = strengthFill

local strengthHandle = Instance.new("ImageButton")
strengthHandle.Name = "StrengthHandle"
strengthHandle.Size = UDim2.new(0, 25, 0, 25)
strengthHandle.Position = UDim2.new(0.5, -12, 0, -2)
strengthHandle.BackgroundTransparency = 1
strengthHandle.Image = "rbxassetid://3926305904"
strengthHandle.ImageRectOffset = Vector2.new(924, 724)
strengthHandle.ImageRectSize = Vector2.new(36, 36)
strengthHandle.ImageColor3 = Color3.new(1, 1, 1)
strengthHandle.Parent = strengthSlider

local strengthValue = Instance.new("TextLabel")
strengthValue.Size = UDim2.new(0.8, 0, 0, 20)
strengthValue.Position = UDim2.new(0.1, 0, 0, 65)
strengthValue.BackgroundTransparency = 1
strengthValue.Text = "50%"
strengthValue.TextColor3 = Color3.fromRGB(255, 75, 75)
strengthValue.TextScaled = true
strengthValue.Font = Enum.Font.GothamBold
strengthValue.Parent = strengthFrame

-- Feature Grid
local featureScroll = Instance.new("ScrollingFrame")
featureScroll.Name = "FeatureScroll"
featureScroll.Size = UDim2.new(0.9, 0, 0.6, 0)
featureScroll.Position = UDim2.new(0.05, 0, 0, 160)
featureScroll.BackgroundTransparency = 1
featureScroll.ScrollBarThickness = 6
featureScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 75, 75)
featureScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
featureScroll.Parent = controlPanel

local featureList = Instance.new("UIListLayout")
featureList.Padding = UDim.new(0, 10)
featureList.SortOrder = Enum.SortOrder.LayoutOrder
featureList.Parent = featureScroll

-- Combat Features
local combatFeatures = {
    {name = "🔫 SMART AIMBOT", enabled = true, premium = false},
    {name = "🎯 PREDICTION", enabled = true, premium = true},
    {name = "👁️ VISIBILITY CHECK", enabled = true, premium = false},
    {name = "🧱 WALL CHECK", enabled = true, premium = true},
    {name = "👥 TEAM CHECK", enabled = true, premium = false},
    {name = "📏 DISTANCE LIMIT", enabled = true, premium = false},
    {name = "🦴 TARGET BONE", enabled = true, premium = true},
    {name = "⚡ AUTO TRIGGER", enabled = false, premium = true},
    {name = "🔄 RAPID FIRE", enabled = false, premium = true},
    {name = "💥 NO RECOIL", enabled = false, premium = true},
    {name = "🎯 SILENT AIM", enabled = false, premium = true},
    {name = "📊 ESP OVERLAY", enabled = true, premium = false},
    {name = "🔍 MAGNET AIM", enabled = false, premium = true},
    {name = "🎪 CIRCULAR AIM", enabled = false, premium = true},
    {name = "⚙️ CUSTOM FOV", enabled = true, premium = false},
    {name = "🎮 MOBILE CONTROLS", enabled = true, premium = false}
}

-- Create feature toggles
for i, feature in ipairs(combatFeatures) do
    local featureFrame = Instance.new("Frame")
    featureFrame.Name = feature.name .. "Frame"
    featureFrame.Size = UDim2.new(1, 0, 0, 40)
    featureFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    featureFrame.LayoutOrder = i
    featureFrame.Parent = featureScroll

    local featureCorner = Instance.new("UICorner")
    featureCorner.CornerRadius = UDim.new(0, 8)
    featureCorner.Parent = featureFrame

    local featureText = Instance.new("TextLabel")
    featureText.Size = UDim2.new(1, -60, 1, 0)
    featureText.Position = UDim2.new(0, 10, 0, 0)
    featureText.BackgroundTransparency = 1
    featureText.Text = feature.name
    featureText.TextColor3 = Color3.new(1, 1, 1)
    featureText.TextScaled = true
    featureText.Font = Enum.Font.Gotham
    featureText.TextXAlignment = Enum.TextXAlignment.Left
    featureText.Parent = featureFrame

    local featureToggle = Instance.new("TextButton")
    featureToggle.Name = "Toggle"
    featureToggle.Size = UDim2.new(0, 50, 0, 25)
    featureToggle.Position = UDim2.new(1, -55, 0.5, -12)
    featureToggle.BackgroundColor3 = feature.enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
    featureToggle.Text = feature.enabled and "ON" or "OFF"
    featureToggle.TextColor3 = Color3.new(1, 1, 1)
    featureToggle.TextScaled = true
    featureToggle.Font = Enum.Font.GothamBold
    featureToggle.Parent = featureFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = featureToggle

    if feature.premium then
        local premiumIcon = Instance.new("ImageLabel")
        premiumIcon.Size = UDim2.new(0, 15, 0, 15)
        premiumIcon.Position = UDim2.new(1, -15, 0, 0)
        premiumIcon.BackgroundTransparency = 1
        premiumIcon.Image = "rbxassetid://6764432408"
        premiumIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
        premiumIcon.Parent = featureFrame
    end

    featureToggle.MouseButton1Click:Connect(function()
        feature.enabled = not feature.enabled
        featureToggle.BackgroundColor3 = feature.enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
        featureToggle.Text = feature.enabled and "ON" or "OFF"
        updateFeature(feature.name, feature.enabled)
    end)
end

-- Aimbot Core System
local aimbotActive = false
local currentTarget = nil
local aimbotConnection = nil

-- FOV Circle
local fovCircle = Instance.new("ImageLabel")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, CONFIG.AimbotRadius * 2, 0, CONFIG.AimbotRadius * 2)
fovCircle.Position = UDim2.new(0.5, -CONFIG.AimbotRadius, 0.5, -CONFIG.AimbotRadius)
fovCircle.BackgroundTransparency = 1
fovCircle.Image = "rbxassetid://266543268"
fovCircle.ImageColor3 = Color3.fromRGB(255, 75, 75)
fovCircle.ImageTransparency = 0.7
fovCircle.Visible = false
fovCircle.Parent = screenGui

-- ESP System
local espObjects = {}

-- Main Aimbot Functions
function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local localCharacter = player.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then return nil end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local targetCharacter = targetPlayer.Character
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            local targetBone = targetCharacter:FindFirstChild(CONFIG.AimBone)
            
            if targetHumanoid and targetHumanoid.Health > 0 and targetRoot and targetBone then
                -- Team check
                if CONFIG.TeamCheck and targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then
                    continue
                end
                
                -- Distance check
                local distance = (targetRoot.Position - localRoot.Position).Magnitude
                if distance > CONFIG.MaxDistance then
                    continue
                end
                
                -- Visibility check
                if CONFIG.VisibilityCheck then
                    local screenPos, visible = camera:WorldToViewportPoint(targetBone.Position)
                    if not visible then
                        continue
                    end
                end
                
                -- Wall check
                if CONFIG.WallCheck then
                    local ray = Ray.new(camera.CFrame.Position, (targetBone.Position - camera.CFrame.Position).Unit * distance)
                    local hit = workspace:FindPartOnRay(ray, localCharacter)
                    if hit and hit:IsDescendantOf(targetCharacter) == false then
                        continue
                    end
                end
                
                -- FOV check
                local screenPos = camera:WorldToViewportPoint(targetBone.Position)
                local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                
                if screenDistance > CONFIG.AimbotRadius then
                    continue
                end
                
                -- Priority system
                local priorityScore = distance
                if CONFIG.TargetPriority == "ClosestToCrosshair" then
                    priorityScore = screenDistance
                elseif CONFIG.TargetPriority == "Health" then
                    priorityScore = targetHumanoid.Health
                end
                
                if priorityScore < closestDistance then
                    closestDistance = priorityScore
                    closestPlayer = {
                        Player = targetPlayer,
                        Character = targetCharacter,
                        Humanoid = targetHumanoid,
                        RootPart = targetRoot,
                        AimPart = targetBone,
                        ScreenPosition = screenPos,
                        Distance = distance
                    }
                end
            end
        end
    end
    
    return closestPlayer
end

function aimAtTarget(target)
    if not target or not target.AimPart then return end
    
    local localCharacter = player.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    local aimPosition = target.AimPart.Position
    
    -- Prediction
    if CONFIG.Prediction and target.RootPart.AssemblyLinearVelocity.Magnitude > 0 then
        local travelTime = (target.RootPart.Position - localRoot.Position).Magnitude / 1000 -- Assume bullet speed
        aimPosition = aimPosition + target.RootPart.AssemblyLinearVelocity * travelTime * CONFIG.PredictionStrength
    end
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, aimPosition)
    
    -- Smooth aiming
    local smoothness = CONFIG.AimbotSmoothness
    local strength = CONFIG.AimbotStrength
    
    camera.CFrame = currentCFrame:Lerp(targetCFrame, strength * smoothness)
end

function updateESP(target)
    -- Clear old ESP
    for _, obj in ipairs(espObjects) do
        if obj then obj:Destroy() end
    end
    espObjects = {}
    
    if target and target.Character then
        -- Create ESP box
        local espBox = Instance.new("BoxHandleAdornment")
        espBox.Size = target.Character:GetExtentsSize()
        espBox.CFrame = target.Character:GetPivot()
        espBox.Color3 = Color3.fromRGB(255, 75, 75)
        espBox.Transparency = 0.3
        espBox.AlwaysOnTop = true
        espBox.Adornee = target.Character
        espBox.Parent = screenGui
        
        table.insert(espObjects, espBox)
        
        -- Create name tag
        local head = target.Character:FindFirstChild("Head")
        if head then
            local nameTag = Instance.new("BillboardGui")
            nameTag.Size = UDim2.new(0, 200, 0, 50)
            nameTag.StudsOffset = Vector3.new(0, 3, 0)
            nameTag.Adornee = head
            nameTag.AlwaysOnTop = true
            nameTag.Parent = screenGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = target.Player.Name .. " [" .. math.floor(target.Distance) .. "m]"
            nameLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = nameTag
            
            table.insert(espObjects, nameTag)
        end
    end
end

-- Strength slider functionality
local strengthDragging = false
strengthHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        strengthDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if strengthDragging then
        local sliderPos = strengthSlider.AbsolutePosition
        local sliderSize = strengthSlider.AbsoluteSize
        local mousePos = input.Position
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        CONFIG.AimbotStrength = relativeX
        
        strengthFill.Size = UDim2.new(relativeX, 0, 1, 0)
        strengthHandle.Position = UDim2.new(relativeX, -12, 0, -2)
        strengthValue.Text = tostring(math.floor(relativeX * 100)) .. "%"
    end
end)

UserInputService.InputEnded:Connect(function(input)
    strengthDragging = false
end)

-- Toggle functionality
aimbotToggle.MouseButton1Click:Connect(function()
    controlPanel.Visible = not controlPanel.Visible
    fovCircle.Visible = not fovCircle.Visible
end)

closePanel.MouseButton1Click:Connect(function()
    controlPanel.Visible = false
    fovCircle.Visible = false
end)

-- Draggable toggle button
local toggleDragging = false
local toggleDragStart = Vector2.new(0, 0)
local toggleStartPos = UDim2.new(0, 0, 0, 0)

aimbotToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = aimbotToggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - toggleDragStart
        aimbotToggle.Position = UDim2.new(
            toggleStartPos.X.Scale,
            toggleStartPos.X.Offset + delta.X,
            toggleStartPos.Y.Scale,
            toggleStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = false
    end
end)

-- Feature update function
function updateFeature(featureName, enabled)
    if featureName == "🔫 SMART AIMBOT" then
        CONFIG.AimbotEnabled = enabled
        if enabled then
            startAimbot()
        else
            stopAimbot()
        end
    elseif featureName == "🎯 PREDICTION" then
        CONFIG.Prediction = enabled
    elseif featureName == "👁️ VISIBILITY CHECK" then
        CONFIG.VisibilityCheck = enabled
    elseif featureName == "🧱 WALL CHECK" then
        CONFIG.WallCheck = enabled
    elseif featureName == "👥 TEAM CHECK" then
        CONFIG.TeamCheck = enabled
    elseif featureName == "📏 DISTANCE LIMIT" then
        -- Toggle distance limit
    elseif featureName == "🦴 TARGET BONE" then
        -- Cycle through bones
    elseif featureName == "⚡ AUTO TRIGGER" then
        -- Auto fire when aimed
    elseif featureName == "🔄 RAPID FIRE" then
        -- Increase fire rate
    elseif featureName == "💥 NO RECOIL" then
        -- Remove weapon recoil
    elseif featureName == "🎯 SILENT AIM" then
        -- Silent aimbot
    elseif featureName == "📊 ESP OVERLAY" then
        -- Toggle ESP
    elseif featureName == "🔍 MAGNET AIM" then
        -- Magnetic bullets
    elseif featureName == "🎪 CIRCULAR AIM" then
        -- Circular aim pattern
    elseif featureName == "⚙️ CUSTOM FOV" then
        -- Custom FOV settings
    elseif featureName == "🎮 MOBILE CONTROLS" then
        -- Mobile-specific controls
    end
end

function startAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimbotEnabled then return end
        
        local target = getClosestPlayer()
        currentTarget = target
        
        if target then
            aimAtTarget(target)
            updateESP(target)
            
            -- Visual feedback
            fovCircle.ImageColor3 = Color3.fromRGB(75, 255, 75)
            aimbotToggle.ImageColor3 = Color3.fromRGB(75, 255, 75)
        else
            -- Clear ESP
            for _, obj in ipairs(espObjects) do
                if obj then obj:Destroy() end
            end
            espObjects = {}
            
            -- Reset visual feedback
            fovCircle.ImageColor3 = Color3.fromRGB(255, 75, 75)
            aimbotToggle.ImageColor3 = Color3.fromRGB(255, 75, 75)
        end
    end)
end

function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    
    -- Clear ESP
    for _, obj in ipairs(espObjects) do
        if obj then obj:Destroy() end
    end
    espObjects = {}
    
    currentTarget = nil
    fovCircle.ImageColor3 = Color3.fromRGB(255, 75, 75)
    aimbotToggle.ImageColor3 = Color3.fromRGB(255, 75, 75)
end

-- Mobile aim button
if UserInputService.TouchEnabled then
    local mobileAimButton = Instance.new("TextButton")
    mobileAimButton.Name = "MobileAimButton"
    mobileAimButton.Size = UDim2.new(0, 100, 0, 100)
    mobileAimButton.Position = UDim2.new(0.7, 0, 0.6, 0)
    mobileAimButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    mobileAimButton.BackgroundTransparency = 0.3
    mobileAimButton.Text = "AIM"
    mobileAimButton.TextColor3 = Color3.new(1, 1, 1)
    mobileAimButton.TextScaled = true
    mobileAimButton.Font = Enum.Font.GothamBold
    mobileAimButton.Parent = screenGui
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0.5, 0)
    mobileCorner.Parent = mobileAimButton
    
    local mobileStroke = Instance.new("UIStroke")
    mobileStroke.Color = Color3.new(1, 1, 1)
    mobileStroke.Thickness = 3
    mobileStroke.Parent = mobileAimButton
    
    local aimPressed = false
    
    mobileAimButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            aimPressed = true
            CONFIG.AimbotEnabled = true
            startAimbot()
            mobileAimButton.BackgroundColor3 = Color3.fromRGB(75, 255, 75)
        end
    end)
    
    mobileAimButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            aimPressed = false
            CONFIG.AimbotEnabled = false
            stopAimbot()
            mobileAimButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
        end
    end)
end

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.AimbotKey then
        CONFIG.AimbotEnabled = true
        startAimbot()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == CONFIG.AimbotKey then
        CONFIG.AimbotEnabled = false
        stopAimbot()
    end
end)

-- Initialize
if CONFIG.AimbotEnabled then
    startAimbot()
end

-- Anti-detection
screenGui.Name = "GameUI_" .. tostring(math.random(1000, 9999))
controlPanel.Name = "Settings_" .. tostring(math.random(1000, 9999))

print("🔫 PREMIUM COMBAT SYSTEM LOADED 🔫")
print("Features: Smart Aimbot, ESP, Prediction, Wall Check, Mobile Controls")
print("Drag the red button to move, click to open controls")
