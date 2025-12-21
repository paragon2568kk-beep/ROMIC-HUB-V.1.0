-- [[ ROMIC FLING BEAST V.2.1.19 - SMOOTH MOTION EDITION ]]
if _G.RomicLoaded then 
    local old = game:GetService("CoreGui"):FindFirstChild("RomicHub")
    if old then old:Destroy() end
end
_G.RomicLoaded = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RomicHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999

_G.TotalKills = 0
_G.FlingAll = false
_G.AntiFlingInstalled = false
local KnockedList = {} 

local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = false

-- [[ 🌈 RAINBOW RGB HIGHLIGHT SYSTEM ]]
local function ApplyHighlight(char)
    if not char:FindFirstChild("RomicHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "RomicHighlight"
        highlight.Parent = char
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

task.spawn(function()
    while true do
        local color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                ApplyHighlight(p.Character)
                local h = p.Character:FindFirstChild("RomicHighlight")
                if h then
                    h.FillColor = color
                    h.OutlineColor = color
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- [[ 🌟 NEON GLOW LOADING SYSTEM ]]
local function ShowLoading(title, duration, isMain, callback)
    local LoadBg = Instance.new("Frame", ScreenGui)
    LoadBg.Size = UDim2.new(1, 0, 1, 0); LoadBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0); LoadBg.BackgroundTransparency = 0.2; LoadBg.ZIndex = 10000
    local Main = Instance.new("Frame", LoadBg)
    Main.Size = UDim2.new(0, 400, 0, 140); Main.Position = UDim2.new(0.5, -200, 0.5, -70); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.ZIndex = 10001
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local Glow = Instance.new("UIStroke", Main); Glow.Thickness = 4; Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local Txt = Instance.new("TextLabel", Main)
    Txt.Size = UDim2.new(1, 0, 0, 60); Txt.BackgroundTransparency = 1; Txt.Text = title; Txt.TextColor3 = Color3.new(1,1,1); Txt.Font = Enum.Font.Code; Txt.TextSize = 22; Txt.ZIndex = 10002
    local Bar = Instance.new("Frame", Main)
    Bar.Size = UDim2.new(0.8, 0, 0, 10); Bar.Position = UDim2.new(0.1, 0, 0.7, 0); Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Bar.ZIndex = 10002
    Instance.new("UICorner", Bar)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new(0, 0, 1, 0); Fill.ZIndex = 10003; Instance.new("UICorner", Fill)
    task.spawn(function()
        local start = tick()
        while tick() - start < duration do
            local progress = math.min((tick() - start) / duration, 1)
            local rainbow = Color3.fromHSV(tick() % 5 / 5, 0.9, 1); Fill.Size = UDim2.new(progress, 0, 1, 0); Fill.BackgroundColor3 = rainbow; Glow.Color = rainbow; Txt.TextColor3 = rainbow
            RunService.Heartbeat:Wait()
        end
        LoadBg:Destroy(); if isMain then MainContainer.Visible = true end; if callback then callback() end
    end)
end

-- [[ ⚡ HYPER FLING ENGINE ]]
local StartBtn; 
task.spawn(function()
    while true do
        local all = Players:GetPlayers()
        if StartBtn then StartBtn.Text = _G.FlingAll and "⚡ Flinging..." or "🚀 START FLING" end
        if _G.FlingAll then
            for _, p in pairs(all) do
                if not _G.FlingAll then break end
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not KnockedList[p.Name] then
                    local tRoot = p.Character.HumanoidRootPart
                    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot and tRoot then
                        local startTime = tick()
                        repeat
                            myRoot.CFrame = tRoot.CFrame * CFrame.Angles(math.rad(math.random(-180,180)), math.rad(math.random(-180,180)), math.rad(math.random(-180,180)))
                            myRoot.Velocity = Vector3.new(999999, 999999, 999999); myRoot.RotVelocity = Vector3.new(999999, 999999, 999999)
                            if tRoot.Velocity.Magnitude > 100 or not p.Parent then 
                                if not KnockedList[p.Name] then KnockedList[p.Name] = true; _G.TotalKills = _G.TotalKills + 1 end
                                break 
                            end
                            RunService.Heartbeat:Wait()
                        until tick() - startTime > 0.6 or not _G.FlingAll
                    end
                end
            end
            if _G.TotalKills >= (#Players:GetPlayers()-1) and #Players:GetPlayers() > 1 then
                _G.FlingAll = false; _G.TotalKills = 0; KnockedList = {}
                local s = Instance.new("Sound", SoundService); s.SoundId = "rbxassetid://170765130"; s.Volume = 3; s:Play()
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- [[ 👤 SPECTATE UI ]]
local SpecFrame = Instance.new("Frame", MainContainer); SpecFrame.Size = UDim2.new(0, 160, 0, 250); SpecFrame.Position = UDim2.new(1, -340, 0.5, -125); SpecFrame.BackgroundColor3 = Color3.fromRGB(15,15,15); SpecFrame.Visible = false
Instance.new("UICorner", SpecFrame); Instance.new("UIStroke", SpecFrame).Color = Color3.new(1,1,1)
local SpecScroll = Instance.new("ScrollingFrame", SpecFrame); SpecScroll.Size = UDim2.new(1, -10, 1, -70); SpecScroll.Position = UDim2.new(0, 5, 0, 35); SpecScroll.BackgroundTransparency = 1
Instance.new("UIListLayout", SpecScroll).Padding = UDim.new(0, 5)
local SpecTitle = Instance.new("TextLabel", SpecFrame); SpecTitle.Size = UDim2.new(1, 0, 0, 30); SpecTitle.Text = "👤 ส่องผู้เล่น"; SpecTitle.TextColor3 = Color3.new(1,1,1); SpecTitle.Font = Enum.Font.Code; SpecTitle.TextSize = 14; SpecTitle.BackgroundTransparency = 1

local function UpdateSpecList()
    for _, v in pairs(SpecScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", SpecScroll); b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1); b.TextSize = 12
        Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() if p.Character and p.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = p.Character.Humanoid end end)
    end
end
local BackBtn = Instance.new("TextButton", SpecFrame); BackBtn.Size = UDim2.new(1, -10, 0, 30); BackBtn.Position = UDim2.new(0, 5, 1, -35); BackBtn.Text = "🏠 Me"; BackBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); BackBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", BackBtn); BackBtn.MouseButton1Click:Connect(function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = Player.Character.Humanoid end end)

-- [[ 🔘 MINI UI BUTTONS (Right Side) ]]
local function CreateBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", MainContainer); b.Size = UDim2.new(0, 150, 0, 35); b.Position = pos; b.Text = txt; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 14; Instance.new("UICorner", b); b.Active = true; b.Draggable = true; b.MouseButton1Click:Connect(callback)
    return b
end

StartBtn = CreateBtn("🚀 START FLING", UDim2.new(1, -170, 0.5, -80), Color3.fromRGB(0, 170, 0), function() _G.TotalKills = 0; KnockedList = {}; _G.FlingAll = true end)
CreateBtn("🛑 STOP / RESET", UDim2.new(1, -170, 0.5, -40), Color3.fromRGB(200, 0, 0), function() _G.FlingAll = false; if Player.Character then Player.Character:BreakJoints() end end)
local DefBtn; DefBtn = CreateBtn("🛡️ ติดตั้งป้องกัน", UDim2.new(1, -170, 0.5, 0), Color3.fromRGB(100, 0, 200), function()
    if _G.AntiFlingInstalled then return end
    ShowLoading("Installing Smooth Defense...", 5, false, function() 
        _G.AntiFlingInstalled = true; DefBtn.Text = "✅ SMOOTH DEFENSE"; DefBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) 
    end)
end)

CreateBtn("👤 ระบบส่อง", UDim2.new(1, -170, 0.5, 40), Color3.fromRGB(60, 60, 60), function() 
    SpecFrame.Visible = not SpecFrame.Visible; if SpecFrame.Visible then UpdateSpecList() end 
end)

-- [[ 🔄 PHYSICS & VOID RESCUE LOOP ]]
RunService.Stepped:Connect(function()
    if Player.Character and _G.FlingAll then
        Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
        for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        -- ระบบกันตกแมพ (Smooth Void Rescue)
        local voidLevel = workspace.FallenPartsDestroyHeight + 10
        if root.Position.Y < voidLevel then
            root.Velocity = Vector3.new(0, 50, 0) -- ส่งแรงส่งขึ้นเล็กน้อย
            root.CFrame = CFrame.new(root.Position.X, 250, root.Position.Z)
        end
        
        -- ระบบป้องกันการดีด (Smooth Defense)
        if _G.AntiFlingInstalled and not _G.FlingAll then
            -- ล็อคเฉพาะแรงเหวี่ยงที่สูงผิดปกติ (เกิน 75) เพื่อให้การตกปกติไม่สโลว์
            if root.Velocity.Magnitude > 75 or root.RotVelocity.Magnitude > 75 then
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

ShowLoading("ROMIC HUB V.2.1.19 - SMOOTH", 3, true)

