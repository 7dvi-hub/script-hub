-- PAINEL PREMIUM CORRIGIDO (BASE FUNCIONAL)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== CONFIG =====
local PANEL_NAME = "PainelPremium7DVI"
local KEY_CORRETA = "7dvi"
local TOGGLE_KEY = Enum.KeyCode.RightShift

-- ===== NOTIFY =====
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Painel Premium",
            Text = txt,
            Duration = 3
        })
    end)
end

-- ===== REMOVE DUPLICADO =====
if game.CoreGui:FindFirstChild(PANEL_NAME) then
    game.CoreGui[PANEL_NAME]:Destroy()
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = PANEL_NAME
ScreenGui.ResetOnSpawn = false

-- ===== KEY FRAME =====
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,300,0,180)
KeyFrame.Position = UDim2.new(0.5,-150,0.5,-90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
KeyFrame.Active = true
KeyFrame.Draggable = true

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "KEY PREMIUM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Box = Instance.new("TextBox", KeyFrame)
Box.Size = UDim2.new(0,220,0,36)
Box.Position = UDim2.new(0.5,-110,0,60)
Box.PlaceholderText = "Digite a key"
Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
Box.TextColor3 = Color3.new(1,1,1)

local Btn = Instance.new("TextButton", KeyFrame)
Btn.Size = UDim2.new(0,180,0,36)
Btn.Position = UDim2.new(0.5,-90,0,115)
Btn.Text = "CONFIRMAR"
Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Btn.TextColor3 = Color3.new(1,1,1)

-- ===== MAIN PANEL =====
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,420,0,300)
Main.Position = UDim2.new(0.5,-210,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Visible = false
Main.Active = true
Main.Draggable = true

local MT = Instance.new("TextLabel", Main)
MT.Size = UDim2.new(1,0,0,40)
MT.BackgroundTransparency = 1
MT.Text = "PAINEL PREMIUM 7DVI"
MT.TextColor3 = Color3.new(1,1,1)
MT.Font = Enum.Font.GothamBold
MT.TextSize = 18

-- ===== BUTTONS =====
local function button(text,y,callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0,180,0,36)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text..": OFF"
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text..(on and ": ON" or ": OFF")
        callback(on)
    end)
end

-- ===== PLAYER =====
local humanoid
local function bind()
    local c = Player.Character or Player.CharacterAdded:Wait()
    humanoid = c:WaitForChild("Humanoid")
end
bind()
Player.CharacterAdded:Connect(bind)

button("Speed",60,function(v)
    humanoid.WalkSpeed = v and 50 or 16
end)

local fly = false
button("Fly",110,function(v)
    fly = v
end)

RunService.RenderStepped:Connect(function()
    if fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,40,0)
    end
end)

-- ===== KEY CHECK =====
Btn.MouseButton1Click:Connect(function()
    if Box.Text == KEY_CORRETA then
        KeyFrame.Visible = false
        Main.Visible = true
        notify("Key aceita!")
    else
        notify("Key inválida")
    end
end)

-- ===== TOGGLE PANEL =====
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == TOGGLE_KEY then
        Main.Visible = not Main.Visible
    end
end)
