local container = require 'badar'
local object = require 'libs.classic'

local slider = function(options)
    options = options or {}
    local isPressed = false
    local handleEvent = function(ii)
        local _handler = ii:find('handler')
        local _track = ii:find('track')

        local step = options.step or 1
        local mousePosition = love.mouse.getX() - ii.globalPosition.x
        local maxValue = math.max(0, math.min(math.floor(mousePosition / step) * step, ii.width))
        _handler.x = math.max(0, maxValue) - _handler.width
        if _handler.x < 0 then
            _handler.x = 0
        end
        _track:style({ visible = true }).width = _handler.x + _handler.width
        if ii._onValueChange then
            ii._onValueChange(maxValue)
        end
    end

    local track = container({
            width = options.defaultValue or 0,
            height = 6,
            id = 'track'
        })
        :style({
            color = options.trackColor or { 0, 0, 0 },
            filled = true,
            corner = 3,
            visible = false,
        })
        :modify(function(o)
            if options.defaultValue then
                o:style({ visible = true })
            end
        end)

    local handler = container({
            id = 'handler',
            width = 16,
            height = 16,
            x = options.defaultValue or 0
        })
        :style({
            corner = 8,
            color = { 1, 1, 1 },
            filled = true,
            borderColor = Hex('#4b5563'),
            borderWidth = 1
        })
        :modify(function(p)
            if options.defaultValue then
                p.x = p.x - 16
            end
        end)
        :onClick(function() isPressed = true end)
        :onMouseRelease(function() isPressed = false end)

    local props = {
        id = options.id or 'sliderDefault',
        width = options.width or 200,
        height = 6
    }
    for key, value in pairs(options) do
        props[key] = value
    end
    local component = container(props)
        :content({ track, handler })
        :style({
            corner = 3,
            color = { 0.89453125, 0.89453125, 0.89453125, 1 },
            filled = true,
        })
        :modify(function(i)
            i.height = 6
            local _handler = i:find("handler")
            _handler.y = (_handler.height - i.height) / 2 * -1
        end)
        :onUpdate(function(ii) if isPressed then handleEvent(ii) end end)
        :onClick(function(ii) handleEvent(ii) end)
        :onHover({
            onEnter = function()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end,
            onExit = function()
                love.mouse.setCursor()
            end
        })
    local _extended = object:extend()
    function _extended:onValueChange(func)
        self._onValueChange = func
        return self
    end

    component:implement(_extended)
    return component
end

return slider
