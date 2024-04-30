local container = require 'badar'

local button = function(txt, options)
    options = options or {}

    local _style = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#00000'),
        corner = 4,
        textColor = Hex("#ffffff"),
        iconColor = Hex("#ffffff"),
    }
    local _layout = {
        direction = 'row',
        alignment = 'center',
        gap = 4,
    }

    if options.variant == 'secondary' then
        _style.color = Hex('#f4f4f5')
        _style.textColor = Hex("#000000")
        _style.iconColor = Hex("#000000")
    end
    if options.variant == 'destructive' then
        _style.color = Hex('#dc2626')
        _style.hoverColor = Hex('#df3b3b')
        _style.textColor = Hex("#ffffff")
        _style.iconColor = Hex("#ffffff")
    end
    if options.variant == 'outline' or options.variant == 'icon' then
        _style.color = Hex('#ffffff')
        _style.hoverColor = Hex('#f5f5f5')
        _style.borderColor = Hex('#e5e5e5')
        _style.borderWidth = 2
        _style.textColor = Hex('#000000')
        _style.iconColor = Hex('#000000')
    end
    if options.variant == 'ghost' then
        _style.opacity = 0
        _style.hoverColor = Hex('#e5e5e5')
        _style.textColor = Hex("#000000")
        _style.iconColor = Hex("#000000")
    end
    if options.disabled then
        _style.color = Hex('#e4e4e7')
        _style.textColor = Hex('#ffffff')
        _style.iconColor = Hex('#ffffff')
    end


    local _content = {
        text(txt):style({
            color = _style.textColor,
        })
    }

    if options.icon then
        table.insert(_content, icon(options.icon):style({
            color = _style.iconColor
        }))
    end

    if txt == '' then
        _content = {
            icon(options.icon):style({
                color = _style.iconColor
            })
        }
        _layout = { centered = true }
    end
    local props = {}
    for key, value in pairs(options) do
        props[key] = value
    end
    return container(props)
        :content(_content)
        :style(_style)
        :layout(_layout)
        :onHover({
            onEnter = function(i)
                if options.disabled then
                    love.mouse.setCursor(love.mouse.getSystemCursor('no'))
                else
                    local _cursor = 'hand'
                    if options.loading then _cursor = 'wait' end
                    love.mouse.setCursor(love.mouse.getSystemCursor(_cursor))
                end
                if options.variant == 'ghost' then
                    i._style.opacity = 1
                end
            end,
            onExit = function(i)
                love.mouse.setCursor()
                if options.variant == 'ghost' then
                    i._style.opacity = 0
                end
            end
        })
end

-- https://github.com/s-walrus/hex2color/blob/master/hex2color.lua
function Hex(hex, value)
    return {
        tonumber(string.sub(hex, 2, 3), 16) / 256,
        tonumber(string.sub(hex, 4, 5), 16) / 256,
        tonumber(string.sub(hex, 6, 7), 16) / 256,
        value or 1 }
end

return button
