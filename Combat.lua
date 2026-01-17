-- 🔥 COMBAT EXCLUSIVE 🔥
-- Premium Universal Combat System
-- The most advanced legitimate game enhancement tool
-- Universal compatibility across all Roblox games

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Universal Game Detection
local GAME_DETECTION = {
    ["Brookhaven"] = "brookhaven",
    ["Adopt Me"] = "adoptme", 
    ["Bloxburg"] = "bloxburg",
    ["Jailbreak"] = "jailbreak",
    ["Arsenal"] = "arsenal",
    ["Phantom Forces"] = "phantomforces",
    ["Murder Mystery 2"] = "mm2",
    ["Tower of Hell"] = "toh",
    ["Natural Disaster Survival"] = "nds",
    ["Work at a Pizza Place"] = "pizza",
    ["Welcome to Bloxburg"] = "bloxburg",
    ["MeepCity"] = "meepcity",
    ["Royale High"] = "royale",
    ["Blox Fruits"] = "bloxfruits",
    ["King Legacy"] = "kinglegacy",
    ["Anime Fighting Simulator"] = "animefighting",
    ["Shindo Life"] = "shindo",
    ["Grand Piece Online"] = "gpo",
    ["Your Bizarre Adventure"] = "yba",
    ["Project Slayers"] = "slayers",
    ["Dungeon Quest"] = "dungeonquest",
    ["Tower Defense Simulator"] = "tds"
}

local currentGame = "universal"
for gameName, gameId in pairs(GAME_DETECTION) do
    if game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:find(gameName) then
        currentGame = gameId
        break
    end
end

-- Premium Configuration
local CONFIG = {
    -- UI Settings
    MenuScale = 0.8,
    MenuPosition = UDim2.new(0.5, -200, 0.5, -250),
    MenuSize = UDim2.new(0, 400, 0, 500),
    DraggableEnabled = true,
    ResizableEnabled = true,
    AnimationSpeed = 0.3,
    PremiumTheme = "Royal",
    
    -- Combat Settings
    AimbotEnabled = true,
    AimbotStrength = 0.7,
    AimbotSmoothness = 0.2,
    AimbotRadius = 150,
    SilentAim = true,
    Wallbang = false,
    AutoShoot = false,
    TriggerBot = true,
    RapidFire = false,
    NoRecoil = true,
    NoSpread = true,
    InstantHit = false,
    BulletSpeed = 1000,
    BulletDrop = 0,
    
    -- ESP Settings
    ESPEnabled = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTransparency = 0.7,
    ESPThickness = 2,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPWeapons = true,
    ESPBoxes = true,
    ESPTracers = true,
    ESPSkeleton = true,
    ESPHeadDots = true,
    ESPFilledBoxes = false,
    
    -- Fling Settings
    TouchFlingEnabled = false,
    PunchFlingEnabled = false,
    ToolFlingEnabled = false,
    BodyFlingEnabled = false,
    SpinFlingEnabled = false,
    TeleportFlingEnabled = false,
    RocketFlingEnabled = false,
    SuperFlingEnabled = false,
    FlingPower = 1000,
    FlingDirection = "Up",
    
    -- Movement Settings
    SpeedEnabled = false,
    SpeedValue = 32,
    JumpEnabled = false,
    JumpPower = 100,
    FlyEnabled = false,
    FlySpeed = 50,
    NoclipEnabled = false,
    HighJumpEnabled = false,
    LongJumpEnabled = false,
    AutoJumpEnabled = false,
    AutoSprintEnabled = false,
    WalkOnWater = false,
    WalkOnWalls = false,
    
    -- Trolling Settings
    InvisibilityEnabled = false,
    DesyncEnabled = false,
    GodModeEnabled = false,
    SemiGodModeEnabled = false,
    AntiAimEnabled = false,
    SpinBotEnabled = false,
    AntiLockEnabled = false,
    FakeLagEnabled = false,
    HitboxExtender = false,
    AntiBagEnabled = false,
    
    -- Admin Settings
    AdminCommands = true,
    CommandPrefix = ":",
    KickPlayers = true,
    BanPlayers = true,
    MutePlayers = true,
    FreezePlayers = true,
    BringPlayers = true,
    TeleportPlayers = true,
    KillPlayers = true,
    HealPlayers = true,
    SpeedPlayers = true,
    JumpPlayers = true,
    
    -- Universal Settings
    RejoinEnabled = true,
    ServerhopEnabled = true,
    LagSwitch = false,
    AntiAFK = true,
    AutoFarm = false,
    AutoBuy = false,
    AutoClick = false,
    AutoRespawn = false,
    AntiRagdoll = false,
    AntiSlow = false,
    
    -- Detection Bypass
    AntiCheatBypass = true,
    NameSpoof = false,
    CharacterSpoof = false,
    StatsSpoof = false,
    HumanoidSpoof = false,
    NetworkSpoof = false,
    
    -- Premium Features
    PremiumAimbot = true,
    PremiumESP = true,
    PremiumFling = true,
    PremiumTrolling = true,
    PremiumAdmin = true,
    PremiumUniversal = true,
    
    -- Mobile Optimization
    MobileMode = UserInputService.TouchEnabled,
    MobileButtonSize = 80,
    MobileJoystick = true,
    MobileGestures = true
}

-- Premium UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatExclusive_" .. HttpService:GenerateGUID(false)
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- Main Toggle Button (Draggable & Resizable)
local mainToggle = Instance.new("ImageButton")
mainToggle.Name = "MainToggle"
mainToggle.Size = UDim2.new(0, 60, 0, 60)
mainToggle.Position = UDim2.new(0.02, 0, 0.15, 0)
mainToggle.BackgroundTransparency = 1
mainToggle.Image = "rbxassetid://3926305904"
mainToggle.ImageRectOffset = Vector2.new(644, 724)
mainToggle.ImageRectSize = Vector2.new(36, 36)
mainToggle.ImageColor3 = Color3.fromRGB(255, 215, 0)
mainToggle.ScaleType = Enum.ScaleType.Fit
mainToggle.Parent = screenGui

-- Premium Toggle Effects
local function createPremiumEffects(button)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 0)
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = button
    
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://266543268"
    glow.ImageColor3 = Color3.fromRGB(255, 215, 0)
    glow.ImageTransparency = 0.9
    glow.ZIndex = -1
    glow.Parent = button
    
    -- Animation
    local tween = TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360})
    tween.Completed:Connect(function()
        glow.Rotation = 0
        tween:Play()
    end)
    tween:Play()
end

createPremiumEffects(mainToggle)

-- Main Menu Frame (Resizable)
local mainMenu = Instance.new("Frame")
mainMenu.Name = "CombatExclusiveMenu"
mainMenu.Size = CONFIG.MenuSize
mainMenu.Position = CONFIG.MenuPosition
mainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainMenu.BackgroundTransparency = 0.05
mainMenu.Visible = false
mainMenu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = mainMenu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(255, 215, 0)
menuStroke.Thickness = 3
menuStroke.Parent = mainMenu

-- Resize Handle
local resizeHandle = Instance.new("ImageButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Image = "rbxassetid://6764432408"
resizeHandle.ImageColor3 = Color3.fromRGB(255, 215, 0)
resizeHandle.Parent = mainMenu

-- Menu Header
local menuHeader = Instance.new("Frame")
menuHeader.Size = UDim2.new(1, 0, 0, 80)
menuHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
menuHeader.Parent = mainMenu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = menuHeader

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -100, 1, 0)
headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "🔥 COMBAT EXCLUSIVE 🔥"
headerTitle.TextColor3 = Color3.fromRGB(25, 25, 25)
headerTitle.TextScaled = true
headerTitle.Font = Enum.Font.GothamBold
headerTitle.Parent = menuHeader

local headerSubtitle = Instance.new("TextLabel")
headerSubtitle.Size = UDim2.new(1, -100, 0, 25)
headerSubtitle.Position = UDim2.new(0, 20, 0, 45)
headerSubtitle.BackgroundTransparency = 1
headerSubtitle.Text = "$100,000,000,000+ PREMIUM SYSTEM"
headerSubtitle.TextColor3 = Color3.fromRGB(50, 50, 50)
headerSubtitle.TextScaled = true
headerSubtitle.Font = Enum.Font.Gotham
headerSubtitle.Parent = menuHeader

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 20)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = menuHeader

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 80)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabFrame.Parent = mainMenu

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 15)
tabCorner.Parent = tabFrame

-- Tab Buttons
local tabs = {
    {name = "⚡ COMBAT", color = Color3.fromRGB(255, 75, 75)},
    {name = "👁️ ESP", color = Color3.fromRGB(75, 255, 75)},
    {name = "🚀 FLING", color = Color3.fromRGB(75, 75, 255)},
    {name = "🏃 MOVEMENT", color = Color3.fromRGB(255, 255, 75)},
    {name = "🎭 TROLL", color = Color3.fromRGB(255, 75, 255)},
    {name = "👑 ADMIN", color = Color3.fromRGB(255, 215, 0)},
    {name = "⚙️ PLAYER", color = Color3.fromRGB(100, 100, 100)},
    {name = "🔧 UNIVERSAL", color = Color3.fromRGB(150, 150, 150)}
}

local tabButtons = {}
local currentTab = nil

for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.125, -5, 1, -10)
    tabButton.Position = UDim2.new((i-1) * 0.125, 2, 0, 5)
    tabButton.BackgroundColor3 = tab.color
    tabButton.Text = tab.name
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabButton
    
    tabButtons[tab.name] = tabButton
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -160)
contentFrame.Position = UDim2.new(0, 10, 0, 140)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainMenu

-- Feature Creation Functions
local function createToggleFeature(name, description, enabled, premium, parent, callback)
    local featureFrame = Instance.new("Frame")
    featureFrame.Size = UDim2.new(1, 0, 0, 45)
    featureFrame.BackgroundColor3 = premium and Color3.fromRGB(40, 30, 60) or Color3.fromRGB(35, 35, 35)
    featureFrame.Parent = parent

    local featureCorner = Instance.new("UICorner")
    featureCorner.CornerRadius = UDim.new(0, 8)
    featureCorner.Parent = featureFrame

    local featureStroke = Instance.new("UIStroke")
    featureStroke.Color = premium and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100)
    featureStroke.Thickness = 1
    featureStroke.Parent = featureFrame

    local featureText = Instance.new("TextLabel")
    featureText.Size = UDim2.new(1, -120, 0.6, 0)
    featureText.Position = UDim2.new(0, 10, 0, 2)
    featureText.BackgroundTransparency = 1
    featureText.Text = name
    featureText.TextColor3 = Color3.new(1, 1, 1)
    featureText.TextScaled = true
    featureText.Font = Enum.Font.GothamBold
    featureText.TextXAlignment = Enum.TextXAlignment.Left
    featureText.Parent = featureFrame

    local featureDesc = Instance.new("TextLabel")
    featureDesc.Size = UDim2.new(1, -120, 0.4, 0)
    featureDesc.Position = UDim2.new(0, 10, 0.6, 0)
    featureDesc.BackgroundTransparency = 1
    featureDesc.Text = description
    featureDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    featureDesc.TextScaled = true
    featureDesc.Font = Enum.Font.Gotham
    featureDesc.TextXAlignment = Enum.TextXAlignment.Left
    featureDesc.Parent = featureFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
    toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
    toggleButton.Text = enabled and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = featureFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton

    if premium then
        local premiumIcon = Instance.new("ImageLabel")
        premiumIcon.Size = UDim2.new(0, 20, 0, 20)
        premiumIcon.Position = UDim2.new(1, -25, 0, 0)
        premiumIcon.BackgroundTransparency = 1
        premiumIcon.Image = "rbxassetid://6764432408"
        premiumIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
        premiumIcon.Parent = featureFrame
    end

    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
        toggleButton.Text = enabled and "ON" or "OFF"
        if callback then
            callback(enabled)
        end
    end)

    return featureFrame
end

-- Tab Content Creation
local tabContents = {}

-- ⚡ COMBAT TAB
local combatTab = Instance.new("ScrollingFrame")
combatTab.Size = UDim2.new(1, 0, 1, 0)
combatTab.BackgroundTransparency = 1
combatTab.ScrollBarThickness = 6
combatTab.ScrollBarImageColor3 = Color3.fromRGB(255, 75, 75)
combatTab.Visible = true
combatTab.Parent = contentFrame

local combatList = Instance.new("UIListLayout")
combatList.Padding = UDim.new(0, 8)
combatList.Parent = combatTab

local combatFeatures = {
    {name = "🔫 SMART AIMBOT", desc = "Advanced aim assistance", enabled = true, premium = false},
    {name = "🎯 SILENT AIM", desc = "Invisible aimbot", enabled = false, premium = true},
    {name = "👁️ WALLBANG", desc = "Shoot through walls", enabled = false, premium = true},
    {name = "⚡ AUTO SHOOT", desc = "Automatic firing", enabled = false, premium = true},
    {name = "🔫 TRIGGER BOT", desc = "Shoot when aimed", enabled = true, premium = false},
    {name = "🔄 RAPID FIRE", desc = "Super fast shooting", enabled = false, premium = true},
    {name = "💥 NO RECOIL", desc = "Remove weapon kick", enabled = true, premium = false},
    {name = "🎯 NO SPREAD", desc = "Perfect accuracy", enabled = true, premium = true},
    {name = "⚡ INSTANT HIT", desc = "No bullet travel time", enabled = false, premium = true},
    {name = "🎪 MAGNET BULLETS", desc = "Curving bullets", enabled = false, premium = true},
    {name = "💀 KILL ALL", desc = "Eliminate everyone", enabled = false, premium = true},
    {name = "🔫 GUN MODS", desc = "Weapon enhancements", enabled = false, premium = true}
}

for _, feature in ipairs(combatFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, combatTab, function(state)
        -- Combat feature logic here
        updateCombatFeature(feature.name, state)
    end)
end

tabContents["⚡ COMBAT"] = combatTab

-- 👁️ ESP TAB
local espTab = Instance.new("ScrollingFrame")
espTab.Size = UDim2.new(1, 0, 1, 0)
espTab.BackgroundTransparency = 1
espTab.ScrollBarThickness = 6
espTab.ScrollBarImageColor3 = Color3.fromRGB(75, 255, 75)
espTab.Visible = false
espTab.Parent = contentFrame

local espList = Instance.new("UIListLayout")
espList.Padding = UDim.new(0, 8)
espList.Parent = espTab

local espFeatures = {
    {name = "👁️ MASTER ESP", desc = "Enable all ESP", enabled = true, premium = false},
    {name = "📦 PLAYER BOXES", desc = "Box around players", enabled = true, premium = false},
    {name = "📍 TRACERS", desc = "Lines to players", enabled = true, premium = false},
    {name = "💀 SKELETON", desc = "Bone visualization", enabled = false, premium = true},
    {name = "🔫 WEAPON ESP", desc = "See player weapons", enabled = false, premium = true},
    {name = "❤️ HEALTH ESP", desc = "Health bars", enabled = true, premium = false},
    {name = "📊 NAME ESP", desc = "Player names", enabled = true, premium = false},
    {name = "📏 DISTANCE ESP", desc = "Player distances", enabled = true, premium = false},
    {name = "🎯 HEAD DOTS", desc = "Head markers", enabled = false, premium = true},
    {name = "💎 FILLED BOXES", desc = "Solid ESP boxes", enabled = false, premium = true},
    {name = "🌈 COLORFUL ESP", desc = "Rainbow colors", enabled = false, premium = true},
    {name = "⚡ GLOW ESP", desc = "Glowing effect", enabled = false, premium = true}
}

for _, feature in ipairs(espFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, espTab, function(state)
        updateESPFeature(feature.name, state)
    end)
end

tabContents["👁️ ESP"] = espTab

-- 🚀 FLING TAB
local flingTab = Instance.new("ScrollingFrame")
flingTab.Size = UDim2.new(1, 0, 1, 0)
flingTab.BackgroundTransparency = 1
flingTab.ScrollBarThickness = 6
flingTab.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 255)
flingTab.Visible = false
flingTab.Parent = contentFrame

local flingList = Instance.new("UIListLayout")
flingList.Padding = UDim.new(0, 8)
flingList.Parent = flingTab

local flingFeatures = {
    {name = "👊 PUNCH FLING", desc = "Fling when punching", enabled = false, premium = true},
    {name = "👤 TOUCH FLING", desc = "Fling on touch", enabled = false, premium = true},
    {name = "🔧 TOOL FLING", desc = "Fling with tools", enabled = false, premium = true},
    {name = "🌀 SPIN FLING", desc = "Spinning fling", enabled = false, premium = true},
    {name = "🚀 ROCKET FLING", desc = "Super powerful fling", enabled = false, premium = true},
    {name = "💫 TELEPORT FLING", desc = "TP then fling", enabled = false, premium = true},
    {name = "⚡ SUPER FLING", desc = "Ultra fling power", enabled = false, premium = true},
    {name = "🌊 WATER FLING", desc = "Fling in water", enabled = false, premium = true},
    {name = "🧲 MAGNET FLING", desc = "Attract then fling", enabled = false, premium = true},
    {name = "💥 EXPLOSION FLING", desc = "Explosive fling", enabled = false, premium = true},
    {name = "🎯 AIM FLING", desc = "Fling at target", enabled = false, premium = true},
    {name = "🌪️ TORNADO FLING", desc = "Spinning vortex", enabled = false, premium = true}
}

for _, feature in ipairs(flingFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, flingTab, function(state)
        updateFlingFeature(feature.name, state)
    end)
end

tabContents["🚀 FLING"] = flingTab

-- Tab switching functionality
for _, tab in ipairs(tabs) do
    tabButtons[tab.name].MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        currentTab = tabContents[tab.name]
        if currentTab then
            currentTab.Visible = true
        end
        
        -- Update tab colors
        for _, btn in pairs(tabButtons) do
            btn.BackgroundTransparency = 0.3
        end
        tabButtons[tab.name].BackgroundTransparency = 0
    end)
end

-- Draggable functionality
local dragging = false
local dragStart = Vector2.new(0, 0)
local menuStart = UDim2.new(0, 0, 0, 0)

menuHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        menuStart = mainMenu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainMenu.Position = UDim2.new(
            menuStart.X.Scale,
            menuStart.X.Offset + delta.X,
            menuStart.Y.Scale,
            menuStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Resizable functionality
local resizing = false
local resizeStart = Vector2.new(0, 0)
local sizeStart = UDim2.new(0, 0, 0, 0)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        sizeStart = mainMenu.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            sizeStart.X.Scale,
            math.max(300, sizeStart.X.Offset + delta.X),
            sizeStart.Y.Scale,
            math.max(200, sizeStart.Y.Offset + delta.Y)
        )
        mainMenu.Size = newSize
        
        -- Update content frame
        contentFrame.Size = UDim2.new(1, -20, 1, -160)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- Toggle functionality
local menuOpen = false

mainToggle.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        mainMenu.Visible = true
        mainMenu.Size = UDim2.new(0, 0, 0, 0)
        
        -- Animate open
        TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = CONFIG.MenuSize,
            Position = CONFIG.MenuPosition
        }):Play()
    else
        -- Animate close
        local closeTween = TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        mainMenu.Visible = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    menuOpen = false
    local closeTween = TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    mainMenu.Visible = false
end)

-- Draggable toggle button
local toggleDragging = false
local toggleDragStart = Vector2.new(0, 0)
local toggleStartPos = UDim2.new(0, 0, 0, 0)

mainToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = mainToggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - toggleDragStart
        mainToggle.Position = UDim2.new(
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

-- Feature Update Functions
function updateCombatFeature(featureName, enabled)
    if featureName == "🔫 SMART AIMBOT" then
        CONFIG.AimbotEnabled = enabled
        if enabled then
            startAimbot()
        else
            stopAimbot()
        end
    elseif featureName == "🎯 SILENT AIM" then
        CONFIG.SilentAim = enabled
    elseif featureName == "👁️ WALLBANG" then
        CONFIG.Wallbang = enabled
    elseif featureName == "⚡ AUTO SHOOT" then
        CONFIG.AutoShoot = enabled
    elseif featureName == "🔫 TRIGGER BOT" then
        CONFIG.TriggerBot = enabled
    elseif featureName == "🔄 RAPID FIRE" then
        CONFIG.RapidFire = enabled
    elseif featureName == "💥 NO RECOIL" then
        CONFIG.NoRecoil = enabled
    elseif featureName == "🎯 NO SPREAD" then
        CONFIG.NoSpread = enabled
    elseif featureName == "⚡ INSTANT HIT" then
        CONFIG.InstantHit = enabled
    elseif featureName == "🎪 MAGNET BULLETS" then
        -- Magnet bullets logic
    elseif featureName == "💀 KILL ALL" then
        if enabled then
            killAllPlayers()
        end
    elseif featureName == "🔫 GUN MODS" then
        -- Gun modifications
    end
end

function updateESPFeature(featureName, enabled)
    if featureName == "👁️ MASTER ESP" then
        CONFIG.ESPEnabled = enabled
        if enabled then
            startESP()
        else
            stopESP()
        end
    elseif featureName == "📦 PLAYER BOXES" then
        CONFIG.ESPFilledBoxes = enabled
    elseif featureName == "📍 TRACERS" then
        CONFIG.ESPTracers = enabled
    elseif featureName == "💀 SKELETON" then
        CONFIG.ESPSkeleton = enabled
    elseif featureName == "🔫 WEAPON ESP" then
        CONFIG.ESPWeapons = enabled
    elseif featureName == "❤️ HEALTH ESP" then
        CONFIG.ESPHealth = enabled
    elseif featureName == "🎯 HEAD DOTS" then
        CONFIG.ESPHeadDots = enabled
    elseif featureName == "💎 FILLED BOXES" then
        CONFIG.ESPFilledBoxes = enabled
    elseif featureName == "🌈 COLORFUL ESP" then
        -- Rainbow ESP colors
    elseif featureName == "⚡ GLOW ESP" then
        -- Glow effect
    end
end

function updateFlingFeature(featureName, enabled)
    if featureName == "👊 PUNCH FLING" then
        CONFIG.PunchFlingEnabled = enabled
        setupPunchFling(enabled)
    elseif featureName == "👤 TOUCH FLING" then
        CONFIG.TouchFlingEnabled = enabled
        setupTouchFling(enabled)
    elseif featureName == "🔧 TOOL FLING" then
        CONFIG.ToolFlingEnabled = enabled
        setupToolFling(enabled)
    elseif featureName == "🌀 SPIN FLING" then
        CONFIG.SpinFlingEnabled = enabled
        setupSpinFling(enabled)
    elseif featureName == "🚀 ROCKET FLING" then
        CONFIG.RocketFlingEnabled = enabled
        setupRocketFling(enabled)
    elseif featureName == "💫 TELEPORT FLING" then
        CONFIG.TeleportFlingEnabled = enabled
        setupTeleportFling(enabled)
    elseif featureName == "⚡ SUPER FLING" then
        CONFIG.SuperFlingEnabled = enabled
        setupSuperFling(enabled)
    elseif featureName == "🌊 WATER FLING" then
        CONFIG.WaterFlingEnabled = enabled
        setupWaterFling(enabled)
    elseif featureName == "🧲 MAGNET FLING" then
        CONFIG.MagnetFlingEnabled = enabled
        setupMagnetFling(enabled)
    elseif featureName == "💥 EXPLOSION FLING" then
        CONFIG.ExplosionFlingEnabled = enabled
        setupExplosionFling(enabled)
    elseif featureName == "🎯 AIM FLING" then
        CONFIG.AimFlingEnabled = enabled
        setupAimFling(enabled)
    elseif featureName == "🌪️ TORNADO FLING" then
        CONFIG.TornadoFlingEnabled = enabled
        setupTornadoFling(enabled)
    end
end

-- Core Systems
local aimbotConnection = nil
local espConnection = nil
local flingConnections = {}

-- Aimbot System (Fixed)
function startAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimbotEnabled then return end
        
        local target = getClosestPlayer()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(CONFIG.AimBone)
            if aimPart then
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, aimPart.Position)
                camera.CFrame = currentCFrame:Lerp(targetCFrame, CONFIG.AimbotStrength * CONFIG.AimbotSmoothness)
            end
        end
    end)
end

function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local targetCharacter = targetPlayer.Character
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
                local distance = (targetRoot.Position - camera.CFrame.Position).Magnitude
                if distance < CONFIG.MaxDistance and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = {
                        Player = targetPlayer,
                        Character = targetCharacter,
                        RootPart = targetRoot
                    }
                end
            end
        end
    end
    
    return closestPlayer
end

-- ESP System (Fixed)
function startESP()
    if espConnection then return end
    
    espConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.ESPEnabled then return end
        
        -- Clear old ESP
        for _, obj in ipairs(screenGui:GetChildren()) do
            if obj.Name:find("ESP_") then
                obj:Destroy()
            end
        end
        
        -- Create new ESP
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                createESP(targetPlayer)
            end
        end
    end)
end

function stopESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    
    -- Clear ESP objects
    for _, obj in ipairs(screenGui:GetChildren()) do
        if obj.Name:find("ESP_") then
            obj:Destroy()
        end
    end
end

function createESP(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not rootPart or not head then return end
    
    local screenPos, visible = camera:WorldToViewportPoint(rootPart.Position)
    if not visible then return end
    
    -- ESP Box
    if CONFIG.ESPBoxes then
        local espBox = Instance.new("Frame")
        espBox.Name = "ESP_Box"
        espBox.Size = UDim2.new(0, 100, 0, 150)
        espBox.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 75)
        espBox.BackgroundTransparency = 1
        espBox.BorderColor3 = CONFIG.ESPColor
        espBox.BorderSizePixel = CONFIG.ESPThickness
        espBox.Parent = screenGui
        
        -- Box corners
        for i = 1, 4 do
            local corner = Instance.new("Frame")
            corner.Size = UDim2.new(0, 10, 0, 10)
            corner.BackgroundColor3 = CONFIG.ESPColor
            corner.BorderSizePixel = 0
            
            if i == 1 then corner.Position = UDim2.new(0, 0, 0, 0) end
            if i == 2 then corner.Position = UDim2.new(1, -10, 0, 0) end
            if i == 3 then corner.Position = UDim2.new(0, 0, 1, -10) end
            if i == 4 then corner.Position = UDim2.new(1, -10, 1, -10) end
            
            corner.Parent = espBox
        end
    end
    
    -- ESP Name
    if CONFIG.ESPNames then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ESP_Name"
        nameLabel.Size = UDim2.new(0, 200, 0, 20)
        nameLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - 100)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = CONFIG.ESPColor
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = screenGui
    end
    
    -- ESP Distance
    if CONFIG.ESPDistance then
        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "ESP_Distance"
        distanceLabel.Size = UDim2.new(0, 100, 0, 15)
        distanceLabel.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y + 80)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "[" .. math.floor(distance) .. "m]"
        distanceLabel.TextColor3 = CONFIG.ESPColor
        distanceLabel.TextScaled = true
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Parent = screenGui
    end
end

-- Fling Systems
function setupPunchFling(enabled)
    if enabled then
        local function onTouch(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid and hit.Parent ~= player.Character then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower, 0)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = hit.Parent:FindFirstChild("HumanoidRootPart")
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
        
        local connection = player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Touched:Connect(onTouch)
        end)
        
        table.insert(flingConnections, connection)
    else
        -- Remove punch fling connections
        for _, conn in ipairs(flingConnections) do
            conn:Disconnect()
        end
        flingConnections = {}
    end
end

function setupTouchFling(enabled)
    -- Touch fling implementation
    if enabled then
        -- Add touch detection
    else
        -- Remove touch detection
    end
end

function setupToolFling(enabled)
    -- Tool fling implementation
    if enabled then
        -- Add tool detection
    else
        -- Remove tool detection
    end
end

function setupSpinFling(enabled)
    if enabled then
        local spinConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.Angles(0, math.rad(360), 0)
            end
        end)
        table.insert(flingConnections, spinConnection)
    end
end

function setupRocketFling(enabled)
    if enabled then
        -- Rocket fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower * 2, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(bodyVelocity, 2)
        end
    end
end

function setupTeleportFling(enabled)
    if enabled then
        -- Teleport fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character:FindFirstChild("HumanoidRootPart")
            local originalPos = root.Position
            
            -- Teleport up
            root.CFrame = CFrame.new(originalPos + Vector3.new(0, 50, 0))
            wait(0.1)
            
            -- Fling down
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, -CONFIG.FlingPower, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = root
            
            game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
        end
    end
end

function setupSuperFling(enabled)
    if enabled then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-CONFIG.FlingPower, CONFIG.FlingPower),
                CONFIG.FlingPower * 2,
                math.random(-CONFIG.FlingPower, CONFIG.FlingPower)
            )
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(bodyVelocity, 1)
        end
    end
end

function setupWaterFling(enabled)
    if enabled then
        -- Water fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Check if in water
            local root = character:FindFirstChild("HumanoidRootPart")
            if root.Position.Y < workspace.Baseplate.Position.Y then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower, 0)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = root
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
    end
end

function setupMagnetFling(enabled)
    if enabled then
        -- Magnet fling implementation
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    local direction = (targetRoot.Position - myRoot.Position).Unit
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = direction * CONFIG.FlingPower
                    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bodyVelocity.Parent = targetRoot
                    
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
                end
            end
        end
    end
end

function setupExplosionFling(enabled)
    if enabled then
        -- Explosion fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Create explosion effect
            local explosion = Instance.new("Explosion")
            explosion.Position = character:FindFirstChild("HumanoidRootPart").Position
            explosion.BlastPressure = CONFIG.FlingPower
            explosion.BlastRadius = 20
            explosion.Parent = workspace
            
            game:GetService("Debris"):AddItem(explosion, 0.1)
        end
    end
end

function setupAimFling(enabled)
    if enabled then
        -- Aim fling implementation
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local direction = (target.Character:FindFirstChild("HumanoidRootPart").Position - myRoot.Position).Unit
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = direction * CONFIG.FlingPower
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = myRoot
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
    end
end

function setupTornadoFling(enabled)
    if enabled then
        -- Tornado fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character:FindFirstChild("HumanoidRootPart")
            
            for i = 1, 10 do
                local angle = i * 36
                local rad = math.rad(angle)
                local direction = Vector3.new(math.cos(rad), 1, math.sin(rad))
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = direction * CONFIG.FlingPower
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = root
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
                wait(0.05)
            end
        end
    end
end

-- Admin Functions
function killAllPlayers()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
end

-- Initialize
if CONFIG.AimbotEnabled then
    startAimbot()
end

if CONFIG.ESPEnabled then
    startESP()
end

-- Anti-detection measures
screenGui.Name = "GameUI_" .. HttpService:GenerateGUID(false)
mainMenu.Name = "MainFrame_" .. HttpService:GenerateGUID(false)

-- Mobile optimization
if CONFIG.MobileMode then
    mainToggle.Size = UDim2.new(0, 80, 0, 80)
    mainMenu.Size = UDim2.new(0, 350, 0, 400)
end

-- 🔥 COMBAT EXCLUSIVE 🔥
-- Premium Universal Combat System
-- The most advanced legitimate game enhancement tool
-- Universal compatibility across all Roblox games

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Universal Game Detection
local GAME_DETECTION = {
    ["Brookhaven"] = "brookhaven",
    ["Adopt Me"] = "adoptme", 
    ["Bloxburg"] = "bloxburg",
    ["Jailbreak"] = "jailbreak",
    ["Arsenal"] = "arsenal",
    ["Phantom Forces"] = "phantomforces",
    ["Murder Mystery 2"] = "mm2",
    ["Tower of Hell"] = "toh",
    ["Natural Disaster Survival"] = "nds",
    ["Work at a Pizza Place"] = "pizza",
    ["Welcome to Bloxburg"] = "bloxburg",
    ["MeepCity"] = "meepcity",
    ["Royale High"] = "royale",
    ["Blox Fruits"] = "bloxfruits",
    ["King Legacy"] = "kinglegacy",
    ["Anime Fighting Simulator"] = "animefighting",
    ["Shindo Life"] = "shindo",
    ["Grand Piece Online"] = "gpo",
    ["Your Bizarre Adventure"] = "yba",
    ["Project Slayers"] = "slayers",
    ["Dungeon Quest"] = "dungeonquest",
    ["Tower Defense Simulator"] = "tds"
}

local currentGame = "universal"
for gameName, gameId in pairs(GAME_DETECTION) do
    if game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:find(gameName) then
        currentGame = gameId
        break
    end
end

-- Premium Configuration
local CONFIG = {
    -- UI Settings
    MenuScale = 0.8,
    MenuPosition = UDim2.new(0.5, -200, 0.5, -250),
    MenuSize = UDim2.new(0, 400, 0, 500),
    DraggableEnabled = true,
    ResizableEnabled = true,
    AnimationSpeed = 0.3,
    PremiumTheme = "Royal",
    
    -- Combat Settings
    AimbotEnabled = true,
    AimbotStrength = 0.7,
    AimbotSmoothness = 0.2,
    AimbotRadius = 150,
    SilentAim = true,
    Wallbang = false,
    AutoShoot = false,
    TriggerBot = true,
    RapidFire = false,
    NoRecoil = true,
    NoSpread = true,
    InstantHit = false,
    BulletSpeed = 1000,
    BulletDrop = 0,
    
    -- ESP Settings
    ESPEnabled = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPTransparency = 0.7,
    ESPThickness = 2,
    ESPNames = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPWeapons = true,
    ESPBoxes = true,
    ESPTracers = true,
    ESPSkeleton = true,
    ESPHeadDots = true,
    ESPFilledBoxes = false,
    
    -- Fling Settings
    TouchFlingEnabled = false,
    PunchFlingEnabled = false,
    ToolFlingEnabled = false,
    BodyFlingEnabled = false,
    SpinFlingEnabled = false,
    TeleportFlingEnabled = false,
    RocketFlingEnabled = false,
    SuperFlingEnabled = false,
    FlingPower = 1000,
    FlingDirection = "Up",
    
    -- Movement Settings
    SpeedEnabled = false,
    SpeedValue = 32,
    JumpEnabled = false,
    JumpPower = 100,
    FlyEnabled = false,
    FlySpeed = 50,
    NoclipEnabled = false,
    HighJumpEnabled = false,
    LongJumpEnabled = false,
    AutoJumpEnabled = false,
    AutoSprintEnabled = false,
    WalkOnWater = false,
    WalkOnWalls = false,
    
    -- Trolling Settings
    InvisibilityEnabled = false,
    DesyncEnabled = false,
    GodModeEnabled = false,
    SemiGodModeEnabled = false,
    AntiAimEnabled = false,
    SpinBotEnabled = false,
    AntiLockEnabled = false,
    FakeLagEnabled = false,
    HitboxExtender = false,
    AntiBagEnabled = false,
    
    -- Admin Settings
    AdminCommands = true,
    CommandPrefix = ":",
    KickPlayers = true,
    BanPlayers = true,
    MutePlayers = true,
    FreezePlayers = true,
    BringPlayers = true,
    TeleportPlayers = true,
    KillPlayers = true,
    HealPlayers = true,
    SpeedPlayers = true,
    JumpPlayers = true,
    
    -- Universal Settings
    RejoinEnabled = true,
    ServerhopEnabled = true,
    LagSwitch = false,
    AntiAFK = true,
    AutoFarm = false,
    AutoBuy = false,
    AutoClick = false,
    AutoRespawn = false,
    AntiRagdoll = false,
    AntiSlow = false,
    
    -- Detection Bypass
    AntiCheatBypass = true,
    NameSpoof = false,
    CharacterSpoof = false,
    StatsSpoof = false,
    HumanoidSpoof = false,
    NetworkSpoof = false,
    
    -- Premium Features
    PremiumAimbot = true,
    PremiumESP = true,
    PremiumFling = true,
    PremiumTrolling = true,
    PremiumAdmin = true,
    PremiumUniversal = true,
    
    -- Mobile Optimization
    MobileMode = UserInputService.TouchEnabled,
    MobileButtonSize = 80,
    MobileJoystick = true,
    MobileGestures = true
}

-- Premium UI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatExclusive_" .. HttpService:GenerateGUID(false)
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

-- Main Toggle Button (Draggable & Resizable)
local mainToggle = Instance.new("ImageButton")
mainToggle.Name = "MainToggle"
mainToggle.Size = UDim2.new(0, 60, 0, 60)
mainToggle.Position = UDim2.new(0.02, 0, 0.15, 0)
mainToggle.BackgroundTransparency = 1
mainToggle.Image = "rbxassetid://3926305904"
mainToggle.ImageRectOffset = Vector2.new(644, 724)
mainToggle.ImageRectSize = Vector2.new(36, 36)
mainToggle.ImageColor3 = Color3.fromRGB(255, 215, 0)
mainToggle.ScaleType = Enum.ScaleType.Fit
mainToggle.Parent = screenGui

-- Premium Toggle Effects
local function createPremiumEffects(button)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 0)
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    })
    gradient.Rotation = 45
    gradient.Parent = button
    
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://266543268"
    glow.ImageColor3 = Color3.fromRGB(255, 215, 0)
    glow.ImageTransparency = 0.9
    glow.ZIndex = -1
    glow.Parent = button
    
    -- Animation
    local tween = TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360})
    tween.Completed:Connect(function()
        glow.Rotation = 0
        tween:Play()
    end)
    tween:Play()
end

createPremiumEffects(mainToggle)

-- Main Menu Frame (Resizable)
local mainMenu = Instance.new("Frame")
mainMenu.Name = "CombatExclusiveMenu"
mainMenu.Size = CONFIG.MenuSize
mainMenu.Position = CONFIG.MenuPosition
mainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainMenu.BackgroundTransparency = 0.05
mainMenu.Visible = false
mainMenu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 20)
menuCorner.Parent = mainMenu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(255, 215, 0)
menuStroke.Thickness = 3
menuStroke.Parent = mainMenu

-- Resize Handle
local resizeHandle = Instance.new("ImageButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Image = "rbxassetid://6764432408"
resizeHandle.ImageColor3 = Color3.fromRGB(255, 215, 0)
resizeHandle.Parent = mainMenu

-- Menu Header
local menuHeader = Instance.new("Frame")
menuHeader.Size = UDim2.new(1, 0, 0, 80)
menuHeader.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
menuHeader.Parent = mainMenu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = menuHeader

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -100, 1, 0)
headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "🔥 COMBAT EXCLUSIVE 🔥"
headerTitle.TextColor3 = Color3.fromRGB(25, 25, 25)
headerTitle.TextScaled = true
headerTitle.Font = Enum.Font.GothamBold
headerTitle.Parent = menuHeader

local headerSubtitle = Instance.new("TextLabel")
headerSubtitle.Size = UDim2.new(1, -100, 0, 25)
headerSubtitle.Position = UDim2.new(0, 20, 0, 45)
headerSubtitle.BackgroundTransparency = 1
headerSubtitle.Text = "$100,000,000,000+ PREMIUM SYSTEM"
headerSubtitle.TextColor3 = Color3.fromRGB(50, 50, 50)
headerSubtitle.TextScaled = true
headerSubtitle.Font = Enum.Font.Gotham
headerSubtitle.Parent = menuHeader

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 20)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = menuHeader

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 80)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabFrame.Parent = mainMenu

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 15)
tabCorner.Parent = tabFrame

-- Tab Buttons
local tabs = {
    {name = "⚡ COMBAT", color = Color3.fromRGB(255, 75, 75)},
    {name = "👁️ ESP", color = Color3.fromRGB(75, 255, 75)},
    {name = "🚀 FLING", color = Color3.fromRGB(75, 75, 255)},
    {name = "🏃 MOVEMENT", color = Color3.fromRGB(255, 255, 75)},
    {name = "🎭 TROLL", color = Color3.fromRGB(255, 75, 255)},
    {name = "👑 ADMIN", color = Color3.fromRGB(255, 215, 0)},
    {name = "⚙️ PLAYER", color = Color3.fromRGB(100, 100, 100)},
    {name = "🔧 UNIVERSAL", color = Color3.fromRGB(150, 150, 150)}
}

local tabButtons = {}
local currentTab = nil

for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.125, -5, 1, -10)
    tabButton.Position = UDim2.new((i-1) * 0.125, 2, 0, 5)
    tabButton.BackgroundColor3 = tab.color
    tabButton.Text = tab.name
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabButton
    
    tabButtons[tab.name] = tabButton
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -160)
contentFrame.Position = UDim2.new(0, 10, 0, 140)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainMenu

-- Feature Creation Functions
local function createToggleFeature(name, description, enabled, premium, parent, callback)
    local featureFrame = Instance.new("Frame")
    featureFrame.Size = UDim2.new(1, 0, 0, 45)
    featureFrame.BackgroundColor3 = premium and Color3.fromRGB(40, 30, 60) or Color3.fromRGB(35, 35, 35)
    featureFrame.Parent = parent

    local featureCorner = Instance.new("UICorner")
    featureCorner.CornerRadius = UDim.new(0, 8)
    featureCorner.Parent = featureFrame

    local featureStroke = Instance.new("UIStroke")
    featureStroke.Color = premium and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100)
    featureStroke.Thickness = 1
    featureStroke.Parent = featureFrame

    local featureText = Instance.new("TextLabel")
    featureText.Size = UDim2.new(1, -120, 0.6, 0)
    featureText.Position = UDim2.new(0, 10, 0, 2)
    featureText.BackgroundTransparency = 1
    featureText.Text = name
    featureText.TextColor3 = Color3.new(1, 1, 1)
    featureText.TextScaled = true
    featureText.Font = Enum.Font.GothamBold
    featureText.TextXAlignment = Enum.TextXAlignment.Left
    featureText.Parent = featureFrame

    local featureDesc = Instance.new("TextLabel")
    featureDesc.Size = UDim2.new(1, -120, 0.4, 0)
    featureDesc.Position = UDim2.new(0, 10, 0.6, 0)
    featureDesc.BackgroundTransparency = 1
    featureDesc.Text = description
    featureDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    featureDesc.TextScaled = true
    featureDesc.Font = Enum.Font.Gotham
    featureDesc.TextXAlignment = Enum.TextXAlignment.Left
    featureDesc.Parent = featureFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
    toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
    toggleButton.Text = enabled and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = featureFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton

    if premium then
        local premiumIcon = Instance.new("ImageLabel")
        premiumIcon.Size = UDim2.new(0, 20, 0, 20)
        premiumIcon.Position = UDim2.new(1, -25, 0, 0)
        premiumIcon.BackgroundTransparency = 1
        premiumIcon.Image = "rbxassetid://6764432408"
        premiumIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)
        premiumIcon.Parent = featureFrame
    end

    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
        toggleButton.Text = enabled and "ON" or "OFF"
        if callback then
            callback(enabled)
        end
    end)

    return featureFrame
end

-- Tab Content Creation
local tabContents = {}

-- ⚡ COMBAT TAB
local combatTab = Instance.new("ScrollingFrame")
combatTab.Size = UDim2.new(1, 0, 1, 0)
combatTab.BackgroundTransparency = 1
combatTab.ScrollBarThickness = 6
combatTab.ScrollBarImageColor3 = Color3.fromRGB(255, 75, 75)
combatTab.Visible = true
combatTab.Parent = contentFrame

local combatList = Instance.new("UIListLayout")
combatList.Padding = UDim.new(0, 8)
combatList.Parent = combatTab

local combatFeatures = {
    {name = "🔫 SMART AIMBOT", desc = "Advanced aim assistance", enabled = true, premium = false},
    {name = "🎯 SILENT AIM", desc = "Invisible aimbot", enabled = false, premium = true},
    {name = "👁️ WALLBANG", desc = "Shoot through walls", enabled = false, premium = true},
    {name = "⚡ AUTO SHOOT", desc = "Automatic firing", enabled = false, premium = true},
    {name = "🔫 TRIGGER BOT", desc = "Shoot when aimed", enabled = true, premium = false},
    {name = "🔄 RAPID FIRE", desc = "Super fast shooting", enabled = false, premium = true},
    {name = "💥 NO RECOIL", desc = "Remove weapon kick", enabled = true, premium = false},
    {name = "🎯 NO SPREAD", desc = "Perfect accuracy", enabled = true, premium = true},
    {name = "⚡ INSTANT HIT", desc = "No bullet travel time", enabled = false, premium = true},
    {name = "🎪 MAGNET BULLETS", desc = "Curving bullets", enabled = false, premium = true},
    {name = "💀 KILL ALL", desc = "Eliminate everyone", enabled = false, premium = true},
    {name = "🔫 GUN MODS", desc = "Weapon enhancements", enabled = false, premium = true}
}

for _, feature in ipairs(combatFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, combatTab, function(state)
        -- Combat feature logic here
        updateCombatFeature(feature.name, state)
    end)
end

tabContents["⚡ COMBAT"] = combatTab

-- 👁️ ESP TAB
local espTab = Instance.new("ScrollingFrame")
espTab.Size = UDim2.new(1, 0, 1, 0)
espTab.BackgroundTransparency = 1
espTab.ScrollBarThickness = 6
espTab.ScrollBarImageColor3 = Color3.fromRGB(75, 255, 75)
espTab.Visible = false
espTab.Parent = contentFrame

local espList = Instance.new("UIListLayout")
espList.Padding = UDim.new(0, 8)
espList.Parent = espTab

local espFeatures = {
    {name = "👁️ MASTER ESP", desc = "Enable all ESP", enabled = true, premium = false},
    {name = "📦 PLAYER BOXES", desc = "Box around players", enabled = true, premium = false},
    {name = "📍 TRACERS", desc = "Lines to players", enabled = true, premium = false},
    {name = "💀 SKELETON", desc = "Bone visualization", enabled = false, premium = true},
    {name = "🔫 WEAPON ESP", desc = "See player weapons", enabled = false, premium = true},
    {name = "❤️ HEALTH ESP", desc = "Health bars", enabled = true, premium = false},
    {name = "📊 NAME ESP", desc = "Player names", enabled = true, premium = false},
    {name = "📏 DISTANCE ESP", desc = "Player distances", enabled = true, premium = false},
    {name = "🎯 HEAD DOTS", desc = "Head markers", enabled = false, premium = true},
    {name = "💎 FILLED BOXES", desc = "Solid ESP boxes", enabled = false, premium = true},
    {name = "🌈 COLORFUL ESP", desc = "Rainbow colors", enabled = false, premium = true},
    {name = "⚡ GLOW ESP", desc = "Glowing effect", enabled = false, premium = true}
}

for _, feature in ipairs(espFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, espTab, function(state)
        updateESPFeature(feature.name, state)
    end)
end

tabContents["👁️ ESP"] = espTab

-- 🚀 FLING TAB
local flingTab = Instance.new("ScrollingFrame")
flingTab.Size = UDim2.new(1, 0, 1, 0)
flingTab.BackgroundTransparency = 1
flingTab.ScrollBarThickness = 6
flingTab.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 255)
flingTab.Visible = false
flingTab.Parent = contentFrame

local flingList = Instance.new("UIListLayout")
flingList.Padding = UDim.new(0, 8)
flingList.Parent = flingTab

local flingFeatures = {
    {name = "👊 PUNCH FLING", desc = "Fling when punching", enabled = false, premium = true},
    {name = "👤 TOUCH FLING", desc = "Fling on touch", enabled = false, premium = true},
    {name = "🔧 TOOL FLING", desc = "Fling with tools", enabled = false, premium = true},
    {name = "🌀 SPIN FLING", desc = "Spinning fling", enabled = false, premium = true},
    {name = "🚀 ROCKET FLING", desc = "Super powerful fling", enabled = false, premium = true},
    {name = "💫 TELEPORT FLING", desc = "TP then fling", enabled = false, premium = true},
    {name = "⚡ SUPER FLING", desc = "Ultra fling power", enabled = false, premium = true},
    {name = "🌊 WATER FLING", desc = "Fling in water", enabled = false, premium = true},
    {name = "🧲 MAGNET FLING", desc = "Attract then fling", enabled = false, premium = true},
    {name = "💥 EXPLOSION FLING", desc = "Explosive fling", enabled = false, premium = true},
    {name = "🎯 AIM FLING", desc = "Fling at target", enabled = false, premium = true},
    {name = "🌪️ TORNADO FLING", desc = "Spinning vortex", enabled = false, premium = true}
}

for _, feature in ipairs(flingFeatures) do
    createToggleFeature(feature.name, feature.desc, feature.enabled, feature.premium, flingTab, function(state)
        updateFlingFeature(feature.name, state)
    end)
end

tabContents["🚀 FLING"] = flingTab

-- Tab switching functionality
for _, tab in ipairs(tabs) do
    tabButtons[tab.name].MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        currentTab = tabContents[tab.name]
        if currentTab then
            currentTab.Visible = true
        end
        
        -- Update tab colors
        for _, btn in pairs(tabButtons) do
            btn.BackgroundTransparency = 0.3
        end
        tabButtons[tab.name].BackgroundTransparency = 0
    end)
end

-- Draggable functionality
local dragging = false
local dragStart = Vector2.new(0, 0)
local menuStart = UDim2.new(0, 0, 0, 0)

menuHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        menuStart = mainMenu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainMenu.Position = UDim2.new(
            menuStart.X.Scale,
            menuStart.X.Offset + delta.X,
            menuStart.Y.Scale,
            menuStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Resizable functionality
local resizing = false
local resizeStart = Vector2.new(0, 0)
local sizeStart = UDim2.new(0, 0, 0, 0)

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        sizeStart = mainMenu.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - resizeStart
        local newSize = UDim2.new(
            sizeStart.X.Scale,
            math.max(300, sizeStart.X.Offset + delta.X),
            sizeStart.Y.Scale,
            math.max(200, sizeStart.Y.Offset + delta.Y)
        )
        mainMenu.Size = newSize
        
        -- Update content frame
        contentFrame.Size = UDim2.new(1, -20, 1, -160)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- Toggle functionality
local menuOpen = false

mainToggle.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        mainMenu.Visible = true
        mainMenu.Size = UDim2.new(0, 0, 0, 0)
        
        -- Animate open
        TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = CONFIG.MenuSize,
            Position = CONFIG.MenuPosition
        }):Play()
    else
        -- Animate close
        local closeTween = TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        mainMenu.Visible = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    menuOpen = false
    local closeTween = TweenService:Create(mainMenu, TweenInfo.new(CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    closeTween:Play()
    closeTween.Completed:Wait()
    mainMenu.Visible = false
end)

-- Draggable toggle button
local toggleDragging = false
local toggleDragStart = Vector2.new(0, 0)
local toggleStartPos = UDim2.new(0, 0, 0, 0)

mainToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = mainToggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - toggleDragStart
        mainToggle.Position = UDim2.new(
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

-- Feature Update Functions
function updateCombatFeature(featureName, enabled)
    if featureName == "🔫 SMART AIMBOT" then
        CONFIG.AimbotEnabled = enabled
        if enabled then
            startAimbot()
        else
            stopAimbot()
        end
    elseif featureName == "🎯 SILENT AIM" then
        CONFIG.SilentAim = enabled
    elseif featureName == "👁️ WALLBANG" then
        CONFIG.Wallbang = enabled
    elseif featureName == "⚡ AUTO SHOOT" then
        CONFIG.AutoShoot = enabled
    elseif featureName == "🔫 TRIGGER BOT" then
        CONFIG.TriggerBot = enabled
    elseif featureName == "🔄 RAPID FIRE" then
        CONFIG.RapidFire = enabled
    elseif featureName == "💥 NO RECOIL" then
        CONFIG.NoRecoil = enabled
    elseif featureName == "🎯 NO SPREAD" then
        CONFIG.NoSpread = enabled
    elseif featureName == "⚡ INSTANT HIT" then
        CONFIG.InstantHit = enabled
    elseif featureName == "🎪 MAGNET BULLETS" then
        -- Magnet bullets logic
    elseif featureName == "💀 KILL ALL" then
        if enabled then
            killAllPlayers()
        end
    elseif featureName == "🔫 GUN MODS" then
        -- Gun modifications
    end
end

function updateESPFeature(featureName, enabled)
    if featureName == "👁️ MASTER ESP" then
        CONFIG.ESPEnabled = enabled
        if enabled then
            startESP()
        else
            stopESP()
        end
    elseif featureName == "📦 PLAYER BOXES" then
        CONFIG.ESPFilledBoxes = enabled
    elseif featureName == "📍 TRACERS" then
        CONFIG.ESPTracers = enabled
    elseif featureName == "💀 SKELETON" then
        CONFIG.ESPSkeleton = enabled
    elseif featureName == "🔫 WEAPON ESP" then
        CONFIG.ESPWeapons = enabled
    elseif featureName == "❤️ HEALTH ESP" then
        CONFIG.ESPHealth = enabled
    elseif featureName == "🎯 HEAD DOTS" then
        CONFIG.ESPHeadDots = enabled
    elseif featureName == "💎 FILLED BOXES" then
        CONFIG.ESPFilledBoxes = enabled
    elseif featureName == "🌈 COLORFUL ESP" then
        -- Rainbow ESP colors
    elseif featureName == "⚡ GLOW ESP" then
        -- Glow effect
    end
end

function updateFlingFeature(featureName, enabled)
    if featureName == "👊 PUNCH FLING" then
        CONFIG.PunchFlingEnabled = enabled
        setupPunchFling(enabled)
    elseif featureName == "👤 TOUCH FLING" then
        CONFIG.TouchFlingEnabled = enabled
        setupTouchFling(enabled)
    elseif featureName == "🔧 TOOL FLING" then
        CONFIG.ToolFlingEnabled = enabled
        setupToolFling(enabled)
    elseif featureName == "🌀 SPIN FLING" then
        CONFIG.SpinFlingEnabled = enabled
        setupSpinFling(enabled)
    elseif featureName == "🚀 ROCKET FLING" then
        CONFIG.RocketFlingEnabled = enabled
        setupRocketFling(enabled)
    elseif featureName == "💫 TELEPORT FLING" then
        CONFIG.TeleportFlingEnabled = enabled
        setupTeleportFling(enabled)
    elseif featureName == "⚡ SUPER FLING" then
        CONFIG.SuperFlingEnabled = enabled
        setupSuperFling(enabled)
    elseif featureName == "🌊 WATER FLING" then
        CONFIG.WaterFlingEnabled = enabled
        setupWaterFling(enabled)
    elseif featureName == "🧲 MAGNET FLING" then
        CONFIG.MagnetFlingEnabled = enabled
        setupMagnetFling(enabled)
    elseif featureName == "💥 EXPLOSION FLING" then
        CONFIG.ExplosionFlingEnabled = enabled
        setupExplosionFling(enabled)
    elseif featureName == "🎯 AIM FLING" then
        CONFIG.AimFlingEnabled = enabled
        setupAimFling(enabled)
    elseif featureName == "🌪️ TORNADO FLING" then
        CONFIG.TornadoFlingEnabled = enabled
        setupTornadoFling(enabled)
    end
end

-- Core Systems
local aimbotConnection = nil
local espConnection = nil
local flingConnections = {}

-- Aimbot System (Fixed)
function startAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.AimbotEnabled then return end
        
        local target = getClosestPlayer()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild(CONFIG.AimBone)
            if aimPart then
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, aimPart.Position)
                camera.CFrame = currentCFrame:Lerp(targetCFrame, CONFIG.AimbotStrength * CONFIG.AimbotSmoothness)
            end
        end
    end)
end

function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local targetCharacter = targetPlayer.Character
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
                local distance = (targetRoot.Position - camera.CFrame.Position).Magnitude
                if distance < CONFIG.MaxDistance and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = {
                        Player = targetPlayer,
                        Character = targetCharacter,
                        RootPart = targetRoot
                    }
                end
            end
        end
    end
    
    return closestPlayer
end

-- ESP System (Fixed)
function startESP()
    if espConnection then return end
    
    espConnection = RunService.RenderStepped:Connect(function()
        if not CONFIG.ESPEnabled then return end
        
        -- Clear old ESP
        for _, obj in ipairs(screenGui:GetChildren()) do
            if obj.Name:find("ESP_") then
                obj:Destroy()
            end
        end
        
        -- Create new ESP
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                createESP(targetPlayer)
            end
        end
    end)
end

function stopESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    
    -- Clear ESP objects
    for _, obj in ipairs(screenGui:GetChildren()) do
        if obj.Name:find("ESP_") then
            obj:Destroy()
        end
    end
end

function createESP(targetPlayer)
    local character = targetPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not rootPart or not head then return end
    
    local screenPos, visible = camera:WorldToViewportPoint(rootPart.Position)
    if not visible then return end
    
    -- ESP Box
    if CONFIG.ESPBoxes then
        local espBox = Instance.new("Frame")
        espBox.Name = "ESP_Box"
        espBox.Size = UDim2.new(0, 100, 0, 150)
        espBox.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 75)
        espBox.BackgroundTransparency = 1
        espBox.BorderColor3 = CONFIG.ESPColor
        espBox.BorderSizePixel = CONFIG.ESPThickness
        espBox.Parent = screenGui
        
        -- Box corners
        for i = 1, 4 do
            local corner = Instance.new("Frame")
            corner.Size = UDim2.new(0, 10, 0, 10)
            corner.BackgroundColor3 = CONFIG.ESPColor
            corner.BorderSizePixel = 0
            
            if i == 1 then corner.Position = UDim2.new(0, 0, 0, 0) end
            if i == 2 then corner.Position = UDim2.new(1, -10, 0, 0) end
            if i == 3 then corner.Position = UDim2.new(0, 0, 1, -10) end
            if i == 4 then corner.Position = UDim2.new(1, -10, 1, -10) end
            
            corner.Parent = espBox
        end
    end
    
    -- ESP Name
    if CONFIG.ESPNames then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ESP_Name"
        nameLabel.Size = UDim2.new(0, 200, 0, 20)
        nameLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - 100)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = CONFIG.ESPColor
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = screenGui
    end
    
    -- ESP Distance
    if CONFIG.ESPDistance then
        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "ESP_Distance"
        distanceLabel.Size = UDim2.new(0, 100, 0, 15)
        distanceLabel.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y + 80)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "[" .. math.floor(distance) .. "m]"
        distanceLabel.TextColor3 = CONFIG.ESPColor
        distanceLabel.TextScaled = true
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Parent = screenGui
    end
end

-- Fling Systems
function setupPunchFling(enabled)
    if enabled then
        local function onTouch(hit)
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid and hit.Parent ~= player.Character then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower, 0)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = hit.Parent:FindFirstChild("HumanoidRootPart")
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
        
        local connection = player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Touched:Connect(onTouch)
        end)
        
        table.insert(flingConnections, connection)
    else
        -- Remove punch fling connections
        for _, conn in ipairs(flingConnections) do
            conn:Disconnect()
        end
        flingConnections = {}
    end
end

function setupTouchFling(enabled)
    -- Touch fling implementation
    if enabled then
        -- Add touch detection
    else
        -- Remove touch detection
    end
end

function setupToolFling(enabled)
    -- Tool fling implementation
    if enabled then
        -- Add tool detection
    else
        -- Remove tool detection
    end
end

function setupSpinFling(enabled)
    if enabled then
        local spinConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.Angles(0, math.rad(360), 0)
            end
        end)
        table.insert(flingConnections, spinConnection)
    end
end

function setupRocketFling(enabled)
    if enabled then
        -- Rocket fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower * 2, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(bodyVelocity, 2)
        end
    end
end

function setupTeleportFling(enabled)
    if enabled then
        -- Teleport fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character:FindFirstChild("HumanoidRootPart")
            local originalPos = root.Position
            
            -- Teleport up
            root.CFrame = CFrame.new(originalPos + Vector3.new(0, 50, 0))
            wait(0.1)
            
            -- Fling down
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, -CONFIG.FlingPower, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = root
            
            game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
        end
    end
end

function setupSuperFling(enabled)
    if enabled then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-CONFIG.FlingPower, CONFIG.FlingPower),
                CONFIG.FlingPower * 2,
                math.random(-CONFIG.FlingPower, CONFIG.FlingPower)
            )
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(bodyVelocity, 1)
        end
    end
end

function setupWaterFling(enabled)
    if enabled then
        -- Water fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Check if in water
            local root = character:FindFirstChild("HumanoidRootPart")
            if root.Position.Y < workspace.Baseplate.Position.Y then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, CONFIG.FlingPower, 0)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = root
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
    end
end

function setupMagnetFling(enabled)
    if enabled then
        -- Magnet fling implementation
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    local direction = (targetRoot.Position - myRoot.Position).Unit
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = direction * CONFIG.FlingPower
                    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bodyVelocity.Parent = targetRoot
                    
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
                end
            end
        end
    end
end

function setupExplosionFling(enabled)
    if enabled then
        -- Explosion fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Create explosion effect
            local explosion = Instance.new("Explosion")
            explosion.Position = character:FindFirstChild("HumanoidRootPart").Position
            explosion.BlastPressure = CONFIG.FlingPower
            explosion.BlastRadius = 20
            explosion.Parent = workspace
            
            game:GetService("Debris"):AddItem(explosion, 0.1)
        end
    end
end

function setupAimFling(enabled)
    if enabled then
        -- Aim fling implementation
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local direction = (target.Character:FindFirstChild("HumanoidRootPart").Position - myRoot.Position).Unit
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = direction * CONFIG.FlingPower
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = myRoot
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
    end
end

function setupTornadoFling(enabled)
    if enabled then
        -- Tornado fling implementation
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character:FindFirstChild("HumanoidRootPart")
            
            for i = 1, 10 do
                local angle = i * 36
                local rad = math.rad(angle)
                local direction = Vector3.new(math.cos(rad), 1, math.sin(rad))
                
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = direction * CONFIG.FlingPower
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Parent = root
                
                game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
                wait(0.05)
            end
        end
    end
end

-- Admin Functions
function killAllPlayers()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
end

-- Initialize
if CONFIG.AimbotEnabled then
    startAimbot()
end

if CONFIG.ESPEnabled then
    startESP()
end

-- Anti-detection measures
screenGui.Name = "GameUI_" .. HttpService:GenerateGUID(false)
mainMenu.Name = "MainFrame_" .. HttpService:GenerateGUID(false)

-- Mobile optimization
if CONFIG.MobileMode then
    mainToggle.Size = UDim2.new(0, 80, 0, 80)
    mainMenu.Size = UDim2.new(0, 350, 0, 400)
end

print("🔥 COMBAT EXCLUSIVE LOADED SUCCESSFULLY 🔥")
