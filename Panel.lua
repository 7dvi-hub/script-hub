--[[ 
7dvi HUB - SINGLE FILE
Fly | Speed | TP | ESP | Aimbot
UI Premium | Abas: Combat / Visual / Player
Key System Integrado
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

-- ================= CONFIG =================
local KEY_CORRETA = "7DVI-9XK4-2025"
local TOGGLE_KEY = Enum.KeyCode.RightShift
local AIM_KEY = Enum.UserInputType.MouseButton2
local FlySpeed = 60
local WalkSpeedValue = 40
local AimFOV = 120
local ESP_NameSize = 14

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CoreGui = (gethui and gethui()) or game.CoreGui

-- ================= ANTI DUPLICATE =================
if CoreGui:FindFirstChild("7dviKeySystem") then CoreGui["7dviKeySystem"]:Destroy() end

-- ================= UI KEY SYSTEM =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "7dviKeySystem"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,200)
Frame.Position = UDim2.new(0.5,-150,0.5,-100)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
Title.Text = "7dvi Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", Title).CornerRadius = UDim.new(0,10)

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(0.85,0,0,32)
KeyBox.Position = UDim2.new(0.075,0,0.32,0)
KeyBox.PlaceholderText = "Digite sua Key..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", KeyBox)

local Verify = Instance.new("TextButton", Frame)
Verify.Size = UDim2.new(0.85,0,0,32)
Verify.Position = UDim2.new(0.075,0,0.52,0)
Verify.Text = "Verificar Key"
Verify.Font = Enum.Font.GothamBold
Verify.TextSize = 14
Verify.BackgroundColor3 = Color3.fromRGB(255,0,0)
Verify.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Verify)

local GetKey = Instance.new("TextButton", Frame)
GetKey.Size = UDim2.new(0.85,0,0,28)
GetKey.Position = UDim2.new(0.075,0,0.72,0)
GetKey.Text = "Adquirir Key"
GetKey.Font = Enum.Font.Gotham
GetKey.TextSize = 13
GetKey.BackgroundColor3 = Color3.fromRGB(60,60,60)
GetKey.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", GetKey)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,0.88,0)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextColor3 = Color3.new(1,1,1)
Status.Text = ""

-- ================= LOGIC KEY SYSTEM =================
Verify.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY_CORRETA then
        Status.Text = "Key correta! Carregando..."
        task.wait(0.8)
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7dvi-hub/script-hub/main/Panel.lua"))()
    else
        Status.Text = "Key incorreta!"
        task.wait(1.2)
        Status.Text = ""
    end
end)

GetKey.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://fir3.net/pass2")
        Status.Text = "Link copiado!"
        task.wait(1.2)
        Status.Text = ""
    end
end)
