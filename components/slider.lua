local container = require 'badar'

local slider = function(options)
    options = options or {};

    local self = container(table.spread({
        id = options.id or 'sliderDefault',
        width = options.width or 200,
        height = 6
    }, options))
    local isPressed = false

    local styles = {
        container = {
            corner = 3,
            color = { 0.89453125, 0.89453125, 0.89453125, 1 },
            filled = true,
        },
        track = {
            color = options.trackColor or { 0, 0, 0 },
            filled = true,
            corner = 3,
            visible = false,
        },
        handler = {
            corner = 8,
            color = { 1, 1, 1 },
            filled = true,
            borderColor = Hex('#4b5563'),
            borderWidth = 1
        }
    }
    local props = {
        track = {
            width = options.value or 0,
            height = 8,
            id = 'track'
        },
        handler = {
            id = 'handler',
            width = 16,
            height = 16,
            x = options.defaultValue or 0
        }
    }

    local track = container(props.track).style(styles.track)
    if options.value then track.style({ visible = true }) end

    local handler = container(props.handler)
        .style(styles.handler)
        .onClick(function() isPressed = true end)
        .onMouseRelease(function() isPressed = false end)

    local handleEvent = function(ii)
        local _handler = ii.find('handler')
        local _track = ii.find('track')

        local step = options.step or 1
        local mousePosition = love.mouse.getX() - ii.globalPosition.x
        local maxValue = math.max(0, math.min(math.floor(mousePosition / step) * step, ii.width))

        _handler.x = math.max(0, maxValue) - _handler.width
        if _handler.x < 0 then
            _handler.x = 0
        end
        _track.style({ visible = true }).width = _handler.x + _handler.width
        if ii.onValuechange_function then
            ii.onValuechange_function(maxValue)
        end
    end

    self.onValueChange = function(func)
        self.onValuechange_function = func
        return self
    end
    self
    .style(styles.container)
    .content({ track, handler }, { alignment = 'center' })
    .find('handler').x = self.x
    self
        .onUpdate(function(i)
            if isPressed then handleEvent(i) end
        end)
        .onClick(function(i) handleEvent(i) end)
        .onHover({
            onEnter = function()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end,
            onExit = function()
                love.mouse.setCursor()
            end
        })


    return container({ width = self.width, height = 25 })
        .content({ self }, { alignment = 'center' })
        .style({ opacity = 0 })
end

return slider
