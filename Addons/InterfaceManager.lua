function InterfaceManager:BuildInterfaceSection(tab)
    assert(self.Library, "Must set InterfaceManager.Library")
    local Library = self.Library
    
    -- 1. Ambil Data Tema dari GitHub
    local themeUrl = "https://raw.githubusercontent.com/dyarXP/RHDXP-Library/main/src/Themes/Cyberpunk.lua"
    local success, CyberpunkTheme = pcall(function()
        return loadstring(game:HttpGet(themeUrl))()
    end)

    -- 2. Paksa Suntik Warna Neon ke Library
    if success and CyberpunkTheme then
        -- Masukkan ke daftar tema library
        Library.Themes["Cyberpunk"] = CyberpunkTheme
        
        -- Override manual palet warna library yang sedang berjalan
        for property, color in next, CyberpunkTheme do
            if Library[property] then
                Library[property] = color
            end
        end
        
        -- Terapkan tema
        Library:SetTheme("Cyberpunk")
    end

    self:LoadSettings()

    local section = tab:AddSection("Interface Settings")

    section:AddParagraph({
        Title = "Visual Style: Cyberpunk",
        Content = "Tema eksklusif RHDXP Hub (Neon Blue & Pink) telah diterapkan."
    })

    -- Tombol Toggle tetap ada seperti di gambar Anda
    if Library.UseAcrylic then
        section:AddToggle("AcrylicToggle", {
            Title = "Acrylic (Blur)",
            Default = self.Settings.Acrylic,
            Callback = function(Value)
                Library:ToggleAcrylic(Value)
                self.Settings.Acrylic = Value
                self:SaveSettings()
            end
        })
    end

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
