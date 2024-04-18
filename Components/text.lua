local badar = require 'badar'
text = badar:extend()

function text:new(txt, obj)
    obj = obj or {}
    text.super.new(self, obj)

    self._text = txt;
    self._color = { 0, 0, 0 }
    self.fontSize = 16
    self.fontName = ''
    if self.fontName ~= '' then
        self.font = love.graphics.newFont(self.fontName, self.fontSize)
    else
        self.font = love.graphics.newFont(self.fontSize)
    end

    self.glyphWidth = 0
    self._lineHeight = 1
    self._limit = self.font:getWidth(self._text)
    self.pressed = false;
    self.selection = {
        start  = 0,
        finish = 0,
        width  = 0,
        height = 0,
    }
    self.width = self.font:getWidth(self._text)
    self.height = self.font:getHeight(self._text)
    self.autoLayout = { x = false, y = false }
    self.alignment = 'left'
    self.drawFunc = function()
        love.graphics.setFont(self.font)
        self.font:setLineHeight(self._lineHeight)

        -- if self.pressed then
        --     self.glyphWidth = self.font:getWidth('c')
        --     local snap = math.floor(love.mouse.getX() / self.glyphWidth) * self.glyphWidth
        --     self.selection.width = self.selection.width + snap

        --     if self.selection.width > self.font:getWidth(self._text) then
        --         self.selection.width = self.font:getWidth(self._text)
        --     end

        --     love.graphics.setColor({ 1, 1, 1 })
        --     love.graphics.rectangle(
        --         'fill',
        --         self.selection.start,
        --         self.y,
        --         self.selection.width - self.selection.start,
        --         self.font:getHeight(self._text))
        -- end

        --text
        love.graphics.setColor({ self._color[1], self._color[2], self._color[3], self.opacity })
        love.graphics.printf(self._text, self.x, self.y, self._limit, self.alignment)
    end

    return self
end

function text:size(number)
    self.fontSize = number
    self.width = self.font:getWidth(self._text)
    self.height = self.font:getHeight(self._text)
    return self
end

function text:getRect()
    return {
        self.globalPosition.x,
        self.globalPosition.y,
        self.globalPosition.x + self.font:getWidth(self._text),
        self.globalPosition.y + self.font:getHeight(self._text)
    }
end

function text:lineHeight(number)
    self._lineHeight = number
    self.width = self.font:getWidth(self._text)
    self.height = self.font:getHeight(self._text)
    return self
end

function text:fontFamily(fontFamily)
    self.font = love.graphics.newFont(fontFamily, self.fontSize)
    return self
end

function text:limit(number)
    self._limit = number
    return self
end

function text:align(alignment)
    self.alignment = alignment
    return self
end

return text
