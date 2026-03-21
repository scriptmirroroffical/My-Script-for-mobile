local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === HÀM KÉO THẢ CHO MOBILE ===
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- === GIAO DIỆN ===
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "Hitbox_Mobile_V15"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
MakeDraggable(MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HITBOX V15 MOBILE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local MiniBtn = Instance.new("TextButton", MainFrame)
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MiniBtn)

local SizeInput = Instance.new("TextBox", MainFrame)
SizeInput.Size = UDim2.new(0.9, 0, 0, 40)
SizeInput.Position = UDim2.new(0.05, 0, 0.15, 0)
SizeInput.Text = "20"
SizeInput.PlaceholderText = "Size (Default 20)"
SizeInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SizeInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SizeInput)

local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(0.9, 0, 0, 140)
PlayerList.Position = UDim2.new(0.05, 0, 0.3, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerList.ScrollBarThickness = 4
Instance.new("UIListLayout", PlayerList).Padding = UDim.new(0, 5)

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
ToggleBtn.Text = "ACTIVATE: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn)

-- === LOGIC TỐI ƯU ===
local _G_Enabled = false
local SelectedPlayer = "Tất cả"

local function UpdateHitbox(p)
    if p == LocalPlayer or not p.Character then return end
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local hitbox = p.Character:FindFirstChild("MobileHitboxV15")
    
    -- Nếu chưa có hitbox, tạo mới
    if not hitbox then
        hitbox = Instance.new("Part")
        hitbox.Name = "MobileHitboxV15"
        hitbox.Transparency = 0.6
        hitbox.BrickColor = BrickColor.new("Cyan")
        hitbox.Material = Enum.Material.Neon
        hitbox.CanCollide = false
        hitbox.Massless = true
        hitbox.Parent = p.Character

        -- QUAN TRỌNG: Đưa hitbox về đúng vị trí tâm của đối thủ trước khi hàn (Weld)
        hitbox.CFrame = root.CFrame 

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hitbox
        weld.Part1 = root
        weld.Parent = hitbox
        
        local selection = Instance.new("SelectionBox", hitbox)
        selection.Adornee = hitbox
        selection.Color3 = Color3.fromRGB(0, 255, 255)
        selection.LineThickness = 0.05
    end

    -- Cập nhật kích thước dựa trên TextBox
    local size = tonumber(SizeInput.Text) or 20
    if _G_Enabled and (SelectedPlayer == "Tất cả" or SelectedPlayer == p.Name) then
        hitbox.Size = Vector3.new(size, size, size)
        hitbox.Transparency = 0.6
    else
        -- Khi tắt, thu nhỏ về mặc định và tàng hình
        hitbox.Size = Vector3.new(2, 2, 1) 
        hitbox.Transparency = 1
    end
end

-- Vòng lặp tối ưu: 0.5 giây cập nhật một lần thay vì mỗi khung hình
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            UpdateHitbox(p)
        end
    end
end)

-- Xử lý giao diện danh sách
local function RefreshList()
    for _, child in pairs(PlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    
    local function addBtn(name)
        local b = Instance.new("TextButton", PlayerList)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.Text = name
        b.BackgroundColor3 = (SelectedPlayer == name) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 40, 40)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Activated:Connect(function() SelectedPlayer = name RefreshList() end)
        Instance.new("UICorner", b)
    end
    
    addBtn("Tất cả")
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then addBtn(p.Name) end end
end

-- Sự kiện nút bấm
ToggleBtn.Activated:Connect(function()
    _G_Enabled = not _G_Enabled
    ToggleBtn.Text = _G_Enabled and "ACTIVATE: ON" or "ACTIVATE: OFF"
    ToggleBtn.BackgroundColor3 = _G_Enabled and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(170, 0, 0)
end)

local collapsed = false
MiniBtn.Activated:Connect(function()
    collapsed = not collapsed
    MainFrame:TweenSize(collapsed and UDim2.new(0, 220, 0, 45) or UDim2.new(0, 220, 0, 320), "Out", "Quart", 0.3, true)
    PlayerList.Visible = not collapsed
    SizeInput.Visible = not collapsed
    ToggleBtn.Visible = not collapsed
end)

Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)
RefreshList()
