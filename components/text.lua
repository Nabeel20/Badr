local container = require 'badar'

local text = function(txt, options)
    local self = container(table.spread({}, options or {}));

    -- override draw function
    ---@diagnostic disable-next-line: duplicate-set-field
    self.drawSelf = function()
        self._style.limit = self.font:getWidth(self.text)
        love.graphics.setFont(self.font)
        self.font:setFilter("nearest", "nearest")
        self.font:setLineHeight(self._style.lineHeight)
        --text
        love.graphics.setColor({
            self._style.color[1],
            self._style.color[2],
            self._style.color[3],
            self._style.opacity
        })
        love.graphics.printf(
            self.text,
            self.x + self._style.padding[4],
            self.y + self._style.padding[1],
            self._style.limit,
            self._style.alignment
        )
    end

    -- expand styles
    self._style = table.spread(self._style, {
        color = { 0, 0, 0 }, -- default is black
        size = 14,
        lineHeight = 1,
        alignment = 'left',
        fontFamily = 'assets/Poppins-Regular.ttf',
        limit = 1000,
    })
    if self._style.fontFamily then
        self.font = love.graphics.newFont(self._style.fontFamily, self._style.size)
    else
        self.font = love.graphics.newFont(self._style.size)
    end

    self.text = txt;
    local padding = {
        horizontal = self._style.padding[2] + self._style.padding[4],
        vertical = self._style.padding[1] + self._style.padding[3],
    }

    self.width = self.font:getWidth(self.text) + padding.horizontal
    self.height = self.font:getHeight(self.text) + padding.vertical

    -- override style function
    ---@diagnostic disable-next-line: duplicate-set-field
    self.style = function(style)
        for key, value in pairs(style) do
            self._style[key] = value
        end
        if self._style.fontFamily then
            self.font = love.graphics.newFont(self._style.fontFamily, self._style.size)
        else
            self.font = love.graphics.newFont(self._style.size)
        end
        self.width = self.font:getWidth(self.text) + padding.horizontal
        self.height = self.font:getHeight(self.text) + padding.vertical
        return self
    end
    return self
end

return text
