local badar = require 'badar'
icon = badar:extend()

function icon:new(image, obj)
    obj = obj or {}
    icon.super.new(self, obj)
    if type(image) ~= "userdata" then
        print('ERROR. Badar. Missing argument for icon component, no image resource.')
        return self
    end

    local horizontalPadding = self._style.padding[4] + self._style.padding[2]
    local verticalPadding = self._style.padding[1] + self._style.padding[3]

    if type(image) == 'userdata' and image:typeOf('Image') then
        self.image = image
        self.width = (self.image:getWidth() * self._style.scale) + horizontalPadding
        self.height = (self.image:getHeight() * self._style.scale) + verticalPadding

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
    else
        self.drawSelf = function()
        end
    end
    return self
end

return icon
