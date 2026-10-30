local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local oldGui = CoreGui:FindFirstChild("ClassicProximityPromptGUI") or LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ClassicProximityPromptGUI")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClassicLibrary"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local isMinimized = false
local normalSize = UDim2.new(0, 340, 0, 310)
local normalMainSize = UDim2.new(0, 340, 0, 260)
local centerPos = UDim2.new(0.5, -170, 0.5, -155)

local BG_MAIN = Color3.fromRGB(25, 25, 27)
local BG_TITLE = Color3.fromRGB(33, 33, 36)
local COLOR_ON = Color3.fromRGB(46, 204, 113)
local COLOR_OFF = Color3.fromRGB(231, 76, 60)
local BTN_BG = Color3.fromRGB(38, 38, 42)
local TEXT_COLOR = Color3.fromRGB(240, 240, 245)
local BORDER_COLOR = Color3.fromRGB(50, 50, 55)
local TAB_ACTIVE = Color3.fromRGB(55, 55, 62)
local TAB_INACTIVE = Color3.fromRGB(38, 38, 42)

local MasterFrame = Instance.new("Frame")
MasterFrame.Name = "MasterFrame"
MasterFrame.Size = normalSize
MasterFrame.Position = centerPos
MasterFrame.BackgroundTransparency = 1
MasterFrame.Active = true
MasterFrame.Parent = ScreenGui

local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Size = UDim2.new(1, 0, 0, 45)
TitleFrame.BackgroundColor3 = BG_TITLE
TitleFrame.BorderSizePixel = 0
TitleFrame.ZIndex = 3
TitleFrame.Parent = MasterFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Classic Library"
TitleLabel.TextColor3 = TEXT_COLOR
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = TitleFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 22, 0, 22)
ToggleButton.Position = UDim2.new(1, -37, 0, 11.5)
ToggleButton.BackgroundColor3 = COLOR_ON
ToggleButton.Text = ""
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 4
ToggleButton.Parent = TitleFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 5)
ToggleCorner.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = normalMainSize
MainFrame.Position = UDim2.new(0, 0, 0, 45)
MainFrame.BackgroundColor3 = BG_MAIN
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 1
MainFrame.Parent = MasterFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1
MainStroke.Color = BORDER_COLOR
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

local TabHolder = Instance.new("Frame")
TabHolder.Name = "TabHolder"
TabHolder.Size = UDim2.new(0, 85, 1, 0)
TabHolder.Position = UDim2.new(0, 0, 0, 0)
TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
TabHolder.BorderSizePixel = 0
TabHolder.Parent = MainFrame

local TabHolderCorner = Instance.new("UICorner")
TabHolderCorner.CornerRadius = UDim.new(0, 8)
TabHolderCorner.Parent = TabHolder

local TabFix = Instance.new("Frame")
TabFix.Name = "Fix"
TabFix.Size = UDim2.new(0, 20, 1, 0)
TabFix.Position = UDim2.new(1, -10, 0, 0)
TabFix.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
TabFix.BorderSizePixel = 0
TabFix.Parent = TabHolder

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabHolder
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.Parent = TabHolder

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.Size = UDim2.new(0, 255, 1, 0)
ContentHolder.Position = UDim2.new(0, 85, 0, 0)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = MainFrame

local Library = {}
Library.Flags = {}
Library.Tabs = {}
Library.CurrentTab = nil

local function makeCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function makeStroke(obj)
    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Color = BORDER_COLOR
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

function Library:Notify(title, text, dur)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 250, 0, 60)
    n.Position = UDim2.new(1, -260, 1, -70)
    n.BackgroundColor3 = BG_TITLE
    n.BorderSizePixel = 0
    n.Parent = ScreenGui
    makeCorner(n, 8)
    makeStroke(n)
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -20, 0, 20)
    tl.Position = UDim2.new(0, 10, 0, 5)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = TEXT_COLOR
    tl.Font = Enum.Font.SourceSansBold
    tl.TextSize = 14
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Parent = n
    local tc = Instance.new("TextLabel")
    tc.Size = UDim2.new(1, -20, 0, 30)
    tc.Position = UDim2.new(0, 10, 0, 25)
    tc.BackgroundTransparency = 1
    tc.Text = text
    tc.TextColor3 = Color3.fromRGB(200, 200, 200)
    tc.Font = Enum.Font.SourceSans
    tc.TextSize = 12
    tc.TextXAlignment = Enum.TextXAlignment.Left
    tc.TextWrapped = true
    tc.Parent = n
    game:GetService("Debris"):AddItem(n, dur or 3)
end

function Library:AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(0, 70, 0, 22)
    TabButton.BackgroundColor3 = TAB_INACTIVE
    TabButton.TextColor3 = TEXT_COLOR
    TabButton.Text = name
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 12
    TabButton.BorderSizePixel = 0
    TabButton.ZIndex = 2
    TabButton.LayoutOrder = #TabHolder:GetChildren()
    TabButton.Parent = TabHolder
    makeCorner(TabButton, 5)
    makeStroke(TabButton)

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = name.."_Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.ScrollBarThickness = 2
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentFrame.Visible = false
    ContentFrame.Parent = ContentHolder

    local ContentList = Instance.new("UIListLayout")
    ContentList.Parent = ContentFrame
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingTop = UDim.new(0, 12)
    ContentPad.PaddingBottom = UDim2.new(0, 12)
    ContentPad.Parent = ContentFrame

    local Tab = {}
    Tab.Button = TabButton
    Tab.Content = ContentFrame

    function Tab:CreateScrollingFrame(size)
        local sf = Instance.new("ScrollingFrame")
        sf.Size = size or UDim2.new(0.92, 0, 0, 100)
        sf.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
        sf.BorderSizePixel = 0
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.ScrollBarThickness = 2
        sf.Parent = ContentFrame
        makeCorner(sf, 6)
        makeStroke(sf)
        local ll = Instance.new("UIListLayout")
        ll.Parent = sf
        ll.Padding = UDim.new(0, 6)
        ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local pd = Instance.new("UIPadding")
        pd.PaddingTop = UDim.new(0, 6)
        pd.PaddingBottom = UDim.new(0, 6)
        pd.Parent = sf
        return sf
    end

    function Tab:AddSection(text)
        local sec = Instance.new("TextLabel")
        sec.Size = UDim2.new(0.92, 0, 0, 25)
        sec.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
        sec.TextColor3 = TEXT_COLOR
        sec.Text = text
        sec.Font = Enum.Font.SourceSansBold
        sec.TextSize = 13
        sec.BorderSizePixel = 0
        sec.Parent = ContentFrame
        makeCorner(sec, 6)
        return sec
    end

    function Tab:AddDivider()
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0.92, 0, 0, 1)
        d.BackgroundColor3 = BORDER_COLOR
        d.BorderSizePixel = 0
        d.Parent = ContentFrame
        return d
    end

    function Tab:AddParagraph(title, content)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.92, 0, 0, 60)
        f.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
        f.BorderSizePixel = 0
        f.Parent = ContentFrame
        makeCorner(f, 6)
        makeStroke(f)
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -10, 0, 20)
        t.Position = UDim2.new(0, 10, 0, 5)
        t.BackgroundTransparency = 1
        t.Text = title
        t.TextColor3 = TEXT_COLOR
        t.Font = Enum.Font.SourceSansBold
        t.TextSize = 13
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = f
        local c = Instance.new("TextLabel")
        c.Size = UDim2.new(1, -10, 0, 30)
        c.Position = UDim2.new(0, 10, 0, 25)
        c.BackgroundTransparency = 1
        c.Text = content
        c.TextColor3 = Color3.fromRGB(180, 180, 180)
        c.Font = Enum.Font.SourceSans
        c.TextSize = 12
        c.TextWrapped = true
        c.TextXAlignment = Enum.TextXAlignment.Left
        c.Parent = f
        return f
    end

    function Tab:AddLabel(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.92, 0, 0, 28)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = TEXT_COLOR
        lbl.Text = text
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = ContentFrame
        return lbl
    end

    function Tab:AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Name = text
        btn.Size = UDim2.new(0.92, 0, 0, 38)
        btn.BackgroundColor3 = BTN_BG
        btn.TextColor3 = TEXT_COLOR
        btn.Text = text
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.ZIndex = 2
        btn.Parent = ContentFrame
        makeCorner(btn, 6)
        makeStroke(btn)
        if callback then btn.MouseButton1Click:Connect(function() pcall(callback) end) end
        return btn
    end

    function Tab:AddToggle(text, default, callback, flag)
        local state = default or false
        local btn = Instance.new("TextButton")
        btn.Name = text
        btn.Size = UDim2.new(0.92, 0, 0, 38)
        btn.BackgroundColor3 = BTN_BG
        btn.TextColor3 = state and COLOR_ON or COLOR_OFF
        btn.Text = text.." : "..(state and "ON" or "OFF")
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.ZIndex = 2
        btn.Parent = ContentFrame
        makeCorner(btn, 6)
        makeStroke(btn)
        if flag then Library.Flags[flag] = state end
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.TextColor3 = state and COLOR_ON or COLOR_OFF
            btn.Text = text.." : "..(state and "ON" or "OFF")
            if flag then Library.Flags[flag] = state end
            if callback then pcall(callback, state) end
        end)
        return btn
    end

    function Tab:AddSlider(text, min, max, default, callback, flag)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.92, 0, 0, 45)
        f.BackgroundColor3 = BTN_BG
        f.BorderSizePixel = 0
        f.Parent = ContentFrame
        makeCorner(f, 6)
        makeStroke(f)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -10, 0, 20)
        l.Position = UDim2.new(0, 10, 0, 2)
        l.BackgroundTransparency = 1
        l.Text = text.." : "..default
        l.TextColor3 = TEXT_COLOR
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -20, 0, 6)
        bar.Position = UDim2.new(0, 10, 0, 28)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        bar.BorderSizePixel = 0
        bar.Parent = f
        makeCorner(bar, 3)
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = COLOR_ON
        fill.BorderSizePixel = 0
        fill.Parent = bar
        makeCorner(fill, 3)
        if flag then Library.Flags[flag] = default end
        local dragging = false
        bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + pct * (max - min))
                fill.Size = UDim2.new(pct, 0, 1, 0)
                l.Text = text.." : "..val
                if flag then Library.Flags[flag] = val end
                if callback then pcall(callback, val) end
            end
        end)
        return f
    end

    function Tab:AddDropdown(text, list, default, callback, flag)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.92, 0, 0, 38)
        f.BackgroundColor3 = BTN_BG
        f.BorderSizePixel = 0
        f.ClipsDescendants = false
        f.ZIndex = 5
        f.Parent = ContentFrame
        makeCorner(f, 6)
        makeStroke(f)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 1, 0)
        b.BackgroundTransparency = 1
        b.Text = text.." : "..(default or list[1])
        b.TextColor3 = TEXT_COLOR
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 13
        b.ZIndex = 5
        b.Parent = f
        local drop = Instance.new("Frame")
        drop.Size = UDim2.new(1, 0, 0, #list * 28)
        drop.Position = UDim2.new(0, 0, 1, 5)
        drop.BackgroundColor3 = BG_TITLE
        drop.BorderSizePixel = 0
        drop.Visible = false
        drop.ZIndex = 10
        drop.Parent = f
        makeCorner(drop, 6)
        makeStroke(drop)
        local dl = Instance.new("UIListLayout")
        dl.Parent = drop
        if flag then Library.Flags[flag] = default or list[1] end
        for _, v in ipairs(list) do
            local opt = Instance.new("TextButton")
            opt.Size = UDim2.new(1, 0, 0, 28)
            opt.BackgroundColor3 = BTN_BG
            opt.Text = v
            opt.TextColor3 = TEXT_COLOR
            opt.Font = Enum.Font.SourceSans
            opt.TextSize = 12
            opt.ZIndex = 10
            opt.BorderSizePixel = 0
            opt.Parent = drop
            opt.MouseButton1Click:Connect(function()
                b.Text = text.." : "..v
                drop.Visible = false
                f.Size = UDim2.new(0.92, 0, 0, 38)
                if flag then Library.Flags[flag] = v end
                if callback then pcall(callback, v) end
            end)
        end
        b.MouseButton1Click:Connect(function()
            drop.Visible = not drop.Visible
            f.Size = drop.Visible and UDim2.new(0.92, 0, 0, 38 + 5 + drop.Size.Y.Offset) or UDim2.new(0.92, 0, 0, 38)
        end)
        return f
    end

    function Tab:AddTextbox(placeholder, defaultText, callback, flag)
        local tb = Instance.new("TextBox")
        tb.Name = "Textbox"
        tb.Size = UDim2.new(0.92, 0, 0, 32)
        tb.BackgroundColor3 = BG_TITLE
        tb.TextColor3 = TEXT_COLOR
        tb.PlaceholderText = placeholder or ""
        tb.PlaceholderColor3 = Color3.fromRGB(130, 130, 135)
        tb.Text = defaultText or ""
        tb.Font = Enum.Font.SourceSans
        tb.TextSize = 14
        tb.BorderSizePixel = 0
        tb.ZIndex = 2
        tb.Parent = ContentFrame
        makeCorner(tb, 6)
        makeStroke(tb)
        if flag then Library.Flags[flag] = defaultText end
        tb:GetPropertyChangedSignal("Text"):Connect(function()
            if flag then Library.Flags[flag] = tb.Text end
            if callback then pcall(callback, tb.Text) end
        end)
        return tb
    end

    function Tab:AddColorPicker(text, default, callback, flag)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.92, 0, 0, 38)
        b.BackgroundColor3 = BTN_BG
        b.Text = text
        b.TextColor3 = TEXT_COLOR
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.Parent = ContentFrame
        makeCorner(b, 6)
        makeStroke(b)
        local preview = Instance.new("Frame")
        preview.Size = UDim2.new(0, 20, 0, 20)
        preview.Position = UDim2.new(1, -30, 0, 9)
        preview.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
        preview.BorderSizePixel = 0
        preview.Parent = b
        makeCorner(preview, 4)
        if flag then Library.Flags[flag] = default end
        b.MouseButton1Click:Connect(function()
            local c = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
            preview.BackgroundColor3 = c
            if flag then Library.Flags[flag] = c end
            if callback then pcall(callback, c) end
        end)
        return b
    end

    function Tab:AddKeybind(text, default, callback, flag)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.92, 0, 0, 38)
        b.BackgroundColor3 = BTN_BG
        b.Text = text.." : "..(default and default.Name or "None")
        b.TextColor3 = TEXT_COLOR
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        b.Parent = ContentFrame
        makeCorner(b, 6)
        makeStroke(b)
        local listening = false
        b.MouseButton1Click:Connect(function()
            listening = true
            b.Text = text.." : ..."
        end)
        UserInputService.InputBegan:Connect(function(input, gp)
            if listening and not gp then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    b.Text = text.." : "..input.KeyCode.Name
                    if flag then Library.Flags[flag] = input.KeyCode end
                    if callback then pcall(callback, input.KeyCode) end
                end
            end
        end)
        return b
    end

    TabButton.MouseButton1Click:Connect(function()
        if Library.CurrentTab == Tab then
            TabButton.BackgroundColor3 = TAB_INACTIVE
            ContentFrame.Visible = false
            Library.CurrentTab = nil
        else
            for _, t in pairs(Library.Tabs) do
                t.Button.BackgroundColor3 = TAB_INACTIVE
                t.Content.Visible = false
            end
            TabButton.BackgroundColor3 = TAB_ACTIVE
            ContentFrame.Visible = true
            Library.CurrentTab = Tab
        end
    end)

    table.insert(Library.Tabs, Tab)
    return Tab
end

local setTimeEnabled = false
local autoTapEnabled = false
local visibleEnabled = false
local xrayEnabled = false
local autoTapRadius = 15
local originalHoldTimes = {}
local originalVisibilities = {}
local originalLOS = {}

local MainTab = Library:AddTab("Main")
local ESPTab = Library:AddTab("ESP")

MainTab.Button.BackgroundColor3 = TAB_ACTIVE
MainTab.Content.Visible = true
Library.CurrentTab = MainTab

MainTab:AddSection("ProximityPrompt")
MainTab:AddToggle("Set Time", false, function(v) setTimeEnabled = v end, "SetTime")
MainTab:AddToggle("Auto Tap", false, function(v) autoTapEnabled = v end, "AutoTap")
MainTab:AddSlider("Radius", 5, 50, 15, function(v) autoTapRadius = v end, "Radius")
MainTab:AddToggle("Visible", false, function(v) visibleEnabled = v end, "Visible")
MainTab:AddToggle("Prompt X-ray", false, function(v) xrayEnabled = v end, "Xray")
MainTab:AddDivider()
MainTab:AddParagraph("Info", "Classic design + viral features. Size default 340x310")

ESPTab:AddSection("ESP Menu")
ESPTab:AddParagraph("ESP", "Tambah tab ESP otomatis muncul disini")
ESPTab:AddToggle("ESP Player", false, function(v) Library:Notify("ESP", "ESP Player "..(v and "ON" or "OFF"), 2) end)
ESPTab:AddDropdown("ESP Mode", {"Box", "Chams", "Name"}, "Box", function(v) end)
ESPTab:AddColorPicker("ESP Color", Color3.fromRGB(255,0,0), function(c) end)
ESPTab:AddKeybind("ESP Key", Enum.KeyCode.E, function(k) end)
ESPTab:AddButton("Add ESP Feature", function() Library:Notify("ESP", "Added!", 2) end)

local SettingsTab = Library:AddTab("Settings")
SettingsTab:AddSection("Config")
SettingsTab:AddButton("Notify Test", function() Library:Notify("Sukses", "Fitur aktif!", 3) end)
SettingsTab:AddTextbox("Custom Text", "", function(v) print(v) end)
local sf = SettingsTab:CreateScrollingFrame(UDim2.new(0.92, 0, 0, 80))
local lb = Instance.new("TextLabel")
lb.Size = UDim2.new(1, 0, 0, 20)
lb.BackgroundTransparency = 1
lb.Text = "ScrollingFrame bisa dipanggil"
lb.TextColor3 = TEXT_COLOR
lb.Font = Enum.Font.SourceSansBold
lb.TextSize = 12
lb.Parent = sf

task.spawn(function()
    while task.wait(0.3) do
        if setTimeEnabled then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    if not originalHoldTimes[prompt] then originalHoldTimes[prompt] = prompt.HoldDuration end
                    prompt.HoldDuration = 0
                end
            end
        else
            for prompt, originalTime in pairs(originalHoldTimes) do
                if prompt and prompt.Parent then prompt.HoldDuration = originalTime end
            end
            table.clear(originalHoldTimes)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if autoTapEnabled and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local myPos = root.Position
                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local parent = prompt.Parent
                        if parent and parent:IsA("BasePart") then
                            if (myPos - parent.Position).Magnitude <= autoTapRadius then
                                if fireproximityprompt then
                                    fireproximityprompt(prompt)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait(0.02)
                                    prompt:InputHoldEnd()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.4) do
        if visibleEnabled then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    if originalVisibilities[prompt] == nil then originalVisibilities[prompt] = prompt.Enabled end
                    prompt.Enabled = true
                end
            end
        else
            for prompt, originalState in pairs(originalVisibilities) do
                if prompt and prompt.Parent then prompt.Enabled = originalState end
            end
            table.clear(originalVisibilities)
        end
    end
end)

task.spawn(function()
    while task.wait(0.4) do
        if xrayEnabled then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    if originalLOS[prompt] == nil then originalLOS[prompt] = prompt.RequiresLineOfSight end
                    prompt.RequiresLineOfSight = false
                end
            end
        else
            for prompt, originalState in pairs(originalLOS) do
                if prompt and prompt.Parent then prompt.RequiresLineOfSight = originalState end
            end
            table.clear(originalLOS)
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if isMinimized then
        local hideTween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0, 45)})
        hideTween:Play()
        ToggleButton.BackgroundColor3 = COLOR_OFF
        hideTween.Completed:Connect(function()
            if isMinimized then MainFrame.Visible = false MasterFrame.Size = UDim2.new(0, 340, 0, 45) end
        end)
    else
        MasterFrame.Size = normalSize
        MainFrame.Visible = true
        local showTween = TweenService:Create(MainFrame, tweenInfo, {Size = normalMainSize, Position = UDim2.new(0, 0, 0, 45)})
        showTween:Play()
        ToggleButton.BackgroundColor3 = COLOR_ON
    end
end)

local dragToggle = false
local dragStart, startPos
TitleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MasterFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MasterFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
end)

return Library
