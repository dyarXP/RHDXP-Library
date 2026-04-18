local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
    InterfaceManager.Folder = "RHDXP_Settings"
    InterfaceManager.Settings = {
        Theme = "Cyberpunk",
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
        if not isfolder(self.Folder) then makefolder(self.Folder) end
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
        
        -- [[ AMBIL TEMA CYBERPUNK DARI GITHUB ]]
        local success, CyberpunkTheme = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/dyarXP/RHDXP-Library/main/src/Themes/Cyberpunk.lua"))()
        end)

        if success and CyberpunkTheme then
            Library.Themes["Cyberpunk"] = CyberpunkTheme
            Library:SetTheme("Cyberpunk")
        else
            warn("❌ Gagal memuat tema Cyberpunk dari GitHub, menggunakan default Dark.")
            Library:SetTheme("Dark")
        end

        self:LoadSettings()

        local section = tab:AddSection("Interface Settings")

        section:AddParagraph({
            Title = "Visual Style: Cyberpunk",
            Content = "Tema eksklusif RHDXP Hub telah diterapkan secara otomatis."
        })
    
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
end

return InterfaceManager
