local component = require 'badr'

local function label(options)
    local _font = options.font or love.graphics.getFont()

    return component {
        text = options.text or options,
        visible = options.visible or true,
        id = options.id,
        --
        width = _font:getWidth(options.text or options),
        height = _font:getHeight(options.text or options),
        onClick = options.onClick or nil,
        font = _font,
        draw = function(self)
            if not self.visible then return end
            love.graphics.setFont(self.font)
            love.graphics.setColor(options.color or { 0, 0, 0 })
            love.graphics.print(self.text, self.x, self.y)
            love.graphics.setColor({ 1, 1, 1 })
        end,
    }
end

return label
