local W7Lib = {}

function W7Lib:CreateWindow(judulScript)
    -- 1. Wadah Utama
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "W7_Library"
    ScreenGui.Parent = game:GetService("CoreInterface") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- 2. Frame Utama (Background)
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Gelap estetik
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
    MainFrame.Size = UDim2.new(0, 320, 0, 220)
    MainFrame.Active = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 170, 255) -- Garis tepi cyan/biru terang
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- 3. TopBar (Judul)
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.04, 0, 0, 0)
    Title.Size = UDim2.new(0.9, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = judulScript
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- 4. PENGATUR TAB (Menu Samping / Kiri)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    TabContainer.Position = UDim2.new(0, 5, 0, 40)
    TabContainer.Size = UDim2.new(0, 90, 1, -45)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 5. WADAH HALAMAN (Kanan)
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 100, 0, 40)
    PageContainer.Size = UDim2.new(1, -105, 1, -45)

    -- Fitur Geser Layar Sentuh (HP Friendly)
    local UserInputService = game:GetService("UserInputService")
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

    -- Logika Pembuatan Tab & Konten
    local WindowFunctions = {}
    local firstTab = true

    function WindowFunctions:CreateTab(namaTab)
        -- Bikin Tombol Tab di Kiri
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(0.9, 0, 0, 28)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = namaTab
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 11
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 4)
        TCorner.Parent = TabButton

        -- Bikin Halaman Kanan Pasangannya
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = PageContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 6)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        -- Buka tab pertama secara otomatis
        if firstTab then
            TabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
            Page.Visible = true
            firstTab = false
        end

        -- Aksi pindah Tab saat diklik/sentuh
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
            end
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(0, 170, 255)
        end)

        -- FUNGSI TOMBOL DI DALAM TAB INI
        local ElementFunctions = {}
        
        function ElementFunctions:CreateButton(namaTombol, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            Button.Size = UDim2.new(0.95, 0, 0, 30)
            Button.Font = Enum.Font.Gotham
            Button.Text = namaTombol
            Button.TextColor3 = Color3.fromRGB(230, 230, 230)
            Button.TextSize = 12
            
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 5)
            BCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return ElementFunctions
    end

    return WindowFunctions
end

return W7Lib
