local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RP V.1.0 💎", -- เปลี่ยนชื่อตามสั่ง
   LoadingTitle = "กำลังโหลดระบบ RP V.1.0...",
   LoadingSubtitle = "ละเอียดที่สุดโดย Gemini AI",
})

-- [[ ตัวแปรหลัก - ห้ามยุ่ง ]]
local lp = game.Players.LocalPlayer
local selectedPlayer = ""
local isFollowing = false
local isSpectating = false
local rainbowSkinActive = false
local noclipActive = false 
local farTimer = 0 

_G.Glow = false
_G.RainbowESP = false
_G.RealNames = false
_G.Distance = false

-- [[ 🚶 TAB 1: เดินทะลุกำแพง (NoClip Fixed) ]]
local TabNoClip = Window:CreateTab("เดินทะลุ 🚶", 4483362458)

TabNoClip:CreateToggle({
   Name = "เปิดเดินทะลุกำแพง (NoClip)",
   CurrentValue = false,
   Callback = function(v)
       noclipActive = v
       if not v then
           if lp.Character then
               for _, part in pairs(lp.Character:GetDescendants()) do
                   if part:IsA("BasePart") then part.CanCollide = true end
               end
           end
       end
   end,
})

-- [[ 👁️ TAB 2: การมอง (ESP) ]]
local TabESP = Window:CreateTab("การมอง (ESP) 👁️", 4483362458)
TabESP:CreateToggle({ Name = "เรืองแสงสายรุ้ง (Rainbow Glow)", CurrentValue = false, Callback = function(v) _G.RainbowESP = v end })
TabESP:CreateToggle({ Name = "เรืองแสงสีแดง (Red Glow)", CurrentValue = false, Callback = function(v) _G.Glow = v end })
TabESP:CreateToggle({ Name = "แสดงชื่อ ID ผู้เล่น", CurrentValue = false, Callback = function(v) _G.RealNames = v end })
TabESP:CreateToggle({ Name = "แสดงระยะห่าง (เมตร)", CurrentValue = false, Callback = function(v) _G.Distance = v end })

-- [[ 🎯 TAB 3: เป้าหมาย (วาร์ป 4 วิ + กล้อง) ]]
local TabTarget = Window:CreateTab("เป้าหมาย 🎯", 4483362458)

local PlayerDropdown
local function RefreshList()
    local names = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(names, v.Name) end end
    return names
end

PlayerDropdown = TabTarget:CreateDropdown({
   Name = "เลือกชื่อผู้เล่น",
   Options = RefreshList(),
   Callback = function(Option) selectedPlayer = Option[1] end,
})

TabTarget:CreateButton({ Name = "🔄 รีเฟรชรายชื่อ", Callback = function() PlayerDropdown:Refresh(RefreshList()) end })

TabTarget:CreateToggle({
   Name = "ส่องดู (Spectate)",
   CurrentValue = false,
   Callback = function(v) 
       isSpectating = v 
       if not v then game.Workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid end
   end,
})

TabTarget:CreateToggle({
   Name = "เดินตาม (วาร์ปเมื่อห่าง 4 วิ)",
   CurrentValue = false,
   Callback = function(v) isFollowing = v farTimer = 0 end,
})

-- [[ 🌈 TAB 4: ตัวละคร ]]
local TabSelf = Window:CreateTab("ตัวละคร 🌈", 4483362458)
TabSelf:CreateToggle({ Name = "เปิดสีผิวรุ้ง (คนอื่นเห็น)", CurrentValue = false, Callback = function(v) rainbowSkinActive = v end })

-- [[ ⚙️ Core Engine ]]
game:GetService("RunService").Stepped:Connect(function()
    if noclipActive and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        local rainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)

        -- ESP Logic
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hl = p.Character:FindFirstChild("ShadowGlow")
                if _G.RainbowESP or _G.Glow then
                    if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "ShadowGlow" end
                    hl.FillColor = _G.RainbowESP and rainbowColor or Color3.fromRGB(255, 0, 0)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif hl then hl:Destroy() end
                
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local gui = head:FindFirstChild("ShadowInfo") or Instance.new("BillboardGui", head)
                    gui.Name = "ShadowInfo"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(0, 200, 0, 50); gui.Enabled = (_G.RealNames or _G.Distance)
                    local label = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel", gui)
                    label.TextColor3 = _G.RainbowESP and rainbowColor or Color3.new(1, 1, 1)
                    local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    local txt = ""
                    if _G.RealNames then txt = txt .. p.Name .. "\n" end
                    if _G.Distance then txt = txt .. math.floor(dist) .. "m" end
                    label.Text = txt
                end
            end
        end

        -- Follow / TP Logic
        local target = game.Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if isSpectating then game.Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid end
            if isFollowing then
                local dist = (lp.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                if dist > 15 then
                    farTimer = farTimer + 0.1
                    if farTimer >= 4 then
                        lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        farTimer = 0
                    else
                        lp.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
                    end
                else
                    lp.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
                    farTimer = 0
                end
            end
        end

        if rainbowSkinActive and lp.Character then
            for _, p in pairs(lp.Character:GetChildren()) do if p:IsA("BasePart") then p.Color = rainbowColor end end
        end
        task.wait(0.1)
    end
end)
