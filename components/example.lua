local component = require 'badar'
local signal    = require 'components.signal'
local label     = require 'components.label'
local button    = require 'components.button'

-- Copy to your main.lua file

-- Define your component
local menu      = component {
    column = true,
    gap = 4,
    x = 10,
    y = 10,
    draw = function(self)
        for _, child in ipairs(self.children) do
            love.graphics.push()
            love.graphics.translate(self.x or 0, self.y or 0)

            --! Draw all the children
            if child.draw then
                child:draw()
            end
            love.graphics.pop()
        end
    end
}

function love.load()
    love.graphics.setBackgroundColor({ 1, 1, 1 })
    local counter = label('0')
    menu = menu
        + counter
        + label { text = 'Doubled: 0', id = 'awesome' }
        + label 'Hello, World!'
        + button {
            text = 'Click me!',
            onClick = function(self)
                counter.text = counter.text + 1
                -- get child by id
                (self.parent % 'awesome').text = 'Doubled: ' .. counter.text * 2
            end
        }
end

function love.draw()
    menu:draw()
end

function love.mousepressed(x, y, btn, isTouch, presses)
    signal.click:emit(btn)
end
