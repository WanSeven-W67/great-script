local W7Lib = {}

function W7Lib:CreateWindow(judulScript)
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Pembersihan otomatis jika GUI sudah ada
    if PlayerGui:FindFirstChild("W7_Premium_Lib") then
        PlayerGui:FindFirstChild("W7_Premium_Lib"):Destroy()
    end

    -- 1. SCREEN GUI (Wadah Utama)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "W7_Premium_Lib"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    -- 2. MAIN FRAME (Kotak Besar)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22) -- Hitam pekat estetik
    MainFrame.Position = UDim2.new(0.5, -165, 0.5, -115)   -- Skala ideal HP
    MainFrame.Size = UDim2.new(0, 330, 0, 230)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 170, 255) -- Aksen metallic blue khas W7
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame

    -- 3. TOP BAR (Bagian Atas)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    -- Menutupi sudut bawah TopBar agar tetap kotak di dalam Frame melengkung
    local TopPatch = Instance.new("Frame")
    TopPatch.Size = UDim2.new(1, 0, 0, 10)
    TopPatch.Position = UDim2.new(0, 0, 1, -10)
    TopPatch.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TopPatch.BorderSizePixel = 0
    TopPatch.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = judulScript
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tombol Perkecil / Minimize GUI
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Parent = TopBar
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinBtn.Position = UDim2.new(0.88, 0, 0.2, 0)
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0) -- Lingkaran bulat
    MinCorner.Parent = MinBtn

    -- 4. TAB CONTAINER (Samping Kiri)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
    TabContainer.Position = UDim2.new(0, 6, 0, 44)
    TabContainer.Size = UDim2.new(0, 90, 1, -50)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 6)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 5. PAGE CONTAINER (Kanan)
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 102, 0, 44)
    PageContainer.Size = UDim2.new(1, -108, 1, -50)

    -- SCRIPT LOGIKA PERKECIL (MINIMIZE) GUI
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        if not minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 330, 0, 38)}):Play()
            MinBtn.Text = "+"
            minimized = true
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 330, 0, 230)}):Play()
            MinBtn.Text = "-"
            minimized = false
        end
    end)

    -- SCRIPT SYSTEM DRAG UNTUK LAYAR HP
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- LOGIKA MEMBUAT TAB & ELEMEN DI DALAMNYA
    local WindowFunctions = {}
    local firstTab = true

    function WindowFunctions:CreateTab(namaTab)
        -- Membuat Balok Menu di Kiri
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(0.92, 0, 0, 30)
        TabButton.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = namaTab
        TabButton.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabButton.TextSize = 11
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 5)
        TCorner.Parent = TabButton

        -- Membuat Wadah Halaman di Kanan
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = PageContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 6)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        -- Otomatis aktifkan tab pertama
        if firstTab then
            TabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            Page.Visible = true
            firstTab = false
        end

        -- Aksi pindah Tab saat disentuh
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(140, 140, 145) 
                    v.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
                end
            end
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        end)

        local ElementFunctions = {}
        
        -- ──> FITUR 1: TOMBOL ELEMEN (CREATE BUTTON)
        function ElementFunctions:CreateButton(namaTombol, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            Button.Size = UDim2.new(0.96, 0, 0, 32)
            Button.Font = Enum.Font.Gotham
            Button.Text = "  " .. namaTombol
            Button.TextColor3 = Color3.fromRGB(235, 235, 235)
            Button.TextSize = 12
            Button.TextXAlignment = Enum.TextXAlignment.Left
            
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = Button
            
            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(45, 45, 52)
            BStroke.Thickness = 1
            BStroke.Parent = Button

            Button.MouseButton1Click:Connect(function()
                -- Efek klik animasi kilat
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                task.wait(0.08)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
                pcall(callback)
            end)
        end

        -- ──> FITUR 2: SAKLAR ON/OFF (CREATE TOGGLE)
        function ElementFunctions:CreateToggle(namaToggle, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            ToggleFrame.Size = UDim2.new(0.96, 0, 0, 32)
            
            local TFCorner = Instance.new("UICorner")
            TFCorner.CornerRadius = UDim.new(0, 6)
            TFCorner.Parent = ToggleFrame

            local TFStroke = Instance.new("UIStroke")
            TFStroke.Color = Color3.fromRGB(45, 45, 52)
            TFStroke.Thickness = 1
            TFStroke.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0.04, 0, 0, 0)
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = namaToggle
            ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleLabel.TextSize = 12
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            -- Kotakan saklar indikator
            local Switch = Instance.new("TextButton")
            Switch.Name = "Switch"
            Switch.Parent = ToggleFrame
            Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Switch.Position = UDim2.new(0.82, 0, 0.2, 0)
            Switch.Size = UDim2.new(0, 32, 0, 18)
            Switch.Text = ""
            
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Switch
            
            -- Bulatan kecil di dalam saklar
            local Dot = Instance.new("Frame")
            Dot.Parent = Switch
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Position = UDim2.new(0.1, 0, 0.1, 0)
            Dot.Size = UDim2.new(0, 14, 0, 14)
            
            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(1, 0)
            DCorner.Parent = Dot

            local toggled = false
            Switch.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.1, 0)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0.1, 0, 0.1, 0)}):Play()
                end
                pcall(callback, toggled)
            end)
        end

        return ElementFunctions
    end

    return WindowFunctions
end

return W7Lib
