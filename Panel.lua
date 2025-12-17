--[[ 
  7dvi HUB - SINGLE FILE
  Fly | Speed | TP | ESP | Aimbot
  UI Moderna | Slider ESP | Compatível com executores
]]

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

-- ================= SAFE UI =================
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
    ESP_Box = false,
    ESP_Name = false,
    ESP_Distance = false,
    Aimbot = false
}

local FlySpeed = 60
local WalkSpeedValue = 40
local AimFOV = 120
local ESP_NameSize = 14

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", UIParent)
ScreenGui.Name = "7dviHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,520,0,380)
Main.Position = UDim2.new(0.5,-260,0.5,-190)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- ================= ANIMATION =================
local function toggleUI()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Size = UDim2.new(0,0,0,0)
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0,520,0,380)
        }):Play()
    end
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
Title.Text = "7dvi"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.new(1,1,1)

-- ================= TOGGLE =================
local function createToggle(text, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0,220,0,36)
    b.Position = UDim2.new(0,20,0,y)
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

-- ================= SLIDER =================
local function createSlider(text, y, min, max, default, callback)
    local holder = Instance.new("Frame", Main)
    holder.Size = UDim2.new(0,220,0,50)
    holder.Position = UDim2.new(0,20,0,y)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = text..": "..default
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13

    local bar = Instance.new("Frame", holder)
    bar.Position = UDim2.new(0,0,0,30)
    bar.Size = UDim2.new(1,0,0,8)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(120,120,255)
    Instance.new("UICorner", fill)

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local scale = math.clamp(
                (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1
            )
            fill.Size = UDim2.new(scale,0,1,0)
            local value = math.floor(min + (max-min)*scale)
            label.Text = text..": "..value
            callback(value)
        end
    end)
end

-- ================= FLY =================
local flyBV, flyBG
createToggle("Fly",60,function(v)
    States.Fly = v
    local c = LocalPlayer.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if v then
        flyBV = Instance.new("BodyVelocity",hrp)
        flyBV.MaxForce = Vector3.new(1,1,1)*9e9
        flyBG = Instance.new("BodyGyro",hrp)
        flyBG.MaxTorque = Vector3.new(1,1,1)*9e9
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if not States.Fly then return end
    local c = LocalPlayer.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local cam = Camera.CFrame
    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
    flyBV.Velocity = dir * FlySpeed
    flyBG.CFrame = cam
end)

-- ================= SPEED =================
createToggle("Speed",110,function(v)
    States.Speed = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v and WalkSpeedValue or 16 end
end)

-- ================= AIMBOT =================
createToggle("Aimbot",160,function(v) States.Aimbot = v end)

local function getClosest()
    local c,dist
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
                if mag<=AimFOV and (not dist or mag<dist) then
                    dist=mag c=p
                end
            end
        end
    end
    return c
end

RunService.RenderStepped:Connect(function()
    if States.Aimbot and UIS:IsMouseButtonPressed(AIM_KEY) then
        local t = getClosest()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position,t.Character.Head.Position),0.15
            )
        end
    end
end)

-- ================= ESP =================
local drawings = {}
local function clearESP()
    for _,d in pairs(drawings) do pcall(function() d:Remove() end) end
    drawings = {}
end

createToggle("ESP Box",210,function(v) States.ESP_Box=v end)
createToggle("ESP Nome",250,function(v) States.ESP_Name=v end)
createToggle("ESP Distância",290,function(v) States.ESP_Distance=v end)

createSlider("ESP Nome Tamanho",330,10,30,ESP_NameSize,function(v)
    ESP_NameSize = v
end)

RunService.RenderStepped:Connect(function()
    clearESP()
    if not Drawing then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=p.Character.HumanoidRootPart
            local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
            if not vis then continue end

            if States.ESP_Box then
                local b=Drawing.new("Square")
                b.Size=Vector2.new(60,90)
                b.Position=Vector2.new(pos.X-30,pos.Y-45)
                b.Color=Color3.new(1,0,0)
                b.Filled=false
                table.insert(drawings,b)
            end

            if States.ESP_Name then
                local t=Drawing.new("Text")
                t.Text=p.Name
                t.Size=ESP_NameSize
                t.Center=true
                t.Position=Vector2.new(pos.X,pos.Y-55)
                t.Color=Color3.new(1,1,1)
                table.insert(drawings,t)
            end

            if States.ESP_Distance then
                local d=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude)
                local t=Drawing.new("Text")
                t.Text=d.."m"
                t.Center=true
                t.Size=13
                t.Position=Vector2.new(pos.X,pos.Y+50)
                t.Color=Color3.new(1,1,1)
                table.insert(drawings,t)
            end
        end
    end
end)

-- ================= AUTO OPEN =================
toggleUI()
-- ================= PLAYER TP LIST =================
local TPFrame = Instance.new("Frame", Main)
TPFrame.Size = UDim2.new(0,240,0,300)
TPFrame.Position = UDim2.new(0,260,0,60)
TPFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", TPFrame)

local TPTitle = Instance.new("TextLabel", TPFrame)
TPTitle.Size = UDim2.new(1,0,0,30)
TPTitle.BackgroundTransparency = 1
TPTitle.Text = "Players TP"
TPTitle.Font = Enum.Font.GothamBold
TPTitle.TextSize = 15
TPTitle.TextColor3 = Color3.new(1,1,1)

local TPScroll = Instance.new("ScrollingFrame", TPFrame)
TPScroll.Position = UDim2.new(0,0,0,35)
TPScroll.Size = UDim2.new(1,0,1,-35)
TPScroll.CanvasSize = UDim2.new(0,0,0,0)
TPScroll.ScrollBarImageTransparency = 0.6
TPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TPScroll.BackgroundTransparency = 1

local TPLayout = Instance.new("UIListLayout", TPScroll)
TPLayout.Padding = UDim.new(0,6)

-- ================= TP FUNCTION =================
local function teleportTo(plr)
    local char = LocalPlayer.Character
    if char and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        char:PivotTo(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
    end
end

-- ================= REFRESH LIST =================
local function refreshTPList()
    TPScroll:ClearAllChildren()
    TPLayout.Parent = TPScroll

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local item = Instance.new("Frame", TPScroll)
            item.Size = UDim2.new(1,-10,0,36)
            item.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Instance.new("UICorner", item)

            local name = Instance.new("TextLabel", item)
            name.Size = UDim2.new(0.65,0,1,0)
            name.BackgroundTransparency = 1
            name.Text = p.Name
            name.Font = Enum.Font.Gotham
            name.TextSize = 13
            name.TextColor3 = Color3.new(1,1,1)
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.Position = UDim2.new(0,8,0,0)

            local tp = Instance.new("TextButton", item)
            tp.Size = UDim2.new(0.28,0,0.75,0)
            tp.Position = UDim2.new(0.7,0,0.125,0)
            tp.Text = "TP"
            tp.Font = Enum.Font.GothamBold
            tp.TextSize = 13
            tp.BackgroundColor3 = Color3.fromRGB(120,120,255)
            tp.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", tp)

            tp.MouseButton1Click:Connect(function()
                teleportTo(p)
            end)
        end
    end
end

-- ================= AUTO UPDATE =================
refreshTPList()
Players.PlayerAdded:Connect(refreshTPList)
Players.PlayerRemoving:Connect(refreshTPList)

-- ================= AUTO OPEN =================
toggleUI()
