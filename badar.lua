--
-- badar
--
-- Copyright (c) 2024 Nabeel
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
badar = Object:extend()


function badar:new(obj)
    obj = obj or {}
    self.id = obj.id or 'default id'
    self.x = obj.x or 0
    self.y = obj.y or 0
    self.width = obj.width or 0
    self.height = obj.height or 0
    self.minWidth = obj.minWidth or 0
    self.minHeight = obj.minHeight or 0

    self._style = {
        color = { 1, 1, 1 },
        padding = { 0, 0, 0, 0 }, -- top, right, bottom, left
        hoverEnabled = false,
        corner = 0,
        opacity = 1, -- set to zero to hide border
        filled = false,
    }
    self.gap = 0;
    self.hideBorder = obj.hideBorder or false;
    if self.hideBorder then
        self._style.opacity = 0
    end
    self.hovered = false
    self.globalPosition = { x = 0, y = 0 }

    self.clickFunc = obj.onClick or function() end;
    self.hoverFunc = obj.onHover or function() end;
    self.drawFunc = function()
        local drawMode = (self.hovered and self._style.hoverEnabled) and 'fill' or 'line'
        if (self._style.filled) then drawMode = 'fill' end
        love.graphics.rectangle(
            drawMode,
            self.x,
            self.y,
            self.width,
            self.height,
            self._style.corner,
            self._style.corner
        )
    end
    self.children = obj.children or {}
    return self
end

function badar:draw()
    love.graphics.setColor({ self._style.color[1], self._style.color[2], self._style.color[3], self._style.opacity })
    self.drawFunc()

    if self:isMouseInside() then
        self.hovered = true
        self:hoverFunc()
    else
        self.hovered = false
    end

    return function()
        love.graphics.push()
        love.graphics.translate(math.floor(self.x + self._style.padding[4]), math.floor(self.y + self._style.padding[1]))
        local sW, sH = love.graphics.getWidth(), love.graphics.getHeight()
        self.globalPosition.x, self.globalPosition.y = love.graphics.inverseTransformPoint(sW, sH)
        self.globalPosition.x = sW - self.globalPosition.x
        self.globalPosition.y = sH - self.globalPosition.y

        for _, child in ipairs(self.children) do
            child:draw()()
        end

        love.graphics.pop()
        return self
    end
end

function badar:content(content)
    self.children = content;
    self.width = self:calculateLayout().computedWidth
    self.height = self:calculateLayout().computedHeight
    return self;
end

function badar:onHover(func)
    self.hoverFunc = func
    return self
end

function badar:handleClick(btn)
    if self:isMouseInside() then
        self:clickFunc()
        self.hovered = true
    else
        self.hovered = false
    end
end

function badar:onClick(func)
    self.clickFunc = func
    self._style.hoverEnabled = true
    return self
end

function badar:getRect()
    return {
        self.globalPosition.x - self._style.padding[4],
        self.globalPosition.y - self._style.padding[1],
        self.globalPosition.x + self.width - self._style.padding[2],
        self.globalPosition.y + self.height - self._style.padding[3]
    }
end

function badar:render()
    return self:draw()()
end

function badar:update(func)
    func(self)
    return self
end

function badar:isMouseInside()
    local px, py = love.mouse.getX(), love.mouse.getY()
    local rect = self:getRect()

    local rx1, ry1, rx2, ry2 = rect[1], rect[2], rect[3], rect[4]
    return px >= rx1 and px <= rx2 and py >= ry1 and py <= ry2
end

function badar:mousepressed(button)
    self:handleClick(button)
    for _, child in ipairs(self.children) do
        child:mousepressed(button)
    end
end

function badar:align(axis, gap, alignment)
    self.axis = axis or 'row'
    self.gap = gap or 0;
    self.alignment = alignment or nil;
    self:calculateLayout()
    local offset = 0;
    local highest = 0
    local widest = 0
    if #self.children == 0 then return self end

    for _, child in ipairs(self.children) do
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end

    for _, child in ipairs(self.children) do
        if axis == 'center' then
            child.x = (self.width - child.width) / 2 - self._style.padding[4] - self._style.padding[2]
            child.y = (self.height - child.height) / 2 - self._style.padding[1] - self._style.padding[3]
        end
        if axis == 'row' then
            child.x = offset;
            offset = offset + child.width + self.gap
            -- alignment
            if child.height ~= highest then
                if self.alignment == 'center' then
                    child.y = (highest - child.height) / 2
                end
                if self.alignment == 'end' then
                    child.y = highest - child.height
                end
            end
        end
        if axis == 'column' then
            child.y = offset;
            offset = offset + child.height + self.gap
            --alignment
            if child.width ~= widest then
                if self.alignment == 'center' then
                    child.x = (widest - child.width) / 2
                end
                if self.alignment == 'end' then
                    child.x = widest - child.width
                end
            end
        end
    end

    if self.axis == 'row' then
        self.height = math.max(highest + self._style.padding[1] + self._style.padding[3], self.minHeight)
    end
    if self.axis == 'column' then
        self.width = math.max(widest + self._style.padding[4] + self._style.padding[2], self.minWidth)
    end
    return self
end

function badar:calculateLayout()
    local totalWidth, totalHeight, widest, highest = 0, 0, 0, 0
    for _, child in ipairs(self.children) do
        totalWidth = totalWidth + child.width;
        totalHeight = totalHeight + child.height
        highest = math.max(child.height, highest)
        widest = math.max(child.width, widest)
    end

    local hPadding = self._style.padding[4] + self._style.padding[2]
    local vPadding = self._style.padding[1] + self._style.padding[3]
    local gap = self.gap * (#self.children - 1)

    -- Comparing calculated dimensions with minimum dimensions
    -- Then comparing that value with the provided width or height
    local minimumWidth = math.max(totalWidth + hPadding + gap, self.minWidth)
    local minimumHeight = math.max(totalHeight + hPadding + gap, self.minHeight)

    local contentWidth = totalWidth + hPadding + gap;
    local contentHeight = totalHeight + vPadding + gap
    return {
        highest = highest,
        widest = widest,
        padding = {
            horizontal = hPadding,
            vertical = vPadding
        },
        gap = gap,
        contentWidth = contentWidth,
        contentHeight = contentHeight,
        computedWidth = math.max(minimumWidth, self.width),
        computedHeight = math.max(minimumHeight, self.height)
    }
end

function badar:style(style)
    for key, value in pairs(style) do
        self._style[key] = value
    end
    self:calculateLayout()
    return self
end

function badar:find(target)
    if self == nil then
        return nil
    end

    if self.id == target then
        return self
    end

    for i, child in ipairs(self.children or {}) do
        local result = child:find(target)
        if result ~= nil then
            return result
        end
    end

    return nil
end

return badar
