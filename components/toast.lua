local container = require 'badar'
local text = require 'components.text'
local center = require 'components.center'

local flux = require 'libs.flux'

local toast = function(message, options)
    options = options or {}
    local styles = {
        primary = {
            borderColor = Hex('#d1d5db'),
            borderWidth = 0.1,
            corner = 4,
            padding = { 14, 14, 14, 14 },
            textColor = { 0, 0, 0 },
        },
        destructive = {
            color = Hex('#dc2626'),
            borderWidth = 0,
            padding = { 14, 14, 14, 14 },
            textColor = { 1, 1, 1 },
            corner = 4,
        }
    }
    local selectedStyle = styles[options.variant or 'primary']
    local messageComponent = text(message).style({ color = selectedStyle.textColor })

    return container({ width = messageComponent.width })
        .style(selectedStyle)
        .content(function(i) return { center(messageComponent, i) } end)
        .modify(function(i)
            i.y = love.graphics.getHeight()
            flux.to(i, 0.3, { y = love.graphics.getHeight() - i.height - (options.offset or 14) })
        end)
end
return toast
