-- [[ ROMIC FLING BEAST V.5.5 - MISSION COMPLETE ]]
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

-- ฟังก์ชันดึงจำนวนคนในเซิร์ฟ (ไม่รวมเรา)
local function GetOtherPlayersCount()
    local count = #Players:GetPlayers() - 1
    return count > 0 and count or 1 -- ป้องกันตัวหารเป็น 0
end

-- [[ 1. FULL SCREEN LOADING (15 SEC) ]]
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); LoadFrame.ZIndex = 1000
local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 0, 50); LoadText.Position = UDim2.new(0, 0, 0.45, 0); LoadText.BackgroundTransparency = 1; LoadText.TextColor3 = Color3.fromRGB(255, 255, 255); LoadText.Font = Enum.Font.Code; LoadText.TextSize = 25; LoadText.ZIndex = 1001
local BarBack = Instance.new("Frame", LoadFrame)
BarBack.Size = UDim2.new(0, 400, 0, 6); BarBack.Position = UDim2.new(0.5, -200, 0.55, 0); BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30); BarBack.ZIndex = 1001
local BarFill = Instance.new("Frame", BarBack); BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.ZIndex = 1002

task.spawn(function()
    local duration = 15
    local start = tick()
    while tick() - start < duration do
        local progress = (tick() - start) / duration
        BarFill.Size = UDim2.new(progress, 0, 1, 0)
        BarFill.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
        LoadText.Text = "กำลังคำนวณเป้าหมายทั้งหมด... " .. math.floor(progress * 100) .. "%"
        task.wait()
    end
    local s = Instance.new("Sound", SoundService); s.SoundId = "rbxassetid://170765130"; s.Volume = 2; s:Play()
    StarterGui:SetCore("SendNotification", {Title = "ระบบพร้อมใช้งาน", Text = "เปิดใช้งานเรียบร้อยแล้ว!", Duration = 5})
    LoadFrame:Destroy()
end)

-- [[ 2. CINEMATIC INTRO (20 SEC) ]]
local Intro = Instance.new("TextLabel", ScreenGui)
Intro.Size = UDim2.new(1, 0, 0, 100); Intro.Position = UDim2.new(0, 0, 0.4, 0); Intro.BackgroundTransparency = 1; Intro.Text = "ROMIC HUB V.5.5"; Intro.TextColor3 = Color3.fromRGB(255, 255, 255); Intro.Font = Enum.Font.SourceSansBold; Intro.TextSize = 80; Intro.Visible = false
task.spawn(function()
    repeat task.wait() until not ScreenGui:FindFirstChild("Frame")
    Intro.Visible = true
    local start = tick()
    while tick() - start < 15 do
        Intro.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        task.wait()
    end
    TweenService:Create(Intro, TweenInfo.new(5), {TextTransparency = 1}):Play()
    task.wait(5); Intro:Destroy()
end)

-- [[ 3. MISSION ENGINE ]]
task.spawn(function()
    while true do
        if _G.FlingAll then
            local players = Players:GetPlayers()
            for _, p in pairs(players) do
                if not _G.FlingAll then break end
                
                local currentTotal = GetOtherPlayersCount()
                
                -- ตรวจสอบว่าครบหรือยัง
                if _G.TotalKills >= currentTotal and currentTotal > 0 then
                    _G.FlingAll = false
                    StarterGui:SetCore("SendNotification", {
                        Title = "MISSION COMPLETE!",
                        Text = "กำจัดครบทุกคนแล้ว (" .. _G.TotalKills .. "/" .. currentTotal .. ") กำลังรีเซ็ตตัวละคร...",
                        Duration = 5
                    })
                    task.wait(1)
                    if Player.Character then Player.Character:BreakJoints() end
                    _G.TotalKills = 0 -- รีเซ็ตแต้มหลังจบงาน
                    KnockedList = {}
                    break
                end

                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not KnockedList[p.Name] then
                    local tRoot = p.Character.HumanoidRootPart
                    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if not myRoot then break end
                    
                    local start = tick()
                    local counted = false
                    
                    repeat
                        if not _G.FlingAll or not tRoot or not myRoot then break end
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 0)
                        myRoot.Velocity = Vector3.new(0, 12000, 0)
                        myRoot.RotVelocity = Vector3.new(1000000, 1000000, 1000000)
                        
                        if tRoot.Velocity.Magnitude > 300 and not counted then
                            _G.TotalKills = _G.TotalKills + 1
                            counted = true
                            KnockedList[p.Name] = true
                            
                            StarterGui:SetCore("SendNotification", {
                                Title = "🎯 ความคืบหน้า [" .. _G.TotalKills .. "/" .. currentTotal .. "]",
                                Text = "กำจัดสำเร็จ: " .. p.DisplayName,
                                Duration = 2
                            })
                        end
                        RunService.Heartbeat:Wait()
                    until (tRoot.Velocity.Magnitude > 500) or (tick() - start > 0.8)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- [[ 4. UI BUTTONS ]]
local function CreateBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", ScreenGui)
    b.Size = UDim2.new(0, 160, 0, 45); b.Position = pos; b.Text = txt
    b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.Draggable = true
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

CreateBtn("🚀 เริ่มภารกิจ", UDim2.new(0, 10, 0.5, -50), Color3.fromRGB(0, 170, 0), function() 
    _G.TotalKills = 0
    KnockedList = {}
    _G.FlingAll = true 
end)

CreateBtn("🛑 ยกเลิก/รีเซ็ต", UDim2.new(0, 10, 0.5, 0), Color3.fromRGB(200, 0, 0), function() 
    _G.FlingAll = false 
    if Player.Character then Player.Character:BreakJoints() end
end)

RunService.Stepped:Connect(function()
    if Player.Character and _G.FlingAll then
        Player.Character.Humanoid.PlatformStand = true
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

