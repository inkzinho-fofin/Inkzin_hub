local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local FlowLib = {}

-- [CONFIGURAÇÃO DE TEMAS]
local Themes = {
	Black = {Main = Color3.fromRGB(10, 10, 10), Sec = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(255, 255, 255)},
	DarkPurple = {Main = Color3.fromRGB(15, 5, 30), Sec = Color3.fromRGB(25, 10, 50), Accent = Color3.fromRGB(140, 70, 255)},
}

function FlowLib:Init(themeName)
	local theme = Themes[themeName] or Themes.DarkPurple
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Flow_Unificado"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- [ORBE CYBERPUNK]
	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Size = UDim2.new(0, 50, 0, 50)
	OpenBtn.Position = UDim2.new(0, 20, 0, 100)
	OpenBtn.BackgroundColor3 = theme.Main
	OpenBtn.Text = "F"
	OpenBtn.TextColor3 = theme.Accent
	OpenBtn.Font = Enum.Font.GothamBold
	OpenBtn.TextSize = 22
	OpenBtn.Parent = ScreenGui
	Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
	local Stroke = Instance.new("UIStroke", OpenBtn)
	Stroke.Color = theme.Accent
	Stroke.Thickness = 2

	-- [JANELA PRINCIPAL]
	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 550, 0, 350)
	Main.Position = UDim2.new(0.5, -275, 0.5, -175)
	Main.BackgroundColor3 = theme.Main
	Main.Parent = ScreenGui
	Main.Visible = true
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

	local Header = Instance.new("Frame")
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.BackgroundColor3 = theme.Sec
	Header.Parent = Main
	Instance.new("UICorner", Header)

	local Title = Instance.new("TextLabel")
	Title.Text = "  FLOW_BLOX_FRUITS"
	Title.Size = UDim2.new(0.5, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = theme.Accent
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Size = UDim2.new(0, 130, 1, -50)
	Sidebar.Position = UDim2.new(0, 10, 0, 45)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 0
	Sidebar.Parent = Main
	Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(1, -160, 1, -55)
	ContentHolder.Position = UDim2.new(0, 150, 0, 45)
	ContentHolder.BackgroundColor3 = theme.Sec
	ContentHolder.Parent = Main
	Instance.new("UICorner", ContentHolder)

	-- DRAG SYSTEM
	local function MakeDraggable(obj, dragPart)
		local dragging, dragInput, dragStart, startPos
		dragPart.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = obj.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	MakeDraggable(Main, Header)
	MakeDraggable(OpenBtn, OpenBtn)

	local Tabs = {}
	local firstTab = true

	function FlowLib:AddTab(name)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.BackgroundColor3 = theme.Main
		TabBtn.Text = name
		TabBtn.TextColor3 = theme.Accent
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.Parent = Sidebar
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
		local bStroke = Instance.new("UIStroke", TabBtn)
		bStroke.Color = theme.Accent
		bStroke.Transparency = 0.8

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, -10, 1, -10)
		Page.Position = UDim2.new(0, 5, 0, 5)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.Parent = ContentHolder
		Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

		if firstTab then
			Page.Visible = true
			bStroke.Transparency = 0
			firstTab = false
		end

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(ContentHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
			for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.UIStroke.Transparency = 0.8 end end
			Page.Visible = true
			bStroke.Transparency = 0
		end)

		local Components = {}

		-- [TOGGLE]
		function Components:AddToggle(text, callback)
			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(1, 0, 0, 35)
			Toggle.BackgroundColor3 = theme.Main
			Toggle.Text = "  " .. text
			Toggle.TextColor3 = theme.Accent
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 13
			Toggle.TextXAlignment = Enum.TextXAlignment.Left
			Toggle.Parent = Page
			Instance.new("UICorner", Toggle)
			
			local Indicator = Instance.new("Frame")
			Indicator.Size = UDim2.new(0, 20, 0, 20)
			Indicator.Position = UDim2.new(1, -25, 0.5, -10)
			Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Indicator.Parent = Toggle
			Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

			local state = false
			Toggle.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = state and theme.Accent or Color3.fromRGB(50, 50, 50)}):Play()
				callback(state)
			end)
		end

		-- [SLIDER] (Ajustado para funcionar a dedo/mouse)
		function Components:AddSlider(text, min, max, default, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 45)
			SliderFrame.BackgroundColor3 = theme.Main
			SliderFrame.Parent = Page
			Instance.new("UICorner", SliderFrame)

			local Label = Instance.new("TextLabel")
			Label.Text = "  " .. text .. ": " .. default
			Label.Size = UDim2.new(1, 0, 0, 20)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = theme.Accent
			Label.Font = Enum.Font.Gotham
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local BarBG = Instance.new("Frame")
			BarBG.Size = UDim2.new(1, -20, 0, 6)
			BarBG.Position = UDim2.new(0, 10, 0, 30)
			BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			BarBG.Parent = SliderFrame
			Instance.new("UICorner", BarBG)

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
			Bar.BackgroundColor3 = theme.Accent
			Bar.Parent = BarBG
			Instance.new("UICorner", Bar)

			local function UpdateSlider()
				local mousePos = UserInputService:GetMouseLocation().X
				local barPos = BarBG.AbsolutePosition.X
				local barSize = BarBG.AbsoluteSize.X
				local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
				local value = math.floor(min + (max - min) * percent)
				
				Bar.Size = UDim2.new(percent, 0, 1, 0)
				Label.Text = "  " .. text .. ": " .. value
				callback(value)
			end

			BarBG.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local moveConn
					moveConn = UserInputService.InputChanged:Connect(function(moveInput)
						if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
							UpdateSlider()
						end
					end)
					UserInputService.InputEnded:Connect(function(endInput)
						if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
							moveConn:Disconnect()
						end
					end)
					UpdateSlider()
				end
			end)
		end

		return Components
	end

	OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
	
	return FlowLib
end

-----------------------------------------------------------
-- LÓGICA DO JOGO (SEA 1)
-----------------------------------------------------------

local QuestData = {
    {Level = 1, NPC = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1, EnemyPos = CFrame.new(1060, 17, 1547), QuestPos = CFrame.new(1060, 17, 1547)},
    {Level = 10, NPC = "Monkey", QuestName = "JungleQuest", QuestLevel = 1, EnemyPos = CFrame.new(-1600, 37, 150), QuestPos = CFrame.new(-1600, 37, 150)},
    -- ... (adicione as outras quests aqui conforme seu código original)
}

local function TweenTo(cframe)
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        local Dist = (HRP.Position - cframe.Position).Magnitude
        local Speed = _G.FlySpeed or 300
        local Info = TweenInfo.new(Dist / Speed, Enum.EasingStyle.Linear)
        local Tween = TweenService:Create(HRP, Info, {CFrame = cframe})
        Tween:Play()
        return Tween
    end
end

-- [EXECUÇÃO]
local MyUI = FlowLib:Init("DarkPurple")

local Farm = MyUI:AddTab("Farm")
local Config = MyUI:AddTab("Config")
local Fruits = MyUI:AddTab("Fruits")
local Teleport = MyUI:AddTab("Teleport")

-- EXEMPLO DE USO DOS NOVOS COMPONENTES:
Farm:AddToggle("Auto Farm Level", function(s)
    _G.AutoFarm = s
    -- Lógica de farm aqui...
end)

Config:AddSlider("Velocidade do Tween", 100, 500, 300, function(v)
    _G.FlySpeed = v
end)

Config:AddToggle("Pulo Infinito", function(s)
    _G.InfJump = s
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump then LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
    end)
end)

Fruits:AddToggle("Teleport to Fruit", function(s)
    _G.TPFruit = s
end)

-- Sistema de Noclip automático para o Tween
RunService.Stepped:Connect(function()
    if _G.AutoFarm and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
