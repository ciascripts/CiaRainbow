-- CiaRainbow — local scooter colors
-- R toggles rainbow. CR shows/hides the menu.
-- Closing restores original colors.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("CiaRainbow")
if previous then previous:Destroy() end

local C = {
    base = Color3.fromRGB(13, 17, 22),
    card = Color3.fromRGB(22, 28, 35),
    border = Color3.fromRGB(43, 53, 64),
    white = Color3.fromRGB(240, 245, 248),
    muted = Color3.fromRGB(146, 161, 174),
    green = Color3.fromRGB(172, 255, 104),
    amber = Color3.fromRGB(255, 206, 110),
}

local enabled, alive = true, true
local cycleSeconds, hue = 6, 0
local scooter
local originals = {}
local connections = {}

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function restore()
    for part, color in pairs(originals) do
        if part.Parent then part.Color = color end
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "CiaRainbow"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function round(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
end

local function border(object)
    local stroke = Instance.new("UIStroke")
    stroke.Color = C.border
    stroke.Thickness = 1
    stroke.Parent = object
end

local function panel(parent, x, y, w, h)
    local object = Instance.new("Frame")
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(w, h)
    object.BackgroundColor3 = C.card
    object.BorderSizePixel = 0
    object.Parent = parent
    round(object, 12)
    return object
end

local function label(parent, text, x, y, w, h, size, color, bold)
    local object = Instance.new("TextLabel")
    object.BackgroundTransparency = 1
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(w, h)
    object.Text = text
    object.TextSize = size
    object.TextColor3 = color or C.white
    object.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    object.TextXAlignment = Enum.TextXAlignment.Left
    object.Parent = parent
    return object
end

local function button(parent, text, x, y, w, h)
    local object = Instance.new("TextButton")
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(w, h)
    object.BackgroundColor3 = C.card
    object.BorderSizePixel = 0
    object.Text = text
    object.TextColor3 = C.white
    object.TextSize = 13
    object.Font = Enum.Font.GothamBold
    object.Parent = parent
    round(object, 10)
    return object
end

local main = panel(gui, 0, 0, 380, 420)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = C.base
main.Active = true
border(main)

local scale = Instance.new("UIScale")
scale.Parent = main

local header = button(main, "", 16, 6, 304, 72)
header.BackgroundTransparency = 1
header.AutoButtonColor = false

local logo = panel(header, 4, 16, 42, 42)
logo.BackgroundColor3 = C.green
local logoText = label(logo, "CR", 0, 0, 42, 42, 16, C.base, true)
logoText.TextXAlignment = Enum.TextXAlignment.Center

label(header, "CiaRainbow", 58, 17, 200, 25, 22, C.white, true)
label(header, "SCOOTER COLOR CONTROL",
    58, 43, 225, 14, 9, C.muted, true)

local close = button(main, "×", 330, 24, 30, 30)
close.TextSize = 23
close.TextColor3 = C.muted
connect(close.Activated, function() gui:Destroy() end)

label(main, "YOUR RIDE. YOUR COLORS.",
    20, 79, 245, 16, 10, C.muted, true)

local badge = label(main, "WAITING", 270, 79, 90, 16, 10, C.amber, true)
badge.TextXAlignment = Enum.TextXAlignment.Right

local toggle = button(main, "DISABLE RAINBOW", 20, 106, 340, 48)
toggle.TextSize = 14

local statusCard = panel(main, 20, 166, 340, 60)
local status = label(statusCard, "", 14, 8, 312, 44, 11, C.muted)
status.TextWrapped = true

local sliderCard = panel(main, 20, 238, 340, 104)
label(sliderCard, "RAINBOW CYCLE", 14, 11, 205, 20, 10, C.white, true)

local speedLabel = label(sliderCard, "", 239, 8, 87, 26, 21, C.green, true)
speedLabel.TextXAlignment = Enum.TextXAlignment.Right

local slider = button(sliderCard, "", 20, 37, 300, 34)
slider.BackgroundTransparency = 1
slider.AutoButtonColor = false

local track = panel(slider, 0, 15, 300, 5)
track.BackgroundColor3 = C.border

local fill = panel(track, 0, 0, 0, 5)
fill.BackgroundColor3 = C.green

local knob = panel(track, 0, 0, 20, 20)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = C.white

label(sliderCard, "1s · FAST", 14, 77, 90, 14, 10, C.muted)
local slow = label(sliderCard, "15s · SLOW", 226, 77, 100, 14, 10, C.muted)
slow.TextXAlignment = Enum.TextXAlignment.Right

local preview = panel(main, 20, 354, 340, 16)

local footer = label(main, "R  TOGGLE     /     LOCAL VISUALS",
    20, 392, 340, 12, 9, C.muted)
footer.TextXAlignment = Enum.TextXAlignment.Center

local menu = button(gui, "CR", 0, 0, 56, 56)
menu.AnchorPoint = Vector2.new(1, 0)
menu.Position = UDim2.new(1, -16, 0, 80)
menu.BackgroundColor3 = C.green
menu.TextColor3 = C.base
menu.TextSize = 17
menu.ZIndex = 50
border(menu)

connect(menu.Activated, function()
    main.Visible = not main.Visible
    menu.BackgroundColor3 = main.Visible and C.green or C.card
    menu.TextColor3 = main.Visible and C.base or C.green
end)

local function updateUI()
    local count = 0
    for _ in pairs(originals) do count = count + 1 end

    toggle.Text = enabled and "DISABLE RAINBOW" or "ENABLE RAINBOW"
    toggle.BackgroundColor3 = enabled and C.card or C.green
    toggle.TextColor3 = enabled and C.green or C.base

    if not enabled then
        badge.Text = "OFF"
        badge.TextColor3 = C.muted
        status.Text = "Rainbow off. Original colors restored."
    elseif not scooter then
        badge.Text = "WAITING"
        badge.TextColor3 = C.amber
        status.Text = "Spawn your scooter to start rainbow colors."
    elseif count == 0 then
        badge.Text = "WAITING"
        badge.TextColor3 = C.amber
        status.Text = scooter.Name .. "\nWaiting for visible parts..."
    else
        badge.Text = "● LIVE"
        badge.TextColor3 = C.green
        status.Text = scooter.Name .. "\n" .. count .. " visible parts • local colors"
    end
end

local function toggleRainbow()
    enabled = not enabled
    if not enabled then restore() end
    updateUI()
end

connect(toggle.Activated, toggleRainbow)
connect(UIS.InputBegan, function(input, processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.R then toggleRainbow() end
end)

local function drawSlider()
    local ratio = (cycleSeconds - 1) / 14
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    knob.Position = UDim2.fromScale(ratio, 0.5)
    speedLabel.Text = string.format("%.1fs", cycleSeconds)
end

local function setSlider(x)
    if slider.AbsoluteSize.X <= 0 then return end
    local ratio = math.clamp(
        (x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
    cycleSeconds = math.floor((1 + ratio * 14) * 10 + 0.5) / 10
    drawSlider()
end

local sliderInput, dragInput, dragStart, frameStart

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function isMovement(input, active)
    return active and (input == active
        or (active.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement))
end

connect(slider.InputBegan, function(input)
    if isPress(input) then
        sliderInput = input
        setSlider(input.Position.X)
    end
end)

connect(header.InputBegan, function(input)
    if isPress(input) then
        dragInput = input
        dragStart = input.Position
        frameStart = main.Position
    end
end)

connect(UIS.InputChanged, function(input)
    if isMovement(input, sliderInput) then
        setSlider(input.Position.X)
    end

    if isMovement(input, dragInput) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            frameStart.X.Scale, frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

connect(UIS.InputEnded, function(input)
    if input == sliderInput then sliderInput = nil end
    if input == dragInput then dragInput = nil end
end)

connect(UIS.WindowFocusReleased, function()
    sliderInput, dragInput = nil, nil
end)

local cameraConnection

local function fit()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local view = camera.ViewportSize
    scale.Scale = math.max(0.1, math.min(
        1, (view.X - 24) / 380, (view.Y - 60) / 420))
end

local function watchCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    local camera = workspace.CurrentCamera
    if camera then
        cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    end
    fit()
end

connect(workspace:GetPropertyChangedSignal("CurrentCamera"), watchCamera)
watchCamera()

local function findScooter()
    -- Resolve the model directly from its owner marker.
    for _, item in ipairs(workspace:GetDescendants()) do
        if item.Name == "ScooterOwner"
            and item:IsA("ObjectValue")
            and item.Value == player then
            local model = item:FindFirstAncestorOfClass("Model")
            if model then return model end
        end
    end
end

local function eligible(part)
    if not part:IsA("BasePart") or part.Transparency >= 1 then
        return false
    end

    local ancestor = part.Parent
    while ancestor and ancestor ~= scooter do
        if ancestor.Name == "CustomScooterParts" then return false end
        ancestor = ancestor.Parent
    end
    return ancestor == scooter
end

local function refresh()
    local found = findScooter()
    if found ~= scooter then
        restore()
        originals = {}
        scooter = found
    end

    for part, color in pairs(originals) do
        if not scooter or not eligible(part) then
            if part.Parent then part.Color = color end
            originals[part] = nil
        end
    end

    if scooter then
        for _, part in ipairs(scooter:GetDescendants()) do
            if eligible(part) and originals[part] == nil then
                originals[part] = part.Color
            end
        end
    end

    updateUI()
end

local elapsed = 0
connect(RunService.Heartbeat, function(dt)
    hue = (hue + dt / cycleSeconds) % 1
    elapsed = elapsed + dt
    if elapsed < 1 / 30 then return end
    elapsed = 0

    local color = Color3.fromHSV(hue, 1, 1)
    preview.BackgroundColor3 = enabled and color or C.border

    if not enabled or not scooter then return end
    for part in pairs(originals) do
        if part:IsDescendantOf(scooter) then
            part.Color = color
        end
    end
end)

gui.Destroying:Connect(function()
    alive = false
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    if cameraConnection then cameraConnection:Disconnect() end
    restore()
end)

drawSlider()
refresh()

task.spawn(function()
    while alive do
        task.wait(2)
        if alive then refresh() end
    end
end)

print("[CiaRainbow] Loaded — R toggles colors, CR toggles menu.")
