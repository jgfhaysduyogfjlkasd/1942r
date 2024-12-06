-- "addons\\crashscreen\\lua\\autorun\\crashscreen.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
crashscreen = crashscreen or {}

if (not CLIENT) then return end -- Only clientside stuff from here on.

-- Callbacks from the html page.
function crashscreen.disconnect()
    RunConsoleCommand("disconnect")
end

function crashscreen.reconnect()
    RunConsoleCommand("retry")
end

function crashscreen.forums()
    gui.OpenURL("https://neutronnetworks.noclip.me/")
end

function crashscreen.discord()
    gui.OpenURL("https://discord.gg/historianetworks")
end


function crashscreen.showPanel()
    if crashscreen.Panel and IsValid(crashscreen.Panel) then return end

    crashscreen.Panel = vgui.Create("DHTML")
    crashscreen.Panel:SetSize(ScrW(), ScrH())
    crashscreen.Panel:SetPos(0, 0)
    crashscreen.Panel:SetHTML([[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            color: inherit;
            font-family: inherit;
            box-sizing: border-box;
        }
        @-webkit-keyframes fadein {
            0% {opacity: 0}
            100% {opacity: 1}
        }
        @keyframes fadein {
            0% {opacity: 0}
            100% {opacity: 1}
        }

        html, body {
            width: 100%;
            height: 100%;
        }
        body {
            position: relative;
            overflow: auto;
            font-family: 'Tajawal', sans-serif;
            background-color: rgba(20, 20, 20, 0.7);
            opacity: 0;
            -webkit-animation: fadein 1.2s forwards;
                    animation: fadein 1.2s forwards;
        }
        #center {
            position: absolute;
            left: 50%;
            top: 50%;
            text-align: center;
            -webkit-transform: translate(-50%, -50%);
                    transform: translate(-50%, -50%);
        }
        @-webkit-keyframes lostconnection {
            0% {color: #FF8A50}
            50% {color: #808080}
            100% {color: #FF8A50}
        }
        @keyframes lostconnection {
            0% {color: #FF8A50}
            50% {color: #808080}
            100% {color: #FF8A50}
        }
        #icon {
            color: white;
            width: 128px;
            height: 128px;
            -webkit-animation: lostconnection 1.2s infinite;
                    animation: lostconnection 1.2s infinite;
        }
        h1 {
            color: white;
            font-size: 48px;
        }
        p {
            color: #f2f2f2;
            font-size: 23px;
        }
        #buttons {
            margin-top: 48px;
        }
        #buttons button {
            color: #f2f2f2;
            padding: 12px 24px;
            font-size: 23px;
            outline: none;
            border: 1px solid #636363;
            background: rgba(20, 20, 20, 0.7);
            -webkit-transition: color 0.2s ease-in-out;
            transition: color 0.2s ease-in-out;
        }
        #buttons button + button {
            margin-left: 12px;
        }
        #buttons button:hover {
            color: #808080;
        }
    </style>
</head>
<body>
    <main id="center">
        <!-- "borrowed" icons from font awesome pro. -->
        <svg viewBox="0 0 640 512" id="icon">
            <path fill="currentColor" d="M324.2 320.4c-1.4-.1-2.8-.4-4.2-.4-44.2 0-80 35.8-80 80s35.8 80 80 80 80-35.8 80-80c0-8-1.5-15.5-3.7-22.8zM320 448c-26.5 0-48-21.5-48-48s21.5-48 48-48 48 21.5 48 48-21.5 48-48 48zM3.8 158c-4.9 4.7-5.1 12.5-.3 17.3l5.7 5.7c4.6 4.6 12.1 4.7 16.8.3 19.1-18.1 39.5-33.9 60.8-47.8l-26.4-20.8C40.8 126.3 21.7 141 3.8 158zM614 181.3c4.7 4.5 12.2 4.4 16.8-.3l5.7-5.7c4.8-4.8 4.7-12.6-.3-17.3C503.6 32.2 314.1.6 152.9 63.3l30.2 23.8C328.9 37.9 495.8 69.2 614 181.3zm-297.5 10.8l44.6 35.2c51.8 7.7 101.8 29.8 143.3 66.7 4.8 4.3 12.2 4 16.6-.7l5.5-5.8c4.7-4.9 4.4-12.7-.7-17.2-59.4-53-134.4-79-209.3-78.2zM637 485.2L23 1.8C19.6-1 14.5-.5 11.8 3l-10 12.5C-1 19-.4 24 3 26.7l614 483.5c3.4 2.8 8.5 2.2 11.2-1.2l10-12.5c2.8-3.5 2.3-8.5-1.2-11.3zM114 270.3c-5 4.5-5.3 12.3-.6 17.2l5.5 5.8c4.5 4.7 11.8 5 16.7.7 25.8-23 55.7-40.9 88.1-52.8L195 218.6c-29 12.7-56.4 29.8-81 51.7z"></path>
        </svg>
        <h1>Red Panda Gaming | Connection Unstable.. </h1>
        <p>The connection to the server has been interrupted.</p>
        <p>This may be caused due to your connection or a server-side problem</p>
        <p>Please wait to establish a new connection.</p>
        <div id="buttons">
            <button onclick="console.log('RUNLUA:crashscreen.reconnect()')">Reconnect</button>
            <button onclick="console.log('RUNLUA:crashscreen.forums()')">Website</button>
            <button onclick="console.log('RUNLUA:crashscreen.discord()')">Discord</button>
            <button onclick="console.log('RUNLUA:crashscreen.disconnect()')">Disconnect</button>
            <!--<button onclick="console.log('RUNLUA:crashscreen.hidePanel()')">DEV</button>-->
        </div>
    </main>
</body>
</html>
    ]])
    crashscreen.Panel:SetAllowLua(true)

    crashscreen.Panel:MakePopup()
    crashscreen.Panel:DoModal()
end

function crashscreen.hidePanel()
    if not crashscreen.Panel or not IsValid(crashscreen.Panel) then return end
    crashscreen.Panel:Remove()
    crashscreen.Panel = nil
end

-- After some reasearch i found out that neither think nor tick are server bound whilst they are supposed to...
-- however timers are bound to the server soo... sorry for the ugly sollution.

timer.Create("Crashscreen", 0.1, 0, function ()
    crashscreen.LastTick = CurTime()
    crashscreen.hidePanel()
end)

crashscreen.scriptLoaded = crashscreen.scriptLoaded or SysTime()

hook.Add("Think", "Crashscreen", function ()
    if (SysTime() - crashscreen.scriptLoaded) > 60 && CurTime() - crashscreen.LastTick >= 1.3 then
        crashscreen.showPanel()
    end
end)
