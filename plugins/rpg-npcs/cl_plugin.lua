netstream.Hook(
    "ShowDialog",
    function(client, settings, ent)
        local name = settings.Name
        local model = settings.Model
        local profession = settings.Profession
        local affiliation = settings.Affiliation
        local introductionText = settings.IntroductionText
        local buttons = settings.buttons
        nut.dialog.Generate(
            name,
            model,
            profession,
            affiliation,
            function()
                nut.dialog.frame(name, model, profession, affiliation)
                nut.dialog.text(introductionText)
                for optionName, optionData in pairs(buttons) do
                    if optionData.checkhook and not hook.Run(optionData.checkhook, client, ent) then continue end
                    nut.dialog.button(
                        optionName,
                        40,
                        function()
                            netstream.Start(optionData.runhook, client, ent)
                            self:Close()
                        end
                    )
                end
            end
        )
    end
)