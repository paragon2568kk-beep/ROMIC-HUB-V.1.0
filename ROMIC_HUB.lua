-- [[ ROMIC FLING BEAST V.1.7 - THE ULTIMATE GOD MODE ]]
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

_G.TotalKills = 0
_G.FlingAll = false
local KnockedList = {} 

-- [[ 1. LOADING SCREEN (15 SEC) ]]
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); LoadFrame.ZIndex = 1000
local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 0, 50); LoadText.Position = UDim2.new(0, 0, 0.45, 0); LoadText.BackgroundTransparency = 1; LoadText.TextColor3 = Color3.fromRGB(255, 255, 255); LoadText.Font = Enum.Font.Code; LoadText.TextSize = 25; LoadText.ZIndex = 1001
local BarBack = Instance.new("Frame", LoadFrame); BarBack.Size = UDim2.new(0, 400, 0, 6); BarBack.Position = UDim2.new(0.5, -200, 0.55, 0); BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30); BarBack.ZIndex = 1001
local BarFill = Instance.new("Frame", BarBack); BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.ZIndex = 1002

task.spawn(function()
    local duration = 15
    for i = 1, 100 do
        BarFill.Size = UDim2.new(i/100, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1)
        LoadText.Text = "กำลังรวบรวมพลังทำลายล้างสูงสุด... " .. i .. "%"
        task.wait(duration/100)
    end
    local s = Instance.new("Sound", SoundService); s.SoundId = "rbxassetid://170765130"; s.Volume = 2; s:Play()
    LoadFrame:Destroy()
end)

-- [[ 2. MISSION COMPLETE UI (ประกาศกลางจอสีรุ้ง) ]]
local function ShowCompleteUI()
    local WinText = Instance.new("TextLabel", ScreenGui)
    WinText.Size = UDim2.new(1, 0, 0, 100); WinText.Position = UDim2.new(0, 0, 0.4, 0)
    WinText.BackgroundTransparency = 1; WinText.Text = "MISSION COMPLETE!"
    WinText.Font = Enum.Font.SourceSansBold; WinText.TextSize = 100; WinText.ZIndex = 2000
    
    local s = Instance.new("Sound", SoundService); s.SoundId = "rbxassetid://170765130"; s.Volume = 3; s:Play()
    local start = tick()
    while tick() - start < 4 do
        WinText.TextColor3 = Color3.fromHSV(tick() % 1, 1, 1) -- สีรุ้ง
        WinText.Rotation = math.sin(tick() * 12) * 5 -- ส่ายหน้าจอ
        task.wait()
    end
    WinText:Destroy()
end

-- [[ 3. GOD MODE ENGINE (Hyper Push + Quick Count) ]]
task.spawn(function()
    while true do
        if _G.FlingAll then
            local currentTotal = #Players:GetPlayers() - 1
            
            -- จบภารกิจเมื่อครบจำนวน
            if _G.TotalKills >= currentTotal and currentTotal > 0 then
                _G.FlingAll = false
                ShowCompleteUI()
                if Player.Character then Player.Character:BreakJoints() end
                _G.TotalKills = 0; KnockedList = {}
            end

            for _, p in pairs(Players:GetPlayers()) do
                if not _G.FlingAll then break end
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not KnockedList[p.Name] then
                    local tRoot = p.Character.HumanoidRootPart
                    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    
                    if myRoot and tRoot then
                        local t = tick()
                        repeat
                            -- วาร์ปแบบสุ่มตำแหน่งรอบตัว (แก้บัคดีดไม่ไป)
                            myRoot.CFrame = tRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                            myRoot.Velocity = Vector3.new(0, 35000, 0) 
                            myRoot.RotVelocity = Vector3.new(5000000, 5000000, 5000000)
                            
                            -- เช็คการปลิว (เกณฑ์ต่ำเพื่อนับไว)
                            if tRoot.Velocity.Magnitude > 50 then 
                                _G.TotalKills = _G.TotalKills + 1
                                KnockedList[p.Name] = true
                                StarterGui:SetCore("SendNotification", {
                                    Title = "🎯 TARGET [".._G.TotalKills.."/"..currentTotal.."]",
                                    Text = p.DisplayName.." กระเด็น!",
                                    Duration = 0.5
                                })
                                break 
                            end
                            RunService.Heartbeat:Wait()
                        until tick() - t > 0.5 or not _G.FlingAll -- จำกัดเวลาต่อคนแค่ 0.5 วิ
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- [[ 4. MAIN UI CONTROL ]]
local function CreateBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", ScreenGui)
    b.Size = UDim2.new(0, 160, 0, 45); b.Position = pos; b.Text = txt
    b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.Draggable = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
end

CreateBtn("🚀 START GOD MODE", UDim2.new(0, 10, 0.5, -50), Color3.fromRGB(0, 170, 0), function() 
    _G.TotalKills = 0; KnockedList = {}; _G.FlingAll = true 
end)

CreateBtn("🛑 STOP / RESET", UDim2.new(0, 10, 0.5, 0), Color3.fromRGB(200, 0, 0), function() 
    _G.FlingAll = false; if Player.Character then Player.Character:BreakJoints() end 
end)

-- Physics Bypass (Anti-Collision)
RunService.Stepped:Connect(function()
    if Player.Character and _G.FlingAll then
        Player.Character.Humanoid.PlatformStand = true
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

