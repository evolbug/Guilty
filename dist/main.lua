-- evolbug 2016-2017, MIT license
-- Guilty testbench

local gui = require "guilty.guilty"
local LICENSE = require('miscellaneous').LICENSE


local lg = love.graphics 


function Window(x, y, w, h, otherColor)
    if otherColor==nil then otherColor=false end
    
    local win = gui.Container(x, y, w, h)

    local bg = win:attach(gui.Rectangle('center', 'center', win.w-2, win.h-2))
    if otherColor then
        bg.theme.color = function() return gui.RGBA(gui.theme.color.secondary) end
    end

    win:attach(gui.Border())

    return win
end


function love.load()

    love.window.setMode(500,400)
    love.keyboard.setKeyRepeat(true)

    -- main window
    window = Window('center','center', lg.getWidth()-10, lg.getHeight()-10)
    window:attach(gui.Text('center', 5, 'evolbug 2016-2017, MIT license. Guilty .4'))


    -- inner windows
    local license = window:attach(Window('center', 20, window.w-10, 200, true))
        local ltext = license:attach(gui.TextBoxScrollable(5, 5, license.w-10, license.h-10))
        ltext.text:set(LICENSE)


     local win2 = window:attach(Window('center',225, window.w-10, window.h-240, true))

        local textbax = win2:attach(gui.TextBox(1, 1, win2.w/2, win2.h-2))
            textbax.text:set("Write text below and press the button to add it here\n")

        local inputbox = win2:attach(gui.TextInput(win2.w/2+2, 2, win2.w/2-4, 40))
            inputbox:attach(gui.Border())
        
        local textbtn = win2:attach(gui.Button(win2.w/2+2, 45, win2.w/2-4,30, 'Add text'))
            textbtn:attach(gui.Border())
            textbtn.onclick.release = function() textbax.text:add(inputbox.text.buffer) end

        --extra container for checkboxes
        local checks = win2:attach(gui.Container(win2.w/2+2, 77, win2.w/2-4, 70))
            checks:attach(gui.Border())
            local ch1 = checks:attach(gui.Checkbox(10, 5, 15, 'show input and button', true))
                ch1.onclick.any = function()
                    textbtn.visible = ch1.state
                    inputbox.visible = ch1.state
                end

            local ch2 = checks:attach(gui.Checkbox(10, 28, 15, 'show text', true))
                ch2.onclick.any = function() textbax.visible = ch2.state end
    
            local ch3 = checks:attach(gui.Checkbox(10, 50, 15, 'show license', true))
                ch3.onclick.any = function() license.visible = ch3.state end
end


function love.draw()
    lg.clear(gui.RGBA(gui.theme.color.secondary))
    window:draw()
end

function love.update(dt)
    window:event{['delta']={dt}}
end
    
function love.textinput(text)
    window:event{['textinput']={text}}
end

function love.keypressed(key)
    window:event{['keypress']={key}}
end

function love.mousepressed(x, y, button, istouch)
    window:event{['mousepress']={x, y, button, istouch}}
end

function love.mousereleased(x, y, button, istouch)
    window:event{['mouserelease']={x, y, button, istouch}}
end

function love.wheelmoved(x, y)
    window:event{['wheelmove']={x, y}}
end

function love.mousemoved(x, y)
    window:event{['mousemove']={x, y}}
end
