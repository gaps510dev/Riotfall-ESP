local D = Drawing

local cf = workspace:WaitForChild("Characters")
local eb = {}
local et = {}

local function createEB(n)
    local c = cf:FindFirstChild(n)
    if not c then return end

    local cp = c:FindFirstChild("Center")
    if not cp then return end

    if eb[n] and et[n] then
        return
    end

    local b = D.new("Square")
    b.Visible = true
    b.Color = Color3.new(1, 1, 1)
    b.Thickness = 2
    b.Transparency = 1
    b.Filled = false

    local t = D.new("Text")
    t.Visible = true
    t.Color = Color3.new(1, 1, 1)
    t.Size = 14
    t.Center = true

    local function update()
        if cp and cp.Parent then
            local sp, os = workspace.CurrentCamera:WorldToViewportPoint(cp.Position)
            if os then
                local s = Vector2.new(30, 60) -- Customize size as needed
                b.Size = s
                b.Position = Vector2.new(sp.X - s.X / 2, sp.Y - s.Y / 2)
                b.Visible = true

                local d = (workspace.CurrentCamera.CFrame.Position - cp.Position).Magnitude
                t.Text = string.format("%.1f studs", d)
                t.Position = Vector2.new(sp.X, sp.Y + s.Y / 2 + 5) -- Place text below the box
                t.Visible = true
            else
                b.Visible = false
                t.Visible = false
            end
        end
    end

    game:GetService("RunService").RenderStepped:Connect(update)
    eb[n] = b
    et[n] = t
end

local function onCA(c)
    if c:IsA("Model") and c:FindFirstChild("Center") then
        createEB(c.Name)
    end
end

local function onCR(c)
    if c:IsA("Model") and eb[c.Name] then
        eb[c.Name]:Remove()
        eb[c.Name] = nil
        et[c.Name]:Remove()
        et[c.Name] = nil
    end
end

for _, c in pairs(cf:GetChildren()) do
    onCA(c)
end

cf.ChildAdded:Connect(onCA)
cf.ChildRemoved:Connect(onCR)
