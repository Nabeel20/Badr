local component = require 'badar'
local signal    = require 'components.signal'
local button    = require 'components.button'

-- Copy to your main.lua file

function love.load()
    love.graphics.setBackgroundColor({ 1, 1, 1 })
    local clicks = 0
    local menu = component { column = true, gap = 10 }
        + button {
            text = 'New game',
            width = 200,
            onHover = function()
                print 'mouse entered'
                return function()
                    print('mouse exited')
                end
            end
        }
        + button { text = 'Settings', width = 200 }
        + button { text = 'Credits', width = 200 }
        + button { text = 'Quit', width = 200, onClick = function() love.event.quit() end }
        + button {
            text = 'Clicked: 0',
            width = 200,
            onClick = function(self)
                clicks = clicks + 1
                self.text = 'Clicked: ' .. clicks
            end
        }

    menu.y = love.graphics.getHeight() * 0.5 - menu.height * 0.5
    menu.x = love.graphics.getWidth() * 0.5 - menu.width * 0.5
end

function love.draw()
    signal.draw:emit()
end

function love.mousepressed(x, y, btn, isTouch, presses)
    signal.click:emit(btn)
end
