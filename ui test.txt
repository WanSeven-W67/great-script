-- =============================================================================
-- MAHA KARYA: W7 PREMIUM UI LIBRARY (FRAMEWORK v1.0)
-- PEMBUAT: W7 (WanSeven)
-- BAGIAN: 1 / 4 (Fondasi, Auto-Scale, & Core Engine)
-- =============================================================================

local W7Lib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Membersihkan UI lama jika ada biar gak tumpang tindih
if PlayerGui:FindFirstChild("W7_Premium_Lib") then
    PlayerGui:FindFirstChild("W7_Premium_Lib"):Destroy()
end

function W7Lib:CreateWindow(judulScript)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "W7_Premium_Lib"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true -- Mengabaikan bar atas roblox agar posisi akurat

    -- FITUR 18: Auto-Scale GUI (Menghitung ukuran proporsional layar HP)
    local CurrentScreenSize = ScreenGui.AbsoluteSize
    local baseWidth = math.clamp(CurrentScreenSize.X * 0.45, 330, 480)
    local baseHeight = math.clamp(CurrentScreenSize.Y * 0.55, 230, 320)
    
    -- Konfigurasi Default & Fitur 13 (Auto-Save Cache)
    local SaveFile = "W7_Config_Cache.json"
    local Config = {
        Width = baseWidth,
        Height = baseHeight,
        ThemeColor = {0, 170, 255},
        BgImage = "",
        SoundEnabled = true,
        FPSBoost = false
    }

    -- Membaca file save jika device executor mendukung writefile/readfile
    if readfile and isfile and isfile(SaveFile) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(SaveFile))
            for k, v in pairs(decoded) do Config[k] = v end
        end)
    end

    local function SaveConfig()
        if writefile then
            pcall(function()
                writefile(SaveFile, HttpService:JSONEncode(Config))
            end)
        end
    end

    -- FITUR 16: Custom Sound Effects Generator
    local function PlayClickSound()
        if not Config.SoundEnabled then return end
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9114223161" -- Efek klik sci-fi modern
        sound.Volume = 1
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end

    -- Pembuatan Main Frame (Kotak Utama W7 Hub)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    MainFrame.Position = UDim2.new(0.5, -Config.Width/2, 0.45, -Config.Height/2)
    MainFrame.Size = UDim2.new(0, Config.Width, 0, Config.Height)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    -- Garis Tepi Estetik (Aksen Warna W7)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(unpack(Config.ThemeColor))
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame

    -- FITUR 17: Custom Background Image (Layer Foto Pilihan User)
    local BgImageLabel = Instance.new("ImageLabel")
    BgImageLabel.Name = "BgImageLabel"
    BgImageLabel.Parent = MainFrame
    BgImageLabel.Size = UDim2.new(1, 0, 1, 0)
    BgImageLabel.BackgroundTransparency = 1
    BgImageLabel.Image = Config.BgImage
    BgImageLabel.ImageTransparency = 0.75 -- Efek Glassmorphic halus agar tombol terlihat
    BgImageLabel.ScaleType = Enum.ScaleType.Crop

    -- TopBar (Kepala Menu untuk Geser/Drag di HP)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    TopBar.BackgroundTransparency = Config.BgImage ~= "" and 0.2 or 0
    TopBar.Size = UDim2.new(1, 0, 0, 42)

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 14)
    TopCorner.Parent = TopBar

    local TopPatch = Instance.new("Frame") -- Menutupi sudut bawah TopBar agar kotak
    TopPatch.Size = UDim2.new(1, 0, 0, 12)
    TopPatch.Position = UDim2.new(0, 0, 1, -12)
    TopPatch.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    TopPatch.BackgroundTransparency = TopBar.BackgroundTransparency
    TopPatch.BorderSizePixel = 0
    TopPatch.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.04, 0, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = judulScript
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tombol Minimize Bulat Khas W7 Premium
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Parent = TopBar
    MinBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    MinBtn.Position = UDim2.new(1, -34, 0.22, 0)
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 15

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinBtn
-- =============================================================================
-- BAGIAN: 2 / 4 (Sistem Sentuh/Drag, Minimize, & Wadah Navigasi)
-- (TIDAK BOLEH ADA BARIS KOSONG ANTARA BAGIAN 1 DAN 2)
-- =============================================================================

    -- FITUR MINIMIZE (Sembunyikan Menu Menjadi Bar)
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        if not minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 42)}):Play()
            MinBtn.Text = "+"
            minimized = true
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, Config.Height)}):Play()
            MinBtn.Text = "-"
            minimized = false
        end
    end)

    -- SCRIPT DRAG UNTUK PENGGUNA HP (Mobile Touch / Mouse)
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then dragging = false end 
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end 
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- FITUR 12: Smart Search Bar (Cari Fitur Global)
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = TopBar
    SearchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    SearchBox.Position = UDim2.new(0.55, 0, 0.15, 0)
    SearchBox.Size = UDim2.new(0.3, 0, 0.7, 0)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Cari..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    SearchBox.TextSize = 11
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Color3.fromRGB(40, 40, 50)
    SearchStroke.Parent = SearchBox

    -- Wadah Navigasi Samping (Tab Container)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    TabContainer.BackgroundTransparency = Config.BgImage ~= "" and 0.4 or 0
    TabContainer.Position = UDim2.new(0, 6, 0, 48)
    TabContainer.Size = UDim2.new(0, 100, 1, -56)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 6)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Wadah Halaman Utama (Page Container)
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Position = UDim2.new(0, 114, 0, 48)
    PageContainer.Size = UDim2.new(1, -122, 1, -56)
-- =============================================================================
-- BAGIAN: 3 / 4 (FPS Counter, Watermark, & Pembuatan Komponen)
-- (TIDAK BOLEH ADA BARIS KOSONG ANTARA BAGIAN 2 DAN 3)
-- =============================================================================

    -- FITUR 20: Watermark & FPS/Ping Counter di Pojok Layar Kiri Atas
    local WatermarkUI = Instance.new("ScreenGui")
    WatermarkUI.Name = "W7_Watermark"
    WatermarkUI.Parent = PlayerGui
    WatermarkUI.IgnoreGuiInset = true

    local WatermarkLabel = Instance.new("TextLabel")
    WatermarkLabel.Parent = WatermarkUI
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.Position = UDim2.new(0, 10, 0, 10)
    WatermarkLabel.Size = UDim2.new(0, 200, 0, 20)
    WatermarkLabel.Font = Enum.Font.GothamBold
    WatermarkLabel.Text = judulScript .. " | FPS: -- | Ping: --"
    WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WatermarkLabel.TextSize = 12
    WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local WatermarkStroke = Instance.new("UIStroke")
    WatermarkStroke.Thickness = 1.2
    WatermarkStroke.Parent = WatermarkLabel

    -- Loop Penghitung FPS dan Ping
    local lastUpdate = tick()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - lastUpdate >= 1 then
            local ping = string.format("%.0f", LocalPlayer:GetNetworkPing() * 1000)
            WatermarkLabel.Text = string.format("%s | FPS: %d | Ping: %sms", judulScript, frames, ping)
            frames = 0
            lastUpdate = tick()
        end
    end)

    local WindowFunctions = {}
    local ElementsLibrary = {} -- Menyimpan semua tombol untuk dicari SearchBox
    local firstTab = true

    -- FITUR 1 & 18: Fungsi Custom Resize (Otomatis atur proporsi tombol min)
    function WindowFunctions:ChangeSize(width, height)
        Config.Width = width
        Config.Height = height
        SaveConfig()
        if not minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, width, 0, height)}):Play()
            -- MainFrame posisi juga perlu dikalkulasi ulang
            TweenService:Create(MainFrame, TweenInfo.new(0.4), {Position = UDim2.new(0.5, -width/2, 0.45, -height/2)}):Play()
        end
    end

    function WindowFunctions:CreateTab(namaTab)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(0.92, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        TabButton.BackgroundTransparency = Config.BgImage ~= "" and 0.3 or 0
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = namaTab
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 155)
        TabButton.TextSize = 11
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 6)
        TCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = namaTab
        Page.Parent = PageContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(unpack(Config.ThemeColor))

        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 6)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        if firstTab then
            TabButton.TextColor3 = Color3.fromRGB(unpack(Config.ThemeColor))
            TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            Page.Visible = true
            firstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            PlayClickSound()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150, 150, 155) 
                    v.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
                end
            end
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(unpack(Config.ThemeColor))
            TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        end)

        -- Logika Smart Search Bar
        SearchBox.Changed:Connect(function()
            local searchText = string.lower(SearchBox.Text)
            for _, item in pairs(ElementsLibrary) do
                if string.find(string.lower(item.Name), searchText) then
                    item.Instance.Visible = true
                else
                    item.Instance.Visible = false
                end
            end
        end)
-- =============================================================================
-- BAGIAN: 4 / 4 (Komponen Interaktif & Penutup Library)
-- (TIDAK BOLEH ADA BARIS KOSONG ANTARA BAGIAN 3 DAN 4)
-- =============================================================================

        local TabFunctions = {}

        -- COMPONENT: Button (Tombol Biasa)
        function TabFunctions:CreateButton(text, callback)
            callback = callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = text
            ButtonFrame.Size = UDim2.new(0.94, 0, 0, 36)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            ButtonFrame.BackgroundTransparency = Config.BgImage ~= "" and 0.4 or 0
            ButtonFrame.Parent = Page

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = ButtonFrame

            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(45, 45, 55)
            BStroke.Parent = ButtonFrame

            local ActualButton = Instance.new("TextButton")
            ActualButton.Size = UDim2.new(1, 0, 1, 0)
            ActualButton.BackgroundTransparency = 1
            ActualButton.Font = Enum.Font.GothamMedium
            ActualButton.Text = text
            ActualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActualButton.TextSize = 12
            ActualButton.Parent = ButtonFrame

            ActualButton.MouseButton1Click:Connect(function()
                PlayClickSound()
                -- Efek klik berkedip tipis pada stroke aksen
                BStroke.Color = Color3.fromRGB(unpack(Config.ThemeColor))
                task.spawn(callback)
                task.wait(0.15)
                BStroke.Color = Color3.fromRGB(45, 45, 55)
            end)

            table.insert(ElementsLibrary, {Name = text, Instance = ButtonFrame})
        end

        -- COMPONENT: Toggle (Saklar ON/OFF)
        function TabFunctions:CreateToggle(text, default, callback)
            callback = callback or function() end
            local state = default or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text
            ToggleFrame.Size = UDim2.new(0.94, 0, 0, 36)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            ToggleFrame.BackgroundTransparency = Config.BgImage ~= "" and 0.4 or 0
            ToggleFrame.Parent = Page

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = ToggleFrame

            local TStroke = Instance.new("UIStroke")
            TStroke.Color = Color3.fromRGB(45, 45, 55)
            TStroke.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Position = UDim2.new(0.04, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            -- Wadah lampu saklar belakang
            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 36, 0, 18)
            Switch.Position = UDim2.new(1, -46, 0.25, 0)
            Switch.BackgroundColor3 = state and Color3.fromRGB(unpack(Config.ThemeColor)) or Color3.fromRGB(40, 40, 50)
            Switch.Text = ""
            Switch.Parent = ToggleFrame

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Switch

            -- Pentolan bulat saklar
            local SliderDot = Instance.new("Frame")
            SliderDot.Size = UDim2.new(0, 14, 0, 14)
            SliderDot.Position = state and UDim2.new(1, -16, 0.1, 0) or UDim2.new(0, 2, 0.1, 0)
            SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderDot.Parent = Switch

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(1, 0)
            DCorner.Parent = SliderDot

            Switch.MouseButton1Click:Connect(function()
                PlayClickSound()
                state = not state
                local targetPos = state and UDim2.new(1, -16, 0.1, 0) or UDim2.new(0, 2, 0.1, 0)
                local targetColor = state and Color3.fromRGB(unpack(Config.ThemeColor)) or Color3.fromRGB(40, 40, 50)
                
                TweenService:Create(SliderDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
                
                task.spawn(callback, state)
            end)

            table.insert(ElementsLibrary, {Name = text, Instance = ToggleFrame})
        end

        -- COMPONENT: Slider (Geseran Angka)
        function TabFunctions:CreateSlider(text, min, max, default, callback)
            callback = callback or function() end
            local value = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text
            SliderFrame.Size = UDim2.new(0.94, 0, 0, 44)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            SliderFrame.BackgroundTransparency = Config.BgImage ~= "" and 0.4 or 0
            SliderFrame.Parent = Page

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 6)
            SCorner.Parent = SliderFrame

            local SStroke = Instance.new("UIStroke")
            SStroke.Color = Color3.fromRGB(45, 45, 55)
            SStroke.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 0, 22)
            Label.Position = UDim2.new(0.04, 0, 0, 2)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.3, 0, 0, 22)
            ValueLabel.Position = UDim2.new(0.66, 0, 0, 2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = Color3.fromRGB(unpack(Config.ThemeColor))
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            -- Rel lintasan geser
            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(0.92, 0, 0, 4)
            Track.Position = UDim2.new(0.04, 0, 0.7, 0)
            Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Track.Text = ""
            Track.Parent = SliderFrame

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = Track

            -- Isi lintasan yang berwarna aktif
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(unpack(Config.ThemeColor))
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local sliding = false
            local function UpdateSlider(input)
                local ratio = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * ratio)
                ValueLabel.Text = tostring(value)
                Fill.Size = UDim2.new(ratio, 0, 1, 0)
                task.spawn(callback, value)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            table.insert(ElementsLibrary, {Name = text, Instance = SliderFrame})
        end

        -- COMPONENT: TextBox (Kolom Ketik Input)
        function TabFunctions:CreateTextBox(text, placeholder, callback)
            callback = callback or function() end

            local BoxFrame = Instance.new("Frame")
            BoxFrame.Name = text
            BoxFrame.Size = UDim2.new(0.94, 0, 0, 38)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            BoxFrame.BackgroundTransparency = Config.BgImage ~= "" and 0.4 or 0
            BoxFrame.Parent = Page

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = BoxFrame

            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(45, 45, 55)
            BStroke.Parent = BoxFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0.04, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame

            local ActualBox = Instance.new("TextBox")
            ActualBox.Size = UDim2.new(0.4, 0, 0, 22)
            ActualBox.Position = UDim2.new(0.56, 0, 0.2, 0)
            ActualBox.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
            ActualBox.Font = Enum.Font.Gotham
            ActualBox.PlaceholderText = placeholder
            ActualBox.Text = ""
            ActualBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActualBox.TextSize = 11

            local ABCorner = Instance.new("UICorner")
            ABCorner.CornerRadius = UDim.new(0, 4)
            ABCorner.Parent = ActualBox

            ActualBox.FocusLost:Connect(function(enterPressed)
                PlayClickSound()
                task.spawn(callback, ActualBox.Text, enterPressed)
            end)

            table.insert(ElementsLibrary, {Name = text, Instance = BoxFrame})
        end

        -- COMPONENT: Paragraph / Label Info (Kotak Informasi Teks)
        function TabFunctions:CreateParagraph(title, desc)
            local ParaFrame = Instance.new("Frame")
            ParaFrame.Name = title
            ParaFrame.Size = UDim2.new(0.94, 0, 0, 50)
            ParaFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            ParaFrame.BackgroundTransparency = Config.BgImage ~= "" and 0.5 or 0
            ParaFrame.Parent = Page

            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 6)
            PCorner.Parent = ParaFrame

            local PStroke = Instance.new("UIStroke")
            PStroke.Color = Color3.fromRGB(35, 35, 45)
            PStroke.Parent = ParaFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(0.92, 0, 0, 20)
            TitleLabel.Position = UDim2.new(0.04, 0, 0, 4)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Color3.fromRGB(unpack(Config.ThemeColor))
            TitleLabel.TextSize = 11
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = ParaFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Size = UDim2.new(0.92, 0, 0, 24)
            DescLabel.Position = UDim2.new(0.04, 0, 0, 22)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = desc
            DescLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
            DescLabel.TextSize = 11
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextYAlignment = Enum.TextYAlignment.Top
            DescLabel.TextWrapped = true
            DescLabel.Parent = ParaFrame

            -- Auto-adjust tinggi kotak kalau deskripsinya kepanjangan
            if DescLabel.TextBounds.X > DescLabel.AbsoluteSize.X then
                ParaFrame.Size = UDim2.new(0.94, 0, 0, 60)
                DescLabel.Size = UDim2.new(0.92, 0, 0, 34)
            end

            table.insert(ElementsLibrary, {Name = title .. " " .. desc, Instance = ParaFrame})
        end

        -- ENGINE CORE: Integrasi Sistem Luar (Ganti Gambar & Destroy)
        function WindowFunctions:SetBackgroundImage(assetId)
            Config.BgImage = "rbxassetid://" .. tostring(assetId:match("%d+"))
            BgImageLabel.Image = Config.BgImage
            TopBar.BackgroundTransparency = 0.2
            TabContainer.BackgroundTransparency = 0.4
            SaveConfig()
        end

        function WindowFunctions:DestroyGUI()
            WatermarkUI:Destroy()
            ScreenGui:Destroy()
        end

        return TabFunctions
    end

    return WindowFunctions
end

return W7Lib
