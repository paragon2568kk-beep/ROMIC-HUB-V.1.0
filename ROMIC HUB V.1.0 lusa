-- [[ ROMIC HUB V.1.0 - ULTIMATE MERGED ]]
if _G.RomicLoaded then 
    local old = game:GetService("CoreGui"):FindFirstChild("RomicHub")
    if old then old:Destroy() end
end
_G.RomicLoaded = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- [[ SETTINGS ]]
_G.Speed = 50        -- ความเร็ววิ่ง
_G.UseSpeed = false  -- สถานะเปิด/ปิดวิ่งเร็ว
_G.NoClip = false
_G.AutoClick = false
_G.Fly = false
_G.FlySpeed = 50
_G.ESP_Chams = false

local FlyUp = false
local FlyDown = false

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RomicHub"

-- ปุ่มควบคุมบินสำหรับมือถือ
local FlyControls = Instance.new("Frame", ScreenGui)
FlyControls.Size = UDim2.new(0, 70, 0, 150); FlyControls.Position = UDim2.new(0.85, 0, 0.4, 0)
FlyControls.BackgroundTransparency = 1; FlyControls.Visible = false

local btnUp = Instance.new("TextButton", FlyControls)
btnUp.Size = UDim2.new(1, 0, 0, 70); btnUp.Text = "▲"; btnUp.BackgroundColor3 = Color3.fromRGB(0, 255, 120); btnUp.TextSize = 40; btnUp.Font = Enum.Font.SourceSansBold
local btnDown = Instance.new("TextButton", FlyControls)
btnDown.Size = UDim2.new(1, 0, 0, 70); btnDown.Position = UDim2.new(0, 0, 0, 80); btnDown.Text = "▼"; btnDown.BackgroundColor3 = Color3.fromRGB(255, 60, 60); btnDown.TextSize = 40; btnDown.Font = Enum.Font.SourceSansBold

btnUp.MouseButton1Down:Connect(function() FlyUp = true end); btnUp.MouseButton1Up:Connect(function() FlyUp = false end)
btnDown.MouseButton1Down:Connect(function() FlyDown = true end); btnDown.MouseButton1Up:Connect(function() FlyDown = false end)

-- เมนูหลัก
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 360); Main.Position = UDim2.new(0.5, -250, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 2; Main.BorderColor3 = Color3.fromRGB(0, 255, 255); Main.Active = true; Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "ROMIC HUB V.1.0 | รวมทุกฟังก์ชัน"; Title.TextColor3 = Color3.fromRGB(0, 255, 255); Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 40, 1, 0); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.Text = "-"; CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Sidebar
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, 130, 1, -40); TabBar.Position = UDim2.new(0, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -140, 1, -50); Container.Position = UDim2.new(0, 140, 0, 45); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.Name = name; f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0); f.ScrollBarThickness = 3
    local list = Instance.new("UIListLayout", f); list.Padding = UDim.new(0, 5)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() f.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10) end)
    return f
end

local Pages = { Move = CreatePage("Move"), Visual = CreatePage("Visual"), Event = CreatePage("Event"), TP = CreatePage("TP"), Spectate = CreatePage("Spectate"), Special = CreatePage("Special") }

local function AddTab(txt, page)
    local b = Instance.new("TextButton", TabBar)
    b.Size = UDim2.new(1, -10, 0, 32); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.TextSize = 13
    b.Position = UDim2.new(0, 5, 0, (#TabBar:GetChildren()-1)*35)
    b.MouseButton1Click:Connect(function() for _,p in pairs(Pages) do p.Visible = false end page.Visible = true end)
end

AddTab("เดิน/คลิก", Pages.Move)
AddTab("การมองเห็น", Pages.Visual)
AddTab("อีเว้นท์", Pages.Event)
AddTab("วาร์ปหาคน", Pages.TP)
AddTab("ส่องผู้เล่น", Pages.Spectate)
AddTab("พิเศษ/บิน", Pages.Special)

local function MakeToggle(txt, parent, varName, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 35)
    local function Update() 
        b.Text = txt .. (_G[varName] and ": เปิด" or ": ปิด")
        b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
        if callback then callback(_G[varName]) end
    end
    Update(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName]; Update() end)
end

-- [[ หมวดวาร์ปหาคน (Teleport) ]]
local function RefreshTP()
    for _, v in pairs(Pages.TP:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local RefBtn = Instance.new("TextButton", Pages.TP); RefBtn.Size = UDim2.new(1, 0, 0, 35); RefBtn.Text = "🔄 รีเฟรชรายชื่อวาร์ป"; RefBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100); RefBtn.MouseButton1Click:Connect(RefreshTP)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", Pages.TP); b.Size = UDim2.new(1, 0, 0, 30); b.Text = "วาร์ปไปหา: " .. p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.MouseButton1Click:Connect(function() if p.Character then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end)
        end
    end
end

-- [[ หมวดส่องผู้เล่น (Spectate - FIXED) ]]
local function RefreshSpectate()
    for _, v in pairs(Pages.Spectate:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local RefBtn = Instance.new("TextButton", Pages.Spectate); RefBtn.Size = UDim2.new(1, 0, 0, 35); RefBtn.Text = "🔄 รีเฟรชรายชื่อส่อง"; RefBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200); RefBtn.MouseButton1Click:Connect(RefreshSpectate)
    local selfBtn = Instance.new("TextButton", Pages.Spectate); selfBtn.Size = UDim2.new(1, 0, 0, 35); selfBtn.Text = "🏠 กลับมาดูตัวเอง"; selfBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 0); selfBtn.MouseButton1Click:Connect(function() Camera.CameraSubject = Player.Character.Humanoid end)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", Pages.Spectate); b.Size = UDim2.new(1, 0, 0, 30); b.Text = "ส่อง: " .. p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.MouseButton1Click:Connect(function() if p.Character and p.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = p.Character.Humanoid end end)
        end
    end
end

-- [[ หมวดอีเว้นท์ ]]
local function ScanEvents()
    for _, v in pairs(Pages.Event:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local RefEv = Instance.new("TextButton", Pages.Event); RefEv.Size = UDim2.new(1, 0, 0, 40); RefEv.Text = "🔍 ค้นหาของกิจกรรม"; RefEv.BackgroundColor3 = Color3.fromRGB(0, 150, 100); RefEv.MouseButton1Click:Connect(ScanEvents)
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and (obj.Name:lower():find("event") or obj.Name:lower():find("coin")) then
            local b = Instance.new("TextButton", Pages.Event); b.Size = UDim2.new(1, 0, 0, 30); b.Text = "วาร์ป: "..obj.Name; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.MouseButton1Click:Connect(function() Player.Character.HumanoidRootPart.CFrame = CFrame.new(obj:IsA("Model") and obj:GetModelCFrame().Position or obj.Position) end)
        end
    end
end

-- [[ ตั้งค่าฟังชั่นหลัก ]]
MakeToggle("เปิดวิ่งเร็ว (Speed)", Pages.Move, "UseSpeed")
MakeToggle("เดินทะลุ (NoClip)", Pages.Move, "NoClip")
MakeToggle("ออโต้คลิก", Pages.Move, "AutoClick")
MakeToggle("ตัวเรืองแสง (Chams)", Pages.Visual, "ESP_Chams")
MakeToggle("ระบบบิน (Fly Mobile)", Pages.Special, "Fly", function(v) FlyControls.Visible = v end)

-- [[ ENGINE CORE ]]
RunService.RenderStepped:Connect(function()
    if _G.Fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Root = Player.Character.HumanoidRootPart
        if not Root:FindFirstChild("R_FlyV") then
            local bv = Instance.new("BodyVelocity", Root); bv.Name = "R_FlyV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local bg = Instance.new("BodyGyro", Root); bg.Name = "R_FlyG"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
        end
        Root.R_FlyG.CFrame = Camera.CFrame
        local vel = Player.Character.Humanoid.MoveDirection * _G.FlySpeed
        if FlyUp then vel = vel + Vector3.new(0, _G.FlySpeed, 0) elseif FlyDown then vel = vel + Vector3.new(0, -_G.FlySpeed, 0) end
        Root.R_FlyV.Velocity = vel
    else
        pcall(function() Player.Character.HumanoidRootPart.R_FlyV:Destroy(); Player.Character.HumanoidRootPart.R_FlyG:Destroy() end)
    end
end)

-- เรืองแสง
local function ApplyChams(p)
    local Highlight = Instance.new("Highlight")
    Highlight.FillColor = Color3.fromRGB(0, 255, 255)
    RunService.RenderStepped:Connect(function() if p.Character then Highlight.Parent = _G.ESP_Chams and p.Character or nil end end)
end
for _, v in pairs(Players:GetPlayers()) do if v ~= Player then ApplyChams(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= Player then ApplyChams(v) end end)

-- ลูปการทำงาน (Speed & NoClip)
task.spawn(function()
    while true do task.wait(0.1)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            -- ระบบวิ่งเร็ว
            if _G.UseSpeed then Player.Character.Humanoid.WalkSpeed = _G.Speed else Player.Character.Humanoid.WalkSpeed = 16 end
            -- ระบบเดินทะลุ
            if _G.NoClip then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end
    end
end)

-- ปุ่มย่อเมนู
local MiniBtn = Instance.new("TextButton", ScreenGui); MiniBtn.Size = UDim2.new(0, 60, 0, 30); MiniBtn.Position = UDim2.new(0, 10, 0.5, 0); MiniBtn.Text = "ROMIC"; MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); MiniBtn.Visible = false; MiniBtn.Draggable = true
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; MiniBtn.Visible = true end)
MiniBtn.MouseButton1Click:Connect(function() Main.Visible = true; MiniBtn.Visible = false end)

Pages.Move.Visible = true
RefreshTP(); RefreshSpectate(); ScanEvents();
