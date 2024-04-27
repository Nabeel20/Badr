local container = require 'badar'
local flux = require 'libs.flux'
local objcet = require 'libs.classic'


local progress = function(options)
    options = options or {}

    local track = container({
            width = options.value or 0,
            height = 8,
            id = 'track'
        })
        :style({
            color = options.trackColor or { 0, 0, 0 },
            filled = true,
            corner = 4,
            visible = false
        })

    if options.value then track:style({ visible = true }) end

    local output = container({
        width = options.width or 100,
        height = 8,
        id = options.id,
    }):content({
        track
    }):style({
        color = options.backgroundColor or { 0.89453125, 0.89453125, 0.89453125, 1 },
        filled = true,
        corner = 4
    })

    local _extend = objcet:extend()
    function _extend:setValue(value)
        local t = output:find('track'):style({ visible = true })
        local nextValue = math.min(value, output.width)
        flux.to(t, 0.8, { width = nextValue }):ease('quartout')
        output.value = nextValue

        return self
    end

    output.value = 0
    output:implement(_extend)
    return output
end

return progress
