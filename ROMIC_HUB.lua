-- [[ ROMIC HUB V.2.0 - TRINITY BUTTONS & TP FIX ]]
if _G.RomicLoaded then 
    local old = game:GetService("CoreGui"):FindFirstChild("RomicHub")
    if old then old:Destroy() end
end
_G.RomicLoaded = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- [[ SETTINGS ]]
_G.NoClip = true
_G.FlingAll = false
_G.SavedPos = nil
_G.DisturbTarget = nil
_G.FlingTarget = nil

local RainbowLabels = {}

-- [[ RAINBOW ENGINE ]]
task.spawn(function()
    while true do
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, label in pairs(RainbowLabels) do
            if label and label.Parent then label.TextColor3 = color end
        end
        task.wait()
    end
end)

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RomicHub"

local function CreateQuickBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", ScreenGui)
    b.Size = UDim2.new(0, 110, 0, 40); b.Position = pos
    b.Text = txt; b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold; b.TextSize = 14; b.Draggable = true
    b.BorderSizePixel = 2; b.BorderColor3 = Color3.fromRGB(255, 255, 255)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- 🛑 ปุ่มหยุดด่วน
CreateQuickBtn("🛑 STOP TROLL", UDim2.new(0, 10, 0.5, -45), Color3.fromRGB(150, 0, 0), function()
    _G.FlingAll = false; _G.FlingTarget = nil; _G.DisturbTarget = nil
end)

-- 🏠 ปุ่มวาร์ปกลับด่วน
CreateQuickBtn("🏠 GO BACK", UDim2.new(0, 10, 0.5, 0), Color3.fromRGB(0, 80, 150), function()
    if _G.SavedPos then Player.Character.HumanoidRootPart.CFrame = _G.SavedPos end
end)

-- 🚀 ปุ่มปั่นทุกคนด่วน (แยกออกจาก UI)
local QuickFlingAll = CreateQuickBtn("🚀 FLING ALL", UDim2.new(0, 10, 0.5, 45), Color3.fromRGB(200, 0, 0), function()
    _G.FlingAll = not _G.FlingAll
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "ROMIC HUB", Text = _G.FlingAll and "เริ่มปั่นทุกคน!" or "หยุดปั่นทุกคนแล้ว", Duration = 1.5})
end)
table.insert(RainbowLabels, QuickFlingAll)

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 360); Main.Position = UDim2.new(0.5, -250, 0.5, -180); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "ROMIC HUB V.2.0 | TP FIX & SEPARATE BTN"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20; table.insert(RainbowLabels, Title)

local TabBar = Instance.new("Frame", Main); TabBar.Size = UDim2.new(0, 130, 1, -40); TabBar.Position = UDim2.new(0, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -140, 1, -50); Container.Position = UDim2.new(0, 140, 0, 45); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local f = Instance.new("ScrollingFrame", Container); f.Name = name; f.Size = UDim2.new(1, 0, 1, 0); f.BackgroundTransparency = 1; f.Visible = false; f.CanvasSize = UDim2.new(0, 0, 0, 0)
    local list = Instance.new("UIListLayout", f); list.Padding = UDim.new(0, 5)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() f.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10) end)
    return f
end

local Pages = { TP = CreatePage("TP"), SavePos = CreatePage("SavePos"), Troll = CreatePage("Troll") }

local function AddTab(txt, page)
    local b = Instance.new("TextButton", TabBar); b.Size = UDim2.new(1, -10, 0, 32); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold
    b.Position = UDim2.new(0, 5, 0, (#TabBar:GetChildren()-1)*35); table.insert(RainbowLabels, b)
    b.MouseButton1Click:Connect(function() for _,p in pairs(Pages) do p.Visible = false end page.Visible = true end)
end

AddTab("วาร์ปหาคน", Pages.TP); AddTab("ปั่นผู้เล่น", Pages.Troll); AddTab("ตั้งค่าจุดวาร์ป", Pages.SavePos)

-- [[ TP SYSTEM FIX ]]
local function RefreshLists()
    for _,p in pairs(Pages.TP:GetChildren()) do if p:IsA("TextButton") then p:Destroy() end end
    for _,p in pairs(Pages.Troll:GetChildren()) do if p:IsA("Frame") then p:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            -- หน้า TP
            local tpB = Instance.new("TextButton", Pages.TP); tpB.Size = UDim2.new(1, 0, 0, 35); tpB.Text = "📍 วาร์ปไปหา: "..p.DisplayName; tpB.BackgroundColor3 = Color3.fromRGB(40, 40, 40); tpB.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpB.MouseButton1Click:Connect(function() Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end)
            
            -- หน้า Troll รายบุคคล
            local f = Instance.new("Frame", Pages.Troll); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
            local bF = Instance.new("TextButton", f); bF.Size = UDim2.new(0.5, -5, 1, 0); bF.Text = "🚀 ผลัก"; bF.BackgroundColor3 = Color3.fromRGB(100, 50, 0); bF.MouseButton1Click:Connect(function() _G.FlingTarget = p end)
            local bD = Instance.new("TextButton", f); bD.Position = UDim2.new(0.5, 5, 0, 0); bD.Size = UDim2.new(0.5, -5, 1, 0); bD.Text = "🌀 ปั่น"; bD.BackgroundColor3 = Color3.fromRGB(80, 0, 120); bD.MouseButton1Click:Connect(function() _G.DisturbTarget = p end)
        end
    end
end
Players.PlayerAdded:Connect(RefreshLists); Players.PlayerRemoving:Connect(RefreshLists)

-- [[ SAVE POS ]]
local SaveBtn = Instance.new("TextButton", Pages.SavePos); SaveBtn.Size = UDim2.new(1, 0, 0, 50); SaveBtn.Text = "📍 เซฟจุดกลับ"; SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0); table.insert(RainbowLabels, SaveBtn)
SaveBtn.MouseButton1Click:Connect(function() if Player.Character then _G.SavedPos = Player.Character.HumanoidRootPart.CFrame end end)

-- [[ CORE ENGINE ]]
RunService.Heartbeat:Connect(function()
    local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    if _G.FlingTarget and _G.FlingTarget.Character and _G.FlingTarget.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = _G.FlingTarget.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
        Root.Velocity = Vector3.new(999999, 999999, 999999)
    elseif _G.DisturbTarget and _G.DisturbTarget.Character and _G.DisturbTarget.Character:FindFirstChild("HumanoidRootPart") then
        Root.CFrame = _G.DisturbTarget.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-7,7), math.random(0,3), math.random(-7,7))
    end
end)

task.spawn(function()
    while true do
        if _G.FlingAll then
            for _, p in pairs(Players:GetPlayers()) do
                if not _G.FlingAll then break end
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local tRoot = p.Character.HumanoidRootPart
                    local start = tick()
                    repeat
                        if not _G.FlingAll or not tRoot then break end
                        Player.Character.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                        Player.Character.HumanoidRootPart.Velocity = Vector3.new(999999, 999999, 999999)
                        task.wait()
                    until (tRoot.Velocity.Magnitude > 150) or (tick() - start > 1.2)
                end
            end
        end
        task.wait(0.1)
    end
end)

RunService.Stepped:Connect(function()
    if Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

local MiniBtn = Instance.new("TextButton", ScreenGui); MiniBtn.Size = UDim2.new(0, 60, 0, 30); MiniBtn.Position = UDim2.new(0, 10, 0.5, -90); MiniBtn.Text = "ROMIC"; MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); MiniBtn.Visible = false; MiniBtn.Draggable = true; table.insert(RainbowLabels, MiniBtn)
local CloseBtn = Instance.new("TextButton", Title); CloseBtn.Size = UDim2.new(0, 40, 1, 0); CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.Text = "-"; CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; MiniBtn.Visible = true end); MiniBtn.MouseButton1Click:Connect(function() Main.Visible = true; MiniBtn.Visible = false end)

RefreshLists(); Pages.TP.Visible = true

