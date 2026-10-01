local Game = game.PlaceId

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ThemePresets = {
    Emerald = {
        Primary = Color3.fromRGB(232, 234, 238),
        PrimaryHover = Color3.fromRGB(255, 255, 255),
        PrimaryGlow = Color3.fromRGB(210, 214, 220),
        Secondary = Color3.fromRGB(145, 149, 156),
        Accent = Color3.fromRGB(205, 208, 214),
        BorderGlow = Color3.fromRGB(170, 174, 182),
        Glow = Color3.fromRGB(255, 255, 255),
    },
    Neon = {
        Primary = Color3.fromRGB(232, 234, 238),
        PrimaryHover = Color3.fromRGB(255, 255, 255),
        PrimaryGlow = Color3.fromRGB(210, 214, 220),
        Secondary = Color3.fromRGB(145, 149, 156),
        Accent = Color3.fromRGB(205, 208, 214),
        BorderGlow = Color3.fromRGB(170, 174, 182),
        Glow = Color3.fromRGB(255, 255, 255),
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(232, 234, 238),
        PrimaryHover = Color3.fromRGB(255, 255, 255),
        PrimaryGlow = Color3.fromRGB(210, 214, 220),
        Secondary = Color3.fromRGB(145, 149, 156),
        Accent = Color3.fromRGB(205, 208, 214),
        BorderGlow = Color3.fromRGB(170, 174, 182),
        Glow = Color3.fromRGB(255, 255, 255),
    },
    Ocean = {
        Primary = Color3.fromRGB(232, 234, 238),
        PrimaryHover = Color3.fromRGB(255, 255, 255),
        PrimaryGlow = Color3.fromRGB(210, 214, 220),
        Secondary = Color3.fromRGB(145, 149, 156),
        Accent = Color3.fromRGB(205, 208, 214),
        BorderGlow = Color3.fromRGB(170, 174, 182),
        Glow = Color3.fromRGB(255, 255, 255),
    },
    Crimson = {
        Primary = Color3.fromRGB(232, 234, 238),
        PrimaryHover = Color3.fromRGB(255, 255, 255),
        PrimaryGlow = Color3.fromRGB(210, 214, 220),
        Secondary = Color3.fromRGB(145, 149, 156),
        Accent = Color3.fromRGB(205, 208, 214),
        BorderGlow = Color3.fromRGB(170, 174, 182),
        Glow = Color3.fromRGB(255, 255, 255),
    },
}

local Theme = {
    Primary = Color3.fromRGB(255, 255, 255),
    PrimaryHover = Color3.fromRGB(242, 242, 242),
    PrimaryGlow = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(42, 42, 45),
    SecondaryHover = Color3.fromRGB(52, 52, 56),
    SecondaryGlow = Color3.fromRGB(70, 70, 74),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentHover = Color3.fromRGB(238, 238, 238),
    AccentGlow = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(72, 180, 110),
    Warning = Color3.fromRGB(210, 160, 60),
    Error = Color3.fromRGB(215, 80, 80),
    Info = Color3.fromRGB(150, 160, 175),
    Background = Color3.fromRGB(3, 3, 3),
    BackgroundBlur = Color3.fromRGB(7, 7, 7),
    Surface = Color3.fromRGB(17, 17, 17),
    SurfaceElevated = Color3.fromRGB(24, 24, 24),
    SurfaceHover = Color3.fromRGB(31, 31, 31),
    Card = Color3.fromRGB(21, 21, 21),
    CardElevated = Color3.fromRGB(28, 28, 28),
    CardHover = Color3.fromRGB(35, 35, 35),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(214, 214, 214),
    TextMuted = Color3.fromRGB(150, 150, 150),
    TextDisabled = Color3.fromRGB(92, 92, 92),
    Border = Color3.fromRGB(38, 38, 38),
    BorderLight = Color3.fromRGB(28, 28, 28),
    BorderGlow = Color3.fromRGB(255, 255, 255),
    BorderHover = Color3.fromRGB(78, 78, 78),
    KeybindGrey = Color3.fromRGB(39, 39, 39),
    GlassMain = 0.02,
    GlassSecondary = 0.04,
    GlassLight = 0.08,
    GlowStrength = 0.04,
    Shadow = Color3.fromRGB(0, 0, 0),
    ShadowStrong = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(255, 255, 255),
}

local function GetContrastText(Color)
    local Luminance = Color.R * 0.299 + Color.G * 0.587 + Color.B * 0.114
    return Luminance > 0.62 and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 255, 255)
end

-- Always derive button/option text from the color that is actually visible
-- behind the text. This keeps text readable across every theme and state.
local function SetContrastText(TextObject, BackgroundColor)
    if TextObject and TextObject.Parent and BackgroundColor then
        TextObject.TextColor3 = GetContrastText(BackgroundColor)
    end
end

Theme.PrimaryText = GetContrastText(Theme.Primary)

local ThemeColorRegistry = {}
local ThemeGradientRegistry = {}

local function RegisterColor(Object, Property, ThemeKey)
    if not Object or not Property or not ThemeKey then return end
    table.insert(ThemeColorRegistry, {Object = Object, Property = Property, ThemeKey = ThemeKey})
end

local function RegisterGradient(Gradient, BuildFn)
    if not Gradient or not BuildFn then return end
    table.insert(ThemeGradientRegistry, {Gradient = Gradient, BuildFn = BuildFn})
end

local Animations = {
    Lightning = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    UltraFast = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.34, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    FadeIn = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    FadeOut = TweenInfo.new(0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
    Smooth = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    Sharp = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    Breathe = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    GlowPulse = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    SlideIn = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
}

local ScalingManager = {
    BaseResolution = Vector2.new(1920, 1080),
    CurrentScale = 1,
    MinScale = 0.4,
    MaxScale = 2.5,
    AdaptiveMode = true
}

function ScalingManager:CalculateScale()
    local Camera = workspace.CurrentCamera
    if not Camera then return 1 end
    local Viewport = Camera.ViewportSize
    local ScaleX = Viewport.X / self.BaseResolution.X
    local ScaleY = Viewport.Y / self.BaseResolution.Y
    local Scale = math.sqrt(ScaleX * ScaleY)
    if Viewport.X < 768 then Scale = Scale * 1.2
    elseif Viewport.X < 1366 then Scale = Scale * 1.1 end
    Scale = math.clamp(Scale, self.MinScale, self.MaxScale)
    self.CurrentScale = Scale
    return Scale
end

function ScalingManager:GetScaledValue(Value)
    return Value * self.CurrentScale
end

local TouchManager = {
    IsTouchDevice = UserInputService.TouchEnabled,
    IsDragging = false,
    DragObject = nil,
}

function TouchManager:EnableDrag(Frame, DragHandle)
    local Handle = DragHandle or Frame
    local Dragging = false
    local DragStartPos, StartPosition
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStartPos = Input.Position
            StartPosition = Frame.Position
            self.IsDragging = true
        end
    end)
    local function UpdateDrag(Input)
        if Dragging and DragStartPos then
            local Delta = Input.Position - DragStartPos
            Frame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end
    Handle.InputChanged:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then UpdateDrag(I) end end)
    UserInputService.InputChanged:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then UpdateDrag(I) end end)
    local function EndDrag() Dragging = false DragStartPos = nil StartPosition = nil self.IsDragging = false end
    Handle.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then EndDrag() end end)
    UserInputService.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then EndDrag() end end)
end

local KeybindManager = {
    Bindings = {}, ToggleBindings = {}, ToggleStates = {},
    Listening = false, CurrentCallback = nil, ListeningFrame = nil,
    ListeningConnections = {}, ActiveListeners = {}
}

function KeybindManager:Bind(KeyCode, Callback)
    if self.Bindings[KeyCode] then self.Bindings[KeyCode]:Disconnect() end
    self.Bindings[KeyCode] = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == KeyCode then
            local Ok, Err = pcall(Callback)
            if not Ok then warn("Keybind error:", Err) end
        end
    end)
end

function KeybindManager:StartListening(Callback, Frame)
    if self.Listening then self:StopListening() end
    self.Listening = true
    self.CurrentCallback = Callback
    self.ListeningFrame = Frame
    if Frame then Frame.Text = "Press any key..." Frame.TextColor3 = Theme.Primary end
    self:ClearConnections()
    local KeyConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.UserInputType == Enum.UserInputType.Keyboard then
            self:FinishListening(Input.KeyCode)
        end
    end)
    local MouseConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed then
            local T = Input.UserInputType
            if T == Enum.UserInputType.MouseButton1 or T == Enum.UserInputType.MouseButton2 or T == Enum.UserInputType.MouseButton3 then
                self:FinishListening(T)
            end
        end
    end)
    table.insert(self.ListeningConnections, KeyConn)
    table.insert(self.ListeningConnections, MouseConn)
end

function KeybindManager:FinishListening(InputCode)
    self.Listening = false
    self:ClearConnections()
    if self.ListeningFrame then
        if InputCode then
            self.ListeningFrame.Text = tostring(InputCode):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
        else
            self.ListeningFrame.Text = "None"
        end
        self.ListeningFrame.TextColor3 = Theme.TextPrimary
    end
    if self.CurrentCallback and InputCode then
        local Ok, Err = pcall(self.CurrentCallback, InputCode)
        if not Ok then warn("Keybind listener error:", Err) end
    end
    self:Cleanup()
end

function KeybindManager:StopListening()
    self.Listening = false
    self:ClearConnections()
    if self.ListeningFrame then self.ListeningFrame.Text = "None" self.ListeningFrame.TextColor3 = Theme.TextMuted end
    self:Cleanup()
end

function KeybindManager:ClearConnections()
    for _, C in pairs(self.ListeningConnections) do if C and C.Connected then C:Disconnect() end end
    self.ListeningConnections = {}
end

function KeybindManager:Cleanup()
    self.CurrentCallback = nil
    self.ListeningFrame = nil
end

function KeybindManager:Unbind(KeyCode)
    if self.Bindings[KeyCode] then self.Bindings[KeyCode]:Disconnect() self.Bindings[KeyCode] = nil end
    if self.ToggleBindings[KeyCode] then self.ToggleBindings[KeyCode]:Disconnect() self.ToggleBindings[KeyCode] = nil end
end

function KeybindManager:UnbindAll()
    for _, C in pairs(self.Bindings) do C:Disconnect() end
    for _, C in pairs(self.ToggleBindings) do C:Disconnect() end
    self.Bindings = {} self.ToggleBindings = {} self.ToggleStates = {}
    self:StopListening()
end

local DropdownManager = { OpenDropdown = nil, AllDropdowns = {} }
function DropdownManager:Register(D) table.insert(self.AllDropdowns, D) end
function DropdownManager:CloseAll()
    for _, D in pairs(self.AllDropdowns) do if D and D.Close then D.Close() end end
    self.OpenDropdown = nil
end

local ActiveNotifications = {}

local function CreateTween(Object, Info, Props)
    return TweenService:Create(Object, Info, Props)
end

local function AddCorner(Frame, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius or ScalingManager:GetScaledValue(12))
    C.Parent = Frame
    return C
end

local function AddStroke(Frame, Thickness, Color, Transparency)
    local S = Instance.new("UIStroke")
    S.Thickness = Thickness or 1
    S.Color = Color or Theme.Border
    S.Transparency = Transparency or 0
    S.Parent = Frame
    return S
end

local function AddGradient(Frame, CS, Rotation, Transparency)
    local G = Instance.new("UIGradient")
    G.Color = CS
    G.Rotation = Rotation or 90
    if Transparency then G.Transparency = Transparency end
    G.Parent = Frame
    return G
end

local function CreateRipple(Frame, Position)
    local Ripple = Instance.new("Frame")
    Ripple.Name = "RippleEffect"
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0, Position.X, 0, Position.Y)
    Ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    Ripple.BackgroundTransparency = 0.78
    Ripple.BorderSizePixel = 0
    Ripple.ZIndex = Frame.ZIndex + 10
    Ripple.Parent = Frame
    AddCorner(Ripple, 1000)
    local MaxSize = math.max(Frame.AbsoluteSize.X, Frame.AbsoluteSize.Y) * 2.5
    local T = CreateTween(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, MaxSize, 0, MaxSize),
        Position = UDim2.new(0, Position.X - MaxSize / 2, 0, Position.Y - MaxSize / 2),
        BackgroundTransparency = 1
    })
    T:Play()
    T.Completed:Connect(function() Ripple:Destroy() end)
    return Ripple
end

local function AddHoverEffect(Frame, HoverColor, NormalColor)
    local NormalBg = NormalColor or Frame.BackgroundColor3
    local HoverBg = HoverColor or Theme.SurfaceHover
    Frame.MouseEnter:Connect(function() CreateTween(Frame, Animations.Fast, {BackgroundColor3 = HoverBg}):Play() end)
    Frame.MouseLeave:Connect(function() CreateTween(Frame, Animations.Fast, {BackgroundColor3 = NormalBg}):Play() end)
end

local function AddSubtleGlow(Stroke, BaseColor)
    local DimColor = BaseColor:lerp(Color3.fromRGB(30, 40, 35), 0.35)
    CreateTween(Stroke, Animations.GlowPulse, {Color = BaseColor, Transparency = 0.08}):Play()
    task.delay(Animations.GlowPulse.Time, function()
        if Stroke and Stroke.Parent then
            CreateTween(Stroke, Animations.GlowPulse, {Color = DimColor, Transparency = 0.45}):Play()
        end
    end)
end

local function StaggerIn(Elements, Delay)
    Delay = Delay or 0.055
    for I, El in ipairs(Elements) do
        if El and El.Parent then
            El.BackgroundTransparency = 1
        end
        task.delay(I * Delay, function()
            if El and El.Parent then
                CreateTween(El, Animations.Spring, {BackgroundTransparency = 0.25}):Play()
            end
        end)
    end
end

local function TypewriterEffect(Label, Text, Speed)
    Speed = Speed or 0.04
    Label.Text = ""
    for I = 1, #Text do
        task.delay(I * Speed, function()
            if Label and Label.Parent then
                Label.Text = string.sub(Text, 1, I)
            end
        end)
    end
end

local function SerializeValue(V, Seen)
    local ValueType = typeof(V)
    if ValueType == "Color3" then
        return {__type = "Color3", R = V.R, G = V.G, B = V.B}
    end
    if ValueType == "EnumItem" then
        return {__type = "EnumItem", EnumType = tostring(V.EnumType), Name = V.Name}
    end
    if ValueType == "Vector2" then
        return {__type = "Vector2", X = V.X, Y = V.Y}
    end
    if ValueType == "Vector3" then
        return {__type = "Vector3", X = V.X, Y = V.Y, Z = V.Z}
    end
    if ValueType == "UDim" then
        return {__type = "UDim", Scale = V.Scale, Offset = V.Offset}
    end
    if ValueType == "UDim2" then
        return {__type = "UDim2", XScale = V.X.Scale, XOffset = V.X.Offset, YScale = V.Y.Scale, YOffset = V.Y.Offset}
    end
    if ValueType == "NumberRange" then
        return {__type = "NumberRange", Min = V.Min, Max = V.Max}
    end
    if ValueType == "Rect" then
        return {__type = "Rect", MinX = V.Min.X, MinY = V.Min.Y, MaxX = V.Max.X, MaxY = V.Max.Y}
    end
    if ValueType == "CFrame" then
        local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = V:GetComponents()
        return {__type = "CFrame", Components = {X,Y,Z,R00,R01,R02,R10,R11,R12,R20,R21,R22}}
    end
    if ValueType == "BrickColor" then
        return {__type = "BrickColor", Number = V.Number}
    end
    if type(V) == "table" then
        Seen = Seen or {}
        if Seen[V] then return nil end
        Seen[V] = true
        local T = {}
        for K, Item in pairs(V) do
            local SK = type(K) == "number" and tostring(K) or tostring(K)
            local SV = SerializeValue(Item, Seen)
            if SV ~= nil then T[SK] = SV end
        end
        Seen[V] = nil
        return {__type = "Table", Data = T}
    end
    if ValueType == "Instance" or ValueType == "userdata" or ValueType == "function" or ValueType == "thread" then
        return nil
    end
    return V
end

local function DeserializeValue(V)
    if type(V) == "table" and V.__type == "Color3" then
        return Color3.new(tonumber(V.R) or 1, tonumber(V.G) or 1, tonumber(V.B) or 1)
    end
    if type(V) == "table" and V.__type == "EnumItem" then
        local EnumTypeName = tostring(V.EnumType):gsub("Enum%.", "")
        local EnumTable = Enum[EnumTypeName]
        if EnumTable and EnumTable[V.Name] then return EnumTable[V.Name] end
        return nil
    end
    if type(V) == "table" and V.__type == "Vector2" then
        return Vector2.new(tonumber(V.X) or 0, tonumber(V.Y) or 0)
    end
    if type(V) == "table" and V.__type == "Vector3" then
        return Vector3.new(tonumber(V.X) or 0, tonumber(V.Y) or 0, tonumber(V.Z) or 0)
    end
    if type(V) == "table" and V.__type == "UDim" then
        return UDim.new(tonumber(V.Scale) or 0, tonumber(V.Offset) or 0)
    end
    if type(V) == "table" and V.__type == "UDim2" then
        return UDim2.new(tonumber(V.XScale) or 0, tonumber(V.XOffset) or 0, tonumber(V.YScale) or 0, tonumber(V.YOffset) or 0)
    end
    if type(V) == "table" and V.__type == "NumberRange" then
        return NumberRange.new(tonumber(V.Min) or 0, tonumber(V.Max) or tonumber(V.Min) or 0)
    end
    if type(V) == "table" and V.__type == "Rect" then
        return Rect.new(tonumber(V.MinX) or 0, tonumber(V.MinY) or 0, tonumber(V.MaxX) or 0, tonumber(V.MaxY) or 0)
    end
    if type(V) == "table" and V.__type == "CFrame" and type(V.Components) == "table" and #V.Components >= 12 then
        return CFrame.new(table.unpack(V.Components, 1, 12))
    end
    if type(V) == "table" and V.__type == "BrickColor" then
        return BrickColor.new(tonumber(V.Number) or 1)
    end
    if type(V) == "table" and V.__type == "Table" and type(V.Data) == "table" then
        local T = {}
        for K, Item in pairs(V.Data) do
            local N = tonumber(K)
            local Key = N and tostring(N) == K and N or K
            T[Key] = DeserializeValue(Item)
        end
        return T
    end
    if type(V) == "table" then
        local T = {}
        for K, Item in pairs(V) do T[K] = DeserializeValue(Item) end
        return T
    end
    return V
end

local TerminScriptsLib = {}
TerminScriptsLib.__index = TerminScriptsLib

function TerminScriptsLib.new(Title, Config)
    local Self = setmetatable({}, TerminScriptsLib)
    Config = Config or {}
    Self.Title = Title or "Termin Scripts V3"
    Self.GlowEffects = Config.GlowEffects ~= false
    Self.Animations = Config.Animations ~= false
    Self.KeybindToggle = Config.KeybindToggle or Enum.KeyCode.RightControl
    Self.CurrentThemeName = "Neon"
    ScalingManager:CalculateScale()
    Self.Tabs = {}
    Self.CurrentTab = nil
    Self.IsVisible = true
    Self.IsMinimized = false
    Self.IsMaximized = false
    Self.OriginalSize = nil
    Self.OriginalPosition = nil
    Self.StructuralRefs = {}
    Self.ConfigRegistry = {}
    Self.ConfigFolderName = Config.ConfigFolderName or "TerminConfigs"
    Self.CurrentConfigName = Config.DefaultConfigName or ""
    Self.AutoSaveEnabled = Config.AutoSaveEnabled == true
    Self.IsLoadingConfig = false
    Self.AutoLoadConfigEnabled = Config.AutoLoadConfig == true
    Self.AutoLoadConfigName = Config.AutoLoadConfigName or ""
    Self.ConfigLoadMethod = Config.ConfigLoadMethod or "Merge"
    Self.AutoLoadDelay = tonumber(Config.AutoLoadDelay) or 0.75
    Self._AutoLoadScheduled = false
    Self._AutoLoadAttempted = false
    Self._AutoLoadGeneration = 0
    Self._AutoKeyCounter = 0
    Self:CreateMainGui()
    Self:SetupControls()
    Self:SetupDragging()
    Self:SetupKeybinds()
    Self:SetupScaling()
    Self:PlayEntranceAnimation()
    return Self
end

function TerminScriptsLib:PlayEntranceAnimation()
    local Frame = self.MainFrame
    if not Frame or not Frame.Parent then return end
    local OrigPos = self.OriginalPosition or Frame.Position
    Frame.Position = UDim2.new(OrigPos.X.Scale, OrigPos.X.Offset, OrigPos.Y.Scale, OrigPos.Y.Offset + 10 * ScalingManager.CurrentScale)
    Frame.BackgroundTransparency = 0.12
    CreateTween(Frame, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = OrigPos,
        BackgroundTransparency = Theme.GlassMain
    }):Play()
end

function TerminScriptsLib:CreateMainGui()
    local Scale = ScalingManager.CurrentScale
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "TerminScriptsV3"
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true

    local Width, Height = 980 * Scale, 720 * Scale
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainContainer"
    self.MainFrame.Size = UDim2.new(0, Width, 0, Height)
    self.MainFrame.Position = UDim2.new(0.5, -Width / 2, 0.5, -Height / 2)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BackgroundTransparency = Theme.GlassMain
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position

    AddCorner(self.MainFrame, 18 * Scale)
    local MainStroke = AddStroke(self.MainFrame, 1.5 * Scale, Theme.BorderGlow, 0.3)
    self.StructuralRefs.MainStroke = MainStroke
    RegisterColor(MainStroke, "Color", "BorderGlow")

    local Bg = AddGradient(self.MainFrame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Background),
        ColorSequenceKeypoint.new(0.6, Theme.Surface),
        ColorSequenceKeypoint.new(1, Theme.Background)
    }, 135)
    self.StructuralRefs.BgGradient = Bg
    RegisterGradient(Bg, function()
        return ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Background),
            ColorSequenceKeypoint.new(0.6, Theme.Surface),
            ColorSequenceKeypoint.new(1, Theme.Background)
        }
    end)

    self:CreateHeader()
    self:CreateContentArea()
end

function TerminScriptsLib:CreateHeader()
    local Scale = ScalingManager.CurrentScale
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 78 * Scale)
    self.Header.BackgroundColor3 = Theme.Surface
    self.Header.BackgroundTransparency = 0.05
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame
    AddCorner(self.Header, 18 * Scale)

    local HeaderBottomLine = Instance.new("Frame")
    HeaderBottomLine.Size = UDim2.new(1, -40 * Scale, 0, 1 * Scale)
    HeaderBottomLine.Position = UDim2.new(0, 20 * Scale, 1, -1)
    HeaderBottomLine.BackgroundColor3 = Theme.Primary
    HeaderBottomLine.BackgroundTransparency = 0.55
    HeaderBottomLine.BorderSizePixel = 0
    HeaderBottomLine.Parent = self.Header
    RegisterColor(HeaderBottomLine, "BackgroundColor3", "Primary")

    local HeaderGrad = AddGradient(self.Header, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Surface),
        ColorSequenceKeypoint.new(1, Theme.Surface)
    }, 0, NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
    self.StructuralRefs.HeaderGrad = HeaderGrad
    RegisterGradient(HeaderGrad, function()
        return ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Surface),
            ColorSequenceKeypoint.new(1, Theme.Surface)
        }
    end)

    local AvatarContainer = Instance.new("Frame")
    AvatarContainer.Size = UDim2.new(0, 62 * Scale, 0, 62 * Scale)
    AvatarContainer.Position = UDim2.new(0, 20 * Scale, 0.5, -31 * Scale)
    AvatarContainer.BackgroundColor3 = Theme.Card
    AvatarContainer.BackgroundTransparency = 0.08
    AvatarContainer.BorderSizePixel = 0
    AvatarContainer.Parent = self.Header
    AddCorner(AvatarContainer, 16 * Scale)
    local AvStroke = AddStroke(AvatarContainer, 1.5 * Scale, Theme.Primary, 0.28)
    RegisterColor(AvStroke, "Color", "Primary")

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(1, -6 * Scale, 1, -6 * Scale)
    Avatar.Position = UDim2.new(0, 3 * Scale, 0, 3 * Scale)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
    Avatar.Parent = AvatarContainer
    AddCorner(Avatar, 14 * Scale)

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(1, -300 * Scale, 1, 0)
    TitleContainer.Position = UDim2.new(0, 96 * Scale, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.Header
    TouchManager:EnableDrag(self.MainFrame, TitleContainer)

    local TitleLayout = Instance.new("UIListLayout")
    TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TitleLayout.Padding = UDim.new(0, 3 * Scale)
    TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TitleLayout.Parent = TitleContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 30 * Scale)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Theme.TextPrimary
    self.TitleLabel.TextSize = 24 * Scale
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.LayoutOrder = 1
    self.TitleLabel.Parent = TitleContainer

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(1, 0, 0, 17 * Scale)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "V5"
    VersionLabel.TextColor3 = Theme.TextSecondary
    VersionLabel.TextSize = 12 * Scale
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.LayoutOrder = 2
    VersionLabel.Parent = TitleContainer

    local StatusRow = Instance.new("Frame")
    StatusRow.Size = UDim2.new(1, 0, 0, 14 * Scale)
    StatusRow.BackgroundTransparency = 1
    StatusRow.LayoutOrder = 3
    StatusRow.Parent = TitleContainer

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 7 * Scale, 0, 7 * Scale)
    StatusDot.Position = UDim2.new(0, 0, 0.5, -3.5 * Scale)
    StatusDot.BackgroundColor3 = Theme.Success
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusRow
    AddCorner(StatusDot, 4 * Scale)
    CreateTween(StatusDot, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.5}):Play()
    RegisterColor(StatusDot, "BackgroundColor3", "Primary")

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -12 * Scale, 1, 0)
    StatusText.Position = UDim2.new(0, 12 * Scale, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Online  â  " .. Player.Name
    StatusText.TextColor3 = Theme.TextMuted
    StatusText.TextSize = 11 * Scale
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusRow

    self:CreateControlButtons()
end

function TerminScriptsLib:CreateControlButtons()
    local Scale = ScalingManager.CurrentScale
    local BtnSize = 28 * Scale
    local Gap = 8 * Scale
    self.CloseBtn = self:CreateControlButton("x", Theme.Error, UDim2.new(1, -(BtnSize + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
    self.MaximizeBtn = self:CreateControlButton("+", Theme.Info, UDim2.new(1, -(BtnSize * 2 + Gap + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
    self.MinimizeBtn = self:CreateControlButton("-", Theme.Warning, UDim2.new(1, -(BtnSize * 3 + Gap * 2 + 18 * Scale), 0.5, -BtnSize / 2), BtnSize)
end

function TerminScriptsLib:CreateControlButton(Text, Color, Position, Size)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, Size, 0, Size)
    Btn.Position = Position
    Btn.BackgroundColor3 = Color
    Btn.BackgroundTransparency = 0.3
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.TextColor3 = GetContrastText(Color)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = Size * 0.48
    Btn.ZIndex = 10
    Btn.Parent = self.Header
    AddCorner(Btn, Size * 0.5)
    AddStroke(Btn, 1, Color, 0.5)
    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Color:lerp(Color3.new(1,1,1), 0.18),
            BackgroundTransparency = 0.05,
            Size = UDim2.new(0, Size * 1.1, 0, Size * 1.1)
        }):Play()
        SetContrastText(Btn, Color:lerp(Color3.new(1,1,1), 0.18))
    end)
    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Color,
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, Size, 0, Size)
        }):Play()
        SetContrastText(Btn, Color)
    end)
    Btn.MouseButton1Down:Connect(function()
        CreateRipple(Btn, Vector2.new(Size / 2, Size / 2))
        CreateTween(Btn, Animations.Lightning, {Size = UDim2.new(0, Size * 0.9, 0, Size * 0.9)}):Play()
    end)
    Btn.MouseButton1Up:Connect(function()
        CreateTween(Btn, Animations.Spring, {Size = UDim2.new(0, Size, 0, Size)}):Play()
    end)
    return Btn
end

function TerminScriptsLib:CreateContentArea()
    local Scale = ScalingManager.CurrentScale
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -32 * Scale, 1, -112 * Scale)
    self.ContentArea.Position = UDim2.new(0, 16 * Scale, 0, 92 * Scale)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame
    self:CreateTabNavigation()
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Size = UDim2.new(1, 0, 1, -66 * Scale)
    self.PageContainer.Position = UDim2.new(0, 0, 0, 62 * Scale)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.ClipsDescendants = true
    self.PageContainer.Parent = self.ContentArea
end

function TerminScriptsLib:CreateTabNavigation()
    local Scale = ScalingManager.CurrentScale
    self.TabNav = Instance.new("Frame")
    self.TabNav.Size = UDim2.new(1, 0, 0, 54 * Scale)
    self.TabNav.BackgroundColor3 = Theme.Card
    self.TabNav.BackgroundTransparency = 0.28
    self.TabNav.BorderSizePixel = 0
    self.TabNav.Parent = self.ContentArea
    AddCorner(self.TabNav, 12 * Scale)
    local NavStroke = AddStroke(self.TabNav, 1 * Scale, Theme.Border, 0.5)
    RegisterColor(NavStroke, "Color", "Primary")

    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(1, -16 * Scale, 1, -8 * Scale)
    self.TabContainer.Position = UDim2.new(0, 8 * Scale, 0, 4 * Scale)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = TouchManager.IsTouchDevice and math.max(3, math.floor(4 * Scale)) or 0
    self.TabContainer.ScrollingEnabled = TouchManager.IsTouchDevice
    self.TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabContainer.ElasticBehavior = TouchManager.IsTouchDevice and Enum.ElasticBehavior.WhenScrollable or Enum.ElasticBehavior.Never
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabContainer.Parent = self.TabNav
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8 * Scale)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Parent = self.TabContainer
    TabLayout.Changed:Connect(function()
        self.TabContainer.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 20 * Scale, 0, 0)
    end)
end

function TerminScriptsLib:CreateTab(Name, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Tab = {
        Name = Name, Config = Config, Button = nil, Page = nil,
        Sections = {}, Active = false, LayoutOrder = #self.Tabs + 1, Gui = self
    }
    local TextSize = TextService:GetTextSize(Name, 14 * Scale, Enum.Font.GothamSemibold, Vector2.new(1000, 1000))
    local BtnWidth = TextSize.X + 32 * Scale
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(0, BtnWidth, 0, 44 * Scale)
    Tab.Button.BackgroundColor3 = Theme.Surface
    Tab.Button.BackgroundTransparency = 0.5
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = ""
    Tab.Button.LayoutOrder = Tab.LayoutOrder
    Tab.Button.Parent = self.TabContainer
    AddCorner(Tab.Button, 11 * Scale)
    local BtnStroke = AddStroke(Tab.Button, 1 * Scale, Theme.Border, 0.65)

    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, -16 * Scale, 1, 0)
    TabText.Position = UDim2.new(0, 8 * Scale, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = Name
    TabText.TextColor3 = Theme.TextMuted
    TabText.TextSize = 14 * Scale
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextXAlignment = Enum.TextXAlignment.Center
    TabText.Parent = Tab.Button
    RegisterColor(TabText, "TextColor3", "PrimaryText")

    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 0, 0, 2.5 * Scale)
    ActiveBar.Position = UDim2.new(0.5, 0, 1, -2.5 * Scale)
    ActiveBar.BackgroundColor3 = Theme.Primary
    ActiveBar.BorderSizePixel = 0
    ActiveBar.AnchorPoint = Vector2.new(0.5, 0)
    ActiveBar.Parent = Tab.Button
    AddCorner(ActiveBar, 2 * Scale)
    RegisterColor(ActiveBar, "BackgroundColor3", "Primary")

    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, 0, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.BorderSizePixel = 0
    Tab.Page.ScrollBarThickness = 5 * Scale
    Tab.Page.ScrollBarImageColor3 = Theme.Primary
    Tab.Page.ScrollBarImageTransparency = 0.5
    Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Page.Visible = false
    Tab.Page.Parent = self.PageContainer
    RegisterColor(Tab.Page, "ScrollBarImageColor3", "Primary")
    local PL = Instance.new("UIListLayout")
    PL.SortOrder = Enum.SortOrder.LayoutOrder
    PL.Padding = UDim.new(0, 16 * Scale)
    PL.Parent = Tab.Page
    local PPad = Instance.new("UIPadding")
    PPad.PaddingTop = UDim.new(0, 10 * Scale)
    PPad.PaddingBottom = UDim.new(0, 16 * Scale)
    PPad.Parent = Tab.Page
    PL.Changed:Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 38 * Scale)
    end)

    Tab.Button.MouseEnter:Connect(function()
        if not Tab.Active then
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.SurfaceHover, BackgroundTransparency = 0.25}):Play()
            CreateTween(TabText, Animations.Fast, {TextColor3 = Theme.TextSecondary}):Play()
        end
    end)
    Tab.Button.MouseLeave:Connect(function()
        if not Tab.Active then
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.5}):Play()
            CreateTween(TabText, Animations.Fast, {TextColor3 = Theme.TextMuted}):Play()
        end
    end)
    Tab.Button.MouseButton1Click:Connect(function()
        CreateRipple(Tab.Button, Vector2.new(Tab.Button.AbsoluteSize.X / 2, Tab.Button.AbsoluteSize.Y / 2))
        self:SwitchTab(Tab)
    end)
    Tab._TabText = TabText
    Tab._BtnStroke = BtnStroke
    Tab._ActiveBar = ActiveBar

    local function MakeHelper(FnName)
        Tab[FnName] = function(TabSelf, Cfg)
            local Section = TabSelf.Sections[#TabSelf.Sections]
            if not Section then Section = TabSelf:CreateSection("Default") end
            return TabSelf.Gui[FnName](TabSelf.Gui, Section, Cfg)
        end
    end
    Tab.CreateSection = function(TabSelf, N, D, C) return TabSelf.Gui:CreateSection(TabSelf, N, D, C) end
    for _, N in ipairs({"TSButton","TSToggle","TSKeyBind","TSDropdown","TSColorPicker","TSSlider","TSTextBox","TSLabel","TSProgressBar","TSSeparator","TSMultiButton","TSBadgeRow","TSCheckbox","TSRadioGroup","TSNumberStepper","TSCard","TSCodeBlock","TSStatDisplay","TSImage","TSSpacer","TSFileDropdown","TSKeybindDisplay"}) do
        MakeHelper(N)
    end

    table.insert(self.Tabs, Tab)
    if #self.Tabs == 1 then self:SwitchTab(Tab) end
    return Tab
end

function TerminScriptsLib:SwitchTab(TargetTab)
    local PrevTab = self.CurrentTab
    for _, Tab in pairs(self.Tabs) do
        if Tab == TargetTab then
            Tab.Active = true
            if PrevTab and PrevTab ~= Tab then
                Tab.Page.BackgroundTransparency = 1
                Tab.Page.Visible = true
                CreateTween(Tab.Page, Animations.FadeIn, {BackgroundTransparency = 1}):Play()
            else
                Tab.Page.Visible = true
            end
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.12}):Play()
            if Tab._BtnStroke then CreateTween(Tab._BtnStroke, Animations.Fast, {Color = Theme.PrimaryGlow, Transparency = 0.2}):Play() end
            if Tab._TabText then CreateTween(Tab._TabText, Animations.Fast, {TextColor3 = GetContrastText(Theme.Primary)}):Play() end
            if Tab._ActiveBar then CreateTween(Tab._ActiveBar, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.65, 0, 0, 2.5 * ScalingManager.CurrentScale)}):Play() end
        else
            Tab.Active = false
            Tab.Page.Visible = false
            CreateTween(Tab.Button, Animations.Fast, {BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0.5}):Play()
            if Tab._BtnStroke then CreateTween(Tab._BtnStroke, Animations.Fast, {Color = Theme.Border, Transparency = 0.65}):Play() end
            if Tab._TabText then CreateTween(Tab._TabText, Animations.Fast, {TextColor3 = Theme.TextMuted}):Play() end
            if Tab._ActiveBar then CreateTween(Tab._ActiveBar, Animations.Fast, {Size = UDim2.new(0, 0, 0, 2.5 * ScalingManager.CurrentScale)}):Play() end
        end
    end
    self.CurrentTab = TargetTab
    if TouchManager.IsTouchDevice and self.TabContainer and TargetTab.Button then
        task.defer(function()
            if not self.TabContainer or not TargetTab.Button or not TargetTab.Button.Parent then return end
            local ContainerX = self.TabContainer.AbsolutePosition.X
            local ContainerW = self.TabContainer.AbsoluteSize.X
            local ButtonX = TargetTab.Button.AbsolutePosition.X
            local ButtonW = TargetTab.Button.AbsoluteSize.X
            local CanvasX = self.TabContainer.CanvasPosition.X
            if ButtonX < ContainerX then
                self.TabContainer.CanvasPosition = Vector2.new(math.max(0, CanvasX + ButtonX - ContainerX - 8 * ScalingManager.CurrentScale), 0)
            elseif ButtonX + ButtonW > ContainerX + ContainerW then
                self.TabContainer.CanvasPosition = Vector2.new(math.max(0, CanvasX + ButtonX + ButtonW - ContainerX - ContainerW + 8 * ScalingManager.CurrentScale), 0)
            end
        end)
    end
end

function TerminScriptsLib:CreateSection(Tab, Name, Description, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Section = {
        Name = Name, Description = Description, Config = Config, Frame = nil,
        Elements = {}, Expanded = true, LayoutOrder = #Tab.Sections + 1, Tab = Tab
    }
    Section.Frame = Instance.new("Frame")
    Section.Frame.Name = Name .. "Section"
    Section.Frame.Size = UDim2.new(1, 0, 0, 80 * Scale)
    Section.Frame.BackgroundColor3 = Theme.Card
    Section.Frame.BackgroundTransparency = 0.22
    Section.Frame.BorderSizePixel = 0
    Section.Frame.LayoutOrder = Section.LayoutOrder
    Section.Frame.Parent = Tab.Page
    AddCorner(Section.Frame, 16 * Scale)
    local SectionStroke = AddStroke(Section.Frame, 1 * Scale, Theme.BorderLight, 0.55)
    RegisterColor(SectionStroke, "Color", "Primary")

    local SectionGrad = AddGradient(Section.Frame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Card),
        ColorSequenceKeypoint.new(1, Theme.Surface)
    }, 145)
    RegisterGradient(SectionGrad, function()
        return ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.Card), ColorSequenceKeypoint.new(1, Theme.Surface)}
    end)

    local SectionHeader = Instance.new("Frame")
    SectionHeader.Name = "Header"
    SectionHeader.Size = UDim2.new(1, 0, 0, 68 * Scale)
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Parent = Section.Frame

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 2.5 * Scale, 0, 28 * Scale)
    AccentBar.Position = UDim2.new(0, 16 * Scale, 0.5, -14 * Scale)
    AccentBar.BackgroundColor3 = Theme.Primary
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = SectionHeader
    AddCorner(AccentBar, 2 * Scale)
    RegisterColor(AccentBar, "BackgroundColor3", "Primary")

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -90 * Scale, 0, 26 * Scale)
    SectionTitle.Position = UDim2.new(0, 26 * Scale, 0.5, -20 * Scale)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = Name
    SectionTitle.TextColor3 = Theme.TextPrimary
    SectionTitle.TextSize = 16 * Scale
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionHeader

    if Description then
        local SectionDesc = Instance.new("TextLabel")
        SectionDesc.Size = UDim2.new(1, -90 * Scale, 0, 16 * Scale)
        SectionDesc.Position = UDim2.new(0, 26 * Scale, 0.5, 8 * Scale)
        SectionDesc.BackgroundTransparency = 1
        SectionDesc.Text = Description
        SectionDesc.TextColor3 = Theme.TextMuted
        SectionDesc.TextSize = 11 * Scale
        SectionDesc.Font = Enum.Font.Gotham
        SectionDesc.TextXAlignment = Enum.TextXAlignment.Left
        SectionDesc.Parent = SectionHeader
    end

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 28 * Scale, 0, 28 * Scale)
    CollapseBtn.Position = UDim2.new(1, -42 * Scale, 0.5, -14 * Scale)
    CollapseBtn.BackgroundColor3 = Theme.Surface
    CollapseBtn.BackgroundTransparency = 0.3
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "v"
    CollapseBtn.TextColor3 = Theme.TextMuted
    CollapseBtn.TextSize = 12 * Scale
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.Parent = SectionHeader
    AddCorner(CollapseBtn, 8 * Scale)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -40 * Scale, 0, 0)
    ContentContainer.Position = UDim2.new(0, 20 * Scale, 0, 72 * Scale)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = Section.Frame
    Section.ContentContainer = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10 * Scale)
    ContentLayout.Parent = ContentContainer

    local BottomPad = Instance.new("UIPadding")
    BottomPad.PaddingBottom = UDim.new(0, 14 * Scale)
    BottomPad.Parent = ContentContainer

    local function UpdateSectionSize()
        if not Section.Expanded then return end
        local CH = ContentLayout.AbsoluteContentSize.Y + 18 * Scale
        Section.Frame.Size = UDim2.new(1, 0, 0, 72 * Scale + CH)
        ContentContainer.Size = UDim2.new(1, -40 * Scale, 0, CH)
    end
    ContentLayout.Changed:Connect(UpdateSectionSize)
    task.delay(0.14, UpdateSectionSize)

    CollapseBtn.MouseButton1Click:Connect(function()
        Section.Expanded = not Section.Expanded
        if Section.Expanded then
            CollapseBtn.Text = "v"
            local CH = ContentLayout.AbsoluteContentSize.Y + 18 * Scale
            CreateTween(ContentContainer, Animations.Spring, {Size = UDim2.new(1, -40 * Scale, 0, CH)}):Play()
            CreateTween(Section.Frame, Animations.Spring, {Size = UDim2.new(1, 0, 0, 72 * Scale + CH)}):Play()
        else
            CollapseBtn.Text = ">"
            CreateTween(ContentContainer, Animations.Fast, {Size = UDim2.new(1, -40 * Scale, 0, 0)}):Play()
            CreateTween(Section.Frame, Animations.Fast, {Size = UDim2.new(1, 0, 0, 72 * Scale)}):Play()
        end
    end)

    local function MakeHelper(FnName)
        Section[FnName] = function(SecSelf, Cfg)
            return SecSelf.Tab.Gui[FnName](SecSelf.Tab.Gui, SecSelf, Cfg)
        end
    end
    for _, N in ipairs({"TSButton","TSToggle","TSKeyBind","TSDropdown","TSColorPicker","TSSlider","TSTextBox","TSLabel","TSProgressBar","TSSeparator","TSMultiButton","TSBadgeRow"}) do
        MakeHelper(N)
    end
    table.insert(Tab.Sections, Section)
    return Section
end

function TerminScriptsLib:TSButton(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Button"
    local Callback = Config.Callback or function() end
    local Color = Config.Color or Theme.Primary
    local Icon = Config.Icon
    local Style = Config.Style or "filled"

    local BtnFrame = Instance.new("Frame")
    BtnFrame.Name = "TSButton"
    BtnFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    BtnFrame.BackgroundTransparency = 1
    BtnFrame.LayoutOrder = #Section.Elements + 1
    BtnFrame.Parent = Section.ContentContainer

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = Style == "ghost" and Theme.SurfaceElevated or Color
    Btn.BackgroundTransparency = Style == "ghost" and 0.5 or 0.1
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.Parent = BtnFrame
    AddCorner(Btn, 12 * Scale)
    local BtnStroke = AddStroke(Btn, Style == "ghost" and 1 * Scale or 1.5 * Scale, Style == "ghost" and Theme.BorderLight or Color, Style == "ghost" and 0.5 or 0.3)
    if Style == "filled" then
        AddGradient(Btn, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color:lerp(Color3.new(1,1,1), 0.06)),
            ColorSequenceKeypoint.new(1, Color:lerp(Color3.new(0,0,0), 0.08))
        }, 90)
    end

    local BtnContent = Instance.new("Frame")
    BtnContent.Size = UDim2.new(1, -32 * Scale, 1, 0)
    BtnContent.Position = UDim2.new(0, 16 * Scale, 0, 0)
    BtnContent.BackgroundTransparency = 1
    BtnContent.Parent = Btn
    local CL = Instance.new("UIListLayout")
    CL.FillDirection = Enum.FillDirection.Horizontal
    CL.Padding = UDim.new(0, 8 * Scale)
    CL.VerticalAlignment = Enum.VerticalAlignment.Center
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CL.Parent = BtnContent

    local function GetButtonBackground()
        return Style == "ghost" and Theme.SurfaceElevated or Color
    end

    if Icon then
        local IL = Instance.new("TextLabel")
        IL.Size = UDim2.new(0, 20 * Scale, 0, 20 * Scale)
        IL.BackgroundTransparency = 1
        IL.Text = Icon
        IL.TextColor3 = GetContrastText(GetButtonBackground())
        IL.TextSize = 16 * Scale
        IL.Font = Enum.Font.GothamBold
        IL.LayoutOrder = 1
        IL.Parent = BtnContent
    end

    local BtnText = Instance.new("TextLabel")
    BtnText.Size = UDim2.new(0, 200 * Scale, 0, 26 * Scale)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = Text
    BtnText.TextColor3 = GetContrastText(GetButtonBackground())
    BtnText.TextSize = 14 * Scale
    BtnText.Font = Enum.Font.GothamSemibold
    BtnText.LayoutOrder = Icon and 2 or 1
    BtnText.Parent = BtnContent

    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Style == "ghost" and Theme.SurfaceElevatedHover or Color:lerp(Color3.new(1,1,1), 0.1),
            BackgroundTransparency = Style == "ghost" and 0.25 or 0.02
        }):Play()
        CreateTween(BtnStroke, Animations.Fast, {Transparency = 0.1}):Play()
        SetContrastText(BtnText, Style == "ghost" and Theme.SurfaceElevatedHover or Color:lerp(Color3.new(1,1,1), 0.1))
        if Icon then SetContrastText(Icon, Style == "ghost" and Theme.SurfaceElevatedHover or Color:lerp(Color3.new(1,1,1), 0.1)) end
    end)
    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, Animations.Fast, {
            BackgroundColor3 = Style == "ghost" and Theme.SurfaceElevated or Color,
            BackgroundTransparency = Style == "ghost" and 0.5 or 0.1
        }):Play()
        CreateTween(BtnStroke, Animations.Fast, {Transparency = Style == "ghost" and 0.5 or 0.3}):Play()
        SetContrastText(BtnText, GetButtonBackground())
        if Icon then SetContrastText(Icon, GetButtonBackground()) end
    end)
    Btn.MouseButton1Down:Connect(function()
        CreateTween(Btn, Animations.Lightning, {Size = UDim2.new(0.97, 0, 0.88, 0), Position = UDim2.new(0.015, 0, 0.06, 0)}):Play()
    end)
    Btn.MouseButton1Up:Connect(function()
        CreateTween(Btn, Animations.Spring, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        CreateRipple(Btn, Vector2.new(Btn.AbsoluteSize.X / 2, Btn.AbsoluteSize.Y / 2))
        local Ok, Err = pcall(Callback)
        if not Ok then warn("Button callback error:", Err) end
    end)

    table.insert(Section.Elements, BtnFrame)
    return {
        Element = BtnFrame,
        SetText = function(T) BtnText.Text = T end,
        SetColor = function(C)
            Color = C
            if Style ~= "ghost" then Btn.BackgroundColor3 = C end
            local Bg = GetButtonBackground()
            SetContrastText(BtnText, Bg)
            if Icon then SetContrastText(Icon, Bg) end
        end,
        SetCallback = function(C) Callback = C end,
        SetEnabled = function(E)
            Btn.Active = E
            CreateTween(Btn, Animations.Fast, {BackgroundTransparency = E and 0.1 or 0.65}):Play()
            CreateTween(BtnText, Animations.Fast, {TextTransparency = E and 0 or 0.55}):Play()
        end,
    }
end

function TerminScriptsLib:TSToggle(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Toggle"
    local Default = Config.Default or false
    local Callback = Config.Callback or function() end
    local Keybind = Config.Keybind
    local Key = Config.Key or ("TSToggle:" .. Text)
    local CurrentValue = Default
    local CurrentKeybind = Keybind

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "TSToggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    ToggleFrame.BackgroundColor3 = Theme.SurfaceElevated
    ToggleFrame.BackgroundTransparency = 0.02
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = #Section.Elements + 1
    ToggleFrame.Parent = Section.ContentContainer
    AddCorner(ToggleFrame, 12 * Scale)
    AddStroke(ToggleFrame, 1 * Scale, Theme.Border, 0.55)

    local HasKeybind = Keybind ~= nil
    local RightOffset = HasKeybind and -178 * Scale or -100 * Scale
    local TextPad = HasKeybind and -200 * Scale or -122 * Scale

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Size = UDim2.new(1, TextPad, 1, 0)
    ToggleText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = Text
    ToggleText.TextColor3 = Theme.TextPrimary
    ToggleText.TextSize = 14 * Scale
    ToggleText.Font = Enum.Font.GothamSemibold
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Parent = ToggleFrame

    local KeybindBtn, KeybindText
    if HasKeybind then
        KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 56 * Scale, 0, 30 * Scale)
        KeybindBtn.Position = UDim2.new(1, -178 * Scale, 0.5, -15 * Scale)
        KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
        KeybindBtn.BackgroundTransparency = 0.2
        KeybindBtn.BorderSizePixel = 0
        KeybindBtn.Text = ""
        KeybindBtn.Parent = ToggleFrame
        AddCorner(KeybindBtn, 9 * Scale)
        AddStroke(KeybindBtn, 1.5 * Scale, Theme.Primary, 0.4)
        KeybindText = Instance.new("TextLabel")
        KeybindText.Size = UDim2.new(1, 0, 1, 0)
        KeybindText.BackgroundTransparency = 1
        KeybindText.Text = CurrentKeybind and CurrentKeybind.Name or "None"
        KeybindText.TextColor3 = Color3.fromRGB(255,255,255)
        KeybindText.TextSize = 10 * Scale
        KeybindText.Font = Enum.Font.GothamBold
        KeybindText.TextScaled = true
        KeybindText.Parent = KeybindBtn
    end

    local SwitchW = 68 * Scale
    local SwitchH = 34 * Scale
    local KnobSize = 26 * Scale

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Size = UDim2.new(0, SwitchW, 0, SwitchH)
    ToggleSwitch.BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.Parent = ToggleFrame
    AddCorner(ToggleSwitch, SwitchH / 2)
    local SwitchStroke = AddStroke(ToggleSwitch, 1.5 * Scale, CurrentValue and Theme.PrimaryGlow or Theme.BorderLight, 0.35)

    if HasKeybind then
        ToggleSwitch.Position = UDim2.new(1, RightOffset + 84, 0.5, -SwitchH / 2)
    else
        ToggleSwitch.Position = UDim2.new(1, -SwitchW - 14 * Scale, 0.5, -SwitchH / 2)
    end

    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, KnobSize, 0, KnobSize)
    ToggleKnob.Position = UDim2.new(0, CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale, 0.5, -KnobSize / 2)
    ToggleKnob.BackgroundColor3 = GetContrastText(Theme.Primary)
    ToggleKnob.BorderSizePixel = 0
    ToggleKnob.Parent = ToggleSwitch
    AddCorner(ToggleKnob, KnobSize / 2)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleSwitch

    local function UpdateToggle()
        local KP = CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale
        CreateTween(ToggleSwitch, Animations.Fast, {BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card}):Play()
        CreateTween(SwitchStroke, Animations.Fast, {Color = CurrentValue and Theme.PrimaryGlow or Theme.BorderLight}):Play()
        CreateTween(ToggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, KP, 0.5, -KnobSize / 2)
        }):Play()
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("Toggle callback error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        CurrentValue = not CurrentValue
        UpdateToggle()
        CreateRipple(ToggleSwitch, Vector2.new(SwitchW / 2, SwitchH / 2))
    end)
    ToggleBtn.MouseEnter:Connect(function()
        local HoverKP = CurrentValue and (SwitchW - KnobSize - 3 * Scale) or 3 * Scale
        CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, KnobSize + 2 * Scale, 0, KnobSize + 2 * Scale),
            Position = UDim2.new(0, HoverKP - 1 * Scale, 0.5, -(KnobSize / 2) - 1 * Scale)
        }):Play()
    end)
    ToggleBtn.MouseLeave:Connect(function()
        local KP = CurrentValue and (SwitchW - KnobSize - 4 * Scale) or 4 * Scale
        CreateTween(ToggleKnob, Animations.Fast, {
            Size = UDim2.new(0, KnobSize, 0, KnobSize),
            Position = UDim2.new(0, KP, 0.5, -KnobSize / 2)
        }):Play()
    end)
    AddHoverEffect(ToggleFrame, Theme.SurfaceHover, Theme.SurfaceElevated)

    if HasKeybind then
        if CurrentKeybind then
            KeybindManager:Bind(CurrentKeybind, function() CurrentValue = not CurrentValue UpdateToggle() end)
        end
        KeybindBtn.MouseButton1Click:Connect(function()
            KeybindText.Text = "..." KeybindBtn.BackgroundColor3 = Theme.Primary KeybindText.TextColor3 = GetContrastText(Theme.Primary)
            local Conn
            Conn = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if CurrentKeybind then KeybindManager:Unbind(CurrentKeybind) end
                    CurrentKeybind = Input.KeyCode
                    KeybindText.Text = Input.KeyCode.Name
                    KeybindManager:Bind(CurrentKeybind, function() CurrentValue = not CurrentValue UpdateToggle() end)
                    KeybindBtn.BackgroundColor3 = Theme.KeybindGrey
                    Conn:Disconnect()
                end
            end)
        end)
    end

    local Ret = {
        Element = ToggleFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = V UpdateToggle() end,
        Toggle = function() CurrentValue = not CurrentValue UpdateToggle() end,
        SetCallback = function(C) Callback = C end,
    }
    self:RegisterElement(Key, function() return CurrentValue end, function(V) CurrentValue = V UpdateToggle() end)
    table.insert(Section.Elements, ToggleFrame)
    return Ret
end

function TerminScriptsLib:TSKeyBind(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "KeyBind"
    local Default = Config.Default
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSKeyBind:" .. Text)
    local CurrentKeybind = Default

    local KBFrame = Instance.new("Frame")
    KBFrame.Name = "TSKeyBind"
    KBFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    KBFrame.BackgroundColor3 = Theme.SurfaceElevated
    KBFrame.BackgroundTransparency = 0.02
    KBFrame.BorderSizePixel = 0
    KBFrame.LayoutOrder = #Section.Elements + 1
    KBFrame.Parent = Section.ContentContainer
    AddCorner(KBFrame, 12 * Scale)
    AddStroke(KBFrame, 1 * Scale, Theme.Border, 0.45)

    local KBLabel = Instance.new("TextLabel")
    KBLabel.Size = UDim2.new(1, -150 * Scale, 1, 0)
    KBLabel.Position = UDim2.new(0, 16 * Scale, 0, 0)
    KBLabel.BackgroundTransparency = 1
    KBLabel.Text = Text
    KBLabel.TextColor3 = Theme.TextPrimary
    KBLabel.TextSize = 14 * Scale
    KBLabel.Font = Enum.Font.GothamSemibold
    KBLabel.TextXAlignment = Enum.TextXAlignment.Left
    KBLabel.Parent = KBFrame

    local KBBtn = Instance.new("TextButton")
    KBBtn.Size = UDim2.new(0, 88 * Scale, 0, 34 * Scale)
    KBBtn.Position = UDim2.new(1, -102 * Scale, 0.5, -17 * Scale)
    KBBtn.BackgroundColor3 = Theme.KeybindGrey
    KBBtn.BackgroundTransparency = 0.05
    KBBtn.BorderSizePixel = 0
    KBBtn.Text = ""
    KBBtn.Parent = KBFrame
    AddCorner(KBBtn, 9 * Scale)
    local KBStroke = AddStroke(KBBtn, 1.5 * Scale, Theme.Primary, 0.35)

    local KBBtnText = Instance.new("TextLabel")
    KBBtnText.Size = UDim2.new(1, 0, 1, 0)
    KBBtnText.BackgroundTransparency = 1
    KBBtnText.Text = CurrentKeybind and tostring(CurrentKeybind):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "") or "None"
    KBBtnText.TextColor3 = Theme.TextPrimary
    KBBtnText.TextSize = 10 * Scale
    KBBtnText.Font = Enum.Font.GothamBold
    KBBtnText.TextScaled = true
    KBBtnText.Parent = KBBtn

    local Listening = false
    local ListenConn = nil

    local function FormatKeybind(KC)
        if not KC then return "None" end
        return tostring(KC):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
    end

    local function UpdateDisplay()
        if not KBBtnText or not KBBtnText.Parent then return end

        if Listening then
            KBBtnText.Text = "..."
            CreateTween(KBBtn, Animations.Fast, {
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.08
            }):Play()
            CreateTween(KBStroke, Animations.Fast, {
                Color = Theme.PrimaryGlow,
                Transparency = 0.1
            }):Play()
        else
            KBBtnText.Text = FormatKeybind(CurrentKeybind)
            CreateTween(KBBtn, Animations.Fast, {
                BackgroundColor3 = Theme.KeybindGrey,
                BackgroundTransparency = 0.05
            }):Play()
            CreateTween(KBStroke, Animations.Fast, {
                Color = Theme.Primary,
                Transparency = 0.35
            }):Play()
        end
    end

    local function BindCurrentKey()
        if not CurrentKeybind then return end

        KeybindManager:Bind(CurrentKeybind, function()
            local Ok, Err = pcall(Callback, CurrentKeybind)
            if not Ok then warn("KeyBind press error:", Err) end
        end)
    end

    KBBtn.MouseButton1Click:Connect(function()
        if Listening then return end

        Listening = true
        UpdateDisplay()
        CreateRipple(KBBtn, Vector2.new(KBBtn.AbsoluteSize.X / 2, KBBtn.AbsoluteSize.Y / 2))

        if ListenConn then
            ListenConn:Disconnect()
            ListenConn = nil
        end

        ListenConn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed or not Listening then return end
            if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            local NewKey = Input.KeyCode
            if not NewKey then return end

            if CurrentKeybind then
                KeybindManager:Unbind(CurrentKeybind)
            end

            CurrentKeybind = NewKey
            Listening = false

            KBBtnText.Text = FormatKeybind(CurrentKeybind)
            CreateTween(KBBtn, Animations.Fast, {
                BackgroundColor3 = Theme.KeybindGrey,
                BackgroundTransparency = 0.05
            }):Play()
            CreateTween(KBStroke, Animations.Fast, {
                Color = Theme.Primary,
                Transparency = 0.35
            }):Play()

            BindCurrentKey()

            if ListenConn then
                ListenConn:Disconnect()
                ListenConn = nil
            end
        end)
    end)

    KBBtn.MouseEnter:Connect(function()
        if not Listening then
            CreateTween(KBBtn, Animations.Fast, {
                BackgroundColor3 = Theme.SurfaceHover
            }):Play()
        end
    end)

    KBBtn.MouseLeave:Connect(function()
        if not Listening then
            CreateTween(KBBtn, Animations.Fast, {
                BackgroundColor3 = Theme.KeybindGrey
            }):Play()
        end
    end)

    BindCurrentKey()
    UpdateDisplay()

    table.insert(Section.Elements, KBFrame)

    local function GetKeybind()
        return CurrentKeybind
    end

    local function SetKeybind(KC)
        if CurrentKeybind then
            KeybindManager:Unbind(CurrentKeybind)
        end

        CurrentKeybind = KC
        BindCurrentKey()
        UpdateDisplay()
    end

    self:RegisterElement(Key, GetKeybind, SetKeybind)

    return {
        Element = KBFrame,
        GetKeybind = GetKeybind,
        SetKeybind = SetKeybind,
        SetCallback = function(C)
            Callback = C
            if CurrentKeybind then
                KeybindManager:Unbind(CurrentKeybind)
                BindCurrentKey()
            end
        end,
    }
end

function TerminScriptsLib:TSDropdown(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Dropdown"
    local PlayerOptions = Config.PlayerOptions == true
    local GetConfiguredOptions = type(Config.Options) == "function" and Config.Options or nil
    local Options = GetConfiguredOptions and GetConfiguredOptions() or Config.Options or {"Option 1","Option 2","Option 3"}
    if type(Options) ~= "table" then Options = {tostring(Options)} end
    local Callback = Config.Callback or function() end
    local MultiSelect = Config.MultiSelect or false
    local Default = Config.Default
    local Key = Config.Key or ("TSDropdown:" .. Text)
    local SelectedOptions = {}
    if Default then SelectedOptions = MultiSelect and (type(Default) == "table" and Default or {Default}) or {Default} end

    local DDFrame = Instance.new("Frame")
    DDFrame.Name = "TSDropdown"
    DDFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    DDFrame.BackgroundTransparency = 1
    DDFrame.LayoutOrder = #Section.Elements + 1
    DDFrame.Parent = Section.ContentContainer

    local DDBtn = Instance.new("TextButton")
    DDBtn.Size = UDim2.new(1, 0, 0, 52 * Scale)
    DDBtn.BackgroundColor3 = Theme.SurfaceElevated
    DDBtn.BackgroundTransparency = 0.02
    DDBtn.BorderSizePixel = 0
    DDBtn.Text = ""
    DDBtn.Active = true
    DDBtn.Parent = DDFrame
    AddCorner(DDBtn, 12 * Scale)
    AddStroke(DDBtn, 1 * Scale, Theme.Border, 0.55)

    local DDContent = Instance.new("Frame")
    DDContent.Size = UDim2.new(1, -32 * Scale, 1, 0)
    DDContent.Position = UDim2.new(0, 16 * Scale, 0, 0)
    DDContent.BackgroundTransparency = 1
    DDContent.Parent = DDBtn
    local DCL = Instance.new("UIListLayout")
    DCL.FillDirection = Enum.FillDirection.Horizontal
    DCL.VerticalAlignment = Enum.VerticalAlignment.Center
    DCL.Parent = DDContent

    local DDText = Instance.new("TextLabel")
    DDText.Size = UDim2.new(1, -130 * Scale, 1, 0)
    DDText.BackgroundTransparency = 1
    DDText.Text = Text
    DDText.TextColor3 = Theme.TextPrimary
    DDText.TextSize = 14 * Scale
    DDText.Font = Enum.Font.GothamSemibold
    DDText.TextXAlignment = Enum.TextXAlignment.Left
    DDText.LayoutOrder = 1
    DDText.Parent = DDContent

    local ValDisplay = Instance.new("TextLabel")
    ValDisplay.Size = UDim2.new(0, 100 * Scale, 1, 0)
    ValDisplay.BackgroundTransparency = 1
    ValDisplay.Text = #SelectedOptions > 0 and (MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]) or "None"
    ValDisplay.TextColor3 = Theme.TextSecondary
    ValDisplay.TextSize = 13 * Scale
    ValDisplay.Font = Enum.Font.Gotham
    ValDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValDisplay.LayoutOrder = 2
    ValDisplay.Parent = DDContent

    local DDArrow = Instance.new("TextLabel")
    DDArrow.Size = UDim2.new(0, 18 * Scale, 1, 0)
    DDArrow.BackgroundTransparency = 1
    DDArrow.Text = "v"
    DDArrow.TextColor3 = Theme.TextMuted
    DDArrow.TextSize = 12 * Scale
    DDArrow.Font = Enum.Font.GothamBold
    DDArrow.LayoutOrder = 3
    DDArrow.Parent = DDContent

    local DropdownList = nil
    local DropdownOpen = false
    local PlayerConnections = {}
    local UpdateDisplay, CloseDD, OpenDD

    local function SelectionStillExists(Value, List)
        for _, Option in ipairs(List) do
            if Option == Value then return true end
        end
        return false
    end

    local function ResolveOptions()
        local NewOptions = GetConfiguredOptions and GetConfiguredOptions() or Options
        if PlayerOptions then
            NewOptions = {}
            for _, P in ipairs(Players:GetPlayers()) do table.insert(NewOptions, P.Name) end
        end
        if type(NewOptions) ~= "table" then NewOptions = {} end
        return NewOptions
    end

    local function RefreshOptionsInternal(KeepSelection)
        Options = ResolveOptions()
        if not KeepSelection then
            SelectedOptions = {}
        else
            local Kept = {}
            for _, Value in ipairs(SelectedOptions) do if SelectionStillExists(Value, Options) then table.insert(Kept, Value) end end
            SelectedOptions = Kept
        end
        UpdateDisplay()
        if DropdownOpen then
            CloseDD()
            OpenDD()
        end
    end

    local function UpdateDisplay()
        if #SelectedOptions > 0 then
            ValDisplay.Text = MultiSelect and table.concat(SelectedOptions, ", ") or SelectedOptions[1]
            ValDisplay.TextColor3 = Theme.Primary
        else
            ValDisplay.Text = "None"
            ValDisplay.TextColor3 = Theme.TextMuted
        end
    end

    local function CreateOptions()
        if DropdownList then return end
        Options = ResolveOptions()
        local Blocker = Instance.new("ImageButton")
        Blocker.Size = UDim2.new(1, 0, 1, 0)
        Blocker.BackgroundTransparency = 1
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.AutoButtonColor = false
        Blocker.Parent = self.ScreenGui

        local BtnAbsPos = DDBtn.AbsolutePosition
        local BtnAbsSize = DDBtn.AbsoluteSize
        local Camera = workspace.CurrentCamera
        local VP = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
        local TargetW = math.max(BtnAbsSize.X, 220 * Scale)
        local TargetH = math.min(#Options * 46 * Scale + 56 * Scale, 340 * Scale)
        local ListX = math.clamp(BtnAbsPos.X, 8, VP.X - TargetW - 8)
        local ListY = BtnAbsPos.Y + BtnAbsSize.Y + 6 * Scale
        if ListY + TargetH > VP.Y - 8 then
            ListY = BtnAbsPos.Y - TargetH - 6 * Scale
        end
        ListY = math.max(ListY, 8)

        DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(0, TargetW, 0, 6 * Scale)
        DropdownList.Position = UDim2.new(0, ListX, 0, ListY)
        DropdownList.AnchorPoint = Vector2.new(0, 0)
        DropdownList.BackgroundColor3 = Theme.CardElevated
        DropdownList.BackgroundTransparency = 0.03
        DropdownList.BorderSizePixel = 0
        DropdownList.ZIndex = 1000
        DropdownList.ClipsDescendants = true
        DropdownList.Parent = Blocker
        AddCorner(DropdownList, 12 * Scale)
        AddStroke(DropdownList, 1.5 * Scale, Theme.Primary, 0.3)

        CreateTween(DropdownList, Animations.Pop, {
            Size = UDim2.new(0, TargetW, 0, TargetH),
        }):Play()

        local ListScroll = Instance.new("ScrollingFrame")
        ListScroll.Size = UDim2.new(1, -8 * Scale, 1, -8 * Scale)
        ListScroll.Position = UDim2.new(0, 4 * Scale, 0, 4 * Scale)
        ListScroll.BackgroundTransparency = 1
        ListScroll.BorderSizePixel = 0
        ListScroll.ScrollBarThickness = 4 * Scale
        ListScroll.ScrollBarImageColor3 = Theme.Primary
        ListScroll.CanvasSize = UDim2.new(0, 0, 0, #Options * 46 * Scale + 8 * Scale)
        ListScroll.ZIndex = 1001
        ListScroll.Parent = DropdownList

        local LL = Instance.new("UIListLayout")
        LL.SortOrder = Enum.SortOrder.LayoutOrder
        LL.Padding = UDim.new(0, 4 * Scale)
        LL.Parent = ListScroll

        local LPad = Instance.new("UIPadding")
        LPad.PaddingTop = UDim.new(0, 4 * Scale)
        LPad.PaddingLeft = UDim.new(0, 4 * Scale)
        LPad.PaddingRight = UDim.new(0, 4 * Scale)
        LPad.Parent = ListScroll

        local function CloseModal()
            if Blocker and Blocker.Parent then Blocker:Destroy() end
            DropdownList = nil
            DropdownOpen = false
            CreateTween(DDArrow, Animations.Fast, {Rotation = 0, TextColor3 = Theme.TextMuted}):Play()
        end
        Blocker.MouseButton1Click:Connect(CloseModal)

        for I, Opt in ipairs(Options) do
            local OBtn = Instance.new("TextButton")
            OBtn.Size = UDim2.new(1, 0, 0, 38 * Scale)
            OBtn.BackgroundColor3 = Theme.SurfaceElevated
            OBtn.BackgroundTransparency = 0.35
            OBtn.BorderSizePixel = 0
            OBtn.Text = Opt
            OBtn.TextColor3 = Theme.TextPrimary
            OBtn.TextSize = 13 * Scale
            OBtn.Font = Enum.Font.GothamMedium
            OBtn.ZIndex = 1002
            OBtn.LayoutOrder = I
            OBtn.Parent = ListScroll
            AddCorner(OBtn, 8 * Scale)
            local IsSel = false
            for _, S in ipairs(SelectedOptions) do if S == Opt then IsSel = true break end end
            if IsSel then
                OBtn.BackgroundColor3 = Theme.Primary
                OBtn.BackgroundTransparency = 0.12
                SetContrastText(OBtn, Theme.Primary)
            else
                SetContrastText(OBtn, Theme.Surface)
            end

            OBtn.MouseEnter:Connect(function()
                local IsSelNow = false
                for _, S in ipairs(SelectedOptions) do if S == Opt then IsSelNow = true break end end
                if not IsSelNow then
                    CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = Theme.SurfaceHover, BackgroundTransparency = 0.18}):Play()
                    SetContrastText(OBtn, Theme.SurfaceHover)
                end
            end)
            OBtn.MouseLeave:Connect(function()
                local IsSelNow = false
                for _, S in ipairs(SelectedOptions) do if S == Opt then IsSelNow = true break end end
                if not IsSelNow then
                    CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = Theme.SurfaceElevated, BackgroundTransparency = 0.35}):Play()
                    SetContrastText(OBtn, Theme.Surface)
                end
            end)
            OBtn.MouseButton1Click:Connect(function()
                CreateRipple(OBtn, Vector2.new(OBtn.AbsoluteSize.X / 2, OBtn.AbsoluteSize.Y / 2))
                if MultiSelect then
                    local Found = false
                    for J, S in ipairs(SelectedOptions) do if S == Opt then table.remove(SelectedOptions, J) Found = true break end end
                    if not Found then table.insert(SelectedOptions, Opt) end
                    local IsNow = false
                    for _, S in ipairs(SelectedOptions) do if S == Opt then IsNow = true break end end
                    local NewBg = IsNow and Theme.Primary or Theme.Surface
                    CreateTween(OBtn, Animations.Fast, {BackgroundColor3 = NewBg, BackgroundTransparency = IsNow and 0.12 or 0.35}):Play()
                    SetContrastText(OBtn, NewBg)
                else
                    SelectedOptions = {Opt}
                    CloseModal()
                end
                UpdateDisplay()
                local Ok, Err = pcall(Callback, MultiSelect and SelectedOptions or SelectedOptions[1])
                if not Ok then warn("Dropdown callback error:", Err) end
                if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
                    task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
                end
            end)
        end
    end

    OpenDD = function()
        if DropdownOpen then return end
        Options = ResolveOptions()
        DropdownOpen = true
        CreateOptions()
        CreateTween(DDArrow, Animations.Fast, {Rotation = 180, TextColor3 = Theme.Primary}):Play()
    end
    CloseDD = function()
        if not DropdownOpen then return end
        DropdownOpen = false
        if DropdownList and DropdownList.Parent then DropdownList.Parent:Destroy() end
        DropdownList = nil
        CreateTween(DDArrow, Animations.Fast, {Rotation = 0, TextColor3 = Theme.TextMuted}):Play()
    end

    DDBtn.MouseButton1Click:Connect(function()
        CreateRipple(DDBtn, Vector2.new(DDBtn.AbsoluteSize.X / 2, DDBtn.AbsoluteSize.Y / 2))
        if DropdownOpen then CloseDD() else OpenDD() end
    end)
    AddHoverEffect(DDBtn, Theme.SurfaceHover, Theme.SurfaceElevated)
    DropdownManager:Register({Close = CloseDD})

    if PlayerOptions then
        table.insert(PlayerConnections, Players.PlayerAdded:Connect(function() task.defer(function() RefreshOptionsInternal(true) end) end))
        table.insert(PlayerConnections, Players.PlayerRemoving:Connect(function(Player)
            for I = #SelectedOptions, 1, -1 do if SelectedOptions[I] == Player.Name then table.remove(SelectedOptions, I) end end
            task.defer(function() RefreshOptionsInternal(true) end)
        end))
        RefreshOptionsInternal(true)
    end

    DDFrame.Destroying:Connect(function()
        for _, Connection in ipairs(PlayerConnections) do if Connection and Connection.Connected then Connection:Disconnect() end end
        PlayerConnections = {}
    end)

    local Ret = {
        Element = DDFrame,
        GetSelected = function() return MultiSelect and SelectedOptions or SelectedOptions[1] end,
        SetSelected = function(V) SelectedOptions = MultiSelect and (type(V) == "table" and V or {V}) or {V} UpdateDisplay() end,
        AddOption = function(O) if O ~= nil and not SelectionStillExists(O, Options) then table.insert(Options, O) end if DropdownOpen then CloseDD() OpenDD() end end,
        RemoveOption = function(O)
            for I = #Options, 1, -1 do if Options[I] == O then table.remove(Options, I) end end
            for I = #SelectedOptions, 1, -1 do if SelectedOptions[I] == O then table.remove(SelectedOptions, I) end end
            UpdateDisplay()
            if DropdownOpen then CloseDD() OpenDD() end
        end,
        SetOptions = function(Opts)
            if type(Opts) == "function" then GetConfiguredOptions = Opts Options = Opts() else Options = type(Opts) == "table" and Opts or {} GetConfiguredOptions = nil end
            local Kept = {}
            for _, Value in ipairs(SelectedOptions) do if SelectionStillExists(Value, Options) then table.insert(Kept, Value) end end
            SelectedOptions = Kept
            UpdateDisplay()
            if DropdownOpen then CloseDD() OpenDD() end
        end,
        RefreshOptions = function() RefreshOptionsInternal(true) end,
        Close = CloseDD,
    }
    self:RegisterElement(Key,
        function() return MultiSelect and SelectedOptions or SelectedOptions[1] end,
        function(V)
            SelectedOptions = MultiSelect and (type(V) == "table" and V or {V}) or {V}
            UpdateDisplay()
            local FireVal = MultiSelect and SelectedOptions or SelectedOptions[1]
            pcall(Callback, FireVal)
        end
    )
    table.insert(Section.Elements, DDFrame)
    return Ret
end

function TerminScriptsLib:TSColorPicker(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Color Picker"
    local Default = Config.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSColorPicker:" .. Text)
    local CurrentColor = Default
    local CurrentHue, CurrentSat, CurrentVal = 0, 1, 1

    local function RgbToHsv(R, G, B)
        local Max = math.max(R, G, B) local Min = math.min(R, G, B) local D = Max - Min
        local H = 0
        if D > 0 then
            if Max == R then H = ((G - B) / D) % 6
            elseif Max == G then H = (B - R) / D + 2
            elseif Max == B then H = (R - G) / D + 4 end
            H = H / 6
        end
        return H, Max == 0 and 0 or D / Max, Max
    end

    local function HsvToRgb(H, S, V)
        local C = V * S local X = C * (1 - math.abs((H * 6) % 2 - 1)) local M = V - C
        local R, G, B = 0, 0, 0
        if H < 1/6 then R,G,B = C,X,0
        elseif H < 2/6 then R,G,B = X,C,0
        elseif H < 3/6 then R,G,B = 0,C,X
        elseif H < 4/6 then R,G,B = 0,X,C
        elseif H < 5/6 then R,G,B = X,0,C
        else R,G,B = C,0,X end
        return Color3.new(R+M, G+M, B+M)
    end

    CurrentHue, CurrentSat, CurrentVal = RgbToHsv(CurrentColor.R, CurrentColor.G, CurrentColor.B)

    local CFrame = Instance.new("Frame")
    CFrame.Name = "TSColorPicker"
    CFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    CFrame.BackgroundColor3 = Theme.SurfaceElevated
    CFrame.BackgroundTransparency = 0.02
    CFrame.BorderSizePixel = 0
    CFrame.LayoutOrder = #Section.Elements + 1
    CFrame.Parent = Section.ContentContainer
    AddCorner(CFrame, 12 * Scale)
    AddStroke(CFrame, 1 * Scale, Theme.Border, 0.55)

    local CText = Instance.new("TextLabel")
    CText.Size = UDim2.new(1, -185 * Scale, 1, 0)
    CText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    CText.BackgroundTransparency = 1
    CText.Text = Text
    CText.TextColor3 = Theme.TextPrimary
    CText.TextSize = 14 * Scale
    CText.Font = Enum.Font.GothamSemibold
    CText.TextXAlignment = Enum.TextXAlignment.Left
    CText.Parent = CFrame

    local CVLabel = Instance.new("TextLabel")
    CVLabel.Size = UDim2.new(0, 80 * Scale, 1, 0)
    CVLabel.Position = UDim2.new(1, -148 * Scale, 0, 0)
    CVLabel.BackgroundTransparency = 1
    CVLabel.Text = string.format("%d, %d, %d", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255))
    CVLabel.TextColor3 = Theme.TextMuted
    CVLabel.TextSize = 11 * Scale
    CVLabel.Font = Enum.Font.Gotham
    CVLabel.TextXAlignment = Enum.TextXAlignment.Right
    CVLabel.Parent = CFrame

    local CBtn = Instance.new("TextButton")
    CBtn.Size = UDim2.new(0, 52 * Scale, 0, 34 * Scale)
    CBtn.Position = UDim2.new(1, -66 * Scale, 0.5, -17 * Scale)
    CBtn.BackgroundColor3 = CurrentColor
    CBtn.BorderSizePixel = 0
    CBtn.Text = ""
    CBtn.Parent = CFrame
    AddCorner(CBtn, 10 * Scale)
    AddStroke(CBtn, 1.5 * Scale, Theme.Primary, 0.4)

    local CPFrame = nil
    local PickerOpen = false

    local function UpdateColor()
        CurrentColor = HsvToRgb(CurrentHue, CurrentSat, CurrentVal)
        CBtn.BackgroundColor3 = CurrentColor
        CVLabel.Text = string.format("%d, %d, %d", math.floor(CurrentColor.R*255), math.floor(CurrentColor.G*255), math.floor(CurrentColor.B*255))
        local Ok, Err = pcall(Callback, CurrentColor)
        if not Ok then warn("Color picker error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end

    local function CreatePicker()
        if CPFrame then return end
        local Blocker = Instance.new("Frame")
        Blocker.Size = UDim2.new(1,0,1,0)
        Blocker.BackgroundColor3 = Color3.new(0,0,0)
        Blocker.BackgroundTransparency = 0.6
        Blocker.BorderSizePixel = 0
        Blocker.ZIndex = 999
        Blocker.Active = true
        Blocker.Parent = self.ScreenGui
        CPFrame = Instance.new("Frame")
        CPFrame.Size = UDim2.new(0, 0, 0, 0)
        CPFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        CPFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        CPFrame.BackgroundColor3 = Theme.CardElevated
        CPFrame.BackgroundTransparency = 0.03
        CPFrame.BorderSizePixel = 0
        CPFrame.ZIndex = 1000
        CPFrame.Parent = Blocker
        AddCorner(CPFrame, 16 * Scale)
        AddStroke(CPFrame, 1.5 * Scale, Theme.Primary, 0.3)
        local Camera = workspace.CurrentCamera
        local Viewport = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
        local TW = math.min(290 * Scale, math.max(230 * Scale, Viewport.X - 20 * Scale))
        local TH = math.min(340 * Scale, math.max(300 * Scale, Viewport.Y - 20 * Scale))
        local Left = math.clamp(Viewport.X / 2, TW / 2 + 8 * Scale, Viewport.X - TW / 2 - 8 * Scale)
        local Top = math.clamp(Viewport.Y / 2, TH / 2 + 8 * Scale, Viewport.Y - TH / 2 - 8 * Scale)
        CPFrame.Position = UDim2.new(0, Left, 0, Top)
        CreateTween(CPFrame, Animations.Pop, {Size = UDim2.new(0, TW, 0, TH), Position = UDim2.new(0, Left, 0, Top)}):Play()

        local TitlePick = Instance.new("TextLabel")
        TitlePick.Size = UDim2.new(1, -50 * Scale, 0, 32 * Scale)
        TitlePick.Position = UDim2.new(0, 16 * Scale, 0, 8 * Scale)
        TitlePick.BackgroundTransparency = 1
        TitlePick.Text = Text
        TitlePick.TextColor3 = Theme.TextPrimary
        TitlePick.TextSize = 15 * Scale
        TitlePick.Font = Enum.Font.GothamBold
        TitlePick.TextXAlignment = Enum.TextXAlignment.Left
        TitlePick.ZIndex = 1001
        TitlePick.Parent = CPFrame

        local SVPicker = Instance.new("Frame")
        SVPicker.Size = UDim2.new(1, -32 * Scale, 0, 175 * Scale)
        SVPicker.Position = UDim2.new(0, 16 * Scale, 0, 46 * Scale)
        SVPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
        SVPicker.BorderSizePixel = 0
        SVPicker.ZIndex = 1001
        SVPicker.Parent = CPFrame
        AddCorner(SVPicker, 8 * Scale)
        local WG = Instance.new("UIGradient")
        WG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}
        WG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}
        WG.Parent = SVPicker
        local BO = Instance.new("Frame")
        BO.Size = UDim2.new(1,0,1,0)
        BO.BackgroundColor3 = Color3.new(0,0,0)
        BO.BorderSizePixel = 0
        BO.ZIndex = 1002
        BO.Parent = SVPicker
        AddCorner(BO, 8 * Scale)
        local BG = Instance.new("UIGradient")
        BG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}
        BG.Rotation = 90
        BG.Parent = BO

        local HueBar = Instance.new("Frame")
        HueBar.Size = UDim2.new(1, -32 * Scale, 0, 24 * Scale)
        HueBar.Position = UDim2.new(0, 16 * Scale, 0, 232 * Scale)
        HueBar.BorderSizePixel = 0
        HueBar.ZIndex = 1001
        HueBar.Parent = CPFrame
        AddCorner(HueBar, 12 * Scale)
        AddGradient(HueBar, ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
        }, 0)

        local PreviewBox = Instance.new("Frame")
        PreviewBox.Size = UDim2.new(1, -32 * Scale, 0, 30 * Scale)
        PreviewBox.Position = UDim2.new(0, 16 * Scale, 0, 268 * Scale)
        PreviewBox.BackgroundColor3 = CurrentColor
        PreviewBox.BorderSizePixel = 0
        PreviewBox.ZIndex = 1001
        PreviewBox.Parent = CPFrame
        AddCorner(PreviewBox, 8 * Scale)
        AddStroke(PreviewBox, 1 * Scale, Theme.BorderLight, 0.4)

        local SVSel = Instance.new("Frame")
        SVSel.Size = UDim2.new(0, 10*Scale, 0, 10*Scale)
        SVSel.Position = UDim2.new(CurrentSat, -5*Scale, 1-CurrentVal, -5*Scale)
        SVSel.BackgroundColor3 = Color3.new(1,1,1)
        SVSel.BorderSizePixel = 0
        SVSel.ZIndex = 1004
        SVSel.Parent = SVPicker
        AddCorner(SVSel, 5*Scale)
        AddStroke(SVSel, 2*Scale, Color3.new(0,0,0), 0.1)

        local HueSel = Instance.new("Frame")
        HueSel.Size = UDim2.new(0, 4*Scale, 1, 4*Scale)
        HueSel.Position = UDim2.new(CurrentHue, -2*Scale, 0, -2*Scale)
        HueSel.BackgroundColor3 = Color3.new(1,1,1)
        HueSel.BorderSizePixel = 0
        HueSel.ZIndex = 1002
        HueSel.Parent = HueBar
        AddCorner(HueSel, 3*Scale)
        AddStroke(HueSel, 1*Scale, Color3.new(0,0,0), 0.1)

        local SVDrag, HueDrag = false, false
        local function ApplySVInput(MP)
            local P = SVPicker.AbsolutePosition
            local S = SVPicker.AbsoluteSize
            if S.X <= 0 or S.Y <= 0 then return end
            CurrentSat = math.clamp((MP.X - P.X) / S.X, 0, 1)
            CurrentVal = 1 - math.clamp((MP.Y - P.Y) / S.Y, 0, 1)
            SVSel.Position = UDim2.new(CurrentSat, -5*Scale, 1-CurrentVal, -5*Scale)
            UpdateColor()
            PreviewBox.BackgroundColor3 = CurrentColor
        end
        local function ApplyHueInput(MP)
            local P = HueBar.AbsolutePosition
            local S = HueBar.AbsoluteSize
            if S.X <= 0 then return end
            CurrentHue = math.clamp((MP.X - P.X) / S.X, 0, 1)
            HueSel.Position = UDim2.new(CurrentHue, -2*Scale, 0, -2*Scale)
            SVPicker.BackgroundColor3 = HsvToRgb(CurrentHue, 1, 1)
            UpdateColor()
            PreviewBox.BackgroundColor3 = CurrentColor
        end
        SVPicker.InputBegan:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
                SVDrag = true
                ApplySVInput(I.Position)
            end
        end)
        HueBar.InputBegan:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
                HueDrag = true
                ApplyHueInput(I.Position)
            end
        end)
        UserInputService.InputChanged:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch then
                if SVDrag then
                    ApplySVInput(I.Position)
                elseif HueDrag then
                    ApplyHueInput(I.Position)
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
                SVDrag = false
                HueDrag = false
            end
        end)

        local CClose = Instance.new("TextButton")
        CClose.Size = UDim2.new(0, 26*Scale, 0, 26*Scale)
        CClose.Position = UDim2.new(1, -36*Scale, 0, 10*Scale)
        CClose.BackgroundColor3 = Theme.Error
        CClose.BackgroundTransparency = 0.3
        CClose.BorderSizePixel = 0
        CClose.Text = "x"
        CClose.TextColor3 = Theme.TextPrimary
        CClose.TextSize = 13*Scale
        CClose.Font = Enum.Font.GothamBold
        CClose.ZIndex = 1001
        CClose.Parent = CPFrame
        AddCorner(CClose, 13*Scale)
        local function CloseIt() if Blocker and Blocker.Parent then Blocker:Destroy() end CPFrame = nil PickerOpen = false end
        CClose.MouseButton1Click:Connect(CloseIt)
        Blocker.MouseButton1Click:Connect(CloseIt)
    end

    CBtn.MouseButton1Click:Connect(function()
        if not PickerOpen then PickerOpen = true CreatePicker() end
        CreateRipple(CBtn, Vector2.new(26*Scale, 17*Scale))
    end)
    CBtn.MouseEnter:Connect(function()
        CreateTween(CBtn, Animations.Fast, {Size = UDim2.new(0, 56*Scale, 0, 38*Scale), Position = UDim2.new(1, -68*Scale, 0.5, -19*Scale)}):Play()
    end)
    CBtn.MouseLeave:Connect(function()
        CreateTween(CBtn, Animations.Fast, {Size = UDim2.new(0, 52*Scale, 0, 34*Scale), Position = UDim2.new(1, -66*Scale, 0.5, -17*Scale)}):Play()
    end)
    AddHoverEffect(CFrame, Theme.SurfaceHover, Theme.SurfaceElevated)

    local Ret = {
        Element = CFrame,
        GetColor = function() return CurrentColor end,
        SetColor = function(C) CurrentColor = C CurrentHue, CurrentSat, CurrentVal = RgbToHsv(C.R, C.G, C.B) UpdateColor() end,
        SetCallback = function(C) Callback = C end,
    }
    self:RegisterElement(Key,
        function() return CurrentColor end,
        function(C)
            local NC = type(C) == "userdata" and C or (type(C) == "table" and Color3.fromRGB(C[1] or 255, C[2] or 255, C[3] or 255) or nil)
            if typeof(NC) == "Color3" then
                CurrentColor = NC
                CurrentHue, CurrentSat, CurrentVal = RgbToHsv(NC.R, NC.G, NC.B)
                CBtn.BackgroundColor3 = NC
                CVLabel.Text = string.format("%d, %d, %d", math.floor(NC.R*255), math.floor(NC.G*255), math.floor(NC.B*255))
                pcall(Callback, NC)
            end
        end
    )
    table.insert(Section.Elements, CFrame)
    return Ret
end

function TerminScriptsLib:TSSlider(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Slider"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Default = Config.Default or Min
    local Increment = Config.Increment or 1
    local Suffix = Config.Suffix or ""
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSSlider:" .. Text)
    local CurrentValue = Default

    local SFrame = Instance.new("Frame")
    SFrame.Name = "TSSlider"
    SFrame.Size = UDim2.new(1, 0, 0, 72 * Scale)
    SFrame.BackgroundColor3 = Theme.SurfaceElevated
    SFrame.BackgroundTransparency = 0.02
    SFrame.BorderSizePixel = 0
    SFrame.LayoutOrder = #Section.Elements + 1
    SFrame.Parent = Section.ContentContainer
    AddCorner(SFrame, 12 * Scale)
    AddStroke(SFrame, 1 * Scale, Theme.Border, 0.55)

    local SText = Instance.new("TextLabel")
    SText.Size = UDim2.new(1, -105 * Scale, 0, 26 * Scale)
    SText.Position = UDim2.new(0, 16 * Scale, 0, 9 * Scale)
    SText.BackgroundTransparency = 1
    SText.Text = Text
    SText.TextColor3 = Theme.TextPrimary
    SText.TextSize = 14 * Scale
    SText.Font = Enum.Font.GothamSemibold
    SText.TextXAlignment = Enum.TextXAlignment.Left
    SText.Parent = SFrame

    local VDisplay = Instance.new("TextLabel")
    VDisplay.Size = UDim2.new(0, 70 * Scale, 0, 26 * Scale)
    VDisplay.Position = UDim2.new(1, -86 * Scale, 0, 9 * Scale)
    VDisplay.BackgroundTransparency = 1
    VDisplay.Text = tostring(CurrentValue) .. Suffix
    VDisplay.TextColor3 = Theme.Primary
    VDisplay.TextSize = 14 * Scale
    VDisplay.Font = Enum.Font.GothamBold
    VDisplay.TextXAlignment = Enum.TextXAlignment.Right
    VDisplay.Parent = SFrame
    RegisterColor(VDisplay, "TextColor3", "Primary")

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -32 * Scale, 0, 6 * Scale)
    Track.Position = UDim2.new(0, 16 * Scale, 0, 48 * Scale)
    Track.BackgroundColor3 = Theme.CardElevated
    Track.BorderSizePixel = 0
    Track.Parent = SFrame
    AddCorner(Track, 3 * Scale)
    AddStroke(Track, 1 * Scale, Theme.BorderLight, 0.55)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    AddCorner(Fill, 3 * Scale)
    AddGradient(Fill, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Secondary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryGlow)
    }, 0)
    RegisterColor(Fill, "BackgroundColor3", "Primary")

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 18 * Scale, 0, 18 * Scale)
    Thumb.Position = UDim2.new((CurrentValue - Min) / (Max - Min), -9 * Scale, 0.5, -9 * Scale)
    Thumb.BackgroundColor3 = Theme.TextPrimary
    Thumb.BorderSizePixel = 0
    Thumb.Parent = Track
    Thumb.ZIndex = Track.ZIndex + 5
    AddCorner(Thumb, 9 * Scale)
    local ThumbStroke = AddStroke(Thumb, 2 * Scale, Theme.Primary, 0.2)
    RegisterColor(ThumbStroke, "Color", "Primary")

    local function UpdateSlider()
        local Pct = (CurrentValue - Min) / (Max - Min)
        CreateTween(Fill, Animations.Fast, {Size = UDim2.new(Pct, 0, 1, 0)}):Play()
        CreateTween(Thumb, Animations.Fast, {Position = UDim2.new(Pct, -9 * Scale, 0.5, -9 * Scale)}):Play()
        VDisplay.Text = tostring(CurrentValue) .. Suffix
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("Slider error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end

    local Dragging = false
    local TrackConn
    local function HandleInput(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 22*Scale, 0, 22*Scale)}):Play()
            TrackConn = UserInputService.InputChanged:Connect(function(I2)
                if (I2.UserInputType == Enum.UserInputType.MouseMovement or I2.UserInputType == Enum.UserInputType.Touch) and Dragging then
                    local TP = Track.AbsolutePosition.X
                    local TS = Track.AbsoluteSize.X
                    local Pct = math.clamp((I2.Position.X - TP) / TS, 0, 1)
                    local Raw = Min + (Max - Min) * Pct
                    CurrentValue = math.clamp(math.floor(Raw / Increment + 0.5) * Increment, Min, Max)
                    UpdateSlider()
                end
            end)
        end
    end
    Track.InputBegan:Connect(HandleInput)
    Thumb.InputBegan:Connect(HandleInput)
    UserInputService.InputEnded:Connect(function(I)
        if (I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch) and Dragging then
            Dragging = false
            CreateTween(Thumb, Animations.Spring, {Size = UDim2.new(0, 18*Scale, 0, 18*Scale)}):Play()
            if TrackConn then TrackConn:Disconnect() TrackConn = nil end
        end
    end)
    Thumb.MouseEnter:Connect(function()
        if not Dragging then CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 22*Scale, 0, 22*Scale), Position = UDim2.new((CurrentValue-Min)/(Max-Min), -11*Scale, 0.5, -11*Scale)}):Play() end
    end)
    Thumb.MouseLeave:Connect(function()
        if not Dragging then CreateTween(Thumb, Animations.Fast, {Size = UDim2.new(0, 18*Scale, 0, 18*Scale), Position = UDim2.new((CurrentValue-Min)/(Max-Min), -9*Scale, 0.5, -9*Scale)}):Play() end
    end)
    AddHoverEffect(SFrame, Theme.SurfaceHover, Theme.SurfaceElevated)

    local Ret = {
        Element = SFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = math.clamp(tonumber(V) or Min, Min, Max) UpdateSlider() end,
        SetRange = function(NMin, NMax) Min = tonumber(NMin) or Min Max = tonumber(NMax) or Max if Max < Min then Min, Max = Max, Min end CurrentValue = math.clamp(CurrentValue, Min, Max) UpdateSlider() end,
        SetCallback = function(C) if type(C) == "function" then Callback = C end end,
    }
    self:RegisterElement(Key,
        function() return CurrentValue end,
        function(V)
            local NumberValue = tonumber(V)
            if NumberValue == nil then return end
            CurrentValue = math.clamp(NumberValue, Min, Max)
            UpdateSlider()
        end
    )
    table.insert(Section.Elements, SFrame)
    return Ret
end

function TerminScriptsLib:TSTextBox(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "TextBox"
    local Placeholder = Config.Placeholder or "Enter text..."
    local Default = Config.Default or ""
    local Callback = Config.Callback or function() end
    local Multiline = Config.Multiline or false
    local NumbersOnly = Config.NumbersOnly or false
    local Key = Config.Key or ("TSTextBox:" .. Text)

    local TBFrame = Instance.new("Frame")
    TBFrame.Name = "TSTextBox"
    TBFrame.Size = UDim2.new(1, 0, 0, Multiline and 92 * Scale or 52 * Scale)
    TBFrame.BackgroundColor3 = Theme.SurfaceElevated
    TBFrame.BackgroundTransparency = 0.02
    TBFrame.BorderSizePixel = 0
    TBFrame.LayoutOrder = #Section.Elements + 1
    TBFrame.Parent = Section.ContentContainer
    AddCorner(TBFrame, 12 * Scale)
    AddStroke(TBFrame, 1 * Scale, Theme.Border, 0.55)

    local TBLabel = Instance.new("TextLabel")
    TBLabel.Size = UDim2.new(1, -16 * Scale, 0, 22 * Scale)
    TBLabel.Position = UDim2.new(0, 16 * Scale, 0, 4 * Scale)
    TBLabel.BackgroundTransparency = 1
    TBLabel.Text = Text
    TBLabel.TextColor3 = Theme.TextSecondary
    TBLabel.TextSize = 11 * Scale
    TBLabel.Font = Enum.Font.GothamSemibold
    TBLabel.TextXAlignment = Enum.TextXAlignment.Left
    TBLabel.Parent = TBFrame

    local TBInput = Instance.new("TextBox")
    TBInput.Size = UDim2.new(1, -32 * Scale, 0, Multiline and 54 * Scale or 22 * Scale)
    TBInput.Position = UDim2.new(0, 16 * Scale, 0, 26 * Scale)
    TBInput.BackgroundColor3 = Theme.CardElevated
    TBInput.BackgroundTransparency = 0.25
    TBInput.BorderSizePixel = 0
    TBInput.Text = Default
    TBInput.PlaceholderText = Placeholder
    TBInput.TextColor3 = Theme.TextPrimary
    TBInput.PlaceholderColor3 = Theme.TextMuted
    TBInput.TextSize = 13 * Scale
    TBInput.Font = Enum.Font.Gotham
    TBInput.TextXAlignment = Enum.TextXAlignment.Left
    TBInput.TextYAlignment = Multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    TBInput.MultiLine = Multiline
    TBInput.TextWrapped = Multiline
    TBInput.Parent = TBFrame
    AddCorner(TBInput, 7 * Scale)
    local TBStroke = AddStroke(TBInput, 1.5 * Scale, Theme.BorderLight, 0.55)

    TBInput.Focused:Connect(function()
        CreateTween(TBInput, Animations.Fast, {BackgroundColor3 = Theme.CardElevated, BackgroundTransparency = 0.08}):Play()
        CreateTween(TBStroke, Animations.Fast, {Color = Theme.Primary, Transparency = 0.15}):Play()
    end)
    TBInput.FocusLost:Connect(function()
        CreateTween(TBInput, Animations.Fast, {BackgroundColor3 = Theme.CardElevated, BackgroundTransparency = 0.15}):Play()
        CreateTween(TBStroke, Animations.Fast, {Color = Theme.BorderLight, Transparency = 0.55}):Play()
        local Ok, Err = pcall(Callback, TBInput.Text)
        if not Ok then warn("TextBox error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end)
    if NumbersOnly then
        TBInput.Changed:Connect(function(P)
            if P == "Text" then
                local N = TBInput.Text:gsub("[^%d%.%-]", "")
                if N ~= TBInput.Text then TBInput.Text = N end
            end
        end)
    end
    AddHoverEffect(TBFrame, Theme.SurfaceHover, Theme.SurfaceElevated)

    local Ret = {
        Element = TBFrame,
        GetText = function() return TBInput.Text end,
        SetText = function(T)
            TBInput.Text = tostring(T == nil and "" or T)
            pcall(Callback, TBInput.Text)
        end,
        SetCallback = function(C) if type(C) == "function" then Callback = C end end,
        Focus = function() TBInput:CaptureFocus() end,
        ClearText = function() TBInput.Text = "" pcall(Callback, TBInput.Text) end,
    }
    self:RegisterElement(Key,
        function() return TBInput.Text end,
        function(V)
            TBInput.Text = tostring(V == nil and "" or V)
            pcall(Callback, TBInput.Text)
        end
    )
    table.insert(Section.Elements, TBFrame)
    return Ret
end

function TerminScriptsLib:TSLabel(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Label"
    local Value = Config.Value or ""
    local Icon = Config.Icon
    local Style = Config.Style or "default"
    local Typewriter = Config.Typewriter or false

    local BgColor = Theme.Surface
    if Style == "info" then BgColor = Theme.Primary:lerp(Theme.Surface, 0.88)
    elseif Style == "warning" then BgColor = Theme.Warning:lerp(Theme.Surface, 0.88)
    elseif Style == "error" then BgColor = Theme.Error:lerp(Theme.Surface, 0.88) end

    local LFrame = Instance.new("Frame")
    LFrame.Name = "TSLabel"
    LFrame.Size = UDim2.new(1, 0, 0, 42 * Scale)
    LFrame.BackgroundColor3 = BgColor
    LFrame.BackgroundTransparency = 0.25
    LFrame.BorderSizePixel = 0
    LFrame.LayoutOrder = #Section.Elements + 1
    LFrame.Parent = Section.ContentContainer
    AddCorner(LFrame, 10 * Scale)
    local LStrokeColor = Style == "info" and Theme.Primary or (Style == "warning" and Theme.Warning or (Style == "error" and Theme.Error or Theme.BorderLight))
    AddStroke(LFrame, 1 * Scale, LStrokeColor, 0.5)

    local LeftOff = 14 * Scale
    if Icon then
        local ILabel = Instance.new("TextLabel")
        ILabel.Size = UDim2.new(0, 22 * Scale, 1, 0)
        ILabel.Position = UDim2.new(0, LeftOff, 0, 0)
        ILabel.BackgroundTransparency = 1
        ILabel.Text = Icon
        ILabel.TextColor3 = LStrokeColor
        ILabel.TextSize = 15 * Scale
        ILabel.Font = Enum.Font.GothamBold
        ILabel.TextXAlignment = Enum.TextXAlignment.Center
        ILabel.Parent = LFrame
        LeftOff = LeftOff + 26 * Scale
    end

    local LText = Instance.new("TextLabel")
    LText.Size = UDim2.new(0.5, -(LeftOff), 1, 0)
    LText.Position = UDim2.new(0, LeftOff, 0, 0)
    LText.BackgroundTransparency = 1
    LText.Text = Text
    LText.TextColor3 = Theme.TextSecondary
    LText.TextSize = 12 * Scale
    LText.Font = Enum.Font.GothamSemibold
    LText.TextXAlignment = Enum.TextXAlignment.Left
    LText.Parent = LFrame

    local LValue = Instance.new("TextLabel")
    LValue.Size = UDim2.new(0.48, -14 * Scale, 1, 0)
    LValue.Position = UDim2.new(0.52, 0, 0, 0)
    LValue.BackgroundTransparency = 1
    LValue.Text = Typewriter and "" or Value
    LValue.TextColor3 = Style == "info" and Theme.Primary or (Style == "warning" and Theme.Warning or Theme.TextPrimary)
    LValue.TextSize = 12 * Scale
    LValue.Font = Enum.Font.GothamBold
    LValue.TextXAlignment = Enum.TextXAlignment.Right
    LValue.Parent = LFrame
    RegisterColor(LValue, "TextColor3", Style == "info" and "Primary" or "TextPrimary")

    if Typewriter and Value ~= "" then
        task.delay(0.1, function() TypewriterEffect(LValue, Value, 0.035) end)
    end

    table.insert(Section.Elements, LFrame)
    return {
        Element = LFrame,
        SetText = function(T) LText.Text = T end,
        SetValue = function(V)
            if Typewriter then TypewriterEffect(LValue, V, 0.03)
            else LValue.Text = V end
        end,
        GetValue = function() return LValue.Text end,
    }
end

function TerminScriptsLib:TSProgressBar(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Progress"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Default = Config.Default or Min
    local Suffix = Config.Suffix or "%"
    local Animated = Config.Animated ~= false
    local CurrentValue = Default

    local BindInstance = Config.Instance
    local BindProperty = Config.Property
    local BindMaxProperty = Config.MaxProperty

    local PFrame = Instance.new("Frame")
    PFrame.Name = "TSProgressBar"
    PFrame.Size = UDim2.new(1, 0, 0, 62 * Scale)
    PFrame.BackgroundColor3 = Theme.Surface
    PFrame.BackgroundTransparency = 0.28
    PFrame.BorderSizePixel = 0
    PFrame.LayoutOrder = #Section.Elements + 1
    PFrame.Parent = Section.ContentContainer
    AddCorner(PFrame, 12 * Scale)
    AddStroke(PFrame, 1 * Scale, Theme.Border, 0.55)

    local PText = Instance.new("TextLabel")
    PText.Size = UDim2.new(0.65, -16 * Scale, 0, 24 * Scale)
    PText.Position = UDim2.new(0, 16 * Scale, 0, 8 * Scale)
    PText.BackgroundTransparency = 1
    PText.Text = Text
    PText.TextColor3 = Theme.TextPrimary
    PText.TextSize = 13 * Scale
    PText.Font = Enum.Font.GothamSemibold
    PText.TextXAlignment = Enum.TextXAlignment.Left
    PText.Parent = PFrame

    local PValLabel = Instance.new("TextLabel")
    PValLabel.Size = UDim2.new(0.35, -16 * Scale, 0, 24 * Scale)
    PValLabel.Position = UDim2.new(0.65, 0, 0, 8 * Scale)
    PValLabel.BackgroundTransparency = 1
    PValLabel.TextColor3 = Theme.Primary
    PValLabel.TextSize = 13 * Scale
    PValLabel.Font = Enum.Font.GothamBold
    PValLabel.TextXAlignment = Enum.TextXAlignment.Right
    PValLabel.Parent = PFrame
    RegisterColor(PValLabel, "TextColor3", "Primary")

    local PTrack = Instance.new("Frame")
    PTrack.Size = UDim2.new(1, -32 * Scale, 0, 9 * Scale)
    PTrack.Position = UDim2.new(0, 16 * Scale, 0, 42 * Scale)
    PTrack.BackgroundColor3 = Theme.Card
    PTrack.BorderSizePixel = 0
    PTrack.Parent = PFrame
    AddCorner(PTrack, 5 * Scale)

    local PFill = Instance.new("Frame")
    PFill.Size = UDim2.new(0, 0, 1, 0)
    PFill.BackgroundColor3 = Theme.Primary
    PFill.BorderSizePixel = 0
    PFill.Parent = PTrack
    AddCorner(PFill, 5 * Scale)
    AddGradient(PFill, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Secondary),
        ColorSequenceKeypoint.new(0.5, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryGlow)
    }, 0)
    RegisterColor(PFill, "BackgroundColor3", "Primary")

    if Animated then
        local Shimmer = Instance.new("Frame")
        Shimmer.Size = UDim2.new(0, 30 * Scale, 1, 0)
        Shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
        Shimmer.BackgroundTransparency = 0.72
        Shimmer.BorderSizePixel = 0
        Shimmer.ZIndex = PFill.ZIndex + 1
        Shimmer.Parent = PFill
        AddCorner(Shimmer, 3 * Scale)
        local function AnimateShimmer()
            if not Shimmer or not Shimmer.Parent then return end
            Shimmer.Position = UDim2.new(-0.25, 0, 0, 0)
            local T = CreateTween(Shimmer, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(1.1, 0, 0, 0)})
            T:Play()
            T.Completed:Connect(function() task.delay(1.2, AnimateShimmer) end)
        end
        task.delay(0.5, AnimateShimmer)
    end

    local DisplayedValue = Min
    local ActiveThreads = {}

    local function ClearThreads()
        for _, Thread in ipairs(ActiveThreads) do task.cancel(Thread) end
        table.clear(ActiveThreads)
    end

    local function AnimateCounter(TargetVal)
        ClearThreads()
        local Steps = 10
        local StepTime = 0.15 / Steps
        local StartVal = DisplayedValue
        for I = 1, Steps do
            local Thread = task.delay(I * StepTime, function()
                if not PValLabel or not PValLabel.Parent then return end
                local T = I / Steps
                local Interpolated = StartVal + (TargetVal - StartVal) * T
                DisplayedValue = Interpolated
                local Pct = math.clamp((Interpolated - Min) / (Max - Min), 0, 1)
                PValLabel.Text = tostring(math.floor(Pct * 100)) .. Suffix
            end)
            table.insert(ActiveThreads, Thread)
        end
    end

    local function UpdateProgress()
        local Pct = math.clamp((CurrentValue - Min) / (Max - Min), 0, 1)
        CreateTween(PFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(Pct, 0, 1, 0)}):Play()
        AnimateCounter(CurrentValue)
    end

    local ListenerConnection
    local MaxListenerConnection

    if BindInstance and BindProperty then
        CurrentValue = BindInstance[BindProperty] or CurrentValue
        if BindMaxProperty then Max = BindInstance[BindMaxProperty] or Max end
        ListenerConnection = BindInstance:GetPropertyChangedSignal(BindProperty):Connect(function()
            CurrentValue = math.clamp(BindInstance[BindProperty], Min, Max)
            UpdateProgress()
        end)
        if BindMaxProperty then
            MaxListenerConnection = BindInstance:GetPropertyChangedSignal(BindMaxProperty):Connect(function()
                Max = BindInstance[BindMaxProperty]
                CurrentValue = math.clamp(BindInstance[BindProperty], Min, Max)
                UpdateProgress()
            end)
        end
    end

    UpdateProgress()
    AddHoverEffect(PFrame, Theme.SurfaceHover, Theme.Surface)
    table.insert(Section.Elements, PFrame)

    return {
        Element = PFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = math.clamp(V, Min, Max) UpdateProgress() end,
        SetText = function(T) PText.Text = T end,
        Disconnect = function()
            ClearThreads()
            if ListenerConnection then ListenerConnection:Disconnect() end
            if MaxListenerConnection then MaxListenerConnection:Disconnect() end
        end
    }
end

function TerminScriptsLib:TSSeparator(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text
    local Color = Config.Color or Theme.Primary

    local SepFrame = Instance.new("Frame")
    SepFrame.Name = "TSSeparator"
    SepFrame.Size = UDim2.new(1, 0, 0, Text and 22 * Scale or 12 * Scale)
    SepFrame.BackgroundTransparency = 1
    SepFrame.LayoutOrder = #Section.Elements + 1
    SepFrame.Parent = Section.ContentContainer

    if Text then
        local LeftLine = Instance.new("Frame")
        LeftLine.Size = UDim2.new(0.5, -60 * Scale, 0, 1 * Scale)
        LeftLine.Position = UDim2.new(0, 0, 0.5, 0)
        LeftLine.BackgroundColor3 = Color
        LeftLine.BackgroundTransparency = 0.6
        LeftLine.BorderSizePixel = 0
        LeftLine.Parent = SepFrame

        local RightLine = Instance.new("Frame")
        RightLine.Size = UDim2.new(0.5, -60 * Scale, 0, 1 * Scale)
        RightLine.Position = UDim2.new(0.5, 60 * Scale, 0.5, 0)
        RightLine.BackgroundColor3 = Color
        RightLine.BackgroundTransparency = 0.6
        RightLine.BorderSizePixel = 0
        RightLine.Parent = SepFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 110 * Scale, 1, 0)
        Label.Position = UDim2.new(0.5, -55 * Scale, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Text
        Label.TextColor3 = Color
        Label.TextTransparency = 0.35
        Label.TextSize = 10 * Scale
        Label.Font = Enum.Font.GothamSemibold
        Label.Parent = SepFrame
    else
        local Line = Instance.new("Frame")
        Line.Size = UDim2.new(1, 0, 0, 1 * Scale)
        Line.Position = UDim2.new(0, 0, 0.5, 0)
        Line.BackgroundColor3 = Color
        Line.BackgroundTransparency = 0.65
        Line.BorderSizePixel = 0
        Line.Parent = SepFrame
    end

    table.insert(Section.Elements, SepFrame)
    return {Element = SepFrame}
end

function TerminScriptsLib:TSMultiButton(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Options = Config.Options or {"Option A", "Option B", "Option C"}
    local Default = Config.Default or Options[1]
    local Callback = Config.Callback or function() end
    local Selected = Default

    local MBFrame = Instance.new("Frame")
    MBFrame.Name = "TSMultiButton"
    MBFrame.Size = UDim2.new(1, 0, 0, 48 * Scale)
    MBFrame.BackgroundColor3 = Theme.Card
    MBFrame.BackgroundTransparency = 0.2
    MBFrame.BorderSizePixel = 0
    MBFrame.LayoutOrder = #Section.Elements + 1
    MBFrame.Parent = Section.ContentContainer
    AddCorner(MBFrame, 12 * Scale)
    AddStroke(MBFrame, 1 * Scale, Theme.BorderLight, 0.5)

    local InnerPad = Instance.new("UIPadding")
    InnerPad.PaddingLeft = UDim.new(0, 4 * Scale)
    InnerPad.PaddingRight = UDim.new(0, 4 * Scale)
    InnerPad.PaddingTop = UDim.new(0, 5 * Scale)
    InnerPad.PaddingBottom = UDim.new(0, 5 * Scale)
    InnerPad.Parent = MBFrame

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BtnLayout.Padding = UDim.new(0, 4 * Scale)
    BtnLayout.Parent = MBFrame

    local Buttons = {}
    local function SelectOption(Opt)
        Selected = Opt
        for _, BData in ipairs(Buttons) do
            local IsNow = BData.Text == Opt
            CreateTween(BData.Btn, Animations.Fast, {
                BackgroundColor3 = IsNow and Theme.Primary or Theme.Surface,
                BackgroundTransparency = IsNow and 0.05 or 0.5
            }):Play()
            CreateTween(BData.Label, Animations.Fast, {
                TextColor3 = IsNow and Theme.TextPrimary or Theme.TextMuted
            }):Play()
        end
        local Ok, Err = pcall(Callback, Opt)
        if not Ok then warn("MultiButton error:", Err) end
    end

    local TotalWeight = #Options
    for I, Opt in ipairs(Options) do
        local IsSelected = Opt == Selected
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1 / TotalWeight, -3 * Scale, 1, 0)
        Btn.BackgroundColor3 = IsSelected and Theme.Primary or Theme.Surface
        Btn.BackgroundTransparency = IsSelected and 0.05 or 0.5
        Btn.BorderSizePixel = 0
        Btn.Text = ""
        Btn.LayoutOrder = I
        Btn.Parent = MBFrame
        AddCorner(Btn, 9 * Scale)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = Opt
        Label.TextColor3 = IsSelected and Theme.TextPrimary or Theme.TextMuted
        Label.TextSize = 12 * Scale
        Label.Font = Enum.Font.GothamSemibold
        Label.Parent = Btn

        table.insert(Buttons, {Btn = Btn, Label = Label, Text = Opt})

        Btn.MouseButton1Click:Connect(function()
            CreateRipple(Btn, Vector2.new(Btn.AbsoluteSize.X / 2, Btn.AbsoluteSize.Y / 2))
            SelectOption(Opt)
        end)
    end

    table.insert(Section.Elements, MBFrame)

    self:RegisterElement(Config.Key or ("TSMultiButton:" .. table.concat(Options, "|")), function() return Selected end, function(V) SelectOption(V) end)

    return {
        Element = MBFrame,
        GetSelected = function() return Selected end,
        SetSelected = function(V) SelectOption(V) end,
        SetCallback = function(C) Callback = C end,
    }
end

function TerminScriptsLib:TSBadgeRow(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Label = Config.Label or ""
    local Badges = Config.Badges or {}

    local RowFrame = Instance.new("Frame")
    RowFrame.Name = "TSBadgeRow"
    RowFrame.Size = UDim2.new(1, 0, 0, 38 * Scale)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = #Section.Elements + 1
    RowFrame.Parent = Section.ContentContainer

    if Label ~= "" then
        local LText = Instance.new("TextLabel")
        LText.Size = UDim2.new(0, 110 * Scale, 1, 0)
        LText.BackgroundTransparency = 1
        LText.Text = Label
        LText.TextColor3 = Theme.TextSecondary
        LText.TextSize = 12 * Scale
        LText.Font = Enum.Font.GothamSemibold
        LText.TextXAlignment = Enum.TextXAlignment.Left
        LText.Parent = RowFrame
    end

    local BadgeContainer = Instance.new("Frame")
    BadgeContainer.Size = UDim2.new(1, Label ~= "" and -114 * Scale or 0, 1, 0)
    BadgeContainer.Position = UDim2.new(0, Label ~= "" and 114 * Scale or 0, 0, 0)
    BadgeContainer.BackgroundTransparency = 1
    BadgeContainer.Parent = RowFrame

    local BLayout = Instance.new("UIListLayout")
    BLayout.FillDirection = Enum.FillDirection.Horizontal
    BLayout.Padding = UDim.new(0, 6 * Scale)
    BLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BLayout.Parent = BadgeContainer

    local BadgeObjects = {}
    for _, BData in ipairs(Badges) do
        local BColor = BData.Color or Theme.Primary
        local Badge = Instance.new("Frame")
        Badge.Size = UDim2.new(0, 0, 0, 24 * Scale)
        Badge.BackgroundColor3 = BColor
        Badge.BackgroundTransparency = 0.15
        Badge.BorderSizePixel = 0
        Badge.AutomaticSize = Enum.AutomaticSize.X
        Badge.Parent = BadgeContainer
        AddCorner(Badge, 12 * Scale)
        AddStroke(Badge, 1 * Scale, BColor, 0.4)

        local BPad = Instance.new("UIPadding")
        BPad.PaddingLeft = UDim.new(0, 8 * Scale)
        BPad.PaddingRight = UDim.new(0, 8 * Scale)
        BPad.Parent = Badge

        local BLabel = Instance.new("TextLabel")
        BLabel.Size = UDim2.new(0, 0, 1, 0)
        BLabel.AutomaticSize = Enum.AutomaticSize.X
        BLabel.BackgroundTransparency = 1
        BLabel.Text = BData.Text or "Badge"
        BLabel.TextColor3 = BColor:lerp(Color3.new(1,1,1), 0.4)
        BLabel.TextSize = 10 * Scale
        BLabel.Font = Enum.Font.GothamBold
        BLabel.Parent = Badge

        table.insert(BadgeObjects, Badge)
    end

    table.insert(Section.Elements, RowFrame)
    return {
        Element = RowFrame,
        GetBadges = function() return BadgeObjects end,
    }
end

function TerminScriptsLib:TSCheckbox(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Checkbox"
    local Default = Config.Default or false
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSCheckbox:" .. Text)
    local CurrentValue = Default

    local CFrame = Instance.new("Frame")
    CFrame.Name = "TSCheckbox"
    CFrame.Size = UDim2.new(1, 0, 0, 48 * Scale)
    CFrame.BackgroundColor3 = Theme.Surface
    CFrame.BackgroundTransparency = 0.28
    CFrame.BorderSizePixel = 0
    CFrame.LayoutOrder = #Section.Elements + 1
    CFrame.Parent = Section.ContentContainer
    AddCorner(CFrame, 12 * Scale)
    AddStroke(CFrame, 1 * Scale, Theme.Border, 0.55)

    local CText = Instance.new("TextLabel")
    CText.Size = UDim2.new(1, -70 * Scale, 1, 0)
    CText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    CText.BackgroundTransparency = 1
    CText.Text = Text
    CText.TextColor3 = Theme.TextPrimary
    CText.TextSize = 14 * Scale
    CText.Font = Enum.Font.GothamSemibold
    CText.TextXAlignment = Enum.TextXAlignment.Left
    CText.Parent = CFrame

    local BoxSize = 26 * Scale
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, BoxSize, 0, BoxSize)
    Box.Position = UDim2.new(1, -BoxSize - 14 * Scale, 0.5, -BoxSize / 2)
    Box.BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card
    Box.BorderSizePixel = 0
    Box.Parent = CFrame
    AddCorner(Box, 7 * Scale)
    local BoxStroke = AddStroke(Box, 1.5 * Scale, CurrentValue and Theme.PrimaryGlow or Theme.BorderLight, 0.35)

    local CheckMark = Instance.new("TextLabel")
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.BackgroundTransparency = 1
    CheckMark.Text = "v"
    CheckMark.TextColor3 = Color3.fromRGB(10, 15, 12)
    CheckMark.TextSize = 15 * Scale
    CheckMark.Font = Enum.Font.GothamBlack
    CheckMark.TextTransparency = CurrentValue and 0 or 1
    CheckMark.Parent = Box

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = CFrame

    local function UpdateCheckbox()
        CreateTween(Box, Animations.Fast, {BackgroundColor3 = CurrentValue and Theme.Primary or Theme.Card}):Play()
        CreateTween(BoxStroke, Animations.Fast, {Color = CurrentValue and Theme.PrimaryGlow or Theme.BorderLight}):Play()
        CreateTween(CheckMark, Animations.Fast, {TextTransparency = CurrentValue and 0 or 1}):Play()
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("Checkbox callback error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end

    ClickBtn.MouseButton1Click:Connect(function()
        CurrentValue = not CurrentValue
        UpdateCheckbox()
        CreateRipple(Box, Vector2.new(BoxSize / 2, BoxSize / 2))
    end)
    AddHoverEffect(CFrame, Theme.SurfaceHover, Theme.SurfaceElevated)

    local Ret = {
        Element = CFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = V UpdateCheckbox() end,
        SetCallback = function(C) Callback = C end,
    }
    if Key then
        self:RegisterElement(Key, function() return CurrentValue end, function(V) CurrentValue = V UpdateCheckbox() end)
    end
    table.insert(Section.Elements, CFrame)
    return Ret
end

function TerminScriptsLib:TSRadioGroup(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Options"
    local Options = Config.Options or {}
    local Default = Config.Default or Options[1]
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSRadioGroup:" .. Text)
    local CurrentValue = Default

    local RowHeight = 40 * Scale
    local RFrame = Instance.new("Frame")
    RFrame.Name = "TSRadioGroup"
    RFrame.Size = UDim2.new(1, 0, 0, 34 * Scale + (#Options * RowHeight))
    RFrame.BackgroundColor3 = Theme.Surface
    RFrame.BackgroundTransparency = 0.28
    RFrame.BorderSizePixel = 0
    RFrame.LayoutOrder = #Section.Elements + 1
    RFrame.Parent = Section.ContentContainer
    AddCorner(RFrame, 12 * Scale)
    AddStroke(RFrame, 1 * Scale, Theme.Border, 0.55)

    local RTitle = Instance.new("TextLabel")
    RTitle.Size = UDim2.new(1, -32 * Scale, 0, 26 * Scale)
    RTitle.Position = UDim2.new(0, 16 * Scale, 0, 6 * Scale)
    RTitle.BackgroundTransparency = 1
    RTitle.Text = Text
    RTitle.TextColor3 = Theme.TextPrimary
    RTitle.TextSize = 14 * Scale
    RTitle.Font = Enum.Font.GothamSemibold
    RTitle.TextXAlignment = Enum.TextXAlignment.Left
    RTitle.Parent = RFrame

    local OptionCircles = {}
    local function RefreshOptions()
        for _, Data in ipairs(OptionCircles) do
            local IsSelected = Data.Value == CurrentValue
            CreateTween(Data.Circle, Animations.Fast, {BackgroundColor3 = IsSelected and Theme.Primary or Theme.Card}):Play()
            CreateTween(Data.Dot, Animations.Fast, {BackgroundTransparency = IsSelected and 0 or 1}):Play()
        end
    end

    for Index, OptionValue in ipairs(Options) do
        local OptionRow = Instance.new("TextButton")
        OptionRow.Size = UDim2.new(1, -32 * Scale, 0, RowHeight - 6 * Scale)
        OptionRow.Position = UDim2.new(0, 16 * Scale, 0, 32 * Scale + (Index - 1) * RowHeight)
        OptionRow.BackgroundTransparency = 1
        OptionRow.Text = ""
        OptionRow.Parent = RFrame

        local CircleSize = 20 * Scale
        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, CircleSize, 0, CircleSize)
        Circle.Position = UDim2.new(0, 0, 0.5, -CircleSize / 2)
        Circle.BackgroundColor3 = OptionValue == CurrentValue and Theme.Primary or Theme.Card
        Circle.BorderSizePixel = 0
        Circle.Parent = OptionRow
        AddCorner(Circle, CircleSize / 2)
        AddStroke(Circle, 1.5 * Scale, Theme.BorderLight, 0.35)

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, CircleSize - 10 * Scale, 0, CircleSize - 10 * Scale)
        Dot.Position = UDim2.new(0.5, -(CircleSize - 10 * Scale) / 2, 0.5, -(CircleSize - 10 * Scale) / 2)
        Dot.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
        Dot.BackgroundTransparency = OptionValue == CurrentValue and 0 or 1
        Dot.BorderSizePixel = 0
        Dot.Parent = Circle
        AddCorner(Dot, (CircleSize - 10 * Scale) / 2)

        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -CircleSize - 12 * Scale, 1, 0)
        OptionLabel.Position = UDim2.new(0, CircleSize + 12 * Scale, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = tostring(OptionValue)
        OptionLabel.TextColor3 = Theme.TextSecondary
        OptionLabel.TextSize = 13 * Scale
        OptionLabel.Font = Enum.Font.GothamMedium
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionRow

        table.insert(OptionCircles, {Circle = Circle, Dot = Dot, Value = OptionValue})

        OptionRow.MouseButton1Click:Connect(function()
            if CurrentValue == OptionValue then return end
            CurrentValue = OptionValue
            RefreshOptions()
            local Ok, Err = pcall(Callback, CurrentValue)
            if not Ok then warn("RadioGroup callback error:", Err) end
            if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
                task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
            end
        end)
    end

    local Ret = {
        Element = RFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = V RefreshOptions() end,
        SetCallback = function(C) Callback = C end,
    }
    if Key then
        self:RegisterElement(Key, function() return CurrentValue end, function(V) CurrentValue = V RefreshOptions() end)
    end
    table.insert(Section.Elements, RFrame)
    return Ret
end

function TerminScriptsLib:TSNumberStepper(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Value"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Step = Config.Step or 1
    local Default = Config.Default or Min
    local Callback = Config.Callback or function() end
    local Key = Config.Key or ("TSNumberStepper:" .. Text)
    local CurrentValue = Default

    local NFrame = Instance.new("Frame")
    NFrame.Name = "TSNumberStepper"
    NFrame.Size = UDim2.new(1, 0, 0, 52 * Scale)
    NFrame.BackgroundColor3 = Theme.Surface
    NFrame.BackgroundTransparency = 0.28
    NFrame.BorderSizePixel = 0
    NFrame.LayoutOrder = #Section.Elements + 1
    NFrame.Parent = Section.ContentContainer
    AddCorner(NFrame, 12 * Scale)
    AddStroke(NFrame, 1 * Scale, Theme.Border, 0.55)

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -160 * Scale, 1, 0)
    NText.Position = UDim2.new(0, 16 * Scale, 0, 0)
    NText.BackgroundTransparency = 1
    NText.Text = Text
    NText.TextColor3 = Theme.TextPrimary
    NText.TextSize = 14 * Scale
    NText.Font = Enum.Font.GothamSemibold
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.Parent = NFrame

    local function MakeStepBtn(PosX, Label)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 30 * Scale, 0, 30 * Scale)
        Btn.Position = UDim2.new(1, PosX, 0.5, -15 * Scale)
        Btn.BackgroundColor3 = Theme.Card
        Btn.BorderSizePixel = 0
        Btn.Text = Label
        Btn.TextColor3 = Theme.TextPrimary
        Btn.TextSize = 16 * Scale
        Btn.Font = Enum.Font.GothamBold
        Btn.Parent = NFrame
        AddCorner(Btn, 8 * Scale)
        AddStroke(Btn, 1 * Scale, Theme.BorderLight, 0.5)
        AddHoverEffect(Btn, Theme.SurfaceHover, Theme.Card)
        return Btn
    end

    local DecBtn = MakeStepBtn(-146 * Scale, "-")
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60 * Scale, 0, 30 * Scale)
    ValueLabel.Position = UDim2.new(1, -110 * Scale, 0.5, -15 * Scale)
    ValueLabel.BackgroundColor3 = Theme.Card
    ValueLabel.BackgroundTransparency = 0.2
    ValueLabel.BorderSizePixel = 0
    ValueLabel.Text = tostring(CurrentValue)
    ValueLabel.TextColor3 = Theme.Primary
    ValueLabel.TextSize = 13 * Scale
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = NFrame
    AddCorner(ValueLabel, 8 * Scale)
    RegisterColor(ValueLabel, "TextColor3", "Primary")
    local IncBtn = MakeStepBtn(-40 * Scale, "+")

    local function UpdateStepper()
        ValueLabel.Text = tostring(CurrentValue)
        local Ok, Err = pcall(Callback, CurrentValue)
        if not Ok then warn("NumberStepper callback error:", Err) end
        if not Section.Tab.Gui.IsLoadingConfig and Section.Tab.Gui.AutoSaveEnabled and Section.Tab.Gui.CurrentConfigName ~= "" then
            task.delay(0.1, function() Section.Tab.Gui:SaveConfig() end)
        end
    end

    DecBtn.MouseButton1Click:Connect(function()
        CurrentValue = math.clamp(CurrentValue - Step, Min, Max)
        UpdateStepper()
    end)
    IncBtn.MouseButton1Click:Connect(function()
        CurrentValue = math.clamp(CurrentValue + Step, Min, Max)
        UpdateStepper()
    end)
    AddHoverEffect(NFrame, Theme.SurfaceHover, Theme.Surface)

    local Ret = {
        Element = NFrame,
        GetValue = function() return CurrentValue end,
        SetValue = function(V) CurrentValue = math.clamp(V, Min, Max) UpdateStepper() end,
        SetCallback = function(C) Callback = C end,
    }
    if Key then
        self:RegisterElement(Key, function() return CurrentValue end, function(V) CurrentValue = math.clamp(V, Min, Max) UpdateStepper() end)
    end
    table.insert(Section.Elements, NFrame)
    return Ret
end

function TerminScriptsLib:TSCard(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Icon = Config.Icon or "*"
    local Title = Config.Title or "Card"
    local Description = Config.Description or ""
    local Callback = Config.Callback

    local CardFrame = Instance.new(Callback and "TextButton" or "Frame")
    CardFrame.Name = "TSCard"
    CardFrame.Size = UDim2.new(1, 0, 0, 66 * Scale)
    CardFrame.BackgroundColor3 = Theme.Surface
    CardFrame.BackgroundTransparency = 0.25
    CardFrame.BorderSizePixel = 0
    CardFrame.LayoutOrder = #Section.Elements + 1
    CardFrame.Parent = Section.ContentContainer
    if Callback then
        CardFrame.Text = ""
        CardFrame.AutoButtonColor = false
    end
    AddCorner(CardFrame, 14 * Scale)
    AddStroke(CardFrame, 1 * Scale, Theme.BorderLight, 0.5)

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 42 * Scale, 0, 42 * Scale)
    IconFrame.Position = UDim2.new(0, 12 * Scale, 0.5, -21 * Scale)
    IconFrame.BackgroundColor3 = Theme.Primary
    IconFrame.BackgroundTransparency = 0.85
    IconFrame.BorderSizePixel = 0
    IconFrame.Parent = CardFrame
    AddCorner(IconFrame, 12 * Scale)

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icon
    IconLabel.TextColor3 = Theme.Primary
    IconLabel.TextSize = 18 * Scale
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Parent = IconFrame
    RegisterColor(IconLabel, "TextColor3", "Primary")

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70 * Scale, 0, 20 * Scale)
    TitleLabel.Position = UDim2.new(0, 64 * Scale, 0, 12 * Scale)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.TextPrimary
    TitleLabel.TextSize = 14 * Scale
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = CardFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -70 * Scale, 0, 28 * Scale)
    DescLabel.Position = UDim2.new(0, 64 * Scale, 0, 32 * Scale)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Description
    DescLabel.TextColor3 = Theme.TextMuted
    DescLabel.TextSize = 11 * Scale
    DescLabel.TextWrapped = true
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = CardFrame

    if Callback then
        CardFrame.MouseButton1Click:Connect(function()
            CreateRipple(CardFrame, Vector2.new(CardFrame.AbsoluteSize.X / 2, CardFrame.AbsoluteSize.Y / 2))
            local Ok, Err = pcall(Callback)
            if not Ok then warn("Card callback error:", Err) end
        end)
        AddHoverEffect(CardFrame, Theme.SurfaceHover, Theme.Surface)
    end

    table.insert(Section.Elements, CardFrame)
    return {
        Element = CardFrame,
        SetTitle = function(T) TitleLabel.Text = T end,
        SetDescription = function(D) DescLabel.Text = D end,
    }
end

function TerminScriptsLib:TSCodeBlock(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Code = Config.Code or ""
    local Label = Config.Label or "Snippet"

    local Lines = 1
    for _ in string.gmatch(Code, "\n") do Lines = Lines + 1 end
    local BoxHeight = math.clamp(34 * Scale + Lines * 16 * Scale, 70 * Scale, 220 * Scale)

    local CBFrame = Instance.new("Frame")
    CBFrame.Name = "TSCodeBlock"
    CBFrame.Size = UDim2.new(1, 0, 0, BoxHeight)
    CBFrame.BackgroundColor3 = Theme.Card
    CBFrame.BackgroundTransparency = 0.1
    CBFrame.BorderSizePixel = 0
    CBFrame.LayoutOrder = #Section.Elements + 1
    CBFrame.Parent = Section.ContentContainer
    AddCorner(CBFrame, 12 * Scale)
    AddStroke(CBFrame, 1 * Scale, Theme.BorderLight, 0.5)

    local LabelText = Instance.new("TextLabel")
    LabelText.Size = UDim2.new(1, -90 * Scale, 0, 24 * Scale)
    LabelText.Position = UDim2.new(0, 14 * Scale, 0, 6 * Scale)
    LabelText.BackgroundTransparency = 1
    LabelText.Text = Label
    LabelText.TextColor3 = Theme.TextMuted
    LabelText.TextSize = 11 * Scale
    LabelText.Font = Enum.Font.GothamBold
    LabelText.TextXAlignment = Enum.TextXAlignment.Left
    LabelText.Parent = CBFrame

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 64 * Scale, 0, 22 * Scale)
    CopyBtn.Position = UDim2.new(1, -76 * Scale, 0, 6 * Scale)
    CopyBtn.BackgroundColor3 = Theme.Primary
    CopyBtn.BackgroundTransparency = 0.85
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "Copy"
    CopyBtn.TextColor3 = Theme.Primary
    CopyBtn.TextSize = 11 * Scale
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.Parent = CBFrame
    AddCorner(CopyBtn, 7 * Scale)

    local ScrollBox = Instance.new("ScrollingFrame")
    ScrollBox.Size = UDim2.new(1, -24 * Scale, 1, -38 * Scale)
    ScrollBox.Position = UDim2.new(0, 12 * Scale, 0, 32 * Scale)
    ScrollBox.BackgroundTransparency = 1
    ScrollBox.BorderSizePixel = 0
    ScrollBox.ScrollBarThickness = 3 * Scale
    ScrollBox.ScrollBarImageColor3 = Theme.Primary
    ScrollBox.CanvasSize = UDim2.new(0, 0, 0, Lines * 16 * Scale + 6 * Scale)
    ScrollBox.Parent = CBFrame

    local CodeText = Instance.new("TextLabel")
    CodeText.Size = UDim2.new(1, 0, 0, Lines * 16 * Scale + 6 * Scale)
    CodeText.BackgroundTransparency = 1
    CodeText.Text = Code
    CodeText.TextColor3 = Theme.TextSecondary
    CodeText.TextSize = 12 * Scale
    CodeText.Font = Enum.Font.Code
    CodeText.TextXAlignment = Enum.TextXAlignment.Left
    CodeText.TextYAlignment = Enum.TextYAlignment.Top
    CodeText.TextWrapped = true
    CodeText.Parent = ScrollBox

    CopyBtn.MouseButton1Click:Connect(function()
        local Ok = pcall(function() setclipboard(Code) end)
        CopyBtn.Text = Ok and "Copied" or "Failed"
        task.delay(1.2, function() if CopyBtn and CopyBtn.Parent then CopyBtn.Text = "Copy" end end)
    end)

    table.insert(Section.Elements, CBFrame)
    return {
        Element = CBFrame,
        SetCode = function(C) CodeText.Text = C end,
    }
end

function TerminScriptsLib:TSStatDisplay(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Label = Config.Label or "Stat"
    local Value = Config.Value or "0"
    local Icon = Config.Icon or "#"

    local SFrame = Instance.new("Frame")
    SFrame.Name = "TSStatDisplay"
    SFrame.Size = UDim2.new(1, 0, 0, 58 * Scale)
    SFrame.BackgroundColor3 = Theme.Surface
    SFrame.BackgroundTransparency = 0.25
    SFrame.BorderSizePixel = 0
    SFrame.LayoutOrder = #Section.Elements + 1
    SFrame.Parent = Section.ContentContainer
    AddCorner(SFrame, 12 * Scale)
    AddStroke(SFrame, 1 * Scale, Theme.BorderLight, 0.5)

    local IconFrame = Instance.new("Frame")
    IconFrame.Size = UDim2.new(0, 36 * Scale, 0, 36 * Scale)
    IconFrame.Position = UDim2.new(0, 12 * Scale, 0.5, -18 * Scale)
    IconFrame.BackgroundColor3 = Theme.Primary
    IconFrame.BackgroundTransparency = 0.85
    IconFrame.BorderSizePixel = 0
    IconFrame.Parent = SFrame
    AddCorner(IconFrame, 10 * Scale)

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icon
    IconLabel.TextColor3 = Theme.Primary
    IconLabel.TextSize = 15 * Scale
    IconLabel.Font = Enum.Font.GothamBlack
    IconLabel.Parent = IconFrame
    RegisterColor(IconLabel, "TextColor3", "Primary")

    local LabelText = Instance.new("TextLabel")
    LabelText.Size = UDim2.new(0.5, -60 * Scale, 0, 16 * Scale)
    LabelText.Position = UDim2.new(0, 58 * Scale, 0, 10 * Scale)
    LabelText.BackgroundTransparency = 1
    LabelText.Text = Label
    LabelText.TextColor3 = Theme.TextMuted
    LabelText.TextSize = 11 * Scale
    LabelText.Font = Enum.Font.Gotham
    LabelText.TextXAlignment = Enum.TextXAlignment.Left
    LabelText.Parent = SFrame

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(0.5, -60 * Scale, 0, 22 * Scale)
    ValueText.Position = UDim2.new(0, 58 * Scale, 0, 26 * Scale)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = tostring(Value)
    ValueText.TextColor3 = Theme.TextPrimary
    ValueText.TextSize = 16 * Scale
    ValueText.Font = Enum.Font.GothamBlack
    ValueText.TextXAlignment = Enum.TextXAlignment.Left
    ValueText.Parent = SFrame

    table.insert(Section.Elements, SFrame)
    return {
        Element = SFrame,
        SetValue = function(V) ValueText.Text = tostring(V) end,
        SetLabel = function(L) LabelText.Text = L end,
    }
end

function TerminScriptsLib:TSImage(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local ImageId = Config.ImageId or "rbxassetid://0"
    local Height = Config.Height or 140

    local IFrame = Instance.new("Frame")
    IFrame.Name = "TSImage"
    IFrame.Size = UDim2.new(1, 0, 0, Height * Scale)
    IFrame.BackgroundColor3 = Theme.Card
    IFrame.BackgroundTransparency = 0.2
    IFrame.BorderSizePixel = 0
    IFrame.LayoutOrder = #Section.Elements + 1
    IFrame.Parent = Section.ContentContainer
    AddCorner(IFrame, 14 * Scale)
    AddStroke(IFrame, 1 * Scale, Theme.BorderLight, 0.5)
    IFrame.ClipsDescendants = true

    local ImageLbl = Instance.new("ImageLabel")
    ImageLbl.Size = UDim2.new(1, 0, 1, 0)
    ImageLbl.BackgroundTransparency = 1
    ImageLbl.Image = ImageId
    ImageLbl.ScaleType = Enum.ScaleType.Crop
    ImageLbl.Parent = IFrame

    table.insert(Section.Elements, IFrame)
    return {
        Element = IFrame,
        SetImage = function(Id) ImageLbl.Image = Id end,
    }
end

function TerminScriptsLib:TSSpacer(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Height = Config.Height or 12

    local SpacerFrame = Instance.new("Frame")
    SpacerFrame.Name = "TSSpacer"
    SpacerFrame.Size = UDim2.new(1, 0, 0, Height * Scale)
    SpacerFrame.BackgroundTransparency = 1
    SpacerFrame.LayoutOrder = #Section.Elements + 1
    SpacerFrame.Parent = Section.ContentContainer

    table.insert(Section.Elements, SpacerFrame)
    return {Element = SpacerFrame}
end

function TerminScriptsLib:TSFileDropdown(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "File"
    local Folder = Config.Folder or ""
    local Extension = Config.Extension
    local Callback = Config.Callback or function() end
    local CurrentValue = nil

    local function ScanFiles()
        local Results = {}
        local Ok, FileList = pcall(function() return listfiles(Folder) end)
        if Ok and FileList then
            for _, FullPath in ipairs(FileList) do
                local FileName = FullPath:match("([^/\\]+)$") or FullPath
                if not Extension or FileName:sub(-#Extension) == Extension then
                    table.insert(Results, FileName)
                end
            end
        end
        return Results
    end

    return self:TSDropdown(Section, {
        Text = Text,
        Options = ScanFiles(),
        Callback = Callback,
        Default = CurrentValue,
    })
end

function TerminScriptsLib:TSKeybindDisplay(Section, Config)
    Config = Config or {}
    local Scale = ScalingManager.CurrentScale
    local Text = Config.Text or "Hotkey"
    local Keybind = Config.Keybind

    local KFrame = Instance.new("Frame")
    KFrame.Name = "TSKeybindDisplay"
    KFrame.Size = UDim2.new(1, 0, 0, 44 * Scale)
    KFrame.BackgroundColor3 = Theme.Surface
    KFrame.BackgroundTransparency = 0.3
    KFrame.BorderSizePixel = 0
    KFrame.LayoutOrder = #Section.Elements + 1
    KFrame.Parent = Section.ContentContainer
    AddCorner(KFrame, 10 * Scale)
    AddStroke(KFrame, 1 * Scale, Theme.Border, 0.55)

    local KText = Instance.new("TextLabel")
    KText.Size = UDim2.new(1, -100 * Scale, 1, 0)
    KText.Position = UDim2.new(0, 14 * Scale, 0, 0)
    KText.BackgroundTransparency = 1
    KText.Text = Text
    KText.TextColor3 = Theme.TextSecondary
    KText.TextSize = 13 * Scale
    KText.Font = Enum.Font.GothamMedium
    KText.TextXAlignment = Enum.TextXAlignment.Left
    KText.Parent = KFrame

    local KeyPill = Instance.new("Frame")
    KeyPill.Size = UDim2.new(0, 70 * Scale, 0, 26 * Scale)
    KeyPill.Position = UDim2.new(1, -84 * Scale, 0.5, -13 * Scale)
    KeyPill.BackgroundColor3 = Theme.KeybindGrey
    KeyPill.BackgroundTransparency = 0.15
    KeyPill.BorderSizePixel = 0
    KeyPill.Parent = KFrame
    AddCorner(KeyPill, 8 * Scale)
    AddStroke(KeyPill, 1.5 * Scale, Theme.Primary, 0.4)

    local KeyPillText = Instance.new("TextLabel")
    KeyPillText.Size = UDim2.new(1, 0, 1, 0)
    KeyPillText.BackgroundTransparency = 1
    KeyPillText.Text = Keybind and Keybind.Name or "None"
    KeyPillText.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyPillText.TextSize = 11 * Scale
    KeyPillText.Font = Enum.Font.GothamBold
    KeyPillText.TextScaled = true
    KeyPillText.Parent = KeyPill

    table.insert(Section.Elements, KFrame)
    return {
        Element = KFrame,
        SetKeybind = function(NewKeybind) KeyPillText.Text = NewKeybind and NewKeybind.Name or "None" end,
    }
end


function TerminScriptsLib:Notify(Title, Message, NotifType, Duration)
    Duration = Duration or 4
    NotifType = NotifType or "info"
    local Scale = ScalingManager.CurrentScale
    local TypeColors = {
        success = Theme.Success, error = Theme.Error,
        warning = Theme.Warning, info = Theme.Primary,
    }
    local TypeSymbols = {success = "+", error = "x", warning = "!", info = "i"}
    local Color = TypeColors[NotifType] or Theme.Primary
    local Symbol = TypeSymbols[NotifType] or "i"
    local NW = 295 * Scale
    local NH = 68 * Scale
    local Padding = 8 * Scale
    local YOffset = Padding + (#ActiveNotifications * (NH + Padding))

    local NotificationGui = self.ScreenGui
    if not NotificationGui or not NotificationGui.Parent then
        NotificationGui = PlayerGui:FindFirstChild("TerminScriptsNotifications")
        if not NotificationGui then
            NotificationGui = Instance.new("ScreenGui")
            NotificationGui.Name = "TerminScriptsNotifications"
            NotificationGui.Parent = PlayerGui
            NotificationGui.ResetOnSpawn = false
            NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotificationGui.IgnoreGuiInset = true
            NotificationGui.DisplayOrder = 1001
        end
    end

    local NFrame = Instance.new("Frame")
    NFrame.Name = "Notification"
    NFrame.Size = UDim2.new(0, NW, 0, NH)
    NFrame.Position = UDim2.new(1, NW + 20 * Scale, 1, -(YOffset + NH))
    NFrame.BackgroundColor3 = Theme.Card
    NFrame.BackgroundTransparency = 0.06
    NFrame.BorderSizePixel = 0
    NFrame.ZIndex = 500
    NFrame.Parent = NotificationGui
    AddCorner(NFrame, 13 * Scale)
    AddStroke(NFrame, 1.5 * Scale, Color, 0.25)

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 2.5 * Scale, 1, -14 * Scale)
    AccentLine.Position = UDim2.new(0, 0, 0, 7 * Scale)
    AccentLine.BackgroundColor3 = Color
    AccentLine.BorderSizePixel = 0
    AccentLine.ZIndex = 501
    AccentLine.Parent = NFrame
    AddCorner(AccentLine, 2 * Scale)

    local IconBg = Instance.new("Frame")
    IconBg.Size = UDim2.new(0, 26 * Scale, 0, 26 * Scale)
    IconBg.Position = UDim2.new(0, 10 * Scale, 0.5, -13 * Scale)
    IconBg.BackgroundColor3 = Color
    IconBg.BackgroundTransparency = 0.8
    IconBg.BorderSizePixel = 0
    IconBg.ZIndex = 501
    IconBg.Parent = NFrame
    AddCorner(IconBg, 8 * Scale)

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Symbol
    IconLabel.TextColor3 = Color
    IconLabel.TextSize = 13 * Scale
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.ZIndex = 502
    IconLabel.Parent = IconBg

    local TitleL = Instance.new("TextLabel")
    TitleL.Size = UDim2.new(1, -52 * Scale, 0, 20 * Scale)
    TitleL.Position = UDim2.new(0, 46 * Scale, 0, 12 * Scale)
    TitleL.BackgroundTransparency = 1
    TitleL.Text = Title
    TitleL.TextColor3 = Theme.TextPrimary
    TitleL.TextSize = 13 * Scale
    TitleL.Font = Enum.Font.GothamBold
    TitleL.TextXAlignment = Enum.TextXAlignment.Left
    TitleL.ZIndex = 501
    TitleL.Parent = NFrame

    local MsgL = Instance.new("TextLabel")
    MsgL.Size = UDim2.new(1, -52 * Scale, 0, 18 * Scale)
    MsgL.Position = UDim2.new(0, 46 * Scale, 0, 33 * Scale)
    MsgL.BackgroundTransparency = 1
    MsgL.Text = Message
    MsgL.TextColor3 = Theme.TextSecondary
    MsgL.TextSize = 11 * Scale
    MsgL.Font = Enum.Font.Gotham
    MsgL.TextXAlignment = Enum.TextXAlignment.Left
    MsgL.ZIndex = 501
    MsgL.Parent = NFrame

    local ProgTrack = Instance.new("Frame")
    ProgTrack.Size = UDim2.new(1, -10 * Scale, 0, 3 * Scale)
    ProgTrack.Position = UDim2.new(0, 5 * Scale, 1, -5 * Scale)
    ProgTrack.BackgroundColor3 = Theme.Card
    ProgTrack.BorderSizePixel = 0
    ProgTrack.ZIndex = 501
    ProgTrack.Parent = NFrame
    AddCorner(ProgTrack, 1 * Scale)
    local ProgFill = Instance.new("Frame")
    ProgFill.Size = UDim2.new(1, 0, 1, 0)
    ProgFill.BackgroundColor3 = Color
    ProgFill.BorderSizePixel = 0
    ProgFill.ZIndex = 502
    ProgFill.Parent = ProgTrack
    AddCorner(ProgFill, 1 * Scale)
    CreateTween(ProgFill, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    NFrame.MouseEnter:Connect(function()
        CreateTween(NFrame, Animations.Fast, {BackgroundTransparency = 0.0}):Play()
    end)
    NFrame.MouseLeave:Connect(function()
        CreateTween(NFrame, Animations.Fast, {BackgroundTransparency = 0.06}):Play()
    end)

    table.insert(ActiveNotifications, NFrame)
    CreateTween(NFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -(NW + 12 * Scale), 1, -(YOffset + NH))
    }):Play()

    task.delay(Duration, function()
        local T = CreateTween(NFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, NW + 20 * Scale, 1, -(YOffset + NH)),
            BackgroundTransparency = 1
        })
        T:Play()
        T.Completed:Connect(function()
            for I, N in ipairs(ActiveNotifications) do
                if N == NFrame then table.remove(ActiveNotifications, I) break end
            end
            NFrame:Destroy()
            for I, N in ipairs(ActiveNotifications) do
                local TargetY = -(Padding + (I - 1) * (NH + Padding) + NH)
                CreateTween(N, Animations.Normal, {Position = UDim2.new(1, -(NW + 12 * Scale), 1, TargetY)}):Play()
            end
        end)
    end)
end

function TerminScriptsLib:SetTheme(ThemeName)
    local Preset = ThemePresets[ThemeName]
    if not Preset then return end
    self.CurrentThemeName = ThemeName
    for Key, Value in pairs(Preset) do
        Theme[Key] = Value
    end
    Theme.Success = Color3.fromRGB(72, 180, 110)
    Theme.PrimaryText = GetContrastText(Theme.Primary)
    for I = #ThemeColorRegistry, 1, -1 do
        local Entry = ThemeColorRegistry[I]
        if not Entry.Object or not Entry.Object.Parent then
            table.remove(ThemeColorRegistry, I)
        else
            local NewColor = Theme[Entry.ThemeKey]
            if NewColor then
                pcall(function() Entry.Object[Entry.Property] = NewColor end)
            end
        end
    end
    for I = #ThemeGradientRegistry, 1, -1 do
        local Entry = ThemeGradientRegistry[I]
        if not Entry.Gradient or not Entry.Gradient.Parent then
            table.remove(ThemeGradientRegistry, I)
        else
            pcall(function() Entry.Gradient.Color = Entry.BuildFn() end)
        end
    end
    local NotifTypes = {
        Emerald = "success", Neon = "info", Cyberpunk = "warning", Ocean = "info", Crimson = "error"
    }
    local ThemeNames = {
        Emerald = "Neon White", Neon = "Neon Purple", Cyberpunk = "Cyberpunk Gold",
        Ocean = "Ocean Cyan", Crimson = "Crimson Red"
    }
    self:Notify("Theme Applied", ThemeNames[ThemeName] or ThemeName, NotifTypes[ThemeName] or "info", 3)
end

function TerminScriptsLib:SetupControls()
    self.MinimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)
    self.MaximizeBtn.MouseButton1Click:Connect(function() self:Maximize() end)
    self.CloseBtn.MouseButton1Click:Connect(function() self:Destroy() end)
end

function TerminScriptsLib:SetupDragging()
    local DragStart, StartPos
    local Dragging = false
    self.Header.InputBegan:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not self.IsMaximized then
            Dragging = true
            DragStart = Input.Position
            StartPos = self.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
            local D = Input.Position - DragStart
            self.MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + D.X, StartPos.Y.Scale, StartPos.Y.Offset + D.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
    end)
end

function TerminScriptsLib:SetupKeybinds()
    KeybindManager:Bind(self.KeybindToggle, function() self:Toggle() end)
end

function TerminScriptsLib:SetupScaling()
    local Conn
    Conn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        ScalingManager:CalculateScale()
    end)
    self.ScaleConnection = Conn
end

function TerminScriptsLib:Minimize()
    self.IsMinimized = not self.IsMinimized
    local TS = self.IsMinimized and UDim2.new(0, 340 * ScalingManager.CurrentScale, 0, 86 * ScalingManager.CurrentScale) or self.OriginalSize
    local TT = self.IsMinimized and 0.6 or Theme.GlassMain
    CreateTween(self.MainFrame, Animations.Spring, {Size = TS, BackgroundTransparency = TT}):Play()
    if self.IsMinimized then
        CreateTween(self.ContentArea, Animations.Fast, {BackgroundTransparency = 1}):Play()
        task.delay(0.18, function() if self.ContentArea then self.ContentArea.Visible = false end end)
    else
        self.ContentArea.Visible = true
        self.ContentArea.BackgroundTransparency = 1
    end
    self.MinimizeBtn.Text = self.IsMinimized and "+" or "-"
end

function TerminScriptsLib:Maximize()
    self.IsMaximized = not self.IsMaximized
    local Camera = workspace.CurrentCamera
    local SS = Camera.ViewportSize
    local Scale = ScalingManager.CurrentScale
    local TS = self.IsMaximized and UDim2.new(0, SS.X - 80 * Scale, 0, SS.Y - 80 * Scale) or self.OriginalSize
    local TP = self.IsMaximized and UDim2.new(0, 40 * Scale, 0, 40 * Scale) or self.OriginalPosition
    CreateTween(self.MainFrame, Animations.Back, {Size = TS, Position = TP}):Play()
    self.MaximizeBtn.Text = self.IsMaximized and "o" or "+"
end

function TerminScriptsLib:Toggle()
    self.IsVisible = not self.IsVisible
    if self.IsVisible then
        self.ScreenGui.Enabled = true
        self:PlayEntranceAnimation()
    else
        CreateTween(self.MainFrame, Animations.FadeOut, {BackgroundTransparency = 1}):Play()
        task.delay(0.25, function() if self.ScreenGui then self.ScreenGui.Enabled = false end end)
    end
end

function TerminScriptsLib:Destroy()
    KeybindManager:UnbindAll()
    if self.ScaleConnection then self.ScaleConnection:Disconnect() end
    DropdownManager:CloseAll()
    if self.ScreenGui then
        local DT = CreateTween(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, self.MainFrame.Size.X.Offset * 0.92, 0, self.MainFrame.Size.Y.Offset * 0.92)
        })
        DT:Play()
        DT.Completed:Connect(function() self.ScreenGui:Destroy() end)
    end
end

function TerminScriptsLib:RegisterElement(Key, GetFn, SetFn, DefaultValue)
    if not Key then
        if not self._AutoKeyCounter then self._AutoKeyCounter = 0 end
        self._AutoKeyCounter = self._AutoKeyCounter + 1
        Key = "_auto_" .. tostring(self._AutoKeyCounter)
    end
    if DefaultValue == nil and type(GetFn) == "function" then
        local Ok, Value = pcall(GetFn)
        if Ok then DefaultValue = Value end
    end
    local BaseKey = tostring(Key)
    local Existing = false
    for _, E in ipairs(self.ConfigRegistry) do
        if E.Key == BaseKey then Existing = true break end
    end
    if Existing then
        local Suffix = 2
        local Candidate = BaseKey .. "#" .. tostring(Suffix)
        while true do
            local Used = false
            for _, E in ipairs(self.ConfigRegistry) do
                if E.Key == Candidate then Used = true break end
            end
            if not Used then
                Key = Candidate
                break
            end
            Suffix = Suffix + 1
            Candidate = BaseKey .. "#" .. tostring(Suffix)
        end
    end
    table.insert(self.ConfigRegistry, {Key = Key, Get = GetFn, Set = SetFn, Default = DefaultValue})
    self:ScheduleAutoLoad()
end

function TerminScriptsLib:GetLastConfigPath()
    return self.ConfigFolderName .. "/.lastconfig.txt"
end

function TerminScriptsLib:SetLastConfigName(Name)
    if not Name or Name == "" then return false end
    local Folder = self.ConfigFolderName
    local Ok = pcall(function()
        if not isfolder(Folder) then makefolder(Folder) end
        writefile(self:GetLastConfigPath(), tostring(Name))
    end)
    return Ok
end

function TerminScriptsLib:GetLastConfigName()
    local Ok, Name = pcall(function() return readfile(self:GetLastConfigPath()) end)
    if Ok and type(Name) == "string" then
        Name = Name:gsub("[\r\n]", "")
        if Name ~= "" then return Name end
    end
    return nil
end

function TerminScriptsLib:ResolveAutoLoadConfigName()
    if self.AutoLoadConfigName and self.AutoLoadConfigName ~= "" then
        local Path = self.ConfigFolderName .. "/" .. self.AutoLoadConfigName .. ".json"
        local Ok = pcall(function() return isfile(Path) end)
        if Ok and isfile(Path) then return self.AutoLoadConfigName end
    end

    if self.CurrentConfigName and self.CurrentConfigName ~= "" then
        local Path = self.ConfigFolderName .. "/" .. self.CurrentConfigName .. ".json"
        local Ok, Exists = pcall(function() return isfile(Path) end)
        if Ok and Exists then return self.CurrentConfigName end
    end

    local LastName = self:GetLastConfigName()
    if LastName then
        local Path = self.ConfigFolderName .. "/" .. LastName .. ".json"
        local Ok, Exists = pcall(function() return isfile(Path) end)
        if Ok and Exists then return LastName end
    end

    local Names = self:GetConfigList()
    if #Names == 1 then return Names[1] end
    return nil
end

function TerminScriptsLib:TryAutoLoadConfig()
    if not self.AutoLoadConfigEnabled or self.IsLoadingConfig or self._AutoLoadAttempted then return false end
    self._AutoLoadAttempted = true

    local Name = self:ResolveAutoLoadConfigName()
    if not Name then return false end

    local Success = self:LoadConfig(Name)
    if Success then
        self.CurrentConfigName = Name
        return true
    end
    return false
end

function TerminScriptsLib:ScheduleAutoLoad()
    if not self.AutoLoadConfigEnabled then return end

    -- Debounce by generation rather than by a single boolean so a script
    -- registering many controls has time to finish before config is applied.
    self._AutoLoadGeneration = (self._AutoLoadGeneration or 0) + 1
    local Generation = self._AutoLoadGeneration
    self._AutoLoadScheduled = true

    task.delay(self.AutoLoadDelay, function()
        if not self or not self.ScreenGui or not self.ScreenGui.Parent then return end
        if Generation ~= self._AutoLoadGeneration then return end
        self._AutoLoadScheduled = false
        self:TryAutoLoadConfig()
    end)
end

local function CleanConfigName(Name)
    Name = tostring(Name or ""):gsub("[/:*?<>|%c]", ""):gsub("\\", ""):gsub('"', ""):gsub("^%s+", ""):gsub("%s+$", "")
    return Name:sub(1, 64)
end

function TerminScriptsLib:SaveConfig(Name)
    Name = CleanConfigName(Name or self.CurrentConfigName)
    if Name == "" then return false end
    local Folder = self.ConfigFolderName
    pcall(function() if not isfolder(Folder) then makefolder(Folder) end end)
    local Data = {}
    for _, E in ipairs(self.ConfigRegistry) do
        local Ok, Val = pcall(E.Get)
        if Ok then Data[E.Key] = SerializeValue(Val) end
    end
    local Ok, Encoded = pcall(function() return HttpService:JSONEncode(Data) end)
    if not Ok then return false end
    local Written = pcall(function() writefile(Folder .. "/" .. Name .. ".json", Encoded) end)
    if Written then
        self.CurrentConfigName = Name
        self:SetLastConfigName(Name)
        return true
    end
    return false
end

function TerminScriptsLib:LoadConfig(Name, Method)
    Name = CleanConfigName(Name or self.CurrentConfigName)
    if Name == "" then return false end
    Method = Method or self.ConfigLoadMethod or "Merge"
    if Method ~= "Replace" then Method = "Merge" end
    local Path = self.ConfigFolderName .. "/" .. Name .. ".json"
    local Ok1, Content = pcall(function() return readfile(Path) end)
    if not Ok1 or type(Content) ~= "string" or Content == "" then return false end
    local Ok2, Data = pcall(function() return HttpService:JSONDecode(Content) end)
    if not Ok2 or type(Data) ~= "table" then return false end
    self.IsLoadingConfig = true
    self.ConfigLoadMethod = Method
    if Method == "Replace" then
        for _, E in ipairs(self.ConfigRegistry) do
            if E.Default ~= nil then pcall(E.Set, E.Default) end
        end
    end
    local Applied = 0
    local Failed = 0
    for I, E in ipairs(self.ConfigRegistry) do
        local StoredValue = Data[E.Key]
        if StoredValue == nil then StoredValue = Data["_auto_" .. tostring(I)] end
        if StoredValue ~= nil then
            local OkSet, Value = pcall(DeserializeValue, StoredValue)
            if OkSet and Value ~= nil then
                local OkApply = pcall(E.Set, Value)
                if OkApply then Applied = Applied + 1 else Failed = Failed + 1 end
            else
                Failed = Failed + 1
            end
        end
    end
    self.IsLoadingConfig = false
    if Applied > 0 or #self.ConfigRegistry == 0 then
        self.CurrentConfigName = Name
        self:SetLastConfigName(Name)
        self.LastConfigLoadStats = {Applied = Applied, Failed = Failed, Method = Method}
        return true
    end
    self.LastConfigLoadStats = {Applied = 0, Failed = Failed, Method = Method}
    return false
end

function TerminScriptsLib:GetConfigList()
    local Ok, Files = pcall(function() return listfiles(self.ConfigFolderName) end)
    if not Ok or not Files then return {} end
    local Names = {}
    for _, F in ipairs(Files) do
        local N = tostring(F):match("([^/\\]+)%.json$")
        if N then table.insert(Names, N) end
    end
    table.sort(Names)
    return Names
end

function TerminScriptsLib:DeleteConfig(Name)
    Name = CleanConfigName(Name)
    if Name == "" then return false end
    local Path = self.ConfigFolderName .. "/" .. Name .. ".json"
    local Ok = pcall(function()
        if isfile(Path) then delfile(Path) end
    end)
    return Ok
end

function TerminScriptsLib:RenameConfig(OldName, NewName)
    OldName = CleanConfigName(OldName)
    NewName = CleanConfigName(NewName)
    if OldName == "" or NewName == "" or OldName == NewName then return false end
    local OldPath = self.ConfigFolderName .. "/" .. OldName .. ".json"
    local NewPath = self.ConfigFolderName .. "/" .. NewName .. ".json"
    local Ok = pcall(function()
        if isfile(OldPath) then
            local Content = readfile(OldPath)
            writefile(NewPath, Content)
            delfile(OldPath)
            if self.CurrentConfigName == OldName then self.CurrentConfigName = NewName end
        end
    end)
    return Ok
end

function TerminScriptsLib:ExportConfigToClipboard()
    if #self.ConfigRegistry == 0 then return false end
    local Data = {}
    for _, E in ipairs(self.ConfigRegistry) do
        local Ok, Val = pcall(E.Get)
        if Ok then Data[E.Key] = SerializeValue(Val) end
    end
    local Ok, Encoded = pcall(function() return HttpService:JSONEncode(Data) end)
    if not Ok then return false end
    pcall(function() setclipboard(Encoded) end)
    return true
end

function TerminScriptsLib:ImportConfigFromText(Content)
    if type(Content) ~= "string" or Content == "" then return false end
    local Ok, Data = pcall(function() return HttpService:JSONDecode(Content) end)
    if not Ok or type(Data) ~= "table" then return false end
    self.IsLoadingConfig = true
    local Applied = false
    for I, E in ipairs(self.ConfigRegistry) do
        local StoredValue = Data[E.Key]
        if StoredValue == nil then StoredValue = Data["_auto_" .. tostring(I)] end
        if StoredValue ~= nil then
            local OkValue, Value = pcall(DeserializeValue, StoredValue)
            if OkValue then
                local OkApply = pcall(E.Set, Value)
                if OkApply then Applied = true end
            end
        end
    end
    self.IsLoadingConfig = false
    return Applied
end

function TerminScriptsLib:ImportConfigFromClipboard()
    local Ok, Content = pcall(function() return getclipboard() end)
    if not Ok or not Content then return false end
    return self:ImportConfigFromText(Content)
end

function TerminScriptsLib:ResetAllToDefault()
    for _, E in ipairs(self.ConfigRegistry) do
        if E.Default ~= nil then
            pcall(E.Set, E.Default)
        end
    end
end

function TerminScriptsLib:CreateConfigTab()
    local Scale = ScalingManager.CurrentScale
    local ConfigTab = self:CreateTab("Configs")

    local ActiveSection = ConfigTab:CreateSection("Active Config", "Currently loaded configuration")
    local ActiveNameLabel = ActiveSection:TSLabel({
        Text = "Loaded",
        Value = self.CurrentConfigName,
        Style = "info",
    })

    local function RefreshActiveLabel()
        ActiveNameLabel.SetValue(self.CurrentConfigName ~= "" and self.CurrentConfigName or "None")
    end

    ActiveSection:TSButton({
        Text = "Save Current Config",
        Color = Theme.Primary,
        Callback = function()
            if self.CurrentConfigName == "" then
                self:Notify("Config", "No config name set. Create a config first.", "warning", 3)
                return
            end
            local Success = self:SaveConfig()
            if Success then
                self:Notify("Config Saved", self.CurrentConfigName, "success", 2.5)
                RefreshActiveLabel()
            else
                self:Notify("Save Failed", "Could not write config file.", "error", 3)
            end
        end,
    })

    ActiveSection:TSButton({
        Text = "Reload Current Config",
        Color = Theme.Secondary,
        Style = "ghost",
        Callback = function()
            if self.CurrentConfigName == "" then
                self:Notify("Config", "No config loaded.", "warning", 3)
                return
            end
            local Success = self:LoadConfig(nil, self.ConfigLoadMethod)
            if Success then
                self:Notify("Config Loaded", self.CurrentConfigName, "success", 2.5)
                RefreshActiveLabel()
            else
                self:Notify("Load Failed", "Config file not found.", "error", 3)
            end
        end,
    })

    ActiveSection:TSButton({
        Text = "Export to Clipboard",
        Color = Theme.Accent,
        Style = "ghost",
        Callback = function()
            local Ok = self:ExportConfigToClipboard()
            if Ok then
                self:Notify("Exported", "Config copied to clipboard.", "success", 2.5)
            else
                self:Notify("Export Failed", "Could not export config.", "error", 3)
            end
        end,
    })

    local ImportSection = ConfigTab:CreateSection("Import Config", "Paste JSON into the box and apply it")

    local ImportInput = ImportSection:TSTextBox({
        Text = "Config JSON",
        Placeholder = "Paste exported config JSON here...",
        Multiline = true,
    })

    ImportSection:TSButton({
        Text = "Import JSON",
        Color = Theme.Info,
        Callback = function()
            local Ok = self:ImportConfigFromText(ImportInput.GetText())
            if Ok then
                self:Notify("Imported", "Config applied from JSON.", "success", 2.5)
            else
                self:Notify("Import Failed", "The JSON is not a valid config or contains no matching keys.", "error", 3)
            end
        end,
    })

    ImportSection:TSButton({
        Text = "Paste Clipboard",
        Color = Theme.Secondary,
        Style = "ghost",
        Callback = function()
            local Ok, Content = pcall(function() return getclipboard() end)
            if Ok and type(Content) == "string" and Content ~= "" then
                ImportInput.SetText(Content)
                self:Notify("Clipboard", "Clipboard JSON pasted into the import box.", "success", 2.5)
            else
                self:Notify("Clipboard", "Could not read clipboard text.", "error", 3)
            end
        end,
    })

    local ManageSection = ConfigTab:CreateSection("Manage Configs", "Load, delete and rename saved configs")

    local ConfigListOptions = self:GetConfigList()
    if #ConfigListOptions == 0 then table.insert(ConfigListOptions, "(no configs)") end

    local SelectedConfigName = self.CurrentConfigName ~= "" and self.CurrentConfigName or ConfigListOptions[1]

    local ConfigListDropdown = ManageSection:TSDropdown({
        Text = "Select Config",
        Options = ConfigListOptions,
        Default = ConfigListOptions[1],
        Callback = function(V)
            if V and V ~= "(no configs)" then SelectedConfigName = V end
        end,
    })

    local LoadMethodDropdown = ManageSection:TSDropdown({
        Text = "Load Method",
        Options = {"Merge", "Replace"},
        Default = self.ConfigLoadMethod or "Merge",
        Callback = function(V)
            if V == "Replace" then
                self.ConfigLoadMethod = "Replace"
            else
                self.ConfigLoadMethod = "Merge"
            end
        end,
    })

    local AutoLoadOptions = {"(disabled)"}
    for _, Name in ipairs(self:GetConfigList()) do table.insert(AutoLoadOptions, Name) end
    local AutoLoadSelection = self.AutoLoadConfigName ~= "" and self.AutoLoadConfigName or "(disabled)"
    local AutoLoadDropdown = ManageSection:TSDropdown({
        Text = "Auto Load Config",
        Options = AutoLoadOptions,
        Default = AutoLoadSelection,
        Callback = function(V)
            if V == "(disabled)" or V == "(no configs)" then
                self.AutoLoadConfigName = ""
            elseif V then
                self.AutoLoadConfigName = V
            end
        end,
    })

    local function RefreshDropdown()
        local NewList = self:GetConfigList()
        if #NewList == 0 then NewList = {"(no configs)"} end
        ConfigListDropdown.SetOptions(NewList)
        local Preferred = self.CurrentConfigName
        local Found = false
        if Preferred and Preferred ~= "" then
            for _, Name in ipairs(NewList) do
                if Name == Preferred then Found = true break end
            end
        end
        SelectedConfigName = Found and Preferred or NewList[1]
        if Found then ConfigListDropdown.SetSelected(Preferred) end

        local AutoOptions = {"(disabled)"}
        for _, Name in ipairs(NewList) do
            if Name ~= "(no configs)" then table.insert(AutoOptions, Name) end
        end
        AutoLoadDropdown.SetOptions(AutoOptions)
        local AutoPreferred = self.AutoLoadConfigName
        local AutoFound = false
        if AutoPreferred and AutoPreferred ~= "" then
            for _, Name in ipairs(AutoOptions) do
                if Name == AutoPreferred then AutoFound = true break end
            end
        end
        if AutoFound then
            AutoLoadDropdown.SetSelected(AutoPreferred)
        else
            self.AutoLoadConfigName = ""
            AutoLoadDropdown.SetSelected("(disabled)")
        end
    end

    ManageSection:TSButton({
        Text = "Load Selected",
        Color = Theme.Primary,
        Callback = function()
            if not SelectedConfigName or SelectedConfigName == "(no configs)" then
                self:Notify("Config", "No config selected.", "warning", 2.5)
                return
            end
            local ExactSelected = ConfigListDropdown.GetSelected()
            if type(ExactSelected) == "table" then ExactSelected = ExactSelected[1] end
            if ExactSelected and ExactSelected ~= "" and ExactSelected ~= "(no configs)" then
                SelectedConfigName = ExactSelected
            end
            local Method = self.ConfigLoadMethod == "Replace" and "Replace" or "Merge"
            local Success = self:LoadConfig(SelectedConfigName, Method)
            local Stats = self.LastConfigLoadStats or {}
            if Success then
                local Applied = tonumber(Stats.Applied) or 0
                local Failed = tonumber(Stats.Failed) or 0
                local Suffix = Failed > 0 and (" â¢ " .. tostring(Failed) .. " skipped") or ""
                self:Notify("Loaded", SelectedConfigName .. " â¢ " .. tostring(Applied) .. " values" .. Suffix, "success", 3)
                RefreshActiveLabel()
                RefreshDropdown()
            else
                local Failed = tonumber(Stats.Failed) or 0
                self:Notify("Load Failed", "No registered values matched " .. SelectedConfigName .. " (" .. tostring(Failed) .. " failed)", "error", 3.5)
            end
        end,
    })

    ManageSection:TSButton({
        Text = "Delete Selected",
        Color = Theme.Error,
        Style = "ghost",
        Callback = function()
            if not SelectedConfigName or SelectedConfigName == "(no configs)" then
                self:Notify("Config", "No config selected.", "warning", 2.5)
                return
            end
            local Success = self:DeleteConfig(SelectedConfigName)
            if Success then
                self:Notify("Deleted", SelectedConfigName, "error", 2.5)
                if self.CurrentConfigName == SelectedConfigName then self.CurrentConfigName = "" end
                RefreshActiveLabel()
                RefreshDropdown()
            else
                self:Notify("Delete Failed", "Could not delete: " .. SelectedConfigName, "error", 3)
            end
        end,
    })

    ManageSection:TSSeparator({Text = "RENAME"})

    local RenameInput = ManageSection:TSTextBox({
        Text = "New Name",
        Placeholder = "Enter new config name...",
    })

    ManageSection:TSButton({
        Text = "Rename Selected",
        Color = Theme.Warning,
        Style = "ghost",
        Callback = function()
            local NewName = RenameInput.GetText()
            if not SelectedConfigName or SelectedConfigName == "(no configs)" then
                self:Notify("Config", "No config selected.", "warning", 2.5)
                return
            end
            if not NewName or NewName == "" then
                self:Notify("Config", "Enter a new name first.", "warning", 2.5)
                return
            end
            local Success = self:RenameConfig(SelectedConfigName, NewName)
            if Success then
                self:Notify("Renamed", SelectedConfigName .. " -> " .. NewName, "success", 3)
                RefreshActiveLabel()
                RefreshDropdown()
            else
                self:Notify("Rename Failed", "Could not rename config.", "error", 3)
            end
        end,
    })

    local CreateSection = ConfigTab:CreateSection("Create Config", "Save current settings as a new config")

    local NewConfigInput = CreateSection:TSTextBox({
        Text = "Config Name",
        Placeholder = "Enter config name...",
    })

    CreateSection:TSButton({
        Text = "Create & Save",
        Color = Theme.Primary,
        Callback = function()
            local Name = NewConfigInput.GetText()
            if not Name or Name == "" then
                self:Notify("Config", "Enter a config name first.", "warning", 2.5)
                return
            end
            local CleanName = Name:gsub("[^%w%-%_%.%s]", ""):gsub("^%s+", ""):gsub("%s+$", "")
            if CleanName == "" then
                self:Notify("Config", "Invalid config name.", "warning", 2.5)
                return
            end
            local Success = self:SaveConfig(CleanName)
            if Success then
                self:Notify("Created", CleanName .. " saved.", "success", 2.5)
                NewConfigInput.ClearText()
                RefreshActiveLabel()
                RefreshDropdown()
            else
                self:Notify("Create Failed", "Could not save config.", "error", 3)
            end
        end,
    })

    CreateSection:TSButton({
        Text = "Duplicate Active Config",
        Color = Theme.Info,
        Style = "ghost",
        Callback = function()
            if self.CurrentConfigName == "" then
                self:Notify("Config", "No active config to duplicate.", "warning", 3)
                return
            end
            local DupName = NewConfigInput.GetText()
            if not DupName or DupName == "" then DupName = self.CurrentConfigName .. " Copy" end
            local CleanName = DupName:gsub("[^%w%-%_%.%s]", ""):gsub("^%s+", ""):gsub("%s+$", "")
            if CleanName == "" then CleanName = self.CurrentConfigName .. " Copy" end
            local Success = self:SaveConfig(CleanName)
            if Success then
                self.CurrentConfigName = self.CurrentConfigName
                self:Notify("Duplicated", CleanName, "success", 2.5)
                NewConfigInput.ClearText()
                RefreshActiveLabel()
                RefreshDropdown()
            else
                self:Notify("Duplicate Failed", "Could not duplicate config.", "error", 3)
            end
        end,
    })

    local AutoSection = ConfigTab:CreateSection("Auto & Reset", "Automatic saving and reset options")

    AutoSection:TSToggle({
        Text = "Auto Save on Change",
        Default = self.AutoSaveEnabled,
        Callback = function(V)
            self.AutoSaveEnabled = V
            if V and self.CurrentConfigName == "" then
                self:Notify("Auto Save", "Set a config name first.", "warning", 3)
            end
        end,
    })

    AutoSection:TSToggle({
        Text = "Auto Load Config",
        Default = false,
        Callback = function(V)
            self.AutoLoadConfigEnabled = V == true
            self._AutoLoadAttempted = false
            if self.AutoLoadConfigEnabled and not self.IsLoadingConfig then
                local Name = self:ResolveAutoLoadConfigName()
                if Name then
                    self.AutoLoadConfigName = Name
                    local Success = self:LoadConfig(Name)
                    if Success then
                        RefreshActiveLabel()
                        RefreshDropdown()
                        self:Notify("Auto Load", "Loaded " .. Name, "success", 2.5)
                    else
                        self:Notify("Auto Load", "Could not load " .. Name, "warning", 3)
                    end
                else
                    self:Notify("Auto Load", "Select a config above first.", "info", 3)
                end
            end
        end,
    })

    AutoSection:TSButton({
        Text = "Reset All to Default",
        Color = Theme.Error,
        Style = "ghost",
        Callback = function()
            self:ResetAllToDefault()
            self:Notify("Reset", "All values reset to defaults.", "warning", 2.5)
        end,
    })

    return ConfigTab
end

local KeySystemApiBaseUrl = "https://terminkeys.vercel.app/api"
local TerminScriptsVersion = "5.1.5"
local VersionMismatchReason = "Outdated Version Visit terminkeys.vercel.app For New Version"
local KeySystemFolderName = "TerminScriptsLib"
local KeySystemKeyFilePath = KeySystemFolderName .. "/SavedKey.txt"

local function GetHwid()
    local Ok, Id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if Ok and Id and Id ~= "" then return Id end
    return "UID-" .. tostring(Player.UserId)
end

local function SaveKeyToFile(KeyValue)
    pcall(function()
        if not isfolder(KeySystemFolderName) then makefolder(KeySystemFolderName) end
        writefile(KeySystemKeyFilePath, KeyValue)
    end)
end

local function LoadKeyFromFile()
    local Ok, Content = pcall(function()
        if isfile(KeySystemKeyFilePath) then return readfile(KeySystemKeyFilePath) end
        return nil
    end)
    if Ok and Content and Content ~= "" then return Content end
    return nil
end

local function KeySystemRequest(Options)
    local RequestFn = (typeof(request) == "function" and request)
        or (typeof(http_request) == "function" and http_request)
        or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
        or (typeof(fluxus) == "table" and typeof(fluxus.request) == "function" and fluxus.request)
        or nil
    if RequestFn then
        return pcall(RequestFn, Options)
    end
    return pcall(function() return game:GetService("HttpService"):RequestAsync(Options) end)
end

local function VerifyKey(KeyValue, Hwid)
    local UserId = Player.UserId
    local Ok, Response = KeySystemRequest({
        Url = KeySystemApiBaseUrl .. "/verify",
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            action = "verify-key",
            key = KeyValue,
            hwid = Hwid,
            userId = UserId,
            username = Player.Name,
            displayName = Player.DisplayName,
            profileUrl = "https://www.roblox.com/users/" .. tostring(UserId) .. "/profile",
            headshotUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(UserId) .. "&width=420&height=420&format=png",
            placeId = Game,
        }),
    })
    if not Ok or type(Response) ~= "table" or not Response.Body then
        return false, nil, "Failed to reach the license server"
    end
    local StatusCode = tonumber(Response.StatusCode or Response.Status or 200) or 200
    local DecodeOk, Data = pcall(function() return HttpService:JSONDecode(Response.Body) end)
    if not DecodeOk or type(Data) ~= "table" then
        return false, nil, StatusCode >= 400 and ("License server error (" .. tostring(StatusCode) .. ")") or "Invalid response from license server"
    end
    if StatusCode >= 200 and StatusCode < 300 and Data.valid then
        return true, Data, nil
    end
    return false, Data, Data.message or ("Key verification failed (" .. tostring(StatusCode) .. ")")
end

local function CheckPlayerCommand(Hwid)
    local Ok, Response = KeySystemRequest({
        Url = KeySystemApiBaseUrl .. "/verify",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({action = "check-player-policy", userId = Player.UserId, hwid = Hwid}),
    })
    if not Ok or type(Response) ~= "table" or not Response.Body then return false, nil end
    local DecodeOk, Data = pcall(function() return HttpService:JSONDecode(Response.Body) end)
    if not DecodeOk or type(Data) ~= "table" then return false, nil end
    if Data.kick or Data.blocked then
        Player:Kick(Data.reason or "Access has been blocked by an administrator")
        return true, Data
    end
    if type(Data.message) == "string" and Data.message ~= "" then
        pcall(function()
            TerminScriptsLib:Notify("Termin Scripts", Data.message, "info", 8)
        end)
    end
    return true, Data
end

local function CheckCurrentVersion()
    local Ok, Response = KeySystemRequest({
        Url = KeySystemApiBaseUrl .. "/verify",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({action = "check-version", version = TerminScriptsVersion}),
    })
    if not Ok or type(Response) ~= "table" or not Response.Body then return true end
    local DecodeOk, Data = pcall(function() return HttpService:JSONDecode(Response.Body) end)
    if not DecodeOk or type(Data) ~= "table" then return true end
    if Data.match == false then
        Player:Kick(VersionMismatchReason)
        return false
    end
    return true
end

local function StartPlayerPolicyMonitor(Hwid)
    if getgenv().TerminScriptsPlayerPolicyMonitor then return end
    getgenv().TerminScriptsPlayerPolicyMonitor = true
    task.spawn(function()
        local LastVersionCheck = 0
        while Player and Player.Parent do
            if os.clock() - LastVersionCheck >= 15 then
                LastVersionCheck = os.clock()
                local VersionCallOk, VersionOk = pcall(CheckCurrentVersion)
                if not VersionCallOk or VersionOk == false then break end
            end
            local Ok, Data = pcall(CheckPlayerCommand, Hwid)
            if Ok and type(Data) == "table" and Data.kick then break end
            task.wait(1)
        end
        getgenv().TerminScriptsPlayerPolicyMonitor = nil
    end)
end

local function CreateKeySystemGui()
    local Scale = ScalingManager.CurrentScale
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TerminKeySystem"
    Gui.Parent = PlayerGui
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.IgnoreGuiInset = true
    Gui.DisplayOrder = 999

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Theme.Background
    Overlay.BackgroundTransparency = 0.18
    Overlay.BorderSizePixel = 0
    Overlay.Parent = Gui

    local CardWidth, CardHeight = 430 * Scale, 330 * Scale
    local Card = Instance.new("Frame")
    Card.Size = UDim2.fromOffset(CardWidth, CardHeight)
    Card.Position = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2 + 10 * Scale)
    Card.BackgroundColor3 = Theme.Surface
    Card.BackgroundTransparency = 0
    Card.BorderSizePixel = 0
    Card.Parent = Overlay
    AddCorner(Card, 14 * Scale)

    local Stroke = AddStroke(Card, 1 * Scale, Theme.Border, 0.05)

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, -48 * Scale, 0, 2 * Scale)
    TopLine.Position = UDim2.new(0, 24 * Scale, 0, 22 * Scale)
    TopLine.BackgroundColor3 = Theme.TextPrimary
    TopLine.BorderSizePixel = 0
    TopLine.Parent = Card
    AddCorner(TopLine, 2 * Scale)

    local Brand = Instance.new("TextLabel")
    Brand.Size = UDim2.new(1, -48 * Scale, 0, 20 * Scale)
    Brand.Position = UDim2.new(0, 24 * Scale, 0, 40 * Scale)
    Brand.BackgroundTransparency = 1
    Brand.Text = "TERMIN SCRIPTS"
    Brand.TextColor3 = Theme.TextSecondary
    Brand.TextSize = 11 * Scale
    Brand.Font = Enum.Font.GothamBold
    Brand.TextXAlignment = Enum.TextXAlignment.Left
    Brand.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -48 * Scale, 0, 30 * Scale)
    Title.Position = UDim2.new(0, 24 * Scale, 0, 66 * Scale)
    Title.BackgroundTransparency = 1
    Title.Text = "Enter your key"
    Title.TextColor3 = Theme.TextPrimary
    Title.TextSize = 22 * Scale
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Card

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -48 * Scale, 0, 34 * Scale)
    Subtitle.Position = UDim2.new(0, 24 * Scale, 0, 98 * Scale)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Paste your key below to continue."
    Subtitle.TextColor3 = Theme.TextMuted
    Subtitle.TextSize = 12 * Scale
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Card

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, -48 * Scale, 0, 48 * Scale)
    InputFrame.Position = UDim2.new(0, 24 * Scale, 0, 138 * Scale)
    InputFrame.BackgroundColor3 = Theme.CardElevated
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = Card
    AddCorner(InputFrame, 9 * Scale)

    local InputStroke = AddStroke(InputFrame, 1 * Scale, Theme.Border, 0.05)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -26 * Scale, 1, 0)
    KeyBox.Position = UDim2.new(0, 13 * Scale, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "Enter key"
    KeyBox.PlaceholderColor3 = Theme.TextMuted
    KeyBox.TextColor3 = Theme.TextPrimary
    KeyBox.TextSize = 13 * Scale
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.ClearTextOnFocus = false
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.Parent = InputFrame

    KeyBox.Focused:Connect(function()
        CreateTween(InputStroke, Animations.Fast, {
            Color = Theme.Primary,
            Transparency = 0
        }):Play()
    end)

    KeyBox.FocusLost:Connect(function()
        CreateTween(InputStroke, Animations.Fast, {
            Color = Theme.Border,
            Transparency = 0.05
        }):Play()
    end)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -48 * Scale, 0, 22 * Scale)
    Status.Position = UDim2.new(0, 24 * Scale, 0, 194 * Scale)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Theme.TextMuted
    Status.TextSize = 11 * Scale
    Status.Font = Enum.Font.GothamMedium
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Card

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(1, -48 * Scale, 0, 44 * Scale)
    Submit.Position = UDim2.new(0, 24 * Scale, 0, 222 * Scale)
    Submit.BackgroundColor3 = Theme.Primary
    Submit.BorderSizePixel = 0
    Submit.Text = "Continue"
    Submit.TextColor3 = Theme.Background
    Submit.TextSize = 13 * Scale
    Submit.Font = Enum.Font.GothamSemibold
    Submit.AutoButtonColor = false
    Submit.Parent = Card
    AddCorner(Submit, 9 * Scale)

    local SubmitStroke = AddStroke(Submit, 1 * Scale, Theme.PrimaryHover, 0.72)

    Submit.MouseEnter:Connect(function()
        CreateTween(Submit, Animations.Fast, {
            BackgroundColor3 = Theme.PrimaryHover
        }):Play()
    end)

    Submit.MouseLeave:Connect(function()
        CreateTween(Submit, Animations.Fast, {
            BackgroundColor3 = Theme.Primary
        }):Play()
    end)

    local Bottom = Instance.new("TextLabel")
    Bottom.Size = UDim2.new(1, -48 * Scale, 0, 18 * Scale)
    Bottom.Position = UDim2.new(0, 24 * Scale, 0, 282 * Scale)
    Bottom.BackgroundTransparency = 1
    Bottom.Text = "Your key is linked to this device."
    Bottom.TextColor3 = Theme.TextMuted
    Bottom.TextSize = 10 * Scale
    Bottom.Font = Enum.Font.Gotham
    Bottom.TextXAlignment = Enum.TextXAlignment.Left
    Bottom.Parent = Card

    local Busy = false
    local Handle = {
        ScreenGui = Gui
    }

    local function SetStatus(Text, Kind)
        Status.Text = Text or ""
        local Color = Theme.TextMuted
        if Kind == "success" then Color = Theme.Success
        elseif Kind == "error" then Color = Theme.Error
        elseif Kind == "info" then Color = Theme.TextSecondary end
        Status.TextColor3 = Color
    end

    function Handle:SetStatus(Text, Kind)
        SetStatus(Text, Kind)
    end

    function Handle:SetLoading(State)
        Busy = State == true
        Submit.Active = not Busy
        Submit.AutoButtonColor = false
        Submit.Text = Busy and "Verifying..." or "Continue"
        KeyBox.TextEditable = not Busy
        if Busy then
            Submit.BackgroundColor3 = Theme.Secondary
        else
            Submit.BackgroundColor3 = Theme.Primary
        end
    end

    function Handle:OnSubmit(Callback)
        Submit.MouseButton1Click:Connect(function()
            if Busy then return end
            Callback(KeyBox.Text)
        end)
        KeyBox.FocusLost:Connect(function(EnterPressed)
            if EnterPressed and not Busy then
                Callback(KeyBox.Text)
            end
        end)
    end

    function Handle:Destroy()
        if not Gui or not Gui.Parent then return end
        local Move = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2 + 4 * Scale)
        CreateTween(Card, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = Move,
            BackgroundTransparency = 1
        }):Play()
        CreateTween(Overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        CreateTween(Stroke, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play()
        task.delay(0.22, function()
            if Gui and Gui.Parent then Gui:Destroy() end
        end)
    end

    CreateTween(Card, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2)
    }):Play()

    return Handle
end

local function CreateLoaderGui()
    local Scale = ScalingManager.CurrentScale
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TerminKeySystemLoader"
    Gui.Parent = PlayerGui
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.IgnoreGuiInset = true
    Gui.DisplayOrder = 998

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Theme.Background
    Overlay.BackgroundTransparency = 0.35
    Overlay.BorderSizePixel = 0
    Overlay.Parent = Gui

    local CardWidth, CardHeight = 390 * Scale, 178 * Scale
    local Card = Instance.new("Frame")
    Card.Size = UDim2.fromOffset(CardWidth, CardHeight)
    Card.Position = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2 + 8 * Scale)
    Card.BackgroundColor3 = Theme.Surface
    Card.BorderSizePixel = 0
    Card.Parent = Overlay
    AddCorner(Card, 14 * Scale)
    local Stroke = AddStroke(Card, 1 * Scale, Theme.Border, 0.12)

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 38 * Scale, 0, 2 * Scale)
    Accent.Position = UDim2.new(0, 22 * Scale, 0, 20 * Scale)
    Accent.BackgroundColor3 = Theme.Primary
    Accent.BorderSizePixel = 0
    Accent.Parent = Card
    AddCorner(Accent, 2 * Scale)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -44 * Scale, 0, 28 * Scale)
    Title.Position = UDim2.new(0, 22 * Scale, 0, 38 * Scale)
    Title.BackgroundTransparency = 1
    Title.Text = "TERMIN SCRIPTS"
    Title.TextColor3 = Theme.TextPrimary
    Title.TextSize = 20 * Scale
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Card

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -44 * Scale, 0, 20 * Scale)
    Status.Position = UDim2.new(0, 22 * Scale, 0, 70 * Scale)
    Status.BackgroundTransparency = 1
    Status.Text = "Starting..."
    Status.TextColor3 = Theme.TextSecondary
    Status.TextSize = 11 * Scale
    Status.Font = Enum.Font.GothamMedium
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Card

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -44 * Scale, 0, 4 * Scale)
    Track.Position = UDim2.new(0, 22 * Scale, 0, 108 * Scale)
    Track.BackgroundColor3 = Theme.BorderLight
    Track.BorderSizePixel = 0
    Track.Parent = Card
    AddCorner(Track, 2 * Scale)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    AddCorner(Fill, 2 * Scale)

    local Handle = {ScreenGui = Gui}

    function Handle:Run(OnComplete)
        local Phases = {
            {"Connecting...", 0.28, 0.42},
            {"Loading interface...", 0.58, 0.48},
            {"Applying configuration...", 0.82, 0.44},
            {"Ready", 1, 0.38},
        }
        CreateTween(Card, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2)
        }):Play()
        for _, Phase in ipairs(Phases) do
            Status.Text = Phase[1]
            CreateTween(Fill, TweenInfo.new(Phase[3], Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(Phase[2], 0, 1, 0)
            }):Play()
            task.wait(Phase[3])
        end
        CreateTween(Card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -CardWidth / 2, 0.5, -CardHeight / 2 - 6 * Scale),
            BackgroundTransparency = 1
        }):Play()
        CreateTween(Overlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.2, function()
            if Gui and Gui.Parent then Gui:Destroy() end
            if OnComplete then
                local Result = OnComplete()
                if type(Result) == "table" and type(Result.ScheduleAutoLoad) == "function" then
                    Result:ScheduleAutoLoad()
                end
            end
        end)
    end

    return Handle
end

function TerminScriptsLib.RunKeySystem(OnSuccess)
    ScalingManager:CalculateScale()
    if type(OnSuccess) == "function" then
        local Result = OnSuccess()
        if type(Result) == "table" and type(Result.ScheduleAutoLoad) == "function" then
            Result:ScheduleAutoLoad()
        end
    end
end

loaders = TerminScriptsLib
