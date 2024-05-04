local container = require 'badar'

-- https://github.com/s-walrus/hex2color/blob/master/hex2color.lua
function Hex(hex, value)
    return {
        tonumber(string.sub(hex, 2, 3), 16) / 256,
        tonumber(string.sub(hex, 4, 5), 16) / 256,
        tonumber(string.sub(hex, 6, 7), 16) / 256,
        value or 1 }
end

local styles = {
    primary = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#00000'),
        corner = 4,
        textColor = Hex("#ffffff"),
        iconColor = Hex("#ffffff"),
    },
    secondary = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#f4f4f5'),
        textColor = Hex("#000000"),
        iconColor = Hex("#000000"),
        corner = 4,
    },
    destructive = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#dc2626'),
        hoverColor = Hex('#df3b3b'),
        textColor = Hex("#ffffff"),
        iconColor = Hex("#ffffff"),
        corner = 4,
    },
    outline = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#ffffff'),
        hoverColor = Hex('#f5f5f5'),
        borderColor = Hex('#e5e5e5'),
        borderWidth = 2,
        textColor = Hex('#000000'),
        iconColor = Hex('#000000'),
        corner = 4,
    },
    icon = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#ffffff'),
        hoverColor = Hex('#f5f5f5'),
        borderColor = Hex('#e5e5e5'),
        borderWidth = 2,
        textColor = Hex('#000000'),
        iconColor = Hex('#000000'),
        corner = 4,
    },
    ghost = {
        opacity = 0,
        padding = { 8, 12, 8, 12 },
        hoverColor = Hex('#e5e5e5'),
        textColor = Hex("#000000"),
        iconColor = Hex("#000000"),
        corner = 4,

    },
    disabled = {
        padding = { 8, 12, 8, 12 },
        color = Hex('#e4e4e7'),
        textColor = Hex('#ffffff'),
        iconColor = Hex('#ffffff'),
        corner = 4,
    }
}
local button = function(txt, options)
    options = options or {}

    local layout = {
        direction = 'row',
        alignment = 'center',
        gap = 4,
    }
    local content = {
        text(txt):style({ color = styles[options.variant or 'primary'].textColor })
    }
    if options.icon then
        table.insert(content, icon(options.icon):style({
            color = styles[options.variant or 'primary'].iconColor
        }))
    end

    if txt == '' then
        content = {
            icon(options.icon):style({
                color = styles[options.variant or 'primary'].iconColor
            })
        }
        layout = { centered = true }
    end
    local props = {}
    for key, value in pairs(options) do
        props[key] = value
    end


    return container(props)
        :content(content)
        :style(styles[options.variant or 'primary'])
        :layout(layout)
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
                    i:style({ opacity = 1 })
                end
            end,
            onExit = function(i)
                love.mouse.setCursor()
                if options.variant == 'ghost' then
                    i:style({ opacity = 0 })
                end
            end
        })
end



return button
