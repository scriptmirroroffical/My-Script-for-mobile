local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_System_Mobile_Optimized"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Hàm kéo thả giao diện (Hỗ trợ Touch mượt hơn)
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

----------------------------------------------------------------
-- LOADING SCREEN
----------------------------------------------------------------
local loadingFrame = Instance.new("CanvasGroup")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadingFrame.Parent = screenGui

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
loadingLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Initializing System..."
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.Font = Enum.Font.GothamMedium
loadingLabel.TextScaled = true
loadingLabel.Parent = loadingFrame

local percentageLabel = Instance.new("TextLabel")
percentageLabel.Size = UDim2.new(1, 0, 0.05, 0)
percentageLabel.Position = UDim2.new(0, 0, 0.55, 0)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Text = "0%"
percentageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
percentageLabel.Font = Enum.Font.Code
percentageLabel.TextSize = 18
percentageLabel.Parent = loadingFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.6, 0, 0.02, 0) -- To hơn một chút cho màn hình ngang
progressBg.Position = UDim2.new(0.2, 0, 0.62, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBg.BorderSizePixel = 0
progressBg.Parent = loadingFrame
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBg
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
})
uiGradient.Parent = progressFill

----------------------------------------------------------------
-- LOADING LOGIC
----------------------------------------------------------------
local statusMessages = {
    "Bypassing integrity checks...",
    "Loading player roles...",
    "Optimizing for Mobile...",
    "Finalizing UI components...",
    "Ready!"
}

task.spawn(function()
    for i = 1, #statusMessages do
        loadingLabel.Text = statusMessages[i]
        task.wait(0.6)
    end
end)

local loadingTime = 3
local tweenInfoLoad = TweenInfo.new(loadingTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(progressFill, tweenInfoLoad, {Size = UDim2.new(1, 0, 1, 0)}):Play()

local startTick = tick()
while tick() - startTick < loadingTime do
    local progress = math.floor(((tick() - startTick) / loadingTime) * 100)
    percentageLabel.Text = progress .. "%"
    task.wait()
end
percentageLabel.Text = "100%"

----------------------------------------------------------------
-- ROLES & DATA
----------------------------------------------------------------
local Roles = {
    Murderer   = {color = Color3.fromRGB(255, 0, 0), keywords = {"knife"}},
    Sheriff    = {color = Color3.fromRGB(135, 206, 250), keywords = {"gun","revolver"}},
    Slapper    = {color = Color3.fromRGB(255, 255, 153), keywords = {"slap"}},
    Thug       = {color = Color3.fromRGB(128, 0, 128), keywords = {"punch"}},
    Cop        = {color = Color3.fromRGB(173, 216, 230), keywords = {"handcuffs"}},
    Hacker     = {color = Color3.fromRGB(0, 200, 0), keywords = {"hacker"}},
    Detective  = {color = Color3.fromRGB(0, 0, 139), keywords = {"detect"}},
    Medic      = {color = Color3.fromRGB(255, 105, 180), keywords = {"revive"}},
    Taser      = {color = Color3.fromRGB(255, 165, 0), keywords = {"taser"}},
    Wizard     = {color = Color3.fromRGB(255, 182, 193), keywords = {"wizardorb"}},
    Clown      = {color = Color3.fromRGB(139, 69, 19), keywords = {"pie"}},
    Innocent   = {color = Color3.fromRGB(0, 255, 0), keywords = {}}
}

local playerRoles = {}

----------------------------------------------------------------
-- GUI CHÍNH (Đã tăng kích thước cho Mobile)
----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 60) -- Tăng size để dễ bấm
MainFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = screenGui
MakeDraggable(MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.4, 0, 0.8, 0)
ESPButton.Position = UDim2.new(0.04, 0, 0.1, 0)
ESPButton.Text = "ESP: OFF"
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextScaled = true
ESPButton.TextColor3 = Color3.new(1, 1, 1)
ESPButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ESPButton.Parent = MainFrame
Instance.new("UICorner", ESPButton).CornerRadius = UDim.new(0, 6)

local TPListButton = Instance.new("TextButton")
TPListButton.Size = UDim2.new(0.35, 0, 0.8, 0)
TPListButton.Position = UDim2.new(0.48, 0, 0.1, 0)
TPListButton.Text = "TP List"
TPListButton.Font = Enum.Font.GothamBold
TPListButton.TextScaled = true
TPListButton.TextColor3 = Color3.new(1, 1, 1)
TPListButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TPListButton.Parent = MainFrame
Instance.new("UICorner", TPListButton).CornerRadius = UDim.new(0, 6)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0.12, 0, 0.8, 0)
MinimizeButton.Position = UDim2.new(0.85, 0, 0.1, 0)
MinimizeButton.Text = "_"
MinimizeButton.TextSize = 24
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Parent = MainFrame
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

----------------------------------------------------------------
-- MINI FRAME (Dấu + to hơn để ngón tay dễ chạm)
----------------------------------------------------------------
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 50, 0, 50) 
MiniFrame.Position = MainFrame.Position
MiniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Parent = screenGui
MakeDraggable(MiniFrame)
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(1, 0)

local PlusButton = Instance.new("TextButton")
PlusButton.Size = UDim2.new(1, 0, 1, 0)
PlusButton.Text = "+"
PlusButton.TextSize = 35
PlusButton.Font = Enum.Font.GothamBold
PlusButton.TextColor3 = Color3.fromRGB(0, 255, 0)
PlusButton.BackgroundTransparency = 1
PlusButton.Parent = MiniFrame

-- Dùng .Activated thay cho .MouseButton1Click trên mobile
MinimizeButton.Activated:Connect(function()
    MiniFrame.Position = MainFrame.Position
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

PlusButton.Activated:Connect(function()
    MainFrame.Position = MiniFrame.Position
    MiniFrame.Visible = false
    MainFrame.Visible = true
end)

----------------------------------------------------------------
-- ESP LOGIC
----------------------------------------------------------------
local espEnabled = false

local function createESP(player, color, roleName)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart

        -- Box ESP
        local box = root:FindFirstChild("MyESP") or Instance.new("BoxHandleAdornment")
        box.Name = "MyESP"
        box.Adornee = root
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(3.5, 5, 3.5)
        box.Transparency = 0.5
        box.Color3 = color
        box.Parent = root

        -- Name + Role ESP
        local billboard = root:FindFirstChild("NameESP")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "NameESP"
            billboard.Adornee = root
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 4, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = root

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextScaled = true
            nameLabel.Parent = billboard
        end
        
        local label = billboard:FindFirstChild("NameLabel")
        if label then
            label.Text = player.Name .. " - " .. roleName
            label.TextColor3 = color
        end
    end
end

local function removeESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local oldBox = root:FindFirstChild("MyESP")
            local oldName = root:FindFirstChild("NameESP")
            if oldBox then oldBox:Destroy() end
            if oldName then oldName:Destroy() end
        end
    end
end

ESPButton.Activated:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ESPButton.Text = "ESP: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        removeESP()
    end
end)

local function getRole(player)
    if not player.Character then return "Innocent", Roles.Innocent.color end
    local items = player.Backpack:GetChildren()
    for _, item in pairs(player.Character:GetChildren()) do
        if item:IsA("Tool") then table.insert(items, item) end
    end
    
    for roleName, roleData in pairs(Roles) do
        for _, keyword in ipairs(roleData.keywords) do
            for _, tool in ipairs(items) do
                if tool.Name:lower():find(keyword) then
                    return roleName, roleData.color
                end
            end
        end
    end
    return "Innocent", Roles.Innocent.color
end

task.spawn(function()
    while task.wait(1) do
        if espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    -- Kiểm tra xem humanoid còn sống không để tránh rác ESP
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local roleName, roleColor = getRole(player)
                        playerRoles[player.Name] = roleName
                        createESP(player, roleColor, roleName)
                    end
                end
            end
        end
    end
end)

----------------------------------------------------------------
-- TP LIST GUI
----------------------------------------------------------------
local TPFrame = Instance.new("Frame")
TPFrame.Size = UDim2.new(0, 200, 0, 280) -- Rộng và cao hơn
TPFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
TPFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TPFrame.Visible = false
TPFrame.Parent = screenGui
Instance.new("UICorner", TPFrame).CornerRadius = UDim.new(0, 8)
MakeDraggable(TPFrame)

local TPTitle = Instance.new("TextLabel")
TPTitle.Size = UDim2.new(1, 0, 0.12, 0)
TPTitle.BackgroundTransparency = 1
TPTitle.Text = "Teleport Menu"
TPTitle.Font = Enum.Font.GothamBold
TPTitle.TextScaled = true
TPTitle.TextColor3 = Color3.new(1, 1, 1)
TPTitle.Parent = TPFrame

local CloseTPButton = Instance.new("TextButton")
CloseTPButton.Size = UDim2.new(0.15, 0, 0.12, 0)
CloseTPButton.Position = UDim2.new(0.85, 0, 0, 0)
CloseTPButton.Text = "X"
CloseTPButton.Font = Enum.Font.GothamBold
CloseTPButton.TextScaled = true
CloseTPButton.TextColor3 = Color3.new(1, 1, 1)
CloseTPButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseTPButton.Parent = TPFrame
Instance.new("UICorner", CloseTPButton).CornerRadius = UDim.new(0, 6)

CloseTPButton.Activated:Connect(function()
    TPFrame.Visible = false
end)

TPListButton.Activated:Connect(function()
    TPFrame.Visible = not TPFrame.Visible
end)

local TPScroll = Instance.new("ScrollingFrame")
TPScroll.Size = UDim2.new(1, 0, 0.88, 0)
TPScroll.Position = UDim2.new(0, 0, 0.12, 0)
TPScroll.BackgroundTransparency = 1
TPScroll.ScrollBarThickness = 6 -- Cuộn dễ hơn bằng tay
TPScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TPScroll.Parent = TPFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TPScroll
UIListLayout.Padding = UDim.new(0, 8) -- Khoảng cách giữa các nút rộng hơn
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function teleportToRole(targetRole)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if playerRoles[player.Name] == targetRole then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                return
            end
        end
    end
end

for roleName, roleData in pairs(Roles) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40) -- CHIỀU CAO 40 ĐỂ DỄ BẤM TRÊN MOBILE
    btn.Text = "TP " .. roleName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = roleData.color
    btn.Parent = TPScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.Activated:Connect(function()
        teleportToRole(roleName)
    end)
end

----------------------------------------------------------------
-- KHI LOADING XONG THÌ HIỆN GUI
----------------------------------------------------------------
local fadeTween = TweenService:Create(loadingFrame, TweenInfo.new(0.5), {GroupTransparency = 1})
fadeTween:Play()
fadeTween.Completed:Connect(function()
    loadingFrame:Destroy()
    MainFrame.Visible = true
end)
