local container = require 'badar'

local icon = function(image, options)
    local self = container(options or {})

    local padding = {
        horizontal = self._style.padding[4] + self._style.padding[2],
        vertical = self._style.padding[1] + self._style.padding[3]
    }
    if image == nil then
        return self
    end
    self.image = image
    self.width = (self.image:getWidth() * self._style.scale) + padding.horizontal
    self.height = (self.image:getHeight() * self._style.scale) + padding.vertical

    ---@diagnostic disable-next-line: duplicate-set-field
    self.drawSelf = function()
        love.graphics.draw(
            self.image,
            self.x + self._style.padding[4],
            self.y + self._style.padding[1],
            0,
            self._style.scale,
            self._style.scale
        )
    end
    return self;
end

return icon
