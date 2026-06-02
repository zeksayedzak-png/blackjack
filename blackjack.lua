-- MozerHub v2 - Blackjack Edition
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSidebar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local MinimizedFrame = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local UserProfile = Instance.new("Frame")
local UserName = Instance.new("TextLabel")
local UserID = Instance.new("TextLabel")
local UserIcon = Instance.new("ImageLabel")
local TabContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- Settings & Variables
local Balance = 1000
local CurrentBet = 0
local PlayerHand = {}
local DealerHand = {}
local Deck = {}
local GameActive = false

-- ScreenGui Setup
ScreenGui.Name = "MozerHub_v2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Welcome Animation
local function ShowWelcome()
    local WelcomeGui = Instance.new("ScreenGui", game.CoreGui)
    local MozerLabel = Instance.new("TextLabel", WelcomeGui)
    MozerLabel.Size = UDim2.new(1, 0, 0.1, 0)
    MozerLabel.Position = UDim2.new(0, 0, 0.38, 0)
    MozerLabel.BackgroundTransparency = 1
    MozerLabel.Text = "Mozer"
    MozerLabel.TextSize = 80
    MozerLabel.Font = Enum.Font.FredokaOne
    local WelcomeLabel = Instance.new("TextLabel", WelcomeGui)
    WelcomeLabel.Size = UDim2.new(1, 0, 0.1, 0)
    WelcomeLabel.Position = UDim2.new(0, 0, 0.56, 0)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome Blackjack"
    WelcomeLabel.TextSize = 40
    WelcomeLabel.Font = Enum.Font.FredokaOne
    task.spawn(function()
        while WelcomeGui.Parent do
            local hue = tick() % 5 / 5
            MozerLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            WelcomeLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait()
        end
    end)
    task.wait(2.2)
    WelcomeGui:Destroy()
end

-- Main Window
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Sidebar
LeftSidebar.Name = "Sidebar"
LeftSidebar.Parent = MainFrame
LeftSidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LeftSidebar.Size = UDim2.new(0, 155, 1, 0)
LeftSidebar.BorderSizePixel = 0
Instance.new("UICorner", LeftSidebar).CornerRadius = UDim.new(0, 12)

Title.Parent = LeftSidebar
Title.Text = "Be Mozer 🃏"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22

-- Right Content (Blackjack Area)
RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightContent.Position = UDim2.new(0, 165, 0, 20)
RightContent.Size = UDim2.new(1, -175, 1, -40)
Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 12)

-- UI Elements for Game
local BalanceLabel = Instance.new("TextLabel", RightContent)
BalanceLabel.Size = UDim2.new(0.6, 0, 0, 30)
BalanceLabel.Position = UDim2.new(0, 10, 0, 5)
BalanceLabel.Text = "💰 Coins: " .. Balance
BalanceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
BalanceLabel.BackgroundTransparency = 1
BalanceLabel.Font = Enum.Font.GothamBold
BalanceLabel.TextSize = 16
BalanceLabel.TextXAlignment = Enum.TextXAlignment.Left

local RefreshBtn = Instance.new("TextButton", RightContent)
RefreshBtn.Size = UDim2.new(0, 30, 0, 30)
RefreshBtn.Position = UDim2.new(0.9, -35, 0, 5)
RefreshBtn.Text = "🔄"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", RefreshBtn)

local GameArea = Instance.new("Frame", RightContent)
GameArea.Size = UDim2.new(1, -20, 0.5, 0)
GameArea.Position = UDim2.new(0, 10, 0, 40)
GameArea.BackgroundTransparency = 1

local DealerFrame = Instance.new("Frame", GameArea)
DealerFrame.Size = UDim2.new(1, 0, 0.45, 0)
DealerFrame.BackgroundTransparency = 1

local PlayerFrame = Instance.new("Frame", GameArea)
PlayerFrame.Size = UDim2.new(1, 0, 0.45, 0)
PlayerFrame.Position = UDim2.new(0, 0, 0.55, 0)
PlayerFrame.BackgroundTransparency = 1

-- Betting Buttons Container
local BetContainer = Instance.new("Frame", RightContent)
BetContainer.Size = UDim2.new(1, -10, 0, 40)
BetContainer.Position = UDim2.new(0, 5, 1, -85)
BetContainer.BackgroundTransparency = 1
local BetLayout = Instance.new("UIListLayout", BetContainer)
BetLayout.FillDirection = Enum.FillDirection.Horizontal
BetLayout.Padding = UDim.new(0, 4)
BetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ControlContainer = Instance.new("Frame", RightContent)
ControlContainer.Size = UDim2.new(1, -10, 0, 35)
ControlContainer.Position = UDim2.new(0, 5, 1, -40)
ControlContainer.BackgroundTransparency = 1

-- Function to create card UI
local function CreateCardUI(card, parent)
	local c = Instance.new("Frame", parent)
	c.Size = UDim2.new(0, 45, 0, 70)
	c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	local corner = Instance.new("UICorner", c)
	corner.CornerRadius = UDim.new(0, 8)
	
	local suit = Instance.new("TextLabel", c)
	suit.Size = UDim2.new(1, 0, 0.5, 0)
	suit.Text = card.Suit
	suit.TextSize = 20
	suit.BackgroundTransparency = 1
	
	local val = Instance.new("TextLabel", c)
	val.Size = UDim2.new(1, 0, 0.5, 0)
	val.Position = UDim2.new(0, 0, 0.5, 0)
	val.Text = card.Name .. "\n" .. card.Val
	val.TextSize = 10
	val.TextColor3 = Color3.fromRGB(0,0,0)
	val.Font = Enum.Font.GothamBold
	val.BackgroundTransparency = 1
    
    Instance.new("UIListLayout", parent).FillDirection = Enum.FillDirection.Horizontal
    Instance.new("UIListLayout", parent).Padding = UDim.new(0, 5)
end

-- Game Logic
local suits = {"❤️", "💎", "♣️", "♠️"}
local names = {
	[1]="الآس",[11]="عجوز👴",[12]="أميرة👸",[13]="ملك🤴"
}

local function CreateDeck()
	Deck = {}
	for _, suit in pairs(suits) do
		for i = 1, 13 do
			local cName = names[i] or tostring(i)
			local cVal = i
			if i > 10 then cVal = 10 end
			if i == 1 then cVal = 11 end
			table.insert(Deck, {Suit = suit, Name = cName, Val = cVal, RealNum = i})
		end
	end
end

local function GetScore(hand)
	local score = 0
	local aces = 0
	for _, card in pairs(hand) do
		score = score + card.Val
		if card.RealNum == 1 then aces = aces + 1 end
	end
	while score > 21 and aces > 0 do
		score = score - 10
		aces = aces - 1
	end
	return score
end

local function ClearTable()
	for _, v in pairs(DealerFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
	for _, v in pairs(PlayerFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
end

local function EndGame(msg)
	GameActive = false
	CurrentBet = 0
	BalanceLabel.Text = "💰 Coins: " .. Balance .. " | " .. msg
end

-- Create Betting Buttons
local bets = {10, 50, 100, 500, 1000, 2000, 5000, 10000}
for _, bAmount in pairs(bets) do
	local b = Instance.new("TextButton", BetContainer)
	b.Size = UDim2.new(0, 42, 1, 0)
	b.Text = "💵\n" .. bAmount
	b.TextSize = 10
	b.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", b)
	
	b.MouseButton1Click:Connect(function()
		if not GameActive and Balance >= bAmount then
			CurrentBet = bAmount
			BalanceLabel.Text = "💰 Coins: " .. Balance .. " | Bet: " .. CurrentBet
		end
	end)
end

-- Action Buttons
local SelectBtn = Instance.new("TextButton", ControlContainer)
SelectBtn.Size = UDim2.new(0, 80, 1, 0)
SelectBtn.Position = UDim2.new(0, 0, 0, 0)
SelectBtn.Text = "Select ✅"
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
Instance.new("UICorner", SelectBtn)

local HitBtn = Instance.new("TextButton", ControlContainer)
HitBtn.Size = UDim2.new(0, 80, 1, 0)
HitBtn.Position = UDim2.new(0, 90, 0, 0)
HitBtn.Text = "سحب 🃏"
HitBtn.Visible = false
Instance.new("UICorner", HitBtn)

local StandBtn = Instance.new("TextButton", ControlContainer)
StandBtn.Size = UDim2.new(0, 80, 1, 0)
StandBtn.Position = UDim2.new(0, 180, 0, 0)
StandBtn.Text = "توقف ✋"
StandBtn.Visible = false
Instance.new("UICorner", StandBtn)

SelectBtn.MouseButton1Click:Connect(function()
	if CurrentBet > 0 and not GameActive then
		GameActive = true
		Balance = Balance - CurrentBet
		BalanceLabel.Text = "💰 Coins: " .. Balance .. " | Bet: " .. CurrentBet
		ClearTable()
		CreateDeck()
		PlayerHand = {Deck[math.random(#Deck)], Deck[math.random(#Deck)]}
		DealerHand = {Deck[math.random(#Deck)]}
		
		for _, c in pairs(PlayerHand) do CreateCardUI(c, PlayerFrame) end
		for _, c in pairs(DealerHand) do CreateCardUI(c, DealerFrame) end
		
		SelectBtn.Visible = false
		HitBtn.Visible = true
		StandBtn.Visible = true
	end
end)

HitBtn.MouseButton1Click:Connect(function()
	local card = Deck[math.random(#Deck)]
	table.insert(PlayerHand, card)
	CreateCardUI(card, PlayerFrame)
	if GetScore(PlayerHand) > 21 then
		HitBtn.Visible = false
		StandBtn.Visible = false
		SelectBtn.Visible = true
		EndGame("LOSE! (Bust)")
	end
end)

StandBtn.MouseButton1Click:Connect(function()
	HitBtn.Visible = false
	StandBtn.Visible = false
	SelectBtn.Visible = true
	
	while GetScore(DealerHand) < 17 do
		local card = Deck[math.random(#Deck)]
		table.insert(DealerHand, card)
		CreateCardUI(card, DealerFrame)
	end
	
	local pS = GetScore(PlayerHand)
	local dS = GetScore(DealerHand)
	
	if dS > 21 or pS > dS then
		Balance = Balance + (CurrentBet * 2)
		EndGame("WIN! 🎉")
	elseif pS < dS then
		EndGame("LOSE! 💀")
	else
		Balance = Balance + CurrentBet
		EndGame("DRAW! ⚖️")
	end
end)

RefreshBtn.MouseButton1Click:Connect(function()
    if not GameActive then
        Balance = 1000
        BalanceLabel.Text = "💰 Coins: " .. Balance
    end
end)

-- Draggable & Minimized Logic (From your template)
local function MakeDraggable(frame)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizedFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizedFrame.Size = UDim2.new(0, 55, 0, 55)
MinimizedFrame.Visible = false
MinimizedFrame.Text = "🃏"
MinimizedFrame.TextSize = 32
Instance.new("UICorner", MinimizedFrame)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
end)

MakeDraggable(MainFrame)
MakeDraggable(MinimizedFrame)

task.spawn(function()
    ShowWelcome()
    MainFrame.Visible = true
end)
