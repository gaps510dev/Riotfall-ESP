local Drawing = Drawing

local charactersFolder = workspace:WaitForChild("Characters")
local tracers = {}
local tracerTexts = {}

local function createTracer(characterName)
    local character = charactersFolder:FindFirstChild(characterName)
    if not character then return end

    local centerPart = character:FindFirstChild("Center")
    if not centerPart then return end

    if tracers[characterName] and tracerTexts[characterName] then
        return -- Tracer and text already exist
    end

    local tracer = Drawing.new("Line")
    tracer.Visible = true
    tracer.Color = Color3.new(1, 1, 1)
    tracer.Thickness = 2

    local text = Drawing.new("Text")
    text.Visible = true
    text.Color = Color3.new(1, 1, 1)
    text.Size = 14
    text.Center = true

    local function update()
        if centerPart and centerPart.Parent then
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(centerPart.Position)
            if onScreen then
                tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Visible = true

                local distance = (workspace.CurrentCamera.CFrame.Position - centerPart.Position).Magnitude
                text.Text = string.format("%.1f studs", distance)
                text.Position = Vector2.new(screenPos.X, screenPos.Y + 15) -- Place text above the character's head
                text.Visible = true
            else
                tracer.Visible = false
                text.Visible = false
            end
        end
    end

    game:GetService("RunService").RenderStepped:Connect(update)
    tracers[characterName] = tracer
    tracerTexts[characterName] = text
end

local function onChildAdded(child)
    if child:IsA("Model") and child:FindFirstChild("Center") then
        createTracer(child.Name)
    end
end

local function onChildRemoved(child)
    if child:IsA("Model") and tracers[child.Name] then
        tracers[child.Name]:Remove()
        tracers[child.Name] = nil
        tracerTexts[child.Name]:Remove()
        tracerTexts[child.Name] = nil
    end
end

for _, child in pairs(charactersFolder:GetChildren()) do
    onChildAdded(child)
end

charactersFolder.ChildAdded:Connect(onChildAdded)
charactersFolder.ChildRemoved:Connect(onChildRemoved)
