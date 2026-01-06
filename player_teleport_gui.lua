local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerTPGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 320)
frame.Position = UDim2.new(0, 20, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BorderSizePixel = 0
frame.ZIndex = 2
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Player Teleport"
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = frame

-- Scrolling list
local list = Instance.new("ScrollingFrame")
list.Position = UDim2.new(0, 10, 0, 40)
list.Size = UDim2.new(1, -20, 1, -50)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.None
list.ScrollBarImageTransparency = 0.3
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ZIndex = 2
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = list

-- Teleport logic
local function teleportTo(target)
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local tChar = target.Character
    if not hrp or not tChar then return end

    local tHrp = tChar:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end

    hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, -5)
end

-- Refresh list
local function refresh()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Code
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.BorderSizePixel = 0
            btn.ZIndex = 3
            btn.Parent = list

            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                teleportTo(plr)
            end)
        end
    end

    task.wait()
    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
end

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
