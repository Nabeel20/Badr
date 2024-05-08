local container = require 'badar'
local icon = require 'components.icon'
local text = require 'components.text'
local checkIcon = love.graphics.newImage('assets/check-line.png') -- https://remixicon.com/icon/check-line

local checkbox = function(string, options)
    options = options or {}
    if options.disabled then options.color = Hex('#525252') end
    local self = container(options or {})

    local box = container({
            width = 16,
            height = 16,
            id = 'box'
        })
        .style({
            borderWidth = 1,
            corner = 4,
            opacity = 0,
            color = options.color or { 0, 0, 0 },
            borderColor = options.color or { 0, 0, 0 },
        })
        .content({ icon(checkIcon, { id = 'icon' }).style({ opacity = 0 }) })

    if options.value then
        box.style({ opacity = 1 }).find('icon').style({ opacity = 1 })
    end

    self.onValueChange = function(func)
        self._onValueChange = func
        return self
    end
    local checkboxText = text(string).style({ color = options.color, size = options.size or 16 })
    self.width         = box.width + checkboxText.width;
    self.height        = box.height + checkboxText.height

    self.content({ box, checkboxText },
        {
            direction = 'row',
            alignment = 'center',
            gap = 8
        })
        .style({ opacity = 0 })
        .onClick(function(i)
            if not options.disabled then
                local opacity = 1
                i.value = not i.value

                if i.value then
                    opacity = 1 -- default opacity is 0
                else
                    opacity = 0
                end
                box.style({ opacity = opacity }).find('icon').style({ opacity = opacity })

                if i._onValueChange then
                    i._onValueChange(i.value, string)
                end
            end
        end)
        .onHover({
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

    return self
end

return checkbox
