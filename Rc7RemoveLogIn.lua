-- Gui to Lua - Version: 3.2 (Login Removed by scriptmirroroffical@gmail.com)

local rc7 = Instance.new("ScreenGui")
local mini = Instance.new("ImageButton")
local mainpage = Instance.new("ImageLabel")
local input = Instance.new("TextBox")
local output = Instance.new("TextBox")
local exe = Instance.new("TextButton")
local clear = Instance.new("TextButton")
local open = Instance.new("TextButton")
local roxploit = Instance.new("TextButton")
local dex = Instance.new("TextButton")
local close_2 = Instance.new("TextButton")
local minimize_2 = Instance.new("TextButton")

--Properties:
rc7.Name = "rc7"
rc7.Parent = game.CoreGui
rc7.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

mini.Name = "mini"
mini.Parent = rc7
mini.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mini.BackgroundTransparency = 1.000
mini.Position = UDim2.new(0, 0, 0.894399107, 0)
mini.Size = UDim2.new(0, 58, 0, 60)
mini.Visible = false
mini.Image = "http://www.roblox.com/asset/?id=14416021390"
mini.MouseButton1Down:connect(function()
    mainpage.Visible = true
    mini.Visible = false
end)

mainpage.Name = "mainpage"
mainpage.Parent = rc7
mainpage.Active = true
mainpage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainpage.BorderSizePixel = 0
mainpage.Position = UDim2.new(0.171028033, 0, 0.178529739, 0)
mainpage.Size = UDim2.new(0, 349, 0, 363)
mainpage.Visible = true -- Tự động hiện giao diện chính
mainpage.Image = "http://www.roblox.com/asset/?id=12263991723"

input.Name = "input"
input.Parent = mainpage
input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
input.Position = UDim2.new(0.0343839526, 0, 0.0991735533, 0)
input.Size = UDim2.new(0, 296, 0, 239)
input.Font = Enum.Font.Arial
input.MultiLine = true
input.Text = ""
input.TextXAlignment = Enum.TextXAlignment.Left
input.TextYAlignment = Enum.TextYAlignment.Top

output.Name = "output"
output.Parent = mainpage
output.Active = false
output.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
output.Position = UDim2.new(0.0343839526, 0, 0.845730007, 0)
output.Size = UDim2.new(0, 296, 0, 52)
output.Font = Enum.Font.Arial
output.Text = ""

exe.Name = "exe"
exe.Parent = mainpage
exe.BackgroundTransparency = 1.000
exe.Position = UDim2.new(0.315186232, 0, 0.774104655, 0)
exe.Size = UDim2.new(0, 99, 0, 20)
exe.Font = Enum.Font.ArialBold
exe.Text = "Execute"
exe.TextColor3 = Color3.fromRGB(20, 212, 255)
exe.MouseButton1Down:connect(function()
    if input.Text ~= "" and input.Text ~= " " then
        loadstring(input.Text)()
        output.Text = "Script successfully executed!"
    else
        output.Text = "Script is blank, paste a script!"
    end
    wait(2)
    output.Text = ""
end)

clear.Name = "clear"
clear.Parent = mainpage
clear.BackgroundTransparency = 1.000
clear.Position = UDim2.new(0.598853886, 0, 0.774104655, 0)
clear.Size = UDim2.new(0, 99, 0, 20)
clear.Text = "Clear"
clear.TextColor3 = Color3.fromRGB(20, 212, 255)
clear.MouseButton1Down:connect(function()
    input.Text = ""
end)

open.Name = "open"
open.Parent = mainpage
open.BackgroundTransparency = 1.000
open.Position = UDim2.new(0.0343839526, 0, 0.774104655, 0)
open.Size = UDim2.new(0, 99, 0, 20)
open.Text = "Open"
open.TextColor3 = Color3.fromRGB(20, 212, 255)
open.MouseButton1Down:connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE/main/ScriptHub"))()
end)

roxploit.Name = "roxploit"
roxploit.Parent = mainpage
roxploit.BackgroundTransparency = 1.000
roxploit.Position = UDim2.new(0.904999971, 0, 0.799000025, 0)
roxploit.Size = UDim2.new(0, 29, 0, 29)
roxploit.Text = ""
roxploit.MouseButton1Down:connect(function()
    loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-RoXploit-by-KrystalTeam-9328"))()
end)

dex.Name = "dex"
dex.Parent = mainpage
dex.BackgroundTransparency = 1.000
dex.Position = UDim2.new(0.904999971, 0, 0.910000026, 0)
dex.Size = UDim2.new(0, 29, 0, 29)
dex.Text = ""
dex.MouseButton1Down:connect(function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
end)

close_2.Name = "close"
close_2.Parent = mainpage
close_2.BackgroundTransparency = 1.000
close_2.Position = UDim2.new(0.88252151, 0, 0, 0)
close_2.Size = UDim2.new(0, 41, 0, 24)
close_2.Text = ""
close_2.MouseButton1Down:connect(function()
    rc7:Destroy() -- Đóng hoàn toàn GUI
end)

minimize_2.Name = "minimize"
minimize_2.Parent = mainpage
minimize_2.BackgroundTransparency = 1.000
minimize_2.Position = UDim2.new(0.598853886, 0, 0, 0)
minimize_2.Size = UDim2.new(0, 41, 0, 24)
minimize_2.Text = ""
minimize_2.MouseButton1Down:connect(function()
    mainpage.Visible = false
    mini.Visible = true
end)

-- Script di chuyển GUI (Dragify)
local function EERUFD_fake_script()
    local script = Instance.new('LocalScript', mainpage)
    local UIS = game:GetService("UserInputService")
    local gui = script.Parent
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end
coroutine.wrap(EERUFD_fake_script)()