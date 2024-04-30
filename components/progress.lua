local container = require 'badar'
local flux = require 'libs.flux'

local progress = function(options)
    options = options or {}
    local track = container({
            width = options.value or 0,
            height = 8,
            id = 'track'
        })
        :style({
            color = options.trackColor or { 0, 0, 0 },
            corner = 4,
            visible = false
        })

    if options.value then track:style({ visible = true }) end

    local props = {
        width = options.width or 100,
        height = 8,
        value = options.value or 0
    }
    for key, value in pairs(options) do
        props[key] = value
    end

    local output = container(props)
        :content({ track })
        :style({
            color = options.backgroundColor or { 0.89453125, 0.89453125, 0.89453125, 1 },
            filled = true,
            corner = 4
        })

    output.setValue = function(_s, value)
        local t = output:find('track'):style({ visible = true })
        local nextValue = math.min(value, output.width)
        flux.to(t, 0.8, { width = nextValue }):ease('quartout')
        output.value = nextValue
        return output
    end

    return output
end

return progress
