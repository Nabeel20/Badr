local container = require 'badar'
local text = require 'components.text'
local icon = require 'components.icon'


-- https://github.com/s-walrus/hex2color/blob/master/hex2color.lua
function Hex(hex, value)
    return {
        tonumber(string.sub(hex, 2, 3), 16) / 256,
        tonumber(string.sub(hex, 4, 5), 16) / 256,
        tonumber(string.sub(hex, 6, 7), 16) / 256,
        value or 1 }
end

local button = function(txt, options)
    options = options or {}
    local styles = {
        primary = {
            padding = { 8, 12, 8, 12 },
            color = Hex('#00000'),
            hoverColor = Hex('#2f2f31'),
            corner = 4,
            textColor = Hex("#ffffff"),
            iconColor = Hex("#ffffff"),
        },
        secondary = {
            padding = { 8, 12, 8, 12 },
            corner = 4,
            color = Hex('#f4f4f5'),
            textColor = Hex("#000000"),
            iconColor = Hex("#000000"),
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
    local layout = {
        centered = true
    }
    local buttonText = text(txt).style({ color = styles[options.variant or 'primary'].textColor, size = 15 })
    local buttonIcon = {};

    local content = {
        buttonText
    }
    if options.icon then
        buttonIcon = icon(options.icon).style({
            color = styles[options.variant or 'primary'].iconColor
        })
        table.insert(content, buttonIcon)
        layout = {
            direction = 'row',
            alignment = 'center',
            gap = 4,
        }
    end

    if txt == '' then
        table.remove(content, 1)
        styles[options.variant or 'primary'].padding = { 8, 8, 8, 8 }
        layout = { centered = true }
        buttonText.width = 0
        buttonText.height = 0
    end

    return container(table.spread({
            width = buttonText.width + (buttonIcon.width or 0),
            height = buttonText.height + (buttonIcon.height or 0)
        }, options or {}))
        .style(table.spread(styles[options.variant or 'primary'], options or {}))
        .content(content, layout)
        .onHover({
            onEnter = function(i)
                if options.disabled then
                    love.mouse.setCursor(love.mouse.getSystemCursor('no'))
                else
                    local _cursor = 'hand'
                    if options.loading then _cursor = 'wait' end
                    love.mouse.setCursor(love.mouse.getSystemCursor(_cursor))
                end
                if options.variant == 'ghost' then
                    i.style({ opacity = 1 })
                end
            end,
            onExit = function(i)
                love.mouse.setCursor()
                if options.variant == 'ghost' then
                    i.style({ opacity = 0 })
                end
            end
        })
        .onMouseRelease(function()
            love.mouse.setCursor()
        end)
end



return button
