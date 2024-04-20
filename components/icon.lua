local badar = require 'badar'
icon = badar:extend()

function icon:new(fileName, obj)
    obj = obj or {}
    icon.super.new(self, obj)
    local iconStyle = {
        tint = false,
        scale = 1,
    }
    extend(self._style, iconStyle)
    local horizontalPadding = self._style.padding[4] + self._style.padding[2]
    local verticalPadding = self._style.padding[1] + self._style.padding[3]
    self.image = love.graphics.newImage(fileName)
    self.width = (self.image:getWidth() * self._style.scale) + horizontalPadding
    self.height = (self.image:getHeight() * self._style.scale) + verticalPadding

    self.drawFunc = function()
        if self._style.tint then
            love.graphics.setColor({
                self._style.color[1],
                self._style.color[2],
                self._style.color[3],
                self._style.opacity
            })
        end

        love.graphics.draw(
            self.image,
            self.x + self._style.padding[4],
            self.y + self._style.padding[1],
            0,
            self._style.scale,
            self._style.scale
        )
    end

    return self
end

-- Copyright (c) 2020 rxi
function extend(t, ...)
    for i = 1, select("#", ...) do
        local x = select(i, ...)
        if x then
            for k, v in pairs(x) do
                t[k] = v
            end
        end
    end
    return t
end

return icon
