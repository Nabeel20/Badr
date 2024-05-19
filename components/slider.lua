local container = require 'badar'
local row       = require 'components.row'

local slider    = function(options)
    options = options or {};
    local track = container({ width = options.value or 0, height = 6 })
        .style({ color = options.trackColor or { 0, 0, 0 }, corner = 3, visible = false })
    local handler = container({ y = -4, width = 16, height = 16, corner = 8 }).style({
        corner = 8,
        color = { 1, 1, 1 },
        filled = true,
        borderColor = Hex('#4b5563'),
        borderWidth = 1,
        hoverColor = Hex('#e5e7eb')
    })
    return container(table.spread({
            width = options.width or 200,
            height = 6
        }, options))
        .onHover({
            onEnter = function()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end,
            onExit = function()
                love.mouse.setCursor()
            end
        })
        .style({
            corner = 3,
            color = { 0.89453125, 0.89453125, 0.89453125, 1 }
        })
        .content(function(_slider)
            -- helper function
            _slider.onValueChange = function(func)
                _slider.onValuechange_function = func
                return _slider
            end

            if options.value then track.style({ visible = true }) end
            local handleEvent = function()
                local step = options.step or 1
                local mousePosition = love.mouse.getX() - _slider.globalPosition.x
                local maxValue = math.max(0, math.min(math.floor(mousePosition / step) * step, _slider.width))

                handler.x = math.max(0, maxValue) - handler.width
                if handler.x < 0 then
                    handler.x = 0
                end
                track.style({ visible = true }).width = handler.x + handler.width
                if _slider.onValuechange_function then
                    _slider.onValuechange_function(maxValue)
                end
            end
            _slider.onClick(function() handleEvent() end)
            handler.onClick(function() handleEvent() end)
                .onUpdate(function(i)
                    if i.pressed then handleEvent() end
                end)

            return {
                track,
                handler
            }
        end)
end

return slider
