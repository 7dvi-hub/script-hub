--[[ 
  7dvi HUB | Anti-Detect + Tabs
  Combat | Visual | Player
]]

-- ================= ANTI DETECT =================
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt,false)

    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self,...)
        local method = getnamecallmethod()
        if method == "Kick" or tostring(self) == "Kick" then
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
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local TOGGLE_KEY = Enum.KeyCode.RightShift
local AIM_KEY = Enum.UserInputType.MouseButton2

-- ================= UI SAFE =================
local UIParent = (gethui and gethui()) or game.CoreGui
pcall(function()
    for _,v in ipairs(UIParent:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:find("Hub") then
            v:Destroy()
        end
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
local ESP_NameSize = 14

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", UIParent)
ScreenGui.Name = "Ui_"..math.random(1000,9999)
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,540,0,400)
Main.Position = UDim2.new(0.5,-270,0.5,-200)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- ================= TOGGLE UI =================
local function toggleUI()
    Main.Visible = not Main.Visible
end

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == TOGGLE_KEY then
        toggleUI()
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
local Tabs = {}
local Buttons = {}

local function createTab(name, x)
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
        for _,f in pairs(Tabs) do f.Visible = false end
        frame.Visible = true
    end)

    table.insert(Tabs, frame)
    return frame
end

local CombatTab = createTab("Combat",20)
local VisualTab = createTab("Visual",190)
local PlayerTab = createTab("Player",360)

CombatTab.Visible = true

-- ================= UI HELPERS =================
local function toggle(parent,text,y,callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,220,0,36)
    b.Position = UDim2.new(0,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    Instance.new("UICorner", b)

    local on = false
    b.Text = text.." : OFF"

    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text..(on and " : ON" or " : OFF")
        callback(on)
    end)
end

-- ================= COMBAT =================
toggle(CombatTab,"Aimbot",10,function(v)
    States.Aimbot = v
end)

local function getClosest()
    local best,dist
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X,pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag <= AimFOV and (not dist or mag < dist) then
                    dist = mag
                    best = p
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if States.Aimbot and UIS:IsMouseButtonPressed(AIM_KEY) then
        local t = getClosest()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, t.Character.Head.Position),0.15
            )
        end
    end
end)

-- ================= VISUAL =================
toggle(VisualTab,"ESP Box",10,function(v) States.ESP_Box = v end)
toggle(VisualTab,"ESP Nome",55,function(v) States.ESP_Name = v end)
toggle(VisualTab,"ESP Distância",100,function(v) States.ESP_Distance = v end)

-- ================= PLAYER =================
toggle(PlayerTab,"Fly",10,function(v) States.Fly = v end)
toggle(PlayerTab,"Speed",55,function(v)
    States.Speed = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v and WalkSpeedValue or 16 end
end)

-- ================= TP POR NICK =================
local NickBox = Instance.new("TextBox", PlayerTab)
NickBox.Size = UDim2.new(0,220,0,30)
NickBox.Position = UDim2.new(0,0,0,110)
NickBox.PlaceholderText = "TP por nick"
NickBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
NickBox.TextColor3 = Color3.new(1,1,1)
NickBox.Font = Enum.Font.Gotham
NickBox.TextSize = 13
Instance.new("UICorner", NickBox)

local function findPlayer(txt)
    txt = txt:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower():sub(1,#txt) == txt then
            return p
        end
    end
end

NickBox.FocusLost:Connect(function(enter)
    if enter then
        local p = findPlayer(NickBox.Text)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(
                p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            )
        end
        NickBox.Text = ""
    end
end)

-- ================= AUTO OPEN =================
toggleUI()
