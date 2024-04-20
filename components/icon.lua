local badar = require 'badar'
icon = badar:extend()

function icon:new(fileName, obj)
    obj = obj or {}
    icon.super.new(self, obj)
    self.fileName = love.graphics.newImage(fileName)
    self.scale = obj.scale or 1
    self.width = self.fileName:getWidth() * self.scale
    self.height = self.fileName:getHeight() * self.scale
    self.autoLayout = { x = false, y = false }
    self._tint = obj.tint or false
    self.drawFunc = function()
        if self._tint then
            --   love.graphics.setColor(1, 0, 0, 1)
        end
        love.graphics.draw(self.fileName, self.x, self.y, 0, self.scale, self.scale)
    end

    return self
end

return icon
