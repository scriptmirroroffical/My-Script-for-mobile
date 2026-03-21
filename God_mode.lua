local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local active = false
local bypassLevel = 2 
local connections = {}
local foundBackdoors = {}

-- Bảo vệ UI
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or player:WaitForChild("PlayerGui")
if targetGui:FindFirstChild("OmniGodHub_Mobile") then targetGui.OmniGodHub_Mobile:Destroy() end

-----------------------------------------------------------
-- TOUCH-DRAGGABLE LOGIC (Dành riêng cho Mobile)
-----------------------------------------------------------
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

-----------------------------------------------------------
-- 1. REAL BYPASS & STEALTH LOGIC
-----------------------------------------------------------
local function InitiateAntiKick()
    local mt = getrawmetatable(game)
    if not mt then return false end
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            return nil 
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    return true
end

local function ApplyStealth(char)
    if not char then return end
    local tags = CollectionService:GetTags(char)
    for _, tag in ipairs(tags) do CollectionService:RemoveTag(char, tag) end
    
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Massless = true 
            p.CollisionGroupId = 0 
        end
    end
end

local function ScanForBackdoors()
    local found = {}
    local descendants = game:GetDescendants()
    for i = 1, #descendants do
        local v = descendants[i]
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if v.Name:lower():match("check") or v.Name:lower():match("control") or #v.Name > 30 then
                local success = pcall(function() v:FireServer("OmniTest") end)
                if success then table.insert(found, v) end
            end
        end
        if i % 200 == 0 then task.wait() end -- Giảm tải quét cho Mobile
    end
    return found
end

-----------------------------------------------------------
-- 2. UI CREATION (Mobile Optimized)
-----------------------------------------------------------
local sg = Instance.new("ScreenGui", targetGui)
sg.Name = "OmniGodHub_Mobile"
sg.ResetOnSpawn = false

-- Terminal Loading
local term = Instance.new("Frame", sg)
term.Size = UDim2.new(0, 300, 0, 180)
term.Position = UDim2.new(0.5, -150, 0.4, 0)
term.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
term.BorderSizePixel = 0
Instance.new("UICorner", term)

local termLog = Instance.new("TextLabel", term)
termLog.Size = UDim2.new(1, -20, 1, -20)
termLog.Position = UDim2.new(0, 10, 0, 10)
termLog.BackgroundTransparency = 1
termLog.TextColor3 = Color3.fromRGB(0, 255, 100)
termLog.Font = Enum.Font.Code
termLog.TextSize = 14
termLog.TextXAlignment = Enum.TextXAlignment.Left
termLog.TextYAlignment = Enum.TextYAlignment.Top
termLog.Text = ""

-- Main UI
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 180) -- Rộng hơn chút để dễ thao tác
main.Position = UDim2.new(0.5, -140, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
main.BorderSizePixel = 0
main.Active = true
main.Visible = false 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
MakeDraggable(main)

-- Nút thu nhỏ
local btnMinimize = Instance.new("TextButton", main)
btnMinimize.Size = UDim2.new(0, 30, 0, 30)
btnMinimize.Position = UDim2.new(1, -35, 0, 5)
btnMinimize.Text = "-"
btnMinimize.TextSize = 24
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextColor3 = Color3.new(1, 1, 1)
btnMinimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "OMNI-GOD V.MAX"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.22, 0)
status.Text = "STATUS: STANDBY"
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.Font = Enum.Font.GothamMedium
status.TextSize = 13
status.BackgroundTransparency = 1

local btnLevel = Instance.new("TextButton", main)
btnLevel.Size = UDim2.new(0.85, 0, 0, 40) -- To hơn cho ngón tay
btnLevel.Position = UDim2.new(0.075, 0, 0.4, 0)
btnLevel.Text = "BYPASS LEVEL: 2 (GHOST)"
btnLevel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btnLevel.TextColor3 = Color3.new(1, 1, 1)
btnLevel.Font = Enum.Font.GothamSemibold
btnLevel.TextSize = 14
Instance.new("UICorner", btnLevel).CornerRadius = UDim.new(0, 6)

local btnToggle = Instance.new("TextButton", main)
btnToggle.Size = UDim2.new(0.85, 0, 0, 45) -- To hơn
btnToggle.Position = UDim2.new(0.075, 0, 0.68, 0)
btnToggle.Text = "ACTIVATE"
btnToggle.BackgroundColor3 = Color3.fromRGB(20, 150, 80)
btnToggle.TextColor3 = Color3.new(1, 1, 1)
btnToggle.Font = Enum.Font.GothamBold
btnToggle.TextSize = 16
Instance.new("UICorner", btnToggle).CornerRadius = UDim.new(0, 6)

-- Open Icon (Khi thu nhỏ)
local openIcon = Instance.new("TextButton", sg)
openIcon.Size = UDim2.new(0, 50, 0, 50)
openIcon.Position = UDim2.new(0.05, 0, 0.5, 0)
openIcon.Text = "⚡"
openIcon.TextSize = 25
openIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
openIcon.Visible = false
Instance.new("UICorner", openIcon).CornerRadius = UDim.new(1, 0)
MakeDraggable(openIcon)

btnMinimize.Activated:Connect(function()
    main.Visible = false
    openIcon.Visible = true
end)

openIcon.Activated:Connect(function()
    openIcon.Visible = false
    main.Visible = true
    main.Position = openIcon.Position -- Mở ra ngay vị trí icon
end)

-----------------------------------------------------------
-- 3. CORE LOGIC (GOD MODE + FIX JUMP + HIGHLIGHT)
-----------------------------------------------------------
local function ClearConnections()
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    table.clear(connections)
end

local function RestoreNormal(char)
    ClearConnections()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
    if char:FindFirstChild("OmniHighlight") then char.OmniHighlight:Destroy() end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanTouch = true end
    end
end

local function ApplyGodMode(char)
    ClearConnections()
    if not char then return end
    
    ApplyStealth(char)

    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    -- FIX LEVEL 3: Clone Logic
    if bypassLevel == 3 then
        local oldHum = hum
        local newHum = oldHum:Clone()
        newHum.Parent = char
        newHum.Name = oldHum.Name
        workspace.CurrentCamera.CameraSubject = newHum
        oldHum:Destroy()
        hum = newHum
        
        local animate = char:FindFirstChild("Animate")
        if animate then animate.Disabled = true task.wait(0.1) animate.Disabled = false end
    end

    -- HIGHLIGHT
    if not char:FindFirstChild("OmniHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "OmniHighlight"
        hl.Parent = char
        hl.FillColor = Color3.fromRGB(0, 200, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
    end

    hum.MaxHealth = math.huge
    hum.Health = math.huge
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    -- TỐI ƯU HÓA MOBILE: Đặt CanTouch = false MỘT LẦN ở đây, KHÔNG để trong Heartbeat
    if bypassLevel >= 2 then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanTouch = false end
        end
    end

    -- LOOP CẬP NHẬT (Chỉ giữ lại những thứ thật sự cần check mỗi frame)
    local loop = RunService.Heartbeat:Connect(function()
        if not active or not hum or not root then return end
        hum.Health = math.huge
        
        -- Anti-Void
        if root.Position.Y < -350 then
            root.Velocity = Vector3.new(0,0,0)
            root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
        end
    end)
    table.insert(connections, loop)

    -- JUMP FIX (Dùng cho cả Mobile Nút Nhảy và PC)
    local jumpConn = UserInputService.JumpRequest:Connect(function()
        if active and hum then
            hum.Jump = true 
            hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end)
    table.insert(connections, jumpConn)
end

-----------------------------------------------------------
-- TERMINAL & EVENTS
-----------------------------------------------------------
task.spawn(function()
    local function log(t) termLog.Text = termLog.Text .. "> " .. t .. "\n" task.wait(0.2) end
    log("INITIALIZING OMNI-SYSTEM...")
    local ak = pcall(InitiateAntiKick)
    log(ak and "ANTI-KICK: ACTIVE (HOOKED)" or "ANTI-KICK: UNSUPPORTED")
    log("APPLYING STEALTH ATTRIBUTES...")
    ApplyStealth(player.Character)
    log("SCANNING FOR SERVER BACKDOORS...")
    foundBackdoors = ScanForBackdoors()
    log("SYSTEM READY. BOOTING UI...")
    task.wait(0.5)
    term:Destroy()
    main.Visible = true
end)

-- Thay thế .MouseButton1Click bằng .Activated cho Mobile
btnLevel.Activated:Connect(function()
    if active then return end
    bypassLevel = bypassLevel + 1
    if bypassLevel > 3 then bypassLevel = 1 end
    local txt = (bypassLevel == 1 and "1 (STEALTH)") or (bypassLevel == 2 and "2 (GHOST)") or "3 (CLONE)"
    btnLevel.Text = "BYPASS LEVEL: " .. bypassLevel .. " (" .. txt .. ")"
end)

btnToggle.Activated:Connect(function()
    active = not active
    if active then
        btnToggle.Text = "DEACTIVATE"
        btnToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "STATUS: ACTIVE (LV " .. bypassLevel .. ")"
        status.TextColor3 = Color3.fromRGB(0, 255, 150)
        if player.Character then ApplyGodMode(player.Character) end
    else
        btnToggle.Text = "ACTIVATE"
        btnToggle.BackgroundColor3 = Color3.fromRGB(20, 150, 80)
        status.Text = "STATUS: STANDBY"
        status.TextColor3 = Color3.fromRGB(150, 150, 150)
        if player.Character then RestoreNormal(player.Character) end
    end
end)

player.CharacterAdded:Connect(function(c) if active then task.wait(0.7) ApplyGodMode(c) end end)
