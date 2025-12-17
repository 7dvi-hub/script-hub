--[[
SCRIPT HUB - KEY SYSTEM + DARK UI + ABAS
Modelo educacional
]]

-- CONFIG
local KEY_CORRETA = "MTT-1234"
local HUB_NAME = "MTT HUB"

-- LIMPAR GUI
if game.CoreGui:FindFirstChild(HUB_NAME) then
    game.CoreGui[HUB_NAME]:Destroy()
end

-- SERVIÇOS
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = HUB_NAME

-- FUNÇÃO DRAG
local function dragify(Frame)
    local dragToggle, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ================= KEY SYSTEM =================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
dragify(KeyFrame)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1,0,0,40)
KeyTitle.Text = HUB_NAME.." | KEY"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0,240,0,35)
KeyBox.Position = UDim2.new(0.5,-120,0,70)
KeyBox.PlaceholderText = "Digite a key"
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(0,200,0,35)
Confirm.Position = UDim2.new(0.5,-100,0,120)
Confirm.Text = "Confirmar"
Confirm.BackgroundColor3 = Color3.fromRGB(60,60,60)
Confirm.TextColor3 = Color3.new(1,1,1)

-- ================= HUB =================
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0,500,0,300)
HubFrame.Position = UDim2.new(0.5,-250,0.5,-150)
HubFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
HubFrame.Visible = false
HubFrame.Parent = ScreenGui
dragify(HubFrame)

local HubTitle = Instance.new("TextLabel", HubFrame)
HubTitle.Size = UDim2.new(1,0,0,40)
HubTitle.Text = HUB_NAME
HubTitle.TextColor3 = Color3.new(1,1,1)
HubTitle.BackgroundTransparency = 1
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 18

-- ABAS
local Tabs = Instance.new("Frame", HubFrame)
Tabs.Size = UDim2.new(0,120,1,-40)
Tabs.Position = UDim2.new(0,0,0,40)
Tabs.BackgroundColor3 = Color3.fromRGB(25,25,25)

local Pages = Instance.new("Frame", HubFrame)
Pages.Size = UDim2.new(1,-120,1,-40)
Pages.Position = UDim2.new(0,120,0,40)
Pages.BackgroundTransparency = 1

local function createTab(name)
    local Button = Instance.new("TextButton", Tabs)
    Button.Size = UDim2.new(1,0,0,40)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.Gotham

    local Page = Instance.new("Frame", Pages)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.BackgroundTransparency = 1

    Button.MouseButton1Click:Connect(function()
        for _,v in pairs(Pages:GetChildren()) do
            v.Visible = false
        end
        Page.Visible = true
    end)

    return Page
end

local MainPage = createTab("Main")
local PlayerPage = createTab("Player")

-- BOTÃO EXEMPLO
local TestButton = Instance.new("TextButton", MainPage)
TestButton.Size = UDim2.new(0,200,0,40)
TestButton.Position = UDim2.new(0,20,0,20)
TestButton.Text = "Hello World"
TestButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
TestButton.TextColor3 = Color3.new(1,1,1)

TestButton.MouseButton1Click:Connect(function()
    print("Script executado")
end)

-- KEY CHECK
Confirm.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY_CORRETA then
        KeyFrame:Destroy()
        HubFrame.Visible = true
        MainPage.Visible = true
    else
        KeyBox.Text = "KEY INVÁLIDA"
    end
end)
