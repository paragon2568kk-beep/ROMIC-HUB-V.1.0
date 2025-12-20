-- [[ ROMIC FLING BEAST V.2.1.1 - FIXED COUNTER + NO BUG ]]
if _G.RomicLoaded then 
    local old = game:GetService("CoreGui"):FindFirstChild("RomicHub")
    if old then old:Destroy() end
end
_G.RomicLoaded = true

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RomicHub"
ScreenGui.DisplayOrder = 9999

_G.TotalKills = 0
_G.FlingAll = false
local KnockedList = {} 

-- [[ 🛡️ ระบบป้องกัน (ANTI-FLING & ANTI-REPORT) ]]
task.spawn(function()
    Player.Chatted:Connect(function(msg)
        local blacklist = {"report", "hacker", "cheat", "exploit", "admin", "เตะ", "โปร"}
        for _, word in pairs(blacklist) do
            if string.find(string.lower(msg), word) then
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "[WARNING]: ตรวจพบคำที่เสี่ยงต่อการโดนแบนในแชท!",
                    Color = Color3.fromRGB(255, 85, 0),
                    Font = Enum.Font.SourceSansBold
                })
                break
            end
        end
    end)

    while true do
        RunService.Heartbeat:Wait()
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and not _G.FlingAll then
            if root.Velocity.Magnitude > 50 or root.RotVelocity.Magnitude > 50 then
                root.Velocity = Vector3.new(0,0,0)
                root.RotVelocity = Vector3.new(0,0,0)
            end
        end
    end
end)

-- [[ 1. LOADING SCREEN ]]
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); LoadFrame.ZIndex = 1000
local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 0, 50); LoadText.Position = UDim2.new(0, 0, 0.45, 0); LoadText.BackgroundTransparency = 1; LoadText.TextColor3 = Color3.fromRGB(255, 255, 255); LoadText.Font = Enum.Font.Code; LoadText.TextSize = 25; LoadText.ZIndex = 1001
local BarBack = Instance.new("Frame", LoadFrame); BarBack.Size = UDim2.new(0, 400, 0, 6); BarBack.Position = UDim2.new(0.5, -200, 0.55, 0); BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30); BarBack.ZIndex = 1001
local BarFill = Instance.new("Frame", BarBack); BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.ZIndex = 1002

task.spawn(function()
    local duration = 5 -- ลดเวลาโหลดให้กระชับ
    for i = 1, 100 do
        BarFill.Size = UDim2.new(i/100, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1)
        LoadText.Text = "กำลังติดตั้งระบบป้องกันและกันรายงาน... " .. i .. "%"
        task.wait(duration/100)
    end
    LoadFrame:Destroy()
end)

-- [[ 2. MISSION COMPLETE UI ]]
local function ShowCompleteUI()
    local WinText = Instance.new("TextLabel", ScreenGui)
    WinText.Size = UDim2.new(1, 0, 0, 100); WinText.Position = UDim2.new(0, 0, 0.4, 0)
    WinText.BackgroundTransparency = 1; WinText.Text = "สำเร็จ"
    WinText.Font = Enum.Font.SourceSansBold; WinText.TextSize = 100; WinText.ZIndex = 2000
    local s = Instance.new("Sound", SoundService); s.SoundId = "rbxassetid://170765130"; s.Volume = 3; s:Play()
    local start = tick()
    while tick() - start < 3 do
        WinText.TextColor3 = Color3.fromHSV(tick() % 1, 1, 1)
        WinText.Position = UDim2.new(0, math.random(-10,10), 0.4, math.random(-10,10))
        task.wait()
    end
    WinText:Destroy()
end

-- [[ 3. HYPER FLING ENGINE & DYNAMIC COUNTER (FIXED) ]]
local StartBtn; 

task.spawn(function()
    while true do
        local totalPlayers = #Players:GetPlayers() - 1
        if StartBtn then
            if _G.FlingAll then
                StartBtn.Text = "⚡ ATTACKING (".._G.TotalKills.."/"..totalPlayers..")"
            else
                StartBtn.Text = "🚀 START FLING (0/"..totalPlayers..")"
            end
        end

        if _G.FlingAll then
            if _G.TotalKills >= totalPlayers and totalPlayers > 0 then
                _G.FlingAll = false
                ShowCompleteUI()
                if Player.Character then Player.Character:BreakJoints() end
                _G.TotalKills = 0; KnockedList = {}
            end

            for _, p in pairs(Players:GetPlayers()) do
                if not _G.FlingAll then break end
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not KnockedList[p.Name] then
                    local tRoot = p.Character.HumanoidRootPart
                    local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    
                    if myRoot and tRoot and (tHum and tHum.Health > 0) then
                        local startTime = tick()
                        repeat
                            -- ล็อคเป้าหมายและอัดแรงเหวี่ยง
                            myRoot.CFrame = tRoot.CFrame * CFrame.Angles(math.rad(math.random(0,360)),math.rad(math.random(0,360)),math.rad(math.random(0,360)))
                            myRoot.Velocity = Vector3.new(1000000, 1000000, 1000000)
                            myRoot.RotVelocity = Vector3.new(1000000, 1000000, 1000000)

                            -- ตรวจสอบว่าปลิวจริงหรือไม่ (ใช้ค่า 50 เพื่อความชัวร์)
                            if tRoot.Velocity.Magnitude > 50 or tHum.Health <= 0 then 
                                if not KnockedList[p.Name] then
                                    KnockedList[p.Name] = true
                                    _G.TotalKills = _G.TotalKills + 1
                                    StarterGui:SetCore("SendNotification", {
                                        Title = "🎯 TARGET NEUTRALIZED",
                                        Text = p.DisplayName.." ปลิวไปแล้ว!",
                                        Duration = 1
                                    })
                                end
                                break 
                            end
                            RunService.Heartbeat:Wait()
                        until tick() - startTime > 0.3 or not _G.FlingAll
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- [[ 4. UI BUTTONS ]]
local function CreateBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", ScreenGui)
    b.Size = UDim2.new(0, 240, 0, 50); b.Position = pos; b.Text = txt
    b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.TextSize = 18
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); b.Active = true; b.Draggable = true
    b.MouseButton1Click:Connect(callback)
    return b
end

StartBtn = CreateBtn("🚀 START FLING", UDim2.new(0, 15, 0.5, -60), Color3.fromRGB(0, 170, 0), function() 
    _G.TotalKills = 0; KnockedList = {}; _G.FlingAll = true 
end)

CreateBtn("🛑 STOP / RESET", UDim2.new(0, 15, 0.5, 0), Color3.fromRGB(200, 0, 0), function() 
    _G.FlingAll = false; if Player.Character then Player.Character:BreakJoints() end 
    _G.TotalKills = 0; KnockedList = {}
end)

-- Physics Sync
RunService.Stepped:Connect(function()
    if Player.Character and _G.FlingAll then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

