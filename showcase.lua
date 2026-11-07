local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ars240/256-UI/refs/heads/main/src.lua"))()

local win = Lib:CreateWindow({
    title = "256HUB",
    subtitle = "256UI showcase",
    accentA = Color3.fromRGB(255, 0, 46),
    accentB = Color3.fromRGB(217, 130, 110),
    size = Vector2.new(760, 600),
    menuKey = "f4",
    configFolder = "256UI_SHOWCASE",
    configName = "default",
    autoSave = true,
    smartFps = false,
    checkboxStyle = true,
})

local function note(title, body, kind) Lib:Notify(title, body, 3, kind) end

Lib:Category("Showcase")
local home = win:Tab("Home", "house")

local welcome = home:Section("Welcome", "Left", "what this is")
welcome:Paragraph("256UI", "the 256HUB interface library. every element below is live - click around, then open the cog for themes and configs.")
welcome:Info("F4 opens/closes the menu, Ctrl+Space opens search")
welcome:Divider("live")
local clock = welcome:Label("time: --:--:--")
local progress = welcome:Progressbar("Loading demo", 0)

local notes = home:Section("Notifications", "Right", "every kind")
notes:Button("Info", function() note("info", "this is an info notification", "info") end)
    :AddButton("Success", function() note("success", "it worked", "success") end)
notes:Button("Warning", function() note("warning", "careful with that", "warning") end)
    :AddButton("Error", function() note("error", "something broke", "error") end)
notes:Button("Dialog", function()
    Lib:Dialog({
        title = "Are you sure?",
        text = "dialogs ask before doing something big.",
        confirm = "Do it",
        cancel = "Nope",
        onConfirm = function() note("dialog", "confirmed", "success") end,
        onCancel = function() note("dialog", "cancelled", "warning") end,
    })
end, "opens a confirm / cancel box")

local feat = win:Tab("Features", "crosshairs")

local toggles = feat:Section("Toggles", "Left", "with keybinds, colors and children")
local master = toggles:Toggle("Master switch", true, function(v) print("master", v) end, "turns the rows below on/off")
master:AddKeybind("e", "Toggle", function(...) print("master bind", ...) end)
toggles:Toggle("Child option", false, function(v) print("child", v) end):DependsOn(master)
toggles:Toggle("Glow", true, function(v) print("glow", v) end)
    :AddColorpicker("Glow color", Color3.fromRGB(255, 0, 46), function(c, a) print("glow color", c, a) end, 1)
toggles:Toggle("Risky option", false, function(v) print("risky", v) end, "marked as risky"):SetRisk(true)
toggles:Toggle("Locked option", true, function() end, "can't be changed"):SetLocked(true)

local sliders = feat:Section("Sliders", "Right", "numbers and ranges")
sliders:Slider("Walk speed", 16, 1, 0, 100, "", function(v) print("speed", v) end, "whole numbers")
sliders:Slider("Smoothness", 0.5, 0.05, 0, 1, "", function(v) print("smooth", v) end, "decimals")
sliders:Slider("Delay", 150, 10, 0, 1000, "ms", function(v) print("delay", v) end)
sliders:RangeSlider("Distance", 50, 300, 5, 0, 1000, "studs", function(lo, hi) print("range", lo, hi) end)

local vis = win:Tab("Visuals", "eye")
local esp = vis:Sub("ESP", "person")
local world = vis:Sub("World", "sun")

local espMain = esp:Section("ESP", "Left", "dropdowns")
espMain:Dropdown("Box style", { "Corner" }, { "Full", "Corner", "3D" }, false, function(v) print("box", v[1]) end)
espMain:Dropdown("Parts", { "Head", "Torso" }, { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }, true,
    function(v) print("parts", table.concat(v, ",")) end, "multi-select, max 4, searchable", true, 4)
espMain:Colorpicker("Box color", Color3.fromRGB(255, 0, 46), function(c, a) print("box color", c, a) end, 1)
espMain:Colorpicker("Name color", Color3.fromRGB(255, 255, 255), function(c) print("name color", c) end)

local espText = esp:Section("Text", "Right", "text input")
espText:Textbox("Custom tag", "", function(s) note("textbox", "you typed: " .. s, "info") end, "type, then press enter")
espText:Toggle("Show distance", true, function(v) print("distance", v) end)

local worldSec = world:Section("World", "Left", "sub-tab content")
worldSec:Toggle("Fullbright", false, function(v) print("fullbright", v) end)
worldSec:Slider("Time of day", 14, 0.5, 0, 24, "h", function(v) print("time", v) end)

Lib:Category("Extras")
local live = win:Tab("Live", "speedometer")

local dyn = live:Section("Dynamic dropdown", "Left", "add / remove choices at runtime")
local items = dyn:Dropdown("Items", {}, { "Apple", "Banana" }, false, function(v) print("item", v[1]) end)
local n = 0
dyn:Button("Add item", function()
    n = n + 1
    items:AddChoice("Item " .. n)
    note("dropdown", "added item " .. n, "success")
end):AddButton("Clear", function()
    items:ClearChoices()
    note("dropdown", "cleared", "warning")
end)

local binds = live:Section("Keybinds", "Right", "click to rebind, right-click for mode")
binds:Keybind("Fly", "f", function(...) print("fly", ...) end, "toggle mode")
binds:Keybind("Sprint", "leftshift", function(...) print("sprint", ...) end)
binds:Divider("overlay")
local overlayOn = false
local box
binds:Toggle("Stats overlay", false, function(v)
    overlayOn = v
    if box then box:SetVisible(v) end
end, "a draggable info box on screen")

box = Lib:CreateBox({ title = "256HUB stats", x = 20, y = 160, width = 190, visible = false })
local fpsLine = box:Stat("FPS: --")
local timeLine = box:Stat("Time: --")
box:Text("bar = progress")
local barLine = box:Bar(0)

local look = win:Tab("Themes", "star")
local theme = look:Section("Presets", "Left", "one-click looks")
local presets = Lib:ThemePresets()
theme:Dropdown("Theme preset", { presets[1] }, presets, false, function(v)
    Lib:ApplyThemePreset(v[1])
    note("theme", "applied " .. tostring(v[1]), "success")
end)
theme:Dropdown("Background effect", { "Off" }, Lib:BackgroundEffects(), false, function(v) Lib:SetBackgroundEffect(v[1]) end)

local accent = look:Section("Accent", "Right", "custom colours")

local accA, accB = Color3.fromRGB(255, 0, 46), Color3.fromRGB(217, 130, 110)
accent:Colorpicker("Accent A", accA, function(c) accA = c; Lib:SetAccent(accA, accB) end)
accent:Colorpicker("Accent B", accB, function(c) accB = c; Lib:SetAccent(accA, accB) end)
accent:Info("more in the cog: font, corner radius, opacity, configs")

win:AddSettingsTab("cog")

task.spawn(function()
    local frames, last, fps, t = 0, os.clock(), 0, 0
    while _G["256UI"] == Lib do
        frames = frames + 1
        local now = os.clock()
        if now - last >= 1 then
            fps, frames, last = frames, 0, now
        end
        t = (t + 0.02) % 1
        pcall(function()
            clock:SetText("time: " .. os.date("%H:%M:%S"))
            progress:Set(math.floor(t * 100))
            if overlayOn then
                fpsLine.Value = "FPS: " .. fps
                timeLine.Value = "Time: " .. os.date("%H:%M:%S")
                barLine.Value = t
            end
        end)
        task.wait(0.05)
    end
end)

Lib:Notify("256UI", "showcase loaded - F4 to toggle", 4, "success")
