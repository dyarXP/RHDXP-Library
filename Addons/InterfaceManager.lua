local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
    InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Cyberpunk", -- Set default ke Cyberpunk
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl"
    }

    function InterfaceManager:SetFolder(folder)
        self.Folder = folder;
        self:BuildFolderTree()
    end

    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end

    function InterfaceManager:BuildFolderTree()
        local paths = {self.Folder, self.Folder .. "/settings"}
        for _, str in ipairs(paths) do
            if not isfolder(str) then makefolder(str) end
        end
    end

    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", httpService:JSONEncode(InterfaceManager.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)
            if success then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
        local Library = self.Library
        local Settings = InterfaceManager.Settings

        InterfaceManager:LoadSettings()

        -- [[ INJEKSI TEMA CYBERPUNK KE LIBRARY ]]
        Library.Themes["Cyberpunk"] = {
            -- Warna dasar Gelap/Transparan
            MainColor = Color3.fromRGB(15, 15, 20),
            SecondaryColor = Color3.fromRGB(20, 20, 25),
            -- Warna Aksen Neon (Cyan & Pink)
            AccentColor = Color3.fromRGB(0, 255, 255), 
            TextColor = Color3.fromRGB(255, 255, 255),
            -- Detail UI
            TitleColor = Color3.fromRGB(255, 0, 150), -- Neon Pink
            OutlineColor = Color3.fromRGB(50, 50, 70)
        }
        
        -- Paksa gunakan tema Cyberpunk
        Library:SetTheme("Cyberpunk")

        local section = tab:AddSection("Interface Settings")

        -- Label Informasi Tema (Karena dropdown dihapus)
        section:AddParagraph({
            Title = "Current Theme: Cyberpunk",
            Content = "Visual khusus RHDXP Hub dengan gaya Neon & Hologram."
        })
    
        if Library.UseAcrylic then
            section:AddToggle("AcrylicToggle", {
                Title = "Acrylic (Blur)",
                Description = "Efek blur pada background (Grafik 8+)",
                Default = Settings.Acrylic,
                Callback = function(Value)
                    Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
                end
            })
        end
    
        section:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Description = "Membuat interface tembus pandang.",
            Default = Settings.Transparency,
            Callback = function(Value)
                Library:ToggleTransparency(Value)
                Settings.Transparency = Value
                InterfaceManager:SaveSettings()
            end
        })
    
        local MenuKeybind = section:AddKeybind("MenuKeybind", { 
            Title = "Minimize Bind", 
            Default = Settings.MenuKeybind 
        })
        
        MenuKeybind:OnChanged(function()
            Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
        end)
        Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
