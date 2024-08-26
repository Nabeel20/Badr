local component = require 'badar'
local menu      = component {
    column = true,
    gap = 4,
    x = 10,
    y = 10,
    draw = function(self)
        for _, child in ipairs(self.children) do
            love.graphics.push()
            love.graphics.translate(self.x or 0, self.y or 0)
            love.graphics.scale(self.scaleX or 1, self.scaleY or 1)
            if child.draw then
                child:draw()
            end
            love.graphics.pop()
        end
    end
}

return menu
