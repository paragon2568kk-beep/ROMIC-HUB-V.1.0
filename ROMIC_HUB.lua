-- [[ ANTI-KICK BYPASS ]]
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if tostring(self) == "LocalPlayer" and (getnamecallmethod() == "Kick" or getnamecallmethod() == "kick") then
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [[ 1. ส่วนป้องกัน UI ซ้อนกัน ]]
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
local FastClickBtn = Instance.new("TextButton")
local XrayBtn = Instance.new("TextButton")
local espEnabled = false -- ตัวแปรเก็บสถานะ เปิด/ปิด
local lp = game.Players.LocalPlayer -- ตัวแปรแทนตัวเรา
local RunService = game:GetService("RunService") -- ใช้สำหรับอัปเดตตำแหน่งเรืองแสง
local TpBackBtn = Instance.new("TextButton") -- เพิ่มบรรทัดนี้
local isLagActive_V12 = false 
local LagBtn_V12 = Instance.new("TextButton") -- ตัวแปรปุ่มลอยหน้าจอ

local savedPos = nil
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Brainrot_GodMode_V12_6"

LagBtn_V12.Parent = ScreenGui -- เปลี่ยน ScreenGui เป็นชื่อตัวแปร GUI ของคุณ
LagBtn_V12.Name = "LagBtn_V12"
LagBtn_V12.Text = "LAG: OFF"
LagBtn_V12.Size = UDim2.new(0, 110, 0, 50)
-- ตำแหน่ง: ฝั่งขวา (1, -120), ความสูง (0, 200)
LagBtn_V12.Position = UDim2.new(1, -120, 0, 200) 
LagBtn_V12.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LagBtn_V12.TextColor3 = Color3.new(1, 1, 1)
LagBtn_V12.Draggable = true
LagBtn_V12.Active = true
LagBtn_V12.Visible = false -- ปิดไว้ก่อนตอนเริ่ม
Instance.new("UICorner", LagBtn_V12)

-- ระบบทำงาน Lag Switch
LagBtn_V12.MouseButton1Click:Connect(function()
    isLagActive_V12 = not isLagActive_V12
    LagBtn_V12.Text = isLagActive_V12 and "LAG: ON" or "LAG: OFF"
    LagBtn_V12.BackgroundColor3 = isLagActive_V12 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(45, 45, 45)
    
    pcall(function()
        settings().Network.IncomingReplicationLag = isLagActive_V12 and 1000 or 0
    end)
end)

-- [[ FPS COUNTER ]]
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

-- [[ SETUP FLOATING BUTTONS (ปุ่มที่ลอยข้างนอก) ]]
FlyHomeBtn.Parent = ScreenGui
FlyHomeBtn.Text = "FLY HOME"
FlyHomeBtn.Size = UDim2.new(0, 110, 0, 50)
FlyHomeBtn.Position = UDim2.new(0, 10, 0, 150)
FlyHomeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
FlyHomeBtn.TextColor3 = Color3.new(1, 1, 1)
FlyHomeBtn.Draggable = true
FlyHomeBtn.Active = true
Instance.new("UICorner", FlyHomeBtn)

SlowFlyBtn.Parent = ScreenGui
SlowFlyBtn.Text = "Hover: OFF"
SlowFlyBtn.Size = UDim2.new(0, 110, 0, 50)
SlowFlyBtn.Position = UDim2.new(0, 10, 0, 210)
SlowFlyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
SlowFlyBtn.TextColor3 = Color3.new(1, 1, 1)
SlowFlyBtn.Draggable = true
SlowFlyBtn.Active = true
Instance.new("UICorner", SlowFlyBtn)

-- [[ MAIN MENU SETUP ]]
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
Instance.new("UICorner", ToggleBtn)

ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, 0, 1, -10)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ScrollingFrame.ScrollBarThickness = 5
UIListLayout.Parent = ScrollingFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)

local function CreateShowToggle(text, targetUI)
    local btn = Instance.new("TextButton")
    CreateBtn(btn, "แสดง" .. text .. " (OFF)", Color3.fromRGB(150, 50, 50)) 
    
    btn.MouseButton1Click:Connect(function()
        if targetUI then
            targetUI.Visible = not targetUI.Visible
            btn.Text = targetUI.Visible and "แสดง" .. text .. " (ON)" or "แสดง" .. text .. " (OFF)"
            btn.BackgroundColor3 = targetUI.Visible and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        end
    end)
end

-- สร้างปุ่มในเมนู
CreateBtn(FastClickBtn, "คลิกเดียวเก็บของ (OFF)", Color3.fromRGB(100, 0, 200))
CreateBtn(SetPointBtn, "บันทึกจุด (Set Point)", Color3.fromRGB(0, 150, 0))
CreateBtn(NoclipBtn, "ทะลุกำแพง (OFF)", Color3.fromRGB(80, 80, 80))
CreateBtn(InfJumpBtn, "กระโดดบนอากาศ (OFF)", Color3.fromRGB(80, 80, 80))
CreateBtn(XrayBtn, "X-Ray: OFF", Color3.fromRGB(150, 0, 200))
CreateBox(HeightBox, "ระดับความสูง", "80")
CreateBox(SpeedBox, "ล็อควิ่งเร็ว", "60")
CreateBox(FlySpeedBox, "ความเร็วบินกลับ", "250")
CreateShowToggle("ปุ่ม FLY", FlyHomeBtn)
CreateShowToggle("ปุ่ม HOVER", SlowFlyBtn)
CreateShowToggle("ปุ่ม X-RAY", XrayBtn)
CreateShowToggle("ปุ่ม TP BACK", TpBackBtn)
CreateShowToggle("ปุ่ม LAG", LagBtn_V12)

-- [[ ฟังก์ชัน FLY HOME ]]
FlyHomeBtn.MouseButton1Click:Connect(function()
    if not savedPos then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "ยังไม่ได้บันทึกจุด!", Duration = 2})
        return 
    end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local h = tonumber(HeightBox.Text) or 80
    local fSpeed = tonumber(FlySpeedBox.Text) or 250

    FlyHomeBtn.Text = "EVADE!"
    root.Velocity = Vector3.new(0, 300, 0)
    task.wait(0.05)
    root.CFrame = CFrame.new(root.Position.X, h, root.Position.Z)

    local targetAirPos = Vector3.new(savedPos.Position.X, h, savedPos.Position.Z)
    local dist = (root.Position - targetAirPos).Magnitude
    local moveTween = TweenService:Create(root, TweenInfo.new(dist/fSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetAirPos)})
    moveTween:Play()
    moveTween.Completed:Wait()

    root.CFrame = savedPos
    FlyHomeBtn.Text = "FLY HOME"
end)

-- [[ ตั้งค่าปุ่ม X-Ray ลอยตัว ]]
XrayBtn.Parent = ScreenGui -- ใช้ชื่อ ScreenGui ตามในสคริปต์หลักของคุณ
XrayBtn.Text = "X-Ray: OFF"
XrayBtn.Size = UDim2.new(0, 110, 0, 50) -- ขนาดเท่ากับปุ่ม Fly Home
XrayBtn.Position = UDim2.new(0, 10, 0, 270) -- อยู่ใต้ปุ่ม Hover (ระยะห่าง 270)
XrayBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200) -- สีม่วง
XrayBtn.TextColor3 = Color3.new(1, 1, 1)
XrayBtn.Draggable = true -- สำคัญ: ทำให้ลากปุ่มไปมาได้บนมือถือ
XrayBtn.Active = true
Instance.new("UICorner", XrayBtn)

-- [[ SETUP TP BACK BUTTON ]]
TpBackBtn.Parent = ScreenGui
TpBackBtn.Text = "TP BACK"
TpBackBtn.Size = UDim2.new(0, 110, 0, 50)
TpBackBtn.Position = UDim2.new(0, 10, 0, 330) -- อยู่ใต้ X-Ray
TpBackBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
TpBackBtn.TextColor3 = Color3.new(1, 1, 1)
TpBackBtn.Draggable = true
TpBackBtn.Active = true
Instance.new("UICorner", TpBackBtn)

TpBackBtn.MouseButton1Click:Connect(function()
    if savedPos and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = savedPos
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "ยังไม่มีจุดวาร์ปกลับ!", Duration = 2})
    end
end)

-- [[ ฟังก์ชัน HOVER ]]
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
            while isHovering and root and root.Parent do
                local h = tonumber(HeightBox.Text) or 80
                local s = tonumber(FlySpeedBox.Text) or 100
                local yVel = (root.Position.Y < h) and 150 or (root.Position.Y > h+5 and -100 or 0)
                bv.Velocity = (char.Humanoid.MoveDirection * s) + Vector3.new(0, yVel, 0)
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

-- [[ ฟังก์ชันอื่นๆ ]]
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

SetPointBtn.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = lp.Character.HumanoidRootPart.CFrame
        SetPointBtn.Text = "SAVED!"
        task.wait(0.5)
        SetPointBtn.Text = "บันทึกจุด (Set Point)"
    end
end)

local fastClickActive = false
FastClickBtn.MouseButton1Click:Connect(function()
    fastClickActive = not fastClickActive
    FastClickBtn.Text = fastClickActive and "คลิกเดียวเก็บของ (ON)" or "คลิกเดียวเก็บของ (OFF)"
    FastClickBtn.BackgroundColor3 = fastClickActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(100, 0, 200)
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if fastClickActive then fireproximityprompt(prompt) end
end)

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

InfJumpBtn.MouseButton1Click:Connect(function()
    local active = InfJumpBtn.Text:find("OFF")
    InfJumpBtn.Text = active and "InfJump: ON" or "InfJump: OFF"
    InfJumpBtn.BackgroundColor3 = active and Color3.fromRGB(0, 180, 180) or Color3.fromRGB(80, 80, 80)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpBtn.Text:find("ON") and lp.Character then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local xrayActive = false
XrayBtn.MouseButton1Click:Connect(function()
    xrayActive = not xrayActive
    XrayBtn.Text = xrayActive and "X-Ray: ON" or "X-Ray: OFF"
    XrayBtn.BackgroundColor3 = xrayActive and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(150, 0, 200)
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(lp.Character) then
            if xrayActive then
                if not obj:FindFirstChild("OriginalTrans") then
                    local v = Instance.new("NumberValue", obj)
                    v.Name = "OriginalTrans"
                    v.Value = obj.Transparency
                end
                obj.Transparency = 0.5 -- ระดับความใส
            else
                local v = obj:FindFirstChild("OriginalTrans")
                obj.Transparency = v and v.Value or 0
            end
        end
    end
end)

-- [[ บรรทัดที่ 264: ระบบล็อคความเร็ววิ่ง (WalkSpeed) ]]
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                -- ดึงค่าจากช่อง SpeedBox ที่คุณสร้างไว้ในบรรทัดที่ 142
                local s = tonumber(SpeedBox.Text) or 16 
                lp.Character.Humanoid.WalkSpeed = s
            end
        end)
    end
end)

-- [[ 1. ตัวแปรเก็บสถานะ (วางไว้ก่อนฟังก์ชัน) ]]
local espEnabled = false -- ตัวแปรเช็คว่าเปิดหรือปิด

-- [[ 2. ฟังก์ชันหลักสำหรับทำให้เรืองแสง ]]
local function ApplyHighlight(char)
    -- ตรวจสอบว่ามี Highlight อยู่แล้วหรือยัง เพื่อไม่ให้สร้างซ้ำจนแลค
    if not char:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Parent = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- สีแดงเรืองแสง
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- เส้นขอบขาว
        highlight.FillTransparency = 0.5 -- ความเข้มของสี
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ทำให้มองทะลุกำแพงได้
    end
end

XrayBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    XrayBtn.Text = espEnabled and "X-Ray & Safety: ON" or "X-Ray & Safety: OFF"
    
    -- ลูปจัดการทั้งเรื่อง แสง (Highlight) และ การสัมผัส (Touch)
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        -- 1. ส่วนของมองทะลุผู้เล่น
        if obj:IsA("Model") and game.Players:GetPlayerFromCharacter(obj) then
            local p = game.Players:GetPlayerFromCharacter(obj)
            if p ~= lp then
                if espEnabled then
                    local h = obj:FindFirstChild("ESPHighlight") or Instance.new("Highlight", obj)
                    h.Name = "ESPHighlight"
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    if obj:FindFirstChild("ESPHighlight") then obj.ESPHighlight:Destroy() end
                end
            end
        end

        -- 2. ส่วนของ Disable Touch (ปิดการแตะของที่ทำให้ตาย)
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("lava") or name:find("kill") or name:find("dead") or name:find("trap") then
                obj.CanTouch = not espEnabled -- ถ้าเปิดระบบ CanTouch จะเป็น false (แตะไม่โดน)
            end
        end
    end
end)

-- ทำให้ปุ่มทำงานเมื่อคลิก
TpBackBtn.MouseButton1Click:Connect(function()
    if savedPos and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        -- วาร์ปกลับไปยังจุดที่เคยบันทึกไว้ในตัวแปร savedPos
        lp.Character.HumanoidRootPart.CFrame = savedPos
    else
        -- ถ้ายังไม่ได้บันทึกจุด ให้แจ้งเตือน
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "System",
            Text = "ยังไม่ได้บันทึกตำแหน่ง!",
            Duration = 2
        })
    end
end)

-- [[ ฟังก์ชัน Lag Switch ]]
local settings = settings or {}
local network = game:GetService("NetworkClient")

LagBtn.MouseButton1Click:Connect(function()
    lagActive = not lagActive
    LagBtn.Text = lagActive and "LAG: ON" or "LAG: OFF"
    LagBtn.BackgroundColor3 = lagActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
    
    -- ใช้การเซต Parent ของ Network เพื่อทำให้เน็ตค้าง (Client-side lag)
    if lagActive then
        settings.IncomingReplicationLag = 99e9 -- ทำให้เน็ตค้าง
    else
        settings.IncomingReplicationLag = 0 -- กลับมาเป็นปกติ
    end
end)
