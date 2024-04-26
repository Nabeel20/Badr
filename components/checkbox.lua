local container = require 'badar'

local checkbox = function(string, options)
    options = options or {}
    local _value = options.value or false
    if options.disabled then options.color = Hex('#525252') end
    local box = container({
        width = 16,
        height = 16,
        id = 'box'
    }):style({
        color = options.color or { 0, 0, 0 },
        filled = options.value or false,
        corner = 4
    }):content({
        icon(love.graphics.newImage('assets/check-line.png')) -- https://remixicon.com/icon/check-line
    })
    local output = container({ data = { value = _value } })
        :content({
            box,
            text(string):style({ color = options.color })
        })
        :layout({
            direction = 'row',
            alignment = 'center',
            gap = 8
        })
        :onClick(function(i)
            if not options.disabled then
                local _b = i:find('box')
                i.data.value = not i.data.value
                _b:style({ filled = i.data.value })
                i._onValueChange(i.data.value, string)
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
