function PLUGIN:LoadFonts(font)
    surface.CreateFont("Title_Font", {
        font = "Arial",
        extended = false,
        size = 25,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Price_Font", {
        font = "Arial",
        extended = false,
        size = 15,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Vehicle_Font", {
        font = "Times New Roman",
        size = 22,
        weight = 800,
        antialias = true,
    })
end