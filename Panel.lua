--[[ 
  7dvi HUB | FUNCIONAL
  Anti-Detect Básico
  Combat | Visual | Player
]]

-- ================= ANTI DETECT =================
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self,...)
        if getnamecallmethod() == "Kick" then
            return
        end
        return old(self,...)
    end)
    setreadonly(mt,true)
end)

-- ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local TOGGLE_KEY = Enum.KeyCode.RightShift
local AIM_KEY = Enum.UserInputType.MouseButton2

-- ================= UI SAFE =================
local UIParent = (gethui and gethui()) or game.CoreGui
pcall(function()
    if UIParent:FindFirstChild("7dviHub") then
        UIParent["7dviHub"]:Destroy()
    end
end)

-- ================= STATES =================
local States = {
    Fly = false,
    Speed = false,
    Aimbot = false,
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false
}

local WalkSpeedValue = 40
local FlySpeed = 60
local AimFOV = 120

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", UIParent)
ScreenGui.Name = "7dviHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,540,0,400)
Main.Position = UDim2.new(0.5,-270,0.5,-200)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- ================= TOGGLE UI =================
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == TOGGLE_KEY then
        Main.Visible = not Main.Visible
    end
end)

-- ================= TITLE =================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "7dvi HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.new(1,1,1)

-- ================= TABS =================
local function createTab(name,x)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0,160,0,30)
    btn.Position = UDim2.new(0,x,0,45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    local frame = Instance.new("Frame", Main)
    frame.Size = UDim2.new(1,-20,1,-90)
    frame.Position = UDim2.new(0,10,0,85)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(Main:GetChildren()) do
            if v:IsA("Frame") and v ~= Main and v ~= frame then
                v.Visible = false
            end
        end
        frame.Visible = true
    end)

    return frame
end

local CombatTab = createTab("Combat",20)
local VisualTab = createTab("Visual",190)
local PlayerTab = createTab("Player",360)
CombatTab.Visible = true

-- ================= UI TOGGLE =================
local function Toggle(parent,text,y,callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,220,0,35)
    b.Position = UDim2.new(0,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    Instance.new("UICorner", b)
