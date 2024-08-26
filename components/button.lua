local component = require 'badar'

-- https://github.com/s-walrus/hex2color/blob/master/hex2color.lua
local function Hex(hex, value)
    return {
        tonumber(string.sub(hex, 2, 3), 16) / 256,
        tonumber(string.sub(hex, 4, 5), 16) / 256,
        tonumber(string.sub(hex, 6, 7), 16) / 256,
        value or 1 }
end

return function(options)
    local _font = options.font or love.graphics.getFont()

    local style = options.style or {
        disabledColor = { 1, 1, 1 },
        padding = { top = 8, right = 12, left = 12, bottom = 8 },
        backgroundColor = Hex('#dc2626'),
        cornerRadius = 4,
        hoverColor = Hex('#dc2626'),
        textColor = Hex("#ffffff"),
        iconColor = Hex("#ffffff"),
        borderColor = { 1, 1, 1 },
        borderWidth = 0,
        border = false
    }

    return component {
        text = options.text,
        icon = options.icon or nil,
        opacity = options.opacity or 1,
        --
        onClick = options.onClick,
        onHover = options.onHover,
        disabled = options.disabled or false,
        --
        width = options.width or _font:getWidth(options.text) + style.padding.left + style.padding.right,
        height = options.height or _font:getHeight(options.text) + style.padding.top + style.padding.bottom,
        font = _font,
        --
        draw = function(self)
            love.graphics.setFont(_font)
            -- border
            if style.border then
                love.graphics.setColor(style.borderColor)
                love.graphics.setLineWidth(style.borderWidth or 0)
                love.graphics.rectangle('line', self.x, self.y, self.width, self.height, style.cornerRadius)
                love.graphics.setColor({ 0, 0, 0 })
            end
            --
            love.graphics.setColor({
                style.backgroundColor[1],
                style.backgroundColor[2],
                style.backgroundColor[3],
                self.opacity })
            -- hover logic
            if self:isMouseInside() then
                if type(self.onHover) == "function" and self.hoverCalled == false then
                    --*  onHover return a 'clean up' callback
                    self.onMouseExit = self.onHover(self)
                    self.hoverCalled = true
                end
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
                love.graphics.setColor(style.hoverColor)
                self.hovered = true
            elseif self.hovered then
                love.mouse.setCursor()
                if self.onMouseExit then
                    self.onMouseExit()
                end
                self.hovered = false
                self.hoverCalled = false
            end
            -- icon
            if self.icon ~= nil then
                love.graphics.draw(self.icon)
            end
            --
            love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, style.cornerRadius)
            love.graphics.setColor(style.textColor)
            love.graphics.printf(self.text, self.x + style.padding.left, self.y + style.padding.top,
                self.width - style.padding.left - style.padding.right, 'center')
            love.graphics.setColor({ 1, 1, 1 })
        end
    }
end
