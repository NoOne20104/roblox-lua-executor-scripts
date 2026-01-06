print("ESP script loaded")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ESPEnabled = false
local ESPObjects = {}

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Name = "ESP_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,180,0,45)
btn.Position = UDim2.new(0,20,0.30,0) -- MUCH higher now
btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
btn.TextColor3 = Color3.fromRGB(0,255,150)
btn.Text = "ESP : OFF"
btn.Font = Enum.Font.Code
btn.TextSize = 18
btn.BorderSizePixel = 0
btn.ZIndex = 10
btn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = btn

-- ================= ESP CORE =================

local function clearESP(player)
	if ESPObjects[player] then
		for _,v in pairs(ESPObjects[player]) do
			if v then pcall(function() v:Destroy() end) end
		end
	end
	ESPObjects[player] = nil
end

local function createESP(player)
	if player == LocalPlayer then return end
	if ESPObjects[player] then return end

	ESPObjects[player] = {}

	local hl = Instance.new("Highlight")
	hl.FillTransparency = 0.5
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = gui

	local bill = Instance.new("BillboardGui")
	bill.Size = UDim2.new(0,220,0,70)
	bill.StudsOffset = Vector3.new(0,3,0)
	bill.AlwaysOnTop = true
	bill.Parent = gui

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.TextStrokeTransparency = 0
	text.TextWrapped = true
	text.Font = Enum.Font.Code
	text.TextSize = 14
	text.TextColor3 = Color3.fromRGB(255,255,255)
	text.Parent = bill

	ESPObjects[player].Highlight = hl
	ESPObjects[player].Billboard = bill
	ESPObjects[player].Label = text
end

local function updateESP()
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and ESPEnabled then
			if not ESPObjects[plr] then
				createESP(plr)
			end

			local char = plr.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")

			if char and hum and hrp then
				local data = ESPObjects[plr]
				data.Highlight.Adornee = char
				data.Billboard.Adornee = hrp

				local myChar = LocalPlayer.Character
				local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
				local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0

				local teamName = plr.Team and plr.Team.Name or "No Team"
				local sameTeam = (plr.Team ~= nil and plr.Team == LocalPlayer.Team)

				local color = sameTeam and Color3.fromRGB(0,170,255) or Color3.fromRGB(255,70,70)

				data.Highlight.FillColor = color
				data.Highlight.OutlineColor = color

				data.Label.TextColor3 = color
				data.Label.Text =
					plr.Name .. " (" .. plr.DisplayName .. ")\n" ..
					"HP: " .. math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth) .. "\n" ..
					"Dist: " .. dist .. "\n" ..
					"Team: " .. teamName
			end
		else
			clearESP(plr)
		end
	end
end

-- ================= TOGGLE =================

btn.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	btn.Text = ESPEnabled and "ESP : ON" or "ESP : OFF"

	if not ESPEnabled then
		for plr,_ in pairs(ESPObjects) do
			clearESP(plr)
		end
	end
end)

Players.PlayerRemoving:Connect(clearESP)

RunService.RenderStepped:Connect(function()
	if ESPEnabled then
		updateESP()
	end
end)
