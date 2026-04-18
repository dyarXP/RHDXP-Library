local httpService = game:GetService("HttpService")
local InterfaceManager = {}

InterfaceManager.Folder = "RHDXP_Settings"
InterfaceManager.Settings = {
    Theme = "Cyberpunk",
    Acrylic = true,
    Transparency = true,
    MenuKeybind = "LeftControl"
}

function InterfaceManager:SetFolder(folder)
    self.Folder = folder
    if not isfolder(self.Folder) then 
        makefolder(self.Folder) 
    end
end

function InterfaceManager:SetLibrary(library)
    self.Library = library
end

function InterfaceManager:SaveSettings()
    writefile(self.Folder .. "/options.json", httpService:JSONEncode(self.Settings))
end

function InterfaceManager:LoadSettings()
    local path = self.Folder .. "/options.json"
    if isfile(path) then
        local data = readfile(path)
        local success, decoded = pcall(httpService.JSONDecode, httpService, data)
        if success then
            for i, v in next, decoded do
                self.Settings[i] = v
            end
        end
    end
end

function InterfaceManager:BuildInterfaceSection(tab)
    assert(self.Library, "Must set InterfaceManager.Library")
    local Library = self.Library
    
    -- Load Tema Cyberpunk dari folder Themes Anda
    local themeUrl = "https://raw.githubusercontent.com/dyarXP/RHDXP-Library/main/src/Themes/Cyberpunk.lua"
    local success, CyberpunkTheme = pcall(function()
        return loadstring(game:HttpGet(themeUrl))()
    end)

    if success and CyberpunkTheme then
        Library.Themes["Cyberpunk"] = CyberpunkTheme
        Library:SetTheme("Cyberpunk")
        -- Memaksa warna aksen neon (Cyan) agar langsung terlihat
        Library.AccentColor = CyberpunkTheme.AccentColor or Color3.fromRGB(0, 255, 255)
    else
        Library:SetTheme("Dark")
    end

    self:LoadSettings()

    local section = tab:AddSection("Interface Settings")

    section:AddParagraph({
        Title = "RHDXP Visual Style",
        Content = "Tema Cyberpunk telah diterapkan secara otomatis."
    })

    section:AddToggle("AcrylicToggle", {
        Title = "Acrylic (Blur)",
        Default = self.Settings.Acrylic,
        Callback = function(Value)
            Library:ToggleAcrylic(Value)
            self.Settings.Acrylic = Value
            self:SaveSettings()
        end
    })

    section:AddToggle("TransparentToggle", {
        Title = "Transparency",
        Default = self.Settings.Transparency,
        Callback = function(Value)
            Library:ToggleTransparency(Value)
            self.Settings.Transparency = Value
            self:SaveSettings()
        end
    })

    local MenuKeybind = section:AddKeybind("MenuKeybind", { 
        Title = "Minimize Bind", 
        Default = self.Settings.MenuKeybind 
    })
    
    MenuKeybind:OnChanged(function()
        self.Settings.MenuKeybind = MenuKeybind.Value
        self:SaveSettings()
    end)
    Library.MinimizeKeybind = MenuKeybind
end

-- INI ADALAH BAGIAN PALING PENTING AGAR TIDAK NIL
return InterfaceManager
