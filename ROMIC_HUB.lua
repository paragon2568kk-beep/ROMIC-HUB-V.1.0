-- [[ ROMIC HUB V.1.8 - THE ULTIMATE ALL-IN-ONE ]]
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
_G.Speed = 50
_G.UseSpeed = false
_G.NoClip = false
_G.Fly = false
_G.FlySpeed = 50
_G.Spin = false
_G.DisturbTarget = nil
_G.FlingTarget = nil
_G.FlingAll = false
_G.SavedPos = nil 

local FlyUp = false
local FlyDown = false
local RainbowLabels = {}

-- [[ RAINBOW ENGINE ]]
task.spawn(function()
    while true do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, label in pairs(RainbowLabels) do
            if label and label.Parent then
                label.TextColor3 = color
            end
        end
        task.wait()
    end
end)

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RomicHub"

-- 🔴 ปุ่มหยุดปั่นด่วน (QUICK STOP)
local QuickStop = Instance.new("TextButton", ScreenGui)
QuickStop.Size = UDim2.new(0, 110, 0, 40); QuickStop.Position = UDim2.new(0, 10, 0.5, 45)
QuickStop.Text = "🛑 STOP TROLL"; QuickStop.BackgroundColor3 = Color3.fromRGB(150, 0, 0); QuickStop.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickStop.Font = Enum.Font.SourceSansBold; QuickStop.TextSize = 14; QuickStop.Draggable = true; QuickStop.BorderSizePixel = 2; QuickStop.BorderColor3 = Color3.fromRGB(255, 255, 255)

QuickStop.MouseButton1Click:Connect(function()
    _G.DisturbTarget = nil; _G.FlingTarget = nil; _G.FlingAll = false
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ROMIC HUB", Text = "หยุดการทำงานทั้งหมด!", Duration = 1.5})
end)

-- 🏠 ปุ่มวาร์ปกลับด่วน (QUICK GO BACK)
local QuickBack = Instance.new("TextButton", ScreenGui)
QuickBack.Size = UDim2.new(0, 110, 0, 40); QuickBack.Position = UDim2.new(0, 10, 0.5, 90)
QuickBack.Text = "🏠 GO BACK"; QuickBack.BackgroundColor3 = Color3.fromRGB(0, 80, 150); QuickBack.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickBack.Font = Enum.Font.SourceSansBold; QuickBack.TextSize = 14; QuickBack.Draggable = true; QuickBack.BorderSizePixel = 2; QuickBack.BorderColor3 = Color3.fromRGB(255, 255, 255)

QuickBack.MouseButton1Click:Connect(function()
    if _G.SavedPos and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = _G.SavedPos
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ROMIC HUB", Text = "ยังไม่ได้เซฟจุด!", Duration = 1.5})
    end
end)

-- Main UI Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 360); Main.Position = UDim2.new(0.5, -250, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 2; Main.BorderColor3 = Color3.fromRGB(0, 255, 255); Main.Active = true; Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "ROMIC HUB V.1.8 | THE ULTIMATE"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20
table.insert(RainbowLabels, Title)

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 40, 1, 0); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.Text = "-"; CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local TabBar = Instance.new("Frame", Main); TabBar.Size = UDim2.new(0, 130, 1, -40); TabBar.Position = UDim2.new(0, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -140, 1, -50); Container.Position = UDim2.new(0, 140, 0, 45); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", Container); f.Name = name; f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    local list = Instance.new("UIListLayout", f); list.Padding = UDim.new(0, 5)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() f.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10) end)
    return f
end

local Pages = { Move = CreatePage("Move"), TP = CreatePage("TP"), Troll = CreatePage("Troll"), SavePos = CreatePage("SavePos"), Special = CreatePage("Special") }

local function AddTab(txt, page)
    local b = Instance.new("TextButton", TabBar); b.Size = UDim2.new(1, -10, 0, 32); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold
    b.Position = UDim2.new(0, 5, 0, (#TabBar:GetChildren()-1)*35); table.insert(RainbowLabels, b)
    b.MouseButton1Click:Connect(function() for _,p in pairs(Pages) do p.Visible = false end page.Visible = true end)
end

AddTab("เดิน/คลิก", Pages.Move); AddTab("วาร์ปหาคน", Pages.TP); AddTab("ปั่นผู้เล่น", Pages.Troll); AddTab("ตั้งค่าจุดวาร์ป", Pages.SavePos); AddTab("พิเศษ/บิน", Pages.Special)

-- [[ SYSTEMS ]]
local FlingAllBtn = Instance.new("TextButton", Pages.Troll)
FlingAllBtn.Size = UDim2.new(1, 0, 0, 50); FlingAllBtn.Text = "🚀 ปั่นทุกคน (Fling All)"; FlingAllBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); table.insert(RainbowLabels, FlingAllBtn)
FlingAllBtn.MouseButton1Click:Connect(function() _G.FlingAll = not _G.FlingAll FlingAllBtn.Text = _G.FlingAll and "🔥 กำลังปั่นทุกคน..." or "🚀 ปั่นทุกคน (Fling All)" end)

local function RefreshTroll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local f = Instance.new("Frame", Pages.Troll); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
            local bF = Instance.new("TextButton", f); bF.Size = UDim2.new(0.5, -5, 1, 0); bF.Text = "🚀 ผลัก: "..p.DisplayName; bF.BackgroundColor3 = Color3.fromRGB(100, 50, 0); table.insert(RainbowLabels, bF)
            local bD = Instance.new("TextButton", f); bD.Position = UDim2.new(0.5, 5, 0, 0); bD.Size = UDim2.new(0.5, -5, 1, 0); bD.Text = "🌀 ปั่น"; bD.BackgroundColor3 = Color3.fromRGB(80, 0, 120); table.insert(RainbowLabels, bD)
            bF.MouseButton1Click:Connect(function() _G.FlingTarget = p end); bD.MouseButton1Click:Connect(function() _G.DisturbTarget = p end)
        end
    end
end

local SaveBtn = Instance.new("TextButton", Pages.SavePos); SaveBtn.Size = UDim2.new(1, 0, 0, 50); SaveBtn.Text = "📍 เซฟตำแหน่งปัจจุบัน"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0); table.insert(RainbowLabels, SaveBtn)
SaveBtn.MouseButton1Click:Connect(function() if Player.Character then _G.SavedPos = Player.Character.HumanoidRootPart.CFrame end end)

-- [[ CORE ENGINE ]]
RunService.Heartbeat:Connect(function()
    local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    if _G.FlingTarget and _G.FlingTarget.Character and _G.FlingTarget.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = _G.FlingTarget.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
        Root.Velocity = Vector3.new(999999, 999999, 999999)
    elseif _G.FlingAll then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                Root.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                Root.Velocity = Vector3.new(999999, 999999, 999999)
            end
        end
    elseif _G.DisturbTarget and _G.DisturbTarget.Character and _G.DisturbTarget.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = _G.DisturbTarget.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-7,7), math.random(0,3), math.random(-7,7))
    end
    
    if _G.Spin then Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(60), 0) end
end)

local function MakeToggle(txt, parent, varName)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 35); table.insert(RainbowLabels, b)
    local function Update() b.Text = txt..(_G[varName] and ": เปิด" or ": ปิด") b.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 40) end
    Update(); b.MouseButton1Click:Connect(function() _G[varName] = not _G[varName] Update() end)
end

MakeToggle("เดินทะลุ (NoClip)", Pages.Move, "NoClip"); MakeToggle("ระบบหมุนตัว", Pages.Special, "Spin")

local MiniBtn = Instance.new("TextButton", ScreenGui); MiniBtn.Size = UDim2.new(0, 60, 0, 30); MiniBtn.Position = UDim2.new(0, 10, 0.5, 0); MiniBtn.Text = "ROMIC"; MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); MiniBtn.Visible = false; MiniBtn.Draggable = true; table.insert(RainbowLabels, MiniBtn)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; MiniBtn.Visible = true end); MiniBtn.MouseButton1Click:Connect(function() Main.Visible = true; MiniBtn.Visible = false end)

RefreshTroll(); Pages.Move.Visible = true

