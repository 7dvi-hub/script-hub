--[[
7DVI HUB | PREMIUM UI
Key System + Dark + Abas + Animações + Blur
]]

-- ================= CONFIG =================
local HUB_NAME = "7DVI HUB"
local KEY_CORRETA = "7DVI-2025"

-- ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer

-- ================= CLEAN =================
if game.CoreGui:FindFirstChild(HUB_NAME) then
    game.CoreGui[HUB_NAME]:Destroy()
end

-- ================= BLUR =================
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local function tweenBlur(v)
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = v}):Play()
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = HUB_NAME

-- ================= DRAG =================
local function drag(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ================= KEY SYSTEM =================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,320,0,190)
KeyFrame.Position = UDim2.new(0.5,-160,0.5,-95)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
KeyFrame.BackgroundTransparency = 0.05
drag(KeyFrame)

local KCorner = Instance.new("UICorner", KeyFrame)
KCorner.CornerRadius = UDim.new(0,14)

local KStroke = Instance.new("UIStroke", KeyFrame)
KStroke.Color = Color3.fromRGB(80,80,80)

local KTitle = Instance.new("TextLabel", KeyFrame)
KTitle.Size = UDim2.new(1,0,0,45)
KTitle.Text = HUB_NAME .. " | KEY"
KTitle.TextColor3 = Color3.fromRGB(255,255,255)
KTitle.BackgroundTransparency = 1
KTitle.Font = Enum.Font.GothamBold
KTitle.TextSize = 18

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0,240,0,38)
KeyBox.Position = UDim2.new(0.5,-120,0,75)
KeyBox.PlaceholderText = "Digite sua key"
KeyBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,10)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(0,200,0,38)
Confirm.Position = UDim2.new(0.5,-100,0,130)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(40,40,40)
Confirm.TextColor3 = Color3.fromRGB(255,255,255)
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 14
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,10)

-- ================= HUB =================
local Hub = Instance.new("Frame", ScreenGui)
Hub.Size = UDim2.new(0,560,0,340)
Hub.Position = UDim2.new(0.5,-280,0.5,-170)
Hub.BackgroundColor3 = Color3.fromRGB(14,14,14)
Hub.Visible = false
drag(Hub)

local HCorner = Instance.new("UICorner", Hub)
HCorner.CornerRadius = UDim.new(0,16)

local HStroke = Instance.new("UIStroke", Hub)
HStroke.Color = Color3.fromRGB(90,90,90)

local Title = Instance.new("TextLabel", Hub)
Title.Size = UDim2.new(1,0,0,45)
Title.Text = HUB_NAME
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- ================= SIDEBAR =================
local Sidebar = Instance.new("Frame", Hub)
Sidebar.Size = UDim2.new(0,130,1,-45)
Sidebar.Position = UDim2.new(0,0,0,45)
Sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,16)

local Pages = Instance.new("Frame", Hub)
Pages.Size = UDim2.new(1,-140,1,-55)
Pages.Position = UDim2.new(0,140,0,55)
Pages.BackgroundTransparency = 1

local function createTab(name)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1,-10,0,42)
    btn.Position = UDim2.new(0,5,0,5 + (#Sidebar:GetChildren()-1)*46)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local page = Instance.new("Frame", Pages)
    page.Size = UDim2.new(1,0,1,0)
    page.Visible = false
    page.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(Pages:GetChildren()) do v.Visible = false end
        page.Visible = true
    end)

    return page
end

local Main = createTab("Main")
local PlayerTab = createTab("Player")

-- ================= TOGGLE =================
local function createToggle(parent, text, y, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,220,0,40)
    btn.Position = UDim2.new(0,20,0,y)
    btn.Text = text .. " : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " : ON" or " : OFF")
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(60,60,60) or Color3.fromRGB(35,35,35)
        }):Play()
        callback(state)
    end)
end

createToggle(Main, "Exemplo Toggle", 20, function(v)
    print("Toggle:", v)
end)

-- ================= KEY CHECK =================
Confirm.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY_CORRETA then
        tweenBlur(15)
        KeyFrame:Destroy()
        Hub.Visible = true
        Main.Visible = true
    else
        KeyBox.Text = "KEY INVÁLIDA"
    end
end)
