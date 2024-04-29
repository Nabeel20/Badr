local container = require 'badar'
local checkIcon = love.graphics.newImage('assets/check-line.png') -- https://remixicon.com/icon/check-line

local box = container({
    width = 16,
    height = 16,
    id = 'box'
}):style({
    borderWidth = 1,
    corner = 4,
    opacity = 0
}):content({
    icon(checkIcon, { id = 'icon' }):style({ opacity = 0 })
})


local checkbox = function(string, options)
    options = options or {}
    options.disabled = options.disabled or false
    if options.disabled then options.color = Hex('#525252') end
    box:style({
        color = options.color or { 0, 0, 0 },
        borderColor = options.color or { 0, 0, 0 },
        opacity = 0
    })

    if options.value then
        box:style({ opacity = 1 }):find('icon'):style({ opacity = 1 })
    end
    local output = container({ value = options.value or false })
        :content({
            box,
            text(string):style({ color = options.color })
        })
        :style({ opacity = 0 })
        :layout({
            direction = 'row',
            alignment = 'center',
            gap = 8
        })
        :onClick(function(i)
            print('checkBox clicked', i.value)
            if not options.disabled then
                local opacity = 1
                i.value = not i.value

                if i.value then
                    opacity = 1 -- default opacity is 0
                else
                    opacity = 0
                end
                box:style({ opacity = opacity }):find('icon'):style({ opacity = opacity })

                if i._onValueChange then
                    i._onValueChange(i.value, string)
                end
            end
        end)
        :onHover({
            onEnter = function()
                if options.disabled then
                    love.mouse.setCursor(love.mouse.getSystemCursor('no'))
                else
                    love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
                end
            end,
            onExit = function()
                love.mouse.setCursor()
            end
        })
    local _extended = Object:extend()
    function _extended:onValueChanged(func)
        self._onValueChange = func
        return self
    end

    output:implement(_extended)
    return output
end

return checkbox
