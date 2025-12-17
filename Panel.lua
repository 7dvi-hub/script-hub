--[[ 
 PREMIUM HUB UI - SINGLE FILE
 Fly | TP | ESP | Aimbot | Speed
 Tecla configurável | UI Moderna | Compatível com executores
]]

-- ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local TOGGLE_KEY = Enum.KeyCode.RightShift -- altere para Insert / F se quiser
local AIM_KEY = Enum.UserInputType.MouseButton2

-- ================= SAFE UI PARENT =================
local UIParent = (gethui and gethui()) or game.CoreGui

pcall(function()
    if UIParent:FindFirstChild("PremiumHub") then
        UIParent.PremiumHub:Destroy()
    end
end)

-- ================= VARIABLES =================
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

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", UIParent)
ScreenGui.Name = "PremiumHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
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
        TweenService:Create(
            Main,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0,520,0,360)}
        ):Play()
    end
end

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == TOGGLE_KEY then
        toggleUI()
    end
end)

-- ================= TITLE =================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)

-- ================= BUTTON CREATOR =================
local function createToggle(text, parent, posY, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,220,0,36)
    btn.Position = UDim2.new(0,20,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local state = false
    btn.Text = text.." : OFF"

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..(state and " : ON" or " : OFF")
        callback(state)
    end)
end

-- ================= FLY =================
local flyBV, flyBG

createToggle("Fly", Main, 60, function(v)
    States.Fly = v
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if v then
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1,1,1)*9e9
        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(1,1,1)*9e9
    else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if not States.Fly then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local camCF = Camera.CFrame
    local move = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end

    flyBV.Velocity = move * FlySpeed
    flyBG.CFrame = camCF
end)

-- ================= SPEED =================
createToggle("Speed", Main, 110, function(v)
    States.Speed = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = v and WalkSpeedValue or 16
    end
end)

-- ================= TELEPORT =================
local TPFrame = Instance.new("Frame", Main)
TPFrame.Size = UDim2.new(0,220,0,120)
TPFrame.Position = UDim2.new(0,20,0,160)
TPFrame.BackgroundTransparency = 1

for i,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        local b = Instance.new("TextButton", TPFrame)
        b.Size = UDim2.new(1,0,0,24)
        b.Position = UDim2.new(0,0,0,(i-1)*26)
        b.Text = "TP → "..plr.Name
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame =
                    plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            end)
        end)
    end
end

-- ================= AIMBOT =================
local function getClosestTarget()
    local closest, dist
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X,pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag <= AimFOV and (not dist or mag < dist) then
                    dist = mag
                    closest = plr
                end
            end
        end
    end
    return closest
end

createToggle("Aimbot", Main, 300, function(v)
    States.Aimbot = v
end)

RunService.RenderStepped:Connect(function()
    if States.Aimbot and UIS:IsMouseButtonPressed(AIM_KEY) then
        local t = getClosestTarget()
        if t and t.Character then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, t.Character.Head.Position),
                0.15
            )
        end
    end
end)

-- ================= ESP (BOX / NAME / DIST) =================
local drawings = {}

local function clearESP()
    for _,d in pairs(drawings) do
        pcall(function() d:Remove() end)
    end
    drawings = {}
end

createToggle("ESP BOX", Main, 260, function(v) States.ESP_Box = v end)
createToggle("ESP NAME", Main, 260+40, function(v) States.ESP_Name = v end)
createToggle("ESP DIST", Main, 260+80, function(v) States.ESP_Distance = v end)

RunService.RenderStepped:Connect(function()
    clearESP()
    if not Drawing then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos,vis = Camera:WorldToViewportPoint(hrp.Position)
            if not vis then continue end

            if States.ESP_Box then
                local box = Drawing.new("Square")
                box.Size = Vector2.new(60,90)
                box.Position = Vector2.new(pos.X-30,pos.Y-45)
                box.Color = Color3.new(1,0,0)
                box.Filled = false
                table.insert(drawings, box)
            end

            if States.ESP_Name then
                local txt = Drawing.new("Text")
                txt.Text = plr.Name
                txt.Position = Vector2.new(pos.X, pos.Y-55)
                txt.Center = true
                txt.Color = Color3.new(1,1,1)
                table.insert(drawings, txt)
            end

            if States.ESP_Distance then
                local d = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                local txt = Drawing.new("Text")
                txt.Text = d.."m"
                txt.Position = Vector2.new(pos.X, pos.Y+50)
                txt.Center = true
                txt.Color = Color3.new(1,1,1)
                table.insert(drawings, txt)
            end
        end
    end
end)

-- ================= AUTO OPEN =================
toggleUI()
