-- [[ 1. ส่วนป้องกัน UI ซ้อนกัน (บรรทัดแรกสุด) ]]
if game.CoreGui:FindFirstChild("Brainrot_GodMode_V12_6") then 
    game.CoreGui["Brainrot_GodMode_V12_6"]:Destroy() 
end

-- [[ 2. ส่วนแจ้งเตือนเวอร์ชัน ]]
local VERSION = "1.00" 
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot GodMode",
    Text = "โหลดเวอร์ชัน " .. VERSION .. " สำเร็จแล้ว!",
    Duration = 5
})

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local FlyHomeBtn = Instance.new("TextButton")
local SetPointBtn = Instance.new("TextButton")
local SlowFlyBtn = Instance.new("TextButton")
local SpeedBox = Instance.new("TextBox")
local FlySpeedBox = Instance.new("TextBox")
local HeightBox = Instance.new("TextBox")
local FPSLabel = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local ScrollingFrame = Instance.new("ScrollingFrame")
local NoclipBtn = Instance.new("TextButton")
local InfJumpBtn = Instance.new("TextButton")
local FastClickBtn = Instance.new("TextButton") -- ปุ่มเปิดระบบคลิกเก็บของ
local AutoClickBtn = Instance.new("TextButton") -- เพิ่มบรรทัดนี้

local savedPos = nil
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Brainrot_GodMode_V12_6"

-- [[ 1. FPS COUNTER ]]
FPSLabel.Parent = ScreenGui
FPSLabel.Size = UDim2.new(0, 100, 0, 30)
FPSLabel.Position = UDim2.new(1, -110, 0, 10)
FPSLabel.BackgroundTransparency = 0.5
FPSLabel.BackgroundColor3 = Color3.new(0,0,0)
FPSLabel.TextColor3 = Color3.new(0,1,0)
FPSLabel.TextSize = 16
RunService.RenderStepped:Connect(function(dt)
    FPSLabel.Text = "FPS: "..math.floor(1/dt)
end)

-- [[ 2. ปุ่ม FLY HOME ]]
FlyHomeBtn.Parent = ScreenGui
FlyHomeBtn.Text = "FLY HOME"
FlyHomeBtn.Size = UDim2.new(0, 110, 0, 50)
FlyHomeBtn.Position = UDim2.new(0, 10, 0, 150)
FlyHomeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
FlyHomeBtn.Draggable = true
FlyHomeBtn.Active = true
Instance.new("UICorner", FlyHomeBtn)

-- ฟังก์ชั่นการทำงาน (ดึงค่าจาก Box ในเมนูหลักมาใช้)
local isHovering = false
SlowFlyBtn.MouseButton1Click:Connect(function()
    isHovering = not isHovering
    SlowFlyBtn.Text = isHovering and "Hover: ON" or "Hover: OFF"
    SlowFlyBtn.BackgroundColor3 = isHovering and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200)
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isHovering and root then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while isHovering and root.Parent do
                -- ดึงค่าความสูงและความเร็วจาก TextBox ใน MainFrame
                local h = tonumber(HeightBox.Text) or 80
                local s = tonumber(FlySpeedBox.Text) or 100
                
                local yVel = (root.Position.Y < h) and 180 or (root.Position.Y > h+5 and -120 or 0)
                bv.Velocity = (char.Humanoid.MoveDirection * s) + Vector3.new(0, yVel, 0)
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)


-- [[ 3. MAIN MENU ]]
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -190)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

ToggleBtn.Parent = ScreenGui
ToggleBtn.Text = "MENU"
ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, 0, 1, -10)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollingFrame.ScrollBarThickness = 5
UIListLayout.Parent = ScrollingFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)

local function CreateBtn(btn, text, color)
    btn.Parent = ScrollingFrame
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
end

local function CreateBox(box, placeholder, default)
    box.Parent = ScrollingFrame
    box.PlaceholderText = placeholder
    box.Text = default or ""
    box.Size = UDim2.new(0.9, 0, 0, 35)
    Instance.new("UICorner", box)
end

-- เพิ่มปุ่มระบบใหม่
CreateBtn(FastClickBtn, "คลิกเดียวเก็บของ (OFF)", Color3.fromRGB(100, 0, 200))
CreateBtn(SetPointBtn, "บันทึกจุด (Set Point)", Color3.fromRGB(0, 150, 0))
CreateBtn(SlowFlyBtn, "ลอยตัว (Hover: OFF)", Color3.fromRGB(0, 120, 200))
CreateBtn(NoclipBtn, "ทะลุกำแพง (OFF)", Color3.fromRGB(80, 80, 80))
CreateBtn(InfJumpBtn, "กระโดดบนอากาศ (OFF)", Color3.fromRGB(80, 80, 80))
CreateBox(HeightBox, "ระดับความสูง", "80")
CreateBox(SpeedBox, "ล็อควิ่งเร็ว", "60")
CreateBox(FlySpeedBox, "ความเร็วบินกลับ", "250")
CreateBtn(AutoClickBtn, "Auto Clicker (OFF)", Color3.fromRGB(200, 100, 0))

-- [[ ฟังก์ชั่นพิเศษ: คลิกเดียวเก็บของ (Instant Proximity) ]]
local fastClickActive = false
FastClickBtn.MouseButton1Click:Connect(function()
    fastClickActive = not fastClickActive
    FastClickBtn.Text = fastClickActive and "คลิกเดียวเก็บของ (ON)" or "คลิกเดียวเก็บของ (OFF)"
    FastClickBtn.BackgroundColor3 = fastClickActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(100, 0, 200)
    
    -- ปรับแต่ง ProximityPrompt ให้ทำงานทันที
    if fastClickActive then
        ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            if fastClickActive then
                fireproximityprompt(prompt) -- จำลองการกดจนเสร็จทันที
            end
        end)
    end
end)

-- [[ ระบบบินกลับแบบพุ่งพรวด (วาร์ปดีด) ]]
FlyHomeBtn.MouseButton1Click:Connect(function()
    if not savedPos then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targetHeight = tonumber(HeightBox.Text) or 80
    local fSpeed = tonumber(FlySpeedBox.Text) or 250

    FlyHomeBtn.Text = "EVADE!"
    root.Velocity = Vector3.new(0, 350, 0) -- ดีดแรงขึ้น
    task.wait(0.05)
    root.CFrame = CFrame.new(root.Position.X, targetHeight, root.Position.Z)

    local targetAirPos = Vector3.new(savedPos.Position.X, targetHeight, savedPos.Position.Z)
    local dist = (root.Position - targetAirPos).Magnitude
    local moveTween = TweenService:Create(root, TweenInfo.new(dist/fSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetAirPos)})
    moveTween:Play()
    moveTween.Completed:Wait()

    root.CFrame = savedPos
    FlyHomeBtn.Text = "FLY HOME"
end)

-- [[ แก้ไขส่วนปุ่ม Hover ให้แยกออกมา ]]
SlowFlyBtn.Parent = ScreenGui -- ย้ายออกจากเมนูหลักมาที่หน้าจอ
SlowFlyBtn.Text = "Hover: OFF"
SlowFlyBtn.Size = UDim2.new(0, 110, 0, 50)
SlowFlyBtn.Position = UDim2.new(0, 10, 0, 210) -- ตำแหน่งใต้ปุ่ม FLY HOME
SlowFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
SlowFlyBtn.TextColor3 = Color3.new(1, 1, 1)
SlowFlyBtn.Draggable = true -- ทำให้ลากปุ่มไปมาได้
SlowFlyBtn.Active = true
Instance.new("UICorner", SlowFlyBtn)

-- ฟังก์ชั่นการทำงาน (ดึงค่าจาก Box ในเมนูหลักมาใช้)
local isHovering = false
SlowFlyBtn.MouseButton1Click:Connect(function()
    isHovering = not isHovering
    SlowFlyBtn.Text = isHovering and "Hover: ON" or "Hover: OFF"
    SlowFlyBtn.BackgroundColor3 = isHovering and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 120, 200)
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if isHovering and root then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while isHovering and root.Parent do
                -- ดึงค่าความสูงและความเร็วจาก TextBox ใน MainFrame
                local h = tonumber(HeightBox.Text) or 80
                local s = tonumber(FlySpeedBox.Text) or 100
                
                local yVel = (root.Position.Y < h) and 180 or (root.Position.Y > h+5 and -120 or 0)
                bv.Velocity = (char.Humanoid.MoveDirection * s) + Vector3.new(0, yVel, 0)
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

-- ล็อคความเร็ววิ่ง
task.spawn(function()
    while true do
        task.wait(0.2)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = tonumber(SpeedBox.Text) or 60
        end
    end
end)

-- บันทึกจุด
SetPointBtn.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = lp.Character.HumanoidRootPart.CFrame
        SetPointBtn.Text = "SAVED!"
        task.wait(0.5)
        SetPointBtn.Text = "บันทึกจุด (Set Point)"
    end
end)

-- ปุ่มปิดเปิด/Noclip/InfJump
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    NoclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(200, 0, 100) or Color3.fromRGB(80, 80, 80)
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpBtn.Text:find("ON") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
InfJumpBtn.MouseButton1Click:Connect(function()
    local active = InfJumpBtn.Text:find("OFF")
    InfJumpBtn.Text = active and "InfJump: ON" or "InfJump: OFF"
    InfJumpBtn.BackgroundColor3 = active and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(80, 80, 80)
end)

-- [[ ระบบ Auto Collect (เก็บของรอบตัวอัตโนมัติ) ]]
local autoCollectActive = false

AutoClickBtn.MouseButton1Click:Connect(function()
    autoCollectActive = not autoCollectActive
    AutoClickBtn.Text = autoCollectActive and "Auto Collect: ON" or "Auto Collect: OFF"
    AutoClickBtn.BackgroundColor3 = autoCollectActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 100, 0)
    
    if autoCollectActive then
        task.spawn(function()
            while autoCollectActive do
                -- วนลูปหา ProximityPrompt ทุกอย่างที่อยู่ในระยะรอบตัว
                for _, prompt in pairs(game:GetService("ProximityPromptService"):GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        -- ตรวจสอบระยะห่าง (ถ้าอยู่ใกล้พอจะสั่งกดทันที)
                        local char = lp.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local dist = (char.HumanoidRootPart.Position - prompt.Parent:GetModelCFrame().p).Magnitude
                            if dist <= (prompt.MaxActivationDistance + 5) then
                                fireproximityprompt(prompt) -- สั่งให้ปุ่มทำงานทันที
                            end
                        end
                    end
                end
                task.wait(0.1) -- ความถี่ในการสแกนหาของรอบตัว
            end
        end)
    end
end)
